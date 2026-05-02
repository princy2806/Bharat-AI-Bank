// C03: Voter ID / EPIC Cards (PDF) - All Person Accounts
// Execute: Developer Console > Execute Anonymous
// Doc AI Template: VOTER_ID
// Fields: Name, DOB, Gender, Constituency, EPIC Number, Address

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
    static String epic(String state, Integer idx){
        Map<String,String> sc=new Map<String,String>{
            'Madhya Pradesh'=>'MPC','Maharashtra'=>'MHC','Delhi'=>'DLC','Rajasthan'=>'RJC',
            'Karnataka'=>'KAC','Gujarat'=>'GJC','Telangana'=>'TLC','Tamil Nadu'=>'TNC',
            'West Bengal'=>'WBC','Uttar Pradesh'=>'UPC','Kerala'=>'KLC','Punjab'=>'PBC',
            'Haryana'=>'HRC','Bihar'=>'BRC','Odisha'=>'ODC','Assam'=>'ASC'
        };
        String code=sc.containsKey(state)?sc.get(state):'INC';
        Integer h=Math.abs(idx*7+13);
        return code+'/'+String.valueOf(Math.mod(h,30)+1).leftPad(2,'0')+'/'+
               String.valueOf(Math.mod(h,999)+100)+'/'+String.valueOf(100000+Math.mod(h,899999));
    }
    static String constituency(String city){
        Map<String,String> cm=new Map<String,String>{
            'Indore'=>'229 - Indore-1','Mumbai'=>'173 - Bandra West','Delhi'=>'048 - Greater Kailash',
            'Jaipur'=>'061 - Sodala','Pune'=>'214 - Shivajinagar','Bengaluru'=>'149 - Indiranagar',
            'Ahmedabad'=>'065 - Navrangpura','Hyderabad'=>'093 - Jubilee Hills',
            'Chennai'=>'038 - Anna Nagar West','Kolkata'=>'025 - Rashbehari',
            'Lucknow'=>'178 - Lucknow Central','Kanpur'=>'155 - Kanpur',
            'Bhopal'=>'150 - Bhopal Central','Nagpur'=>'190 - Nagpur South',
            'Patna'=>'051 - Patna Sahib','Surat'=>'070 - Surat East'
        };
        return cm.containsKey(city)?cm.get(city):'001 - Central';
    }
    static String gen(String fn){
        Set<String> fem=new Set<String>{'PRIYA','SUNITA','MEERA','KAVITHA','ANITA','POOJA','NEHA',
            'DEEPA','REKHA','SONIA','NISHA','GEETA','USHA','LATA','SEEMA','DIVYA','RITU',
            'DEVI','LAKSHMI','SAVITA','SUDHA','RADHA','RITA','SWATI','NITA','ASHA','MAYA',
            'SHILPA','SNEHA','PALLAVI','JYOTI','ARCHANA','VARSHA','ANJALI','SHRUTI','RADHIKA'};
        return fem.contains(fn==null?'':fn.toUpperCase())?'FEMALE':'MALE';
    }
}

List<Account> accs=[SELECT Id,FirstName,LastName,PersonBirthdate,BillingStreet,BillingCity,BillingState,BillingPostalCode FROM Account WHERE IsPersonAccount=true ORDER BY LastName,FirstName];
List<ContentVersion> batch=new List<ContentVersion>();
Integer cnt=0;
for(Account a:accs){
    String nm=(a.FirstName+' '+a.LastName).toUpperCase();
    String gender=U.gen(a.FirstName);
    String epicNo=U.epic(a.BillingState!=null?a.BillingState:'',cnt);
    String consty=U.constituency(a.BillingCity!=null?a.BillingCity:'');
    String dob=a.PersonBirthdate!=null?String.valueOf(a.PersonBirthdate):'1985-06-15';
    String city=a.BillingCity!=null?a.BillingCity:'';
    String st2=a.BillingState!=null?a.BillingState:'';
    String pin=a.BillingPostalCode!=null?a.BillingPostalCode:'';
    String addr=(a.BillingStreet!=null?a.BillingStreet+', ':'')+city+(st2!=''?', '+st2:'')+(pin!=''?' - '+pin:'');
    String relation=gender=='FEMALE'?'D/O':'S/O';
    List<String> lines=new List<String>{
        'ELECTION COMMISSION OF INDIA',
        'ELECTORS PHOTO IDENTITY CARD (EPIC)',
        '================================================================',
        'EPIC Number      : '+epicNo,
        'State            : '+st2,
        'District         : '+city,
        'Assembly         : '+consty,
        'Part No          : '+String.valueOf(Math.mod(cnt+1,200)+1)+' | Serial No: '+String.valueOf(Math.mod(cnt*7+1,500)+1),
        '================================================================',
        'Name             : '+nm,
        'Relation         : '+relation+' '+U.gen(a.FirstName).equals('FEMALE')?'MOHAN '+a.LastName:'RAMESH '+a.LastName,
        'Date of Birth    : '+dob,
        'Gender           : '+gender,
        '================================================================',
        'Residential Address:',
        addr.left(80),
        '================================================================',
        'Issue Date       : 2010-08-20',
        'Issuing Officer  : District Election Officer, '+city,
        'This card is the property of Election Commission of India.'
    };
    batch.add(new ContentVersion(
        Title='Voter ID Card - '+a.FirstName+' '+a.LastName,
        PathOnClient='VoterID_'+a.FirstName+'_'+a.LastName+'.pdf',
        FirstPublishLocationId=a.Id,
        VersionData=U.pdf(lines)
    ));
    cnt++;
    if(Math.mod(cnt,25)==0){insert batch;batch.clear();}
}
if(!batch.isEmpty())insert batch;
System.debug('Voter IDs inserted: '+cnt);
