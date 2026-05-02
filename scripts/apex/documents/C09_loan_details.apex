// C09: Loan Details Summary (PDF) - All Person Accounts
// Execute: Developer Console > Execute Anonymous
// Doc AI Template: LOAN_DETAILS
// Fields: Loan Type, Loan Amount, EMI, Outstanding, Bank, Tenure

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
        List<String> banks=new List<String>{'HDFC Bank','State Bank of India','ICICI Bank',
            'Axis Bank','Kotak Mahindra Bank','Bank of Baroda','Punjab National Bank',
            'LIC Housing Finance','Bajaj Finserv','Tata Capital'};
        return banks[Math.mod(idx,10)];
    }
    static String loanType(Integer idx){
        List<String> types=new List<String>{'Home Loan','Personal Loan','Business Loan',
            'Home Loan','Car Loan','Personal Loan','Home Loan','Education Loan',
            'Business Loan','Home Loan'};
        return types[Math.mod(idx,10)];
    }
}

List<Account> accs=[SELECT Id,FirstName,LastName,BillingCity,BillingState,AnnualRevenue FROM Account WHERE IsPersonAccount=true ORDER BY LastName,FirstName];
List<ContentVersion> batch=new List<ContentVersion>();
Integer cnt=0;
for(Account a:accs){
    String nm=(a.FirstName+' '+a.LastName).toUpperCase();
    Integer hv=Math.abs(a.Id.hashCode());
    String city=a.BillingCity!=null?a.BillingCity:'';
    String lndr=U.lender(cnt);
    String lt=U.loanType(cnt);
    Decimal rev=a.AnnualRevenue!=null?a.AnnualRevenue:500000;
    Integer loanAmt;
    Decimal rate;
    Integer tenureMonths;
    if(lt=='Home Loan'){loanAmt=2000000+Math.mod(hv,8000000);rate=8.65;tenureMonths=240;}
    else if(lt=='Personal Loan'){loanAmt=100000+Math.mod(hv,400000);rate=12.5;tenureMonths=60;}
    else if(lt=='Business Loan'){loanAmt=500000+Math.mod(hv,4500000);rate=11.0;tenureMonths=84;}
    else if(lt=='Car Loan'){loanAmt=400000+Math.mod(hv,800000);rate=9.0;tenureMonths=60;}
    else{loanAmt=500000+Math.mod(hv,2000000);rate=8.5;tenureMonths=120;}
    loanAmt=Math.round(loanAmt/50000)*50000;
    Integer emi=(Integer)(loanAmt*rate/100/12*(1+rate/100/12*tenureMonths)/(((1+rate/100/12*tenureMonths))-1));
    Integer paidMonths=Math.mod(hv,tenureMonths/2)+12;
    Integer outstanding=loanAmt-Math.round((Decimal)loanAmt*paidMonths/tenureMonths/10000)*10000;
    String loanNo='HL/'+String.valueOf(Date.today().year()-Math.mod(hv,5))+'/'+city.left(3).toUpperCase()+'/'+String.valueOf(100000+Math.mod(hv,899999));
    List<String> lines=new List<String>{
        lndr.toUpperCase(),
        'LOAN ACCOUNT STATEMENT',
        '================================================================',
        'Loan Account No  : '+loanNo,
        'Borrower         : '+nm,
        'Loan Type        : '+lt,
        '================================================================',
        'LOAN DETAILS:',
        'Sanctioned Amount: Rs '+String.valueOf(loanAmt),
        'Interest Rate    : '+String.valueOf(rate)+'% p.a. ('+lndr.left(4).toUpperCase()+' MCLR+0.15%)',
        'Tenure           : '+String.valueOf(tenureMonths)+' months',
        'Disbursement Date: '+String.valueOf(Date.today().addMonths(-paidMonths)),
        '================================================================',
        'CURRENT STATUS (as on '+String.valueOf(Date.today())+'):',
        'EMI Amount       : Rs '+String.valueOf(emi),
        'EMIs Paid        : '+String.valueOf(paidMonths)+' of '+String.valueOf(tenureMonths),
        'Principal Paid   : Rs '+String.valueOf(loanAmt-outstanding),
        'Outstanding Amt  : Rs '+String.valueOf(outstanding),
        'Next EMI Date    : '+String.valueOf(Date.today().addDays(10-Math.mod(Date.today().day(),28))),
        '================================================================',
        'PAYMENT STATUS   : REGULAR (No Defaults)',
        'NACH Bank        : '+lndr,
        'NACH Account     : XXXXXX'+String.valueOf(1000+Math.mod(hv,8999)),
        '================================================================',
        'For NOC/Part Payment: '+lndr.toLowerCase().replace(' ','')+'.com',
        'Customer Care    : 1800-XXX-XXXX | Branch: '+city
    };
    batch.add(new ContentVersion(
        Title='Loan Details - '+a.FirstName+' '+a.LastName,
        PathOnClient='LoanDetails_'+a.FirstName+'_'+a.LastName+'.pdf',
        FirstPublishLocationId=a.Id,
        VersionData=U.pdf(lines)
    ));
    cnt++;
    if(Math.mod(cnt,25)==0){insert batch;batch.clear();}
}
if(!batch.isEmpty())insert batch;
System.debug('Loan details inserted: '+cnt);
