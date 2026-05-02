// C16: PF / EPF Account Details (PDF) - All Person Accounts
// Execute: Developer Console > Execute Anonymous
// Doc AI Template: PF_STATEMENT
// Fields: UAN, PF Account No, Employer, Employee Contribution, Employer Contribution, Balance

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
    String uan(Integer hv){
        String s=String.valueOf(100000000000L+Math.mod(hv,899999999999L));
        return s.left(12);
    }
    String pfAcc(String city,Integer hv){
        Map<String,String> rc=new Map<String,String>{
            'Indore'=>'MP/IND','Mumbai'=>'MH/MUM','Delhi'=>'DL/DEL','Jaipur'=>'RJ/JAI',
            'Pune'=>'MH/PUN','Bengaluru'=>'KA/BLR','Ahmedabad'=>'GJ/AMD',
            'Hyderabad'=>'TL/HYD','Chennai'=>'TN/CHN','Kolkata'=>'WB/KOL',
            'Lucknow'=>'UP/LKO','Bhopal'=>'MP/BHO','Nagpur'=>'MH/NGP'
        };
        String rc2=rc.containsKey(city)?rc.get(city):'IN/DEL';
        return rc2+'/'+String.valueOf(10000+Math.mod(hv,89999))+'/'+String.valueOf(1+Math.mod(hv,999));
    }
    String employer(String industry, String city){
        Map<String,String> em=new Map<String,String>{
            'Technology'=>'Infosys Limited','Healthcare'=>'Apollo Hospitals Pvt Ltd',
            'Finance'=>'HDFC Securities Limited','Manufacturing'=>'Tata Motors Limited',
            'Retail'=>'Reliance Retail Limited','Education'=>'Extramarks Education Pvt Ltd',
            'Real Estate'=>'DLF Home Developers Ltd','Consulting'=>'PricewaterhouseCoopers Pvt Ltd'
        };
        if(industry!=null&&em.containsKey(industry))return em.get(industry);
        return city+' Business Solutions Pvt Ltd';
    }
}

U u=new U();
List<Account> accs=[SELECT Id,FirstName,LastName,BillingCity,BillingState,AnnualRevenue,Industry FROM Account WHERE IsPersonAccount=true ORDER BY LastName,FirstName];
List<ContentVersion> batch=new List<ContentVersion>();
Integer cnt=0;
for(Account a:accs){
    String nm=(a.FirstName+' '+a.LastName).toUpperCase();
    Integer hv=Math.abs(a.Id.hashCode());
    String city=a.BillingCity!=null?a.BillingCity:'';
    String st2=a.BillingState!=null?a.BillingState:'';
    String industry=a.Industry!=null?a.Industry:'Technology';
    Decimal rev=a.AnnualRevenue!=null?a.AnnualRevenue:600000;
    String empName=u.employer(industry,city);
    Integer monthly=(Integer)(rev/12);
    Integer basic=Math.round(monthly*0.4/100)*100;
    Integer empContr=Math.round(basic*0.12/100)*100;  // Employee: 12% of basic
    Integer emplContr=Math.round(basic*0.12/100)*100; // Employer: 12% of basic
    Integer epsContr=Math.round(basic*0.0833/100)*100; // EPS: 8.33% goes to pension
    Integer epfContr=emplContr-epsContr; // Rest to EPF
    Integer serviceYears=3+Math.mod(hv,12);
    Integer totalEmpContr=empContr*12*serviceYears;
    Integer totalEmplContr=epfContr*12*serviceYears;
    Integer interest=(Integer)((totalEmpContr+totalEmplContr)*0.081*serviceYears/2);
    Integer balance=totalEmpContr+totalEmplContr+interest;
    String uanNum=u.uan(hv);
    String pfAccNo=u.pfAcc(city,hv);
    List<String> lines=new List<String>{
        'EMPLOYEES PROVIDENT FUND ORGANISATION (EPFO)',
        'MINISTRY OF LABOUR & EMPLOYMENT, GOVERNMENT OF INDIA',
        '================================================================',
        'MEMBER PASSBOOK / PF STATEMENT',
        'Period: 01-Apr-2025 to 31-Mar-2026 (FY 2025-26)',
        '================================================================',
        'UAN (Universal Account No): '+uanNum,
        'PF Account Number        : '+pfAccNo,
        'Member Name              : '+nm,
        'Date of Joining          : '+String.valueOf(Date.today().addYears(-serviceYears)),
        '================================================================',
        'EMPLOYER DETAILS:',
        'Employer Name            : '+empName,
        'Establishment Code       : EST/'+city.left(3).toUpperCase()+'/'+String.valueOf(10000+Math.mod(hv,89999)),
        'Region                   : '+city+', '+st2,
        '================================================================',
        'CONTRIBUTION DETAILS (FY 2025-26):',
        'Monthly Basic Salary     : Rs '+String.valueOf(basic),
        'Employee EPF (12%)       : Rs '+String.valueOf(empContr)+'/month',
        'Employer EPF             : Rs '+String.valueOf(epfContr)+'/month',
        'Employer EPS (Pension)   : Rs '+String.valueOf(epsContr)+'/month',
        'Annual Employee Contr    : Rs '+String.valueOf(empContr*12),
        'Annual Employer Contr    : Rs '+String.valueOf(epfContr*12),
        '================================================================',
        'ACCUMULATED BALANCE (as on 31-Mar-2026):',
        'Employee Contribution    : Rs '+String.valueOf(totalEmpContr),
        'Employer Contribution    : Rs '+String.valueOf(totalEmplContr),
        'Interest Earned          : Rs '+String.valueOf(interest),
        'TOTAL EPF BALANCE        : Rs '+String.valueOf(balance),
        'EPS (Pension) Balance    : Rs '+String.valueOf(epsContr*12*serviceYears),
        '================================================================',
        'Interest Rate FY 2025-26 : 8.25% per annum',
        'KYC Status               : VERIFIED (Aadhaar + PAN + Bank linked)',
        '================================================================',
        'EPFO Member Portal: www.epfindia.gov.in | Helpline: 1800-118-005',
        'SMS: EPFOHO UAN ENG to 7738299899 | Umang App available'
    };
    batch.add(new ContentVersion(
        Title='PF/EPF Statement - '+a.FirstName+' '+a.LastName+' FY2025-26',
        PathOnClient='PF_Statement_'+a.FirstName+'_'+a.LastName+'_FY2025-26.pdf',
        FirstPublishLocationId=a.Id,
        VersionData=u.pdf(lines)
    ));
    cnt++;
    if(Math.mod(cnt,25)==0){insert batch;batch.clear();}
}
if(!batch.isEmpty())insert batch;
System.debug('PF statements inserted: '+cnt);
