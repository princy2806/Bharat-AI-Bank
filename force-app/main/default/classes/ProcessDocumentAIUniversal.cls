public class ProcessDocumentAIUniversal {

    private static final String CONTENT_TYPE = 'application/json';

    private static final String CLIENT_ID     = Label.Consumer_Key;
    private static final String CLIENT_SECRET = Label.Consumer_Secret;

    // ─────────────────────────────────────────
    //  INPUT / OUTPUT
    // ─────────────────────────────────────────
    public class InputWrapper {
        @InvocableVariable(required=true) public String contactEmail;
        @InvocableVariable(required=true) public String idpConfigurationIdOrName;
    }

    public class OutputWrapper {
        @InvocableVariable public Boolean success;
        @InvocableVariable public String  errorMessage;
        @InvocableVariable public String  resultJson;
        @InvocableVariable public String  rawResponse;
        @InvocableVariable public String  schemaUsed;
        @InvocableVariable public String  documentTitle;   // which file was actually used
    }

    private class InternalResponse {
        public Boolean success;
        public String  errorMessage;
        public String  extractedDataJson;
        public String  rawResponse;
    }

    // ─────────────────────────────────────────
    //  INVOCABLE ENTRY POINT
    // ─────────────────────────────────────────
    @InvocableMethod(label='Document AI Universal Extractor (Dynamic Schema)')
    public static List<OutputWrapper> extractDocument(List<InputWrapper> inputList) {

        List<OutputWrapper> outputs = new List<OutputWrapper>();
        OutputWrapper out = new OutputWrapper();

        try {
            if (inputList == null || inputList.isEmpty()) {
                out.success = false; out.errorMessage = 'Input list is empty.';
                outputs.add(out); return outputs;
            }

            InputWrapper inp = inputList[0];

            if (String.isBlank(inp.contactEmail)) {
                out.success = false; out.errorMessage = 'contactEmail is missing.';
                outputs.add(out); return outputs;
            }
            if (String.isBlank(inp.idpConfigurationIdOrName)) {
                out.success = false; out.errorMessage = 'idpConfigurationIdOrName is missing.';
                outputs.add(out); return outputs;
            }

            // ── 1. Resolve the entity (Account) to look up files ──────────────
            //    Files are attached via FirstPublishLocationId = Account.Id
            //    so we must query ContentDocumentLink using the Account Id,
            //    NOT the Contact Id.
            Id entityId = resolveAccountId(inp.contactEmail);

            if (entityId == null) {
                out.success = false;
                out.errorMessage = 'No Person Account found for email: ' + inp.contactEmail;
                outputs.add(out); return outputs;
            }

            // ── 2. Build title pattern: keyword + ' - ' + AccountName ─────────
            //    Title format is always:  "[DocType] - [FirstName LastName]"
            //    e.g. "Aadhaar Card - Rajesh Sharma"
            //         "Loan Agreement - Rajesh Sharma"
            //    Including the name prevents cross-account collisions and
            //    lets the starts-with pattern for 'Loan_Agreements' cleanly
            //    exclude "Home Loan Agreement - Rajesh Sharma".
            String accountName  = resolveAccountName(inp.contactEmail);
            String basePattern  = getTitlePattern(inp.idpConfigurationIdOrName);
            String titlePattern = appendAccountName(basePattern, accountName);

            System.debug('titlePattern resolved: ' + titlePattern);

            List<ContentDocumentLink> links = [
                SELECT ContentDocumentId, ContentDocument.Title
                FROM   ContentDocumentLink
                WHERE  LinkedEntityId = :entityId
                AND    ContentDocument.Title LIKE :titlePattern
                ORDER  BY SystemModstamp DESC
                LIMIT  1
            ];

            if (links.isEmpty()) {
                // Fallback 1: try without name suffix (covers manually uploaded files)
                links = [
                    SELECT ContentDocumentId, ContentDocument.Title
                    FROM   ContentDocumentLink
                    WHERE  LinkedEntityId = :entityId
                    AND    ContentDocument.Title LIKE :basePattern
                    ORDER  BY SystemModstamp DESC
                    LIMIT  1
                ];
            }

            if (links.isEmpty()) {
                // Fallback 2: try Contact Id in case files were linked there
                Id contactId = resolveContactId(inp.contactEmail);
                if (contactId != null) {
                    links = [
                        SELECT ContentDocumentId, ContentDocument.Title
                        FROM   ContentDocumentLink
                        WHERE  LinkedEntityId = :contactId
                        AND    ContentDocument.Title LIKE :titlePattern
                        ORDER  BY SystemModstamp DESC
                        LIMIT  1
                    ];
                }
            }

            if (links.isEmpty()) {
                // Fallback 3: try Cases linked to this Account (covers files uploaded via chat)
                List<Case> relatedCases = [
                    SELECT Id FROM Case WHERE AccountId = :entityId
                    ORDER BY CreatedDate DESC LIMIT 5
                ];
                if (!relatedCases.isEmpty()) {
                    Set<Id> caseIds = new Set<Id>();
                    for (Case c : relatedCases) caseIds.add(c.Id);
                    links = [
                        SELECT ContentDocumentId, ContentDocument.Title
                        FROM   ContentDocumentLink
                        WHERE  LinkedEntityId IN :caseIds
                        AND    ContentDocument.Title LIKE :titlePattern
                        ORDER  BY SystemModstamp DESC
                        LIMIT  1
                    ];
                }
            }

            if (links.isEmpty()) {
                // Fallback 4: most recently uploaded file on Account (any title)
                links = [
                    SELECT ContentDocumentId, ContentDocument.Title
                    FROM   ContentDocumentLink
                    WHERE  LinkedEntityId = :entityId
                    ORDER  BY SystemModstamp DESC
                    LIMIT  1
                ];
            }

            if (links.isEmpty()) {
                // Fallback 5: most recently uploaded file on Contact (any title)
                Id contactId2 = resolveContactId(inp.contactEmail);
                if (contactId2 != null) {
                    links = [
                        SELECT ContentDocumentId, ContentDocument.Title
                        FROM   ContentDocumentLink
                        WHERE  LinkedEntityId = :contactId2
                        ORDER  BY SystemModstamp DESC
                        LIMIT  1
                    ];
                }
            }

            if (links.isEmpty()) {
                // Fallback 6: most recently created ContentDocument org-wide in last 15 minutes
                // Covers files uploaded via chat session (linked to MessagingSession, not Account)
                Datetime cutoff = Datetime.now().addMinutes(-15);
                List<ContentVersion> recentUploads = [
                    SELECT ContentDocumentId, Title
                    FROM   ContentVersion
                    WHERE  CreatedDate >= :cutoff
                    AND    IsLatest = true
                    ORDER  BY CreatedDate DESC
                    LIMIT  1
                ];
                if (!recentUploads.isEmpty()) {
                    ContentDocumentLink fakeLink = new ContentDocumentLink();
                    // Build a minimal link record from the ContentVersion
                    links = [
                        SELECT ContentDocumentId, ContentDocument.Title
                        FROM   ContentDocumentLink
                        WHERE  ContentDocumentId = :recentUploads[0].ContentDocumentId
                        LIMIT  1
                    ];
                    // If not found via link, create a synthetic result using the version
                    if (links.isEmpty()) {
                        out.documentTitle = recentUploads[0].Title;
                        InternalResponse resp2 = processDocument(recentUploads[0].ContentDocumentId, inp.idpConfigurationIdOrName);
                        out.success      = resp2.success;
                        out.errorMessage = resp2.errorMessage;
                        out.resultJson   = resp2.extractedDataJson;
                        out.rawResponse  = resp2.rawResponse;
                        out.schemaUsed   = inp.idpConfigurationIdOrName;
                        outputs.add(out);
                        return outputs;
                    }
                }
            }

            if (links.isEmpty()) {
                out.success = false;
                out.errorMessage = 'No document found matching schema "' +
                    inp.idpConfigurationIdOrName + '" (pattern: ' + titlePattern +
                    ') for account: ' + inp.contactEmail;
                outputs.add(out); return outputs;
            }

            out.documentTitle = links[0].ContentDocument.Title;

            // ── 3. Process ─────────────────────────────────────────────────────
            InternalResponse resp = processDocument(links[0].ContentDocumentId, inp.idpConfigurationIdOrName);

            out.success      = resp.success;
            out.errorMessage = resp.errorMessage;
            out.resultJson   = resp.extractedDataJson;
            out.rawResponse  = resp.rawResponse;
            out.schemaUsed   = inp.idpConfigurationIdOrName;

        } catch (Exception e) {
            out.success      = false;
            out.errorMessage = 'Exception: ' + e.getMessage();
            out.rawResponse  = e.getStackTraceString();
        }

        outputs.add(out);
        return outputs;
    }

    // ─────────────────────────────────────────
    //  RESOLVE ACCOUNT ID (Person Account)
    //  Files created via C01-C22 scripts are
    //  linked to the Account record, not Contact.
    // ─────────────────────────────────────────
    private static Id resolveAccountId(String email) {
        // Person Accounts: PersonEmail is on Account
        List<Account> accs = [
            SELECT Id FROM Account
            WHERE  PersonEmail = :email
            AND    IsPersonAccount = true
            LIMIT  1
        ];
        if (!accs.isEmpty()) return accs[0].Id;

        // Fallback: derive from Contact.AccountId
        List<Contact> cons = [SELECT AccountId FROM Contact WHERE Email = :email LIMIT 1];
        if (!cons.isEmpty() && cons[0].AccountId != null) return cons[0].AccountId;

        return null;
    }

    // ─────────────────────────────────────────
    //  RESOLVE CONTACT ID (fallback)
    // ─────────────────────────────────────────
    private static Id resolveContactId(String email) {
        List<Contact> cons = [SELECT Id FROM Contact WHERE Email = :email LIMIT 1];
        return cons.isEmpty() ? null : cons[0].Id;
    }

    // ─────────────────────────────────────────
    //  RESOLVE ACCOUNT NAME
    //  Returns "FirstName LastName" for the
    //  Person Account matching the email.
    // ─────────────────────────────────────────
    private static String resolveAccountName(String email) {
        List<Account> accs = [
            SELECT FirstName, LastName FROM Account
            WHERE  PersonEmail = :email
            AND    IsPersonAccount = true
            LIMIT  1
        ];
        if (!accs.isEmpty()) {
            String fn = accs[0].FirstName != null ? accs[0].FirstName + ' ' : '';
            return fn + accs[0].LastName;
        }
        // Fallback to Contact name
        List<Contact> cons = [SELECT FirstName, LastName FROM Contact WHERE Email = :email LIMIT 1];
        if (!cons.isEmpty()) {
            String fn = cons[0].FirstName != null ? cons[0].FirstName + ' ' : '';
            return fn + cons[0].LastName;
        }
        return null;
    }

    // ─────────────────────────────────────────
    //  APPEND ACCOUNT NAME TO TITLE PATTERN
    //
    //  Title format is always:
    //    "[DocType] - [FirstName LastName]"
    //    "[DocType] - [FirstName LastName] (extra)"
    //
    //  Strategy: remove the trailing '%' from the
    //  base pattern, append ' - AccountName%'.
    //
    //  Examples:
    //    '%Aadhaar%'        + 'Rajesh Sharma'
    //      → '%Aadhaar% - Rajesh Sharma%'
    //
    //    'Loan Agreement%'  + 'Rajesh Sharma'
    //      → 'Loan Agreement - Rajesh Sharma%'
    //      (starts-with still excludes "Home Loan Agreement - Rajesh Sharma")
    // ─────────────────────────────────────────
    @TestVisible
    private static String appendAccountName(String basePattern, String accountName) {
        if (String.isBlank(accountName)) return basePattern;

        // Strip trailing wildcard, then re-add after name
        String trimmed = basePattern.endsWith('%')
            ? basePattern.substring(0, basePattern.length() - 1)
            : basePattern;

        return trimmed + ' - ' + accountName + '%';
    }

    // ─────────────────────────────────────────
    //  SCHEMA → TITLE PATTERN MAPPING
    //
    //  Maps every Document AI API name to a
    //  SOQL LIKE pattern that uniquely identifies
    //  the matching ContentDocument title.
    //
    //  Rules:
    //  • '%keyword%'  – contains (default)
    //  • 'keyword%'   – starts-with (no leading %)
    //    used where another doc title also *contains*
    //    the same keyword (e.g. "Loan Agreement" is
    //    contained in "Home Loan Agreement" too, so
    //    we match only titles that START with it).
    // ─────────────────────────────────────────
    @TestVisible
    private static String getTitlePattern(String schemaName) {

        Map<String, String> patternMap = new Map<String, String>{

            // Identity documents
            'Aadhar_Card'              => '%Aadhaar%',
            'Pan_Card'                 => '%PAN Card%',
            'Voter_Id_Card'            => '%Voter ID%',
            'Birth_Certificate'        => '%Birth Certificate%',
            'Passport'                 => '%Passport%',

            // Financial / Banking
            'Bank_Account'             => '%Bank Account%',
            'Cibil_Score'              => '%CIBIL%',
            'Credit_Card_Details'      => '%Credit Card%',

            // Loans — specific types use '%X Loan%' (contained);
            // generic "Loan Agreement" uses starts-with to avoid
            // matching "Home Loan Agreement", "Personal Loan Agreement",
            // and "Business Loan Agreement".
            'Loan_Details'             => '%Loan Details%',
            'Loan_Agreements'          => 'Loan Agreement%',       // starts-with
            'Home_Loan_Agreement'      => '%Home Loan Agreement%',
            'Personal_Loan_Agreement'  => '%Personal Loan Agreement%',
            'Business_Loan_Agreement'  => '%Business Loan Agreement%',

            // Tax / Payroll
            'Form16'                   => '%Form16%',    // catches "Form16" and "Form 16 -"
            'Form12B'                  => '%Form12%',    // catches "Form12BB", "Form 12BB"

            // Salary slips – pick the most recent (all three months
            // share "Salary Slip" in the title, so use LIKE with
            // month name if the agent passes a specific variant,
            // otherwise the latest matching slip is returned)
            'Salary_Slip'              => '%Salary Slip%',
            'Salary_Slip_Mar'          => '%Salary Slip%Mar%',
            'Salary_Slip_Feb'          => '%Salary Slip%Feb%',
            'Salary_Slip_Jan'          => '%Salary Slip%Jan%',

            // PF / UAN
            'PF_Statement'             => '%PF%Statement%',   // "PF Statement" or "PF/EPF Statement"
            'UAN_Details'              => '%UAN%',

            // Mutual Funds & Property
            'MF_Statement'             => '%MF Statement%',
            'Mutual_Fund_Statement'    => '%Mutual Fund%',
            'Property_Valuation'       => '%Property Valuation%'
        };

        if (patternMap.containsKey(schemaName)) {
            return patternMap.get(schemaName);
        }

        // Generic fallback: replace underscores with spaces and do
        // a contains search.  e.g. "UAN_Details" → "%UAN Details%"
        return '%' + schemaName.replace('_', ' ') + '%';
    }

    // ─────────────────────────────────────────
    //  PROCESS DOCUMENT (unchanged logic)
    // ─────────────────────────────────────────
    private static InternalResponse processDocument(Id contentDocumentId, String schemaName) {

        InternalResponse response = new InternalResponse();

        try {
            String base64Content = getFileContent(contentDocumentId);

            if (String.isBlank(base64Content)) {
                response.success = false;
                response.errorMessage = 'Failed to retrieve file content.';
                return response;
            }

            String requestBodyJson = createRequestBody(base64Content, schemaName);
            String apiResponse     = makeAPICall(requestBodyJson);
            response.rawResponse   = apiResponse;

            if (String.isBlank(apiResponse)) {
                response.success = false;
                response.errorMessage = 'Empty response from Document AI API.';
                return response;
            }

            if (apiResponse.startsWith('[')) {
                response.success = false;
                response.errorMessage = 'Document AI API error: ' + apiResponse;
                return response;
            }

            Object parsed = JSON.deserializeUntyped(apiResponse);
            if (!(parsed instanceof Map<String, Object>)) {
                response.success = false;
                response.errorMessage = 'Unexpected response format: ' + apiResponse;
                return response;
            }

            Map<String, Object> responseMap = (Map<String, Object>) parsed;
            List<Object> dataList = (List<Object>) responseMap.get('data');

            if (dataList == null || dataList.isEmpty()) {
                response.success = false;
                response.errorMessage = 'Missing "data" in API response.';
                return response;
            }

            Map<String, Object> firstData    = (Map<String, Object>) dataList[0];
            String              extractedStr = (String) firstData.get('data');
            String              error        = (String) firstData.get('error');

            if (!String.isBlank(error)) {
                response.success = false;
                response.errorMessage = 'Extraction error: ' + error;
                return response;
            }

            if (String.isBlank(extractedStr) || extractedStr == '{}') {
                response.success = false;
                response.errorMessage = 'No data extracted from document.';
                return response;
            }

            String              decoded       = decodeHtmlEntities(extractedStr);
            Map<String, Object> extractedMap  = (Map<String, Object>) JSON.deserializeUntyped(decoded);
            Map<String, Object> formattedData = formatExtractedData(extractedMap);

            response.success          = true;
            response.extractedDataJson = JSON.serialize(formattedData);

        } catch (Exception e) {
            response.success      = false;
            response.errorMessage = 'Exception: ' + e.getMessage();
            response.rawResponse  = e.getStackTraceString();
        }

        return response;
    }

    // ─────────────────────────────────────────
    //  HELPERS (unchanged)
    // ─────────────────────────────────────────
    private static String createRequestBody(String base64Content, String schemaName) {
        String body =
            '{\n' +
            '  "idpConfigurationIdOrName": "' + schemaName + '",\n' +
            '  "files": [\n' +
            '    {\n' +
            '      "mimeType": "application/pdf",\n' +
            '      "data": "' + base64Content + '"\n' +
            '    }\n' +
            '  ]\n' +
            '}';
        System.debug('createRequestBody --> ' + body);
        return body;
    }

    private static String getFileContent(String contentDocumentId) {
        try {
            List<ContentVersion> cvList = [
                SELECT VersionData, FileType, Title, ContentSize
                FROM   ContentVersion
                WHERE  ContentDocumentId = :contentDocumentId
                AND    IsLatest = true
                LIMIT  1
            ];
            if (cvList.isEmpty()) return null;
            return EncodingUtil.base64Encode(cvList[0].VersionData);
        } catch (Exception e) {
            System.debug('getFileContent error: ' + e.getMessage());
            return null;
        }
    }

    private static String makeAPICall(String requestBody) {
        String token = getAccessToken();

        HttpRequest request = new HttpRequest();
        request.setEndpoint(
            System.Url.getOrgDomainUrl().toExternalForm() +
            '/services/data/v64.0/ssot/document-processing/actions/extract-data?htmlEncode=false'
        );
        request.setMethod('POST');
        request.setHeader('Content-Type', CONTENT_TYPE);
        request.setHeader('Authorization', 'Bearer ' + token);
        request.setBody(requestBody);
        request.setTimeout(120000);

        HttpResponse response = new Http().send(request);
        System.debug('makeAPICall status=' + response.getStatusCode());
        System.debug('makeAPICall body='   + response.getBody());
        return response.getBody();
    }

    private static Map<String, Object> formatExtractedData(Map<String, Object> extractedData) {
        Map<String, Object> formatted = new Map<String, Object>();
        for (String key : extractedData.keySet()) {
            Object value = extractedData.get(key);
            if (value instanceof Map<String, Object>) {
                Map<String, Object> vm = (Map<String, Object>) value;
                formatted.put(key, vm.containsKey('value') ? vm.get('value') : value);
            } else {
                formatted.put(key, value);
            }
        }
        return formatted;
    }

    private static String decodeHtmlEntities(String input) {
        if (input == null) return null;
        input = input.replace('&quot;', '"');
        input = input.replace('&apos;', '\'');
        input = input.replace('&lt;',   '<');
        input = input.replace('&gt;',   '>');
        input = input.replace('&amp;',  '&');
        input = input.replace('&#39;',  '\'');
        input = input.replace('&nbsp;', ' ');
        return input;
    }

    private static String getAccessToken() {
        String tokenEndpoint = 'https://orgfarm-fb829dcad2.my.salesforce.com/services/oauth2/token';

        HttpRequest req = new HttpRequest();
        req.setEndpoint(tokenEndpoint);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');

        String username = 'princy.shah@accenture.com.rtps';
        String password = 'Accenture2026' + 'V5BwOzEXjEbOYiNKC1cdnGSJ3';

        req.setBody(
            'grant_type=client_credentials' +
            '&client_id='     + EncodingUtil.urlEncode(CLIENT_ID,     'UTF-8') +
            '&client_secret=' + EncodingUtil.urlEncode(CLIENT_SECRET, 'UTF-8') +
            '&username='      + EncodingUtil.urlEncode(username,      'UTF-8') +
            '&password='      + EncodingUtil.urlEncode(password,      'UTF-8')
        );

        HttpResponse res = new Http().send(req);
        System.debug('Token status=' + res.getStatusCode());
        System.debug('Token body='   + res.getBody());

        if (res.getStatusCode() >= 200 && res.getStatusCode() < 300) {
            Map<String, Object> tokenResp = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            return (String) tokenResp.get('access_token');
        }

        throw new CalloutException('Cannot get access token: ' + res.getBody());
    }
}