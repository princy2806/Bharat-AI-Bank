public with sharing class UanDetailsPdfService {

// ===== Utility =====

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


// ===== Business Logic =====

public static String generateUAN(Integer hv){
    String s = String.valueOf(100000000000L + Math.mod(hv, 899999999999L));
    return s.left(12);
}

public static String getCurrentEmployer(String industry){

    Map<String,String> mapVal = new Map<String,String>{
        'Technology'=>'Infosys Limited',
        'Healthcare'=>'Apollo Hospitals Pvt Ltd',
        'Finance'=>'HDFC Securities Limited',
        'Manufacturing'=>'Tata Motors Limited',
        'Retail'=>'Reliance Retail Limited',
        'Education'=>'Extramarks Education Pvt Ltd',
        'Real Estate'=>'DLF Home Developers Ltd',
        'Consulting'=>'PricewaterhouseCoopers Pvt Ltd'
    };

    return mapVal.containsKey(industry) ? mapVal.get(industry)
        : 'Current Employer Pvt Ltd';
}

public static String getPreviousEmployer(String industry){

    Map<String,String> mapVal = new Map<String,String>{
        'Technology'=>'Wipro Technologies Limited',
        'Healthcare'=>'Fortis Healthcare Ltd',
        'Finance'=>'ICICI Securities Limited',
        'Manufacturing'=>'Mahindra & Mahindra Ltd',
        'Retail'=>'Future Group Limited',
        'Education'=>'Pearson India Education',
        'Real Estate'=>'Godrej Properties Limited',
        'Consulting'=>'Ernst & Young LLP'
    };

    return mapVal.containsKey(industry) ? mapVal.get(industry)
        : 'Previous Employer Pvt Ltd';
}

public static String getGender(String firstName){

    Set<String> femaleNames = new Set<String>{
        'PRIYA','SUNITA','MEERA','ANITA','POOJA','NEHA','DEEPA'
    };

    return femaleNames.contains(firstName == null ? '' : firstName.toUpperCase())
        ? 'Female' : 'Male';
}


// ===== Main Method =====

public static void generateUanDetails(List<Account> accs){

    List<ContentVersion> files = new List<ContentVersion>();

    for(Account a : accs){

        String name = (a.FirstName + ' ' + a.LastName).toUpperCase();
        Integer hashVal = Math.abs(a.Id.hashCode());

        String city = a.BillingCity != null ? a.BillingCity : 'CITY';
        String state = a.BillingState != null ? a.BillingState : '';
        String industry = a.Industry != null ? a.Industry : 'Technology';

        String dob = a.PersonBirthdate != null
            ? String.valueOf(a.PersonBirthdate)
            : '1985-06-15';

        String uan = generateUAN(hashVal);

        Integer serviceYears = 3 + Math.mod(hashVal,12);

        String currentEmployer = getCurrentEmployer(industry);
        String previousEmployer = getPreviousEmployer(industry);

        String currentJoin = String.valueOf(Date.today().addYears(-serviceYears));
        String prevFrom = String.valueOf(Date.today().addYears(-serviceYears - 3));
        String prevTo = String.valueOf(Date.today().addYears(-serviceYears).addDays(-30));

        String pfCurrent = city.left(2).toUpperCase() + 'CPF' +
            String.valueOf(10000 + Math.mod(hashVal,89999));

        String pfPrevious = city.left(2).toUpperCase() + 'PPF' +
            String.valueOf(20000 + Math.mod(hashVal,79999));

        Decimal revenue = a.AnnualRevenue != null ? a.AnnualRevenue : 600000;

        Integer basic = Math.round((Integer)(revenue/12) * 0.4 / 100) * 100;

        Integer pfBalance = (Integer)(basic * 0.24 * 12 * serviceYears * 1.35);

        List<String> lines = new List<String>{
            'EPFO - UAN DETAILS',
            '=============================================',
            'UAN              : ' + uan,
            'Name             : ' + name,
            'DOB              : ' + dob,
            'Gender           : ' + getGender(a.FirstName),
            '=============================================',
            'KYC STATUS       : VERIFIED',
            '=============================================',
            'CURRENT EMPLOYMENT:',
            currentEmployer,
            'Joining Date     : ' + currentJoin,
            'PF Account       : ' + pfCurrent,
            '=============================================',
            'PREVIOUS EMPLOYMENT:',
            previousEmployer,
            'From             : ' + prevFrom,
            'To               : ' + prevTo,
            'PF Account       : ' + pfPrevious,
            '=============================================',
            'Total PF Balance : Rs ' + pfBalance,
            'Withdrawal       : ' + (serviceYears >= 5 ? 'Eligible' : 'Not Eligible'),
            '=============================================',
            'Portal: www.epfindia.gov.in'
        };

        files.add(new ContentVersion(
            Title = 'UAN Details - ' + a.FirstName + ' ' + a.LastName,
            PathOnClient = 'UAN_' + a.FirstName + '_' + a.LastName + '.pdf',
            FirstPublishLocationId = a.Id,
            VersionData = generatePdf(lines)
        ));
    }

    if(!files.isEmpty()){
        insert files;
    }
}

}