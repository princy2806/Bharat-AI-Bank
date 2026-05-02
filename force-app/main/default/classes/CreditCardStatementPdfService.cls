public with sharing class CreditCardStatementPdfService {

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

public static String getBank(Integer idx){
    List<String> banks = new List<String>{
        'HDFC Bank','ICICI Bank','SBI Card','Axis Bank',
        'Kotak Mahindra Bank','American Express','Citibank','Standard Chartered'
    };
    return banks[Math.mod(idx, banks.size())];
}

public static String getCardType(Integer idx){
    List<String> types = new List<String>{
        'Regalia Gold','Millennia','SimplySAVE','My Zone',
        'Platinum','Gold Charge','Cashback','Manhattan Platinum'
    };
    return types[Math.mod(idx, types.size())];
}


// ===== Main Method =====

public static void generateStatements(List<Account> accs){

    List<ContentVersion> files = new List<ContentVersion>();
    Integer idx = 0;

    for(Account a : accs){

        String name = (a.FirstName + ' ' + a.LastName).toUpperCase();
        Integer hashVal = Math.abs(a.Id.hashCode());

        String bank = getBank(idx);
        String cardType = getCardType(idx);

        Decimal revenue = a.AnnualRevenue != null ? a.AnnualRevenue : 500000;

        Integer revenueNumber = (Integer)Math.min(500000, Math.max(50000, (Integer)(revenue / 10)));
        revenueNumber = Math.round(revenueNumber / 10000) * 10000;

        Integer outstanding = Math.mod(hashVal, revenueNumber / 2);
        outstanding = Math.round(outstanding / 100) * 100;

        Integer minDue = (Integer)(outstanding * 0.05);

        String cardNumber = 'XXXX XXXX XXXX ' + String.valueOf(1000 + Math.mod(hashVal, 9000));

        Date today = Date.today();
        String statementDate = String.valueOf(today.addDays(-5));
        String dueDate = String.valueOf(today.addDays(15));

        List<String> lines = new List<String>{
            bank.toUpperCase() + ' CREDIT CARD',
            cardType.toUpperCase() + ' - MONTHLY STATEMENT',
            '=============================================',
            'Card Number      : ' + cardNumber,
            'Card Holder      : ' + name,
            'Statement Period : ' + String.valueOf(today.addDays(-35)) + ' to ' + statementDate,
            'Payment Due Date : ' + dueDate,
            '=============================================',
            'ACCOUNT SUMMARY:',
            'Credit Limit     : Rs ' + revenueNumber,
            'Available Credit : Rs ' + (revenueNumber - outstanding),
            'Total Outstanding: Rs ' + outstanding,
            'Minimum Due      : Rs ' + minDue,
            '=============================================',
            'TRANSACTIONS:',
            '2026-03-02  Amazon Online Shopping     Rs 3,450',
            '2026-03-05  Petrol Pump               Rs 2,500',
            '2026-03-08  Swiggy                    Rs 1,200',
            '2026-03-12  Pharmacy                  Rs 850',
            '2026-03-15  Utility Bill              Rs 2,100',
            '2026-03-18  Grocery                   Rs 4,300',
            '2026-03-22  Restaurant                Rs 1,800',
            '2026-03-25  OTT Subscription          Rs 499',
            '=============================================',
            'REWARDS: ' + String.valueOf(Math.mod(hashVal,5000)+500) + ' points',
            'CASHBACK: Rs ' + String.valueOf(Math.mod(hashVal,300)+50),
            '=============================================',
            'Interest Rate : 3.75% per month',
            'Payment Modes : UPI | NetBanking | NEFT'
        };

        files.add(new ContentVersion(
            Title = 'Credit Card Statement - ' + a.FirstName + ' ' + a.LastName,
            PathOnClient = 'CreditCard_' + a.FirstName + '_' + a.LastName + '.pdf',
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