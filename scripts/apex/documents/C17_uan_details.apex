// C17: UAN Details / Employment History (PDF) - All Person Accounts
// Execute: Developer Console > Execute Anonymous
// Doc AI Template: UAN_CARD
// Fields: UAN Number, Name, DOB, Employment History, PF Accounts linked

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
    String prevEmployer(String industry){
        Map<String,String> em=new Map<String,String>{
            'Technology'=>'Wipro Technologies Limited','Healthcare'=>'Fortis Healthcare Ltd',
            'Finance'=>'ICICI Securities Limited','Manufacturing'=>'Mahindra & Mahindra Ltd',
            'Retail'=>'Future Group Limited','Education'=>'Pearson India Education',
            'Real Estate'=>'Godrej Properties Limited','Consulting'=>'Ernst & Young LLP'
        };
        if(industry!=null&&em.containsKey(industry))return em.get(industry);
        return 'Previous Employer Private Limited';
    }
    String currEmployer(String industry){
        Map<String,String> em=new Map<String,String>{
            'Technology'=>'Infosys Limited','Healthcare'=>'Apollo Hospitals Pvt Ltd',
            'Finance'=>'HDFC Securities Limited','Manufacturing'=>'Tata Motors Limited',
            'Retail'=>'Reliance Retail Limited','Education'=>'Extramarks Education Pvt Ltd',
            'Real Estate'=>'DLF Home Developers Ltd','Consulting'=>'PricewaterhouseCoopers Pvt Ltd'
        };
        if(industry!=null&&em.containsKey(industry))return em.get(industry);
        return 'Current Employer Private Limited';
    }
}

U u=new U();
List<Account> accs=[SELECT Id,FirstName,LastName,PersonBirthdate,BillingCity,BillingState,AnnualRevenue,Industry FROM Account WHERE IsPersonAccount=true ORDER BY LastName,FirstName];
List<ContentVersion> batch=new List<ContentVersion>();
Integer cnt=0;
for(Account a:accs){
    String nm=(a.FirstName+' '+a.LastName).toUpperCase();
    Integer hv=Math.abs(a.Id.hashCode());
    String city=a.BillingCity!=null?a.BillingCity:'';
    String st2=a.BillingState!=null?a.BillingState:'';
    String industry=a.Industry!=null?a.Industry:'Technology';
    String dob=a.PersonBirthdate!=null?String.valueOf(a.PersonBirthdate):'1985-06-15';
    String uanNum=u.uan(hv);
    Integer serviceYears=3+Math.mod(hv,12);
    String currEmp=u.currEmployer(industry);
    String prevEmp=u.prevEmployer(industry);
    String currJoin=String.valueOf(Date.today().addYears(-serviceYears));
    String prevFrom=String.valueOf(Date.today().addYears(-serviceYears-3));
    String prevTo=String.valueOf(Date.today().addYears(-serviceYears).addDays(-30));
    String pfAccCurr=(city.left(2).toUpperCase())+'CPF'+String.valueOf(10000+Math.mod(hv,89999));
    String pfAccPrev=(city.left(2).toUpperCase())+'PPF'+String.valueOf(20000+Math.mod(hv,79999));
    Decimal rev=a.AnnualRevenue!=null?a.AnnualRevenue:600000;
    Integer basic=Math.round((Integer)(rev/12)*0.4/100)*100;
    Integer pfBalance=(Integer)(basic*0.24*12*serviceYears*1.35); // approx with interest
    List<String> lines=new List<String>{
        'EMPLOYEES PROVIDENT FUND ORGANISATION (EPFO)',
        'UAN - UNIVERSAL ACCOUNT NUMBER DETAILS',
        '================================================================',
        'UAN                      : '+uanNum,
        'Member Name              : '+nm,
        'Date of Birth            : '+dob,
        'Gender                   : '+(new Set<String>{'PRIYA','SUNITA','MEERA','KAVITHA','ANITA','POOJA','NEHA','DEEPA'}.contains(a.FirstName.toUpperCase())?'Female':'Male'),
        'Aadhaar (Seeded)         : YES (UIDAI Verified)',
        'PAN (Seeded)             : YES (IT Dept Verified)',
        'Mobile                   : '+(a.BillingCity!=null?'LINKED':'NOT LINKED'),
        '================================================================',
        'KYC STATUS               : FULLY VERIFIED',
        'Bank Account Linked      : YES (IFSC Verified)',
        '================================================================',
        'EMPLOYMENT HISTORY:',
        '----------------------------------------------------------------',
        'Current Employment:',
        'Establishment Name       : '+currEmp,
        'Date of Joining          : '+currJoin,
        'PF Account No            : '+pfAccCurr,
        'Establishment ID         : EST/'+city.left(3).toUpperCase()+'/'+String.valueOf(10000+Math.mod(hv,89999)),
        'Status                   : ACTIVE',
        '----------------------------------------------------------------',
        'Previous Employment:',
        'Establishment Name       : '+prevEmp,
        'From                     : '+prevFrom,
        'To                       : '+prevTo,
        'PF Account No            : '+pfAccPrev,
        'Transfer Status          : COMPLETED (transferred to current)',
        '================================================================',
        'TOTAL PF BALANCE (approx) : Rs '+String.valueOf(pfBalance),
        'Withdrawal Eligibility    : '+(serviceYears>=5?'ELIGIBLE (5+ years)':'Not eligible yet'),
        '================================================================',
        'Access: www.epfindia.gov.in | Umang App | 1800-118-005',
        'For withdrawal/transfer: epfindia.gov.in/site_en/Claim.php'
    };
    batch.add(new ContentVersion(
        Title='UAN Details - '+a.FirstName+' '+a.LastName,
        PathOnClient='UAN_'+a.FirstName+'_'+a.LastName+'.pdf',
        FirstPublishLocationId=a.Id,
        VersionData=u.pdf(lines)
    ));
    cnt++;
    if(Math.mod(cnt,25)==0){insert batch;batch.clear();}
}
if(!batch.isEmpty())insert batch;
System.debug('UAN details inserted: '+cnt);
