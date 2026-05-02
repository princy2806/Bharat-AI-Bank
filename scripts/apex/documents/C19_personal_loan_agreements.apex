// C19: Personal Loan Agreements (PDF) - All Person Accounts
// Execute: Developer Console > Execute Anonymous
// Doc AI Template: PERSONAL_LOAN_AGREEMENT
// Fields: Loan Amount, Rate, EMI, Purpose, Bank, Repayment Schedule

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
        List<String> banks=new List<String>{'HDFC Bank Limited','ICICI Bank Limited',
            'Axis Bank Limited','Bajaj Finance Limited','Tata Capital Financial Services',
            'Fullerton India Credit Company','Kotak Mahindra Bank','Muthoot Finance'};
        return banks[Math.mod(idx,8)];
    }
    String purpose(Integer idx){
        List<String> purposes=new List<String>{'Medical expenses','Home renovation',
            'Wedding expenses','Travel and vacation','Education fee payment',
            'Debt consolidation','Consumer electronics purchase','Emergency expenses'};
        return purposes[Math.mod(idx,8)];
    }
}

U u=new U();
List<Account> accs=[SELECT Id,FirstName,LastName,BillingStreet,BillingCity,BillingState,BillingPostalCode,AnnualRevenue FROM Account WHERE IsPersonAccount=true ORDER BY LastName,FirstName];
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
    Integer loanAmt=100000+Math.mod(hv,400000);
    loanAmt=Math.round(loanAmt/10000)*10000;
    Decimal rate=12.5;
    Integer tenure=60;
    Integer emi=(Integer)(loanAmt*rate/100/12*(1+rate/100/12*tenure)/(((1+rate/100/12*tenure))-1));
    String lndr=u.lender(cnt);
    String purp=u.purpose(cnt);
    String loanNo='PL/'+city.left(3).toUpperCase()+'/'+String.valueOf(Date.today().year()-Math.mod(hv,3))+'/'+String.valueOf(200000+Math.mod(hv,799999));
    String agmtDate=String.valueOf(Date.today().addMonths(-(6+Math.mod(hv,30))));
    // Repayment schedule (show first 3 + last EMI)
    Decimal outstandingBal=loanAmt;
    Decimal monthlyRate=rate/100/12;
    Integer intComp1=(Integer)(outstandingBal*monthlyRate);
    Integer princComp1=emi-intComp1;
    outstandingBal-=princComp1;
    Integer intComp2=(Integer)(outstandingBal*monthlyRate);
    Integer princComp2=emi-intComp2;
    List<String> lines=new List<String>{
        lndr.toUpperCase(),
        'PERSONAL LOAN AGREEMENT',
        '================================================================',
        'Loan Account No  : '+loanNo,
        'Date of Agreement: '+agmtDate,
        '================================================================',
        'BORROWER DETAILS:',
        'Full Name        : '+nm,
        'Address          : '+addr.left(70),
        'PAN              : XXXXX'+String.valueOf(1000+cnt)+'X',
        'Employer         : Employed (Salaried)',
        'Monthly Income   : Rs '+String.valueOf((Integer)(rev/12)),
        '================================================================',
        'LOAN DETAILS:',
        'Loan Type        : Personal Loan (Unsecured)',
        'Loan Amount      : Rs '+String.valueOf(loanAmt),
        'Purpose          : '+purp,
        'Interest Rate    : '+String.valueOf(rate)+'% p.a. (Fixed)',
        'Tenure           : '+String.valueOf(tenure)+' months',
        'Processing Fee   : Rs '+String.valueOf(Math.round(loanAmt*0.02/100)*100)+' (2% + GST)',
        'EMI Amount       : Rs '+String.valueOf(emi),
        'Total Payment    : Rs '+String.valueOf(emi*tenure),
        'Total Interest   : Rs '+String.valueOf(emi*tenure-loanAmt),
        '================================================================',
        'REPAYMENT SCHEDULE (SAMPLE):',
        'EMI# | EMI Amt | Principal | Interest | Balance',
        '  1  | '+emi+'  | '+princComp1+'  | '+intComp1+'  | '+(Integer)outstandingBal,
        '  2  | '+emi+'  | '+princComp2+'  | '+intComp2+'  | '+((Integer)outstandingBal-princComp2),
        '... ('+tenure+' EMIs total)',
        '================================================================',
        'NACH Mandate     : Auto-debit authorized from savings account',
        'Debit Date       : '+String.valueOf(1+Math.mod(hv,25))+'th of each month',
        'Penal Interest   : 2% p.m. on overdue amount',
        '================================================================',
        'Borrower: ________________________ Date: '+agmtDate,
        'Authorized Signatory ('+lndr+'): _______________',
        'This is a legally binding agreement under Indian Contract Act 1872.'
    };
    batch.add(new ContentVersion(
        Title='Personal Loan Agreement - '+a.FirstName+' '+a.LastName,
        PathOnClient='PersonalLoanAgreement_'+a.FirstName+'_'+a.LastName+'.pdf',
        FirstPublishLocationId=a.Id,
        VersionData=u.pdf(lines)
    ));
    cnt++;
    if(Math.mod(cnt,25)==0){insert batch;batch.clear();}
}
if(!batch.isEmpty())insert batch;
System.debug('Personal loan agreements inserted: '+cnt);
