public with sharing class PanCardPdfService {
    
    // ===== Utility Methods =====
    
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
    
    
    // ===== PAN Logic =====
    
    public static String generatePAN(String firstName, String lastName, Integer idx){
        
        String ln = lastName != null ? lastName : 'XXX';
        String fn = firstName != null ? firstName : 'X';
        
        String lp = ln.length() >= 3 ? ln.substring(0,3).toUpperCase() : ln.toUpperCase();
        while(lp.length() < 3) lp += 'X';
        
        String fp = fn.substring(0,1).toUpperCase();
        String num = String.valueOf(1000 + Math.mod(idx, 9000));
        String chk = 'P';
        
        // Format: LLLPPNNNNA
        return lp + fp + chk + num + ln.substring(0,1).toUpperCase();
    }
    
    public static String generateFatherName(String lastName){
        
        Map<String,String> fm = new Map<String,String>{
            'Sharma'=>'Ramesh Sharma','Patel'=>'Suresh Patel','Kumar'=>'Anil Kumar',
                'Singh'=>'Balvir Singh','Devi'=>'Rakesh Kumar','Nair'=>'Krishna Nair',
                'Gupta'=>'Ramesh Gupta','Reddy'=>'Venkatesh Reddy','Verma'=>'Anil Verma',
                'Joshi'=>'Mahesh Joshi','Mishra'=>'Ram Prasad Mishra','Yadav'=>'Ramesh Yadav',
                'Tiwari'=>'Shiv Prasad Tiwari','Pandey'=>'Rajendra Pandey','Shah'=>'Ramesh Shah',
                'Mehta'=>'Suresh Mehta','Iyer'=>'Subramanian Iyer','Pillai'=>'Krishnan Pillai',
                'Menon'=>'Gopalan Menon','Banerjee'=>'Samir Banerjee','Chatterjee'=>'Ashok Chatterjee',
                'Mukherjee'=>'Sanjay Mukherjee','Das'=>'Tarun Das','Bose'=>'Arun Bose',
                'Ghosh'=>'Prasanta Ghosh'
                };
                    
                    return fm.containsKey(lastName) ? fm.get(lastName) : 'Ramesh ' + lastName;
    }
    
    
    // ===== Main Method =====
    
    public static void generatePanForAccounts(List<Account> accs){
        
        List<ContentVersion> files = new List<ContentVersion>();
        Integer idx = 0;
        
        for(Account a : accs){
            
            String name = (a.FirstName + ' ' + a.LastName).toUpperCase();
            String panNo = generatePAN(a.FirstName, a.LastName, idx);
            String father = generateFatherName(a.LastName).toUpperCase();
            
            String dob = a.PersonBirthdate != null
                ? String.valueOf(a.PersonBirthdate)
                : '1985-01-15';
            
            String stateCode = a.BillingState != null
                ? a.BillingState.left(2).toUpperCase()
                : 'IN';
            
            List<String> lines = new List<String>{
                'INCOME TAX DEPARTMENT',
                    'GOVERNMENT OF INDIA',
                    '=============================================',
                    'PERMANENT ACCOUNT NUMBER (PAN) CARD',
                    '=============================================',
                    'PAN Number       : ' + panNo,
                    '=============================================',
                    'Name             : ' + name,
                    'Father Name   : ' + father,
                    'Date of Birth    : ' + dob,
                    '=============================================',
                    'Status           : INDIVIDUAL',
                    'Issuing AO Code  : ' + stateCode + 'C-001',
                    'Jurisdiction     : ' + (a.BillingCity != null ? a.BillingCity : ''),
                    'Issue Date       : 2010-04-15',
                    '=============================================',
                    'This card is issued under Section 139A of IT Act 1961.'
                    };
                        
                        files.add(new ContentVersion(
                            Title = 'PAN Card - ' + a.FirstName + ' ' + a.LastName,
                            PathOnClient = 'PAN_' + a.FirstName + '_' + a.LastName + '.pdf',
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