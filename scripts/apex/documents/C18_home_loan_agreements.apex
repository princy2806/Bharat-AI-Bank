// C18: Home Loan Agreements (PDF) - Accounts with Home Loans
// Execute: Developer Console > Execute Anonymous
// Doc AI Template: HOME_LOAN_AGREEMENT
// Fields: Loan Amount, Property, EMI, Rate, Bank, Registration

class U {
    String p(Integer n){String s=String.valueOf(n);while(s.length()<10)s='0'+s;return s;}
    String e(String s){return s==null?'':s.replace('\\','\\\\').replace('(','\\(').replace(')','\\)');}
    Blob pdf(List<String> L){
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
    String lender(Integer idx){
        List<String> banks=new List<String>{'HDFC Bank Limited','State Bank of India',
            'ICICI Bank Limited','Axis Bank Limited','Kotak Mahindra Bank',
            'LIC Housing Finance Limited','Bajaj Finance Limited','PNB Housing Finance'};
        return banks[Math.mod(idx,8)];
    }
    String propType(Integer idx){
        List<String> types=new List<String>{'2BHK Residential Apartment','3BHK Residential Apartment',
            '4BHK Residential Apartment','2BHK Independent House','3BHK Independent House'};
        return types[Math.mod(idx,5)];
    }
}

U u=new U();
// Process all person accounts - generate home loan agreement for each
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
    Decimal rev=a.AnnualRevenue!=null?a.AnnualRevenue:600000;
    Integer loanAmt=1500000+Math.mod(hv,8500000);
    loanAmt=Math.round(loanAmt/100000)*100000;
    Integer propVal=Math.round(loanAmt*1.35/100000)*100000;
    Decimal rate=8.65;
    Integer tenure=240;
    Integer emi=(Integer)(loanAmt*rate/100/12*(1+rate/100/12*tenure)/(((1+rate/100/12*tenure))-1));
    String lndr=u.lender(cnt);
    String propT=u.propType(cnt);
    String loanNo='HL/'+city.left(3).toUpperCase()+'/'+String.valueOf(Date.today().year()-Math.mod(hv,5))+'/'+String.valueOf(100000+Math.mod(hv,899999));
    String agmtDate=String.valueOf(Date.today().addMonths(-(12+Math.mod(hv,60))));
    Integer stampDuty=(Integer)(propVal*0.06);
    String propAddr=city+' - '+String.valueOf(100+Math.mod(hv,400))+', '+propT;
    List<String> lines=new List<String>{
        lndr.toUpperCase(),
        'HOME LOAN AGREEMENT',
        '================================================================',
        'Loan Account No  : '+loanNo,
        'Agreement Date   : '+agmtDate,
        '================================================================',
        'BORROWER:',
        'Name             : '+nm,
        'Address          : '+addr.left(70),
        'PAN              : XXXXX'+String.valueOf(1000+cnt)+'X',
        'Aadhaar (last 4) : XXXX',
        '================================================================',
        'LENDER:',
        lndr,
        'Registered under RBI as Scheduled Commercial Bank',
        '================================================================',
        'LOAN PARTICULARS:',
        'Loan Type        : Home Loan (Individual)',
        'Sanctioned Amount: Rs '+String.valueOf(loanAmt),
        'Property Value   : Rs '+String.valueOf(propVal),
        'LTV Ratio        : '+String.valueOf(Math.round(loanAmt*100/propVal))+'%',
        'Interest Rate    : '+String.valueOf(rate)+'% p.a. (Floating, Repo-linked)',
        'Tenure           : '+String.valueOf(tenure)+' months (20 years)',
        'EMI Amount       : Rs '+String.valueOf(emi),
        'First EMI Date   : '+String.valueOf(Date.valueOf(agmtDate).addMonths(1)),
        '================================================================',
        'PROPERTY:',
        'Property Type    : '+propT,
        'Property Address : '+propAddr,
        'Registration No  : '+String.valueOf(1000+Math.mod(hv,8999))+'/'+String.valueOf(Date.today().year()-Math.mod(hv,5)),
        'Stamp Duty Paid  : Rs '+String.valueOf(stampDuty),
        'Mortgage         : Equitable Mortgage in favour of '+lndr,
        '================================================================',
        'INSURANCE (mandatory):',
        'Home Loan Protect: Policy No HPP/'+String.valueOf(Date.today().year())+'/'+String.valueOf(10000+Math.mod(hv,89999)),
        'Property Insur   : Policy No HPI/'+String.valueOf(Date.today().year())+'/'+String.valueOf(20000+Math.mod(hv,79999)),
        '================================================================',
        'Borrower Signature: ______________ Date: '+agmtDate,
        'Bank Authorized  : ______________ Seal: '+lndr,
        '================================================================',
        'This agreement is subject to RBI/NHB guidelines. SARFAESI applicable.'
    };
    batch.add(new ContentVersion(
        Title='Home Loan Agreement - '+a.FirstName+' '+a.LastName,
        PathOnClient='HomeLoanAgreement_'+a.FirstName+'_'+a.LastName+'.pdf',
        FirstPublishLocationId=a.Id,
        VersionData=u.pdf(lines)
    ));
    cnt++;
    if(Math.mod(cnt,25)==0){insert batch;batch.clear();}
}
if(!batch.isEmpty())insert batch;
System.debug('Home loan agreements inserted: '+cnt);
