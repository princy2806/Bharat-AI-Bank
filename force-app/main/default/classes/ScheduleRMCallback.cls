/**
 * ScheduleRMCallback
 * Agentforce Action: schedules a callback with the customer's Relationship Manager.
 * Topic: Loan EMI Restructuring (and general escalation)
 * - Creates a Task on the Account for the RM
 * - Stores the customer's selected restructuring option (if any)
 * - Returns confirmation message for the agent to relay
 */
public class ScheduleRMCallback {

    public class InputWrapper {
        @InvocableVariable(required=true label='Customer Email')
        public String contactEmail;

        // What the customer selected or wants to discuss
        @InvocableVariable(label='Selected Option or Topic')
        public String selectedOption;

        // When customer wants the callback (free text from conversation)
        @InvocableVariable(label='Preferred Date (YYYY-MM-DD)')
        public String preferredDate;

        @InvocableVariable(label='Preferred Time (e.g. 10:00 AM)')
        public String preferredTime;

        // Additional context to brief the RM
        @InvocableVariable(label='Context / Notes for RM')
        public String contextNotes;
    }

    public class OutputWrapper {
        @InvocableVariable public Boolean success;
        @InvocableVariable public String  errorMessage;
        @InvocableVariable public String  confirmationMessage;
        @InvocableVariable public String  taskId;
        @InvocableVariable public String  rmName;
        @InvocableVariable public String  scheduledDateTime;
    }

    @InvocableMethod(
        label       = 'Schedule RM Callback'
        description = 'Schedules a callback with the customer\'s Relationship Manager. Creates a Task briefing the RM on the customer\'s request.'
    )
    public static List<OutputWrapper> scheduleCallback(List<InputWrapper> inputs) {

        List<OutputWrapper> results = new List<OutputWrapper>();
        OutputWrapper out = new OutputWrapper();

        try {
            InputWrapper inp = inputs[0];

            // Resolve customer via Contact (no Person Account dependency)
            List<Contact> cons = [SELECT Id, Name, AccountId FROM Contact WHERE Email = :inp.contactEmail LIMIT 1];
            if (cons.isEmpty()) {
                out.success = false; out.errorMessage = 'Customer not found for email: ' + inp.contactEmail;
                results.add(out); return results;
            }
            String customerNm = cons[0].Name;
            Id accId = cons[0].AccountId;

            List<Account> accs = [SELECT Id, OwnerId, Owner.Name FROM Account WHERE Id = :accId LIMIT 1];
            if (accs.isEmpty()) {
                out.success = false; out.errorMessage = 'Account not found.';
                results.add(out); return results;
            }
            Account acc = accs[0];

            // Determine callback date
            Date callbackDate;
            if (!String.isBlank(inp.preferredDate)) {
                try { callbackDate = Date.valueOf(inp.preferredDate); } catch(Exception ex) { callbackDate = Date.today().addDays(1); }
            } else {
                // Next business day
                callbackDate = Date.today().addDays(1);
                if (callbackDate.toStartOfWeek() == callbackDate) callbackDate = callbackDate.addDays(1); // skip Sunday
            }

            String timeStr    = String.isBlank(inp.preferredTime) ? '10:00 AM' : inp.preferredTime;
            String rmName2    = acc.Owner.Name != null ? acc.Owner.Name : 'Your Relationship Manager';
            String option     = String.isBlank(inp.selectedOption) ? 'Loan restructuring discussion' : inp.selectedOption;
            String notes      = String.isBlank(inp.contextNotes)   ? '' : '\n\nAdditional Context:\n' + inp.contextNotes;

            // Task description briefs the RM fully
            String taskDesc =
                'AGENTFORCE SCHEDULED CALLBACK\n' +
                '================================\n' +
                'Customer       : ' + customerNm + '\n' +
                'Email          : ' + inp.contactEmail + '\n' +
                'Requested Via  : WhatsApp (Agentforce Self-Serve)\n' +
                'Selected Option: ' + option + '\n' +
                'Preferred Time : ' + timeStr + ' on ' + callbackDate.format() + '\n' +
                '================================\n' +
                'BRIEFING FOR RM:\n' +
                'Customer has used the self-serve agent to explore loan restructuring.\n' +
                'They have selected: ' + option + '\n' +
                'Please review their FSC profile before the call — all documents are\n' +
                'already on file (income proof, ID documents). No re-submission needed.\n' +
                notes;

            Task callbackTask = new Task(
                Subject         = 'RM Callback: ' + customerNm + ' — ' + option,
                Description     = taskDesc,
                Status          = 'Not Started',
                Priority        = 'High',
                ActivityDate    = callbackDate,
                WhatId          = acc.Id,
                OwnerId         = acc.OwnerId,   // assigned to RM (account owner)
                Type            = 'Call',
                CallType        = 'Outbound'
            );
            insert callbackTask;

            out.taskId            = callbackTask.Id;
            out.rmName            = rmName2;
            out.scheduledDateTime = timeStr + ' on ' + callbackDate.format();

            out.confirmationMessage =
                '📞 Callback Scheduled!\n\n' +
                'Your Relationship Manager ' + rmName2 + ' will call you at:\n' +
                '📅 ' + callbackDate.format() + ' at ' + timeStr + '\n\n' +
                '📋 Topic: ' + option + '\n\n' +
                '✅ The RM has been fully briefed — your existing documents on file\n' +
                '   will be used. No paperwork needed from your side.\n\n' +
                'If you need to reschedule, reply "reschedule callback".';

            out.success = true;

        } catch (Exception e) {
            out.success = false;
            out.errorMessage = 'Error scheduling callback: ' + e.getMessage();
        }

        results.add(out);
        return results;
    }
}
