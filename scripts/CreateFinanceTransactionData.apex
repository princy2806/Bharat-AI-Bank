/**
 * CreateFinanceTransactionData.apex
 * Run via: sf apex run --file scripts/CreateFinanceTransactionData.apex -o princy.shah477@agentforce.com
 *
 * Creates realistic banking FinanceTransaction records for demo/testing.
 * Looks up Rajesh Sharma's Contact → AccountId automatically.
 */

// --- 1. Find customer account ---
List<Contact> cons = [SELECT Id, Name, AccountId FROM Contact WHERE Email = 'rajesh.sharma@example.com' LIMIT 1];
if (cons.isEmpty()) {
    System.debug('ERROR: Contact not found. Check the email address.');
    return;
}
Id accId = cons[0].AccountId;
System.debug('Found customer: ' + cons[0].Name + ' | AccountId: ' + accId);

// --- 2. Find a Financial_Account__c to use as ReferenceEntityId ---
List<SObject> finAccs = Database.query(
    'SELECT Id, Account_Type__c FROM Financial_Account__c WHERE Account__c = :accId AND Status__c = \'Active\' LIMIT 5'
);

Id creditCardAccId = null;
Id savingsAccId    = null;
Id loanAccId       = null;

for (SObject fa : finAccs) {
    String aType = (String)fa.get('Account_Type__c');
    if (aType == 'Credit Card' && creditCardAccId == null) creditCardAccId = (Id)fa.get('Id');
    if ((aType == 'Savings Account' || aType == 'SavingsAccount') && savingsAccId == null) savingsAccId = (Id)fa.get('Id');
    if ((aType == 'Home Loan' || aType == 'Personal Loan' || aType == 'HomeLoan' || aType == 'PersonalLoan') && loanAccId == null) loanAccId = (Id)fa.get('Id');
}

// Fallback: use first available account
Id defaultAccId = finAccs.isEmpty() ? null : (Id)finAccs[0].get('Id');
if (creditCardAccId == null) creditCardAccId = defaultAccId;
if (savingsAccId    == null) savingsAccId    = defaultAccId;
if (loanAccId       == null) loanAccId       = defaultAccId;

System.debug('Credit Card AccId: ' + creditCardAccId);
System.debug('Savings AccId:     ' + savingsAccId);
System.debug('Loan AccId:        ' + loanAccId);

// --- 3. Build transactions ---
List<FinanceTransaction> txns = new List<FinanceTransaction>();

// Credit Card transactions (ChargeAmount positive = charge to customer)
txns.add(new FinanceTransaction(
    AccountId        = accId,
    ReferenceEntityId= creditCardAccId,
    SourceEntityId   = creditCardAccId,
    EventType        = 'Charge',
    EventAction      = 'Amazon.in - Online Shopping',
    ChargeAmount     = 4299.00,
    ImpactAmount     = 4299.00,
    TransactionDate  = Datetime.newInstance(2026, 4, 22, 14, 35, 0)
));

txns.add(new FinanceTransaction(
    AccountId        = accId,
    ReferenceEntityId= creditCardAccId,
    SourceEntityId   = creditCardAccId,
    EventType        = 'Charge',
    EventAction      = 'Swiggy - Food Delivery',
    ChargeAmount     = 650.00,
    ImpactAmount     = 650.00,
    TransactionDate  = Datetime.newInstance(2026, 4, 20, 20, 10, 0)
));

txns.add(new FinanceTransaction(
    AccountId        = accId,
    ReferenceEntityId= creditCardAccId,
    SourceEntityId   = creditCardAccId,
    EventType        = 'Charge',
    EventAction      = 'Zara - Retail Shopping',
    ChargeAmount     = 3199.00,
    ImpactAmount     = 3199.00,
    TransactionDate  = Datetime.newInstance(2026, 4, 18, 16, 45, 0)
));

txns.add(new FinanceTransaction(
    AccountId        = accId,
    ReferenceEntityId= creditCardAccId,
    SourceEntityId   = creditCardAccId,
    EventType        = 'Payment',
    EventAction      = 'Credit Card Bill Payment',
    ChargeAmount     = -15000.00,
    ImpactAmount     = -15000.00,
    TransactionDate  = Datetime.newInstance(2026, 4, 15, 10, 0, 0)
));

txns.add(new FinanceTransaction(
    AccountId        = accId,
    ReferenceEntityId= creditCardAccId,
    SourceEntityId   = creditCardAccId,
    EventType        = 'Charge',
    EventAction      = 'MakeMyTrip - Flight Booking',
    ChargeAmount     = 8500.00,
    ImpactAmount     = 8500.00,
    TransactionDate  = Datetime.newInstance(2026, 4, 12, 11, 20, 0)
));

txns.add(new FinanceTransaction(
    AccountId        = accId,
    ReferenceEntityId= creditCardAccId,
    SourceEntityId   = creditCardAccId,
    EventType        = 'Charge',
    EventAction      = 'BookMyShow - Movie Tickets',
    ChargeAmount     = 1200.00,
    ImpactAmount     = 1200.00,
    TransactionDate  = Datetime.newInstance(2026, 4, 10, 19, 0, 0)
));

txns.add(new FinanceTransaction(
    AccountId        = accId,
    ReferenceEntityId= creditCardAccId,
    SourceEntityId   = creditCardAccId,
    EventType        = 'Charge',
    EventAction      = 'DMart - Grocery Shopping',
    ChargeAmount     = 3875.00,
    ImpactAmount     = 3875.00,
    TransactionDate  = Datetime.newInstance(2026, 4, 8, 18, 30, 0)
));

txns.add(new FinanceTransaction(
    AccountId        = accId,
    ReferenceEntityId= creditCardAccId,
    SourceEntityId   = creditCardAccId,
    EventType        = 'Charge',
    EventAction      = 'Netflix - Subscription',
    ChargeAmount     = 649.00,
    ImpactAmount     = 649.00,
    TransactionDate  = Datetime.newInstance(2026, 4, 5, 0, 0, 0)
));

// Savings transactions
txns.add(new FinanceTransaction(
    AccountId        = accId,
    ReferenceEntityId= savingsAccId,
    SourceEntityId   = savingsAccId,
    EventType        = 'Credit',
    EventAction      = 'Salary Credit - TechCorp India',
    ChargeAmount     = -95000.00,
    ImpactAmount     = -95000.00,
    TransactionDate  = Datetime.newInstance(2026, 4, 1, 9, 0, 0)
));

txns.add(new FinanceTransaction(
    AccountId        = accId,
    ReferenceEntityId= savingsAccId,
    SourceEntityId   = savingsAccId,
    EventType        = 'Debit',
    EventAction      = 'NEFT Transfer - Rohit Sharma',
    ChargeAmount     = 20000.00,
    ImpactAmount     = 20000.00,
    TransactionDate  = Datetime.newInstance(2026, 4, 3, 14, 0, 0)
));

txns.add(new FinanceTransaction(
    AccountId        = accId,
    ReferenceEntityId= savingsAccId,
    SourceEntityId   = savingsAccId,
    EventType        = 'Debit',
    EventAction      = 'UPI Payment - PhonePe',
    ChargeAmount     = 2500.00,
    ImpactAmount     = 2500.00,
    TransactionDate  = Datetime.newInstance(2026, 4, 6, 12, 30, 0)
));

// Loan EMI (March)
if (loanAccId != null) {
    txns.add(new FinanceTransaction(
        AccountId        = accId,
        ReferenceEntityId= loanAccId,
        SourceEntityId   = loanAccId,
        EventType        = 'Debit',
        EventAction      = 'Home Loan EMI - March 2026',
        ChargeAmount     = 28500.00,
        ImpactAmount     = 28500.00,
        TransactionDate  = Datetime.newInstance(2026, 3, 5, 10, 0, 0)
    ));

    txns.add(new FinanceTransaction(
        AccountId        = accId,
        ReferenceEntityId= loanAccId,
        SourceEntityId   = loanAccId,
        EventType        = 'Debit',
        EventAction      = 'Home Loan EMI - April 2026',
        ChargeAmount     = 28500.00,
        ImpactAmount     = 28500.00,
        TransactionDate  = Datetime.newInstance(2026, 4, 5, 10, 0, 0)
    ));
}

// Suspicious / disputable charge for demo
txns.add(new FinanceTransaction(
    AccountId        = accId,
    ReferenceEntityId= creditCardAccId,
    SourceEntityId   = creditCardAccId,
    EventType        = 'Charge',
    EventAction      = 'Unknown Merchant - International',
    ChargeAmount     = 5999.00,
    ImpactAmount     = 5999.00,
    TransactionDate  = Datetime.newInstance(2026, 4, 19, 3, 22, 0)
));

// --- 4. Insert ---
try {
    insert txns;
    System.debug('SUCCESS: Inserted ' + txns.size() + ' FinanceTransaction records.');
    for (FinanceTransaction t : txns) {
        System.debug('  Inserted: ' + t.Id + ' | ' + t.EventAction + ' | ' + t.ChargeAmount);
    }
} catch (Exception e) {
    System.debug('ERROR inserting transactions: ' + e.getMessage());
    System.debug('Stack: ' + e.getStackTraceString());
}
