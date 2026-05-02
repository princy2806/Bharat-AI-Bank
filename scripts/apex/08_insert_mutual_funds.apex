// Step 8: Insert Mutual Fund / SIP Accounts (FSC Financial Holdings)
// For customers with MF/SIP: Rajesh Sharma, Priya Patel, Sunita Devi,
// Meera Nair, Kavitha Reddy, Anita Sharma
// Run AFTER 01_insert_person_accounts.apex

Map<String, Id> accMap = new Map<String, Id>();
for (Account a : [
    SELECT Id, FirstName, LastName
    FROM Account
    WHERE LastName IN ('Sharma','Patel','Devi','Nair','Reddy')
    AND IsPersonAccount = true
    ORDER BY CreatedDate DESC
]) {
    accMap.put(a.FirstName + ' ' + a.LastName, a.Id);
}
// Also get Anita Sharma separately to avoid conflict with Rajesh Sharma
for (Account a : [
    SELECT Id, FirstName, LastName
    FROM Account
    WHERE FirstName = 'Anita' AND LastName = 'Sharma'
    AND IsPersonAccount = true
    LIMIT 1
]) {
    accMap.put('Anita Sharma', a.Id);
}

Id mfRTId;
try {
    mfRTId = Schema.SObjectType.FinServ__FinancialAccount__c
        .getRecordTypeInfosByDeveloperName().get('MutualFund').getRecordTypeId();
} catch (Exception e) {
    // Fallback if MutualFund RT not available
    mfRTId = Schema.SObjectType.FinServ__FinancialAccount__c
        .getRecordTypeInfosByDeveloperName().get('BankAccount').getRecordTypeId();
    System.debug('MutualFund RT not found, using BankAccount RT. Adjust RecordType as needed.');
}

List<FinServ__FinancialAccount__c> mfAccounts = new List<FinServ__FinancialAccount__c>{
    new FinServ__FinancialAccount__c(
        Name = 'Mutual Fund SIP - Rajesh Sharma',
        RecordTypeId = mfRTId,
        FinServ__PrimaryOwner__c = accMap.get('Rajesh Sharma'),
        FinServ__Balance__c = 285000.00,
        FinServ__FinancialAccountNumber__c = 'MF00123456789',
        FinServ__Status__c = 'Open',
        FinServ__OpenDate__c = Date.valueOf('2020-01-10'),
        FinServ__Description__c = 'Axis Bluechip Fund - Monthly SIP Rs 5,000. Total units: 1,450. NAV: Rs 196.55. Return: 14.2% CAGR.'
    ),
    new FinServ__FinancialAccount__c(
        Name = 'Mutual Fund SIP - Priya Patel',
        RecordTypeId = mfRTId,
        FinServ__PrimaryOwner__c = accMap.get('Priya Patel'),
        FinServ__Balance__c = 520000.00,
        FinServ__FinancialAccountNumber__c = 'MF00234567890',
        FinServ__Status__c = 'Open',
        FinServ__OpenDate__c = Date.valueOf('2019-05-01'),
        FinServ__Description__c = 'HDFC Flexi Cap Fund - Monthly SIP Rs 10,000. Total invested: Rs 4,20,000. Current value: Rs 5,20,000. Return: 16.5% CAGR.'
    ),
    new FinServ__FinancialAccount__c(
        Name = 'Mutual Fund - Sunita Devi',
        RecordTypeId = mfRTId,
        FinServ__PrimaryOwner__c = accMap.get('Sunita Devi'),
        FinServ__Balance__c = 850000.00,
        FinServ__FinancialAccountNumber__c = 'MF00345678901',
        FinServ__Status__c = 'Open',
        FinServ__OpenDate__c = Date.valueOf('2018-03-15'),
        FinServ__Description__c = 'Mirae Asset Large Cap + ICICI Balanced Fund. Monthly SIP Rs 30,000. Total invested: Rs 7,20,000. Current value: Rs 8,50,000. Return: 13.8% CAGR.'
    ),
    new FinServ__FinancialAccount__c(
        Name = 'Mutual Fund SIP - Meera Nair',
        RecordTypeId = mfRTId,
        FinServ__PrimaryOwner__c = accMap.get('Meera Nair'),
        FinServ__Balance__c = 680000.00,
        FinServ__FinancialAccountNumber__c = 'MF00456789012',
        FinServ__Status__c = 'Open',
        FinServ__OpenDate__c = Date.valueOf('2020-04-01'),
        FinServ__Description__c = 'Mirae Asset Emerging Bluechip Fund - Monthly SIP Rs 15,000. Total invested: Rs 5,40,000. Current value: Rs 6,80,000. Return: 18.2% CAGR.'
    ),
    new FinServ__FinancialAccount__c(
        Name = 'Mutual Fund SIP - Kavitha Reddy',
        RecordTypeId = mfRTId,
        FinServ__PrimaryOwner__c = accMap.get('Kavitha Reddy'),
        FinServ__Balance__c = 340000.00,
        FinServ__FinancialAccountNumber__c = 'MF00567890123',
        FinServ__Status__c = 'Open',
        FinServ__OpenDate__c = Date.valueOf('2021-01-15'),
        FinServ__Description__c = 'ICICI Prudential Technology Fund - Monthly SIP Rs 10,000. Total invested: Rs 2,90,000. Current value: Rs 3,40,000. Return: 12.9% CAGR.'
    ),
    new FinServ__FinancialAccount__c(
        Name = 'Mutual Fund - Anita Sharma',
        RecordTypeId = mfRTId,
        FinServ__PrimaryOwner__c = accMap.get('Anita Sharma'),
        FinServ__Balance__c = 195000.00,
        FinServ__FinancialAccountNumber__c = 'MF00678901234',
        FinServ__Status__c = 'Open',
        FinServ__OpenDate__c = Date.valueOf('2019-08-20'),
        FinServ__Description__c = 'ABSL Frontline Equity Fund - Monthly SIP Rs 5,000. Total invested: Rs 1,55,000. Current value: Rs 1,95,000. Return: 15.1% CAGR.'
    )
};

insert mfAccounts;
System.debug('Inserted ' + mfAccounts.size() + ' Mutual Fund / SIP accounts.');
