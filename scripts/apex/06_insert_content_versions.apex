// Step 6: Insert ContentVersion records (Documents for Document AI)
// Creates: Aadhaar Card, PAN Card, Bank Statement, Home Loan Letter, Credit Report
// for each Person Account. Run AFTER 01_insert_person_accounts.apex.
// ContentDocument is auto-created; ContentDocumentLink auto-links via FirstPublishLocationId.

Map<String, Id> accMap = new Map<String, Id>();
for (Account a : [
    SELECT Id, FirstName, LastName
    FROM Account
    WHERE LastName IN ('Sharma','Patel','Kumar','Devi','Singh','Nair','Gupta','Reddy','Verma')
    AND IsPersonAccount = true
    ORDER BY CreatedDate DESC
]) {
    accMap.put(a.FirstName + ' ' + a.LastName, a.Id);
}

List<ContentVersion> cvList = new List<ContentVersion>();

// ============================================================
// Helper: build a ContentVersion record
// ============================================================
// We use Blob.valueOf(text) so Document AI can parse the text content.
// In production, replace VersionData with actual base64-encoded PDF/image.

// ============================================================
// RAJESH SHARMA - Indore (Home Loan + CC + MF)
// ============================================================
Id rsId = accMap.get('Rajesh Sharma');

cvList.add(new ContentVersion(
    Title = 'Aadhaar Card - Rajesh Sharma',
    PathOnClient = 'Aadhaar_Rajesh_Sharma.txt',
    FirstPublishLocationId = rsId,
    VersionData = Blob.valueOf(
        'GOVERNMENT OF INDIA\n' +
        'UNIQUE IDENTIFICATION AUTHORITY OF INDIA\n' +
        '--------------------------------------------\n' +
        'Name        : RAJESH SHARMA\n' +
        'Date of Birth: 15/06/1985\n' +
        'Gender      : MALE\n' +
        'Address     : 45, MG Road, Vijay Nagar,\n' +
        '              Indore, Madhya Pradesh - 452001\n' +
        '--------------------------------------------\n' +
        'Aadhaar No  : 4782 5631 9024\n' +
        'Issue Date  : 12/03/2016\n' +
        '--------------------------------------------\n' +
        'Your Aadhaar is issued by UIDAI.\n' +
        'Helpline: 1947 | uidai.gov.in'
    ),
    Description__c = 'Aadhaar Card (Front + Back) - Document AI enabled'
));

cvList.add(new ContentVersion(
    Title = 'PAN Card - Rajesh Sharma',
    PathOnClient = 'PAN_Rajesh_Sharma.txt',
    FirstPublishLocationId = rsId,
    VersionData = Blob.valueOf(
        'INCOME TAX DEPARTMENT\n' +
        'GOVT. OF INDIA\n' +
        '--------------------------------------------\n' +
        'Name            : RAJESH SHARMA\n' +
        'Father\'s Name   : RAMESH SHARMA\n' +
        'Date of Birth   : 15/06/1985\n' +
        'Permanent Account Number\n' +
        'PAN             : ABCRS1234P\n' +
        '--------------------------------------------\n' +
        'Signature verified by Income Tax Dept.\n' +
        'This card is valid for Rajesh Sharma.'
    ),
    Description__c = 'PAN Card - Document AI enabled'
));

cvList.add(new ContentVersion(
    Title = 'Bank Statement - Rajesh Sharma (Last 6 months)',
    PathOnClient = 'BankStatement_Rajesh_Sharma.txt',
    FirstPublishLocationId = rsId,
    VersionData = Blob.valueOf(
        'HDFC BANK LIMITED\n' +
        'ACCOUNT STATEMENT\n' +
        '--------------------------------------------\n' +
        'Account Holder : RAJESH SHARMA\n' +
        'Account Number : SB00123456789\n' +
        'Account Type   : Savings\n' +
        'IFSC Code      : HDFC0001234\n' +
        'Branch         : Vijay Nagar, Indore\n' +
        'Period         : 01-Oct-2025 to 31-Mar-2026\n' +
        'Opening Balance: Rs 98,200.00\n' +
        '--------------------------------------------\n' +
        'Date        Description                    Debit      Credit     Balance\n' +
        '01-Mar-2026 Business Receipt               -          1,25,000   2,23,200\n' +
        '05-Mar-2026 Home Loan EMI                  18,450     -          2,04,750\n' +
        '07-Mar-2026 SIP - Axis MF                  5,000      -          1,99,750\n' +
        '10-Mar-2026 Amazon Shopping                3,200      -          1,96,550\n' +
        '12-Mar-2026 MP Bijli - Electricity         850        -          1,95,700\n' +
        '15-Mar-2026 NEFT Credit - Client           50,000     -          2,45,700\n' +
        '17-Mar-2026 POS - Goa Beach Resort         12,500     -          2,33,200\n' +
        '--------------------------------------------\n' +
        'Closing Balance: Rs 1,25,450.75\n' +
        'Average Monthly Balance: Rs 1,15,000.00\n' +
        'This is a system-generated statement.'
    ),
    Description__c = 'Bank Account Statement - 6 months - Document AI enabled'
));

cvList.add(new ContentVersion(
    Title = 'Home Loan Sanction Letter - Rajesh Sharma',
    PathOnClient = 'HomeLoan_Sanction_Rajesh_Sharma.txt',
    FirstPublishLocationId = rsId,
    VersionData = Blob.valueOf(
        'HDFC BANK LIMITED\n' +
        'LOAN SANCTION LETTER\n' +
        '--------------------------------------------\n' +
        'Date            : 28/03/2018\n' +
        'Ref No          : HL/2018/IND/00123\n' +
        '--------------------------------------------\n' +
        'Borrower Name   : RAJESH SHARMA\n' +
        'Borrower PAN    : ABCRS1234P\n' +
        'Borrower Aadhaar: 4782 5631 9024\n' +
        '--------------------------------------------\n' +
        'LOAN DETAILS:\n' +
        'Loan Type       : Home Loan\n' +
        'Loan Amount     : Rs 40,00,000 (Forty Lakhs)\n' +
        'Interest Rate   : 8.65% p.a. (Floating - MCLR linked)\n' +
        'Loan Tenure     : 240 months (20 Years)\n' +
        'EMI Amount      : Rs 18,450 per month\n' +
        'EMI Start Date  : 01/05/2018\n' +
        'Loan Account No : HL00123456789\n' +
        '--------------------------------------------\n' +
        'Property Details:\n' +
        '2BHK Flat, Flat No 301, Sunshine Apartments,\n' +
        'Vijay Nagar, Indore, Madhya Pradesh - 452001\n' +
        'Market Value    : Rs 55,00,000\n' +
        '--------------------------------------------\n' +
        'Outstanding Balance as on 19-Apr-2026: Rs 32,50,000\n' +
        'Payments Made   : 95 EMIs of Rs 18,450\n' +
        'Remaining Tenure: 145 months\n' +
        '--------------------------------------------\n' +
        'Restructuring Options Available:\n' +
        'Option 1: Extend tenure by 12 months -> New EMI: Rs 16,800\n' +
        'Option 2: Extend tenure by 24 months -> New EMI: Rs 15,400\n' +
        'Option 3: 3-month moratorium -> Resume at Rs 18,450 (interest added)\n' +
        '--------------------------------------------\n' +
        'For restructuring, contact your Relationship Manager\n' +
        'or use WhatsApp Banking: +91-9876543210'
    ),
    Description__c = 'Home Loan Sanction Letter with restructuring options - Document AI enabled'
));

cvList.add(new ContentVersion(
    Title = 'Credit Score Report - Rajesh Sharma',
    PathOnClient = 'CreditReport_Rajesh_Sharma.txt',
    FirstPublishLocationId = rsId,
    VersionData = Blob.valueOf(
        'TRANSUNION CIBIL LIMITED\n' +
        'CREDIT INFORMATION REPORT\n' +
        '--------------------------------------------\n' +
        'Report Date     : ' + String.valueOf(Date.today().addDays(-15)) + '\n' +
        'Report Number   : CIR/2026/3421789\n' +
        '--------------------------------------------\n' +
        'PERSONAL INFORMATION:\n' +
        'Full Name       : RAJESH SHARMA\n' +
        'Date of Birth   : 15-Jun-1985\n' +
        'PAN             : ABCRS1234P\n' +
        'Aadhaar         : XXXX XXXX 9024\n' +
        'Mobile          : XXXXXXX210\n' +
        '--------------------------------------------\n' +
        'CREDIT SUMMARY:\n' +
        'CIBIL Score     : 742 (GOOD)\n' +
        'Score Range     : 300-900\n' +
        'Total Accounts  : 3\n' +
        'Active Accounts : 2 (Home Loan + Credit Card)\n' +
        'Closed Accounts : 1\n' +
        '--------------------------------------------\n' +
        'ACCOUNT DETAILS:\n' +
        '1. Home Loan - HDFC Bank\n' +
        '   Sanctioned: Rs 40,00,000 | Outstanding: Rs 32,50,000\n' +
        '   Open Since: Apr-2018 | EMI: Rs 18,450\n' +
        '   Payment Status: 94 on-time, 1 late (30 days in Oct-2023)\n' +
        '2. Credit Card - HDFC Millennia\n' +
        '   Limit: Rs 2,00,000 | Outstanding: Rs 45,200\n' +
        '   Utilization: 22.6% | Payments: 11/12 on-time\n' +
        '3. Vehicle Loan (Closed)\n' +
        '   Fully repaid Feb-2022. No defaults.\n' +
        '--------------------------------------------\n' +
        'ENQUIRIES (Last 12 months): 1\n' +
        'DISPUTES FILED: 0\n' +
        '--------------------------------------------\n' +
        'Score Improvement Tips:\n' +
        '- Reduce CC utilization below 30%\n' +
        '- Maintain 100% on-time payments\n' +
        '--------------------------------------------\n' +
        'This report is confidential. Generated by CIBIL.'
    ),
    Description__c = 'CIBIL Credit Report - Score 742 - Document AI enabled'
));

// ============================================================
// PRIYA PATEL - Mumbai
// ============================================================
Id ppId = accMap.get('Priya Patel');

cvList.add(new ContentVersion(
    Title = 'Aadhaar Card - Priya Patel',
    PathOnClient = 'Aadhaar_Priya_Patel.txt',
    FirstPublishLocationId = ppId,
    VersionData = Blob.valueOf(
        'GOVERNMENT OF INDIA\n' +
        'UNIQUE IDENTIFICATION AUTHORITY OF INDIA\n' +
        '--------------------------------------------\n' +
        'Name        : PRIYA PATEL\n' +
        'Date of Birth: 22/03/1990\n' +
        'Gender      : FEMALE\n' +
        'Address     : 12, Linking Road, Bandra West,\n' +
        '              Mumbai, Maharashtra - 400050\n' +
        '--------------------------------------------\n' +
        'Aadhaar No  : 6234 8901 5678\n' +
        'Issue Date  : 05/08/2017\n' +
        '--------------------------------------------\n' +
        'Helpline: 1947 | uidai.gov.in'
    )
));

cvList.add(new ContentVersion(
    Title = 'PAN Card - Priya Patel',
    PathOnClient = 'PAN_Priya_Patel.txt',
    FirstPublishLocationId = ppId,
    VersionData = Blob.valueOf(
        'INCOME TAX DEPARTMENT - GOVT. OF INDIA\n' +
        'Name            : PRIYA PATEL\n' +
        'Father\'s Name   : SURESH PATEL\n' +
        'Date of Birth   : 22/03/1990\n' +
        'PAN             : BCDPP5678Q'
    )
));

cvList.add(new ContentVersion(
    Title = 'Bank Statement - Priya Patel (Last 6 months)',
    PathOnClient = 'BankStatement_Priya_Patel.txt',
    FirstPublishLocationId = ppId,
    VersionData = Blob.valueOf(
        'AXIS BANK LIMITED - ACCOUNT STATEMENT\n' +
        'Account Holder : PRIYA PATEL | Acc: SB00234567890\n' +
        'Period: 01-Oct-2025 to 31-Mar-2026\n' +
        'Opening Balance: Rs 45,000.00\n' +
        '01-Mar-2026 Salary TCS Ltd         +1,20,000   1,65,000\n' +
        '03-Mar-2026 SIP HDFC Flexi Cap     -10,000     1,55,000\n' +
        '08-Mar-2026 CC Payment Axis        -4,500      1,50,500\n' +
        '11-Mar-2026 Swiggy Food            -2,100      1,48,400\n' +
        '14-Mar-2026 Airtel Postpaid        -1,800      1,46,600\n' +
        'Closing Balance: Rs 89,320.50\n' +
        'Average Monthly Balance: Rs 1,05,000'
    )
));

cvList.add(new ContentVersion(
    Title = 'Credit Score Report - Priya Patel',
    PathOnClient = 'CreditReport_Priya_Patel.txt',
    FirstPublishLocationId = ppId,
    VersionData = Blob.valueOf(
        'TRANSUNION CIBIL - CREDIT INFORMATION REPORT\n' +
        'Report Date: ' + String.valueOf(Date.today().addDays(-10)) + '\n' +
        'Name: PRIYA PATEL | PAN: BCDPP5678Q\n' +
        'CIBIL Score: 798 (VERY GOOD)\n' +
        'Total Accounts: 2 | Active: 1 (Credit Card only)\n' +
        'Credit Card - Axis Bank Ace: Limit Rs 3L | Outstanding Rs 18,700\n' +
        'Utilization: 6.2% | Payment History: 24/24 on-time\n' +
        'Enquiries (12 months): 0 | Disputes: 0'
    )
));

// ============================================================
// AMIT KUMAR - Delhi
// ============================================================
Id akId = accMap.get('Amit Kumar');

cvList.add(new ContentVersion(Title='Aadhaar Card - Amit Kumar',PathOnClient='Aadhaar_Amit_Kumar.txt',FirstPublishLocationId=akId,
    VersionData=Blob.valueOf('GOVT OF INDIA - UIDAI\nName: AMIT KUMAR\nDOB: 08/11/1982\nGender: MALE\nAddress: 78, Lajpat Nagar III, New Delhi - 110024\nAadhaar: 7891 2345 6012\nIssue Date: 20/01/2016')));
cvList.add(new ContentVersion(Title='PAN Card - Amit Kumar',PathOnClient='PAN_Amit_Kumar.txt',FirstPublishLocationId=akId,
    VersionData=Blob.valueOf('INCOME TAX DEPT - GOVT OF INDIA\nName: AMIT KUMAR\nFather: SURESH KUMAR\nDOB: 08/11/1982\nPAN: CDEAKXXXX3F')));
cvList.add(new ContentVersion(Title='Bank Statement - Amit Kumar',PathOnClient='BankStatement_Amit_Kumar.txt',FirstPublishLocationId=akId,
    VersionData=Blob.valueOf('SBI ACCOUNT STATEMENT\nHolder: AMIT KUMAR | Acc: SB00345678901\nPeriod: Oct-2025 to Mar-2026\nSalary Govt +79,167 | Home Loan EMI -22,300 | FD Renewal -50,000 | CC Bill -6,500\nClosing Balance: Rs 2,45,680.25')));
cvList.add(new ContentVersion(Title='Home Loan Sanction Letter - Amit Kumar',PathOnClient='HomeLoan_Amit_Kumar.txt',FirstPublishLocationId=akId,
    VersionData=Blob.valueOf('SBI HOME LOAN SANCTION LETTER\nBorrower: AMIT KUMAR | PAN: CDEAKXXXX3F\nLoan Amount: Rs 65,00,000 | Rate: 8.40% | Tenure: 300 months\nEMI: Rs 22,300 | Loan No: HL00234567890\nProperty: 3BHK Apartment, Lajpat Nagar III, Delhi-110024\nMarket Value: Rs 90,00,000\nOutstanding: Rs 51,00,000 as on Apr-2026')));
cvList.add(new ContentVersion(Title='Credit Score Report - Amit Kumar',PathOnClient='CreditReport_Amit_Kumar.txt',FirstPublishLocationId=akId,
    VersionData=Blob.valueOf('EXPERIAN CREDIT REPORT\nDate: '+String.valueOf(Date.today().addDays(-20))+'\nName: AMIT KUMAR | PAN: CDEAKXXXX3F\nCredit Score: 761 (GOOD)\nHome Loan SBI: Rs 65L sanctioned, Rs 51L outstanding, 35/36 payments on-time\nCC SBI SimplyCLICK: Limit Rs 1.5L, Outstanding Rs 32,100, Utilization 21.4%\nFD: Rs 2,00,000 (acts as collateral buffer)')));

// ============================================================
// SUNITA DEVI - Jaipur
// ============================================================
Id sdId = accMap.get('Sunita Devi');
cvList.add(new ContentVersion(Title='Aadhaar Card - Sunita Devi',PathOnClient='Aadhaar_Sunita_Devi.txt',FirstPublishLocationId=sdId,
    VersionData=Blob.valueOf('GOVT OF INDIA - UIDAI\nName: SUNITA DEVI\nDOB: 30/07/1978\nGender: FEMALE\nAddress: 23, C-Scheme, Jaipur, Rajasthan - 302001\nAadhaar: 3456 7890 1234\nIssue Date: 15/06/2015')));
cvList.add(new ContentVersion(Title='PAN Card - Sunita Devi',PathOnClient='PAN_Sunita_Devi.txt',FirstPublishLocationId=sdId,
    VersionData=Blob.valueOf('INCOME TAX DEPT - GOVT OF INDIA\nName: SUNITA DEVI\nFather: MAHESH AGARWAL\nDOB: 30/07/1978\nPAN: DEFSD7890R')));
cvList.add(new ContentVersion(Title='Bank Statement - Sunita Devi',PathOnClient='BankStatement_Sunita_Devi.txt',FirstPublishLocationId=sdId,
    VersionData=Blob.valueOf('ICICI BANK STATEMENT\nHolder: SUNITA DEVI | Acc: CA00456789012\nPeriod: Oct-2025 to Mar-2026\nGarment Sale +2,50,000 | SIP+MF -30,000 | Supplier NEFT -1,25,000 | CC Bill -9,000\nClosing Balance: Rs 3,78,900.00')));
cvList.add(new ContentVersion(Title='Credit Score Report - Sunita Devi',PathOnClient='CreditReport_Sunita_Devi.txt',FirstPublishLocationId=sdId,
    VersionData=Blob.valueOf('CIBIL CREDIT REPORT\nDate: '+String.valueOf(Date.today().addDays(-8))+'\nName: SUNITA DEVI | PAN: DEFSD7890R\nCIBIL Score: 715 (GOOD)\nCC ICICI Business: Limit Rs 5L, Outstanding Rs 78,500, Utilization 57% (HIGH)\nPayment History: 3 late payments in last 18 months\nRecommendation: Reduce CC utilization')));

// ============================================================
// VIKRAM SINGH - Pune
// ============================================================
Id vsId = accMap.get('Vikram Singh');
cvList.add(new ContentVersion(Title='Aadhaar Card - Vikram Singh',PathOnClient='Aadhaar_Vikram_Singh.txt',FirstPublishLocationId=vsId,
    VersionData=Blob.valueOf('GOVT OF INDIA - UIDAI\nName: VIKRAM SINGH\nDOB: 12/04/1988\nGender: MALE\nAddress: 55, Koregaon Park, Pune, Maharashtra - 411001\nAadhaar: 9012 3456 7890\nIssue Date: 10/11/2017')));
cvList.add(new ContentVersion(Title='PAN Card - Vikram Singh',PathOnClient='PAN_Vikram_Singh.txt',FirstPublishLocationId=vsId,
    VersionData=Blob.valueOf('INCOME TAX DEPT\nName: VIKRAM SINGH\nFather: BALVIR SINGH\nDOB: 12/04/1988\nPAN: EFGVS2345S')));
cvList.add(new ContentVersion(Title='Bank Statement - Vikram Singh',PathOnClient='BankStatement_Vikram_Singh.txt',FirstPublishLocationId=vsId,
    VersionData=Blob.valueOf('ICICI BANK STATEMENT\nHolder: VIKRAM SINGH | Acc: SB00567890123\nPeriod: Oct-2025 to Mar-2026\nSalary Infosys +1,25,000 | Home Loan EMI -28,600 | Amazon -8,900 | Electricity -3,400 | CC -5,000\nClosing Balance: Rs 56,780.00')));
cvList.add(new ContentVersion(Title='Home Loan Sanction Letter - Vikram Singh',PathOnClient='HomeLoan_Vikram_Singh.txt',FirstPublishLocationId=vsId,
    VersionData=Blob.valueOf('ICICI BANK HOME LOAN SANCTION\nBorrower: VIKRAM SINGH | PAN: EFGVS2345S\nLoan Amount: Rs 80,00,000 | Rate: 8.75% | Tenure: 300 months\nEMI: Rs 28,600 | Loan No: HL00345678901\nProperty: 3BHK Flat, Koregaon Park Pune\nOutstanding: Rs 72,00,000 as on Apr-2026')));
cvList.add(new ContentVersion(Title='Credit Score Report - Vikram Singh',PathOnClient='CreditReport_Vikram_Singh.txt',FirstPublishLocationId=vsId,
    VersionData=Blob.valueOf('CIBIL CREDIT REPORT\nDate: '+String.valueOf(Date.today().addDays(-12))+'\nName: VIKRAM SINGH | PAN: EFGVS2345S\nCIBIL Score: 778 (VERY GOOD)\nHome Loan ICICI: Rs 80L, Outstanding Rs 72L, 48/48 payments on-time\nCC HDFC Regalia: Limit Rs 2.5L, Outstanding Rs 22,300, Utilization 8.9%')));

// ============================================================
// MEERA NAIR - Bangalore
// ============================================================
Id mnId = accMap.get('Meera Nair');
cvList.add(new ContentVersion(Title='Aadhaar Card - Meera Nair',PathOnClient='Aadhaar_Meera_Nair.txt',FirstPublishLocationId=mnId,
    VersionData=Blob.valueOf('GOVT OF INDIA - UIDAI\nName: MEERA NAIR\nDOB: 05/09/1993\nGender: FEMALE\nAddress: 34, Indiranagar 100 Feet Road, Bangalore, Karnataka - 560038\nAadhaar: 5678 9012 3456\nIssue Date: 22/02/2020')));
cvList.add(new ContentVersion(Title='PAN Card - Meera Nair',PathOnClient='PAN_Meera_Nair.txt',FirstPublishLocationId=mnId,
    VersionData=Blob.valueOf('INCOME TAX DEPT\nName: MEERA NAIR\nFather: KRISHNA NAIR\nDOB: 05/09/1993\nPAN: GHIMN3456T')));
cvList.add(new ContentVersion(Title='Bank Statement - Meera Nair',PathOnClient='BankStatement_Meera_Nair.txt',FirstPublishLocationId=mnId,
    VersionData=Blob.valueOf('HDFC BANK STATEMENT\nHolder: MEERA NAIR | Acc: SB00678901234\nPeriod: Oct-2025 to Mar-2026\nSalary Wipro +1,50,000 | SIP Mirae -15,000 | Rent -22,000 | Nykaa -4,700 | BESCOM -2,800\nClosing Balance: Rs 1,12,340.80')));
cvList.add(new ContentVersion(Title='Credit Score Report - Meera Nair',PathOnClient='CreditReport_Meera_Nair.txt',FirstPublishLocationId=mnId,
    VersionData=Blob.valueOf('CRIF HIGH MARK CREDIT REPORT\nDate: '+String.valueOf(Date.today().addDays(-5))+'\nName: MEERA NAIR | PAN: GHIMN3456T\nCredit Score: 812 (EXCELLENT)\nCC Amex Platinum Travel: Limit Rs 3.5L, Outstanding Rs 15,600, Utilization 4.5%\nPayment History: 36/36 on-time. ZERO late payments.\nHighest credit score in portfolio.')));

// ============================================================
// SURESH GUPTA - Ahmedabad
// ============================================================
Id sgId = accMap.get('Suresh Gupta');
cvList.add(new ContentVersion(Title='Aadhaar Card - Suresh Gupta',PathOnClient='Aadhaar_Suresh_Gupta.txt',FirstPublishLocationId=sgId,
    VersionData=Blob.valueOf('GOVT OF INDIA - UIDAI\nName: SURESH GUPTA\nDOB: 18/01/1975\nGender: MALE\nAddress: 89, CG Road Navrangpura, Ahmedabad, Gujarat - 380009\nAadhaar: 2345 6789 0123\nIssue Date: 08/09/2014')));
cvList.add(new ContentVersion(Title='PAN Card - Suresh Gupta',PathOnClient='PAN_Suresh_Gupta.txt',FirstPublishLocationId=sgId,
    VersionData=Blob.valueOf('INCOME TAX DEPT\nName: SURESH GUPTA\nFather: RAMESH GUPTA\nDOB: 18/01/1975\nPAN: HIJSG4567U')));
cvList.add(new ContentVersion(Title='Bank Statement - Suresh Gupta',PathOnClient='BankStatement_Suresh_Gupta.txt',FirstPublishLocationId=sgId,
    VersionData=Blob.valueOf('AXIS BANK STATEMENT\nHolder: SURESH GUPTA | Acc: CA00789012345\nPeriod: Oct-2025 to Mar-2026\nTextile Export +5,00,000 | Home Loan EMI -35,200 | Supplier RTGS -2,00,000 | FD -50,000 | CC -8,500\nClosing Balance: Rs 5,20,450.60')));
cvList.add(new ContentVersion(Title='Home Loan Sanction Letter - Suresh Gupta',PathOnClient='HomeLoan_Suresh_Gupta.txt',FirstPublishLocationId=sgId,
    VersionData=Blob.valueOf('AXIS BANK HOME LOAN SANCTION\nBorrower: SURESH GUPTA | PAN: HIJSG4567U\nLoan Amount: Rs 1,20,00,000 | Rate: 8.50% | Tenure: 360 months\nEMI: Rs 35,200 | Loan No: HL00456789012\nProperty: 4BHK Bungalow, Navrangpura Ahmedabad\nOutstanding: Rs 98,00,000 as on Apr-2026')));
cvList.add(new ContentVersion(Title='Credit Score Report - Suresh Gupta',PathOnClient='CreditReport_Suresh_Gupta.txt',FirstPublishLocationId=sgId,
    VersionData=Blob.valueOf('EXPERIAN CREDIT REPORT\nDate: '+String.valueOf(Date.today().addDays(-18))+'\nName: SURESH GUPTA | PAN: HIJSG4567U\nCredit Score: 731 (GOOD)\nHome Loan Axis: Rs 1.2Cr, Outstanding Rs 98L\nCC Kotak Corporate: Limit Rs 10L, Outstanding Rs 95,000\n2 late payments in 2022. No defaults. FD collateral Rs 5L.')));

// ============================================================
// KAVITHA REDDY - Hyderabad
// ============================================================
Id krId = accMap.get('Kavitha Reddy');
cvList.add(new ContentVersion(Title='Aadhaar Card - Kavitha Reddy',PathOnClient='Aadhaar_Kavitha_Reddy.txt',FirstPublishLocationId=krId,
    VersionData=Blob.valueOf('GOVT OF INDIA - UIDAI\nName: KAVITHA REDDY\nDOB: 25/12/1991\nGender: FEMALE\nAddress: 67, Jubilee Hills Road No 36, Hyderabad, Telangana - 500033\nAadhaar: 8901 2345 6789\nIssue Date: 14/07/2018')));
cvList.add(new ContentVersion(Title='PAN Card - Kavitha Reddy',PathOnClient='PAN_Kavitha_Reddy.txt',FirstPublishLocationId=krId,
    VersionData=Blob.valueOf('INCOME TAX DEPT\nName: KAVITHA REDDY\nFather: VENKATESH REDDY\nDOB: 25/12/1991\nPAN: IJKKR5678V')));
cvList.add(new ContentVersion(Title='Bank Statement - Kavitha Reddy',PathOnClient='BankStatement_Kavitha_Reddy.txt',FirstPublishLocationId=krId,
    VersionData=Blob.valueOf('INDUSIND BANK STATEMENT\nHolder: KAVITHA REDDY | Acc: SB00890123456\nPeriod: Oct-2025 to Mar-2026\nSalary Dr Reddys +91,667 | SIP ICICI -10,000 | CC Bill -5,600 | Big Bazaar -3,200 | TSSPDCL -1,500\nClosing Balance: Rs 78,900.25')));
cvList.add(new ContentVersion(Title='Credit Score Report - Kavitha Reddy',PathOnClient='CreditReport_Kavitha_Reddy.txt',FirstPublishLocationId=krId,
    VersionData=Blob.valueOf('CIBIL CREDIT REPORT\nDate: '+String.valueOf(Date.today().addDays(-7))+'\nName: KAVITHA REDDY | PAN: IJKKR5678V\nCIBIL Score: 784 (VERY GOOD)\nCC IndusInd Pinnacle: Limit Rs 2L, Outstanding Rs 28,400, Utilization 14.2%\nPayment History: 30/30 on-time. No late payments.')));

// ============================================================
// ROHIT VERMA - Chennai
// ============================================================
Id rvId = accMap.get('Rohit Verma');
cvList.add(new ContentVersion(Title='Aadhaar Card - Rohit Verma',PathOnClient='Aadhaar_Rohit_Verma.txt',FirstPublishLocationId=rvId,
    VersionData=Blob.valueOf('GOVT OF INDIA - UIDAI\nName: ROHIT VERMA\nDOB: 20/08/1986\nGender: MALE\nAddress: 14, Anna Nagar 2nd Avenue, Chennai, Tamil Nadu - 600040\nAadhaar: 1234 5678 9012\nIssue Date: 18/05/2016')));
cvList.add(new ContentVersion(Title='PAN Card - Rohit Verma',PathOnClient='PAN_Rohit_Verma.txt',FirstPublishLocationId=rvId,
    VersionData=Blob.valueOf('INCOME TAX DEPT\nName: ROHIT VERMA\nFather: ANIL VERMA\nDOB: 20/08/1986\nPAN: JKLRV6789W')));
cvList.add(new ContentVersion(Title='Bank Statement - Rohit Verma',PathOnClient='BankStatement_Rohit_Verma.txt',FirstPublishLocationId=rvId,
    VersionData=Blob.valueOf('KOTAK MAHINDRA BANK STATEMENT\nHolder: ROHIT VERMA | Acc: SB00901234567\nPeriod: Oct-2025 to Mar-2026\nSalary Hyundai +1,08,333 | Home Loan EMI -24,500 | CC SBI -6,700 | Zomato -2,900 | TNEB -1,800\nClosing Balance: Rs 43,210.50')));
cvList.add(new ContentVersion(Title='Home Loan Sanction Letter - Rohit Verma',PathOnClient='HomeLoan_Rohit_Verma.txt',FirstPublishLocationId=rvId,
    VersionData=Blob.valueOf('KOTAK MAHINDRA BANK HOME LOAN SANCTION\nBorrower: ROHIT VERMA | PAN: JKLRV6789W\nLoan Amount: Rs 50,00,000 | Rate: 8.80% | Tenure: 240 months\nEMI: Rs 24,500 | Loan No: HL00567890123\nProperty: 2BHK Flat, Anna Nagar Chennai\nOutstanding: Rs 43,00,000 as on Apr-2026')));
cvList.add(new ContentVersion(Title='Credit Score Report - Rohit Verma',PathOnClient='CreditReport_Rohit_Verma.txt',FirstPublishLocationId=rvId,
    VersionData=Blob.valueOf('CIBIL CREDIT REPORT\nDate: '+String.valueOf(Date.today().addDays(-14))+'\nName: ROHIT VERMA | PAN: JKLRV6789W\nCIBIL Score: 756 (GOOD)\nHome Loan Kotak: Rs 50L, Outstanding Rs 43L, 40/42 on-time, 2 late payments\nCC SBI SimplySAVE: Limit Rs 2.5L, Outstanding Rs 41,200')));

// ============================================================
// ANITA SHARMA - Kolkata
// ============================================================
Id asId = accMap.get('Anita Sharma');
cvList.add(new ContentVersion(Title='Aadhaar Card - Anita Sharma',PathOnClient='Aadhaar_Anita_Sharma.txt',FirstPublishLocationId=asId,
    VersionData=Blob.valueOf('GOVT OF INDIA - UIDAI\nName: ANITA SHARMA\nDOB: 14/05/1980\nGender: FEMALE\nAddress: 29, Park Street, Kolkata, West Bengal - 700016\nAadhaar: 3210 9876 5432\nIssue Date: 07/10/2015')));
cvList.add(new ContentVersion(Title='PAN Card - Anita Sharma',PathOnClient='PAN_Anita_Sharma.txt',FirstPublishLocationId=asId,
    VersionData=Blob.valueOf('INCOME TAX DEPT\nName: ANITA SHARMA\nFather: MOHAN SHARMA\nDOB: 14/05/1980\nPAN: KLMAS7890X')));
cvList.add(new ContentVersion(Title='Bank Statement - Anita Sharma',PathOnClient='BankStatement_Anita_Sharma.txt',FirstPublishLocationId=asId,
    VersionData=Blob.valueOf('STANDARD CHARTERED BANK STATEMENT\nHolder: ANITA SHARMA | Acc: SB00012345678\nPeriod: Oct-2025 to Mar-2026\nDesign Project +75,000 | SIP ABSL -5,000 | Rent -15,000 | Fabric Business -4,300 | CESC -1,100\nClosing Balance: Rs 95,670.00')));
cvList.add(new ContentVersion(Title='Credit Score Report - Anita Sharma',PathOnClient='CreditReport_Anita_Sharma.txt',FirstPublishLocationId=asId,
    VersionData=Blob.valueOf('CRIF HIGH MARK CREDIT REPORT\nDate: '+String.valueOf(Date.today().addDays(-9))+'\nName: ANITA SHARMA | PAN: KLMAS7890X\nCredit Score: 769 (GOOD)\nCC Standard Chartered: Limit Rs 1.5L, Outstanding Rs 19,800, Utilization 13.2%\nPayment History: 36/36 on-time. No defaults. Self-employed.')));

// Insert all ContentVersions in batches to avoid governor limits
List<ContentVersion> batch1 = new List<ContentVersion>();
List<ContentVersion> batch2 = new List<ContentVersion>();
Integer counter = 0;
for (ContentVersion cv : cvList) {
    if (counter < 25) { batch1.add(cv); }
    else { batch2.add(cv); }
    counter++;
}

insert batch1;
System.debug('Batch 1: Inserted ' + batch1.size() + ' ContentVersion records.');
insert batch2;
System.debug('Batch 2: Inserted ' + batch2.size() + ' ContentVersion records.');
System.debug('Total ContentVersions inserted: ' + cvList.size());
System.debug('Documents per person: Aadhaar, PAN, Bank Statement, Home Loan Letter (where applicable), Credit Report');
