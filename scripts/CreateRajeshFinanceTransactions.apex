/**
 * CreateRajeshFinanceTransactions.apex
 * Creates 43 FinanceTransaction records for Rajesh Sharma
 * using the EXACT same field values as existing record FT-000000043.
 *
 * Existing record reference:
 *   AccountId              : 001bm00001jIHPnAAO
 *   TransactionDate        : 2026-03-01
 *   ImpactAmount           : 1500
 *   ResultingBalance       : 45000
 *   CurrencyIsoCode        : INR
 *   FinanceSystemTxnNumber : FS-TRX-1001
 *   EventType              : Allocated
 *   ReferenceEntityId      : a04bm000005oommAAA
 *   ReferenceEntityType    : Payment
 *   SourceEntityId         : a04bm000005oommAAA
 *   DestinationEntityId    : 0aQbm0000002BCHEA2
 *   Subtotal               : 1500
 *   TaxAmount              : 0
 *   TotalAmountWithTax     : 1500
 *   ChargeAmount           : 0
 *   AdjustmentAmount       : 0
 *   EffectiveDate          : 2026-03-01
 *   DueDate                : 2026-03-05
 *
 * Run via:
 *   sf apex run --file scripts/CreateRajeshFinanceTransactions.apex -o princy.shah477@agentforce.com
 */

// ── Fixed field values (same as existing record) ─────────────────────
Id      accountId          = '001bm00001jIHPnAAO';
Id      referenceEntId     = 'a04bm000005oommAAA';
Id      sourceEntId        = 'a04bm000005oommAAA';
Id      destinationEntId   = '0aQbm0000002BCHEA2';
String  referenceEntType   = 'Payment';              // REQUIRED — same as FT-000000043
String  eventType          = 'Allocated';
String  currencyCode       = 'INR';
Decimal impactAmt       = 1500;
Decimal resultingBal    = 45000;
Decimal subtotalAmt     = 1500;
Decimal taxAmt          = 0;
Decimal totalWithTax    = 1500;
Decimal chargeAmt       = 0;
Decimal adjustAmt       = 0;
// EffectiveDate same as TransactionDate; DueDate = TransactionDate + 4 days

// ── All EventAction picklist values ──────────────────────────────────
List<String> eventActions = new List<String>{
    'Post an invoice',
    'Void an invoice',
    'Cancel & rebill',
    'Convert negative invoice lines',
    'Subtotal change on sub invoice line',
    'Tax change on sub invoice line',
    'Invoice line reference changed on sub invoice line',
    'Currency change on sub invoice line',
    'Credit invoice header',
    'Unallocate credit from invoice header',
    'Credit invoice line',
    'Unallocate credit from invoice line',
    'Pay invoice header',
    'Unallocate payment from invoice header',
    'Pay invoice line',
    'Unallocate payment from invoice line',
    'Debit invoice header',
    'Unallocate debit from invoice header',
    'Debit invoice line',
    'Unallocate debit from invoice line',
    'Issue a standalone credit',
    'Void a standalone credit',
    'Refund a credit memo header',
    'Unallocate refund from credit memo header',
    'Refund a credit memo line',
    'Unallocate refund from credit memo line',
    'Debit credit memo header',
    'Unallocate debit from credit memo header',
    'Debit credit memo line',
    'Unallocate debit from credit memo line',
    'Post a standalone payment',
    'Void a standalone payment',
    'Refund a payment',
    'Unallocate refund from payment',
    'Issue a standalone refund',
    'Void a standalone refund',
    'Issue a standalone debit',
    'Void a standalone debit',
    'Pay debit memo header',
    'Unallocate payment from debit memo header',
    'Pay debit memo line',
    'Unallocate payment from debit line',
    'Other'
};

// ── Build records ─────────────────────────────────────────────────────
List<FinanceTransaction> txns = new List<FinanceTransaction>();
Date startDate = Date.newInstance(2026, 1, 1);   // spread from Jan 1, one per day

for (Integer i = 0; i < eventActions.size(); i++) {

    Date     txnDate  = startDate.addDays(i);
    Datetime txnDt    = Datetime.newInstance(txnDate.year(), txnDate.month(), txnDate.day(), 0, 0, 0);
    Date     dueDate  = txnDate.addDays(4);       // DueDate = TransactionDate + 4 days (same as sample)
    String   txnNum   = 'FS-TRX-' + String.valueOf(1002 + i);  // FS-TRX-1002 … FS-TRX-1044

    FinanceTransaction ft = new FinanceTransaction();
    ft.AccountId                      = accountId;
    ft.TransactionDate                = txnDt;
    ft.EffectiveDate                  = txnDt;
    ft.DueDate                        = dueDate;
    ft.CurrencyIsoCode                = currencyCode;
    ft.EventType                      = eventType;
    ft.EventAction                    = eventActions[i];
    ft.ReferenceEntityId              = referenceEntId;
    ft.ReferenceEntityType            = referenceEntType;   // ← was missing, now added
    ft.SourceEntityId                 = sourceEntId;
    ft.DestinationEntityId            = destinationEntId;
    ft.ImpactAmount                   = impactAmt;
    ft.ResultingBalance               = resultingBal;
    ft.Subtotal                       = subtotalAmt;
    ft.TaxAmount                      = taxAmt;
    ft.TotalAmountWithTax             = totalWithTax;
    ft.ChargeAmount                   = chargeAmt;
    ft.AdjustmentAmount               = adjustAmt;
    ft.FinanceSystemTransactionNumber = txnNum;

    txns.add(ft);
}

System.debug('Prepared ' + txns.size() + ' FinanceTransaction records...');

// ── Insert in batches of 10 ───────────────────────────────────────────
Integer batchSize = 10;
Integer total     = txns.size();
Integer inserted  = 0;
Integer failed    = 0;

for (Integer i = 0; i < total; i += batchSize) {
    Integer endIdx = Math.min(i + batchSize, total);
    List<FinanceTransaction> batch = new List<FinanceTransaction>();
    for (Integer j = i; j < endIdx; j++) {
        batch.add(txns[j]);
    }

    try {
        insert batch;
        inserted += batch.size();
        for (FinanceTransaction t : batch) {
            System.debug('  ✓ [' + t.FinanceSystemTransactionNumber + '] ' + t.EventAction + ' | Date: ' + t.TransactionDate);
        }
    } catch (Exception e) {
        System.debug('Batch failed — retrying one by one: ' + e.getMessage());
        for (FinanceTransaction t : batch) {
            try {
                insert t;
                inserted++;
                System.debug('  ✓ OK  : [' + t.FinanceSystemTransactionNumber + '] ' + t.EventAction);
            } catch (Exception e2) {
                failed++;
                System.debug('  ✗ FAIL: [' + t.FinanceSystemTransactionNumber + '] ' + t.EventAction + ' → ' + e2.getMessage());
            }
        }
    }
}

System.debug('════════════════════════════════════════════════');
System.debug('Total attempted : ' + total);
System.debug('Inserted        : ' + inserted);
System.debug('Failed          : ' + failed);
System.debug('════════════════════════════════════════════════');
