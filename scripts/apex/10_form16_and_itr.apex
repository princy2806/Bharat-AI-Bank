// Step 10: Form 16 (Part A + Part B) for Salaried Employees
//          ITR Acknowledgement for Self-Employed / Business Owners
// Document AI Template: FORM_16 / ITR_ACKNOWLEDGEMENT
// Fields to extract: Employee Name, PAN, Employer, TAN, Gross Salary,
//                    Tax Deducted, Net Tax Payable, Assessment Year

Map<String, Id> accMap = new Map<String, Id>();
for (Account a : [SELECT Id, FirstName, LastName FROM Account WHERE IsPersonAccount = true
    AND LastName IN ('Sharma','Patel','Kumar','Devi','Singh','Nair','Gupta','Reddy','Verma')
    ORDER BY CreatedDate DESC]) {
    String key = a.FirstName + ' ' + a.LastName;
    if (!accMap.containsKey(key)) accMap.put(key, a.Id);
}

List<ContentVersion> cvs = new List<ContentVersion>();

// ====== SALARIED EMPLOYEES - FORM 16 ======

// Priya Patel - TCS (Salary: 12 LPA)
cvs.add(new ContentVersion(Title='Form 16 - Priya Patel (AY 2025-26)', PathOnClient='Form16_Priya_Patel_AY2526.txt',
FirstPublishLocationId = accMap.get('Priya Patel'),
VersionData = Blob.valueOf(
'FORM NO. 16\n' +
'CERTIFICATE UNDER SECTION 203 OF THE INCOME TAX ACT, 1961\n' +
'(TDS on Salary)\n' +
'============================================================\n' +
'PART A - TDS DETAILS\n' +
'============================================================\n' +
'Assessment Year     : 2025-26 (FY 2024-25)\n' +
'Certificate No      : TCSPU2025/F16/789012\n' +
'\n' +
'EMPLOYER (DEDUCTOR) DETAILS:\n' +
'Name                : TATA CONSULTANCY SERVICES LIMITED\n' +
'TAN                 : MUMТ01234C\n' +
'PAN                 : AABCT3518Q\n' +
'Address             : TCS House, Raveline St, Fort, Mumbai - 400001\n' +
'\n' +
'EMPLOYEE (DEDUCTEE) DETAILS:\n' +
'Name                : PRIYA PATEL\n' +
'PAN                 : BCDPP5678Q\n' +
'Designation         : Senior Data Analyst\n' +
'Employee ID         : TCS-MH-78901\n' +
'Period of Employment: 01-Apr-2024 to 31-Mar-2025\n' +
'\n' +
'TDS SUMMARY:\n' +
'Quarter | TDS Deposited\n' +
'Q1 (Apr-Jun 2024)  : Rs 18,500\n' +
'Q2 (Jul-Sep 2024)  : Rs 18,500\n' +
'Q3 (Oct-Dec 2024)  : Rs 19,200\n' +
'Q4 (Jan-Mar 2025)  : Rs 19,800\n' +
'Total TDS Deposited : Rs 76,000\n' +
'============================================================\n' +
'PART B - COMPUTATION OF INCOME\n' +
'============================================================\n' +
'GROSS SALARY:\n' +
'Basic Salary        : Rs 6,00,000\n' +
'HRA                 : Rs 2,40,000\n' +
'Special Allowance   : Rs 2,40,000\n' +
'LTA                 : Rs 60,000\n' +
'Medical Allowance   : Rs 15,000\n' +
'GROSS TOTAL SALARY  : Rs 11,55,000\n' +
'\n' +
'LESS: EXEMPTIONS:\n' +
'HRA Exempted (Sec 10(13A)) : Rs 1,80,000\n' +
'LTA Exempted (Sec 10(5))   : Rs 40,000\n' +
'Standard Deduction (Sec 16): Rs 50,000\n' +
'\n' +
'INCOME FROM SALARY          : Rs 8,85,000\n' +
'\n' +
'DEDUCTIONS UNDER CHAPTER VI-A:\n' +
'Sec 80C (PPF + ELSS SIP)   : Rs 1,50,000\n' +
'Sec 80D (Health Insurance)  : Rs 25,000\n' +
'Total Deductions            : Rs 1,75,000\n' +
'\n' +
'NET TAXABLE INCOME          : Rs 7,10,000\n' +
'\n' +
'TAX COMPUTATION:\n' +
'Tax on Rs 7,10,000  : Rs 55,000 (Old Regime)\n' +
'Surcharge           : Nil\n' +
'Health & Education Cess (4%): Rs 2,200\n' +
'GROSS TAX LIABILITY : Rs 57,200\n' +
'Less: TDS Deducted  : Rs 76,000\n' +
'REFUND DUE          : Rs 18,800\n' +
'============================================================\n' +
'Verified by: HR - TCS Limited | Date: 15/05/2025'
)));

// Amit Kumar - Govt of Delhi (Salary: 9.5 LPA)
cvs.add(new ContentVersion(Title='Form 16 - Amit Kumar (AY 2025-26)', PathOnClient='Form16_Amit_Kumar_AY2526.txt',
FirstPublishLocationId = accMap.get('Amit Kumar'),
VersionData = Blob.valueOf(
'FORM NO. 16\n' +
'CERTIFICATE UNDER SECTION 203 OF THE INCOME TAX ACT, 1961\n' +
'============================================================\n' +
'Assessment Year     : 2025-26 (FY 2024-25)\n' +
'Certificate No      : GOID/DL/2025/F16/234567\n' +
'\n' +
'EMPLOYER DETAILS:\n' +
'Name                : GOVERNMENT OF NATIONAL CAPITAL TERRITORY OF DELHI\n' +
'TAN                 : DELD01234G\n' +
'PAN                 : AABCG2340Q\n' +
'Address             : Delhi Secretariat, IP Estate, New Delhi - 110002\n' +
'\n' +
'EMPLOYEE DETAILS:\n' +
'Name                : AMIT KUMAR\n' +
'PAN                 : CDEAKXXXX3F\n' +
'Designation         : Section Officer, Grade-B Gazetted\n' +
'Employee ID         : DL-GOV-45678\n' +
'Pay Scale           : Level 9 (7th Pay Commission)\n' +
'\n' +
'TDS DEPOSITED (TRACES): Rs 55,800 (Total FY 2024-25)\n' +
'============================================================\n' +
'PART B - COMPUTATION:\n' +
'Basic Pay           : Rs 5,40,000\n' +
'Dearness Allowance  : Rs 2,30,000\n' +
'HRA                 : Rs 1,26,000\n' +
'Travel Allowance    : Rs 38,400\n' +
'Medical Allowance   : Rs 15,600\n' +
'GROSS SALARY        : Rs 9,50,000\n' +
'\n' +
'Less: Exemptions\n' +
'HRA (Sec 10(13A))   : Rs 84,000\n' +
'Standard Deduction  : Rs 50,000\n' +
'\n' +
'INCOME FROM SALARY  : Rs 8,16,000\n' +
'\n' +
'Deductions (Ch VI-A):\n' +
'Sec 80C (GPF + NSC) : Rs 1,50,000\n' +
'Sec 80CCC (NPS)     : Rs 50,000\n' +
'Sec 80D             : Rs 25,000\n' +
'Total Deductions    : Rs 2,25,000\n' +
'\n' +
'NET TAXABLE INCOME  : Rs 5,91,000\n' +
'Tax + Cess          : Rs 37,640\n' +
'TDS Deducted        : Rs 55,800\n' +
'REFUND DUE          : Rs 18,160\n' +
'============================================================\n' +
'Signed: Principal Accounts Officer, Govt of Delhi | 15/05/2025'
)));

// Vikram Singh - Infosys (Salary: 15 LPA)
cvs.add(new ContentVersion(Title='Form 16 - Vikram Singh (AY 2025-26)', PathOnClient='Form16_Vikram_Singh_AY2526.txt',
FirstPublishLocationId = accMap.get('Vikram Singh'),
VersionData = Blob.valueOf(
'FORM NO. 16 - TDS CERTIFICATE\n' +
'Assessment Year: 2025-26 | Certificate No: INFY/PUN/2025/F16/345678\n' +
'EMPLOYER: INFOSYS LIMITED | TAN: BNGI00897B | PAN: AAACI1681G\n' +
'Address: Electronics City, Bengaluru - 560100\n' +
'EMPLOYEE: VIKRAM SINGH | PAN: EFGVS2345S\n' +
'Designation: Senior Software Engineer (Band 6) | EmpID: INFY-PUN-56789\n' +
'============================================================\n' +
'PART B - INCOME COMPUTATION:\n' +
'Basic Salary        : Rs 7,50,000\n' +
'HRA                 : Rs 3,00,000\n' +
'Variable Pay        : Rs 2,25,000\n' +
'Special Allowance   : Rs 1,80,000\n' +
'ESOP               : Rs 45,000\n' +
'GROSS SALARY        : Rs 15,00,000\n' +
'Less HRA Exempt     : Rs 2,40,000\n' +
'Less Standard Deduction: Rs 50,000\n' +
'INCOME FROM SALARY  : Rs 12,10,000\n' +
'Sec 80C (PF+ELSS)   : Rs 1,50,000\n' +
'Sec 80D             : Rs 25,000\n' +
'Home Loan Interest (Sec 24b): Rs 2,00,000\n' +
'NET TAXABLE INCOME  : Rs 8,35,000\n' +
'Tax + Cess          : Rs 93,600\n' +
'TDS Deducted        : Rs 93,600\n' +
'TAX BALANCE         : NIL\n' +
'Signed: HR Payroll, Infosys Ltd | 20/05/2025'
)));

// Meera Nair - Wipro (Salary: 18 LPA)
cvs.add(new ContentVersion(Title='Form 16 - Meera Nair (AY 2025-26)', PathOnClient='Form16_Meera_Nair_AY2526.txt',
FirstPublishLocationId = accMap.get('Meera Nair'),
VersionData = Blob.valueOf(
'FORM NO. 16 - TDS CERTIFICATE\n' +
'Assessment Year: 2025-26 | Certificate No: WIPR/BLR/2025/F16/456789\n' +
'EMPLOYER: WIPRO LIMITED | TAN: BNGI12345W | PAN: AAACW2258A\n' +
'EMPLOYEE: MEERA NAIR | PAN: GHIMN3456T\n' +
'Designation: Data Science Lead (Grade L5) | EmpID: WIPRO-BLR-67890\n' +
'============================================================\n' +
'PART B - INCOME COMPUTATION:\n' +
'Basic Salary        : Rs 9,00,000\n' +
'HRA                 : Rs 3,60,000\n' +
'Variable Pay        : Rs 2,70,000\n' +
'Special Allowance   : Rs 2,16,000\n' +
'GROSS SALARY        : Rs 17,46,000\n' +
'Less HRA Exempt     : Rs 2,88,000\n' +
'Less Standard Deduction: Rs 50,000\n' +
'INCOME FROM SALARY  : Rs 14,08,000\n' +
'Sec 80C (PF+ELSS SIP): Rs 1,50,000\n' +
'Sec 80D (Family Health): Rs 50,000\n' +
'NET TAXABLE INCOME  : Rs 12,08,000\n' +
'Tax + Cess          : Rs 1,55,632\n' +
'TDS Deducted        : Rs 1,55,632\n' +
'TAX BALANCE         : NIL\n' +
'Signed: Payroll Finance, Wipro Ltd | 18/05/2025'
)));

// Kavitha Reddy - Dr Reddy's (Salary: 11 LPA)
cvs.add(new ContentVersion(Title='Form 16 - Kavitha Reddy (AY 2025-26)', PathOnClient='Form16_Kavitha_Reddy_AY2526.txt',
FirstPublishLocationId = accMap.get('Kavitha Reddy'),
VersionData = Blob.valueOf(
'FORM NO. 16 - TDS CERTIFICATE\n' +
'Assessment Year: 2025-26 | Certificate No: DRRL/HYD/2025/F16/567890\n' +
'EMPLOYER: DR. REDDYS LABORATORIES LTD | TAN: HYDД01234R | PAN: AABCD3456E\n' +
'EMPLOYEE: KAVITHA REDDY | PAN: IJKKR5678V\n' +
'Designation: Sr. Research Associate | EmpID: DRL-HYD-78901\n' +
'============================================================\n' +
'PART B:\n' +
'Basic Salary        : Rs 5,50,000\n' +
'HRA                 : Rs 2,20,000\n' +
'Variable Pay        : Rs 1,65,000\n' +
'Special Allowance   : Rs 1,32,000\n' +
'GROSS SALARY        : Rs 10,67,000\n' +
'Less HRA Exempt     : Rs 1,65,000\n' +
'Less Standard Deduction: Rs 50,000\n' +
'INCOME FROM SALARY  : Rs 8,52,000\n' +
'Sec 80C (PF+SIP)    : Rs 1,50,000\n' +
'Sec 80D             : Rs 25,000\n' +
'NET TAXABLE INCOME  : Rs 6,77,000\n' +
'Tax + Cess          : Rs 49,608\n' +
'TDS Deducted        : Rs 49,608\n' +
'TAX BALANCE         : NIL\n' +
'Signed: Payroll, Dr Reddys Labs | 22/05/2025'
)));

// Rohit Verma - Hyundai Motors India (Salary: 13 LPA)
cvs.add(new ContentVersion(Title='Form 16 - Rohit Verma (AY 2025-26)', PathOnClient='Form16_Rohit_Verma_AY2526.txt',
FirstPublishLocationId = accMap.get('Rohit Verma'),
VersionData = Blob.valueOf(
'FORM NO. 16 - TDS CERTIFICATE\n' +
'Assessment Year: 2025-26 | Certificate No: HMIL/CHN/2025/F16/678901\n' +
'EMPLOYER: HYUNDAI MOTOR INDIA LIMITED | TAN: CHET01234H | PAN: AAACH1234B\n' +
'EMPLOYEE: ROHIT VERMA | PAN: JKLRV6789W\n' +
'Designation: Senior Production Engineer | EmpID: HMIL-CHN-89012\n' +
'============================================================\n' +
'PART B:\n' +
'Basic Salary        : Rs 6,50,000\n' +
'HRA                 : Rs 2,60,000\n' +
'Variable Pay        : Rs 1,95,000\n' +
'Special Allowance   : Rs 1,56,000\n' +
'GROSS SALARY        : Rs 12,61,000\n' +
'Less HRA Exempt     : Rs 2,00,000\n' +
'Less Standard Deduction: Rs 50,000\n' +
'INCOME FROM SALARY  : Rs 10,11,000\n' +
'Sec 80C (PF+LIC)    : Rs 1,50,000\n' +
'Sec 24b Home Loan Int: Rs 2,00,000\n' +
'Sec 80D             : Rs 25,000\n' +
'NET TAXABLE INCOME  : Rs 6,36,000\n' +
'Tax + Cess          : Rs 43,264\n' +
'TDS Deducted        : Rs 43,264\n' +
'TAX BALANCE         : NIL\n' +
'Signed: HR Finance, Hyundai Motor India | 20/05/2025'
)));

// ====== SELF-EMPLOYED / BUSINESS - ITR ACKNOWLEDGEMENT ======

// Rajesh Sharma - Self-employed (Business Income)
cvs.add(new ContentVersion(Title='ITR Acknowledgement - Rajesh Sharma (AY 2025-26)', PathOnClient='ITR_Rajesh_Sharma_AY2526.txt',
FirstPublishLocationId = accMap.get('Rajesh Sharma'),
VersionData = Blob.valueOf(
'INCOME TAX DEPARTMENT - GOVERNMENT OF INDIA\n' +
'ITR-4 ACKNOWLEDGEMENT (SUGAM)\n' +
'(For Presumptive Income - Small Business)\n' +
'============================================================\n' +
'Assessment Year     : 2025-26 (FY 2024-25)\n' +
'Acknowledgement No  : 234567891234567\n' +
'Date of Filing      : 28/07/2025\n' +
'Mode of Filing      : Online (e-Filing Portal)\n' +
'e-Verification      : Aadhaar OTP | Verified\n' +
'============================================================\n' +
'TAXPAYER DETAILS:\n' +
'Name                : RAJESH SHARMA\n' +
'PAN                 : ABCRS1234P\n' +
'Aadhaar             : 4782 5631 9024\n' +
'Date of Birth       : 15/06/1985\n' +
'Address             : 45, MG Road, Vijay Nagar, Indore MP 452001\n' +
'Mobile              : 9876543210\n' +
'Email               : rajesh.sharma@indoremail.com\n' +
'============================================================\n' +
'INCOME DETAILS:\n' +
'Gross Business Turnover: Rs 42,00,000\n' +
'Presumptive Income (8%): Rs 3,36,000\n' +
'Other Income (Interest) : Rs 15,000\n' +
'GROSS TOTAL INCOME  : Rs 3,51,000\n' +
'\n' +
'DEDUCTIONS (Ch VI-A):\n' +
'Sec 80C (LIC + PPF) : Rs 1,00,000\n' +
'Sec 80D (Mediclaim) : Rs 25,000\n' +
'\n' +
'NET TAXABLE INCOME  : Rs 2,26,000\n' +
'TAX PAYABLE         : Rs 0 (Below basic exemption)\n' +
'TDS Deducted (Bank TDS): Rs 1,500\n' +
'REFUND DUE          : Rs 1,500\n' +
'============================================================\n' +
'STATUS              : Filed & Verified | ITD Processing'
)));

// Sunita Devi - Business Owner (Garments)
cvs.add(new ContentVersion(Title='ITR Acknowledgement - Sunita Devi (AY 2025-26)', PathOnClient='ITR_Sunita_Devi_AY2526.txt',
FirstPublishLocationId = accMap.get('Sunita Devi'),
VersionData = Blob.valueOf(
'INCOME TAX DEPARTMENT\n' +
'ITR-3 ACKNOWLEDGEMENT (Business & Profession)\n' +
'Acknowledgement No  : 345678901234567\n' +
'Date of Filing      : 15/10/2025 | Mode: Online\n' +
'Name: SUNITA DEVI | PAN: DEFSD7890R\n' +
'============================================================\n' +
'INCOME DETAILS:\n' +
'Business Income (Garment Trade): Rs 28,00,000\n' +
'Less: Business Expenses        : Rs 19,80,000\n' +
'Net Profit from Business       : Rs 8,20,000\n' +
'Other Income (FD Interest)     : Rs 35,000\n' +
'GROSS TOTAL INCOME  : Rs 8,55,000\n' +
'Sec 80C             : Rs 1,50,000\n' +
'Sec 80D             : Rs 25,000\n' +
'NET TAXABLE INCOME  : Rs 6,80,000\n' +
'TAX + CESS          : Rs 50,960\n' +
'Advance Tax Paid    : Rs 48,000\n' +
'SELF-ASSESSMENT TAX : Rs 2,960\n' +
'STATUS: Filed & Verified'
)));

// Suresh Gupta - Business Owner (Textile Export)
cvs.add(new ContentVersion(Title='ITR Acknowledgement - Suresh Gupta (AY 2025-26)', PathOnClient='ITR_Suresh_Gupta_AY2526.txt',
FirstPublishLocationId = accMap.get('Suresh Gupta'),
VersionData = Blob.valueOf(
'INCOME TAX DEPARTMENT\n' +
'ITR-3 ACKNOWLEDGEMENT\n' +
'Acknowledgement No  : 456789012345678\n' +
'Date of Filing      : 30/10/2025 | Mode: Online\n' +
'Name: SURESH GUPTA | PAN: HIJSG4567U\n' +
'============================================================\n' +
'INCOME DETAILS:\n' +
'Business Turnover (Textile Export): Rs 2,80,00,000\n' +
'Less: Business Expenses           : Rs 2,10,00,000\n' +
'Net Profit from Business          : Rs 70,00,000\n' +
'Other Income (FD+Dividend)        : Rs 85,000\n' +
'GROSS TOTAL INCOME  : Rs 70,85,000\n' +
'Sec 80C             : Rs 1,50,000\n' +
'Sec 80D             : Rs 50,000\n' +
'NET TAXABLE INCOME  : Rs 68,85,000\n' +
'TAX + SURCHARGE + CESS: Rs 20,82,000\n' +
'Advance Tax Paid    : Rs 20,00,000\n' +
'SELF-ASSESSMENT TAX : Rs 82,000\n' +
'STATUS: Filed & Verified'
)));

// Anita Sharma - Self-employed (Fashion Designer)
cvs.add(new ContentVersion(Title='ITR Acknowledgement - Anita Sharma (AY 2025-26)', PathOnClient='ITR_Anita_Sharma_AY2526.txt',
FirstPublishLocationId = accMap.get('Anita Sharma'),
VersionData = Blob.valueOf(
'INCOME TAX DEPARTMENT\n' +
'ITR-4 ACKNOWLEDGEMENT (SUGAM)\n' +
'Acknowledgement No  : 567890123456789\n' +
'Date of Filing      : 25/07/2025 | Mode: Online\n' +
'Name: ANITA SHARMA | PAN: KLMAS7890X\n' +
'============================================================\n' +
'INCOME DETAILS:\n' +
'Professional Income (Fashion Design): Rs 12,50,000\n' +
'Less: Business Expenses             : Rs 3,75,000\n' +
'Net Professional Income             : Rs 8,75,000\n' +
'Other Income (MF Dividends)         : Rs 22,000\n' +
'GROSS TOTAL INCOME  : Rs 8,97,000\n' +
'Sec 80C (SIP+PPF)   : Rs 1,50,000\n' +
'Sec 80D             : Rs 25,000\n' +
'NET TAXABLE INCOME  : Rs 7,22,000\n' +
'TAX + CESS          : Rs 58,032\n' +
'TDS Deducted        : Rs 55,000\n' +
'SELF-ASSESSMENT TAX : Rs 3,032\n' +
'STATUS: Filed & Verified'
)));

insert cvs;
System.debug('Inserted ' + cvs.size() + ' Form 16 / ITR documents (6 Form 16 + 4 ITR).');
