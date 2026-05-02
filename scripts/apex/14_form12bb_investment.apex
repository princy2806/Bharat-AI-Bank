// Step 14: Form 12BB - Investment Declaration (for salaried employees)
//          Also includes GST Registration Certificate for business owners
// Document AI Template: FORM_12BB
// Fields: Employee Name, PAN, HRA details, LTA, 80C investments,
//         80D premium, Home Loan interest, Total Deductions Claimed

Map<String, Id> accMap = new Map<String, Id>();
for (Account a : [SELECT Id, FirstName, LastName FROM Account WHERE IsPersonAccount = true
    AND LastName IN ('Sharma','Patel','Kumar','Devi','Singh','Nair','Gupta','Reddy','Verma')
    ORDER BY CreatedDate DESC]) {
    String key = a.FirstName + ' ' + a.LastName;
    if (!accMap.containsKey(key)) accMap.put(key, a.Id);
}

List<ContentVersion> cvs = new List<ContentVersion>();

// ===== FORM 12BB - SALARIED EMPLOYEES =====

// Priya Patel - TCS
cvs.add(new ContentVersion(Title='Form 12BB - Priya Patel (FY 2025-26)', PathOnClient='Form12BB_Priya_Patel_FY2526.txt',
FirstPublishLocationId=accMap.get('Priya Patel'),
VersionData=Blob.valueOf(
'FORM 12BB\n' +
'STATEMENT OF PARTICULARS TO BE FURNISHED BY EMPLOYEE\n' +
'(Rule 26C of Income Tax Rules)\n' +
'================================================================\n' +
'FY                              : 2025-26\n' +
'Employee Name                   : PRIYA PATEL\n' +
'Employee PAN                    : BCDPP5678Q\n' +
'Employer                        : TATA CONSULTANCY SERVICES LTD\n' +
'Employee ID                     : TCS-MH-78901\n' +
'Declaration Date                : 15/04/2025\n' +
'================================================================\n' +
'PART I: HRA (House Rent Allowance)\n' +
'Name of Landlord                : SURESH MEHTA\n' +
'PAN of Landlord                 : ABCPM1234X\n' +
'Rent Paid Per Month             : Rs 22,000\n' +
'Annual Rent Paid                : Rs 2,64,000\n' +
'City of Rented Property         : Mumbai (Metro)\n' +
'HRA Received Annually           : Rs 2,40,000\n' +
'HRA Exemption Claimed           : Rs 1,80,000\n' +
'================================================================\n' +
'PART II: LTA (Leave Travel Allowance)\n' +
'LTA Claimed                     : Rs 40,000\n' +
'Journey Details                 : Mumbai to Goa (Nov 2025) - Air\n' +
'================================================================\n' +
'PART III: DEDUCTIONS UNDER CHAPTER VI-A\n' +
'Section 80C Investments:\n' +
'  PPF (HDFC Bank)               : Rs 50,000\n' +
'  ELSS - Axis Long Term Fund    : Rs 60,000\n' +
'  Life Insurance Premium (LIC)  : Rs 40,000\n' +
'  Total 80C                     : Rs 1,50,000 (Maximum limit)\n' +
'\n' +
'Section 80D (Health Insurance):\n' +
'  Self & Family Premium (Star)  : Rs 18,000\n' +
'  Parents Premium (Star Senior) : Rs 25,000\n' +
'  Total 80D                     : Rs 43,000 (Claimed: Rs 43,000)\n' +
'\n' +
'Section 80CCD(1B) - NPS         : Rs 50,000\n' +
'================================================================\n' +
'TOTAL DEDUCTIONS DECLARED       : Rs 2,83,000\n' +
'================================================================\n' +
'I hereby declare that the information given above is correct.\n' +
'Signature: PRIYA PATEL | Date: 15/04/2025'
)));

// Amit Kumar - Govt
cvs.add(new ContentVersion(Title='Form 12BB - Amit Kumar (FY 2025-26)', PathOnClient='Form12BB_Amit_Kumar_FY2526.txt',
FirstPublishLocationId=accMap.get('Amit Kumar'),
VersionData=Blob.valueOf(
'FORM 12BB - INVESTMENT DECLARATION\n' +
'FY: 2025-26 | Employee: AMIT KUMAR | PAN: CDEAKXXXX3F\n' +
'Employer: GNCT DELHI | EmpID: DL-GOV-45678\n' +
'================================================================\n' +
'PART I: HRA\n' +
'(Govt accommodation provided - HRA not applicable)\n' +
'Own House in Lajpat Nagar - Government Quarter allotted\n' +
'================================================================\n' +
'PART II: LTA\n' +
'LTA Claimed: Rs 38,400 | Travel: Delhi to Shimla (Dec 2025) - Rail\n' +
'================================================================\n' +
'PART III: CHAPTER VI-A DEDUCTIONS\n' +
'Sec 80C:\n' +
'  GPF Contribution               : Rs 54,000\n' +
'  LIC Premium                    : Rs 36,000\n' +
'  NSC (National Savings Cert)    : Rs 60,000\n' +
'  Total 80C                      : Rs 1,50,000\n' +
'Sec 80CCC (NPS - Employer+Emp)   : Rs 50,000\n' +
'Sec 80D (CGHS + Private Premium) : Rs 25,000\n' +
'Sec 24b (Home Loan Interest - Lajpat Nagar property): Rs 2,00,000\n' +
'================================================================\n' +
'TOTAL DEDUCTIONS: Rs 4,25,000\n' +
'Declared by: AMIT KUMAR | Date: 10/04/2025'
)));

// Vikram Singh - Infosys
cvs.add(new ContentVersion(Title='Form 12BB - Vikram Singh (FY 2025-26)', PathOnClient='Form12BB_Vikram_Singh_FY2526.txt',
FirstPublishLocationId=accMap.get('Vikram Singh'),
VersionData=Blob.valueOf(
'FORM 12BB - INVESTMENT DECLARATION\n' +
'FY: 2025-26 | Employee: VIKRAM SINGH | PAN: EFGVS2345S\n' +
'Employer: INFOSYS LIMITED | EmpID: INFY-PUN-56789\n' +
'================================================================\n' +
'PART I: HRA\n' +
'Own House in Koregaon Park Pune - Home Loan active\n' +
'No HRA - Claiming Home Loan benefit under Sec 24b\n' +
'================================================================\n' +
'PART II: LTA\n' +
'LTA Claimed: Rs 45,000 | Travel: Pune to Goa (Jan 2026) - Air\n' +
'================================================================\n' +
'PART III: CHAPTER VI-A\n' +
'Sec 80C:\n' +
'  PF Contribution                : Rs 90,000\n' +
'  ELSS - Mirae Asset             : Rs 60,000\n' +
'  Total 80C                      : Rs 1,50,000\n' +
'Sec 80D                          : Rs 25,000\n' +
'Sec 24b (Home Loan Interest)     : Rs 2,00,000\n' +
'  Lender: ICICI Bank | Loan No: HL00345678901\n' +
'  Annual Interest paid (FY25-26) : Rs 2,30,000 (Capped at Rs 2L)\n' +
'================================================================\n' +
'TOTAL DEDUCTIONS: Rs 3,75,000\n' +
'Declared by: VIKRAM SINGH | Date: 08/04/2025'
)));

// Meera Nair - Wipro
cvs.add(new ContentVersion(Title='Form 12BB - Meera Nair (FY 2025-26)', PathOnClient='Form12BB_Meera_Nair_FY2526.txt',
FirstPublishLocationId=accMap.get('Meera Nair'),
VersionData=Blob.valueOf(
'FORM 12BB - INVESTMENT DECLARATION\n' +
'FY: 2025-26 | Employee: MEERA NAIR | PAN: GHIMN3456T\n' +
'Employer: WIPRO LIMITED | EmpID: WIPRO-BLR-67890\n' +
'================================================================\n' +
'PART I: HRA\n' +
'Landlord: SURESH KRISHNAN | PAN: ABCSK5678Y\n' +
'Monthly Rent: Rs 22,000 | Annual: Rs 2,64,000 | City: Bengaluru (Metro)\n' +
'HRA Exemption Claimed: Rs 2,88,000\n' +
'================================================================\n' +
'PART III: CHAPTER VI-A\n' +
'Sec 80C:\n' +
'  PF Contribution                : Rs 1,08,000 (exceeds limit)\n' +
'  (Capped at Rs 1,50,000)        : Rs 1,50,000\n' +
'Sec 80D (Self + Family)          : Rs 50,000\n' +
'  Self Health Insurance (Star)   : Rs 25,000\n' +
'  Parents (60+, Star Senior Cit) : Rs 50,000 (Max Rs 50,000)\n' +
'Sec 80CCD(1B) NPS                : Rs 50,000\n' +
'================================================================\n' +
'TOTAL DEDUCTIONS: Rs 2,50,000\n' +
'Declared by: MEERA NAIR | Date: 12/04/2025'
)));

// Kavitha Reddy - Dr Reddys
cvs.add(new ContentVersion(Title='Form 12BB - Kavitha Reddy (FY 2025-26)', PathOnClient='Form12BB_Kavitha_Reddy_FY2526.txt',
FirstPublishLocationId=accMap.get('Kavitha Reddy'),
VersionData=Blob.valueOf(
'FORM 12BB - INVESTMENT DECLARATION\n' +
'FY: 2025-26 | Employee: KAVITHA REDDY | PAN: IJKKR5678V\n' +
'Employer: DR. REDDYS LABORATORIES | EmpID: DRL-HYD-78901\n' +
'================================================================\n' +
'PART I: HRA\n' +
'Landlord: RAJENDRA SHARMA | PAN: ABCRS9876X\n' +
'Monthly Rent: Rs 15,000 | City: Hyderabad (Non-metro)\n' +
'HRA Exemption: Rs 1,65,000\n' +
'================================================================\n' +
'PART III: CHAPTER VI-A\n' +
'Sec 80C:\n' +
'  PF Contribution                : Rs 66,000\n' +
'  ELSS SIP (ICICI Prudential)    : Rs 60,000\n' +
'  LIC Premium                    : Rs 24,000\n' +
'  Total 80C                      : Rs 1,50,000\n' +
'Sec 80D                          : Rs 25,000\n' +
'================================================================\n' +
'TOTAL DEDUCTIONS: Rs 1,75,000\n' +
'Declared by: KAVITHA REDDY | Date: 15/04/2025'
)));

// Rohit Verma - Hyundai
cvs.add(new ContentVersion(Title='Form 12BB - Rohit Verma (FY 2025-26)', PathOnClient='Form12BB_Rohit_Verma_FY2526.txt',
FirstPublishLocationId=accMap.get('Rohit Verma'),
VersionData=Blob.valueOf(
'FORM 12BB - INVESTMENT DECLARATION\n' +
'FY: 2025-26 | Employee: ROHIT VERMA | PAN: JKLRV6789W\n' +
'Employer: HYUNDAI MOTOR INDIA LTD | EmpID: HMIL-CHN-89012\n' +
'================================================================\n' +
'PART I: HRA - Own House (Home Loan active, no HRA)\n' +
'PART III: CHAPTER VI-A\n' +
'Sec 80C:\n' +
'  PF                             : Rs 78,000\n' +
'  LIC (2 policies)               : Rs 50,000\n' +
'  PPF (Post Office)              : Rs 22,000\n' +
'  Total 80C                      : Rs 1,50,000\n' +
'Sec 24b (Home Loan Interest)     : Rs 2,00,000\n' +
'  Lender: Kotak Mahindra Bank | Loan: HL00567890123\n' +
'  Annual Interest FY25-26        : Rs 2,12,000 (Capped Rs 2L)\n' +
'Sec 80D                          : Rs 25,000\n' +
'================================================================\n' +
'TOTAL DEDUCTIONS: Rs 3,75,000\n' +
'Declared by: ROHIT VERMA | Date: 10/04/2025'
)));

// ===== GST REGISTRATION CERTIFICATES for Business Owners =====

// Rajesh Sharma - GST
cvs.add(new ContentVersion(Title='GST Registration Certificate - Rajesh Sharma', PathOnClient='GST_Rajesh_Sharma.txt',
FirstPublishLocationId=accMap.get('Rajesh Sharma'),
VersionData=Blob.valueOf(
'GOODS AND SERVICES TAX\n' +
'REGISTRATION CERTIFICATE\n' +
'(Rule 10 of CGST Rules, 2017)\n' +
'================================================================\n' +
'GSTIN                           : 23ABCRS1234P1Z5\n' +
'Legal Name of Business          : RAJESH SHARMA\n' +
'Trade Name                      : RS ENTERPRISES\n' +
'Constitution of Business        : Proprietorship\n' +
'Address of Principal Place      : 45, MG Road, Vijay Nagar,\n' +
'                                  Indore, Madhya Pradesh - 452001\n' +
'Date of Liability               : 01/07/2019\n' +
'Date of Registration            : 15/07/2019\n' +
'================================================================\n' +
'Nature of Business Activities   : Trading in Hardware & Electronics\n' +
'HSN/SAC Codes                   : 8471, 8473, 998314\n' +
'State                           : 23 - Madhya Pradesh\n' +
'Central Jurisdication           : CGST Ward - Indore-I\n' +
'State Jurisdication             : SGST Circle - Indore\n' +
'================================================================\n' +
'Annual Turnover (FY 2024-25)    : Rs 42,00,000\n' +
'GST Filing Status               : Regular Taxpayer (Monthly)\n' +
'Last Return Filed               : GSTR-3B for March 2026\n' +
'================================================================\n' +
'This is a digitally signed certificate.\n' +
'Verify at: www.gst.gov.in'
)));

// Sunita Devi - GST
cvs.add(new ContentVersion(Title='GST Registration Certificate - Sunita Devi', PathOnClient='GST_Sunita_Devi.txt',
FirstPublishLocationId=accMap.get('Sunita Devi'),
VersionData=Blob.valueOf(
'GST REGISTRATION CERTIFICATE\n' +
'GSTIN: 08DEFSD7890R1ZA | Name: SUNITA DEVI\n' +
'Trade Name: SUNITA FASHION HOUSE | State: 08 - Rajasthan\n' +
'Business: Garment Manufacturing & Trading\n' +
'Address: 23, C-Scheme, Jaipur, Rajasthan - 302001\n' +
'Registration Date: 20/08/2018\n' +
'Annual Turnover (FY 2024-25): Rs 2,80,00,000\n' +
'Return Status: Regular - GSTR-1 & 3B filed monthly\n' +
'Verified at: www.gst.gov.in'
)));

// Suresh Gupta - GST
cvs.add(new ContentVersion(Title='GST Registration Certificate - Suresh Gupta', PathOnClient='GST_Suresh_Gupta.txt',
FirstPublishLocationId=accMap.get('Suresh Gupta'),
VersionData=Blob.valueOf(
'GST REGISTRATION CERTIFICATE\n' +
'GSTIN: 24HIJSG4567U1ZM | Name: SURESH GUPTA\n' +
'Trade Name: GUPTA TEXTILE EXPORTS | State: 24 - Gujarat\n' +
'Business: Textile Manufacturing & Export (LUT Filed for Export)\n' +
'Address: 89, CG Road, Navrangpura, Ahmedabad - 380009\n' +
'Registration Date: 01/07/2017 | IEC: GUPT0001234\n' +
'Annual Turnover (FY 2024-25): Rs 2,80,00,000\n' +
'Export Turnover: Rs 1,20,00,000 (LUT - Zero Rated)\n' +
'Return Status: Regular - Quarterly GSTR-1, Monthly GSTR-3B\n' +
'Verified at: www.gst.gov.in'
)));

// Anita Sharma - GST (Composition)
cvs.add(new ContentVersion(Title='GST Registration Certificate - Anita Sharma', PathOnClient='GST_Anita_Sharma.txt',
FirstPublishLocationId=accMap.get('Anita Sharma'),
VersionData=Blob.valueOf(
'GST REGISTRATION CERTIFICATE\n' +
'GSTIN: 19KLMAS7890X1ZP | Name: ANITA SHARMA\n' +
'Trade Name: ANITA CREATIONS | State: 19 - West Bengal\n' +
'Business: Fashion Design & Consulting Services (SAC: 998399)\n' +
'Address: 29, Park Street, Kolkata, West Bengal - 700016\n' +
'Registration Date: 12/10/2019\n' +
'Annual Turnover (FY 2024-25): Rs 12,50,000\n' +
'Return Status: Quarterly GSTR-4 (Composition Scheme)\n' +
'Tax Rate: 6% (3% CGST + 3% SGST) on turnover\n' +
'Verified at: www.gst.gov.in'
)));

insert cvs;
System.debug('Inserted ' + cvs.size() + ' Form 12BB (6) + GST Certificates (4) records.');
