public with sharing class PfStatementPdfService {

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

public static String generatePfAccount(String city, Integer hv){

    Map<String,String> regionCodes = new Map<String,String>{
        'Indore'=>'MP/IND','Mumbai'=>'MH/MUM','Delhi'=>'DL/DEL','Jaipur'=>'RJ/JAI',
        'Pune'=>'MH/PUN','Bengaluru'=>'KA/BLR','Ahmedabad'=>'GJ/AMD',
        'Hyderabad'=>'TL/HYD','Chennai'=>'TN/CHN','Kolkata'=>'WB/KOL',
        'Lucknow'=>'UP/LKO','Bhopal'=>'MP/BHO','Nagpur'=>'MH/NGP'
    };

    String rc = regionCodes.containsKey(city) ? regionCodes.get(city) : 'IN/DEL';

    return rc + '/' +
           String.valueOf(10000 + Math.mod(hv,89999)) + '/' +
           String.valueOf(1 + Math.mod(hv,999));
}

public static String getEmployer(String industry, String city){

    Map<String,String> employers = new Map<String,String>{
        'Technology'=>'Infosys Limited',
        'Healthcare'=>'Apollo Hospitals Pvt Ltd',
        'Finance'=>'HDFC Securities Limited',
        'Manufacturing'=>'Tata Motors Limited',
        'Retail'=>'Reliance Retail Limited',
        'Education'=>'Extramarks Education Pvt Ltd',
        'Real Estate'=>'DLF Home Developers Ltd',
        'Consulting'=>'PricewaterhouseCoopers Pvt Ltd'
    };

    if(industry != null && employers.containsKey(industry)){
        return employers.get(industry);
    }

    return (city != null ? city : 'India') + ' Business Solutions Pvt Ltd';
}


// ===== Main Method =====

public static void generatePfStatements(List<Account> accs){

    List<ContentVersion> files = new List<ContentVersion>();

    for(Account a : accs){

        String name = (a.FirstName + ' ' + a.LastName).toUpperCase();
        Integer hashVal = Math.abs(a.Id.hashCode());

        String city = a.BillingCity != null ? a.BillingCity : 'CITY';
        String state = a.BillingState != null ? a.BillingState : '';
        String industry = a.Industry != null ? a.Industry : 'Technology';

        Decimal revenue = a.AnnualRevenue != null ? a.AnnualRevenue : 600000;

        String employer = getEmployer(industry, city);

        Integer monthly = (Integer)(revenue / 12);
        Integer basic = Math.round(monthly * 0.4 / 100) * 100;

        Integer empContribution = Math.round(basic * 0.12 / 100) * 100;
        Integer employerContribution = empContribution;

        Integer eps = Math.round(basic * 0.0833 / 100) * 100;
        Integer epfEmployer = employerContribution - eps;

        Integer serviceYears = 3 + Math.mod(hashVal,12);

        Integer totalEmp = empContribution * 12 * serviceYears;
        Integer totalEmployer = epfEmployer * 12 * serviceYears;

        Integer interest = (Integer)((totalEmp + totalEmployer) * 0.081 * serviceYears / 2);

        Integer balance = totalEmp + totalEmployer + interest;

        String uan = generateUAN(hashVal);
        String pfAcc = generatePfAccount(city, hashVal);

        List<String> lines = new List<String>{
            'EMPLOYEES PROVIDENT FUND ORGANISATION (EPFO)',
            '=============================================',
            'PF STATEMENT (FY 2025-26)',
            '=============================================',
            'UAN              : ' + uan,
            'PF Account No    : ' + pfAcc,
            'Member Name      : ' + name,
            '=============================================',
            'Employer         : ' + employer,
            'Location         : ' + city + ', ' + state,
            '=============================================',
            'Monthly Basic    : Rs ' + basic,
            'Employee EPF     : Rs ' + empContribution,
            'Employer EPF     : Rs ' + epfEmployer,
            'EPS (Pension)    : Rs ' + eps,
            '=============================================',
            'Total Employee   : Rs ' + totalEmp,
            'Total Employer   : Rs ' + totalEmployer,
            'Interest         : Rs ' + interest,
            '=============================================',
            'Total Balance    : Rs ' + balance,
            '=============================================',
            'Status           : KYC VERIFIED'
        };

        files.add(new ContentVersion(
            Title = 'PF Statement - ' + a.FirstName + ' ' + a.LastName,
            PathOnClient = 'PF_' + a.FirstName + '_' + a.LastName + '.pdf',
            FirstPublishLocationId = a.Id,
            VersionData = generatePdf(lines)
        ));
    }

    if(!files.isEmpty()){
        insert files;
    }
}

}