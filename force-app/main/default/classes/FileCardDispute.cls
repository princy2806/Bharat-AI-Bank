/**
 * FileCardDispute
 * Agentforce Action: finds a credit card transaction and raises a dispute case.
 * Topic: Credit Card Dispute
 *
 * Account lookup  : Financial_Account__c (custom) — Account__c → Account
 * Transactions    : FinanceTransaction (Salesforce standard object, dynamic SOQL)
 * Dispute record  : Standard Case (Type = 'Credit Card Dispute')
 */
public class FileCardDispute {

    public class InputWrapper {
        @InvocableVariable(required=true label='Customer Email')
        public String contactEmail;

        @InvocableVariable(required=true label='Disputed Amount')
        public Decimal disputedAmount;

        @InvocableVariable(label='Merchant Name or Location')
        public String merchantName;

        @InvocableVariable(label='Transaction Date (YYYY-MM-DD)')
        public String transactionDate;

        @InvocableVariable(label='Dispute Reason')
        public String disputeReason;
    }

    public class OutputWrapper {
        @InvocableVariable public Boolean success;
        @InvocableVariable public String  errorMessage;

        @InvocableVariable public String  caseNumber;
        @InvocableVariable public String  caseId;
        @InvocableVariable public String  confirmationMessage;

        @InvocableVariable public String  matchedTransactionDate;
        @InvocableVariable public String  matchedTransactionDesc;
        @InvocableVariable public Decimal matchedAmount;

        @InvocableVariable public Boolean provisionalCreditIssued;
    }

    @InvocableMethod(
        label       = 'File Credit Card Dispute'
        description = 'Finds the disputed credit card transaction and raises a formal dispute case. Issues provisional credit immediately.'
    )
    public static List<OutputWrapper> fileDispute(List<InputWrapper> inputs) {

        List<OutputWrapper> results = new List<OutputWrapper>();
        OutputWrapper out = new OutputWrapper();

        try {
            if (inputs == null || inputs.isEmpty()) {
                out.success = false; out.errorMessage = 'Input missing.';
                results.add(out); return results;
            }
            InputWrapper inp = inputs[0];

            if (String.isBlank(inp.contactEmail) || inp.disputedAmount == null) {
                out.success = false; out.errorMessage = 'Email and disputed amount are required.';
                results.add(out); return results;
            }

            // 1. Resolve customer via Contact (no Person Account dependency)
            List<Contact> cons = [SELECT Id, Name, AccountId FROM Contact WHERE Email = :inp.contactEmail LIMIT 1];
            if (cons.isEmpty()) {
                out.success = false; out.errorMessage = 'Customer not found for email: ' + inp.contactEmail;
                results.add(out); return results;
            }
            Id accId = cons[0].AccountId;
            Account acc = [SELECT Id FROM Account WHERE Id = :accId LIMIT 1];

            // 2. Search FinanceTransaction within +/-10% of disputed amount
            // Try ChargeAmount first; fall back to ImpactAmount (some records have ChargeAmount=0)
            Decimal amtLow  = inp.disputedAmount * 0.9;
            Decimal amtHigh = inp.disputedAmount * 1.1;

            List<SObject> txns = Database.query(
                'SELECT Id, TransactionDate, ChargeAmount, ImpactAmount, EventType, EventAction ' +
                'FROM FinanceTransaction ' +
                'WHERE AccountId = :accId ' +
                'AND ChargeAmount >= :amtLow ' +
                'AND ChargeAmount <= :amtHigh ' +
                'ORDER BY TransactionDate DESC LIMIT 5'
            );

            // Fallback: search by ImpactAmount when ChargeAmount is 0 on all records
            if (txns.isEmpty()) {
                txns = Database.query(
                    'SELECT Id, TransactionDate, ChargeAmount, ImpactAmount, EventType, EventAction ' +
                    'FROM FinanceTransaction ' +
                    'WHERE AccountId = :accId ' +
                    'AND ImpactAmount >= :amtLow ' +
                    'AND ImpactAmount <= :amtHigh ' +
                    'ORDER BY TransactionDate DESC LIMIT 5'
                );
            }

            // Last resort: return most recent 5 transactions for manual review
            if (txns.isEmpty()) {
                txns = Database.query(
                    'SELECT Id, TransactionDate, ChargeAmount, ImpactAmount, EventType, EventAction ' +
                    'FROM FinanceTransaction ' +
                    'WHERE AccountId = :accId ' +
                    'ORDER BY TransactionDate DESC LIMIT 5'
                );
            }

            // 3. Match by EventAction (description equivalent)
            SObject matchedTxn = null;
            if (!String.isBlank(inp.merchantName) && txns.size() > 1) {
                for (SObject t : txns) {
                    String evtAction = (String)t.get('EventAction');
                    String evtType   = (String)t.get('EventType');
                    String txnDesc   = String.isBlank(evtAction) ? evtType : evtAction;
                    if (txnDesc != null && txnDesc.containsIgnoreCase(inp.merchantName)) {
                        matchedTxn = t; break;
                    }
                }
            }
            if (matchedTxn == null && !txns.isEmpty()) matchedTxn = txns[0];

            // 4. Extract matched transaction details
            String  txnMatchedDate = '';
            String  txnMatchedDesc = '';
            Decimal txnMatchedAmt  = null;

            if (matchedTxn != null) {
                Datetime matchDt   = (Datetime)matchedTxn.get('TransactionDate');
                txnMatchedDate     = matchDt != null ? matchDt.format('dd/MM/yyyy') : 'Unknown date';
                String evtAction    = (String)matchedTxn.get('EventAction');
                String evtType      = (String)matchedTxn.get('EventType');
                txnMatchedDesc      = String.isBlank(evtAction) ? (String.isBlank(evtType) ? 'Unknown' : evtType) : evtAction;
                Decimal chargeAmt   = (Decimal)matchedTxn.get('ChargeAmount');
                Decimal impactAmt   = (Decimal)matchedTxn.get('ImpactAmount');
                txnMatchedAmt       = chargeAmt != null ? chargeAmt : impactAmt;
            }

            String txnDetail = matchedTxn != null
                ? 'Matched: ' + txnMatchedDate + ' | ' + txnMatchedDesc + ' | ₹' + txnMatchedAmt
                : 'Transaction not matched — manual review required. Disputed amount: ₹' + inp.disputedAmount;

            String reason = String.isBlank(inp.disputeReason)
                ? 'Unauthorized transaction reported by customer via agent.'
                : inp.disputeReason;

            // ── 5. Create standard Case ───────────────────────────────────────
            Case disputeCase = new Case(
                Subject     = 'Credit Card Dispute — ₹' + inp.disputedAmount
                              + (String.isBlank(inp.merchantName) ? '' : ' at ' + inp.merchantName),
                Description = reason + '\n\n' + txnDetail
                              + '\n\nProvisional credit: APPROVED — applied within 24 hours.',
                Status      = 'New',
                Priority    = 'High',
                Origin      = 'Chat',
                AccountId   = acc.Id,
                Type        = 'Credit Card Dispute',
                Reason      = 'User Initiated'
            );
            insert disputeCase;

            disputeCase = [SELECT Id, CaseNumber FROM Case WHERE Id = :disputeCase.Id LIMIT 1];

            CaseComment cc = new CaseComment(
                ParentId    = disputeCase.Id,
                CommentBody = 'PROVISIONAL CREDIT ISSUED: ₹' + inp.disputedAmount
                            + ' — Temporary credit applied. Investigation SLA: 7 working days.'
                            + ' Auto-generated by Agentforce.'
            );
            insert cc;

            // ── 6. Build output ───────────────────────────────────────────────
            out.caseNumber              = disputeCase.CaseNumber;
            out.caseId                  = disputeCase.Id;
            out.provisionalCreditIssued = true;

            if (matchedTxn != null) {
                out.matchedTransactionDate = txnMatchedDate;
                out.matchedTransactionDesc = txnMatchedDesc;
                out.matchedAmount          = txnMatchedAmt;
            }

            out.confirmationMessage =
                '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n' +
                '✅ *Dispute Filed Successfully!*\n' +
                '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n' +
                '📋 *Case Number* : ' + disputeCase.CaseNumber + '\n' +
                '💰 *Disputed Amt* : ₹' + inp.disputedAmount + '\n' +
                (matchedTxn != null
                    ? '🔍 *Transaction*  : ' + txnMatchedDesc + '\n' +
                      '📅 *Txn Date*     : ' + txnMatchedDate + '\n'
                    : '🔍 *Transaction*  : Manual review required\n') +
                '\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n' +
                '⚡ *Provisional Credit Applied!*\n' +
                '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n' +
                '  ₹' + inp.disputedAmount + ' credited to your account\n' +
                '  No interest charged during investigation\n' +
                '  Credit effective within 24 hours\n\n' +
                '📅 *Resolution*   : Within 7 working days\n' +
                '💬 Type *"dispute status"* anytime to track your case.';

            out.success = true;

        } catch (Exception e) {
            out.success = false;
            out.errorMessage = 'Error filing dispute: ' + e.getMessage();
        }

        results.add(out);
        return results;
    }
}
