// C02: PAN Cards (PDF) - All Person Accounts
// Execute: Developer Console > Execute Anonymous
// Doc AI Template: PAN_CARD
// Fields: Name, DOB, PAN Number, Father Name, Signature

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
    static String pan(String fn, String ln, Integer idx){
        String lp=ln.left(3).toUpperCase();
        while(lp.length()<3)lp+='X';
        String fp=fn.left(1).toUpperCase();
        String num=String.valueOf(1000+Math.mod(idx,9000));
        String chk='P';
        // Format: 5 alpha + 4 numeric + 1 alpha = LLLPPNNNNA
        return lp+fp+chk+num+ln.left(1).toUpperCase();
    }
    static String fatherName(String ln){
        Map<String,String> fm=new Map<String,String>{
            'Sharma'=>'Ramesh Sharma','Patel'=>'Suresh Patel','Kumar'=>'Anil Kumar',
            'Singh'=>'Balvir Singh','Devi'=>'Rakesh Kumar','Nair'=>'Krishna Nair',
            'Gupta'=>'Ramesh Gupta','Reddy'=>'Venkatesh Reddy','Verma'=>'Anil Verma',
            'Joshi'=>'Mahesh Joshi','Mishra'=>'Ram Prasad Mishra','Yadav'=>'Ramesh Yadav',
            'Tiwari'=>'Shiv Prasad Tiwari','Pandey'=>'Rajendra Pandey','Shah'=>'Ramesh Shah',
            'Mehta'=>'Suresh Mehta','Iyer'=>'Subramanian Iyer','Pillai'=>'Krishnan Pillai',
            'Menon'=>'Gopalan Menon','Banerjee'=>'Samir Banerjee','Chatterjee'=>'Ashok Chatterjee',
            'Mukherjee'=>'Sanjay Mukherjee','Das'=>'Tarun Das','Bose'=>'Arun Bose',
            'Ghosh'=>'Prasanta Ghosh'
        };
        return fm.containsKey(ln)?fm.get(ln):'Ramesh '+ln;
    }
}

List<Account> accs=[SELECT Id,FirstName,LastName,PersonBirthdate,BillingCity,BillingState FROM Account WHERE IsPersonAccount=true ORDER BY LastName,FirstName];
List<ContentVersion> batch=new List<ContentVersion>();
Integer cnt=0;
for(Account a:accs){
    String nm=(a.FirstName+' '+a.LastName).toUpperCase();
    String panNo=U.pan(a.FirstName,a.LastName,cnt);
    String dob=a.PersonBirthdate!=null?String.valueOf(a.PersonBirthdate):'1985-01-15';
    String father=U.fatherName(a.LastName).toUpperCase();
    List<String> lines=new List<String>{
        'INCOME TAX DEPARTMENT',
        'GOVERNMENT OF INDIA',
        '================================================================',
        'PERMANENT ACCOUNT NUMBER (PAN) CARD',
        '================================================================',
        'PAN Number       : '+panNo,
        '================================================================',
        'Name             : '+nm,
        "Father's Name    : "+father,
        'Date of Birth    : '+dob,
        '================================================================',
        'Status           : INDIVIDUAL',
        'Issued By        : Income Tax Department, Govt. of India',
        'Issuing AO Code  : '+a.BillingState.left(2).toUpperCase()+'C-001',
        '================================================================',
        'Jurisdiction     : '+(a.BillingCity!=null?a.BillingCity:''),
        'Issue Date       : 2010-04-15',
        '================================================================',
        'This card is issued under Section 139A of the Income Tax Act 1961.',
        'PAN is mandatory for all financial transactions above Rs 50,000.',
        'NSDL Helpline: 020-27218080 | www.incometaxindia.gov.in'
    };
    batch.add(new ContentVersion(
        Title='PAN Card - '+a.FirstName+' '+a.LastName,
        PathOnClient='PAN_'+a.FirstName+'_'+a.LastName+'.pdf',
        FirstPublishLocationId=a.Id,
        VersionData=U.pdf(lines)
    ));
    cnt++;
    if(Math.mod(cnt,25)==0){insert batch;batch.clear();}
}
if(!batch.isEmpty())insert batch;
System.debug('PAN cards inserted: '+cnt);
