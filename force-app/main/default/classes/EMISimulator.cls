/**
 * EMISimulator
 * Agentforce Action: calculates 3 loan restructuring options for the customer.
 * Topic: Loan EMI Restructuring
 *
 * Uses Financial_Account__c (custom) with:
 *   Account_Type__c  - "Home Loan" | "Personal Loan" | "Car Loan"
 *   Balance__c       - outstanding loan balance
 *   InterestRate__c  - annual interest rate (%)
 *   MonthlyEMI__c    - current monthly EMI
 *   RemainingTenureMonths__c - months left
 */
public class EMISimulator {

    public class InputWrapper {
        @InvocableVariable(required=true label='Customer Email')
        public String contactEmail;

        @InvocableVariable(label='Loan Type (Home Loan / Personal Loan / Car Loan)')
        public String loanType;
    }

    public class OutputWrapper {
        @InvocableVariable public Boolean success;
        @InvocableVariable public String  errorMessage;

        @InvocableVariable public String  loanAccountName;
        @InvocableVariable public Decimal currentOutstanding;
        @InvocableVariable public Decimal currentEMI;
        @InvocableVariable public Decimal interestRate;
        @InvocableVariable public Integer remainingTenureMonths;

        @InvocableVariable public Decimal optionA_NewEMI;
        @InvocableVariable public Decimal optionA_EMISaving;
        @InvocableVariable public Decimal optionA_ExtraInterest;
        @InvocableVariable public Integer optionA_NewTenure;

        @InvocableVariable public Decimal optionB_NewEMI;
        @InvocableVariable public Decimal optionB_EMISaving;
        @InvocableVariable public Decimal optionB_ExtraInterest;
        @InvocableVariable public Integer optionB_NewTenure;

        @InvocableVariable public Decimal optionC_InterestAccrued;
        @InvocableVariable public Decimal optionC_NewOutstanding;
        @InvocableVariable public Decimal optionC_EMIAfterMoratorium;
        @InvocableVariable public String  optionC_Note;

        @InvocableVariable public String  comparisonSummary;
        @InvocableVariable public String  customerName;
    }

    @InvocableMethod(
        label       = 'EMI Restructuring Simulator'
        description = 'Presents 3 loan restructuring options: extend tenure by 12 months, 24 months, or 3-month EMI moratorium.'
    )
    public static List<OutputWrapper> simulate(List<InputWrapper> inputs) {

        List<OutputWrapper> results = new List<OutputWrapper>();
        OutputWrapper out = new OutputWrapper();

        try {
            InputWrapper inp = inputs[0];

            // 1. Resolve customer via Contact (works with or without Person Accounts)
            List<Contact> cons = [SELECT Id, Name, AccountId FROM Contact WHERE Email = :inp.contactEmail LIMIT 1];
            if (cons.isEmpty()) {
                out.success = false;
                out.errorMessage = 'Customer not found for email: ' + inp.contactEmail;
                results.add(out); return results;
            }
            Id accId = cons[0].AccountId;
            out.customerName = cons[0].Name;

            // 2. Find loan account — covers Home Loan, Personal Loan, Car Loan, Mortgage
            // Build type filter from user input, defaulting to broad loan search
            String typeFilter = '%' + (String.isBlank(inp.loanType) ? 'Loan' : inp.loanType) + '%';

            List<SObject> loans = Database.query(
                'SELECT Id, Name, Account_Type__c, Balance__c, InterestRate__c, ' +
                'MonthlyEMI__c, RemainingTenureMonths__c ' +
                'FROM Financial_Account__c ' +
                'WHERE Account__c = :accId ' +
                'AND Account_Type__c LIKE :typeFilter ' +
                'AND Status__c = \'Active\' ' +
                'ORDER BY Balance__c DESC NULLS LAST LIMIT 1'
            );

            // Fallback 1: search all loan types including Mortgage
            if (loans.isEmpty()) {
                String fallbackFilter = '%Loan%';
                loans = Database.query(
                    'SELECT Id, Name, Account_Type__c, Balance__c, InterestRate__c, ' +
                    'MonthlyEMI__c, RemainingTenureMonths__c ' +
                    'FROM Financial_Account__c ' +
                    'WHERE Account__c = :accId ' +
                    'AND Account_Type__c LIKE :fallbackFilter ' +
                    'AND Status__c = \'Active\' ' +
                    'ORDER BY Balance__c DESC NULLS LAST LIMIT 1'
                );
            }

            // Fallback 2: explicitly search for Mortgage type
            if (loans.isEmpty()) {
                String mortgageFilter = '%Mortgage%';
                loans = Database.query(
                    'SELECT Id, Name, Account_Type__c, Balance__c, InterestRate__c, ' +
                    'MonthlyEMI__c, RemainingTenureMonths__c ' +
                    'FROM Financial_Account__c ' +
                    'WHERE Account__c = :accId ' +
                    'AND Account_Type__c LIKE :mortgageFilter ' +
                    'AND Status__c = \'Active\' ' +
                    'ORDER BY Balance__c DESC NULLS LAST LIMIT 1'
                );
            }

            // Fallback 3: get highest-balance active account (last resort)
            if (loans.isEmpty()) {
                loans = Database.query(
                    'SELECT Id, Name, Account_Type__c, Balance__c, InterestRate__c, ' +
                    'MonthlyEMI__c, RemainingTenureMonths__c ' +
                    'FROM Financial_Account__c ' +
                    'WHERE Account__c = :accId ' +
                    'AND Status__c = \'Active\' ' +
                    'AND Balance__c > 100000 ' +
                    'ORDER BY Balance__c DESC NULLS LAST LIMIT 1'
                );
            }

            if (loans.isEmpty()) {
                out.success = false;
                out.errorMessage = 'No active loan or mortgage account found for this customer.';
                results.add(out); return results;
            }

            SObject loan = loans[0];

            // 3. Extract loan parameters
            String  loanName    = (String)loan.get('Name');
            Decimal outstanding = (Decimal)loan.get('Balance__c');
            Decimal annualRate  = (Decimal)loan.get('InterestRate__c');
            Decimal storedEMI   = (Decimal)loan.get('MonthlyEMI__c');
            Decimal tenureRaw   = (Decimal)loan.get('RemainingTenureMonths__c');

            if (outstanding == null) outstanding = 2000000;
            if (annualRate  == null) annualRate  = 8.65;
            Integer remaining = tenureRaw != null ? Integer.valueOf(tenureRaw) : 120;

            Decimal monthlyRate = annualRate / 100 / 12;
            Decimal currentEMI  = (storedEMI != null && storedEMI > 0)
                                  ? storedEMI
                                  : calcEMI(outstanding, monthlyRate, remaining);

            out.loanAccountName       = loanName;
            out.currentOutstanding    = outstanding.setScale(0);
            out.currentEMI            = currentEMI.setScale(0);
            out.interestRate          = annualRate;
            out.remainingTenureMonths = remaining;

            // 4. Option A - Extend by 12 months
            Integer tenureA   = remaining + 12;
            Decimal emiA      = calcEMI(outstanding, monthlyRate, tenureA);
            Decimal savingA   = currentEMI - emiA;
            Decimal extraIntA = (emiA * tenureA) - (currentEMI * remaining);

            out.optionA_NewEMI        = emiA.setScale(0);
            out.optionA_EMISaving     = savingA.setScale(0);
            out.optionA_ExtraInterest = extraIntA.setScale(0);
            out.optionA_NewTenure     = tenureA;

            // 5. Option B - Extend by 24 months
            Integer tenureB   = remaining + 24;
            Decimal emiB      = calcEMI(outstanding, monthlyRate, tenureB);
            Decimal savingB   = currentEMI - emiB;
            Decimal extraIntB = (emiB * tenureB) - (currentEMI * remaining);

            out.optionB_NewEMI        = emiB.setScale(0);
            out.optionB_EMISaving     = savingB.setScale(0);
            out.optionB_ExtraInterest = extraIntB.setScale(0);
            out.optionB_NewTenure     = tenureB;

            // 6. Option C - 3-Month Moratorium
            Decimal moratInterest  = outstanding * monthlyRate * 3;
            Decimal newOutstanding = outstanding + moratInterest;
            Decimal emiAfterMorat  = calcEMI(newOutstanding, monthlyRate, remaining);

            out.optionC_InterestAccrued    = moratInterest.setScale(0);
            out.optionC_NewOutstanding     = newOutstanding.setScale(0);
            out.optionC_EMIAfterMoratorium = emiAfterMorat.setScale(0);
            out.optionC_Note = 'No EMI for 3 months. Interest of Rs.' + formatAmt(moratInterest)
                + ' added to principal. EMI resumes at Rs.' + formatAmt(emiAfterMorat) + '.';

            // 7. Build comparison summary — attractive chat UI
            List<String> lines = new List<String>();
            lines.add('🏦 *Loan Restructuring Options*');
            lines.add('Hello ' + out.customerName + ', I understand this is a difficult time. Here are your options:');
            lines.add('');
            lines.add('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
            lines.add('📋 *Current Loan Summary*');
            lines.add('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
            lines.add('  Loan        : ' + loanName);
            lines.add('  Outstanding : ₹' + formatAmt(outstanding));
            lines.add('  Current EMI : ₹' + formatAmt(currentEMI) + ' /month');
            lines.add('  Rate        : ' + annualRate + '% p.a.');
            lines.add('  Tenure Left : ' + remaining + ' months');
            lines.add('');
            lines.add('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
            lines.add('✅ *Option A — Extend Tenure by 12 Months*');
            lines.add('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
            lines.add('  New EMI      : ₹' + formatAmt(emiA) + ' /month');
            lines.add('  Monthly Save : ₹' + formatAmt(savingA) + ' 🎉');
            lines.add('  New Tenure   : ' + tenureA + ' months');
            lines.add('  Extra Cost   : ₹' + formatAmt(extraIntA) + ' (added interest)');
            lines.add('');
            lines.add('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
            lines.add('✅ *Option B — Extend Tenure by 24 Months*');
            lines.add('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
            lines.add('  New EMI      : ₹' + formatAmt(emiB) + ' /month');
            lines.add('  Monthly Save : ₹' + formatAmt(savingB) + ' 🎉');
            lines.add('  New Tenure   : ' + tenureB + ' months');
            lines.add('  Extra Cost   : ₹' + formatAmt(extraIntB) + ' (added interest)');
            lines.add('');
            lines.add('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
            lines.add('⏸️ *Option C — 3-Month EMI Holiday (Moratorium)*');
            lines.add('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
            lines.add('  No EMI for   : 3 months (immediate relief)');
            lines.add('  Interest Add : ₹' + formatAmt(moratInterest) + ' added to principal');
            lines.add('  New Principal: ₹' + formatAmt(out.optionC_NewOutstanding));
            lines.add('  EMI After    : ₹' + formatAmt(emiAfterMorat) + ' /month');
            lines.add('');
            lines.add('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
            lines.add('💬 Reply *A*, *B*, or *C* to select your option.');
            lines.add('📞 Your Relationship Manager will call to confirm — *no branch visit needed*.');

            out.comparisonSummary = String.join(lines, '\n');
            out.success = true;

        } catch (Exception e) {
            out.success = false;
            out.errorMessage = 'Error in EMI simulation: ' + e.getMessage();
        }

        results.add(out);
        return results;
    }

    private static Decimal calcEMI(Decimal principal, Decimal monthlyRate, Integer months) {
        if (monthlyRate == 0) return (principal / months).setScale(2);
        Decimal factor = (1 + monthlyRate).pow(months);
        return (principal * monthlyRate * factor / (factor - 1)).setScale(2);
    }

    private static String formatAmt(Decimal amount) {
        if (amount == null) return '0';
        Long   amt    = amount.longValue();
        String s      = String.valueOf(Math.abs(amt));
        if (s.length() <= 3) return s;
        String last3  = s.right(3);
        String rest   = s.left(s.length() - 3);
        String result = '';
        while (rest.length() > 2) { result = ',' + rest.right(2) + result; rest = rest.left(rest.length() - 2); }
        return rest + result + ',' + last3;
    }
}
