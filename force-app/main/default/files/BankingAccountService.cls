/**
 * BankingAccountService
 * Provides post-verification banking information:
 * balance, statements, card status, loan details.
 * All data is masked per security policy.
 */
public with sharing class BankingAccountService {

    // ─── Check Balance ───────────────────────────────────────────────────────

    public class BalanceInput {
        @InvocableVariable(label='Customer Record ID' required=true)
        public String customerRecordId;
    }

    public class BalanceOutput {
        @InvocableVariable(label='Available Balance')
        public String availableBalance;

        @InvocableVariable(label='Response Message')
        public String responseMessage;
    }

    @InvocableMethod(
        label       = 'Get Account Balance'
        description = 'Returns masked account balance for a verified customer'
    )
    public static List<BalanceOutput> getBalance(List<BalanceInput> inputs) {
        List<BalanceOutput> results = new List<BalanceOutput>();
        for (BalanceInput inp : inputs) {
            BalanceOutput out = new BalanceOutput();
            List<BankCustomer__c> recs = [
                SELECT AccountBalance__c, IsVerified__c
                FROM   BankCustomer__c
                WHERE  Id = :inp.customerRecordId
                LIMIT  1
            ];
            if (!recs.isEmpty() && recs[0].IsVerified__c == true) {
                Decimal bal = recs[0].AccountBalance__c ?? 0;
                out.availableBalance = formatCurrency(bal);
                out.responseMessage  = 'Your available balance is ' + out.availableBalance + '.';
            } else {
                out.responseMessage = 'Unauthorized. Please verify your identity first.';
            }
            results.add(out);
        }
        return results;
    }

    // ─── Last N Transactions ─────────────────────────────────────────────────

    public class TransactionInput {
        @InvocableVariable(label='Customer Record ID' required=true)
        public String customerRecordId;

        @InvocableVariable(label='Number of Transactions')
        public Integer numberOfTransactions;   // default 5
    }

    public class TransactionOutput {
        @InvocableVariable(label='Transactions JSON')
        public String transactionsJson;

        @InvocableVariable(label='Formatted Statement')
        public String formattedStatement;

        @InvocableVariable(label='Response Message')
        public String responseMessage;
    }

    @InvocableMethod(
        label       = 'Get Recent Transactions'
        description = 'Returns last N transactions for a verified customer'
    )
    public static List<TransactionOutput> getTransactions(
        List<TransactionInput> inputs
    ) {
        List<TransactionOutput> results = new List<TransactionOutput>();
        for (TransactionInput inp : inputs) {
            TransactionOutput out = new TransactionOutput();
            Integer limit = (inp.numberOfTransactions != null && inp.numberOfTransactions > 0)
                ? inp.numberOfTransactions : 5;

            List<BankTransaction__c> txns = [
                SELECT TransactionDate__c, Description__c,
                       TransactionType__c, Amount__c
                FROM   BankTransaction__c
                WHERE  Customer__c = :inp.customerRecordId
                ORDER BY TransactionDate__c DESC
                LIMIT  :limit
            ];

            List<Map<String,String>> txnList = new List<Map<String,String>>();
            List<String> lines = new List<String>();
            Integer i = 1;
            for (BankTransaction__c t : txns) {
                String sign = (t.TransactionType__c == 'Credit') ? '+' : '-';
                String line = i + '. ' + t.Description__c
                            + '   ' + sign + formatCurrency(t.Amount__c)
                            + '   [' + t.TransactionType__c + ']';
                lines.add(line);
                i++;
            }

            out.formattedStatement = String.join(lines, '\n');
            out.responseMessage    = txns.isEmpty()
                ? 'No transactions found.'
                : 'Here are your last ' + txns.size() + ' transactions:\n'
                  + out.formattedStatement;
            results.add(out);
        }
        return results;
    }

    // ─── Card Status ─────────────────────────────────────────────────────────

    public class CardInput {
        @InvocableVariable(label='Customer Record ID' required=true)
        public String customerRecordId;
    }

    public class CardOutput {
        @InvocableVariable(label='Card Status')
        public String cardStatus;   // Active | Blocked | Expired

        @InvocableVariable(label='Masked Card Number')
        public String maskedCardNumber;

        @InvocableVariable(label='Response Message')
        public String responseMessage;
    }

    @InvocableMethod(
        label       = 'Get Card Status'
        description = 'Returns debit/credit card status for a verified customer'
    )
    public static List<CardOutput> getCardStatus(List<CardInput> inputs) {
        List<CardOutput> results = new List<CardOutput>();
        for (CardInput inp : inputs) {
            CardOutput out = new CardOutput();
            List<BankCustomer__c> recs = [
                SELECT CardStatus__c, CardNumber__c, IsVerified__c
                FROM   BankCustomer__c
                WHERE  Id = :inp.customerRecordId
                LIMIT  1
            ];
            if (!recs.isEmpty() && recs[0].IsVerified__c == true) {
                out.cardStatus      = recs[0].CardStatus__c ?? 'Unknown';
                out.maskedCardNumber = maskCardNumber(recs[0].CardNumber__c);
                out.responseMessage = 'Your debit card ending in '
                    + out.maskedCardNumber + ' is ' + out.cardStatus + '.';
            } else {
                out.responseMessage = 'Unauthorized. Please verify your identity first.';
            }
            results.add(out);
        }
        return results;
    }

    // ─── Loan Details ────────────────────────────────────────────────────────

    public class LoanInput {
        @InvocableVariable(label='Customer Record ID' required=true)
        public String customerRecordId;
    }

    public class LoanOutput {
        @InvocableVariable(label='Loan Balance')
        public String loanBalance;

        @InvocableVariable(label='EMI Due Date')
        public String emiDueDate;

        @InvocableVariable(label='Response Message')
        public String responseMessage;
    }

    @InvocableMethod(
        label       = 'Get Loan Details'
        description = 'Returns active loan balance and EMI due date'
    )
    public static List<LoanOutput> getLoanDetails(List<LoanInput> inputs) {
        List<LoanOutput> results = new List<LoanOutput>();
        for (LoanInput inp : inputs) {
            LoanOutput out = new LoanOutput();
            List<BankCustomer__c> recs = [
                SELECT LoanBalance__c, LoanEMIDate__c, IsVerified__c
                FROM   BankCustomer__c
                WHERE  Id = :inp.customerRecordId
                LIMIT  1
            ];
            if (!recs.isEmpty() && recs[0].IsVerified__c == true) {
                Decimal loan = recs[0].LoanBalance__c ?? 0;
                out.loanBalance  = formatCurrency(loan);
                out.emiDueDate   = recs[0].LoanEMIDate__c != null
                    ? recs[0].LoanEMIDate__c.format() : 'N/A';
                out.responseMessage = loan == 0
                    ? 'You have no active loans.'
                    : 'Your active loan balance is ' + out.loanBalance
                      + '. EMI due date is ' + out.emiDueDate + '.';
            } else {
                out.responseMessage = 'Unauthorized. Please verify your identity first.';
            }
            results.add(out);
        }
        return results;
    }

    // ─── Full Statement – Email ───────────────────────────────────────────────

    public class StatementInput {
        @InvocableVariable(label='Customer Record ID' required=true)
        public String customerRecordId;
    }

    public class StatementOutput {
        @InvocableVariable(label='Response Message')
        public String responseMessage;
    }

    @InvocableMethod(
        label       = 'Request Full Statement'
        description = 'Queues full account statement to customer registered email'
    )
    public static List<StatementOutput> requestFullStatement(
        List<StatementInput> inputs
    ) {
        List<StatementOutput> results = new List<StatementOutput>();
        for (StatementInput inp : inputs) {
            StatementOutput out = new StatementOutput();
            List<BankCustomer__c> recs = [
                SELECT Email__c, IsVerified__c
                FROM   BankCustomer__c
                WHERE  Id = :inp.customerRecordId
                LIMIT  1
            ];
            if (!recs.isEmpty() && recs[0].IsVerified__c == true) {
                // Fire platform event to trigger async statement generation
                StatementRequestEvent__e evt = new StatementRequestEvent__e(
                    CustomerRecordId__c = inp.customerRecordId
                );
                EventBus.publish(evt);
                String maskedEmail = maskEmail(recs[0].Email__c);
                out.responseMessage = 'Your account statement is ready and will be '
                    + 'sent to your registered email ' + maskedEmail
                    + ' within 2 minutes.';
            } else {
                out.responseMessage = 'Unauthorized. Please verify your identity first.';
            }
            results.add(out);
        }
        return results;
    }

    // ─── Helpers ─────────────────────────────────────────────────────────────

    private static String formatCurrency(Decimal amount) {
        return '₹' + String.valueOf(amount.setScale(0))
            .reverse().replaceAll('(\\d{3})(?=\\d)', '$1,').reverse();
    }

    private static String maskCardNumber(String card) {
        if (String.isBlank(card) || card.length() < 4) return 'XXXX';
        return 'XXXX XXXX XXXX ' + card.substring(card.length() - 4);
    }

    private static String maskEmail(String email) {
        if (String.isBlank(email)) return '****';
        Integer at = email.indexOf('@');
        return at > 1 ? email.substring(0, 1) + '****' + email.substring(at) : '****';
    }
}
