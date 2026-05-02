public with sharing class VoterIdPdfService {
    
    // ===== Utility =====
    
    public static String pad(Integer n){
        String s = String.valueOf(n);
        while(s.length() < 10) s = '0' + s;
        return s;
    }
    
    public static String escapePdf(String s){
        return s == null ? '' :
        s.replace('\\','\\\\')
            .replace('(','\\(')
            .replace(')','\\)');
    }
    
    public static Blob generatePdf(List<String> lines){
        
        String content = 'BT /F1 9 Tf 20 820 Td 12 TL\n';
        
        for(String line : lines){
            content += '(' + escapePdf(line.left(85)) + ') Tj T*\n';
        }
        
        content += 'ET';
        
        String header = '%PDF-1.4\n',
            obj1 = '1 0 obj<</Type/Catalog/Pages 2 0 R>>endobj\n',
            obj2 = '2 0 obj<</Type/Pages/Kids[3 0 R]/Count 1>>endobj\n',
            obj3 = '3 0 obj<</Type/Page/MediaBox[0 0 595 842]/Parent 2 0 R/Contents 4 0 R/Resources<</Font<</F1<</Type/Font/Subtype/Type1/BaseFont/Courier>>>>>>endobj\n',
            obj4 = '4 0 obj<</Length ' + content.length() + '>>\nstream\n' + content + '\nendstream\nendobj\n';
        
        Integer p1 = header.length(),
            p2 = p1 + obj1.length(),
            p3 = p2 + obj2.length(),
            p4 = p3 + obj3.length(),
            px = p4 + obj4.length();
        
        String xref = 'xref\n0 5\n0000000000 65535 f \n'
            + pad(p1) + ' 00000 n \n'
            + pad(p2) + ' 00000 n \n'
            + pad(p3) + ' 00000 n \n'
            + pad(p4) + ' 00000 n \n';
        
        String trailer = 'trailer<</Size 5/Root 1 0 R>>\nstartxref\n' + px + '\n%%EOF';
        
        return Blob.valueOf(header + obj1 + obj2 + obj3 + obj4 + xref + trailer);
    }
    
    
    // ===== Business Logic =====
    
    public static String generateEPIC(String state, Integer idx){
        
        Map<String,String> stateCodes = new Map<String,String>{
            'Madhya Pradesh'=>'MPC','Maharashtra'=>'MHC','Delhi'=>'DLC','Rajasthan'=>'RJC',
                'Karnataka'=>'KAC','Gujarat'=>'GJC','Telangana'=>'TLC','Tamil Nadu'=>'TNC',
                'West Bengal'=>'WBC','Uttar Pradesh'=>'UPC','Kerala'=>'KLC','Punjab'=>'PBC',
                'Haryana'=>'HRC','Bihar'=>'BRC','Odisha'=>'ODC','Assam'=>'ASC'
                };
                    
                    String code = stateCodes.containsKey(state) ? stateCodes.get(state) : 'INC';
        Integer h = Math.abs(idx * 7 + 13);
        
        return code + '/' +
            String.valueOf(Math.mod(h,30)+1).leftPad(2,'0') + '/' +
            String.valueOf(Math.mod(h,999)+100) + '/' +
            String.valueOf(100000 + Math.mod(h,899999));
    }
    
    public static String getConstituency(String city){
        
        Map<String,String> cm = new Map<String,String>{
            'Indore'=>'229 - Indore-1','Mumbai'=>'173 - Bandra West','Delhi'=>'048 - Greater Kailash',
                'Jaipur'=>'061 - Sodala','Pune'=>'214 - Shivajinagar','Bengaluru'=>'149 - Indiranagar',
                'Ahmedabad'=>'065 - Navrangpura','Hyderabad'=>'093 - Jubilee Hills',
                'Chennai'=>'038 - Anna Nagar West','Kolkata'=>'025 - Rashbehari',
                'Lucknow'=>'178 - Lucknow Central','Kanpur'=>'155 - Kanpur',
                'Bhopal'=>'150 - Bhopal Central','Nagpur'=>'190 - Nagpur South',
                'Patna'=>'051 - Patna Sahib','Surat'=>'070 - Surat East'
                };
                    
                    return cm.containsKey(city) ? cm.get(city) : '001 - Central';
    }
    
    public static String getGender(String firstName){
        
        Set<String> femaleNames = new Set<String>{
            'PRIYA','SUNITA','MEERA','ANITA','POOJA','NEHA','REKHA','SONIA',
                'NISHA','LATA','SEEMA','DIVYA','RITU','DEVI','LAKSHMI','SAVITA',
                'RADHA','SWATI','ASHA','MAYA','SNEHA','ANJALI','SHRUTI','RADHIKA'
                };
                    
                    return femaleNames.contains(firstName == null ? '' : firstName.toUpperCase())
                    ? 'FEMALE' : 'MALE';
    }
    
    
    // ===== Main Method =====
    
    public static void generateVoterIds(List<Account> accs){
        
        List<ContentVersion> files = new List<ContentVersion>();
        Integer idx = 0;
        
        for(Account a : accs){
            
            String name = (a.FirstName + ' ' + a.LastName).toUpperCase();
            String gender = getGender(a.FirstName);
            String epic = generateEPIC(a.BillingState, idx);
            String constituency = getConstituency(a.BillingCity);
            
            String dob = a.PersonBirthdate != null
                ? String.valueOf(a.PersonBirthdate)
                : '1985-06-15';
            
            String address =
                (a.BillingStreet != null ? a.BillingStreet + ', ' : '') +
                (a.BillingCity != null ? a.BillingCity : '') +
                (a.BillingState != null ? ', ' + a.BillingState : '') +
                (a.BillingPostalCode != null ? ' - ' + a.BillingPostalCode : '');
            
            String relationPrefix = gender == 'FEMALE' ? 'D/O' : 'S/O';
            String relationName = relationPrefix + ' RAMESH ' + a.LastName;
            
            List<String> lines = new List<String>{
                'ELECTION COMMISSION OF INDIA',
                    'ELECTORS PHOTO IDENTITY CARD (EPIC)',
                    '=============================================',
                    'EPIC Number      : ' + epic,
                    'State            : ' + (a.BillingState != null ? a.BillingState : ''),
                    'District         : ' + (a.BillingCity != null ? a.BillingCity : ''),
                    'Assembly         : ' + constituency,
                    '=============================================',
                    'Name             : ' + name,
                    'Relation         : ' + relationName,
                    'Date of Birth    : ' + dob,
                    'Gender           : ' + gender,
                    '=============================================',
                    'Address:',
                    address.left(80),
                    '=============================================',
                    'Issue Date       : 2010-08-20',
                    'Issuing Officer  : District Election Officer'
                    };
                        
                        files.add(new ContentVersion(
                            Title = 'Voter ID - ' + a.FirstName + ' ' + a.LastName,
                            PathOnClient = 'VoterID_' + a.FirstName + '_' + a.LastName + '.pdf',
                            FirstPublishLocationId = a.Id,
                            VersionData = generatePdf(lines)
                        ));
            
            idx++;
        }
        
        if(!files.isEmpty()){
            insert files;
        }
    }
    
}