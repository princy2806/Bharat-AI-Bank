/**
 * BankingOTPService
 * Generates, stores, and validates OTPs for banking customer verification.
 * Integrates with SMS / Email platform events or a messaging provider
 * (e.g. Twilio, Salesforce Messaging).
 */
public with sharing class BankingOTPService {

    private static final Integer OTP_EXPIRY_MINUTES = 5;
    private static final Integer MAX_ATTEMPTS       = 3;
    private static final Integer OTP_LENGTH         = 6;

    // ─── Generate OTP ────────────────────────────────────────────────────────

    public class GenerateInput {
        @InvocableVariable(label='Customer Record ID' required=true)
        public String customerRecordId;
    }

    public class GenerateOutput {
        @InvocableVariable(label='OTP Sent')
        public Boolean otpSent;

        @InvocableVariable(label='Response Message')
        public String  responseMessage;

        @InvocableVariable(label='Expiry Time (ISO)')
        public String  expiryTime;
    }

    @InvocableMethod(
        label       = 'Generate and Send Banking OTP'
        description = 'Creates a 6-digit OTP, stores it on the customer record, and triggers SMS/Email'
        callout     = true
    )
    public static List<GenerateOutput> generateOTP(
        List<GenerateInput> inputs
    ) {
        List<GenerateOutput> results = new List<GenerateOutput>();

        for (GenerateInput inp : inputs) {
            GenerateOutput out = new GenerateOutput();
            try {
                String otp        = generateSecureOTP();
                DateTime expiry   = DateTime.now().addMinutes(OTP_EXPIRY_MINUTES);

                // Persist OTP on customer record (hashed in production)
                BankCustomer__c rec = new BankCustomer__c(
                    Id               = inp.customerRecordId,
                    LastOTP__c       = hashOTP(otp),   // never store plain-text
                    OTPExpiry__c     = expiry,
                    FailedOTPAttempts__c = 0
                );
                update rec;

                // Fire platform event to trigger SMS / Email via messaging service
                OTPSendEvent__e evt = new OTPSendEvent__e(
                    CustomerRecordId__c = inp.customerRecordId,
                    OTPCode__c          = otp,            // plain OTP to sender only
                    ExpiryMinutes__c    = OTP_EXPIRY_MINUTES
                );
                EventBus.publish(evt);

                out.otpSent         = true;
                out.expiryTime      = expiry.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
                out.responseMessage = 'OTP sent successfully. It is valid for '
                                    + OTP_EXPIRY_MINUTES + ' minutes.';
            } catch (Exception e) {
                out.otpSent         = false;
                out.responseMessage = 'Unable to send OTP. Please try again. Error: '
                                    + e.getMessage();
            }
            results.add(out);
        }
        return results;
    }

    // ─── Validate OTP ────────────────────────────────────────────────────────

    public class ValidateInput {
        @InvocableVariable(label='Customer Record ID' required=true)
        public String customerRecordId;

        @InvocableVariable(label='OTP Entered by Customer' required=true)
        public String enteredOTP;
    }

    public class ValidateOutput {
        @InvocableVariable(label='Is Valid')
        public Boolean isValid;

        @InvocableVariable(label='Is Expired')
        public Boolean isExpired;

        @InvocableVariable(label='Is Locked')
        public Boolean isLocked;

        @InvocableVariable(label='Attempts Remaining')
        public Integer attemptsRemaining;

        @InvocableVariable(label='Response Message')
        public String  responseMessage;
    }

    @InvocableMethod(
        label       = 'Validate Banking OTP'
        description = 'Validates the OTP entered by the customer; tracks failed attempts and locks after 3'
        callout     = false
    )
    public static List<ValidateOutput> validateOTP(
        List<ValidateInput> inputs
    ) {
        List<ValidateOutput> results = new List<ValidateOutput>();

        for (ValidateInput inp : inputs) {
            ValidateOutput out = new ValidateOutput();

            List<BankCustomer__c> records = [
                SELECT Id, LastOTP__c, OTPExpiry__c,
                       FailedOTPAttempts__c, IsLocked__c
                FROM   BankCustomer__c
                WHERE  Id = :inp.customerRecordId
                LIMIT  1
            ];

            if (records.isEmpty()) {
                out.isValid         = false;
                out.responseMessage = 'Customer record not found.';
                results.add(out);
                continue;
            }

            BankCustomer__c rec = records[0];

            // Already locked
            if (rec.IsLocked__c == true) {
                out.isLocked        = true;
                out.isValid         = false;
                out.responseMessage =
                    'Your verification session has been locked for security reasons. '
                    + 'Please try again later or contact support.';
                results.add(out);
                continue;
            }

            // OTP expired
            if (rec.OTPExpiry__c == null || rec.OTPExpiry__c < DateTime.now()) {
                out.isExpired       = true;
                out.isValid         = false;
                out.responseMessage = 'OTP has expired. Would you like me to resend a new OTP?';
                results.add(out);
                continue;
            }

            // Validate hash
            Boolean match = (rec.LastOTP__c == hashOTP(inp.enteredOTP));

            if (match) {
                // Clear OTP fields on success
                rec.LastOTP__c           = null;
                rec.OTPExpiry__c         = null;
                rec.FailedOTPAttempts__c = 0;
                rec.IsVerified__c        = true;
                update rec;

                out.isValid             = true;
                out.attemptsRemaining   = MAX_ATTEMPTS;
                out.responseMessage     = 'Identity verified successfully. How may I assist you today?';
            } else {
                Integer attempts = (rec.FailedOTPAttempts__c == null ? 0
                    : (Integer) rec.FailedOTPAttempts__c) + 1;
                rec.FailedOTPAttempts__c = attempts;

                if (attempts >= MAX_ATTEMPTS) {
                    rec.IsLocked__c     = true;
                    out.isLocked        = true;
                    out.responseMessage =
                        'Your verification session has been locked for security reasons. '
                        + 'Please try again later or contact support.';
                } else {
                    out.attemptsRemaining = MAX_ATTEMPTS - attempts;
                    out.responseMessage   = 'Invalid OTP. Please try again. ('
                                          + out.attemptsRemaining + ' attempt'
                                          + (out.attemptsRemaining == 1 ? '' : 's')
                                          + ' remaining)';
                }
                update rec;
                out.isValid = false;
            }
            results.add(out);
        }
        return results;
    }

    // ─── Helpers ─────────────────────────────────────────────────────────────

    private static String generateSecureOTP() {
        Blob randomBytes = Crypto.generateAesKey(128);
        String hex       = EncodingUtil.convertToHex(randomBytes);
        Long   num       = Long.valueOf('1' + hex.substring(0, 6), 16);
        return String.valueOf(Math.abs(Math.mod((Integer)num, 900000)) + 100000);
    }

    private static String hashOTP(String otp) {
        Blob   hash = Crypto.generateDigest('SHA-256', Blob.valueOf(otp));
        return EncodingUtil.convertToHex(hash);
    }
}
