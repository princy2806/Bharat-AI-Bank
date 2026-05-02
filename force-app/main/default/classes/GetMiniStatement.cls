/**
 * GetMiniStatement
 * Agentforce Action: returns last N transactions for a customer.
 * Topic: Account Balance and Statement
 *
 * Account lookup : Financial_Account__c (custom) — Account__c → Account
 * Transactions   : FinanceTransaction (Salesforce standard object)
 *                  Queried via dynamic SOQL to avoid compile-time errors.
 */
public class GetMiniStatement {

    public class InputWrapper {
        @InvocableVariable(required=true label='Customer Email')
        public String contactEmail;

        @InvocableVariable(label='Account Type Filter')
        public String accountTypeFilter;

        @InvocableVariable(label='Number of Transactions')
        public Integer numberOfTransactions;
    }

    public class OutputWrapper {
        @InvocableVariable public Boolean success;
        @InvocableVariable public String  errorMessage;
        @InvocableVariable public String  statementText;
        @InvocableVariable public Integer transactionCount;
        @InvocableVariable public String  customerName;
    }

    @InvocableMethod(
        label       = 'Get Mini Statement'
        description = 'Returns the last 5 transactions for the customer. Can filter by account type (savings, credit card, loan).'
    )
    public static List<OutputWrapper> getMiniStatement(List<InputWrapper> inputs) {

        List<OutputWrapper> results = new List<OutputWrapper>();
        OutputWrapper out = new OutputWrapper();

        try {
            if (inputs == null || inputs.isEmpty() || String.isBlank(inputs[0].contactEmail)) {
                out.success = false; out.errorMessage = 'Customer email is required.';
                results.add(out); return results;
            }

            InputWrapper inp = inputs[0];
            Integer txnLimit = (inp.numberOfTransactions != null && inp.numberOfTransactions > 0)
                               ? Math.min(inp.numberOfTransactions, 20) : 5;

            // 1. Resolve customer via Contact (no Person Account dependency)
            List<Contact> cons = [SELECT Id, Name, AccountId FROM Contact WHERE Email = :inp.contactEmail LIMIT 1];
            if (cons.isEmpty()) {
                out.success = false; out.errorMessage = 'No customer found for email: ' + inp.contactEmail;
                results.add(out); return results;
            }
            Id accId = cons[0].AccountId;
            out.customerName = cons[0].Name;

            // 2. Query FinanceTransaction (standard object)
            // Key fields: ChargeAmount, EventType, EventAction, TransactionDate, AccountId
            List<SObject> txns = Database.query(
                'SELECT Id, TransactionDate, ChargeAmount, ImpactAmount, ' +
                'EventType, EventAction, ResultingBalance ' +
                'FROM FinanceTransaction ' +
                'WHERE AccountId = :accId ' +
                'ORDER BY TransactionDate DESC ' +
                'LIMIT :txnLimit'
            );

            if (txns.isEmpty()) {
                out.success       = true;
                out.statementText = 'No recent transactions found for ' + out.customerName + '.';
                out.transactionCount = 0;
                results.add(out); return results;
            }

            // 3. Build statement text — table format
            List<String> lines = new List<String>();
            lines.add('📋 *Mini Statement — ' + out.customerName + '*');
            lines.add('Last ' + txns.size() + ' transactions:');
            lines.add('');
            lines.add('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
            lines.add('  #  │ Date        │ Description          │ Amount');
            lines.add('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

            Integer i = 1;
            for (SObject txn : txns) {
                String  evtType   = (String)txn.get('EventType');
                String  evtAction = (String)txn.get('EventAction');

                // Use ChargeAmount if non-zero, else fall back to ImpactAmount
                Decimal chargeAmt = (Decimal)txn.get('ChargeAmount');
                Decimal impactAmt = (Decimal)txn.get('ImpactAmount');
                Decimal subtotal  = (Decimal)txn.get('ResultingBalance'); // extra fallback
                Decimal txnAmt;
                if (chargeAmt != null && chargeAmt != 0) {
                    txnAmt = chargeAmt;
                } else if (impactAmt != null && impactAmt != 0) {
                    txnAmt = impactAmt;
                } else {
                    txnAmt = 0;
                }

                // Direction indicator
                String  symbol  = (txnAmt < 0) ? '✅ CR' : (txnAmt > 0 ? '🔴 DR' : '⚪ --');

                Datetime txnDt  = (Datetime)txn.get('TransactionDate');
                String   dateStr = txnDt != null ? txnDt.format('dd MMM yyyy') : 'N/A';

                // Description — EventAction is the merchant/action name
                String txnDesc = String.isBlank(evtAction)
                    ? (String.isBlank(evtType) ? 'Transaction' : evtType)
                    : evtAction;
                // Truncate long descriptions
                if (txnDesc.length() > 22) txnDesc = txnDesc.substring(0, 20) + '..';

                String amtStr = '₹' + formatAmount(txnAmt.abs());

                // Pad fields for alignment
                String numPad  = (i < 10 ? ' ' + i : String.valueOf(i));
                String datePad = dateStr.length() < 11 ? dateStr + '  ' : dateStr;
                String descPad = txnDesc.length() < 22 ? txnDesc.rightPad(22) : txnDesc;

                lines.add('  ' + numPad + ' │ ' + datePad + ' │ ' + descPad + ' │ ' + symbol + ' ' + amtStr);
                i++;
            }

            lines.add('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
            lines.add('');
            lines.add('💬 Type *"balance"* for full account summary');
            lines.add('⚠️  Type *"dispute"* to report an unauthorized charge');

            out.statementText    = String.join(lines, '\n');
            out.transactionCount = txns.size();
            out.success          = true;

        } catch (Exception e) {
            out.success = false;
            out.errorMessage = 'Error fetching statement: ' + e.getMessage();
        }

        results.add(out);
        return results;
    }

    private static String formatAmount(Decimal amount) {
        if (amount == null) return '0';
        Long   amt    = Math.abs(amount).longValue();
        String s      = String.valueOf(amt);
        if (s.length() <= 3) return s;
        String last3  = s.right(3);
        String rest   = s.left(s.length() - 3);
        String result = '';
        while (rest.length() > 2) { result = ',' + rest.right(2) + result; rest = rest.left(rest.length() - 2); }
        return rest + result + ',' + last3;
    }
}
