public with sharing class PersonalLoanAgreementPdfService {

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
    List<String> banks = new List<String>{
        'HDFC Bank Limited','ICICI Bank Limited',
        'Axis Bank Limited','Bajaj Finance Limited',
        'Tata Capital Financial Services','Fullerton India Credit Company',
        'Kotak Mahindra Bank','Muthoot Finance'
    };
    return banks[Math.mod(idx, banks.size())];
}

public static String getPurpose(Integer idx){
    List<String> purposes = new List<String>{
        'Medical expenses','Home renovation','Wedding expenses',
        'Travel and vacation','Education fee payment',
        'Debt consolidation','Consumer electronics purchase',
        'Emergency expenses'
    };
    return purposes[Math.mod(idx, purposes.size())];
}


// ===== Main Method =====

public static void generatePersonalLoanAgreements(List<Account> accs){

    List<ContentVersion> files = new List<ContentVersion>();
    Integer idx = 0;

    for(Account a : accs){

        String name = (a.FirstName + ' ' + a.LastName).toUpperCase();
        Integer hashVal = Math.abs(a.Id.hashCode());

        String city = a.BillingCity != null ? a.BillingCity : 'CITY';
        String state = a.BillingState != null ? a.BillingState : '';
        String pin = a.BillingPostalCode != null ? a.BillingPostalCode : '';

        String address =
            (a.BillingStreet != null ? a.BillingStreet + ', ' : '') +
            city +
            (state != '' ? ', ' + state : '') +
            (pin != '' ? ' - ' + pin : '');

        Decimal revenue = a.AnnualRevenue != null ? a.AnnualRevenue : 600000;

        Integer loanAmount = 100000 + Math.mod(hashVal, 400000);
        loanAmount = Math.round(loanAmount / 10000) * 10000;

        Decimal rate = 12.5;
        Integer tenure = 60;

        Decimal monthlyRate = rate / 100 / 12;

        Integer emi = (Integer)(
            loanAmount * monthlyRate *
            (1 + monthlyRate * tenure) /
            ((1 + monthlyRate * tenure) - 1)
        );

        String lender = getLender(idx);
        String purpose = getPurpose(idx);

        String loanNo = 'PL/' +
            city.left(3).toUpperCase() +
            '/' +
            String.valueOf(Date.today().year() - Math.mod(hashVal,3)) +
            '/' +
            String.valueOf(200000 + Math.mod(hashVal,799999));

        String agreementDate = String.valueOf(
            Date.today().addMonths(-(6 + Math.mod(hashVal,30)))
        );

        // ===== Sample Repayment =====

        Decimal balance = loanAmount;

        Integer int1 = (Integer)(balance * monthlyRate);
        Integer princ1 = emi - int1;
        balance -= princ1;

        Integer int2 = (Integer)(balance * monthlyRate);
        Integer princ2 = emi - int2;

        List<String> lines = new List<String>{
            lender.toUpperCase(),
            'PERSONAL LOAN AGREEMENT',
            '=============================================',
            'Loan No         : ' + loanNo,
            'Agreement Date  : ' + agreementDate,
            '=============================================',
            'BORROWER:',
            name,
            'Address         : ' + address.left(70),
            'Income (Monthly): Rs ' + (Integer)(revenue/12),
            '=============================================',
            'LOAN DETAILS:',
            'Loan Amount     : Rs ' + loanAmount,
            'Purpose         : ' + purpose,
            'Interest Rate   : ' + rate + '%',
            'Tenure          : ' + tenure + ' months',
            'EMI             : Rs ' + emi,
            'Total Payment   : Rs ' + (emi * tenure),
            '=============================================',
            'SAMPLE EMI:',
            'EMI 1 | P: ' + princ1 + ' I: ' + int1,
            'EMI 2 | P: ' + princ2 + ' I: ' + int2,
            '=============================================',
            'Bank            : ' + lender,
            '=============================================',
            'Borrower Sign: __________',
            'Bank Sign    : __________'
        };

        files.add(new ContentVersion(
            Title = 'Personal Loan Agreement - ' + a.FirstName + ' ' + a.LastName,
            PathOnClient = 'PersonalLoan_' + a.FirstName + '_' + a.LastName + '.pdf',
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