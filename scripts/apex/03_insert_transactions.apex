// Step 3: Insert FSC Transactions (Last 5-7 transactions per account)
// Run AFTER 02_insert_financial_accounts.apex

Map<String, Id> faMap = new Map<String, Id>();
for (FinServ__FinancialAccount__c fa : [
    SELECT Id, Name FROM FinServ__FinancialAccount__c
    WHERE Name LIKE '% Account %'
    ORDER BY CreatedDate DESC
]) {
    faMap.put(fa.Name, fa.Id);
}

List<FinServ__FinancialAccountTransaction__c> txns = new List<FinServ__FinancialAccountTransaction__c>();

// --- Rajesh Sharma Transactions ---
Id rajeshAccId = faMap.get('Savings Account - Rajesh Sharma');
txns.addAll(new List<FinServ__FinancialAccountTransaction__c>{
    new FinServ__FinancialAccountTransaction__c(
        Name = 'TXN-RS-001', FinServ__FinancialAccount__c = rajeshAccId,
        FinServ__Amount__c = -12500.00, FinServ__TransactionDate__c = Date.today().addDays(-2),
        FinServ__Description__c = 'POS - Goa Beach Resort', FinServ__TransactionType__c = 'Debit'
    ),
    new FinServ__FinancialAccountTransaction__c(
        Name = 'TXN-RS-002', FinServ__FinancialAccount__c = rajeshAccId,
        FinServ__Amount__c = 50000.00, FinServ__TransactionDate__c = Date.today().addDays(-5),
        FinServ__Description__c = 'NEFT Credit - Business Income', FinServ__TransactionType__c = 'Credit'
    ),
    new FinServ__FinancialAccountTransaction__c(
        Name = 'TXN-RS-003', FinServ__FinancialAccount__c = rajeshAccId,
        FinServ__Amount__c = -18450.00, FinServ__TransactionDate__c = Date.today().addDays(-7),
        FinServ__Description__c = 'EMI - Home Loan', FinServ__TransactionType__c = 'Debit'
    ),
    new FinServ__FinancialAccountTransaction__c(
        Name = 'TXN-RS-004', FinServ__FinancialAccount__c = rajeshAccId,
        FinServ__Amount__c = -3200.00, FinServ__TransactionDate__c = Date.today().addDays(-10),
        FinServ__Description__c = 'Amazon Pay - Online Shopping', FinServ__TransactionType__c = 'Debit'
    ),
    new FinServ__FinancialAccountTransaction__c(
        Name = 'TXN-RS-005', FinServ__FinancialAccount__c = rajeshAccId,
        FinServ__Amount__c = -5000.00, FinServ__TransactionDate__c = Date.today().addDays(-12),
        FinServ__Description__c = 'SIP - Axis Mutual Fund', FinServ__TransactionType__c = 'Debit'
    ),
    new FinServ__FinancialAccountTransaction__c(
        Name = 'TXN-RS-006', FinServ__FinancialAccount__c = rajeshAccId,
        FinServ__Amount__c = -850.00, FinServ__TransactionDate__c = Date.today().addDays(-15),
        FinServ__Description__c = 'Electricity Bill - MP Bijli', FinServ__TransactionType__c = 'Debit'
    ),
    new FinServ__FinancialAccountTransaction__c(
        Name = 'TXN-RS-007', FinServ__FinancialAccount__c = rajeshAccId,
        FinServ__Amount__c = 125000.00, FinServ__TransactionDate__c = Date.today().addDays(-20),
        FinServ__Description__c = 'Business Receipt - Client Payment', FinServ__TransactionType__c = 'Credit'
    )
});

// --- Priya Patel Transactions ---
Id priyaAccId = faMap.get('Savings Account - Priya Patel');
txns.addAll(new List<FinServ__FinancialAccountTransaction__c>{
    new FinServ__FinancialAccountTransaction__c(
        Name = 'TXN-PP-001', FinServ__FinancialAccount__c = priyaAccId,
        FinServ__Amount__c = 120000.00, FinServ__TransactionDate__c = Date.today().addDays(-1),
        FinServ__Description__c = 'Salary Credit - TCS Ltd', FinServ__TransactionType__c = 'Credit'
    ),
    new FinServ__FinancialAccountTransaction__c(
        Name = 'TXN-PP-002', FinServ__FinancialAccount__c = priyaAccId,
        FinServ__Amount__c = -10000.00, FinServ__TransactionDate__c = Date.today().addDays(-3),
        FinServ__Description__c = 'SIP - HDFC Flexi Cap Fund', FinServ__TransactionType__c = 'Debit'
    ),
    new FinServ__FinancialAccountTransaction__c(
        Name = 'TXN-PP-003', FinServ__FinancialAccount__c = priyaAccId,
        FinServ__Amount__c = -4500.00, FinServ__TransactionDate__c = Date.today().addDays(-8),
        FinServ__Description__c = 'Credit Card Payment - HDFC Bank', FinServ__TransactionType__c = 'Debit'
    ),
    new FinServ__FinancialAccountTransaction__c(
        Name = 'TXN-PP-004', FinServ__FinancialAccount__c = priyaAccId,
        FinServ__Amount__c = -2100.00, FinServ__TransactionDate__c = Date.today().addDays(-11),
        FinServ__Description__c = 'Swiggy - Food Delivery', FinServ__TransactionType__c = 'Debit'
    ),
    new FinServ__FinancialAccountTransaction__c(
        Name = 'TXN-PP-005', FinServ__FinancialAccount__c = priyaAccId,
        FinServ__Amount__c = -1800.00, FinServ__TransactionDate__c = Date.today().addDays(-14),
        FinServ__Description__c = 'Airtel Postpaid Bill', FinServ__TransactionType__c = 'Debit'
    )
});

// --- Amit Kumar Transactions ---
Id amitAccId = faMap.get('Savings Account - Amit Kumar');
txns.addAll(new List<FinServ__FinancialAccountTransaction__c>{
    new FinServ__FinancialAccountTransaction__c(
        Name = 'TXN-AK-001', FinServ__FinancialAccount__c = amitAccId,
        FinServ__Amount__c = 79167.00, FinServ__TransactionDate__c = Date.today().addDays(-2),
        FinServ__Description__c = 'Salary Credit - Govt of Delhi', FinServ__TransactionType__c = 'Credit'
    ),
    new FinServ__FinancialAccountTransaction__c(
        Name = 'TXN-AK-002', FinServ__FinancialAccount__c = amitAccId,
        FinServ__Amount__c = -22300.00, FinServ__TransactionDate__c = Date.today().addDays(-5),
        FinServ__Description__c = 'EMI - Home Loan SBI', FinServ__TransactionType__c = 'Debit'
    ),
    new FinServ__FinancialAccountTransaction__c(
        Name = 'TXN-AK-003', FinServ__FinancialAccount__c = amitAccId,
        FinServ__Amount__c = -50000.00, FinServ__TransactionDate__c = Date.today().addDays(-8),
        FinServ__Description__c = 'FD Renewal - 12 months', FinServ__TransactionType__c = 'Debit'
    ),
    new FinServ__FinancialAccountTransaction__c(
        Name = 'TXN-AK-004', FinServ__FinancialAccount__c = amitAccId,
        FinServ__Amount__c = -6500.00, FinServ__TransactionDate__c = Date.today().addDays(-12),
        FinServ__Description__c = 'Credit Card Bill Payment', FinServ__TransactionType__c = 'Debit'
    ),
    new FinServ__FinancialAccountTransaction__c(
        Name = 'TXN-AK-005', FinServ__FinancialAccount__c = amitAccId,
        FinServ__Amount__c = -1200.00, FinServ__TransactionDate__c = Date.today().addDays(-16),
        FinServ__Description__c = 'Jal Board - Water Bill', FinServ__TransactionType__c = 'Debit'
    )
});

// --- Vikram Singh Transactions ---
Id vikramAccId = faMap.get('Savings Account - Vikram Singh');
txns.addAll(new List<FinServ__FinancialAccountTransaction__c>{
    new FinServ__FinancialAccountTransaction__c(
        Name = 'TXN-VS-001', FinServ__FinancialAccount__c = vikramAccId,
        FinServ__Amount__c = 125000.00, FinServ__TransactionDate__c = Date.today().addDays(-1),
        FinServ__Description__c = 'Salary Credit - Infosys Ltd', FinServ__TransactionType__c = 'Credit'
    ),
    new FinServ__FinancialAccountTransaction__c(
        Name = 'TXN-VS-002', FinServ__FinancialAccount__c = vikramAccId,
        FinServ__Amount__c = -28600.00, FinServ__TransactionDate__c = Date.today().addDays(-4),
        FinServ__Description__c = 'Home Loan EMI - ICICI Bank', FinServ__TransactionType__c = 'Debit'
    ),
    new FinServ__FinancialAccountTransaction__c(
        Name = 'TXN-VS-003', FinServ__FinancialAccount__c = vikramAccId,
        FinServ__Amount__c = -8900.00, FinServ__TransactionDate__c = Date.today().addDays(-9),
        FinServ__Description__c = 'Amazon - Electronics Purchase', FinServ__TransactionType__c = 'Debit'
    ),
    new FinServ__FinancialAccountTransaction__c(
        Name = 'TXN-VS-004', FinServ__FinancialAccount__c = vikramAccId,
        FinServ__Amount__c = -3400.00, FinServ__TransactionDate__c = Date.today().addDays(-13),
        FinServ__Description__c = 'MSEDCL - Electricity Bill', FinServ__TransactionType__c = 'Debit'
    ),
    new FinServ__FinancialAccountTransaction__c(
        Name = 'TXN-VS-005', FinServ__FinancialAccount__c = vikramAccId,
        FinServ__Amount__c = -5000.00, FinServ__TransactionDate__c = Date.today().addDays(-17),
        FinServ__Description__c = 'Credit Card Payment - HDFC', FinServ__TransactionType__c = 'Debit'
    )
});

// --- Meera Nair Transactions ---
Id meeraAccId = faMap.get('Savings Account - Meera Nair');
txns.addAll(new List<FinServ__FinancialAccountTransaction__c>{
    new FinServ__FinancialAccountTransaction__c(
        Name = 'TXN-MN-001', FinServ__FinancialAccount__c = meeraAccId,
        FinServ__Amount__c = 150000.00, FinServ__TransactionDate__c = Date.today().addDays(-1),
        FinServ__Description__c = 'Salary Credit - Wipro Ltd', FinServ__TransactionType__c = 'Credit'
    ),
    new FinServ__FinancialAccountTransaction__c(
        Name = 'TXN-MN-002', FinServ__FinancialAccount__c = meeraAccId,
        FinServ__Amount__c = -15000.00, FinServ__TransactionDate__c = Date.today().addDays(-3),
        FinServ__Description__c = 'SIP - Mirae Asset Fund', FinServ__TransactionType__c = 'Debit'
    ),
    new FinServ__FinancialAccountTransaction__c(
        Name = 'TXN-MN-003', FinServ__FinancialAccount__c = meeraAccId,
        FinServ__Amount__c = -22000.00, FinServ__TransactionDate__c = Date.today().addDays(-6),
        FinServ__Description__c = 'House Rent Transfer', FinServ__TransactionType__c = 'Debit'
    ),
    new FinServ__FinancialAccountTransaction__c(
        Name = 'TXN-MN-004', FinServ__FinancialAccount__c = meeraAccId,
        FinServ__Amount__c = -4700.00, FinServ__TransactionDate__c = Date.today().addDays(-10),
        FinServ__Description__c = 'Nykaa - Beauty Products', FinServ__TransactionType__c = 'Debit'
    ),
    new FinServ__FinancialAccountTransaction__c(
        Name = 'TXN-MN-005', FinServ__FinancialAccount__c = meeraAccId,
        FinServ__Amount__c = -2800.00, FinServ__TransactionDate__c = Date.today().addDays(-14),
        FinServ__Description__c = 'BESCOM - Electricity', FinServ__TransactionType__c = 'Debit'
    )
});

// Add remaining accounts with 5 transactions each
Id sureshAccId = faMap.get('Current Account - Suresh Gupta');
Id kavithaAccId = faMap.get('Savings Account - Kavitha Reddy');
Id rohitAccId = faMap.get('Savings Account - Rohit Verma');
Id anitaAccId = faMap.get('Savings Account - Anita Sharma');
Id sunitaAccId = faMap.get('Current Account - Sunita Devi');

txns.addAll(new List<FinServ__FinancialAccountTransaction__c>{
    new FinServ__FinancialAccountTransaction__c(Name='TXN-SG-001',FinServ__FinancialAccount__c=sureshAccId,FinServ__Amount__c=500000.00,FinServ__TransactionDate__c=Date.today().addDays(-3),FinServ__Description__c='Business Receipt - Textile Export',FinServ__TransactionType__c='Credit'),
    new FinServ__FinancialAccountTransaction__c(Name='TXN-SG-002',FinServ__FinancialAccount__c=sureshAccId,FinServ__Amount__c=-35200.00,FinServ__TransactionDate__c=Date.today().addDays(-6),FinServ__Description__c='Home Loan EMI - Axis Bank',FinServ__TransactionType__c='Debit'),
    new FinServ__FinancialAccountTransaction__c(Name='TXN-SG-003',FinServ__FinancialAccount__c=sureshAccId,FinServ__Amount__c=-200000.00,FinServ__TransactionDate__c=Date.today().addDays(-9),FinServ__Description__c='RTGS - Supplier Payment',FinServ__TransactionType__c='Debit'),
    new FinServ__FinancialAccountTransaction__c(Name='TXN-SG-004',FinServ__FinancialAccount__c=sureshAccId,FinServ__Amount__c=-50000.00,FinServ__TransactionDate__c=Date.today().addDays(-12),FinServ__Description__c='FD Booking - 6 months',FinServ__TransactionType__c='Debit'),
    new FinServ__FinancialAccountTransaction__c(Name='TXN-SG-005',FinServ__FinancialAccount__c=sureshAccId,FinServ__Amount__c=-8500.00,FinServ__TransactionDate__c=Date.today().addDays(-15),FinServ__Description__c='Credit Card Payment',FinServ__TransactionType__c='Debit'),
    new FinServ__FinancialAccountTransaction__c(Name='TXN-KR-001',FinServ__FinancialAccount__c=kavithaAccId,FinServ__Amount__c=91667.00,FinServ__TransactionDate__c=Date.today().addDays(-1),FinServ__Description__c='Salary Credit - Dr Reddys Labs',FinServ__TransactionType__c='Credit'),
    new FinServ__FinancialAccountTransaction__c(Name='TXN-KR-002',FinServ__FinancialAccount__c=kavithaAccId,FinServ__Amount__c=-10000.00,FinServ__TransactionDate__c=Date.today().addDays(-4),FinServ__Description__c='SIP - ICICI Prudential',FinServ__TransactionType__c='Debit'),
    new FinServ__FinancialAccountTransaction__c(Name='TXN-KR-003',FinServ__FinancialAccount__c=kavithaAccId,FinServ__Amount__c=-5600.00,FinServ__TransactionDate__c=Date.today().addDays(-8),FinServ__Description__c='Credit Card Bill',FinServ__TransactionType__c='Debit'),
    new FinServ__FinancialAccountTransaction__c(Name='TXN-KR-004',FinServ__FinancialAccount__c=kavithaAccId,FinServ__Amount__c=-3200.00,FinServ__TransactionDate__c=Date.today().addDays(-13),FinServ__Description__c='Big Bazaar - Groceries',FinServ__TransactionType__c='Debit'),
    new FinServ__FinancialAccountTransaction__c(Name='TXN-KR-005',FinServ__FinancialAccount__c=kavithaAccId,FinServ__Amount__c=-1500.00,FinServ__TransactionDate__c=Date.today().addDays(-17),FinServ__Description__c='TSSPDCL - Electricity Bill',FinServ__TransactionType__c='Debit'),
    new FinServ__FinancialAccountTransaction__c(Name='TXN-RV-001',FinServ__FinancialAccount__c=rohitAccId,FinServ__Amount__c=108333.00,FinServ__TransactionDate__c=Date.today().addDays(-2),FinServ__Description__c='Salary Credit - Hyundai Motors',FinServ__TransactionType__c='Credit'),
    new FinServ__FinancialAccountTransaction__c(Name='TXN-RV-002',FinServ__FinancialAccount__c=rohitAccId,FinServ__Amount__c=-24500.00,FinServ__TransactionDate__c=Date.today().addDays(-5),FinServ__Description__c='Home Loan EMI - Kotak Bank',FinServ__TransactionType__c='Debit'),
    new FinServ__FinancialAccountTransaction__c(Name='TXN-RV-003',FinServ__FinancialAccount__c=rohitAccId,FinServ__Amount__c=-6700.00,FinServ__TransactionDate__c=Date.today().addDays(-9),FinServ__Description__c='CC Payment - SBI Card',FinServ__TransactionType__c='Debit'),
    new FinServ__FinancialAccountTransaction__c(Name='TXN-RV-004',FinServ__FinancialAccount__c=rohitAccId,FinServ__Amount__c=-2900.00,FinServ__TransactionDate__c=Date.today().addDays(-13),FinServ__Description__c='Zomato Order',FinServ__TransactionType__c='Debit'),
    new FinServ__FinancialAccountTransaction__c(Name='TXN-RV-005',FinServ__FinancialAccount__c=rohitAccId,FinServ__Amount__c=-1800.00,FinServ__TransactionDate__c=Date.today().addDays(-18),FinServ__Description__c='TNEB - Electricity',FinServ__TransactionType__c='Debit'),
    new FinServ__FinancialAccountTransaction__c(Name='TXN-AS-001',FinServ__FinancialAccount__c=anitaAccId,FinServ__Amount__c=75000.00,FinServ__TransactionDate__c=Date.today().addDays(-3),FinServ__Description__c='Design Project Payment',FinServ__TransactionType__c='Credit'),
    new FinServ__FinancialAccountTransaction__c(Name='TXN-AS-002',FinServ__FinancialAccount__c=anitaAccId,FinServ__Amount__c=-5000.00,FinServ__TransactionDate__c=Date.today().addDays(-7),FinServ__Description__c='SIP - ABSL Mutual Fund',FinServ__TransactionType__c='Debit'),
    new FinServ__FinancialAccountTransaction__c(Name='TXN-AS-003',FinServ__FinancialAccount__c=anitaAccId,FinServ__Amount__c=-15000.00,FinServ__TransactionDate__c=Date.today().addDays(-10),FinServ__Description__c='House Rent',FinServ__TransactionType__c='Debit'),
    new FinServ__FinancialAccountTransaction__c(Name='TXN-AS-004',FinServ__FinancialAccount__c=anitaAccId,FinServ__Amount__c=-4300.00,FinServ__TransactionDate__c=Date.today().addDays(-14),FinServ__Description__c='Fabric Purchase - Business',FinServ__TransactionType__c='Debit'),
    new FinServ__FinancialAccountTransaction__c(Name='TXN-AS-005',FinServ__FinancialAccount__c=anitaAccId,FinServ__Amount__c=-1100.00,FinServ__TransactionDate__c=Date.today().addDays(-18),FinServ__Description__c='CESC - Electricity Bill',FinServ__TransactionType__c='Debit'),
    new FinServ__FinancialAccountTransaction__c(Name='TXN-SD-001',FinServ__FinancialAccount__c=sunitaAccId,FinServ__Amount__c=250000.00,FinServ__TransactionDate__c=Date.today().addDays(-4),FinServ__Description__c='Garment Sale - Wholesale',FinServ__TransactionType__c='Credit'),
    new FinServ__FinancialAccountTransaction__c(Name='TXN-SD-002',FinServ__FinancialAccount__c=sunitaAccId,FinServ__Amount__c=-30000.00,FinServ__TransactionDate__c=Date.today().addDays(-7),FinServ__Description__c='SIP + MF Investment',FinServ__TransactionType__c='Debit'),
    new FinServ__FinancialAccountTransaction__c(Name='TXN-SD-003',FinServ__FinancialAccount__c=sunitaAccId,FinServ__Amount__c=-125000.00,FinServ__TransactionDate__c=Date.today().addDays(-11),FinServ__Description__c='Fabric Supplier NEFT',FinServ__TransactionType__c='Debit'),
    new FinServ__FinancialAccountTransaction__c(Name='TXN-SD-004',FinServ__FinancialAccount__c=sunitaAccId,FinServ__Amount__c=-9000.00,FinServ__TransactionDate__c=Date.today().addDays(-15),FinServ__Description__c='CC Bill Payment',FinServ__TransactionType__c='Debit'),
    new FinServ__FinancialAccountTransaction__c(Name='TXN-SD-005',FinServ__FinancialAccount__c=sunitaAccId,FinServ__Amount__c=-2200.00,FinServ__TransactionDate__c=Date.today().addDays(-19),FinServ__Description__c='Jaipur VVNL - Electricity',FinServ__TransactionType__c='Debit')
});

insert txns;
System.debug('Inserted ' + txns.size() + ' FSC Transactions across all accounts.');
