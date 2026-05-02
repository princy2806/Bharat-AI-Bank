public with sharing class LoanDetailsPdfService {

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

public static String getLender(Integer idx){
    List<String> lenders = new List<String>{
        'HDFC Bank','State Bank of India','ICICI Bank','Axis Bank',
        'Kotak Mahindra Bank','Bank of Baroda','Punjab National Bank',
        'LIC Housing Finance','Bajaj Finserv','Tata Capital'
    };
    return lenders[Math.mod(idx, lenders.size())];
}

public static String getLoanType(Integer idx){
    List<String> types = new List<String>{
        'Home Loan','Personal Loan','Business Loan','Home Loan',
        'Car Loan','Personal Loan','Home Loan','Education Loan',
        'Business Loan','Home Loan'
    };
    return types[Math.mod(idx, types.size())];
}


// ===== Main Method =====

public static void generateLoanDetails(List<Account> accs){

    List<ContentVersion> files = new List<ContentVersion>();
    Integer idx = 0;

    for(Account a : accs){

        String name = (a.FirstName + ' ' + a.LastName).toUpperCase();
        Integer hashVal = Math.abs(a.Id.hashCode());

        String city = a.BillingCity != null ? a.BillingCity : 'CITY';

        String lender = getLender(idx);
        String loanType = getLoanType(idx);

        Integer loanAmount;
        Decimal rate;
        Integer tenure;

        if(loanType == 'Home Loan'){
            loanAmount = 2000000 + Math.mod(hashVal, 8000000);
            rate = 8.65;
            tenure = 240;
        } else if(loanType == 'Personal Loan'){
            loanAmount = 100000 + Math.mod(hashVal, 400000);
            rate = 12.5;
            tenure = 60;
        } else if(loanType == 'Business Loan'){
            loanAmount = 500000 + Math.mod(hashVal, 4500000);
            rate = 11.0;
            tenure = 84;
        } else if(loanType == 'Car Loan'){
            loanAmount = 400000 + Math.mod(hashVal, 800000);
            rate = 9.0;
            tenure = 60;
        } else {
            loanAmount = 500000 + Math.mod(hashVal, 2000000);
            rate = 8.5;
            tenure = 120;
        }

        loanAmount = Math.round(loanAmount / 50000) * 50000;

        // EMI Calculation (approx)
        Decimal monthlyRate = rate / 100 / 12;
        Decimal emiCalc = loanAmount * monthlyRate *
            (1 + monthlyRate * tenure) /
            ((1 + monthlyRate * tenure) - 1);

        Integer emi = (Integer)emiCalc;

        Integer paidMonths = Math.mod(hashVal, tenure / 2) + 12;

        Integer outstanding = loanAmount -
            Math.round((Decimal)loanAmount * paidMonths / tenure / 10000) * 10000;

        String loanNo = 'LN/' +
            String.valueOf(Date.today().year() - Math.mod(hashVal,5)) +
            '/' + city.left(3).toUpperCase() +
            '/' + String.valueOf(100000 + Math.mod(hashVal,899999));

        List<String> lines = new List<String>{
            lender.toUpperCase(),
            'LOAN ACCOUNT STATEMENT',
            '=============================================',
            'Loan Account No  : ' + loanNo,
            'Borrower         : ' + name,
            'Loan Type        : ' + loanType,
            '=============================================',
            'LOAN DETAILS:',
            'Sanctioned Amount: Rs ' + loanAmount,
            'Interest Rate    : ' + rate + '% p.a.',
            'Tenure           : ' + tenure + ' months',
            'Disbursement Date: ' + String.valueOf(Date.today().addMonths(-paidMonths)),
            '=============================================',
            'CURRENT STATUS:',
            'EMI Amount       : Rs ' + emi,
            'EMIs Paid        : ' + paidMonths + ' of ' + tenure,
            'Principal Paid   : Rs ' + (loanAmount - outstanding),
            'Outstanding Amt  : Rs ' + outstanding,
            'Next EMI Date    : ' + String.valueOf(Date.today().addDays(10)),
            '=============================================',
            'STATUS           : REGULAR',
            'Bank             : ' + lender
        };

        files.add(new ContentVersion(
            Title = 'Loan Details - ' + a.FirstName + ' ' + a.LastName,
            PathOnClient = 'LoanDetails_' + a.FirstName + '_' + a.LastName + '.pdf',
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