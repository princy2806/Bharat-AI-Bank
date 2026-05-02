// C10: Loan Agreements (PDF) - All Person Accounts
// Execute: Developer Console > Execute Anonymous
// Doc AI Template: LOAN_AGREEMENT
// Fields: Borrower, Lender, Loan Amount, Terms, Security, Signatures

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
    static String lender(Integer idx){
        List<String> banks=new List<String>{'HDFC Bank Limited','State Bank of India',
            'ICICI Bank Limited','Axis Bank Limited','Kotak Mahindra Bank',
            'Bank of Baroda','Punjab National Bank','LIC Housing Finance Limited',
            'Bajaj Finance Limited','Tata Capital Financial Services'};
        return banks[Math.mod(idx,10)];
    }
}

List<Account> accs=[SELECT Id,FirstName,LastName,PersonBirthdate,BillingStreet,BillingCity,BillingState,BillingPostalCode,AnnualRevenue FROM Account WHERE IsPersonAccount=true ORDER BY LastName,FirstName];
List<ContentVersion> batch=new List<ContentVersion>();
Integer cnt=0;
for(Account a:accs){
    String nm=(a.FirstName+' '+a.LastName).toUpperCase();
    Integer hv=Math.abs(a.Id.hashCode());
    String city=a.BillingCity!=null?a.BillingCity:'';
    String st2=a.BillingState!=null?a.BillingState:'';
    String pin=a.BillingPostalCode!=null?a.BillingPostalCode:'';
    String addr=(a.BillingStreet!=null?a.BillingStreet+', ':'')+city+(st2!=''?', '+st2:'')+(pin!=''?' - '+pin:'');
    String lndr=U.lender(cnt);
    Decimal rev=a.AnnualRevenue!=null?a.AnnualRevenue:500000;
    Integer loanAmt=(Math.mod(cnt,3)==0)?2000000+Math.mod(hv,8000000):(Math.mod(cnt,3)==1)?200000+Math.mod(hv,800000):500000+Math.mod(hv,2000000);
    loanAmt=Math.round(loanAmt/50000)*50000;
    String lt=(Math.mod(cnt,3)==0)?'Home Loan':(Math.mod(cnt,3)==1)?'Personal Loan':'Business Loan';
    Decimal rate=(Math.mod(cnt,3)==0)?8.65:(Math.mod(cnt,3)==1)?12.5:11.0;
    Integer tenure=(Math.mod(cnt,3)==0)?240:(Math.mod(cnt,3)==1)?60:84;
    Integer emi=(Integer)(loanAmt*rate/100/12*(1+rate/100/12*tenure)/(((1+rate/100/12*tenure))-1));
    String agmtDate=String.valueOf(Date.today().addMonths(-(12+Math.mod(hv,48))));
    String loanNo=(Math.mod(cnt,3)==0)?'HL':'PL'+(Math.mod(cnt,3)==1?'':'/BL')+'/'+String.valueOf(Date.today().year()-Math.mod(hv,5))+'/'+String.valueOf(100000+Math.mod(hv,899999));
    List<String> lines=new List<String>{
        lndr.toUpperCase(),
        'LOAN AGREEMENT',
        'Agreement Number: '+loanNo,
        '================================================================',
        'This Agreement is made on '+agmtDate+' between:',
        '',
        'LENDER:',
        lndr,
        'Registered Office: India (RBI Regulated Financial Institution)',
        '',
        'BORROWER:',
        nm,
        'Address: '+addr.left(70),
        'PAN: XXXXX'+String.valueOf(1000+cnt)+'X',
        '================================================================',
        'LOAN PARTICULARS:',
        'Loan Type        : '+lt,
        'Loan Amount      : Rs '+String.valueOf(loanAmt),
        'Purpose          : '+(lt=='Home Loan'?'Purchase of residential property':lt=='Personal Loan'?'Personal use':'Business working capital'),
        'Interest Rate    : '+String.valueOf(rate)+'% p.a. (Floating)',
        'Tenure           : '+String.valueOf(tenure)+' months',
        'EMI              : Rs '+String.valueOf(emi)+' per month',
        'EMI Date         : '+String.valueOf(1+Math.mod(hv,25))+'th of each month',
        '================================================================',
        'SECURITY/COLLATERAL:',
        lt=='Home Loan'?'Mortgage of property as per Schedule A':'Personal guarantee of borrower',
        '================================================================',
        'TERMS: Prepayment allowed. Foreclosure charges: 2% of outstanding.',
        'Default: Penal interest @ 2% p.a. additional on overdue amount.',
        '================================================================',
        'Borrower Signature: ________________ Date: '+agmtDate,
        'Authorized Signatory ('+lndr+'): ________________',
        'Witness 1: ________________ Witness 2: ________________',
        '================================================================',
        'Stamp Duty Paid. Registered as per applicable state laws.'
    };
    batch.add(new ContentVersion(
        Title='Loan Agreement - '+a.FirstName+' '+a.LastName,
        PathOnClient='LoanAgreement_'+a.FirstName+'_'+a.LastName+'.pdf',
        FirstPublishLocationId=a.Id,
        VersionData=U.pdf(lines)
    ));
    cnt++;
    if(Math.mod(cnt,25)==0){insert batch;batch.clear();}
}
if(!batch.isEmpty())insert batch;
System.debug('Loan agreements inserted: '+cnt);
