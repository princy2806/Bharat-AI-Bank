// Step 17: Home Loan Supporting Documents
// Includes: Property Valuation Report, Loan Disbursement Letter,
//           NOC from Builder, Property Registration Certificate
// For: Rajesh Sharma, Amit Kumar, Vikram Singh, Suresh Gupta, Rohit Verma
// Document AI Template: HOME_LOAN_PROPERTY_DOC

Map<String, Id> accMap = new Map<String, Id>();
for (Account a : [SELECT Id, FirstName, LastName FROM Account WHERE IsPersonAccount = true
    AND LastName IN ('Sharma','Kumar','Singh','Gupta','Verma')
    ORDER BY CreatedDate DESC]) {
    String key = a.FirstName + ' ' + a.LastName;
    if (!accMap.containsKey(key)) accMap.put(key, a.Id);
}

List<ContentVersion> cvs = new List<ContentVersion>();

// ===== RAJESH SHARMA - Complete Home Loan Document Set =====
Id rsId = accMap.get('Rajesh Sharma');

cvs.add(new ContentVersion(Title='Property Valuation Report - Rajesh Sharma', PathOnClient='PropertyValuation_Rajesh_Sharma.txt',
FirstPublishLocationId=rsId,
VersionData=Blob.valueOf(
'PROPERTY VALUATION REPORT\n' +
'Empanelled Valuer: SHARMA & ASSOCIATES (Reg. Valuer IBI-2017-MP-001)\n' +
'================================================================\n' +
'Report Date             : 10/03/2018\n' +
'Report Reference No     : SVR/2018/MP/IND/1234\n' +
'Prepared For            : HDFC Bank Limited (Home Loan Processing)\n' +
'Borrower                : RAJESH SHARMA\n' +
'================================================================\n' +
'PROPERTY DESCRIPTION:\n' +
'Property Type           : Residential Apartment (2BHK)\n' +
'Unit No                 : 301, Sunshine Apartments\n' +
'Society Name            : Sunshine Cooperative Housing Society\n' +
'Location                : Vijay Nagar, Indore, Madhya Pradesh - 452001\n' +
'Floor                   : 3rd Floor (G+4 Building)\n' +
'Super Built-up Area     : 1,050 sq ft\n' +
'Carpet Area             : 825 sq ft\n' +
'Age of Building         : 3 years (Constructed 2015)\n' +
'Construction Quality    : Good (RCC Frame Structure)\n' +
'================================================================\n' +
'VALUATION METHODOLOGY: Sales Comparison + Income Approach\n' +
'\n' +
'COMPARATIVE MARKET ANALYSIS:\n' +
'Comparable Sale 1: Sunshine Apt Unit 201, Rs 51,00,000 (Jan 2018)\n' +
'Comparable Sale 2: Green Valley Apt, Vijay Nagar, Rs 49,50,000 (Feb 2018)\n' +
'Comparable Sale 3: Lotus Heights, MG Road, Rs 53,00,000 (Dec 2017)\n' +
'\n' +
'VALUATION SUMMARY:\n' +
'Market Value (As-Is)    : Rs 55,00,000\n' +
'Distress Value (80%)    : Rs 44,00,000\n' +
'Recommended Loan Amount : Up to Rs 41,25,000 (75% of Market Value)\n' +
'================================================================\n' +
'ENCUMBRANCE STATUS:\n' +
'EC Certificate Verified : YES (30 Years Clear)\n' +
'Existing Mortgage       : NONE\n' +
'Litigation              : NONE\n' +
'================================================================\n' +
'This valuation is valid for 3 months from date of report.\n' +
'Signed: R.K. Sharma, Reg. Valuer | Stamp: MP/VAL/2017/001'
)));

cvs.add(new ContentVersion(Title='Loan Disbursement Letter - Rajesh Sharma', PathOnClient='LoanDisbursement_Rajesh_Sharma.txt',
FirstPublishLocationId=rsId,
VersionData=Blob.valueOf(
'HDFC BANK LIMITED\n' +
'LOAN DISBURSEMENT LETTER\n' +
'================================================================\n' +
'Date                    : 01/04/2018\n' +
'Reference No            : HL/DISB/2018/IND/5678\n' +
'Borrower                : RAJESH SHARMA\n' +
'Loan Account No         : HL00123456789\n' +
'================================================================\n' +
'Dear Mr. Rajesh Sharma,\n' +
'\n' +
'We are pleased to inform you that the disbursement of your\n' +
'Home Loan has been processed as follows:\n' +
'\n' +
'DISBURSEMENT DETAILS:\n' +
'Sanctioned Loan Amount  : Rs 40,00,000\n' +
'Disbursement Amount     : Rs 40,00,000 (Full)\n' +
'Date of Disbursement    : 01/04/2018\n' +
'Mode                    : RTGS to Seller Account\n' +
'Beneficiary Name        : SUNSHINE DEVELOPERS PVT LTD\n' +
'Beneficiary Account     : HDFC Bank A/c 12345678901\n' +
'Property                : Flat 301, Sunshine Apartments, Vijay Nagar, Indore\n' +
'================================================================\n' +
'LOAN TERMS:\n' +
'Interest Rate           : 8.65% p.a. (MCLR + 0.25%)\n' +
'EMI Amount              : Rs 18,450\n' +
'EMI Start Date          : 05/05/2018\n' +
'Tenure                  : 240 months\n' +
'Last EMI Date           : 05/04/2038\n' +
'================================================================\n' +
'INSURANCE (MANDATORY):\n' +
'Home Loan Protect Plan  : Policy No HPP/2018/78901234\n' +
'Property Insurance      : Policy No HPI/2018/89012345\n' +
'================================================================\n' +
'NACH Mandate registered for auto-debit on 5th of each month.\n' +
'Debit Bank: HDFC Bank | Account: SB00123456789\n' +
'================================================================\n' +
'For any queries: 1800-266-3232 | homeloan@hdfcbank.com'
)));

cvs.add(new ContentVersion(Title='Property Registration Certificate - Rajesh Sharma', PathOnClient='PropertyReg_Rajesh_Sharma.txt',
FirstPublishLocationId=rsId,
VersionData=Blob.valueOf(
'OFFICE OF THE SUB-REGISTRAR\n' +
'INDORE-II, MADHYA PRADESH\n' +
'PROPERTY REGISTRATION CERTIFICATE\n' +
'================================================================\n' +
'Document Type           : Sale Deed\n' +
'Registration Number     : 1234/2018\n' +
'Date of Registration    : 28/03/2018\n' +
'Stamp Duty Paid         : Rs 3,30,000 (6% of Rs 55,00,000)\n' +
'Registration Fee        : Rs 55,000 (1%)\n' +
'================================================================\n' +
'SELLER DETAILS:\n' +
'Name                    : SUNSHINE DEVELOPERS PVT LTD\n' +
'PAN                     : AABCS1234D\n' +
'RERA No                 : P52100012345\n' +
'\n' +
'BUYER DETAILS:\n' +
'Name                    : RAJESH SHARMA\n' +
'PAN                     : ABCRS1234P\n' +
'Aadhaar                 : 4782 5631 9024\n' +
'================================================================\n' +
'PROPERTY DETAILS:\n' +
'Flat No                 : 301, 3rd Floor\n' +
'Building                : Sunshine Apartments\n' +
'Survey No               : 145/2/A, Vijay Nagar\n' +
'Area (Carpet)           : 825 sq ft\n' +
'Area (SBA)              : 1,050 sq ft\n' +
'Sale Consideration      : Rs 55,00,000\n' +
'================================================================\n' +
'This document is registered under Registration Act, 1908.\n' +
'Registrar: Sub-Registrar Indore-II | Seal & Signature Applied'
)));

// ===== AMIT KUMAR - Home Loan docs =====
Id akId = accMap.get('Amit Kumar');
cvs.add(new ContentVersion(Title='Property Registration Certificate - Amit Kumar', PathOnClient='PropertyReg_Amit_Kumar.txt',
FirstPublishLocationId=akId,
VersionData=Blob.valueOf(
'OFFICE OF THE SUB-REGISTRAR, SOUTH DELHI\n' +
'PROPERTY REGISTRATION CERTIFICATE\n' +
'Doc Type: Sale Deed | Reg No: 5678/2016 | Date: 08/09/2016\n' +
'Stamp Duty Paid: Rs 5,20,000 (8% of Rs 65,00,000)\n' +
'Buyer: AMIT KUMAR | PAN: CDEAKXXXX3F\n' +
'Property: Flat 402, Green Park Apartments, Lajpat Nagar III\n' +
'Area: 1,200 sq ft (SBA) | Sale Value: Rs 65,00,000\n' +
'Registrar: Sub-Registrar South Delhi | Date: 08/09/2016'
)));

cvs.add(new ContentVersion(Title='Loan Disbursement Letter - Amit Kumar', PathOnClient='LoanDisbursement_Amit_Kumar.txt',
FirstPublishLocationId=akId,
VersionData=Blob.valueOf(
'STATE BANK OF INDIA - HOME LOAN DISBURSEMENT LETTER\n' +
'Date: 15/09/2016 | Loan No: HL00234567890\n' +
'Borrower: AMIT KUMAR | Loan Amount: Rs 65,00,000\n' +
'Interest Rate: 8.40% p.a. | EMI: Rs 22,300\n' +
'EMI Start: 15/10/2016 | Tenure: 300 months\n' +
'Disbursed via RTGS to: GREEN PARK DEVELOPERS | SBI A/c 98765432101\n' +
'NACH debit from: SBI A/c SB00345678901 on 15th of each month'
)));

// ===== VIKRAM SINGH - Home Loan docs =====
Id vsId = accMap.get('Vikram Singh');
cvs.add(new ContentVersion(Title='Loan Disbursement Letter - Vikram Singh', PathOnClient='LoanDisbursement_Vikram_Singh.txt',
FirstPublishLocationId=vsId,
VersionData=Blob.valueOf(
'ICICI BANK LIMITED - HOME LOAN DISBURSEMENT\n' +
'Date: 01/02/2020 | Loan No: HL00345678901\n' +
'Borrower: VIKRAM SINGH | PAN: EFGVS2345S\n' +
'Loan Amount: Rs 80,00,000 | Rate: 8.75% | EMI: Rs 28,600\n' +
'Property: Flat 502, Koregaon Heights, Koregaon Park, Pune\n' +
'Disbursed via RTGS to Builder. NACH from ICICI A/c SB00567890123 on 1st.'
)));

cvs.add(new ContentVersion(Title='Property Valuation Report - Vikram Singh', PathOnClient='PropertyValuation_Vikram_Singh.txt',
FirstPublishLocationId=vsId,
VersionData=Blob.valueOf(
'PROPERTY VALUATION REPORT\n' +
'Valuer: PUNE VALUERS ASSOCIATES (Reg. MH/VAL/2019/045)\n' +
'Property: Flat 502, Koregaon Heights, Koregaon Park, Pune - 411001\n' +
'Type: 3BHK Apartment | Floor: 5th | Area: 1,450 sq ft (SBA)\n' +
'Age: 2 years (Built 2018) | Quality: Premium RCC\n' +
'Market Value: Rs 95,00,000 | Distress Value: Rs 76,00,000\n' +
'Loan Recommended: Up to Rs 71,25,000 (75% of MV)\n' +
'EC: Clear 25 years | Existing Mortgage: None\n' +
'Report Date: 15/01/2020 | Valid till: 15/04/2020'
)));

// ===== SURESH GUPTA - Home Loan docs =====
Id sgId = accMap.get('Suresh Gupta');
cvs.add(new ContentVersion(Title='Loan Disbursement Letter - Suresh Gupta', PathOnClient='LoanDisbursement_Suresh_Gupta.txt',
FirstPublishLocationId=sgId,
VersionData=Blob.valueOf(
'AXIS BANK LIMITED - HOME LOAN DISBURSEMENT\n' +
'Date: 10/05/2014 | Loan No: HL00456789012\n' +
'Borrower: SURESH GUPTA | PAN: HIJSG4567U\n' +
'Loan Amount: Rs 1,20,00,000 | Rate: 8.50% | EMI: Rs 35,200\n' +
'Property: Bungalow No 12, Navrangpura, Ahmedabad - 380009\n' +
'Plot Area: 2,000 sq ft | Built-up: 3,500 sq ft | 4BHK\n' +
'Market Value at time of loan: Rs 1,50,00,000\n' +
'NACH from Axis Bank A/c CA00789012345 on 10th of each month.'
)));

// ===== ROHIT VERMA - Home Loan docs =====
Id rvId = accMap.get('Rohit Verma');
cvs.add(new ContentVersion(Title='Loan Disbursement Letter - Rohit Verma', PathOnClient='LoanDisbursement_Rohit_Verma.txt',
FirstPublishLocationId=rvId,
VersionData=Blob.valueOf(
'KOTAK MAHINDRA BANK - HOME LOAN DISBURSEMENT\n' +
'Date: 01/11/2019 | Loan No: HL00567890123\n' +
'Borrower: ROHIT VERMA | PAN: JKLRV6789W\n' +
'Loan Amount: Rs 50,00,000 | Rate: 8.80% | EMI: Rs 24,500\n' +
'Property: Flat 204, Anna Towers, 2nd Avenue, Anna Nagar, Chennai - 600040\n' +
'Area: 950 sq ft (SBA) | Market Value: Rs 62,00,000\n' +
'NACH from Kotak Bank A/c SB00901234567 on 1st of each month.'
)));

// ===== BANK ACCOUNT PASSBOOK / DETAILS for ALL 10 persons =====
for (Account a : [SELECT Id, FirstName, LastName FROM Account WHERE IsPersonAccount = true
    AND LastName IN ('Sharma','Patel','Kumar','Devi','Singh','Nair','Gupta','Reddy','Verma')
    ORDER BY FirstName]) {
    String key = a.FirstName + ' ' + a.LastName;
    if (accMap.containsKey(key)) {
        cvs.add(new ContentVersion(
            Title = 'Bank Account KYC Details - ' + a.FirstName + ' ' + a.LastName,
            PathOnClient = 'BankKYC_' + a.FirstName + '_' + a.LastName + '.txt',
            FirstPublishLocationId = a.Id,
            VersionData = Blob.valueOf(
                'BANK ACCOUNT KYC VERIFICATION DOCUMENT\n' +
                'HDFC BANK LIMITED / ASSOCIATED BANK\n' +
                '================================================================\n' +
                'Account Holder Name     : ' + (a.FirstName + ' ' + a.LastName).toUpperCase() + '\n' +
                'KYC Status              : COMPLETED (Aadhaar + PAN Verified)\n' +
                'KYC Date                : 15/03/2024\n' +
                'KYC Mode                : Digital (V-CIP - Video Customer ID Process)\n' +
                '================================================================\n' +
                'IDENTITY DOCUMENTS SUBMITTED:\n' +
                '1. Aadhaar Card         : VERIFIED (UIDAI authenticated)\n' +
                '2. PAN Card             : VERIFIED (Income Tax Dept)\n' +
                '3. Voter ID             : SUBMITTED\n' +
                '4. Photograph           : Live capture via V-CIP\n' +
                '================================================================\n' +
                'ADDRESS PROOF:\n' +
                'Document Type           : Aadhaar Card\n' +
                'Address Verified        : YES\n' +
                '================================================================\n' +
                'FATCA DECLARATION:\n' +
                'US Person               : NO\n' +
                'Tax Residency           : India only\n' +
                'PAN submitted           : YES\n' +
                '================================================================\n' +
                'CKYC Number             : 12345' + String.valueOf(Math.abs(a.Id.hashCode())).left(7) + '\n' +
                'CKYC Registry           : CERSAI - Central KYC Records Registry\n' +
                '================================================================\n' +
                'This KYC is valid until re-verification as per RBI guidelines.\n' +
                'Next KYC Review         : March 2026\n' +
                'Account Status          : ACTIVE | Full KYC'
            )
        ));
    }
}

insert cvs;
System.debug('Inserted ' + cvs.size() + ' Home Loan property docs + Bank KYC documents.');
