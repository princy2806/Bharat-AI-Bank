// C04: Birth Certificates (PDF) - All Person Accounts
// Execute: Developer Console > Execute Anonymous
// Doc AI Template: BIRTH_CERTIFICATE
// Fields: Name, DOB, Place of Birth, Parents, Registration Number

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
        return fem.contains(fn==null?'':fn.toUpperCase())?'FEMALE':'MALE';
    }
    static String hospital(String city){
        Map<String,String> hm=new Map<String,String>{
            'Indore'=>'MY Hospital, Indore','Mumbai'=>'Lilavati Hospital, Mumbai',
            'Delhi'=>'AIIMS, New Delhi','Jaipur'=>'SMS Hospital, Jaipur',
            'Pune'=>'Sassoon General Hospital, Pune','Bengaluru'=>'Manipal Hospital, Bengaluru',
            'Ahmedabad'=>'Civil Hospital, Ahmedabad','Hyderabad'=>'Nizam Institute, Hyderabad',
            'Chennai'=>'Government General Hospital, Chennai','Kolkata'=>'SSKM Hospital, Kolkata',
            'Lucknow'=>'KGMU, Lucknow','Kanpur'=>'Lala Lajpat Rai Hospital, Kanpur',
            'Bhopal'=>'Hamidia Hospital, Bhopal','Nagpur'=>'Government Medical College, Nagpur'
        };
        return hm.containsKey(city)?hm.get(city):city+' General Hospital';
    }
}

List<Account> accs=[SELECT Id,FirstName,LastName,PersonBirthdate,BillingCity,BillingState,BillingPostalCode FROM Account WHERE IsPersonAccount=true ORDER BY LastName,FirstName];
List<ContentVersion> batch=new List<ContentVersion>();
Integer cnt=0;
for(Account a:accs){
    String nm=(a.FirstName+' '+a.LastName).toUpperCase();
    String gender=U.gen(a.FirstName);
    String dob=a.PersonBirthdate!=null?String.valueOf(a.PersonBirthdate):'1985-06-15';
    String city=a.BillingCity!=null?a.BillingCity:'';
    String st2=a.BillingState!=null?a.BillingState:'';
    String hosp=U.hospital(city);
    Integer regNum=100000+Math.mod(Math.abs(a.Id.hashCode()),899999);
    String regYear=a.PersonBirthdate!=null?String.valueOf(a.PersonBirthdate.year()):'1985';
    String fatherName='RAMESH '+a.LastName.toUpperCase();
    String motherName='SUSHILA '+a.LastName.toUpperCase();
    if(gender=='FEMALE'){fatherName='MOHAN '+a.LastName.toUpperCase();motherName='KAMLA '+a.LastName.toUpperCase();}
    List<String> lines=new List<String>{
        'GOVERNMENT OF '+st2.toUpperCase(),
        'MUNICIPAL CORPORATION - BIRTH AND DEATH REGISTRATION',
        '================================================================',
        'BIRTH CERTIFICATE',
        '================================================================',
        'Registration Number : BC/'+regYear+'/'+city.left(3).toUpperCase()+'/'+String.valueOf(regNum),
        'Date of Issue       : '+String.valueOf(Date.today().addYears(-2)),
        '================================================================',
        'CHILD DETAILS:',
        'Name                : '+nm,
        'Date of Birth       : '+dob,
        'Time of Birth       : '+String.valueOf(Math.mod(Math.abs(a.Id.hashCode()),12)+6)+':'+String.valueOf(Math.mod(Math.abs(a.Id.hashCode()),60)).leftPad(2,'0')+' HRS',
        'Sex                 : '+gender,
        'Place of Birth      : '+hosp,
        '================================================================',
        'PARENTS DETAILS:',
        'Father Name         : '+fatherName,
        'Mother Name         : '+motherName,
        'Permanent Address   : '+city+', '+st2,
        '================================================================',
        'Certified that the above information is true and correct as per',
        'records maintained under Registration of Births and Deaths Act 1969.',
        '----------------------------------------------------------------',
        'Registrar: Birth and Death, '+city+' Municipal Corporation',
        'Official Seal Applied | Verification: www.crsorgi.gov.in'
    };
    batch.add(new ContentVersion(
        Title='Birth Certificate - '+a.FirstName+' '+a.LastName,
        PathOnClient='BirthCert_'+a.FirstName+'_'+a.LastName+'.pdf',
        FirstPublishLocationId=a.Id,
        VersionData=U.pdf(lines)
    ));
    cnt++;
    if(Math.mod(cnt,25)==0){insert batch;batch.clear();}
}
if(!batch.isEmpty())insert batch;
System.debug('Birth certificates inserted: '+cnt);
