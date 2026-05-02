// C05: Passports (PDF) - All Person Accounts
// Execute: Developer Console > Execute Anonymous
// Doc AI Template: PASSPORT
// Fields: Name, DOB, Gender, Passport Number, Place of Issue, Validity

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
    static String gen(String fn){
        Set<String> fem=new Set<String>{'PRIYA','SUNITA','MEERA','KAVITHA','ANITA','POOJA','NEHA',
            'DEEPA','REKHA','SONIA','NISHA','GEETA','USHA','LATA','SEEMA','DIVYA','RITU',
            'DEVI','LAKSHMI','SAVITA','SUDHA','RADHA','RITA','SWATI','NITA','ASHA','MAYA',
            'SHILPA','SNEHA','PALLAVI','JYOTI','ARCHANA','VARSHA','ANJALI','SHRUTI','RADHIKA'};
        return fem.contains(fn==null?'':fn.toUpperCase())?'F':'M';
    }
    static String ppoCity(String city){
        Map<String,String> pm=new Map<String,String>{
            'Indore'=>'BHOPAL','Mumbai'=>'MUMBAI','Delhi'=>'DELHI','Jaipur'=>'JAIPUR',
            'Pune'=>'PUNE','Bengaluru'=>'BENGALURU','Ahmedabad'=>'AHMEDABAD',
            'Hyderabad'=>'HYDERABAD','Chennai'=>'CHENNAI','Kolkata'=>'KOLKATA',
            'Lucknow'=>'LUCKNOW','Kanpur'=>'LUCKNOW','Bhopal'=>'BHOPAL',
            'Nagpur'=>'NAGPUR','Patna'=>'PATNA','Surat'=>'AHMEDABAD'
        };
        return pm.containsKey(city)?pm.get(city):'DELHI';
    }
}

List<Account> accs=[SELECT Id,FirstName,LastName,PersonBirthdate,BillingCity,BillingState,BillingPostalCode FROM Account WHERE IsPersonAccount=true ORDER BY LastName,FirstName];
List<ContentVersion> batch=new List<ContentVersion>();
Integer cnt=0;
for(Account a:accs){
    String nm=a.FirstName.toUpperCase()+' '+a.LastName.toUpperCase();
    String gender=U.gen(a.FirstName);
    String dob=a.PersonBirthdate!=null?String.valueOf(a.PersonBirthdate):'1985-06-15';
    String city=a.BillingCity!=null?a.BillingCity:'';
    String st2=a.BillingState!=null?a.BillingState:'India';
    String ppo=U.ppoCity(city);
    Integer hv=Math.abs(a.Id.hashCode());
    String ppNum='P'+String.valueOf(1000000+Math.mod(hv,8999999));
    String issueDate='2020-'+String.valueOf(Math.mod(hv,12)+1).leftPad(2,'0')+'-15';
    String expDate='2030-'+String.valueOf(Math.mod(hv,12)+1).leftPad(2,'0')+'-14';
    String fatherName='RAMESH '+a.LastName.toUpperCase();
    String spouse=gender=='F'?'ARUN '+a.LastName.toUpperCase():'';
    String mrz1='P<IND'+a.LastName.toUpperCase()+'<<'+a.FirstName.toUpperCase()+'<<<<<<<<<<<<<<<<';
    String mrz2=ppNum.replace('P','')+'IND'+dob.replace('-','').mid(2,6)+gender+expDate.replace('-','').mid(2,6)+'<<<<<<<<<<<<<2';
    List<String> lines=new List<String>{
        'REPUBLIC OF INDIA',
        'MINISTRY OF EXTERNAL AFFAIRS',
        '================================================================',
        'PASSPORT',
        '================================================================',
        'Passport No      : '+ppNum,
        'Surname          : '+a.LastName.toUpperCase(),
        'Given Name(s)    : '+a.FirstName.toUpperCase(),
        'Nationality      : INDIAN',
        'Date of Birth    : '+dob,
        'Sex              : '+gender,
        'Place of Birth   : '+city+', '+st2,
        '================================================================',
        'Place of Issue   : '+ppo,
        'Date of Issue    : '+issueDate,
        'Date of Expiry   : '+expDate,
        '================================================================',
        "Father's Name    : "+fatherName,
        'Permanent Addr   : '+city+', '+st2,
        '================================================================',
        'Machine Readable Zone (MRZ):',
        mrz1.left(44),
        mrz2.left(44),
        '================================================================',
        'Passport Seva Kendra: '+ppo+' PSK',
        'Helpline: 1800-258-1800 | www.passportindia.gov.in'
    };
    batch.add(new ContentVersion(
        Title='Passport - '+a.FirstName+' '+a.LastName,
        PathOnClient='Passport_'+a.FirstName+'_'+a.LastName+'.pdf',
        FirstPublishLocationId=a.Id,
        VersionData=U.pdf(lines)
    ));
    cnt++;
    if(Math.mod(cnt,25)==0){insert batch;batch.clear();}
}
if(!batch.isEmpty())insert batch;
System.debug('Passports inserted: '+cnt);
