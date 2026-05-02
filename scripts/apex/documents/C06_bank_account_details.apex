// C06: Bank Account Details / Passbook (PDF) - All Person Accounts
// Execute: Developer Console > Execute Anonymous
// Doc AI Template: BANK_ACCOUNT
// Fields: Account Number, IFSC, Branch, KYC Status, Balance, Account Type

class U {
    static String p(Integer n){String s=String.valueOf(n);while(s.length()<10)s='0'+s;return s;}
    static String e(String s){return s==null?'':s.replace('\\','\\\\').replace('(','\\(').replace(')','\\)');}
    static Blob pdf(List<String> L){
        String st='BT /F1 9 Tf 20 820 Td 12 TL\n';
        for(String l:L)st+='('+e(l.left(85))+') Tj T*\n';
        st+='ET';
        String h='%PDF-1.4\n',
            o1='1 0 obj<</Type/Catalog/Pages 2 0 R>>endobj\n',
            o2='2 0 obj<</Type/Pages/Kids[3 0 R]/Count 1>>endobj\n',
            o3='3 0 obj<</Type/Page/MediaBox[0 0 595 842]/Parent 2 0 R/Contents 4 0 R/Resources<</Font<</F1<</Type/Font/Subtype/Type1/BaseFont/Courier>>>>>>endobj\n',
            o4='4 0 obj<</Length '+st.length()+'>>\nstream\n'+st+'\nendstream\nendobj\n';
        Integer p1=h.length(),p2=p1+o1.length(),p3=p2+o2.length(),p4=p3+o3.length(),px=p4+o4.length();
        String xr='xref\n0 5\n0000000000 65535 f \n'+p(p1)+' 00000 n \n'+p(p2)+' 00000 n \n'+p(p3)+' 00000 n \n'+p(p4)+' 00000 n \n';
        return Blob.valueOf(h+o1+o2+o3+o4+xr+'trailer<</Size 5/Root 1 0 R>>\nstartxref\n'+px+'\n%%EOF');
    }
    static String bank(String city, Integer idx){
        List<String> banks=new List<String>{'HDFC Bank','State Bank of India','ICICI Bank',
            'Axis Bank','Kotak Mahindra Bank','Bank of Baroda','Punjab National Bank',
            'Canara Bank','Union Bank of India','IndusInd Bank'};
        return banks[Math.mod(idx,10)];
    }
    static String ifsc(String bk, String city, Integer idx){
        Map<String,String> bc=new Map<String,String>{
            'HDFC Bank'=>'HDFC','State Bank of India'=>'SBIN','ICICI Bank'=>'ICIC',
            'Axis Bank'=>'UTIB','Kotak Mahindra Bank'=>'KKBK','Bank of Baroda'=>'BARB',
            'Punjab National Bank'=>'PUNB','Canara Bank'=>'CNRB','Union Bank of India'=>'UBIN',
            'IndusInd Bank'=>'INDB'
        };
        String code=bc.containsKey(bk)?bc.get(bk):'HDFC';
        return code+'00'+String.valueOf(1000+Math.mod(idx*7,8999));
    }
    static String accNo(Integer idx){
        String n=String.valueOf(10000000000L+Math.mod(idx*7+3,89999999999L));
        return n.left(12);
    }
}

List<Account> accs=[SELECT Id,FirstName,LastName,PersonBirthdate,BillingCity,BillingState,PersonMobilePhone,AnnualRevenue FROM Account WHERE IsPersonAccount=true ORDER BY LastName,FirstName];
List<ContentVersion> batch=new List<ContentVersion>();
Integer cnt=0;
for(Account a:accs){
    String nm=(a.FirstName+' '+a.LastName).toUpperCase();
    String city=a.BillingCity!=null?a.BillingCity:'';
    String st2=a.BillingState!=null?a.BillingState:'';
    String bk=U.bank(city,cnt);
    String ifscCode=U.ifsc(bk,city,cnt);
    String accNum=U.accNo(Math.abs(a.Id.hashCode()));
    Integer hv=Math.abs(a.Id.hashCode());
    Decimal bal=50000+Math.mod(hv,450000);
    Decimal rev=a.AnnualRevenue!=null?a.AnnualRevenue:500000;
    String mobile=a.PersonMobilePhone!=null?a.PersonMobilePhone:'9876500000';
    List<String> lines=new List<String>{
        bk.toUpperCase(),
        'SAVINGS ACCOUNT - PASSBOOK / STATEMENT',
        '================================================================',
        'Account Holder   : '+nm,
        'Account Number   : '+accNum,
        'Account Type     : Savings Account',
        'IFSC Code        : '+ifscCode,
        'MICR Code        : '+String.valueOf(Math.mod(hv,900000)+100000)+' '+ifscCode.left(4),
        'Branch           : '+city+' Main Branch',
        '================================================================',
        'KYC STATUS       : COMPLETED',
        'KYC Mode         : Aadhaar + PAN Verified',
        'KYC Date         : 2024-03-15',
        'CKYC Number      : '+String.valueOf(10000000+Math.mod(hv,89999999)),
        '================================================================',
        'ACCOUNT SUMMARY (as on '+String.valueOf(Date.today())+'):',
        'Opening Balance  : Rs '+String.valueOf(bal+25000),
        'Total Credits    : Rs '+String.valueOf(Math.mod(hv,200000)+50000),
        'Total Debits     : Rs '+String.valueOf(Math.mod(hv,150000)+25000),
        'Current Balance  : Rs '+String.valueOf(bal),
        '================================================================',
        'NOMINATED         : YES (Nominee registered)',
        'Mobile Banking    : ENABLED | '+mobile,
        'Net Banking       : ENABLED',
        'Debit Card        : ISSUED (Visa Platinum)',
        '================================================================',
        'ANNUAL STATEMENT: Available online | '+bk.toLowerCase().replace(' ','')+'.com',
        'Customer Care    : 1800-XXX-XXXX | Branch: '+city
    };
    batch.add(new ContentVersion(
        Title='Bank Account Details - '+a.FirstName+' '+a.LastName,
        PathOnClient='BankAccount_'+a.FirstName+'_'+a.LastName+'.pdf',
        FirstPublishLocationId=a.Id,
        VersionData=U.pdf(lines)
    ));
    cnt++;
    if(Math.mod(cnt,25)==0){insert batch;batch.clear();}
}
if(!batch.isEmpty())insert batch;
System.debug('Bank account details inserted: '+cnt);
