// Step 4: Insert Credit Cards and Home Loans as FSC Financial Accounts
// Run AFTER 02_insert_financial_accounts.apex

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

Id creditCardRTId = Schema.SObjectType.FinServ__FinancialAccount__c
    .getRecordTypeInfosByDeveloperName().get('CreditCard').getRecordTypeId();

Id loanRTId = Schema.SObjectType.FinServ__FinancialAccount__c
    .getRecordTypeInfosByDeveloperName().get('Loan').getRecordTypeId();

// ===================== CREDIT CARDS =====================
List<FinServ__FinancialAccount__c> creditCards = new List<FinServ__FinancialAccount__c>{
    new FinServ__FinancialAccount__c(
        Name = 'Credit Card - Rajesh Sharma',
        RecordTypeId = creditCardRTId,
        FinServ__PrimaryOwner__c = accMap.get('Rajesh Sharma'),
        FinServ__Balance__c = -45200.00,
        FinServ__FinancialAccountNumber__c = 'CC4532XXXX4891',
        FinServ__Status__c = 'Open',
        FinServ__OpenDate__c = Date.valueOf('2017-08-01'),
        FinServ__CreditLimit__c = 200000,
        FinServ__Description__c = 'HDFC Millennia Credit Card - Rs 200,000 limit'
    ),
    new FinServ__FinancialAccount__c(
        Name = 'Credit Card - Priya Patel',
        RecordTypeId = creditCardRTId,
        FinServ__PrimaryOwner__c = accMap.get('Priya Patel'),
        FinServ__Balance__c = -18700.00,
        FinServ__FinancialAccountNumber__c = 'CC5241XXXX7823',
        FinServ__Status__c = 'Open',
        FinServ__OpenDate__c = Date.valueOf('2019-05-10'),
        FinServ__CreditLimit__c = 300000,
        FinServ__Description__c = 'Axis Bank Ace Card - Rs 300,000 limit'
    ),
    new FinServ__FinancialAccount__c(
        Name = 'Credit Card - Amit Kumar',
        RecordTypeId = creditCardRTId,
        FinServ__PrimaryOwner__c = accMap.get('Amit Kumar'),
        FinServ__Balance__c = -32100.00,
        FinServ__FinancialAccountNumber__c = 'CC4111XXXX2345',
        FinServ__Status__c = 'Open',
        FinServ__OpenDate__c = Date.valueOf('2016-03-15'),
        FinServ__CreditLimit__c = 150000,
        FinServ__Description__c = 'SBI SimplyCLICK Card - Rs 150,000 limit'
    ),
    new FinServ__FinancialAccount__c(
        Name = 'Credit Card - Sunita Devi',
        RecordTypeId = creditCardRTId,
        FinServ__PrimaryOwner__c = accMap.get('Sunita Devi'),
        FinServ__Balance__c = -78500.00,
        FinServ__FinancialAccountNumber__c = 'CC5425XXXX9012',
        FinServ__Status__c = 'Open',
        FinServ__OpenDate__c = Date.valueOf('2015-11-20'),
        FinServ__CreditLimit__c = 500000,
        FinServ__Description__c = 'ICICI Business Advantage Card - Rs 500,000 limit'
    ),
    new FinServ__FinancialAccount__c(
        Name = 'Credit Card - Vikram Singh',
        RecordTypeId = creditCardRTId,
        FinServ__PrimaryOwner__c = accMap.get('Vikram Singh'),
        FinServ__Balance__c = -22300.00,
        FinServ__FinancialAccountNumber__c = 'CC4532XXXX6789',
        FinServ__Status__c = 'Open',
        FinServ__OpenDate__c = Date.valueOf('2018-09-25'),
        FinServ__CreditLimit__c = 250000,
        FinServ__Description__c = 'HDFC Regalia Card - Rs 250,000 limit'
    ),
    new FinServ__FinancialAccount__c(
        Name = 'Credit Card - Meera Nair',
        RecordTypeId = creditCardRTId,
        FinServ__PrimaryOwner__c = accMap.get('Meera Nair'),
        FinServ__Balance__c = -15600.00,
        FinServ__FinancialAccountNumber__c = 'CC5241XXXX3456',
        FinServ__Status__c = 'Open',
        FinServ__OpenDate__c = Date.valueOf('2020-02-14'),
        FinServ__CreditLimit__c = 350000,
        FinServ__Description__c = 'American Express Platinum Travel - Rs 350,000 limit'
    ),
    new FinServ__FinancialAccount__c(
        Name = 'Credit Card - Suresh Gupta',
        RecordTypeId = creditCardRTId,
        FinServ__PrimaryOwner__c = accMap.get('Suresh Gupta'),
        FinServ__Balance__c = -95000.00,
        FinServ__FinancialAccountNumber__c = 'CC4111XXXX7890',
        FinServ__Status__c = 'Open',
        FinServ__OpenDate__c = Date.valueOf('2012-06-01'),
        FinServ__CreditLimit__c = 1000000,
        FinServ__Description__c = 'Kotak Corporate Card - Rs 10,00,000 limit'
    ),
    new FinServ__FinancialAccount__c(
        Name = 'Credit Card - Kavitha Reddy',
        RecordTypeId = creditCardRTId,
        FinServ__PrimaryOwner__c = accMap.get('Kavitha Reddy'),
        FinServ__Balance__c = -28400.00,
        FinServ__FinancialAccountNumber__c = 'CC5425XXXX1234',
        FinServ__Status__c = 'Open',
        FinServ__OpenDate__c = Date.valueOf('2018-04-10'),
        FinServ__CreditLimit__c = 200000,
        FinServ__Description__c = 'IndusInd Pinnacle Card - Rs 200,000 limit'
    ),
    new FinServ__FinancialAccount__c(
        Name = 'Credit Card - Rohit Verma',
        RecordTypeId = creditCardRTId,
        FinServ__PrimaryOwner__c = accMap.get('Rohit Verma'),
        FinServ__Balance__c = -41200.00,
        FinServ__FinancialAccountNumber__c = 'CC4532XXXX5678',
        FinServ__Status__c = 'Open',
        FinServ__OpenDate__c = Date.valueOf('2016-10-05'),
        FinServ__CreditLimit__c = 250000,
        FinServ__Description__c = 'SBI SimplySAVE Card - Rs 250,000 limit'
    ),
    new FinServ__FinancialAccount__c(
        Name = 'Credit Card - Anita Sharma',
        RecordTypeId = creditCardRTId,
        FinServ__PrimaryOwner__c = accMap.get('Anita Sharma'),
        FinServ__Balance__c = -19800.00,
        FinServ__FinancialAccountNumber__c = 'CC5241XXXX2345',
        FinServ__Status__c = 'Open',
        FinServ__OpenDate__c = Date.valueOf('2017-07-20'),
        FinServ__CreditLimit__c = 150000,
        FinServ__Description__c = 'Standard Chartered Manhattan Card - Rs 150,000 limit'
    )
};

insert creditCards;
System.debug('Inserted ' + creditCards.size() + ' Credit Card accounts.');

// ===================== HOME LOANS =====================
List<FinServ__FinancialAccount__c> loans = new List<FinServ__FinancialAccount__c>{
    // Rajesh Sharma - Home Loan (Indore property)
    new FinServ__FinancialAccount__c(
        Name = 'Home Loan - Rajesh Sharma',
        RecordTypeId = loanRTId,
        FinServ__PrimaryOwner__c = accMap.get('Rajesh Sharma'),
        FinServ__Balance__c = -3250000.00,
        FinServ__FinancialAccountNumber__c = 'HL00123456789',
        FinServ__Status__c = 'Open',
        FinServ__OpenDate__c = Date.valueOf('2018-04-01'),
        FinServ__LoanAmount__c = 4000000,
        FinServ__InterestRate__c = 8.65,
        FinServ__LoanTerm__c = 240,
        FinServ__NextPaymentAmount__c = 18450,
        FinServ__NextPaymentDate__c = Date.today().addDays(5),
        FinServ__Description__c = 'Home Loan - 2BHK Flat, Vijay Nagar Indore. Original: Rs 40L, 20 years @ 8.65%. EMI: Rs 18,450. Restructuring requested due to medical emergency.'
    ),
    // Amit Kumar - Home Loan (Delhi property)
    new FinServ__FinancialAccount__c(
        Name = 'Home Loan - Amit Kumar',
        RecordTypeId = loanRTId,
        FinServ__PrimaryOwner__c = accMap.get('Amit Kumar'),
        FinServ__Balance__c = -5100000.00,
        FinServ__FinancialAccountNumber__c = 'HL00234567890',
        FinServ__Status__c = 'Open',
        FinServ__OpenDate__c = Date.valueOf('2016-09-15'),
        FinServ__LoanAmount__c = 6500000,
        FinServ__InterestRate__c = 8.40,
        FinServ__LoanTerm__c = 300,
        FinServ__NextPaymentAmount__c = 22300,
        FinServ__NextPaymentDate__c = Date.today().addDays(8),
        FinServ__Description__c = 'Home Loan - 3BHK Apartment, Lajpat Nagar Delhi. Original: Rs 65L, 25 years @ 8.40%. EMI: Rs 22,300.'
    ),
    // Vikram Singh - Home Loan (Pune property)
    new FinServ__FinancialAccount__c(
        Name = 'Home Loan - Vikram Singh',
        RecordTypeId = loanRTId,
        FinServ__PrimaryOwner__c = accMap.get('Vikram Singh'),
        FinServ__Balance__c = -7200000.00,
        FinServ__FinancialAccountNumber__c = 'HL00345678901',
        FinServ__Status__c = 'Open',
        FinServ__OpenDate__c = Date.valueOf('2020-02-01'),
        FinServ__LoanAmount__c = 8000000,
        FinServ__InterestRate__c = 8.75,
        FinServ__LoanTerm__c = 300,
        FinServ__NextPaymentAmount__c = 28600,
        FinServ__NextPaymentDate__c = Date.today().addDays(3),
        FinServ__Description__c = 'Home Loan - 3BHK Flat, Koregaon Park Pune. Original: Rs 80L, 25 years @ 8.75%. EMI: Rs 28,600.'
    ),
    // Suresh Gupta - Home Loan (Ahmedabad property)
    new FinServ__FinancialAccount__c(
        Name = 'Home Loan - Suresh Gupta',
        RecordTypeId = loanRTId,
        FinServ__PrimaryOwner__c = accMap.get('Suresh Gupta'),
        FinServ__Balance__c = -9800000.00,
        FinServ__FinancialAccountNumber__c = 'HL00456789012',
        FinServ__Status__c = 'Open',
        FinServ__OpenDate__c = Date.valueOf('2014-05-10'),
        FinServ__LoanAmount__c = 12000000,
        FinServ__InterestRate__c = 8.50,
        FinServ__LoanTerm__c = 360,
        FinServ__NextPaymentAmount__c = 35200,
        FinServ__NextPaymentDate__c = Date.today().addDays(10),
        FinServ__Description__c = 'Home Loan - 4BHK Bungalow, Navrangpura Ahmedabad. Original: Rs 1.2Cr, 30 years @ 8.50%. EMI: Rs 35,200.'
    ),
    // Rohit Verma - Home Loan (Chennai property)
    new FinServ__FinancialAccount__c(
        Name = 'Home Loan - Rohit Verma',
        RecordTypeId = loanRTId,
        FinServ__PrimaryOwner__c = accMap.get('Rohit Verma'),
        FinServ__Balance__c = -4300000.00,
        FinServ__FinancialAccountNumber__c = 'HL00567890123',
        FinServ__Status__c = 'Open',
        FinServ__OpenDate__c = Date.valueOf('2019-11-01'),
        FinServ__LoanAmount__c = 5000000,
        FinServ__InterestRate__c = 8.80,
        FinServ__LoanTerm__c = 240,
        FinServ__NextPaymentAmount__c = 24500,
        FinServ__NextPaymentDate__c = Date.today().addDays(6),
        FinServ__Description__c = 'Home Loan - 2BHK Flat, Anna Nagar Chennai. Original: Rs 50L, 20 years @ 8.80%. EMI: Rs 24,500.'
    )
};

insert loans;
System.debug('Inserted ' + loans.size() + ' Home Loan accounts.');
