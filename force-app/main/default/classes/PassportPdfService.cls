public with sharing class PassportPdfService {
    
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
                    ? 'F' : 'M';
    }
    
    public static String getPassportOffice(String city){
        
        Map<String,String> officeMap = new Map<String,String>{
            'Indore'=>'BHOPAL','Mumbai'=>'MUMBAI','Delhi'=>'DELHI','Jaipur'=>'JAIPUR',
                'Pune'=>'PUNE','Bengaluru'=>'BENGALURU','Ahmedabad'=>'AHMEDABAD',
                'Hyderabad'=>'HYDERABAD','Chennai'=>'CHENNAI','Kolkata'=>'KOLKATA',
                'Lucknow'=>'LUCKNOW','Bhopal'=>'BHOPAL','Nagpur'=>'NAGPUR','Patna'=>'PATNA'
                };
                    
                    return officeMap.containsKey(city) ? officeMap.get(city) : 'DELHI';
    }
    
    public static String generatePassportNumber(Id id){
        Integer h = Math.abs(id.hashCode());
        return 'P' + String.valueOf(1000000 + Math.mod(h, 8999999));
    }
    
    public static String generateDate(Integer seed, Integer year){
        return String.valueOf(year) + '-' +
            String.valueOf(Math.mod(seed,12)+1).leftPad(2,'0') +
            '-15';
    }
    
    
    // ===== Main Method =====
    
    public static void generatePassports(List<Account> accs){
        
        List<ContentVersion> files = new List<ContentVersion>();
        
        for(Account a : accs){
            
            String first = a.FirstName != null ? a.FirstName.toUpperCase() : 'NAME';
            String last = a.LastName != null ? a.LastName.toUpperCase() : 'SURNAME';
            
            String name = first + ' ' + last;
            String gender = getGender(a.FirstName);
            
            String dob = a.PersonBirthdate != null
                ? String.valueOf(a.PersonBirthdate)
                : '1985-06-15';
            
            String city = a.BillingCity != null ? a.BillingCity : 'CITY';
            String state = a.BillingState != null ? a.BillingState : 'INDIA';
            
            String office = getPassportOffice(city);
            
            Integer hashVal = Math.abs(a.Id.hashCode());
            
            String passportNo = generatePassportNumber(a.Id);
            String issueDate = generateDate(hashVal, 2020);
            String expiryDate = generateDate(hashVal, 2030);
            
            String fatherName = 'RAMESH ' + last;
            
            String mrz1 = 'P<IND' + last + '<<' + first + '<<<<<<<<<<<<<<<<';
            String mrz2 = passportNo.replace('P','') +
                'IND' +
                dob.replace('-','').mid(2,6) +
                gender +
                expiryDate.replace('-','').mid(2,6) +
                '<<<<<<<<<<<<<2';
            
            List<String> lines = new List<String>{
                'REPUBLIC OF INDIA',
                    'MINISTRY OF EXTERNAL AFFAIRS',
                    '=============================================',
                    'PASSPORT',
                    '=============================================',
                    'Passport No      : ' + passportNo,
                    'Surname          : ' + last,
                    'Given Name(s)    : ' + first,
                    'Nationality      : INDIAN',
                    'Date of Birth    : ' + dob,
                    'Sex              : ' + gender,
                    'Place of Birth   : ' + city + ', ' + state,
                    '=============================================',
                    'Place of Issue   : ' + office,
                    'Date of Issue    : ' + issueDate,
                    'Date of Expiry   : ' + expiryDate,
                    '=============================================',
                    'Father Name   : ' + fatherName,
                    'Address          : ' + city + ', ' + state,
                    '=============================================',
                    'MRZ:',
                    mrz1.left(44),
                    mrz2.left(44)
                    };
                        
                        files.add(new ContentVersion(
                            Title = 'Passport - ' + first + ' ' + last,
                            PathOnClient = 'Passport_' + first + '_' + last + '.pdf',
                            FirstPublishLocationId = a.Id,
                            VersionData = generatePdf(lines)
                        ));
        }
        
        if(!files.isEmpty()){
            insert files;
        }
    }
        
        }