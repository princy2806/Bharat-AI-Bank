/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-19-2026
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
// C01: Aadhaar Cards (PDF) - All Person Accounts
// Execute: Developer Console > Execute Anonymous
// Doc AI Template: AADHAAR_CARD

class U {

    public static String p(Integer n){
        String s = String.valueOf(n);
        while(s.length() < 10) s = '0' + s;
        return s;
    }

    public static String e(String s){
        return s == null ? '' : s.replace('\\','\\\\').replace('(','\\(').replace(')','\\)');
    }

    public static Blob pdf(List<String> L){
        String st = 'BT /F1 9 Tf 20 820 Td 12 TL\n';
        for(String lost : L){
            st += '(' + e(lost.left(85)) + ') Tj T*\n';
        }
        st += 'ET';

        String h = '%PDF-1.4\n',
            o1 = '1 0 obj<</Type/Catalog/Pages 2 0 R>>endobj\n',
            o2 = '2 0 obj<</Type/Pages/Kids[3 0 R]/Count 1>>endobj\n',
            o3 = '3 0 obj<</Type/Page/MediaBox[0 0 595 842]/Parent 2 0 R/Contents 4 0 R/Resources<</Font<</F1<</Type/Font/Subtype/Type1/BaseFont/Courier>>>>>>endobj\n',
            o4 = '4 0 obj<</Length ' + st.length() + '>>\nstream\n' + st + '\nendstream\nendobj\n';

        Integer p1 = h.length(),
                p2 = p1 + o1.length(),
                p3 = p2 + o2.length(),
                p4 = p3 + o3.length(),
                px = p4 + o4.length();

        String xr = 'xref\n0 5\n0000000000 65535 f \n'
            + p(p1) + ' 00000 n \n'
            + p(p2) + ' 00000 n \n'
            + p(p3) + ' 00000 n \n'
            + p(p4) + ' 00000 n \n';

        return Blob.valueOf(h + o1 + o2 + o3 + o4 + xr +
            'trailer<</Size 5/Root 1 0 R>>\nstartxref\n' + px + '\n%%EOF');
    }

    public static String aadh(String id){
        Integer h = Math.abs(id.hashCode());
        String s = String.valueOf(h) + '000000000000';
        return s.left(4) + ' ' + s.mid(4,4) + ' ' + s.mid(8,4);
    }

    public static String gen(String fn){
        String f = fn == null ? '' : fn.toUpperCase();

        Set<String> fem = new Set<String>{
            'PRIYA','SUNITA','MEERA','KAVITHA','ANITA','POOJA','NEHA',
            'DEEPA','REKHA','SONIA','NISHA','GEETA','USHA','LATA','SEEMA',
            'DIVYA','RITU','MONA','TARA','DEVI','LAKSHMI','SAVITA','SUDHA',
            'RADHA','GITA','RITA','SWATI','NITA','ASHA','MAYA','KIRAN',
            'SHILPA','SNEHA','PALLAVI','JYOTI','ARCHANA','SMITA','VARSHA',
            'ANJALI','NAMITA','SHRUTI','SUPARNA','MANISHA','SARIKA',
            'NANDINI','PREETI','SHWETA','RADHIKA'
        };

        return fem.contains(f) ? 'FEMALE' : 'MALE';
    }
}


// 🔽 Main Execution

List<Account> accs = [
    SELECT Id, FirstName, LastName, PersonBirthdate,
           BillingStreet, BillingCity, BillingState, BillingPostalCode
    FROM Account
    WHERE IsPersonAccount = true
    ORDER BY LastName, FirstName
];

List<ContentVersion> batch = new List<ContentVersion>();
Integer cnt = 0;

for(Account a : accs){

    String nm = (a.FirstName + ' ' + a.LastName).toUpperCase();

    String ad = U.aadh(a.Id);
    String vid = ad.replace(' ','').left(8) + 'XXXX';

    String dob = a.PersonBirthdate != null
        ? String.valueOf(a.PersonBirthdate)
        : '1985-01-15';

    String city = a.BillingCity != null ? a.BillingCity : 'India';
    String st2 = a.BillingState != null ? a.BillingState : '';
    String pin = a.BillingPostalCode != null ? a.BillingPostalCode : '';

    String addr = (a.BillingStreet != null ? a.BillingStreet + ', ' : '')
        + city
        + (st2 != '' ? ', ' + st2 : '')
        + (pin != '' ? ' - ' + pin : '');

    String gender = U.gen(a.FirstName);

    List<String> lines = new List<String>{
        'GOVERNMENT OF INDIA',
        'UNIQUE IDENTIFICATION AUTHORITY OF INDIA (UIDAI)',
        '================================================================',
        'AADHAAR CARD',
        '================================================================',
        'Aadhaar Number   : ' + ad,
        'Name             : ' + nm,
        'Date of Birth    : ' + dob,
        'Gender           : ' + gender,
        '================================================================',
        'Address:',
        addr.left(80),
        '================================================================',
        'VID              : ' + vid,
        'Issue Date       : 2018-06-15',
        'Mobile Linked    : YES (UIDAI registered)',
        'Biometrics       : ENROLLED',
        '================================================================',
        'This Aadhaar is issued by UIDAI under The Aadhaar Act 2016.',
        'Verify at: resident.uidai.gov.in | Helpline: 1947',
        'Enrolling Agency : Common Service Centre (CSC)',
        'Enrolment No     : ' + ad.replace(' ','') + '/' + dob.replace('-','')
    };

    batch.add(new ContentVersion(
        Title = 'Aadhaar Card - ' + a.FirstName + ' ' + a.LastName,
        PathOnClient = 'Aadhaar_' + a.FirstName + '_' + a.LastName + '.pdf',
        FirstPublishLocationId = a.Id,
        VersionData = U.pdf(lines)
    ));

    cnt++;

    if(Math.mod(cnt, 25) == 0){
        insert batch;
        batch.clear();
    }
}

if(!batch.isEmpty()){
    insert batch;
}

System.debug('Aadhaar cards inserted: ' + cnt);