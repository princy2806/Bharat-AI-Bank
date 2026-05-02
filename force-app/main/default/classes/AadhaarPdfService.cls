public with sharing class AadhaarPdfService {

// ===== Utility Methods =====

public static String pad(Integer n){
    String s = String.valueOf(n);
    while(s.length() < 10) s = '0' + s;
    return s;
}

public static String escapePdf(String s){
    return s == null ? '' :
        s.replace('\\','\\\\')
         .replace('(','\\(')
         .replace(')','\\)');
}

public static String generateAadhaar(String id){
    Integer h = Math.abs(id.hashCode());
    String s = String.valueOf(h) + '000000000000';
    return s.left(4) + ' ' + s.mid(4,4) + ' ' + s.mid(8,4);
}

public static String generateGender(String firstName){
    String f = firstName == null ? '' : firstName.toUpperCase();

    Set<String> femaleNames = new Set<String>{
        'PRIYA','SUNITA','MEERA','ANITA','POOJA','NEHA','REKHA','SONIA',
        'NISHA','LATA','SEEMA','DIVYA','RITU','MONA','TARA','DEVI',
        'SAVITA','RADHA','SWATI','ASHA','MAYA','KIRAN','SNEHA','ANJALI',
        'SHRUTI','PREETI','SHWETA','RADHIKA'
    };

    return femaleNames.contains(f) ? 'FEMALE' : 'MALE';
}

public static Blob generatePdf(List<String> lines){

    String content = 'BT /F1 9 Tf 20 820 Td 12 TL\n';

    for(String line : lines){
        content += '(' + escapePdf(line.left(85)) + ') Tj T*\n';
    }

    content += 'ET';

    String header = '%PDF-1.4\n',
           obj1 = '1 0 obj<</Type/Catalog/Pages 2 0 R>>endobj\n',
           obj2 = '2 0 obj<</Type/Pages/Kids[3 0 R]/Count 1>>endobj\n',
           obj3 = '3 0 obj<</Type/Page/MediaBox[0 0 595 842]/Parent 2 0 R/Contents 4 0 R/Resources<</Font<</F1<</Type/Font/Subtype/Type1/BaseFont/Courier>>>>>>endobj\n',
           obj4 = '4 0 obj<</Length ' + content.length() + '>>\nstream\n' + content + '\nendstream\nendobj\n';

    Integer p1 = header.length(),
            p2 = p1 + obj1.length(),
            p3 = p2 + obj2.length(),
            p4 = p3 + obj3.length(),
            px = p4 + obj4.length();

    String xref = 'xref\n0 5\n0000000000 65535 f \n'
        + pad(p1) + ' 00000 n \n'
        + pad(p2) + ' 00000 n \n'
        + pad(p3) + ' 00000 n \n'
        + pad(p4) + ' 00000 n \n';

    String trailer = 'trailer<</Size 5/Root 1 0 R>>\nstartxref\n' + px + '\n%%EOF';

    return Blob.valueOf(header + obj1 + obj2 + obj3 + obj4 + xref + trailer);
}


// ===== Main Method =====

public static void generateAadhaarForAccounts(List<Account> accs){

    List<ContentVersion> files = new List<ContentVersion>();

    for(Account a : accs){

        String name = (a.FirstName + ' ' + a.LastName).toUpperCase();
        String aadhaar = generateAadhaar(a.Id);
        String gender = generateGender(a.FirstName);

        String dob = a.PersonBirthdate != null
            ? String.valueOf(a.PersonBirthdate)
            : '1985-01-15';

        String address =
            (a.BillingStreet != null ? a.BillingStreet + ', ' : '') +
            (a.BillingCity != null ? a.BillingCity : 'India') +
            (a.BillingState != null ? ', ' + a.BillingState : '') +
            (a.BillingPostalCode != null ? ' - ' + a.BillingPostalCode : '');

        List<String> lines = new List<String>{
            'GOVERNMENT OF INDIA',
            'UNIQUE IDENTIFICATION AUTHORITY OF INDIA (UIDAI)',
            '=============================================',
            'AADHAAR CARD',
            '=============================================',
            'Aadhaar Number   : ' + aadhaar,
            'Name             : ' + name,
            'Date of Birth    : ' + dob,
            'Gender           : ' + gender,
            '=============================================',
            'Address:',
            address.left(80),
            '============================================='
        };

        files.add(new ContentVersion(
            Title = 'Aadhaar - ' + a.FirstName + ' ' + a.LastName,
            PathOnClient = 'Aadhaar_' + a.FirstName + '_' + a.LastName + '.pdf',
            FirstPublishLocationId = a.Id,
            VersionData = generatePdf(lines)
        ));
    }

    if(!files.isEmpty()){
        insert files;
    }
}
}