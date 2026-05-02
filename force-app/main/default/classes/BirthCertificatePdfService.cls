public with sharing class BirthCertificatePdfService {
    
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
    
    public static String getGender(String firstName){
        
        Set<String> femaleNames = new Set<String>{
            'PRIYA','SUNITA','MEERA','ANITA','POOJA','NEHA','REKHA','SONIA',
                'NISHA','LATA','SEEMA','DIVYA','RITU','DEVI','LAKSHMI','SAVITA',
                'RADHA','SWATI','ASHA','MAYA','SNEHA','ANJALI','SHRUTI','RADHIKA'
                };
                    
                    return femaleNames.contains(firstName == null ? '' : firstName.toUpperCase())
                    ? 'FEMALE' : 'MALE';
    }
    
    public static String getHospital(String city){
        
        Map<String,String> hospitals = new Map<String,String>{
            'Indore'=>'MY Hospital, Indore',
                'Mumbai'=>'Lilavati Hospital, Mumbai',
                'Delhi'=>'AIIMS, New Delhi',
                'Jaipur'=>'SMS Hospital, Jaipur',
                'Pune'=>'Sassoon General Hospital, Pune',
                'Bengaluru'=>'Manipal Hospital, Bengaluru',
                'Ahmedabad'=>'Civil Hospital, Ahmedabad',
                'Hyderabad'=>'Nizam Institute, Hyderabad',
                'Chennai'=>'Government General Hospital, Chennai',
                'Kolkata'=>'SSKM Hospital, Kolkata',
                'Lucknow'=>'KGMU, Lucknow',
                'Bhopal'=>'Hamidia Hospital, Bhopal'
                };
                    
                    return hospitals.containsKey(city)
                    ? hospitals.get(city)
                    : (city != null ? city : 'City') + ' General Hospital';
    }
    
    
    // ===== Main Method =====
    
    public static void generateBirthCertificates(List<Account> accs){
        
        List<ContentVersion> files = new List<ContentVersion>();
        Integer idx = 0;
        
        for(Account a : accs){
            
            String name = (a.FirstName + ' ' + a.LastName).toUpperCase();
            String gender = getGender(a.FirstName);
            
            String dob = a.PersonBirthdate != null
                ? String.valueOf(a.PersonBirthdate)
                : '1985-06-15';
            
            String city = a.BillingCity != null ? a.BillingCity : 'CITY';
            String state = a.BillingState != null ? a.BillingState : 'STATE';
            
            String hospital = getHospital(city);
            
            Integer regNum = 100000 + Math.mod(Math.abs(a.Id.hashCode()), 899999);
            String regYear = a.PersonBirthdate != null
                ? String.valueOf(a.PersonBirthdate.year())
                : '1985';
            
            String fatherName = (gender == 'FEMALE' ? 'MOHAN ' : 'RAMESH ') + a.LastName.toUpperCase();
            String motherName = (gender == 'FEMALE' ? 'KAMLA ' : 'SUSHILA ') + a.LastName.toUpperCase();
            
            String timeOfBirth =
                String.valueOf(Math.mod(Math.abs(a.Id.hashCode()),12)+6) + ':' +
                String.valueOf(Math.mod(Math.abs(a.Id.hashCode()),60)).leftPad(2,'0') + ' HRS';
            
            List<String> lines = new List<String>{
                'GOVERNMENT OF ' + state.toUpperCase(),
                    'MUNICIPAL CORPORATION - BIRTH REGISTRATION',
                    '=============================================',
                    'BIRTH CERTIFICATE',
                    '=============================================',
                    'Registration No   : BC/' + regYear + '/' + city.left(3).toUpperCase() + '/' + regNum,
                    'Date of Issue     : ' + String.valueOf(Date.today().addYears(-2)),
                    '=============================================',
                    'CHILD DETAILS:',
                    'Name              : ' + name,
                    'Date of Birth     : ' + dob,
                    'Time of Birth     : ' + timeOfBirth,
                    'Sex               : ' + gender,
                    'Place of Birth    : ' + hospital,
                    '=============================================',
                    'PARENTS DETAILS:',
                    'Father Name       : ' + fatherName,
                    'Mother Name       : ' + motherName,
                    'Address           : ' + city + ', ' + state,
                    '=============================================',
                    'Certified under Births and Deaths Act, 1969.',
                    'Registrar: Municipal Corporation, ' + city
                    };
                        
                        files.add(new ContentVersion(
                            Title = 'Birth Certificate - ' + a.FirstName + ' ' + a.LastName,
                            PathOnClient = 'BirthCert_' + a.FirstName + '_' + a.LastName + '.pdf',
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