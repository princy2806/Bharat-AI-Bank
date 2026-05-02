/**
 * CreateDisputeTestTransactions.apex
 * Creates FinanceTransaction records with real non-zero ChargeAmounts
 * for dispute testing. Uses VALID EventAction picklist values only.
 *
 * Run via:
 *   sf apex run --file scripts/CreateDisputeTestTransactions.apex -o princy.shah477@agentforce.com
 */

// ── Find customer ──────────────────────────────────────────────────────
// Try both emails — Rajesh or the test user
String testEmail = '17ravi.ka@gmail.com';
List<Contact> cons = [SELECT Id, Name, AccountId FROM Contact WHERE Email = :testEmail LIMIT 1];
if (cons.isEmpty()) {
    // fallback: try Rajesh's account directly
    cons = [SELECT Id, Name, AccountId FROM Contact WHERE AccountId = '001bm00001jIHPnAAO' LIMIT 1];
}
if (cons.isEmpty()) {
    System.debug('ERROR: No contact found. Check the email.');
    return;
}
Id accId = cons[0].AccountId;
System.debug('Creating transactions for: ' + cons[0].Name + ' | Account: ' + accId);

// ── Find Financial_Account__c for ReferenceEntityId ────────────────────
List<SObject> fas = Database.query(
    'SELECT Id, Account_Type__c FROM Financial_Account__c ' +
    'WHERE Account__c = :accId AND Status__c = \'Active\' LIMIT 5'
);
if (fas.isEmpty()) {
    System.debug('ERROR: No Financial_Account__c found for this account.');
    return;
}
Id faId = (Id)fas[0].get('Id');  // use first available

// ── Common field values (same as existing FT-000000043) ────────────────
String refEntType = 'Payment';
String evtType    = 'Allocated';
String currency   = 'INR';
Decimal resBal    = 45000;
Decimal taxAmt    = 0;
Decimal adjAmt    = 0;

// ── Build transactions using VALID EventAction picklist values ──────────
List<FinanceTransaction> txns = new List<FinanceTransaction>();

// Suspicious large debit — good for dispute test (₹5,999)
// Maps to: "Issue a standalone debit" — valid picklist value
txns.add(new FinanceTransaction(
    AccountId                     = accId,
    ReferenceEntityId             = faId,
    SourceEntityId                = faId,
    ReferenceEntityType           = refEntType,
    EventType                     = evtType,
    EventAction                   = 'Issue a standalone debit',   // ← valid picklist
    ChargeAmount                  = 5999.00,
    ImpactAmount                  = 5999.00,
    Subtotal                      = 5999.00,
    TotalAmountWithTax            = 5999.00,
    TaxAmount                     = taxAmt,
    AdjustmentAmount              = adjAmt,
    ResultingBalance              = resBal,
    CurrencyIsoCode               = currency,
    FinanceSystemTransactionNumber= 'FS-DISP-001',
    TransactionDate               = Datetime.newInstance(2026, 4, 19, 3, 22, 0),
    EffectiveDate                 = Datetime.newInstance(2026, 4, 19, 0, 0, 0),
    DueDate                       = Date.newInstance(2026, 4, 23)
));

// Online shopping charge (₹4,299)
txns.add(new FinanceTransaction(
    AccountId                     = accId,
    ReferenceEntityId             = faId,
    SourceEntityId                = faId,
    ReferenceEntityType           = refEntType,
    EventType                     = evtType,
    EventAction                   = 'Post an invoice',            // ← valid picklist
    ChargeAmount                  = 4299.00,
    ImpactAmount                  = 4299.00,
    Subtotal                      = 4299.00,
    TotalAmountWithTax            = 4299.00,
    TaxAmount                     = taxAmt,
    AdjustmentAmount              = adjAmt,
    ResultingBalance              = resBal,
    CurrencyIsoCode               = currency,
    FinanceSystemTransactionNumber= 'FS-DISP-002',
    TransactionDate               = Datetime.newInstance(2026, 4, 22, 14, 35, 0),
    EffectiveDate                 = Datetime.newInstance(2026, 4, 22, 0, 0, 0),
    DueDate                       = Date.newInstance(2026, 4, 26)
));

// Flight booking (₹12,500) — good for "I didn't make this ₹12,500 charge" test
txns.add(new FinanceTransaction(
    AccountId                     = accId,
    ReferenceEntityId             = faId,
    SourceEntityId                = faId,
    ReferenceEntityType           = refEntType,
    EventType                     = evtType,
    EventAction                   = 'Debit invoice header',       // ← valid picklist
    ChargeAmount                  = 12500.00,
    ImpactAmount                  = 12500.00,
    Subtotal                      = 12500.00,
    TotalAmountWithTax            = 12500.00,
    TaxAmount                     = taxAmt,
    AdjustmentAmount              = adjAmt,
    ResultingBalance              = resBal,
    CurrencyIsoCode               = currency,
    FinanceSystemTransactionNumber= 'FS-DISP-003',
    TransactionDate               = Datetime.newInstance(2026, 4, 12, 11, 20, 0),
    EffectiveDate                 = Datetime.newInstance(2026, 4, 12, 0, 0, 0),
    DueDate                       = Date.newInstance(2026, 4, 16)
));

// Food delivery (₹650)
txns.add(new FinanceTransaction(
    AccountId                     = accId,
    ReferenceEntityId             = faId,
    SourceEntityId                = faId,
    ReferenceEntityType           = refEntType,
    EventType                     = evtType,
    EventAction                   = 'Debit invoice line',         // ← valid picklist
    ChargeAmount                  = 650.00,
    ImpactAmount                  = 650.00,
    Subtotal                      = 650.00,
    TotalAmountWithTax            = 650.00,
    TaxAmount                     = taxAmt,
    AdjustmentAmount              = adjAmt,
    ResultingBalance              = resBal,
    CurrencyIsoCode               = currency,
    FinanceSystemTransactionNumber= 'FS-DISP-004',
    TransactionDate               = Datetime.newInstance(2026, 4, 20, 20, 10, 0),
    EffectiveDate                 = Datetime.newInstance(2026, 4, 20, 0, 0, 0),
    DueDate                       = Date.newInstance(2026, 4, 24)
));

// Credit card bill payment — credit (₹15,000)
txns.add(new FinanceTransaction(
    AccountId                     = accId,
    ReferenceEntityId             = faId,
    SourceEntityId                = faId,
    ReferenceEntityType           = refEntType,
    EventType                     = evtType,
    EventAction                   = 'Pay invoice header',         // ← valid picklist
    ChargeAmount                  = -15000.00,
    ImpactAmount                  = -15000.00,
    Subtotal                      = 15000.00,
    TotalAmountWithTax            = 15000.00,
    TaxAmount                     = taxAmt,
    AdjustmentAmount              = adjAmt,
    ResultingBalance              = resBal,
    CurrencyIsoCode               = currency,
    FinanceSystemTransactionNumber= 'FS-DISP-005',
    TransactionDate               = Datetime.newInstance(2026, 4, 15, 10, 0, 0),
    EffectiveDate                 = Datetime.newInstance(2026, 4, 15, 0, 0, 0),
    DueDate                       = Date.newInstance(2026, 4, 19)
));

// Salary credit (₹95,000)
txns.add(new FinanceTransaction(
    AccountId                     = accId,
    ReferenceEntityId             = faId,
    SourceEntityId                = faId,
    ReferenceEntityType           = refEntType,
    EventType                     = evtType,
    EventAction                   = 'Post a standalone payment',  // ← valid picklist
    ChargeAmount                  = -95000.00,
    ImpactAmount                  = -95000.00,
    Subtotal                      = 95000.00,
    TotalAmountWithTax            = 95000.00,
    TaxAmount                     = taxAmt,
    AdjustmentAmount              = adjAmt,
    ResultingBalance              = resBal,
    CurrencyIsoCode               = currency,
    FinanceSystemTransactionNumber= 'FS-DISP-006',
    TransactionDate               = Datetime.newInstance(2026, 4, 1, 9, 0, 0),
    EffectiveDate                 = Datetime.newInstance(2026, 4, 1, 0, 0, 0),
    DueDate                       = Date.newInstance(2026, 4, 5)
));

// ── Insert ─────────────────────────────────────────────────────────────
try {
    insert txns;
    System.debug('SUCCESS: Inserted ' + txns.size() + ' transactions.');
    for (FinanceTransaction t : txns) {
        System.debug('  ✓ [' + t.FinanceSystemTransactionNumber + '] '
            + t.EventAction + ' | ChargeAmount: ' + t.ChargeAmount);
    }
} catch (Exception e) {
    System.debug('Batch failed — retrying one by one: ' + e.getMessage());
    Integer ok = 0; Integer fail = 0;
    for (FinanceTransaction t : txns) {
        try {
            insert t;
            ok++;
            System.debug('  ✓ ' + t.EventAction + ' | ' + t.ChargeAmount);
        } catch (Exception e2) {
            fail++;
            System.debug('  ✗ ' + t.EventAction + ' → ' + e2.getMessage());
        }
    }
    System.debug('Done — OK: ' + ok + ' | Failed: ' + fail);
}
