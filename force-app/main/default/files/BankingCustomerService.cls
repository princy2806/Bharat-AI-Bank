/**
 * BankingCustomerService
 * Handles customer lookup by Customer ID, Mobile, or Email.
 * Used by Agentforce Service Agent actions and Salesforce Flows.
 *
 * Object assumed: BankCustomer__c (custom object)
 * Fields: CustomerID__c, MobilePhone__c, Email__c, Name,
 *         AccountBalance__c, CardStatus__c, LoanBalance__c,
 *         LoanEMIDate__c, IsVerified__c, FailedOTPAttempts__c,
 *         IsLocked__c, LastOTP__c, OTPExpiry__c
 */
public with sharing class BankingCustomerService {

    // ─── DTOs ────────────────────────────────────────────────────────────────

    public class CustomerResult {
        @AuraEnabled public Boolean found       { get; set; }
        @AuraEnabled public String  customerId  { get; set; }
        @AuraEnabled public String  maskedPhone { get; set; }
        @AuraEnabled public String  maskedEmail { get; set; }
        @AuraEnabled public String  message     { get; set; }
    }

    public class VerificationInput {
        @InvocableVariable(label='Input Value' required=true)
        public String inputValue;   // Customer ID, mobile, or email
    }

    public class VerificationOutput {
        @InvocableVariable(label='Customer Found')
        public Boolean customerFound;

        @InvocableVariable(label='Customer Record ID')
        public String  customerRecordId;

        @InvocableVariable(label='Masked Contact')
        public String  maskedContact;   // e.g. "98****8765"

        @InvocableVariable(label='Response Message')
        public String  responseMessage;

        @InvocableVariable(label='Is Locked')
        public Boolean isLocked;
    }

    // ─── Invocable – called from Flow / Agentforce Action ────────────────────

    @InvocableMethod(
        label       = 'Verify Banking Customer'
        description = 'Looks up a customer by Customer ID, mobile, or email'
        callout     = false
    )
    public static List<VerificationOutput> verifyCustomer(
        List<VerificationInput> inputs
    ) {
        List<VerificationOutput> results = new List<VerificationOutput>();

        for (VerificationInput inp : inputs) {
            VerificationOutput out = new VerificationOutput();
            String val = inp.inputValue?.trim();

            if (String.isBlank(val)) {
                out.customerFound   = false;
                out.responseMessage = 'Please provide a Customer ID, mobile number, or email address.';
                results.add(out);
                continue;
            }

            // Query by all three fields in one SOQL
            List<BankCustomer__c> records = [
                SELECT Id, Name, CustomerID__c,
                       MobilePhone__c, Email__c,
                       IsLocked__c, FailedOTPAttempts__c
                FROM   BankCustomer__c
                WHERE  CustomerID__c   = :val
                OR     MobilePhone__c  = :val
                OR     Email__c        = :val
                LIMIT  1
            ];

            if (records.isEmpty()) {
                out.customerFound   = false;
                out.responseMessage =
                    'The details entered seem incorrect. Please provide a valid '
                    + 'Customer ID, registered mobile number, or email address.';
            } else {
                BankCustomer__c rec = records[0];

                if (rec.IsLocked__c == true) {
                    out.customerFound   = true;
                    out.isLocked        = true;
                    out.customerRecordId = rec.Id;
                    out.responseMessage =
                        'Your account is currently locked due to multiple failed attempts. '
                        + 'Please contact support at 1800-XXX-XXXX.';
                } else {
                    out.customerFound    = true;
                    out.isLocked         = false;
                    out.customerRecordId = rec.Id;
                    out.maskedContact    = maskContact(rec.MobilePhone__c, rec.Email__c);
                    out.responseMessage  =
                        'We have sent a One-Time Password (OTP) to your registered '
                        + 'mobile/email ending with ' + out.maskedContact
                        + '. Please enter the OTP to continue.';
                }
            }
            results.add(out);
        }
        return results;
    }

    // ─── Helper ──────────────────────────────────────────────────────────────

    private static String maskContact(String phone, String email) {
        if (String.isNotBlank(phone) && phone.length() >= 4) {
            return phone.substring(0, 2) + '****'
                + phone.substring(phone.length() - 4);
        }
        if (String.isNotBlank(email)) {
            Integer atIdx = email.indexOf('@');
            if (atIdx > 1) {
                return email.substring(0, 1) + '****'
                    + email.substring(atIdx);
            }
        }
        return 'XXXX';
    }
}
