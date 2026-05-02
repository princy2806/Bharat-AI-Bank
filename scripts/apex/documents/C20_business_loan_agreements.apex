// C20: Business Loan Agreements (PDF) - All Person Accounts
// Execute: Developer Console > Execute Anonymous
// Doc AI Template: BUSINESS_LOAN_AGREEMENT
// Fields: Business Name, Loan Amount, Rate, Collateral, GST, Turnover

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
        List<String> banks=new List<String>{'State Bank of India','HDFC Bank Limited',
            'ICICI Bank Limited','Axis Bank Limited','Bank of Baroda',
            'Bajaj Finance Limited','Tata Capital','SIDBI (Small Industries Dev Bank)'};
        return banks[Math.mod(idx,8)];
    }
    String bizType(String industry){
        Map<String,String> bt=new Map<String,String>{
            'Technology'=>'IT Services & Consulting','Healthcare'=>'Medical Clinic & Pharmacy',
            'Retail'=>'Retail Trading Business','Manufacturing'=>'Small Scale Manufacturing',
            'Real Estate'=>'Property Development','Education'=>'Coaching & Training Institute'
        };
        return bt.containsKey(industry)?bt.get(industry):'Trading & Services';
    }
}

U u=new U();
List<Account> accs=[SELECT Id,FirstName,LastName,BillingStreet,BillingCity,BillingState,BillingPostalCode,AnnualRevenue,Industry FROM Account WHERE IsPersonAccount=true ORDER BY LastName,FirstName];
List<ContentVersion> batch=new List<ContentVersion>();
Integer cnt=0;
for(Account a:accs){
    String nm=(a.FirstName+' '+a.LastName).toUpperCase();
    Integer hv=Math.abs(a.Id.hashCode());
    String city=a.BillingCity!=null?a.BillingCity:'';
    String st2=a.BillingState!=null?a.BillingState:'';
    String pin=a.BillingPostalCode!=null?a.BillingPostalCode:'';
    String addr=(a.BillingStreet!=null?a.BillingStreet+', ':'')+city+(st2!=''?', '+st2:'')+(pin!=''?' - '+pin:'');
    Decimal rev=a.AnnualRevenue!=null?a.AnnualRevenue:1000000;
    String industry=a.Industry!=null?a.Industry:'Retail';
    String bizT=u.bizType(industry);
    String bizName=a.LastName+' '+city.left(4)+' Enterprises';
    Integer loanAmt=500000+Math.mod(hv,4500000);
    loanAmt=Math.round(loanAmt/50000)*50000;
    Decimal rate=11.0;
    Integer tenure=84;
    Integer emi=(Integer)(loanAmt*rate/100/12*(1+rate/100/12*tenure)/(((1+rate/100/12*tenure))-1));
    String lndr=u.lender(cnt);
    String loanNo='BL/'+city.left(3).toUpperCase()+'/'+String.valueOf(Date.today().year()-Math.mod(hv,4))+'/'+String.valueOf(300000+Math.mod(hv,699999));
    String agmtDate=String.valueOf(Date.today().addMonths(-(6+Math.mod(hv,48))));
    String gstNo=st2.left(2).toUpperCase()+'XXXXXXX'+String.valueOf(1000+cnt)+'Z';
    Integer turnover=(Integer)(rev*3);
    List<String> lines=new List<String>{
        lndr.toUpperCase(),
        'BUSINESS LOAN AGREEMENT',
        '================================================================',
        'Loan Account No  : '+loanNo,
        'Date of Agreement: '+agmtDate,
        '================================================================',
        'BORROWER (Proprietor/Director):',
        'Name             : '+nm,
        'Address          : '+addr.left(70),
        'PAN (Personal)   : XXXXX'+String.valueOf(1000+cnt)+'X',
        '================================================================',
        'BUSINESS DETAILS:',
        'Business Name    : '+bizName,
        'Business Type    : '+bizT,
        'GST Number       : '+gstNo,
        'Business PAN     : AABXX'+String.valueOf(1000+cnt)+'B',
        'Annual Turnover  : Rs '+String.valueOf(turnover),
        'Years in Business: '+String.valueOf(3+Math.mod(hv,12))+' years',
        '================================================================',
        'LOAN DETAILS:',
        'Loan Type        : Business Term Loan',
        'Loan Amount      : Rs '+String.valueOf(loanAmt),
        'Purpose          : Working capital & business expansion',
        'Interest Rate    : '+String.valueOf(rate)+'% p.a. (Floating)',
        'Tenure           : '+String.valueOf(tenure)+' months (7 years)',
        'EMI              : Rs '+String.valueOf(emi)+' per month',
        'Security/Collatrl: Primary: Hypothecation of business assets',
        '                   Collateral: Personal guarantee of proprietor',
        '================================================================',
        'COVENANTS:',
        'Financial Stmnts : To be submitted annually',
        'Insurance        : Business assets to be insured',
        'Prepayment       : Allowed after 12 months (2% foreclosure fee)',
        '================================================================',
        'Borrower: ________________________ Date: '+agmtDate,
        'Authorized Signatory ('+lndr+'): _______________',
        '================================================================',
        'Loan covered under CGTMSE scheme | Priority Sector Lending'
    };
    batch.add(new ContentVersion(
        Title='Business Loan Agreement - '+a.FirstName+' '+a.LastName,
        PathOnClient='BusinessLoanAgreement_'+a.FirstName+'_'+a.LastName+'.pdf',
        FirstPublishLocationId=a.Id,
        VersionData=u.pdf(lines)
    ));
    cnt++;
    if(Math.mod(cnt,25)==0){insert batch;batch.clear();}
}
if(!batch.isEmpty())insert batch;
System.debug('Business loan agreements inserted: '+cnt);
