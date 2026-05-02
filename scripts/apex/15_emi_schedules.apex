// Step 15: EMI Schedules - Home Loan & Credit Card for all applicable persons
// Document AI Template: EMI_SCHEDULE / CC_STATEMENT
// Fields: Loan Account No, Borrower, EMI Amount, Due Date, Principal,
//         Interest, Outstanding Balance, Total Payable

Map<String, Id> accMap = new Map<String, Id>();
for (Account a : [SELECT Id, FirstName, LastName FROM Account WHERE IsPersonAccount = true
    AND LastName IN ('Sharma','Patel','Kumar','Devi','Singh','Nair','Gupta','Reddy','Verma')
    ORDER BY CreatedDate DESC]) {
    String key = a.FirstName + ' ' + a.LastName;
    if (!accMap.containsKey(key)) accMap.put(key, a.Id);
}

List<ContentVersion> cvs = new List<ContentVersion>();

// ===== HOME LOAN EMI SCHEDULES =====

// Rajesh Sharma - Home Loan EMI Schedule
cvs.add(new ContentVersion(Title='Home Loan EMI Schedule - Rajesh Sharma', PathOnClient='HomeLoan_EMI_Schedule_Rajesh_Sharma.txt',
FirstPublishLocationId=accMap.get('Rajesh Sharma'),
VersionData=Blob.valueOf(
'HDFC BANK LIMITED\n' +
'HOME LOAN EMI REPAYMENT SCHEDULE\n' +
'================================================================\n' +
'Loan Account No     : HL00123456789\n' +
'Borrower Name       : RAJESH SHARMA\n' +
'PAN                 : ABCRS1234P\n' +
'Original Loan Amount: Rs 40,00,000\n' +
'Disbursement Date   : 01/04/2018\n' +
'Loan Tenure         : 240 months (20 Years)\n' +
'Interest Rate       : 8.65% p.a. (MCLR + 0.25%)\n' +
'EMI Amount          : Rs 18,450\n' +
'================================================================\n' +
'CURRENT STATUS (as on 19-Apr-2026):\n' +
'EMIs Paid           : 96 (Apr-2018 to Mar-2026)\n' +
'EMIs Remaining      : 144\n' +
'Principal Paid      : Rs 7,50,000 (approx)\n' +
'Interest Paid       : Rs 9,91,200 (Rs 18,450 x 96 - Rs 7,50,000)\n' +
'Outstanding Balance : Rs 32,50,000\n' +
'================================================================\n' +
'UPCOMING 12 EMIs (Repayment Schedule):\n' +
'EMI#  Due Date     Principal   Interest   Total EMI   Balance\n' +
' 97   05-May-2026   2,316      16,134     18,450      32,47,684\n' +
' 98   05-Jun-2026   2,333      16,117     18,450      32,45,351\n' +
' 99   05-Jul-2026   2,349      16,101     18,450      32,43,002\n' +
'100   05-Aug-2026   2,366      16,084     18,450      32,40,636\n' +
'101   05-Sep-2026   2,383      16,067     18,450      32,38,253\n' +
'102   05-Oct-2026   2,399      16,051     18,450      32,35,854\n' +
'103   05-Nov-2026   2,416      16,034     18,450      32,33,438\n' +
'104   05-Dec-2026   2,433      16,017     18,450      32,31,005\n' +
'105   05-Jan-2027   2,450      16,000     18,450      32,28,555\n' +
'106   05-Feb-2027   2,467      15,983     18,450      32,26,088\n' +
'107   05-Mar-2027   2,484      15,966     18,450      32,23,604\n' +
'108   05-Apr-2027   2,501      15,949     18,450      32,21,103\n' +
'================================================================\n' +
'RESTRUCTURING OPTIONS AVAILABLE:\n' +
'Option 1 - Extend 12 months: New EMI Rs 16,800 (Save Rs 1,650/month)\n' +
'   Additional Interest Cost: Rs 2,43,600 over extended period\n' +
'Option 2 - Extend 24 months: New EMI Rs 15,400 (Save Rs 3,050/month)\n' +
'   Additional Interest Cost: Rs 5,12,400 over extended period\n' +
'Option 3 - Moratorium 3 months: EMI paused, interest added to principal\n' +
'   New Outstanding after moratorium: Rs 33,08,750\n' +
'   New EMI: Rs 18,450 (same) but tenure extends by ~3 months\n' +
'================================================================\n' +
'For restructuring: WhatsApp 9876543210 or visit branch\n' +
'NACH Mandate Bank: HDFC BANK | Acc: SB00123456789'
)));

// Amit Kumar - Home Loan EMI Schedule
cvs.add(new ContentVersion(Title='Home Loan EMI Schedule - Amit Kumar', PathOnClient='HomeLoan_EMI_Schedule_Amit_Kumar.txt',
FirstPublishLocationId=accMap.get('Amit Kumar'),
VersionData=Blob.valueOf(
'STATE BANK OF INDIA\n' +
'HOME LOAN REPAYMENT SCHEDULE\n' +
'Loan No: HL00234567890 | Borrower: AMIT KUMAR | PAN: CDEAKXXXX3F\n' +
'Loan Amount: Rs 65,00,000 | Rate: 8.40% | Tenure: 300 months\n' +
'EMI: Rs 22,300 | Start Date: 15/10/2016\n' +
'================================================================\n' +
'Current Status (Apr-2026):\n' +
'EMIs Paid: 114 | EMIs Remaining: 186\n' +
'Principal Paid: Rs 14,00,000 | Outstanding: Rs 51,00,000\n' +
'================================================================\n' +
'Next 6 EMIs:\n' +
'EMI#  Due Date    Principal  Interest   EMI     Balance\n' +
'115   15-May-2026  4,102     18,198    22,300   50,95,898\n' +
'116   15-Jun-2026  4,131     18,169    22,300   50,91,767\n' +
'117   15-Jul-2026  4,159     18,141    22,300   50,87,608\n' +
'118   15-Aug-2026  4,188     18,112    22,300   50,83,420\n' +
'119   15-Sep-2026  4,217     18,083    22,300   50,79,203\n' +
'120   15-Oct-2026  4,246     18,054    22,300   50,74,957\n' +
'NACH: SBI Acc SB00345678901 | Auto-debit 15th of each month'
)));

// Vikram Singh - Home Loan EMI Schedule
cvs.add(new ContentVersion(Title='Home Loan EMI Schedule - Vikram Singh', PathOnClient='HomeLoan_EMI_Schedule_Vikram_Singh.txt',
FirstPublishLocationId=accMap.get('Vikram Singh'),
VersionData=Blob.valueOf(
'ICICI BANK LIMITED\n' +
'HOME LOAN REPAYMENT SCHEDULE\n' +
'Loan No: HL00345678901 | Borrower: VIKRAM SINGH | PAN: EFGVS2345S\n' +
'Loan Amount: Rs 80,00,000 | Rate: 8.75% | Tenure: 300 months\n' +
'EMI: Rs 28,600 | Start Date: 01/03/2020\n' +
'================================================================\n' +
'Current Status (Apr-2026):\n' +
'EMIs Paid: 74 | EMIs Remaining: 226\n' +
'Principal Paid: Rs 8,00,000 | Outstanding: Rs 72,00,000\n' +
'================================================================\n' +
'Next 6 EMIs:\n' +
'EMI  Due Date    Principal  Interest   EMI     Balance\n' +
'75   01-May-2026  3,350     25,250    28,600   71,96,650\n' +
'76   01-Jun-2026  3,374     25,226    28,600   71,93,276\n' +
'77   01-Jul-2026  3,399     25,201    28,600   71,89,877\n' +
'78   01-Aug-2026  3,424     25,176    28,600   71,86,453\n' +
'79   01-Sep-2026  3,449     25,151    28,600   71,83,004\n' +
'80   01-Oct-2026  3,473     25,127    28,600   71,79,531\n' +
'NACH: ICICI Bank Acc SB00567890123 | Auto-debit 1st of each month'
)));

// Suresh Gupta - Home Loan EMI Schedule
cvs.add(new ContentVersion(Title='Home Loan EMI Schedule - Suresh Gupta', PathOnClient='HomeLoan_EMI_Schedule_Suresh_Gupta.txt',
FirstPublishLocationId=accMap.get('Suresh Gupta'),
VersionData=Blob.valueOf(
'AXIS BANK LIMITED\n' +
'HOME LOAN REPAYMENT SCHEDULE\n' +
'Loan No: HL00456789012 | Borrower: SURESH GUPTA | PAN: HIJSG4567U\n' +
'Loan Amount: Rs 1,20,00,000 | Rate: 8.50% | Tenure: 360 months\n' +
'EMI: Rs 35,200 | Start Date: 10/06/2014\n' +
'Current Status: EMIs Paid: 142 | Outstanding: Rs 98,00,000\n' +
'Next EMI: 10-May-2026 | Principal: Rs 5,450 | Interest: Rs 29,750\n' +
'Balance after next EMI: Rs 97,94,550'
)));

// Rohit Verma - Home Loan EMI Schedule
cvs.add(new ContentVersion(Title='Home Loan EMI Schedule - Rohit Verma', PathOnClient='HomeLoan_EMI_Schedule_Rohit_Verma.txt',
FirstPublishLocationId=accMap.get('Rohit Verma'),
VersionData=Blob.valueOf(
'KOTAK MAHINDRA BANK LIMITED\n' +
'HOME LOAN REPAYMENT SCHEDULE\n' +
'Loan No: HL00567890123 | Borrower: ROHIT VERMA | PAN: JKLRV6789W\n' +
'Loan Amount: Rs 50,00,000 | Rate: 8.80% | Tenure: 240 months\n' +
'EMI: Rs 24,500 | Start Date: 01/12/2019\n' +
'Current Status: EMIs Paid: 77 | Outstanding: Rs 43,00,000\n' +
'Next EMI: 01-May-2026 | Principal: Rs 8,327 | Interest: Rs 16,173\n' +
'Balance after next EMI: Rs 42,91,673'
)));

// ===== CREDIT CARD STATEMENTS =====

// Rajesh Sharma - Credit Card Statement
cvs.add(new ContentVersion(Title='Credit Card Statement - Rajesh Sharma (March 2026)', PathOnClient='CC_Statement_Rajesh_Sharma_Mar2026.txt',
FirstPublishLocationId=accMap.get('Rajesh Sharma'),
VersionData=Blob.valueOf(
'HDFC BANK LIMITED\n' +
'CREDIT CARD STATEMENT\n' +
'HDFC Millennia Credit Card\n' +
'================================================================\n' +
'Card Number         : XXXX XXXX XXXX 4891\n' +
'Card Holder         : RAJESH SHARMA\n' +
'Statement Date      : 28-Mar-2026\n' +
'Payment Due Date    : 18-Apr-2026\n' +
'Credit Limit        : Rs 2,00,000\n' +
'Available Credit    : Rs 1,54,800\n' +
'================================================================\n' +
'STATEMENT SUMMARY:\n' +
'Opening Balance (01-Mar-2026): Rs 38,700\n' +
'Total Purchases              : Rs 15,800\n' +
'Total Payments               : Rs 9,300\n' +
'Interest Charged             : Rs 0 (Full payment in Feb)\n' +
'Cashback Credited            : Rs (200)\n' +
'CLOSING BALANCE (31-Mar-2026): Rs 45,200\n' +
'Minimum Amount Due (MAD)     : Rs 4,520 (10% of outstanding)\n' +
'Total Amount Due             : Rs 45,200\n' +
'================================================================\n' +
'TRANSACTION DETAILS (March 2026):\n' +
'Date        Description                    Amount\n' +
'02-Mar-2026 Amazon India - Electronics     Rs 8,900 Dr\n' +
'05-Mar-2026 Petrol Pump - HPCL Indore     Rs 2,500 Dr\n' +
'09-Mar-2026 Swiggy Food Order             Rs 450  Dr\n' +
'12-Mar-2026 Pharmacy - Apollo             Rs 1,200 Dr\n' +
'15-Mar-2026 GOA BEACH RESORT (DISPUTED)  Rs 12,500 Dr  *** DISPUTE RAISED ***\n' +
'18-Mar-2026 Payment Received - Thank You  Rs 9,300 Cr\n' +
'25-Mar-2026 Big Bazaar - Groceries       Rs 2,750 Dr\n' +
'================================================================\n' +
'DISPUTED TRANSACTION:\n' +
'Date: 15-Mar-2026 | Merchant: GOA BEACH RESORT\n' +
'Amount: Rs 12,500 | Status: UNDER INVESTIGATION\n' +
'Provisional Credit: Rs 12,500 (Credited to your account)\n' +
'Case No: DISP/2026/03/789012\n' +
'Expected Resolution: 30 days\n' +
'================================================================\n' +
'Reward Points Balance: 4,250 pts | Cashback YTD: Rs 1,850\n' +
'For disputes/queries: WhatsApp 1800-266-4332'
)));

// Priya Patel - Credit Card Statement
cvs.add(new ContentVersion(Title='Credit Card Statement - Priya Patel (March 2026)', PathOnClient='CC_Statement_Priya_Patel_Mar2026.txt',
FirstPublishLocationId=accMap.get('Priya Patel'),
VersionData=Blob.valueOf(
'AXIS BANK ACE CREDIT CARD - STATEMENT\n' +
'Card: XXXX XXXX XXXX 7823 | Holder: PRIYA PATEL\n' +
'Statement: 28-Mar-2026 | Due: 18-Apr-2026\n' +
'Credit Limit: Rs 3,00,000 | Available: Rs 2,81,300\n' +
'Opening Balance: Rs 14,500 | Purchases: Rs 7,900\n' +
'Payment: Rs 3,700 | Cashback: Rs 450\n' +
'CLOSING BALANCE: Rs 18,700 | MAD: Rs 1,870\n' +
'Key Transactions: Nykaa Rs 3,200 | Netflix Rs 649 | Uber Rs 850 | Myntra Rs 3,201\n' +
'Reward Points: 8,920 | Cashback YTD: Rs 3,200'
)));

// Vikram Singh - CC Statement
cvs.add(new ContentVersion(Title='Credit Card Statement - Vikram Singh (March 2026)', PathOnClient='CC_Statement_Vikram_Singh_Mar2026.txt',
FirstPublishLocationId=accMap.get('Vikram Singh'),
VersionData=Blob.valueOf(
'HDFC REGALIA CREDIT CARD - STATEMENT\n' +
'Card: XXXX XXXX XXXX 6789 | Holder: VIKRAM SINGH\n' +
'Statement: 28-Mar-2026 | Due: 18-Apr-2026\n' +
'Credit Limit: Rs 2,50,000 | Available: Rs 2,27,700\n' +
'Opening Balance: Rs 18,900 | Purchases: Rs 8,400\n' +
'Payment: Rs 5,000 | Closing: Rs 22,300 | MAD: Rs 2,230\n' +
'Key Transactions: IRCTC Rs 4,500 | Amazon Rs 2,100 | Zomato Rs 1,800\n' +
'Reward Points: 12,450 | Milestone Benefit: Lounge access active'
)));

// Meera Nair - Amex Statement
cvs.add(new ContentVersion(Title='Credit Card Statement - Meera Nair (March 2026)', PathOnClient='CC_Statement_Meera_Nair_Mar2026.txt',
FirstPublishLocationId=accMap.get('Meera Nair'),
VersionData=Blob.valueOf(
'AMERICAN EXPRESS PLATINUM TRAVEL - STATEMENT\n' +
'Card: XXXX XXXXXX 3456 | Holder: MEERA NAIR\n' +
'Statement: 28-Mar-2026 | Due: 18-Apr-2026\n' +
'Credit Limit: Rs 3,50,000 | Available: Rs 3,34,400\n' +
'Opening Balance: Rs 11,200 | Purchases: Rs 7,900\n' +
'Payment: Rs 3,500 | Closing: Rs 15,600 | MAD: Rs 1,560\n' +
'Key Transactions: Taj Hotel Rs 5,000 | Apple Store Rs 2,100 | Starbucks Rs 800\n' +
'Membership Rewards: 22,800 pts | Lounge: Active'
)));

// Suresh Gupta - Corporate Card
cvs.add(new ContentVersion(Title='Credit Card Statement - Suresh Gupta (March 2026)', PathOnClient='CC_Statement_Suresh_Gupta_Mar2026.txt',
FirstPublishLocationId=accMap.get('Suresh Gupta'),
VersionData=Blob.valueOf(
'KOTAK MAHINDRA BANK CORPORATE CARD - STATEMENT\n' +
'Card: XXXX XXXX XXXX 7890 | Holder: SURESH GUPTA\n' +
'Statement: 28-Mar-2026 | Due: 18-Apr-2026\n' +
'Credit Limit: Rs 10,00,000 | Available: Rs 9,05,000\n' +
'Opening Balance: Rs 78,500 | Business Purchases: Rs 32,200\n' +
'Payment: Rs 15,700 | Closing: Rs 95,000 | MAD: Rs 9,500\n' +
'Key Transactions: Emirates Flight Rs 45,000 | Hotel Marriott Rs 22,000 | Fabric Supplier Rs 15,000\n' +
'Business spend categorized for GST input credit. Annual fee: Rs 2,999'
)));

// All other CC statements (compact)
for (String[] person : new List<String[]>{
    new String[]{'Amit Kumar','SBI SimplyCLICK','XXXX XXXX XXXX 2345','32,100','3,210','CC_Statement_Amit_Kumar_Mar2026.txt'},
    new String[]{'Sunita Devi','ICICI Business Advantage','XXXX XXXX XXXX 9012','78,500','7,850','CC_Statement_Sunita_Devi_Mar2026.txt'},
    new String[]{'Kavitha Reddy','IndusInd Pinnacle','XXXX XXXX XXXX 1234','28,400','2,840','CC_Statement_Kavitha_Reddy_Mar2026.txt'},
    new String[]{'Rohit Verma','SBI SimplySAVE','XXXX XXXX XXXX 5678','41,200','4,120','CC_Statement_Rohit_Verma_Mar2026.txt'},
    new String[]{'Anita Sharma','Standard Chartered Manhattan','XXXX XXXX XXXX 2345','19,800','1,980','CC_Statement_Anita_Sharma_Mar2026.txt'}
}) {
    cvs.add(new ContentVersion(
        Title = 'Credit Card Statement - ' + person[0] + ' (March 2026)',
        PathOnClient = person[4],
        FirstPublishLocationId = accMap.get(person[0]),
        VersionData = Blob.valueOf(
            person[1] + ' - STATEMENT\n' +
            'Card: ' + person[2] + ' | Holder: ' + person[0].toUpperCase() + '\n' +
            'Statement: 28-Mar-2026 | Due: 18-Apr-2026\n' +
            'CLOSING BALANCE: Rs ' + person[3] + '\n' +
            'Minimum Amount Due: Rs ' + person[5] + '\n' +
            'Auto-pay set: Full outstanding amount on due date.\n' +
            'For disputes: Call 1800-XXX-XXXX or WhatsApp Banking.'
        )
    ));
}

insert cvs;
System.debug('Inserted ' + cvs.size() + ' EMI schedules + Credit Card statements.');
