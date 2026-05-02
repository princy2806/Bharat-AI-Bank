public with sharing class MutualFundStatementPdfService {

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

public static String getFund(Integer idx){
    List<String> funds = new List<String>{
        'AXIS BLUECHIP FUND','HDFC FLEXI CAP FUND','MIRAE ASSET LARGE CAP',
        'ICICI PRU BALANCED ADVANTAGE','SBI SMALL CAP',
        'KOTAK EMERGING EQUITY','PARAG PARIKH FLEXI CAP',
        'NIPPON INDIA GROWTH','DSP MIDCAP','ADITYA BIRLA FRONTLINE'
    };
    return funds[Math.mod(idx, funds.size())];
}

public static String getAMC(Integer idx){
    List<String> amcs = new List<String>{
        'Axis AMC','HDFC AMC','Mirae Asset','ICICI Prudential',
        'SBI Funds','Kotak AMC','PPFAS AMC','Nippon India',
        'DSP Investment','Aditya Birla'
    };
    return amcs[Math.mod(idx, amcs.size())];
}

public static String getRegistrar(Integer idx){
    return Math.mod(idx,2) == 0
        ? 'CAMS' : 'KFintech';
}

public static String getFolio(String amc, Integer idx){
    return amc.left(4).toUpperCase().replace(' ','') +
           '/' + String.valueOf(1000000 + Math.mod(idx*7,8999999));
}


// ===== Main Method =====

public static void generateMutualFundStatements(List<Account> accs){

    List<ContentVersion> files = new List<ContentVersion>();
    Integer idx = 0;

    for(Account a : accs){

        String name = (a.FirstName + ' ' + a.LastName).toUpperCase();
        Integer hv = Math.abs(a.Id.hashCode());

        String city = a.BillingCity != null ? a.BillingCity : 'CITY';
        Decimal revenue = a.AnnualRevenue != null ? a.AnnualRevenue : 600000;

        String fund = getFund(idx);
        String amc = getAMC(idx);
        String registrar = getRegistrar(idx);
        String folio = getFolio(amc, hv);

        Integer monthly = (Integer)(revenue / 12);
        Integer sip = Math.max(1000, (Integer)(monthly * 0.1));

        Integer months = 12 + Math.mod(hv,60);
        Integer invested = sip * months;

        Decimal xirr = 12 + Math.mod(hv,8);
        Decimal nav = 100 + Math.mod(hv,300);

        Integer currentValue = (Integer)(invested * (1 + xirr/100));
        Integer units = (Integer)(currentValue / nav);

        List<String> lines = new List<String>{
            'MUTUAL FUND STATEMENT',
            '=============================================',
            'Investor        : ' + name,
            'City            : ' + city,
            '=============================================',
            'Folio           : ' + folio,
            'AMC             : ' + amc,
            'Fund            : ' + fund,
            '=============================================',
            'Invested        : Rs ' + invested,
            'Units           : ' + units,
            'NAV             : Rs ' + (Integer)nav,
            'Current Value   : Rs ' + currentValue,
            'Returns (XIRR)  : ' + (Integer)xirr + '%',
            '=============================================',
            'SIP Amount      : Rs ' + sip,
            'SIP Duration    : ' + months + ' months',
            '=============================================',
            'Registrar       : ' + registrar,
            '============================================='
        };

        files.add(new ContentVersion(
            Title = 'MF Statement - ' + a.FirstName + ' ' + a.LastName,
            PathOnClient = 'MF_' + a.FirstName + '_' + a.LastName + '.pdf',
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