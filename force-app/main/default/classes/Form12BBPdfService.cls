public with sharing class Form12BBPdfService {
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


// ===== Main Method =====

public static void generateForm12BB(List<Account> accs){

    List<ContentVersion> files = new List<ContentVersion>();
    Integer idx = 0;

    for(Account a : accs){

        String name = (a.FirstName + ' ' + a.LastName).toUpperCase();
        Integer hashVal = Math.abs(a.Id.hashCode());

        String city = a.BillingCity != null ? a.BillingCity : 'CITY';

        Decimal revenue = a.AnnualRevenue != null ? a.AnnualRevenue : 600000;

        // ===== HRA =====
        Integer basicSalary = Math.round((Integer)(revenue * 0.4) / 1000) * 1000;
        Integer hraDeclared = Math.round(basicSalary * 0.5 / 1000) * 1000;

        Integer rentPerMonth = Math.mod(hashVal,10000) + 10000;

        Integer hraClaimable = Math.min(
            hraDeclared,
            rentPerMonth * 12 - Math.round(basicSalary * 12 * 0.1 / 1000) * 1000
        );

        // ===== 80C =====
        Integer pf = Math.round(basicSalary * 0.12 / 1000) * 1000;
        Integer lic = Math.mod(hashVal,50000) + 10000;
        Integer elss = Math.mod(hashVal,60000) + 10000;
        Integer ppf = Math.mod(hashVal,30000);

        Integer total80C = Math.min(150000, pf + lic + elss + ppf);

        // ===== 80D =====
        Integer healthInsurance = Math.min(25000, Math.mod(hashVal,20000) + 5000);

        // ===== Home Loan =====
        Boolean hasHomeLoan = Math.mod(idx,3) == 0;

        Integer homeLoanInterest = hasHomeLoan
            ? Math.min(200000, Math.mod(hashVal,180000) + 50000)
            : 0;

        List<String> lines = new List<String>{
            'FORM 12BB',
            'Investment Declaration',
            '=============================================',
            'Financial Year : 2025-26',
            'Employee Name  : ' + name,
            'PAN            : XXXXX' + String.valueOf(1000 + idx) + 'X',
            'City           : ' + city,
            '=============================================',
            'HRA DETAILS:',
            'HRA Received   : Rs ' + hraDeclared,
            'Rent / Month   : Rs ' + rentPerMonth,
            'HRA Exemption  : Rs ' + Math.max(0, hraClaimable),
            '=============================================',
            'LTA CLAIM:',
            'LTA Amount     : Rs ' + Math.min(30000, Math.mod(hashVal,25000) + 5000),
            '=============================================',
            'SECTION 80C:',
            'PF             : Rs ' + pf,
            'LIC            : Rs ' + lic,
            'ELSS           : Rs ' + elss,
            'PPF            : Rs ' + ppf,
            'Total 80C      : Rs ' + total80C,
            '=============================================',
            'SECTION 80D:',
            'Health Ins     : Rs ' + healthInsurance,
            '=============================================',
            'HOME LOAN:',
            hasHomeLoan ? 'Interest Paid : Rs ' + homeLoanInterest : 'Not Applicable',
            '=============================================',
            'Declaration: Information provided is true.',
            'Employee Signature: __________'
        };

        files.add(new ContentVersion(
            Title = 'Form12BB - ' + a.FirstName + ' ' + a.LastName,
            PathOnClient = 'Form12BB_' + a.FirstName + '_' + a.LastName + '.pdf',
            FirstPublishLocationId = a.Id,
            VersionData = generatePdf(lines)
        ));

        idx++;
    }

    if(!files.isEmpty()){
        insert files;
    }
}

}