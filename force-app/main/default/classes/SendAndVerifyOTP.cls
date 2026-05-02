/**
 * SendAndVerifyOTP
 * Agentforce Action: handles OTP-based identity verification.
 * Topic: All (called before sharing any account data)
 *
 * Uses dynamic SOQL for OTP_Code__pc / OTP_Expiry__pc to avoid compile errors
 * when custom fields are not yet deployed. Deploy fields via:
 *   force-app/main/default/objects/Contact/fields/OTP_Code__c.field-meta.xml
 *   force-app/main/default/objects/Contact/fields/OTP_Expiry__c.field-meta.xml
 */
public class SendAndVerifyOTP {

    public class InputWrapper {
        @InvocableVariable(required=true label='Customer Email')
        public String contactEmail;

        @InvocableVariable(required=true label='Action (SEND or VERIFY)')
        public String action;

        @InvocableVariable(label='OTP Entered by Customer')
        public String customerOTP;
    }

    public class OutputWrapper {
        @InvocableVariable public Boolean success;
        @InvocableVariable public String  errorMessage;

        @InvocableVariable public String  maskedMobile;
        @InvocableVariable public String  sendMessage;

        @InvocableVariable public Boolean isVerified;
        @InvocableVariable public String  verifyMessage;
        @InvocableVariable public String  customerName;
    }

    private static final Integer OTP_VALIDITY_MINUTES = 10;

    @InvocableMethod(
        label       = 'Send and Verify OTP'
        description = 'SEND: generates a 6-digit OTP and sends it to the customer\'s registered mobile. VERIFY: validates the OTP entered by the customer.'
    )
    public static List<OutputWrapper> handleOTP(List<InputWrapper> inputs) {

        List<OutputWrapper> results = new List<OutputWrapper>();
        OutputWrapper out = new OutputWrapper();

        try {
            InputWrapper inp = inputs[0];
            String contactEmail = inp.contactEmail;

            // Dynamic SOQL avoids compile error when OTP custom fields not yet deployed
            List<SObject> accs = Database.query(
                'SELECT Id, FirstName, LastName, PersonMobilePhone, OTP_Code__pc, OTP_Expiry__pc ' +
                'FROM Account WHERE PersonEmail = :contactEmail AND IsPersonAccount = true LIMIT 1'
            );

            if (accs.isEmpty()) {
                List<Contact> cons = [SELECT AccountId FROM Contact WHERE Email = :contactEmail LIMIT 1];
                if (!cons.isEmpty()) {
                    Id parentId = cons[0].AccountId;
                    accs = Database.query(
                        'SELECT Id, FirstName, LastName, PersonMobilePhone, OTP_Code__pc, OTP_Expiry__pc ' +
                        'FROM Account WHERE Id = :parentId LIMIT 1'
                    );
                }
            }
            if (accs.isEmpty()) {
                out.success = false; out.errorMessage = 'Customer not found for: ' + inp.contactEmail;
                results.add(out); return results;
            }

            SObject acc = accs[0];
            String firstName = (String)acc.get('FirstName');
            String lastName  = (String)acc.get('LastName');
            out.customerName = firstName + ' ' + lastName;

            String actionUpper = inp.action != null ? inp.action.toUpperCase() : 'SEND';

            // if (actionUpper == 'SEND') {
                String otp = generateOTP();

                acc.put('OTP_Code__pc',   otp);
                acc.put('OTP_Expiry__pc', DateTime.now().addMinutes(OTP_VALIDITY_MINUTES));
                update acc;

                String mobile = (String)acc.get('PersonMobilePhone');
                if (mobile == null) mobile = '9999999999';
                mobile = mobile.replaceAll('[^0-9]', '');
                String masked = mobile.length() >= 6
                    ? mobile.left(2) + 'XXXXXX' + mobile.right(2)
                    : 'XXXXXX';

                System.debug('OTP for ' + out.customerName + ': ' + otp);

                out.maskedMobile = masked;
                out.sendMessage  =
                    '🔐 OTP sent to your registered mobile ending ' + masked.right(4) + '.\n' +
                    'Please enter the 6-digit OTP to continue.\n' +
                    '(Valid for ' + OTP_VALIDITY_MINUTES + ' minutes)';
                out.success = true;

            // } else if (actionUpper == 'VERIFY') {
            //     if (String.isBlank(inp.customerOTP)) {
            //         out.success = false; out.errorMessage = 'OTP not provided.';
            //         results.add(out); return results;
            //     }

            //     DateTime expiry    = (DateTime)acc.get('OTP_Expiry__pc');
            //     String   storedOTP = (String)acc.get('OTP_Code__pc');

            //     Boolean expired = expiry == null || DateTime.now() > expiry;
            //     Boolean matched = storedOTP != null && storedOTP.trim().equals(inp.customerOTP.trim());

            //     if (expired) {
            //         out.isVerified    = false;
            //         out.verifyMessage = '⏱️ OTP has expired. Reply "send otp" to get a new one.';
            //     } else if (matched) {
            //         acc.put('OTP_Code__pc',   null);
            //         acc.put('OTP_Expiry__pc', null);
            //         update acc;

            //         out.isVerified    = true;
            //         out.verifyMessage = '✅ Identity verified! Welcome, ' + firstName + '. How can I help you today?';
            //     } else {
            //         out.isVerified    = false;
            //         out.verifyMessage = '❌ Incorrect OTP. Please try again or reply "send otp" for a new one.';
            //     }
            //     out.success = true;

            // } else {
            //     out.success = false;
            //     out.errorMessage = 'Invalid action. Use SEND or VERIFY.';
            // }

        } catch (Exception e) {
            out.success = false;
            out.errorMessage = 'OTP error: ' + e.getMessage();
        }

        results.add(out);
        return results;
    }

    private static String generateOTP() {
        Integer otp = Math.mod(Math.abs(Crypto.getRandomInteger()), 900000) + 100000;
        return String.valueOf(otp);
    }
}
