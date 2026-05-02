// C15: Salary Slips - January 2026 (PDF) - All Person Accounts
// Execute: Developer Console > Execute Anonymous
// Doc AI Template: SALARY_SLIP

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
    String employer(String industry, String city){
        Map<String,String> em=new Map<String,String>{
            'Technology'=>'Infosys Limited','Healthcare'=>'Apollo Hospitals Pvt Ltd',
            'Finance'=>'HDFC Securities Limited','Manufacturing'=>'Tata Motors Limited',
            'Retail'=>'Reliance Retail Limited','Education'=>'Extramarks Education Pvt Ltd',
            'Real Estate'=>'DLF Home Developers Ltd','Consulting'=>'PricewaterhouseCoopers Pvt Ltd',
            'Media'=>'Zee Entertainment Enterprises','Hospitality'=>'ITC Hotels Limited'
        };
        if(industry!=null&&em.containsKey(industry))return em.get(industry);
        return city+' Business Solutions Pvt Ltd';
    }
}

U u=new U();
List<Account> accs=[SELECT Id,FirstName,LastName,BillingCity,AnnualRevenue,Industry FROM Account WHERE IsPersonAccount=true ORDER BY LastName,FirstName];
List<ContentVersion> batch=new List<ContentVersion>();
Integer cnt=0;
for(Account a:accs){
    String nm=(a.FirstName+' '+a.LastName).toUpperCase();
    Integer hv=Math.abs(a.Id.hashCode());
    String city=a.BillingCity!=null?a.BillingCity:'';
    String industry=a.Industry!=null?a.Industry:'Technology';
    Decimal rev=a.AnnualRevenue!=null?a.AnnualRevenue:600000;
    String empName=u.employer(industry,city);
    Integer monthly=(Integer)(rev/12);
    Integer basic=Math.round(monthly*0.4/100)*100;
    Integer hra=Math.round(monthly*0.2/100)*100;
    Integer special=Math.round(monthly*0.2/100)*100;
    Integer lta=Math.round(monthly*0.1/100)*100;
    Integer medical=Math.round(monthly*0.05/100)*100;
    Integer gross=basic+hra+special+lta+medical;
    Integer pf=Math.round(basic*0.12/100)*100;
    Integer profTax=200;
    Integer tds=Math.round(Math.max(0,(Integer)(rev-500000)*0.1/12)/100)*100;
    Integer totalDed=pf+profTax+tds;
    Integer netPay=gross-totalDed;
    String empId='EMP'+city.left(2).toUpperCase()+String.valueOf(10000+Math.mod(hv,89999));
    // January had a bonus for some employees
    Boolean hasBonus=Math.mod(cnt,4)==0;
    Integer bonus=hasBonus?Math.round(monthly*0.5/1000)*1000:0;
    Integer grossWithBonus=gross+bonus;
    Integer netWithBonus=netPay+bonus;
    List<String> lines=new List<String>{
        empName.toUpperCase(),
        'SALARY SLIP - JANUARY 2026',
        '================================================================',
        'Employee ID      : '+empId,
        'Employee Name    : '+nm,
        'Designation      : Senior Executive',
        'Department       : '+industry,
        'Location         : '+city,
        'Working Days     : 31 | Present: 31 | LOP: 0',
        '================================================================',
        'EARNINGS:',
        'Basic Salary         : Rs '+String.valueOf(basic),
        'House Rent Allowance : Rs '+String.valueOf(hra),
        'Special Allowance    : Rs '+String.valueOf(special),
        'Leave Travel Allow   : Rs '+String.valueOf(lta),
        'Medical Allowance    : Rs '+String.valueOf(medical),
        hasBonus?'Performance Bonus    : Rs '+String.valueOf(bonus):'',
        '                       ----------------',
        'GROSS EARNINGS       : Rs '+String.valueOf(grossWithBonus),
        '================================================================',
        'DEDUCTIONS:',
        'Provident Fund (12%) : Rs '+String.valueOf(pf),
        'Professional Tax     : Rs '+String.valueOf(profTax),
        'TDS (Income Tax)     : Rs '+String.valueOf(tds),
        '                       ----------------',
        'TOTAL DEDUCTIONS     : Rs '+String.valueOf(totalDed),
        '================================================================',
        'NET SALARY           : Rs '+String.valueOf(netWithBonus),
        '================================================================',
        'Credited on: 2026-01-31 | Mode: NEFT',
        'This is a computer-generated document. No signature required.'
    };
    batch.add(new ContentVersion(
        Title='Salary Slip - '+a.FirstName+' '+a.LastName+' (Jan 2026)',
        PathOnClient='SalarySlip_'+a.FirstName+'_'+a.LastName+'_Jan2026.pdf',
        FirstPublishLocationId=a.Id,
        VersionData=u.pdf(lines)
    ));
    cnt++;
    if(Math.mod(cnt,25)==0){insert batch;batch.clear();}
}
if(!batch.isEmpty())insert batch;
System.debug('Salary slips (Jan) inserted: '+cnt);
