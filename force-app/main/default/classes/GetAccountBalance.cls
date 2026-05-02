/**
 * GetAccountBalance
 * Agentforce Action: returns all financial account balances for a customer.
 * Topic: Account Balance and Statement
 * Uses Financial_Account__c (custom object) linked to Account via Account__c lookup.
 */
public class GetAccountBalance {

    public class InputWrapper {
        @InvocableVariable(required=true label='Customer Email')
        public String contactEmail;
    }

    public class OutputWrapper {
        @InvocableVariable public Boolean success;
        @InvocableVariable public String  errorMessage;

        @InvocableVariable public String  balanceSummary;

        @InvocableVariable public String  savingsAccountNumber;
        @InvocableVariable public Decimal savingsBalance;

        @InvocableVariable public String  creditCardNumber;
        @InvocableVariable public Decimal creditCardOutstanding;
        @InvocableVariable public Decimal creditCardLimit;
        @InvocableVariable public Decimal creditCardAvailable;

        @InvocableVariable public String  loanAccountNumber;
        @InvocableVariable public Decimal loanOutstanding;
        @InvocableVariable public Decimal loanEMI;

        @InvocableVariable public String  customerName;
    }

    @InvocableMethod(
        label       = 'Get Account Balance'
        description = 'Returns savings, credit card, and loan balances for the authenticated customer.'
    )
    public static List<OutputWrapper> getBalance(List<InputWrapper> inputs) {

        List<OutputWrapper> results = new List<OutputWrapper>();
        OutputWrapper out = new OutputWrapper();

        try {
            if (inputs == null || inputs.isEmpty() || String.isBlank(inputs[0].contactEmail)) {
                out.success = false;
                out.errorMessage = 'Customer email is required.';
                results.add(out); return results;
            }

            String email = inputs[0].contactEmail;

            // Resolve Account from email (Person Account or Contact)
            List<Account> accs = [
                SELECT Id, FirstName, LastName
                FROM   Account
                WHERE  PersonEmail = :email
                AND    IsPersonAccount = true
                LIMIT  1
            ];
            if (accs.isEmpty()) {
                List<Contact> cons = [SELECT AccountId FROM Contact WHERE Email = :email LIMIT 1];
                if (cons.isEmpty()) {
                    out.success = false; out.errorMessage = 'No customer found for email: ' + email;
                    results.add(out); return results;
                }
                accs = [SELECT Id, FirstName, LastName FROM Account WHERE Id = :cons[0].AccountId LIMIT 1];
            }

            Account acc = accs[0];
            out.customerName = acc.FirstName + ' ' + acc.LastName;

            // Query Financial_Account__c using our custom object
            List<Financial_Account__c> finAccs = [
                SELECT Id, Name, FinancialAccountNumber__c, Account_Type__c,
                       Balance__c, CreditLimit__c, AvailableBalance__c,
                       InterestRate__c, MonthlyEMI__c, RemainingTenureMonths__c
                FROM   Financial_Account__c
                WHERE  Account__c = :acc.Id
                AND    Status__c  = 'Active'
            ];

            List<String> summaryLines = new List<String>();
            summaryLines.add('Account summary for ' + out.customerName + ':');
            summaryLines.add('');

            for (Financial_Account__c fa : finAccs) {
                String faType    = fa.Account_Type__c;
                String acctNum   = maskAccountNumber(fa.FinancialAccountNumber__c != null ? fa.FinancialAccountNumber__c : fa.Name);

                if (faType == 'SavingsAccount' || faType == 'CurrentAccount') {
                    out.savingsAccountNumber = acctNum;
                    out.savingsBalance       = fa.Balance__c != null ? fa.Balance__c : 0;
                    summaryLines.add('🏦 ' + faType + ' (' + acctNum + '): ₹' + formatAmount(out.savingsBalance));

                } else if (faType == 'CreditCard') {
                    out.creditCardNumber      = acctNum;
                    out.creditCardOutstanding = fa.Balance__c != null ? fa.Balance__c : 0;
                    out.creditCardLimit       = fa.CreditLimit__c != null ? fa.CreditLimit__c : 0;
                    out.creditCardAvailable   = fa.AvailableBalance__c != null
                                               ? fa.AvailableBalance__c
                                               : (out.creditCardLimit - out.creditCardOutstanding);
                    summaryLines.add('💳 Credit Card (' + acctNum + '):');
                    summaryLines.add('   Outstanding : ₹' + formatAmount(out.creditCardOutstanding));
                    summaryLines.add('   Available   : ₹' + formatAmount(out.creditCardAvailable));
                    summaryLines.add('   Limit       : ₹' + formatAmount(out.creditCardLimit));

                } else if (faType == 'HomeLoan' || faType == 'PersonalLoan' || faType == 'CarLoan') {
                    // Show the first / highest-balance loan
                    if (out.loanAccountNumber == null) {
                        out.loanAccountNumber = acctNum;
                        out.loanOutstanding   = fa.Balance__c != null ? fa.Balance__c : 0;
                        out.loanEMI           = fa.MonthlyEMI__c != null ? fa.MonthlyEMI__c : 0;
                        summaryLines.add('🏠 ' + faType + ' (' + acctNum + '):');
                        summaryLines.add('   Outstanding : ₹' + formatAmount(out.loanOutstanding));
                        if (out.loanEMI > 0) {
                            summaryLines.add('   Monthly EMI : ₹' + formatAmount(out.loanEMI));
                        }
                    }

                } else if (faType == 'FixedDeposit' || faType == 'RecurringDeposit' || faType == 'MutualFund' || faType == 'Mortgage') {
                    summaryLines.add('📈 ' + faType + ' (' + acctNum + '): ₹' + formatAmount(fa.Balance__c != null ? fa.Balance__c : 0));
                }
            }

            if (summaryLines.size() == 2) {
                summaryLines.add('No active accounts found.');
            }

            summaryLines.add('');
            summaryLines.add('Balance as of ' + Date.today().format() + '. Reply "transactions" for mini-statement.');

            out.balanceSummary = String.join(summaryLines, '\n');
            out.success = true;

        } catch (Exception e) {
            out.success = false;
            out.errorMessage = 'Error fetching balance: ' + e.getMessage();
        }

        results.add(out);
        return results;
    }

    private static String maskAccountNumber(String num) {
        if (String.isBlank(num)) return 'XXXX';
        return num.length() > 4 ? 'XXXX' + num.right(4) : num;
    }

    private static String formatAmount(Decimal amount) {
        if (amount == null) return '0';
        Long amt  = amount.longValue();
        String s  = String.valueOf(Math.abs(amt));
        if (s.length() <= 3) return (amount < 0 ? '-' : '') + s;
        String last3 = s.right(3);
        String rest  = s.left(s.length() - 3);
        String result = '';
        while (rest.length() > 2) {
            result = ',' + rest.right(2) + result;
            rest   = rest.left(rest.length() - 2);
        }
        result = rest + result;
        return (amount < 0 ? '-' : '') + result + ',' + last3;
    }
}
