// Step 2: Insert FSC Financial Accounts (Savings/Current Bank Accounts)
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

Id bankRTId = Schema.SObjectType.FinServ__FinancialAccount__c
    .getRecordTypeInfosByDeveloperName().get('BankAccount').getRecordTypeId();

List<FinServ__FinancialAccount__c> bankAccounts = new List<FinServ__FinancialAccount__c>{
    // Rajesh Sharma - Savings Account (Indore)
    new FinServ__FinancialAccount__c(
        Name = 'Savings Account - Rajesh Sharma',
        RecordTypeId = bankRTId,
        FinServ__PrimaryOwner__c = accMap.get('Rajesh Sharma'),
        FinServ__Balance__c = 125450.75,
        FinServ__FinancialAccountNumber__c = 'SB00123456789',
        FinServ__Status__c = 'Open',
        FinServ__OpenDate__c = Date.valueOf('2015-03-10'),
        FinServ__AnnualIncome__c = 850000,
        FinServ__Description__c = 'Primary savings account - WhatsApp banking enabled'
    ),
    // Priya Patel - Savings Account (Mumbai)
    new FinServ__FinancialAccount__c(
        Name = 'Savings Account - Priya Patel',
        RecordTypeId = bankRTId,
        FinServ__PrimaryOwner__c = accMap.get('Priya Patel'),
        FinServ__Balance__c = 89320.50,
        FinServ__FinancialAccountNumber__c = 'SB00234567890',
        FinServ__Status__c = 'Open',
        FinServ__OpenDate__c = Date.valueOf('2018-07-15'),
        FinServ__AnnualIncome__c = 1200000,
        FinServ__Description__c = 'Salary account - SIP linked'
    ),
    // Amit Kumar - Savings Account (Delhi)
    new FinServ__FinancialAccount__c(
        Name = 'Savings Account - Amit Kumar',
        RecordTypeId = bankRTId,
        FinServ__PrimaryOwner__c = accMap.get('Amit Kumar'),
        FinServ__Balance__c = 245680.25,
        FinServ__FinancialAccountNumber__c = 'SB00345678901',
        FinServ__Status__c = 'Open',
        FinServ__OpenDate__c = Date.valueOf('2010-01-20'),
        FinServ__AnnualIncome__c = 950000,
        FinServ__Description__c = 'Govt salary account - FD linked'
    ),
    // Sunita Devi - Current Account (Jaipur)
    new FinServ__FinancialAccount__c(
        Name = 'Current Account - Sunita Devi',
        RecordTypeId = bankRTId,
        FinServ__PrimaryOwner__c = accMap.get('Sunita Devi'),
        FinServ__Balance__c = 378900.00,
        FinServ__FinancialAccountNumber__c = 'CA00456789012',
        FinServ__Status__c = 'Open',
        FinServ__OpenDate__c = Date.valueOf('2012-09-05'),
        FinServ__AnnualIncome__c = 1800000,
        FinServ__Description__c = 'Business current account'
    ),
    // Vikram Singh - Savings Account (Pune)
    new FinServ__FinancialAccount__c(
        Name = 'Savings Account - Vikram Singh',
        RecordTypeId = bankRTId,
        FinServ__PrimaryOwner__c = accMap.get('Vikram Singh'),
        FinServ__Balance__c = 56780.00,
        FinServ__FinancialAccountNumber__c = 'SB00567890123',
        FinServ__Status__c = 'Open',
        FinServ__OpenDate__c = Date.valueOf('2016-05-18'),
        FinServ__AnnualIncome__c = 1500000,
        FinServ__Description__c = 'Primary savings account'
    ),
    // Meera Nair - Savings Account (Bangalore)
    new FinServ__FinancialAccount__c(
        Name = 'Savings Account - Meera Nair',
        RecordTypeId = bankRTId,
        FinServ__PrimaryOwner__c = accMap.get('Meera Nair'),
        FinServ__Balance__c = 112340.80,
        FinServ__FinancialAccountNumber__c = 'SB00678901234',
        FinServ__Status__c = 'Open',
        FinServ__OpenDate__c = Date.valueOf('2019-02-28'),
        FinServ__AnnualIncome__c = 1800000,
        FinServ__Description__c = 'Salary account - SIP and Mutual Fund linked'
    ),
    // Suresh Gupta - Current Account (Ahmedabad)
    new FinServ__FinancialAccount__c(
        Name = 'Current Account - Suresh Gupta',
        RecordTypeId = bankRTId,
        FinServ__PrimaryOwner__c = accMap.get('Suresh Gupta'),
        FinServ__Balance__c = 520450.60,
        FinServ__FinancialAccountNumber__c = 'CA00789012345',
        FinServ__Status__c = 'Open',
        FinServ__OpenDate__c = Date.valueOf('2008-11-12'),
        FinServ__AnnualIncome__c = 3500000,
        FinServ__Description__c = 'Textile business current account'
    ),
    // Kavitha Reddy - Savings Account (Hyderabad)
    new FinServ__FinancialAccount__c(
        Name = 'Savings Account - Kavitha Reddy',
        RecordTypeId = bankRTId,
        FinServ__PrimaryOwner__c = accMap.get('Kavitha Reddy'),
        FinServ__Balance__c = 78900.25,
        FinServ__FinancialAccountNumber__c = 'SB00890123456',
        FinServ__Status__c = 'Open',
        FinServ__OpenDate__c = Date.valueOf('2017-08-01'),
        FinServ__AnnualIncome__c = 1100000,
        FinServ__Description__c = 'Salary account'
    ),
    // Rohit Verma - Savings Account (Chennai)
    new FinServ__FinancialAccount__c(
        Name = 'Savings Account - Rohit Verma',
        RecordTypeId = bankRTId,
        FinServ__PrimaryOwner__c = accMap.get('Rohit Verma'),
        FinServ__Balance__c = 43210.50,
        FinServ__FinancialAccountNumber__c = 'SB00901234567',
        FinServ__Status__c = 'Open',
        FinServ__OpenDate__c = Date.valueOf('2014-06-22'),
        FinServ__AnnualIncome__c = 1300000,
        FinServ__Description__c = 'Primary savings account'
    ),
    // Anita Sharma - Savings Account (Kolkata)
    new FinServ__FinancialAccount__c(
        Name = 'Savings Account - Anita Sharma',
        RecordTypeId = bankRTId,
        FinServ__PrimaryOwner__c = accMap.get('Anita Sharma'),
        FinServ__Balance__c = 95670.00,
        FinServ__FinancialAccountNumber__c = 'SB00012345678',
        FinServ__Status__c = 'Open',
        FinServ__OpenDate__c = Date.valueOf('2013-04-07'),
        FinServ__AnnualIncome__c = 900000,
        FinServ__Description__c = 'Business savings account'
    )
};

insert bankAccounts;
System.debug('Inserted ' + bankAccounts.size() + ' FSC Bank Accounts.');
