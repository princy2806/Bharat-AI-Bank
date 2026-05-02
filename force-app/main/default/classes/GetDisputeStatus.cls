/**
 * GetDisputeStatus
 * Agentforce Action: returns current status of a customer's open dispute cases.
 * Topic: Credit Card Dispute
 */
public class GetDisputeStatus {

    public class InputWrapper {
        @InvocableVariable(required=true label='Customer Email')
        public String contactEmail;

        // Optional — if customer provides their case number directly
        @InvocableVariable(label='Case Number')
        public String caseNumber;
    }

    public class OutputWrapper {
        @InvocableVariable public Boolean success;
        @InvocableVariable public String  errorMessage;
        @InvocableVariable public String  statusSummary;
        @InvocableVariable public Integer openCaseCount;
    }

    @InvocableMethod(
        label       = 'Get Dispute Status'
        description = 'Returns the current status of all open credit card dispute cases for the customer.'
    )
    public static List<OutputWrapper> getStatus(List<InputWrapper> inputs) {

        List<OutputWrapper> results = new List<OutputWrapper>();
        OutputWrapper out = new OutputWrapper();

        try {
            InputWrapper inp = inputs[0];

            // Resolve Account
            List<Account> accs = [
                SELECT Id, FirstName, LastName
                FROM   Account
                WHERE  PersonEmail = :inp.contactEmail
                AND    IsPersonAccount = true
                LIMIT  1
            ];
            if (accs.isEmpty()) {
                List<Contact> cons = [SELECT AccountId FROM Contact WHERE Email = :inp.contactEmail LIMIT 1];
                if (!cons.isEmpty()) accs = [SELECT Id, FirstName, LastName FROM Account WHERE Id = :cons[0].AccountId LIMIT 1];
            }
            if (accs.isEmpty()) {
                out.success = false; out.errorMessage = 'Customer not found.';
                results.add(out); return results;
            }
            Account acc = accs[0];

            // Fetch cases
            List<Case> cases;
            if (!String.isBlank(inp.caseNumber)) {
                cases = [
                    SELECT CaseNumber, Subject, Status, CreatedDate, LastModifiedDate, Description
                    FROM   Case
                    WHERE  AccountId = :acc.Id
                    AND    CaseNumber = :inp.caseNumber
                    AND    Type = 'Credit Card Dispute'
                    LIMIT  1
                ];
            } else {
                cases = [
                    SELECT CaseNumber, Subject, Status, CreatedDate, LastModifiedDate
                    FROM   Case
                    WHERE  AccountId = :acc.Id
                    AND    Type = 'Credit Card Dispute'
                    AND    IsClosed = false
                    ORDER  BY CreatedDate DESC
                    LIMIT  5
                ];
            }

            if (cases.isEmpty()) {
                out.success       = true;
                out.statusSummary = 'No open dispute cases found for ' + acc.FirstName + '. If you recently filed a dispute, it may take a few minutes to appear.';
                out.openCaseCount = 0;
                results.add(out); return results;
            }

            List<String> lines = new List<String>();
            lines.add('Dispute status for ' + acc.FirstName + ':');
            lines.add('');

            for (Case c : cases) {
                String stage = getStageEmoji(c.Status);
                lines.add('📋 Case: ' + c.CaseNumber);
                lines.add('   Subject: ' + c.Subject);
                lines.add('   Status: ' + stage + ' ' + c.Status);
                lines.add('   Filed On: ' + c.CreatedDate.format());
                lines.add('   Last Updated: ' + c.LastModifiedDate.format());
                lines.add('');
            }

            lines.add('For urgent assistance, reply "callback" to speak to your Relationship Manager.');

            out.statusSummary = String.join(lines, '\n');
            out.openCaseCount = cases.size();
            out.success       = true;

        } catch (Exception e) {
            out.success = false;
            out.errorMessage = 'Error fetching dispute status: ' + e.getMessage();
        }

        results.add(out);
        return results;
    }

    private static String getStageEmoji(String status) {
        if (status == null) return '⏳';
        if (status.equalsIgnoreCase('New'))         return '🆕';
        if (status.equalsIgnoreCase('In Progress') ||
            status.equalsIgnoreCase('Working'))     return '🔄';
        if (status.equalsIgnoreCase('Escalated'))   return '⚠️';
        if (status.equalsIgnoreCase('Closed') ||
            status.equalsIgnoreCase('Resolved'))    return '✅';
        return '⏳';
    }
}
