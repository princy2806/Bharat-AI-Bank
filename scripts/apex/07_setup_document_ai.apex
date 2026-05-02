// Step 7: Verify Document AI Setup and Query Inserted Documents
// Run AFTER all previous scripts.
// Document AI (Einstein OCR) is enabled via Setup UI - this script verifies
// ContentVersions are accessible and shows a summary of all inserted documents.

// Query all ContentVersions linked to our Person Accounts
List<Account> personAccounts = [
    SELECT Id, FirstName, LastName, PersonEmail, PersonMobilePhone
    FROM Account
    WHERE IsPersonAccount = true
    AND LastName IN ('Sharma','Patel','Kumar','Devi','Singh','Nair','Gupta','Reddy','Verma')
    ORDER BY LastName, FirstName
];

System.debug('=== PERSON ACCOUNTS SUMMARY ===');
for (Account a : personAccounts) {
    System.debug('Account: ' + a.FirstName + ' ' + a.LastName + ' | Id: ' + a.Id + ' | Mobile: ' + a.PersonMobilePhone);
}

// Query ContentDocumentLinks for our accounts
Set<Id> accIds = new Map<Id, Account>(personAccounts).keySet();
List<ContentDocumentLink> cdls = [
    SELECT ContentDocumentId, LinkedEntityId, ContentDocument.Title,
           ContentDocument.FileType, ContentDocument.ContentSize,
           ContentDocument.CreatedDate
    FROM ContentDocumentLink
    WHERE LinkedEntityId IN :accIds
    ORDER BY LinkedEntityId, ContentDocument.Title
];

Map<Id, List<String>> accDocMap = new Map<Id, List<String>>();
for (ContentDocumentLink cdl : cdls) {
    if (!accDocMap.containsKey(cdl.LinkedEntityId)) {
        accDocMap.put(cdl.LinkedEntityId, new List<String>());
    }
    accDocMap.get(cdl.LinkedEntityId).add(cdl.ContentDocument.Title);
}

System.debug('=== DOCUMENTS PER ACCOUNT ===');
for (Account a : personAccounts) {
    List<String> docs = accDocMap.get(a.Id);
    System.debug(a.FirstName + ' ' + a.LastName + ': ' + (docs != null ? String.join(docs, ' | ') : 'NO DOCUMENTS'));
}

System.debug('Total ContentDocumentLink records: ' + cdls.size());
System.debug('');
System.debug('=== DOCUMENT AI ENABLEMENT CHECKLIST ===');
System.debug('1. Go to Setup > Einstein > Document AI > Enable');
System.debug('2. Go to Setup > Einstein > Document AI > Document Types > Create:');
System.debug('   - Aadhaar Card (Fields: Name, DOB, Gender, Address, Aadhaar Number)');
System.debug('   - PAN Card (Fields: Name, Father Name, DOB, PAN Number)');
System.debug('   - Bank Statement (Fields: Account Holder, Account Number, Period, Closing Balance)');
System.debug('   - Home Loan Letter (Fields: Borrower, Loan Amount, Rate, EMI, Outstanding)');
System.debug('   - Credit Report (Fields: Name, Score, Payment History, Outstanding)');
System.debug('3. Link Document Types to ContentVersion on Account object');
System.debug('4. Enable WhatsApp in Setup > Messaging > WhatsApp');
System.debug('5. Configure Agentforce Bot with Document AI actions');
System.debug('');
System.debug('=== AGENTFORCE DOCUMENT AI FLOW ===');
System.debug('Customer sends photo via WhatsApp -> Agentforce receives -> Einstein OCR extracts -> FSC record updated');
