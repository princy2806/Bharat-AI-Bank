public with sharing class Form16PdfService {

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

public static String getEmployer(String industry, String city){

    Map<String,String> employers = new Map<String,String>{
        'Technology'=>'Infosys Limited',
        'Healthcare'=>'Apollo Hospitals Pvt Ltd',
        'Finance'=>'HDFC Bank Limited',
        'Manufacturing'=>'Tata Motors Limited',
        'Retail'=>'Reliance Retail Limited',
        'Education'=>'BYJUS Learning Pvt Ltd',
        'Real Estate'=>'DLF Limited',
        'Consulting'=>'Deloitte India Pvt Ltd',
        'Media'=>'Times of India Group',
        'Hospitality'=>'Taj Hotels Limited'
    };

    if(industry != null && employers.containsKey(industry)){
        return employers.get(industry);
    }

    return (city != null ? city : 'India') + ' Enterprises Pvt Ltd';
}


// ===== Main Method =====

public static void generateForm16(List<Account> accs){

    List<ContentVersion> files = new List<ContentVersion>();
    Integer idx = 0;

    for(Account a : accs){

        String name = (a.FirstName + ' ' + a.LastName).toUpperCase();
        Integer hashVal = Math.abs(a.Id.hashCode());

        String city = a.BillingCity != null ? a.BillingCity : 'CITY';
        String industry = a.Industry != null ? a.Industry : 'Technology';

        Decimal revenue = a.AnnualRevenue != null ? a.AnnualRevenue : 600000;

        String employer = getEmployer(industry, city);

        String empPAN = 'AABCE' + String.valueOf(1000 + Math.mod(hashVal,8999)) + 'F';
        String empTAN = city.left(3).toUpperCase() + 'E' + String.valueOf(10000 + Math.mod(hashVal,89999)) + 'B';

        // ===== Tax Calculation =====

        Integer grossSalary = (Integer)revenue;
        Integer hra = Math.round(grossSalary * 0.1 / 1000) * 1000;
        Integer standardDeduction = 50000;

        Integer sec80C = 150000;
        Integer sec80D = 25000;

        Integer netTaxable = Math.max(0,
            grossSalary - hra - standardDeduction - sec80C - sec80D
        );

        Integer tax = 0;

        if(netTaxable > 1500000)
            tax = (Integer)((netTaxable - 1500000) * 0.3 + 187500);
        else if(netTaxable > 1200000)
            tax = (Integer)((netTaxable - 1200000) * 0.2 + 127500);
        else if(netTaxable > 900000)
            tax = (Integer)((netTaxable - 900000) * 0.15 + 67500);
        else if(netTaxable > 600000)
            tax = (Integer)((netTaxable - 600000) * 0.1 + 22500);
        else if(netTaxable > 300000)
            tax = (Integer)((netTaxable - 300000) * 0.05);

        Integer cess = (Integer)(tax * 0.04);
        Integer totalTax = tax + cess;

        List<String> lines = new List<String>{
            'FORM 16 - TDS CERTIFICATE',
            '=============================================',
            'Financial Year : 2025-26',
            '=============================================',
            'EMPLOYER:',
            employer,
            'PAN : ' + empPAN,
            'TAN : ' + empTAN,
            '=============================================',
            'EMPLOYEE:',
            name,
            'PAN : XXXXX' + String.valueOf(1000 + idx) + 'X',
            '=============================================',
            'INCOME DETAILS:',
            'Gross Salary     : Rs ' + grossSalary,
            'HRA Exemption    : Rs ' + hra,
            'Std Deduction    : Rs ' + standardDeduction,
            '=============================================',
            'DEDUCTIONS:',
            'Section 80C      : Rs ' + sec80C,
            'Section 80D      : Rs ' + sec80D,
            '=============================================',
            'Net Taxable      : Rs ' + netTaxable,
            'Income Tax       : Rs ' + tax,
            'Cess             : Rs ' + cess,
            'Total Tax        : Rs ' + totalTax,
            '=============================================',
            'TDS Paid         : Rs ' + totalTax,
            '=============================================',
            'Authorised Signatory',
            employer
        };

        files.add(new ContentVersion(
            Title = 'Form16 - ' + a.FirstName + ' ' + a.LastName,
            PathOnClient = 'Form16_' + a.FirstName + '_' + a.LastName + '.pdf',
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