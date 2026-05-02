// Step 5: Insert Credit Information (CIBIL Scores) for all person accounts
// Run AFTER 01_insert_person_accounts.apex

Map<String, Id> accMap = new Map<String, Id>();
for (Account a : [
    SELECT Id, FirstName, LastName
    FROM Account
    WHERE LastName IN ('Sharma','Patel','Kumar','Devi','Singh','Nair','Gupta','Reddy','Verma')
    AND IsPersonAccount = true
    ORDER BY CreatedDate DESC
]) {
    accMap.put(a.FirstName + ' ' + a.LastName, a.Id);
}

List<FinServ__CreditInformation__c> creditInfos = new List<FinServ__CreditInformation__c>{
    new FinServ__CreditInformation__c(
        Name = 'CIBIL Report - Rajesh Sharma',
        FinServ__Account__c = accMap.get('Rajesh Sharma'),
        FinServ__CreditScore__c = 742,
        FinServ__CreditScoreAgency__c = 'TransUnion CIBIL',
        FinServ__ReportDate__c = Date.today().addDays(-15),
        FinServ__Description__c = 'Score: 742 (Good). Active loans: Home Loan. CC outstanding: Rs 45,200. Payment history: 11/12 on-time. 1 late payment (30 days) in 2023. No defaults. Annual income declared: Rs 8.5L.'
    ),
    new FinServ__CreditInformation__c(
        Name = 'CIBIL Report - Priya Patel',
        FinServ__Account__c = accMap.get('Priya Patel'),
        FinServ__CreditScore__c = 798,
        FinServ__CreditScoreAgency__c = 'TransUnion CIBIL',
        FinServ__ReportDate__c = Date.today().addDays(-10),
        FinServ__Description__c = 'Score: 798 (Very Good). No active loans. CC outstanding: Rs 18,700. Payment history: 24/24 on-time. No defaults. Annual income declared: Rs 12L. SIP investor since 2019.'
    ),
    new FinServ__CreditInformation__c(
        Name = 'CIBIL Report - Amit Kumar',
        FinServ__Account__c = accMap.get('Amit Kumar'),
        FinServ__CreditScore__c = 761,
        FinServ__CreditScoreAgency__c = 'Experian',
        FinServ__ReportDate__c = Date.today().addDays(-20),
        FinServ__Description__c = 'Score: 761 (Good). Active loans: Home Loan. CC outstanding: Rs 32,100. Payment history: 35/36 on-time. No defaults. FD holder. Govt employee - stable income.'
    ),
    new FinServ__CreditInformation__c(
        Name = 'CIBIL Report - Sunita Devi',
        FinServ__Account__c = accMap.get('Sunita Devi'),
        FinServ__CreditScore__c = 715,
        FinServ__CreditScoreAgency__c = 'TransUnion CIBIL',
        FinServ__ReportDate__c = Date.today().addDays(-8),
        FinServ__Description__c = 'Score: 715 (Good). Business owner. CC outstanding: Rs 78,500 (high utilization - 57%). 3 late payments in last 18 months. No defaults. Annual income: Rs 18L.'
    ),
    new FinServ__CreditInformation__c(
        Name = 'CIBIL Report - Vikram Singh',
        FinServ__Account__c = accMap.get('Vikram Singh'),
        FinServ__CreditScore__c = 778,
        FinServ__CreditScoreAgency__c = 'TransUnion CIBIL',
        FinServ__ReportDate__c = Date.today().addDays(-12),
        FinServ__Description__c = 'Score: 778 (Very Good). Active loans: Home Loan. CC outstanding: Rs 22,300. Payment history: 48/48 on-time. No defaults. Annual income: Rs 15L. IT sector - stable.'
    ),
    new FinServ__CreditInformation__c(
        Name = 'CIBIL Report - Meera Nair',
        FinServ__Account__c = accMap.get('Meera Nair'),
        FinServ__CreditScore__c = 812,
        FinServ__CreditScoreAgency__c = 'CRIF High Mark',
        FinServ__ReportDate__c = Date.today().addDays(-5),
        FinServ__Description__c = 'Score: 812 (Excellent). No active loans. CC outstanding: Rs 15,600. Payment history: 36/36 on-time. No defaults. Annual income: Rs 18L. High SIP disciplined investor.'
    ),
    new FinServ__CreditInformation__c(
        Name = 'CIBIL Report - Suresh Gupta',
        FinServ__Account__c = accMap.get('Suresh Gupta'),
        FinServ__CreditScore__c = 731,
        FinServ__CreditScoreAgency__c = 'Experian',
        FinServ__ReportDate__c = Date.today().addDays(-18),
        FinServ__Description__c = 'Score: 731 (Good). Active loans: Home Loan (Rs 1.2Cr). CC outstanding: Rs 95,000 (high). 2 late payments in 2022. No defaults. Annual income: Rs 35L. Business - textile export.'
    ),
    new FinServ__CreditInformation__c(
        Name = 'CIBIL Report - Kavitha Reddy',
        FinServ__Account__c = accMap.get('Kavitha Reddy'),
        FinServ__CreditScore__c = 784,
        FinServ__CreditScoreAgency__c = 'TransUnion CIBIL',
        FinServ__ReportDate__c = Date.today().addDays(-7),
        FinServ__Description__c = 'Score: 784 (Very Good). No active loans. CC outstanding: Rs 28,400. Payment history: 30/30 on-time. No defaults. Annual income: Rs 11L. Pharma sector.'
    ),
    new FinServ__CreditInformation__c(
        Name = 'CIBIL Report - Rohit Verma',
        FinServ__Account__c = accMap.get('Rohit Verma'),
        FinServ__CreditScore__c = 756,
        FinServ__CreditScoreAgency__c = 'TransUnion CIBIL',
        FinServ__ReportDate__c = Date.today().addDays(-14),
        FinServ__Description__c = 'Score: 756 (Good). Active loans: Home Loan. CC outstanding: Rs 41,200. Payment history: 40/42 on-time. 2 late payments. No defaults. Annual income: Rs 13L.'
    ),
    new FinServ__CreditInformation__c(
        Name = 'CIBIL Report - Anita Sharma',
        FinServ__Account__c = accMap.get('Anita Sharma'),
        FinServ__CreditScore__c = 769,
        FinServ__CreditScoreAgency__c = 'CRIF High Mark',
        FinServ__ReportDate__c = Date.today().addDays(-9),
        FinServ__Description__c = 'Score: 769 (Good). No active loans. CC outstanding: Rs 19,800. Payment history: 36/36 on-time. No defaults. Annual income: Rs 9L. Self-employed designer.'
    )
};

insert creditInfos;
System.debug('Inserted ' + creditInfos.size() + ' Credit Information records.');
