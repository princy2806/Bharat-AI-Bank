public with sharing class CibilReportPdfService {
    
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
    
    
    // ===== CIBIL Logic =====
    
    public static Integer calculateScore(Integer hashVal, Decimal churn){
        
        Integer base = 750;
        
        if(churn != null){
            if(churn > 80) base = 580 + Math.mod(hashVal, 70);
            else if(churn > 60) base = 640 + Math.mod(hashVal, 60);
            else if(churn > 40) base = 700 + Math.mod(hashVal, 50);
            else base = 760 + Math.mod(hashVal, 60);
        } else {
            base = 720 + Math.mod(hashVal, 80);
        }
        
        return Math.min(900, Math.max(300, base));
    }
    
    public static String getRating(Integer score){
        if(score >= 800) return 'EXCELLENT';
        if(score >= 750) return 'VERY GOOD';
        if(score >= 700) return 'GOOD';
        if(score >= 650) return 'FAIR';
        return 'POOR';
    }
    
    
    // ===== Main Method =====
    
    public static void generateCibilReports(List<Account> accs){
        
        List<ContentVersion> files = new List<ContentVersion>();
        Integer idx = 0;
        
        for(Account a : accs){
            
            String name = (a.FirstName + ' ' + a.LastName).toUpperCase();
            Integer hashVal = Math.abs(a.Id.hashCode());
            
            Decimal churn = a.ChurnRiskScore__c;
            Integer score = calculateScore(hashVal, churn);
            String rating = getRating(score);
            
            String city = a.BillingCity != null ? a.BillingCity : 'CITY';
            
            Integer utilization = 20 + Math.mod(hashVal, 50);
            Integer activeLoans = Math.mod(hashVal, 4) + 1;
            Integer closedLoans = Math.mod(hashVal, 3);
            Integer enquiries = Math.mod(hashVal, 5);
            
            String pan = 'XXXXX' + String.valueOf(1000 + idx) + 'X';
            
            List<String> lines = new List<String>{
                'TRANSUNION CIBIL LIMITED',
                    'CREDIT INFORMATION REPORT',
                    '=============================================',
                    'Report Date      : ' + String.valueOf(Date.today()),
                    'Report Ref No    : CIR/' + Date.today().year() + '/' + String.valueOf(hashVal).left(8),
                    '=============================================',
                    'CONSUMER DETAILS:',
                    'Full Name        : ' + name,
                    'Date of Birth    : ' + (a.PersonBirthdate != null ? String.valueOf(a.PersonBirthdate) : '1985-01-15'),
                    'PAN              : ' + pan,
                    'Address          : ' + city,
                    '=============================================',
                    'CIBIL SCORE      : ' + score + ' / 900',
                    'Rating           : ' + rating,
                    'Score Change     : +' + String.valueOf(Math.mod(hashVal,25)),
                    '=============================================',
                    'CREDIT SUMMARY:',
                    'Active Accounts  : ' + activeLoans,
                    'Closed Accounts  : ' + closedLoans,
                    'Total Accounts   : ' + (activeLoans + closedLoans),
                    'Recent Enquiries : ' + enquiries + ' (6 months)',
                    '=============================================',
                    'PAYMENT HISTORY  : ' + (score >= 750 ? 'EXCELLENT' : 'FAIR'),
                    'CREDIT UTILIZATION: ' + utilization + '%',
                    'CREDIT AGE       : ' + (3 + Math.mod(hashVal,12)) + ' years',
                    '=============================================',
                    'Valid for 30 days | www.cibil.com'
                    };
                        
                        files.add(new ContentVersion(
                            Title = 'CIBIL Report - ' + a.FirstName + ' ' + a.LastName,
                            PathOnClient = 'CIBIL_' + a.FirstName + '_' + a.LastName + '.pdf',
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