/**
 * UploadReceiptDocument.apex
 * Creates a ContentDocument (plain-text receipt) linked to Rajesh Sharma's Account.
 * The title matches the pattern ProcessDocumentAIUniversal looks for: %Credit Card%
 *
 * Run via:
 *   sf apex run --file scripts/UploadReceiptDocument.apex -o princy.shah477@agentforce.com
 */

// ── 1. Find Rajesh Sharma's Account ───────────────────────────────────────
String testEmail = '17ravi.ka@gmail.com';
List<Contact> cons = [SELECT Id, Name, AccountId FROM Contact WHERE Email = :testEmail LIMIT 1];
if (cons.isEmpty()) {
    cons = [SELECT Id, Name, AccountId FROM Contact WHERE AccountId = '001bm00001jIHPnAAO' LIMIT 1];
}
if (cons.isEmpty()) {
    System.debug('ERROR: No contact found. Check the email.');
    return;
}
Id accId = cons[0].AccountId;
System.debug('Uploading receipt for: ' + cons[0].Name + ' | Account: ' + accId);

// ── 2. Build a realistic receipt body (text/plain — Document AI can parse this) ──
String receiptText =
    '================================================================================\n' +
    '                        GRAND MERIDIAN HOTEL\n' +
    '               A Luxury International Collection Property\n' +
    '           14 Marina Promenade, New Delhi – 110 001, India\n' +
    '      Tel: +91-11-4567-8900  |  reservations@grandmeridian.in\n' +
    '================================================================================\n' +
    '                             TAX INVOICE\n' +
    '================================================================================\n' +
    'Invoice No.     : GMH/2026/04/8871\n' +
    'Invoice Date    : 19 April 2026\n' +
    'Folio No.       : F-49201\n' +
    'Reservation ID  : RES-78543\n' +
    '--------------------------------------------------------------------------------\n' +
    'Guest Name      : Rajesh Sharma\n' +
    'Check-In        : 18 April 2026, 14:00 hrs\n' +
    'Check-Out       : 19 April 2026, 12:00 hrs\n' +
    'Room            : 512 – Deluxe King\n' +
    'Nights          : 1\n' +
    '================================================================================\n' +
    'CHARGES\n' +
    '================================================================================\n' +
    'Date         Description                          Qty    Unit Rate    Amount\n' +
    '------------ ------------------------------------ ------ ------------ ----------\n' +
    '18 Apr 2026  Deluxe King Room Tariff              1 Ngt  INR 4,200    INR 4,200\n' +
    '18 Apr 2026  In-Room Dining - Dinner              1      INR   680    INR   680\n' +
    '19 Apr 2026  Breakfast Buffet - Club Floor        1      INR   350    INR   350\n' +
    '19 Apr 2026  Airport Transfer - Sedan             1      INR   420    INR   420\n' +
    '================================================================================\n' +
    'Sub-Total                                                              INR 5,650\n' +
    'CGST @ 6%                                                              INR   174\n' +
    'SGST @ 6%                                                              INR   175\n' +
    '--------------------------------------------------------------------------------\n' +
    'TOTAL AMOUNT DUE                                                   INR 5,999.00\n' +
    '================================================================================\n' +
    'PAYMENT DETAILS\n' +
    '================================================================================\n' +
    'Payment Method  : Credit Card\n' +
    'Card Type       : VISA\n' +
    'Card Number     : **** **** **** 4821\n' +
    'Transaction Ref : TXN-GMH-20260419-5999\n' +
    'Auth Code       : VX7821\n' +
    'Transaction Date: 19 April 2026\n' +
    'Transaction Time: 12:04 hrs\n' +
    'Amount Charged  : INR 5,999.00\n' +
    'Payment Status  : PAID IN FULL\n' +
    '================================================================================\n' +
    'Merchant        : Grand Meridian Hotel, New Delhi\n' +
    'Amount          : 5999\n' +
    'Currency        : INR\n' +
    'Date            : 19 April 2026\n' +
    '================================================================================\n' +
    'This is a computer-generated invoice. No signature required.\n' +
    'For billing queries: accounts@grandmeridian.in | +91-11-4567-8920\n' +
    '================================================================================\n';

// ── 3. Create ContentVersion (the actual file) ─────────────────────────────
ContentVersion cv = new ContentVersion(
    Title           = 'Credit Card - Rajesh Sharma Hotel Bill',
    PathOnClient    = 'Credit Card - Rajesh Sharma Hotel Bill.txt',
    VersionData     = Blob.valueOf(receiptText),
    IsMajorVersion  = true
);
insert cv;

// Get the ContentDocumentId from the ContentVersion
ContentVersion inserted = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id LIMIT 1];
System.debug('ContentDocument created: ' + inserted.ContentDocumentId);

// ── 4. Link it to the Account ──────────────────────────────────────────────
ContentDocumentLink cdl = new ContentDocumentLink(
    ContentDocumentId = inserted.ContentDocumentId,
    LinkedEntityId    = accId,
    ShareType         = 'V'   // V = Viewer
);
insert cdl;

System.debug('SUCCESS: Receipt uploaded and linked to account.');
System.debug('  ContentDocumentId : ' + inserted.ContentDocumentId);
System.debug('  Account           : ' + accId);
System.debug('  Title             : Credit Card - Rajesh Sharma Hotel Bill');
System.debug('  Amount            : INR 5,999');
System.debug('  Date              : 19 April 2026');
System.debug('  Merchant          : Grand Meridian Hotel, New Delhi');
System.debug('');
System.debug('Now ask the agent: "I want to dispute the charge of 5999 from my hotel bill"');
System.debug('Or: "I pasted my hotel receipt – can you dispute this charge?"');
