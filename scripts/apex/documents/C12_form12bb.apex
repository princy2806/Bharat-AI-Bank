// C12: Form 12BB - Investment Declaration (PDF) - All Person Accounts
// Execute: Developer Console > Execute Anonymous
// Doc AI Template: FORM_12BB
// Fields: HRA, LTA, Sec 80C investments, Sec 80D, Home Loan Interest

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
}

List<Account> accs=[SELECT Id,FirstName,LastName,BillingCity,BillingState,AnnualRevenue,Industry FROM Account WHERE IsPersonAccount=true ORDER BY LastName,FirstName];
List<ContentVersion> batch=new List<ContentVersion>();
Integer cnt=0;
for(Account a:accs){
    String nm=(a.FirstName+' '+a.LastName).toUpperCase();
    Integer hv=Math.abs(a.Id.hashCode());
    String city=a.BillingCity!=null?a.BillingCity:'';
    Decimal rev=a.AnnualRevenue!=null?a.AnnualRevenue:600000;
    // HRA calculation
    Integer basicSal=Math.round((Integer)(rev*0.4)/1000)*1000;
    Integer hraDecl=Math.round(basicSal*0.5/1000)*1000;
    Integer actualRent=Math.mod(hv,10000)+10000;
    Integer hraClaimable=Math.min(hraDecl,actualRent*12-Math.round(basicSal*12*0.1/1000)*1000);
    // 80C
    Integer pf=Math.round(basicSal*0.12/1000)*1000;
    Integer lic=Math.mod(hv,50000)+10000;
    Integer elss=Math.mod(hv,60000)+10000;
    Integer ppf=Math.mod(hv,30000);
    Integer total80C=Math.min(150000,pf+lic+elss+ppf);
    // 80D
    Integer healthIns=Math.min(25000,Math.mod(hv,20000)+5000);
    // 24b
    Boolean hasHomeLoan=Math.mod(cnt,3)==0;
    Integer hlInterest=hasHomeLoan?Math.min(200000,Math.mod(hv,180000)+50000):0;
    List<String> lines=new List<String>{
        'FORM 12BB',
        'Statement of Particulars to be Furnished by Employee',
        '(Rule 26C of Income Tax Rules)',
        '================================================================',
        'Financial Year   : 2025-26',
        'Employee Name    : '+nm,
        'Employee PAN     : XXXXX'+String.valueOf(1000+cnt)+'X',
        'Designation      : Senior Executive',
        'City             : '+city,
        '================================================================',
        '1. HOUSE RENT ALLOWANCE (Sec 10(13A)):',
        'Actual HRA Received      : Rs '+String.valueOf(hraDecl),
        'Actual Rent Paid/Month   : Rs '+String.valueOf(actualRent),
        'Landlord Name            : Ramesh Kumar (PAN: XXXXX1234Y)',
        'HRA Exemption Claimed    : Rs '+String.valueOf(Math.max(0,hraClaimable)),
        '================================================================',
        '2. LEAVE TRAVEL ALLOWANCE (Sec 10(5)):',
        'LTA Claimed              : Rs '+String.valueOf(Math.min(30000,Math.mod(hv,25000)+5000)),
        'Travel Details           : Return journey by Air/Train (family)',
        '================================================================',
        '3. DEDUCTIONS UNDER CHAPTER VI-A:',
        '   Sec 80C (Max Rs 1,50,000):',
        '   EPF Contribution        : Rs '+String.valueOf(pf),
        '   LIC Premium             : Rs '+String.valueOf(lic),
        '   ELSS Mutual Fund SIP    : Rs '+String.valueOf(elss),
        '   PPF Deposit             : Rs '+String.valueOf(ppf),
        '   Total 80C Claimed       : Rs '+String.valueOf(total80C),
        '   Sec 80D (Health Ins)    : Rs '+String.valueOf(healthIns),
        '================================================================',
        '4. INTEREST ON HOME LOAN (Sec 24(b)):',
        hasHomeLoan?'Home Loan Interest       : Rs '+String.valueOf(hlInterest):'Not Applicable',
        hasHomeLoan?'Lender: HDFC Bank | Loan A/c: HLXXXXXXXXXX':'',
        '================================================================',
        'I hereby declare that the above information is true and correct.',
        'Employee Signature: ________________  Date: 2026-04-01'
    };
    batch.add(new ContentVersion(
        Title='Form 12BB - '+a.FirstName+' '+a.LastName+' FY2025-26',
        PathOnClient='Form12BB_'+a.FirstName+'_'+a.LastName+'_FY2025-26.pdf',
        FirstPublishLocationId=a.Id,
        VersionData=U.pdf(lines)
    ));
    cnt++;
    if(Math.mod(cnt,25)==0){insert batch;batch.clear();}
}
if(!batch.isEmpty())insert batch;
System.debug('Form 12BB documents inserted: '+cnt);
