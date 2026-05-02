public with sharing class BusinessLoanAgreementPdfService {

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
        'State Bank of India','HDFC Bank Limited','ICICI Bank Limited',
        'Axis Bank Limited','Bank of Baroda',
        'Bajaj Finance Limited','Tata Capital',
        'SIDBI (Small Industries Development Bank)'
    };
    return lenders[Math.mod(idx, lenders.size())];
}

public static String getBusinessType(String industry){

    Map<String,String> mapVal = new Map<String,String>{
        'Technology'=>'IT Services & Consulting',
        'Healthcare'=>'Medical Clinic & Pharmacy',
        'Retail'=>'Retail Trading Business',
        'Manufacturing'=>'Small Scale Manufacturing',
        'Real Estate'=>'Property Development',
        'Education'=>'Coaching & Training Institute'
    };

    return mapVal.containsKey(industry) ? mapVal.get(industry)
        : 'Trading & Services';
}


// ===== Main Method =====

public static void generateBusinessLoanAgreements(List<Account> accs){

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

        Decimal revenue = a.AnnualRevenue != null ? a.AnnualRevenue : 1000000;
        String industry = a.Industry != null ? a.Industry : 'Retail';

        String businessType = getBusinessType(industry);
        String businessName = a.LastName + ' ' + city.left(4) + ' Enterprises';

        Integer loanAmount = 500000 + Math.mod(hashVal, 4500000);
        loanAmount = Math.round(loanAmount / 50000) * 50000;

        Decimal rate = 11.0;
        Integer tenure = 84;

        Decimal monthlyRate = rate / 100 / 12;

        Integer emi = (Integer)(
            loanAmount * monthlyRate *
            (1 + monthlyRate * tenure) /
            ((1 + monthlyRate * tenure) - 1)
        );

        String lender = getLender(idx);

        String loanNo = 'BL/' +
            city.left(3).toUpperCase() +
            '/' +
            String.valueOf(Date.today().year() - Math.mod(hashVal,4)) +
            '/' +
            String.valueOf(300000 + Math.mod(hashVal,699999));

        String agreementDate = String.valueOf(
            Date.today().addMonths(-(6 + Math.mod(hashVal,48)))
        );

        String gst =
            state.left(2).toUpperCase() +
            'XXXXXXX' +
            String.valueOf(1000 + idx) + 'Z';

        Integer turnover = (Integer)(revenue * 3);

        List<String> lines = new List<String>{
            lender.toUpperCase(),
            'BUSINESS LOAN AGREEMENT',
            '=============================================',
            'Loan No         : ' + loanNo,
            'Agreement Date  : ' + agreementDate,
            '=============================================',
            'BORROWER:',
            name,
            'Address         : ' + address.left(70),
            '=============================================',
            'BUSINESS:',
            businessName,
            'Type            : ' + businessType,
            'GST             : ' + gst,
            'Turnover        : Rs ' + turnover,
            '=============================================',
            'LOAN DETAILS:',
            'Loan Amount     : Rs ' + loanAmount,
            'Rate            : ' + rate + '%',
            'Tenure          : ' + tenure + ' months',
            'EMI             : Rs ' + emi,
            '=============================================',
            'Lender          : ' + lender,
            '=============================================',
            'Borrower Sign: __________',
            'Bank Sign    : __________'
        };

        files.add(new ContentVersion(
            Title = 'Business Loan Agreement - ' + a.FirstName + ' ' + a.LastName,
            PathOnClient = 'BusinessLoan_' + a.FirstName + '_' + a.LastName + '.pdf',
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