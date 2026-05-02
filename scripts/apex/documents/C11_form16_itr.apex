// C11: Form 16 / ITR Acknowledgement (PDF) - All Person Accounts
// Execute: Developer Console > Execute Anonymous
// Doc AI Template: FORM_16
// Fields: Employer, PAN, TAN, Gross Salary, Deductions, TDS, Net Tax

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
    static String employer(String industry, String city){
        Map<String,String> em=new Map<String,String>{
            'Technology'=>'Infosys Limited','Healthcare'=>'Apollo Hospitals Pvt Ltd',
            'Finance'=>'HDFC Bank Limited','Manufacturing'=>'Tata Motors Limited',
            'Retail'=>'Reliance Retail Limited','Education'=>'BYJU\'S Learning Pvt Ltd',
            'Real Estate'=>'DLF Limited','Consulting'=>'Deloitte India Pvt Ltd',
            'Media'=>'Times of India Group','Hospitality'=>'Taj Hotels Limited'
        };
        if(industry!=null&&em.containsKey(industry))return em.get(industry);
        return city+' Enterprises Private Limited';
    }
}

List<Account> accs=[SELECT Id,FirstName,LastName,BillingCity,BillingState,AnnualRevenue,Industry FROM Account WHERE IsPersonAccount=true ORDER BY LastName,FirstName];
List<ContentVersion> batch=new List<ContentVersion>();
Integer cnt=0;
for(Account a:accs){
    String nm=(a.FirstName+' '+a.LastName).toUpperCase();
    Integer hv=Math.abs(a.Id.hashCode());
    String city=a.BillingCity!=null?a.BillingCity:'';
    String industry=a.Industry!=null?a.Industry:'Technology';
    Decimal rev=a.AnnualRevenue!=null?a.AnnualRevenue:600000;
    String empName=U.employer(industry,city);
    String empPAN='AABCE'+String.valueOf(1000+Math.mod(hv,8999))+'F';
    String empTAN=city.left(3).toUpperCase()+'E'+String.valueOf(10000+Math.mod(hv,89999))+'B';
    // Tax computation FY 2025-26
    Integer grossSal=(Integer)rev;
    Integer hra=Math.round(grossSal*0.1/1000)*1000;
    Integer stdDed=50000;
    Integer sec80C=150000;
    Integer sec80D=25000;
    Integer netTaxable=Math.max(0,grossSal-hra-stdDed-sec80C-sec80D);
    Integer tax=0;
    if(netTaxable>1500000)tax=(Integer)((netTaxable-1500000)*0.3+187500);
    else if(netTaxable>1200000)tax=(Integer)((netTaxable-1200000)*0.2+127500);
    else if(netTaxable>900000)tax=(Integer)((netTaxable-900000)*0.15+67500);
    else if(netTaxable>600000)tax=(Integer)((netTaxable-600000)*0.1+22500);
    else if(netTaxable>300000)tax=(Integer)((netTaxable-300000)*0.05);
    Integer cess=(Integer)(tax*0.04);
    Integer totalTax=tax+cess;
    Integer tdsDeducted=totalTax;
    List<String> lines=new List<String>{
        'FORM 16 - CERTIFICATE OF TAX DEDUCTED AT SOURCE',
        'Under Section 203 of Income Tax Act, 1961',
        '================================================================',
        'Financial Year   : 2025-26 (AY 2026-27)',
        '================================================================',
        'PART A: TDS CERTIFICATE',
        'Employer (Deductor)    : '+empName,
        'Employer PAN           : '+empPAN,
        'Employer TAN           : '+empTAN,
        'Employee (Deductee)    : '+nm,
        'Employee PAN           : XXXXX'+String.valueOf(1000+cnt)+'X',
        '================================================================',
        'PART B: COMPUTATION OF INCOME',
        'Gross Salary           : Rs '+String.valueOf(grossSal),
        'Less: HRA Exemption    : Rs '+String.valueOf(hra),
        'Less: Standard Deduct  : Rs '+String.valueOf(stdDed),
        'Gross Total Income     : Rs '+String.valueOf(grossSal-hra-stdDed),
        '----------------------------------------------------------------',
        'DEDUCTIONS (Chapter VI-A):',
        'Sec 80C (PF+LIC+ELSS)  : Rs '+String.valueOf(sec80C),
        'Sec 80D (Health Ins)   : Rs '+String.valueOf(sec80D),
        'Total Deductions       : Rs '+String.valueOf(sec80C+sec80D),
        '----------------------------------------------------------------',
        'Net Taxable Income     : Rs '+String.valueOf(Math.max(0,netTaxable)),
        'Income Tax             : Rs '+String.valueOf(tax),
        'Health & Education Cess: Rs '+String.valueOf(cess),
        'Total Tax Payable      : Rs '+String.valueOf(totalTax),
        'TDS Deducted & Paid    : Rs '+String.valueOf(tdsDeducted),
        '================================================================',
        'Certified that the information given is true and correct.',
        'Authorised Signatory: '+empName,
        'Date: 2026-06-15 | TRACES verified | Form 16 Part A downloaded'
    };
    batch.add(new ContentVersion(
        Title='Form 16 - '+a.FirstName+' '+a.LastName+' FY2025-26',
        PathOnClient='Form16_'+a.FirstName+'_'+a.LastName+'_FY2025-26.pdf',
        FirstPublishLocationId=a.Id,
        VersionData=U.pdf(lines)
    ));
    cnt++;
    if(Math.mod(cnt,25)==0){insert batch;batch.clear();}
}
if(!batch.isEmpty())insert batch;
System.debug('Form 16 documents inserted: '+cnt);
