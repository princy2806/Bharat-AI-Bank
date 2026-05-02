public with sharing class BankAccountPdfService {
    
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
    
    public static String getBank(Integer idx){
        List<String> banks = new List<String>{
            'HDFC Bank','State Bank of India','ICICI Bank','Axis Bank',
                'Kotak Mahindra Bank','Bank of Baroda','Punjab National Bank',
                'Canara Bank','Union Bank of India','IndusInd Bank'
                };
                    return banks[Math.mod(idx, banks.size())];
    }
    
    public static String getIFSC(String bank, Integer idx){
        
        Map<String,String> bankCodes = new Map<String,String>{
            'HDFC Bank'=>'HDFC','State Bank of India'=>'SBIN','ICICI Bank'=>'ICIC',
                'Axis Bank'=>'UTIB','Kotak Mahindra Bank'=>'KKBK','Bank of Baroda'=>'BARB',
                'Punjab National Bank'=>'PUNB','Canara Bank'=>'CNRB','Union Bank of India'=>'UBIN',
                'IndusInd Bank'=>'INDB'
                };
                    
                    String code = bankCodes.containsKey(bank) ? bankCodes.get(bank) : 'HDFC';
        
        return code + '00' + String.valueOf(1000 + Math.mod(idx * 7, 8999));
    }
    
    public static String generateAccountNumber(Id id){
        Long base = 10000000000L + Math.mod(Math.abs(id.hashCode()), 89999999999L);
        return String.valueOf(base).left(12);
    }
    
    
    // ===== Main Method =====
    
    public static void generateBankAccounts(List<Account> accs){
        
        List<ContentVersion> files = new List<ContentVersion>();
        Integer idx = 0;
        
        for(Account a : accs){
            
            String name = (a.FirstName + ' ' + a.LastName).toUpperCase();
            String city = a.BillingCity != null ? a.BillingCity : 'CITY';
            String state = a.BillingState != null ? a.BillingState : '';
            
            String bank = getBank(idx);
            String ifsc = getIFSC(bank, idx);
            String accountNo = generateAccountNumber(a.Id);
            
            Integer hashVal = Math.abs(a.Id.hashCode());
            
            Decimal balance = 50000 + Math.mod(hashVal, 450000);
            String mobile = a.PersonMobilePhone != null ? a.PersonMobilePhone : '9876500000';
            
            List<String> lines = new List<String>{
                bank.toUpperCase(),
                    'SAVINGS ACCOUNT PASSBOOK',
                    '=============================================',
                    'Account Holder   : ' + name,
                    'Account Number   : ' + accountNo,
                    'Account Type     : Savings Account',
                    'IFSC Code        : ' + ifsc,
                    'Branch           : ' + city + ' Main Branch',
                    '=============================================',
                    'KYC STATUS       : COMPLETED',
                    'KYC Mode         : Aadhaar + PAN Verified',
                    'KYC Date         : 2024-03-15',
                    '=============================================',
                    'ACCOUNT SUMMARY:',
                    'Opening Balance  : Rs ' + String.valueOf(balance + 25000),
                    'Total Credits    : Rs ' + String.valueOf(Math.mod(hashVal,200000)+50000),
                    'Total Debits     : Rs ' + String.valueOf(Math.mod(hashVal,150000)+25000),
                    'Current Balance  : Rs ' + String.valueOf(balance),
                    '=============================================',
                    'Mobile Banking   : ENABLED | ' + mobile,
                    'Net Banking      : ENABLED',
                    'Debit Card       : ISSUED'
                    };
                        
                        files.add(new ContentVersion(
                            Title = 'Bank Account - ' + a.FirstName + ' ' + a.LastName,
                            PathOnClient = 'BankAccount_' + a.FirstName + '_' + a.LastName + '.pdf',
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