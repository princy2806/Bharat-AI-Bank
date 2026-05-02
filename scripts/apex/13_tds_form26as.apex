// Step 13: TDS Certificate - Form 26AS (Annual Tax Statement) for all 10 persons
// Document AI Template: FORM_26AS
// Fields: PAN, Taxpayer Name, AY, Employer TAN, TDS Amount, Date of Deduction,
//         Bank TDS, Total TDS, Refund Status

Map<String, Id> accMap = new Map<String, Id>();
for (Account a : [SELECT Id, FirstName, LastName FROM Account WHERE IsPersonAccount = true
    AND LastName IN ('Sharma','Patel','Kumar','Devi','Singh','Nair','Gupta','Reddy','Verma')
    ORDER BY CreatedDate DESC]) {
    String key = a.FirstName + ' ' + a.LastName;
    if (!accMap.containsKey(key)) accMap.put(key, a.Id);
}

List<ContentVersion> cvs = new List<ContentVersion>();

// Template for 26AS header
String header26AS =
    'INCOME TAX DEPARTMENT - GOVT OF INDIA\n' +
    'ANNUAL TAX CREDIT STATEMENT (FORM 26AS)\n' +
    'Under Section 203AA of Income Tax Act, 1961\n' +
    '================================================================\n';

// Rajesh Sharma
cvs.add(new ContentVersion(Title='Form 26AS - Rajesh Sharma (AY 2025-26)', PathOnClient='Form26AS_Rajesh_Sharma_AY2526.txt',
FirstPublishLocationId=accMap.get('Rajesh Sharma'),
VersionData=Blob.valueOf(header26AS +
'PAN                             : ABCRS1234P\n' +
'Taxpayer Name                   : RAJESH SHARMA\n' +
'Assessment Year                 : 2025-26\n' +
'FY                              : 2024-25\n' +
'Address                         : 45 MG Road Vijay Nagar Indore MP 452001\n' +
'================================================================\n' +
'PART A: TDS ON SALARY (Sec 192)\n' +
'Deductor TAN    : N/A (Self-Employed - No Employer TDS)\n' +
'================================================================\n' +
'PART A1: TDS ON OTHER INCOME\n' +
'Sr  Deductor Name           TAN          Amount Paid  TDS Deducted  Date\n' +
'1   HDFC Bank (FD Interest) MUMB00123H   Rs 15,000    Rs 1,500      31/03/2025\n' +
'    Total TDS (Part A1)                               Rs 1,500\n' +
'================================================================\n' +
'PART B: TDS ON SALE OF PROPERTY : NIL\n' +
'PART C: TAX PAID BY TAXPAYER    : NIL (Tax payable is NIL)\n' +
'PART D: TAX REFUND              :\n' +
'  Refund Claimed                : Rs 1,500\n' +
'  Refund Status                 : Processed - Credited to SB00123456789\n' +
'  Date of Refund                : 15/09/2025\n' +
'================================================================\n' +
'PART E: AIR (Annual Information Return):\n' +
'  Business Turnover Reported    : Rs 42,00,000\n' +
'  GST Turnover                  : Rs 42,00,000 (GSTIN: 23ABCRS1234P1Z5)\n' +
'================================================================\n' +
'TOTAL TAXES PAID                : Rs 0\n' +
'TOTAL TDS DEDUCTED              : Rs 1,500\n' +
'REFUND ISSUED                   : Rs 1,500\n' +
'================================================================\n' +
'Generated from TRACES portal: www.tdscpc.gov.in | Date: 01/04/2026'
)));

// Priya Patel
cvs.add(new ContentVersion(Title='Form 26AS - Priya Patel (AY 2025-26)', PathOnClient='Form26AS_Priya_Patel_AY2526.txt',
FirstPublishLocationId=accMap.get('Priya Patel'),
VersionData=Blob.valueOf(header26AS +
'PAN: BCDPP5678Q | Name: PRIYA PATEL | AY: 2025-26\n' +
'================================================================\n' +
'PART A: TDS ON SALARY (Sec 192)\n' +
'Deductor Name   : TATA CONSULTANCY SERVICES LTD\n' +
'TAN             : MUMТ01234C\n' +
'Salary Paid     : Rs 12,60,000\n' +
'TDS Deducted    : Rs 76,000\n' +
'Quarters        : Q1: Rs 18,500 | Q2: Rs 18,500 | Q3: Rs 19,200 | Q4: Rs 19,800\n' +
'================================================================\n' +
'PART A1: TDS ON OTHER INCOME\n' +
'Axis Bank (Savings Interest): TDS Rs 0 (Interest < Rs 10,000)\n' +
'================================================================\n' +
'PART D: REFUND\n' +
'Refund Amount   : Rs 18,800 | Status: Credited to SB00234567890 on 20/08/2025\n' +
'================================================================\n' +
'TOTAL TDS DEDUCTED: Rs 76,000 | NET REFUND: Rs 18,800\n' +
'Generated: TRACES | Date: 01/04/2026'
)));

// Amit Kumar
cvs.add(new ContentVersion(Title='Form 26AS - Amit Kumar (AY 2025-26)', PathOnClient='Form26AS_Amit_Kumar_AY2526.txt',
FirstPublishLocationId=accMap.get('Amit Kumar'),
VersionData=Blob.valueOf(header26AS +
'PAN: CDEAKXXXX3F | Name: AMIT KUMAR | AY: 2025-26\n' +
'================================================================\n' +
'PART A: TDS ON SALARY (Sec 192)\n' +
'Deductor        : GOVT OF NATIONAL CAPITAL TERRITORY OF DELHI\n' +
'TAN             : DELD01234G\n' +
'Salary Paid     : Rs 9,50,000\n' +
'TDS Deducted    : Rs 55,800\n' +
'================================================================\n' +
'PART A1: TDS ON OTHER INCOME\n' +
'SBI Bank (FD Interest Rs 20,000): TDS Rs 2,000 | Date: 31/03/2025\n' +
'================================================================\n' +
'TOTAL TDS DEDUCTED: Rs 57,800\n' +
'PART D: REFUND: Rs 18,160 | Credited to SB00345678901 on 12/09/2025\n' +
'Generated: TRACES | Date: 01/04/2026'
)));

// Sunita Devi
cvs.add(new ContentVersion(Title='Form 26AS - Sunita Devi (AY 2025-26)', PathOnClient='Form26AS_Sunita_Devi_AY2526.txt',
FirstPublishLocationId=accMap.get('Sunita Devi'),
VersionData=Blob.valueOf(header26AS +
'PAN: DEFSD7890R | Name: SUNITA DEVI | AY: 2025-26\n' +
'================================================================\n' +
'PART A: TDS ON SALARY: NIL (Self-employed business owner)\n' +
'================================================================\n' +
'PART A1: TDS ON OTHER INCOME\n' +
'ICICI Bank (FD Interest Rs 35,000): TDS Rs 3,500 | 31/03/2025\n' +
'================================================================\n' +
'PART C: TAX PAID BY TAXPAYER\n' +
'Advance Tax  : Rs 48,000 | Paid on: 15/03/2025\n' +
'Self-Assess  : Rs 2,960  | Paid on: 31/07/2025\n' +
'================================================================\n' +
'TOTAL TAX PAID: Rs 54,460\n' +
'TAX LIABILITY : Rs 50,960 | STATUS: Tax Paid in Full\n' +
'Generated: TRACES | Date: 01/04/2026'
)));

// Vikram Singh
cvs.add(new ContentVersion(Title='Form 26AS - Vikram Singh (AY 2025-26)', PathOnClient='Form26AS_Vikram_Singh_AY2526.txt',
FirstPublishLocationId=accMap.get('Vikram Singh'),
VersionData=Blob.valueOf(header26AS +
'PAN: EFGVS2345S | Name: VIKRAM SINGH | AY: 2025-26\n' +
'================================================================\n' +
'PART A: TDS ON SALARY (Sec 192)\n' +
'Deductor: INFOSYS LIMITED | TAN: BNGI00897B\n' +
'Salary Paid: Rs 15,00,000 | TDS Deducted: Rs 93,600\n' +
'Q1: Rs 23,400 | Q2: Rs 23,400 | Q3: Rs 23,400 | Q4: Rs 23,400\n' +
'================================================================\n' +
'PART A1: Bank TDS: ICICI Bank (Interest Rs 5,000) - TDS: NIL (<Rs10K)\n' +
'TOTAL TDS: Rs 93,600 | TAX BALANCE: NIL\n' +
'Generated: TRACES | Date: 01/04/2026'
)));

// Meera Nair
cvs.add(new ContentVersion(Title='Form 26AS - Meera Nair (AY 2025-26)', PathOnClient='Form26AS_Meera_Nair_AY2526.txt',
FirstPublishLocationId=accMap.get('Meera Nair'),
VersionData=Blob.valueOf(header26AS +
'PAN: GHIMN3456T | Name: MEERA NAIR | AY: 2025-26\n' +
'================================================================\n' +
'PART A: TDS ON SALARY\n' +
'Deductor: WIPRO LIMITED | TAN: BNGI12345W\n' +
'Salary Paid: Rs 17,46,000 | TDS Deducted: Rs 1,55,632\n' +
'================================================================\n' +
'PART A1: HDFC Bank (Interest Rs 8,000) - TDS: NIL\n' +
'TOTAL TDS: Rs 1,55,632 | TAX BALANCE: NIL\n' +
'Generated: TRACES | Date: 01/04/2026'
)));

// Suresh Gupta
cvs.add(new ContentVersion(Title='Form 26AS - Suresh Gupta (AY 2025-26)', PathOnClient='Form26AS_Suresh_Gupta_AY2526.txt',
FirstPublishLocationId=accMap.get('Suresh Gupta'),
VersionData=Blob.valueOf(header26AS +
'PAN: HIJSG4567U | Name: SURESH GUPTA | AY: 2025-26\n' +
'================================================================\n' +
'PART A: TDS ON SALARY: NIL (Business Owner)\n' +
'PART A1: TDS ON OTHER INCOME\n' +
'Axis Bank FD (Rs 85,000 interest): TDS Rs 8,500 | 31/03/2025\n' +
'Dividend Income (Rs 45,000)      : TDS Rs 4,500\n' +
'================================================================\n' +
'PART C: ADVANCE TAX\n' +
'Advance Tax Q1: Rs 5,00,000 | Q2: Rs 5,00,000\n' +
'Advance Tax Q3: Rs 5,00,000 | Q4: Rs 5,00,000\n' +
'Self-Assessment Tax: Rs 82,000 | 30/07/2025\n' +
'================================================================\n' +
'TOTAL TAX PAID: Rs 21,82,000\n' +
'TAX LIABILITY : Rs 20,82,000 | EXCESS PAID: Rs 1,00,000\n' +
'REFUND: Rs 1,00,000 | Credited on 20/10/2025\n' +
'Generated: TRACES | Date: 01/04/2026'
)));

// Kavitha Reddy
cvs.add(new ContentVersion(Title='Form 26AS - Kavitha Reddy (AY 2025-26)', PathOnClient='Form26AS_Kavitha_Reddy_AY2526.txt',
FirstPublishLocationId=accMap.get('Kavitha Reddy'),
VersionData=Blob.valueOf(header26AS +
'PAN: IJKKR5678V | Name: KAVITHA REDDY | AY: 2025-26\n' +
'================================================================\n' +
'PART A: TDS ON SALARY\n' +
'Deductor: DR. REDDYS LABORATORIES LTD | TAN: HYDД01234R\n' +
'Salary Paid: Rs 10,67,000 | TDS Deducted: Rs 49,608\n' +
'================================================================\n' +
'PART A1: IndusInd Bank (Interest Rs 6,000): NIL\n' +
'TOTAL TDS: Rs 49,608 | TAX BALANCE: NIL\n' +
'Generated: TRACES | Date: 01/04/2026'
)));

// Rohit Verma
cvs.add(new ContentVersion(Title='Form 26AS - Rohit Verma (AY 2025-26)', PathOnClient='Form26AS_Rohit_Verma_AY2526.txt',
FirstPublishLocationId=accMap.get('Rohit Verma'),
VersionData=Blob.valueOf(header26AS +
'PAN: JKLRV6789W | Name: ROHIT VERMA | AY: 2025-26\n' +
'================================================================\n' +
'PART A: TDS ON SALARY\n' +
'Deductor: HYUNDAI MOTOR INDIA LTD | TAN: CHET01234H\n' +
'Salary Paid: Rs 12,61,000 | TDS Deducted: Rs 43,264\n' +
'================================================================\n' +
'PART A1: Kotak Bank (Interest Rs 4,000): NIL\n' +
'TOTAL TDS: Rs 43,264 | TAX BALANCE: NIL\n' +
'Generated: TRACES | Date: 01/04/2026'
)));

// Anita Sharma
cvs.add(new ContentVersion(Title='Form 26AS - Anita Sharma (AY 2025-26)', PathOnClient='Form26AS_Anita_Sharma_AY2526.txt',
FirstPublishLocationId=accMap.get('Anita Sharma'),
VersionData=Blob.valueOf(header26AS +
'PAN: KLMAS7890X | Name: ANITA SHARMA | AY: 2025-26\n' +
'================================================================\n' +
'PART A: TDS ON SALARY: NIL (Self-employed designer)\n' +
'PART A1: TDS ON PROFESSIONAL INCOME (Sec 194J)\n' +
'Client 1 (Lakme Fashion): TDS Rs 30,000 | 31/12/2024\n' +
'Client 2 (NIFT): TDS Rs 25,000 | 31/03/2025\n' +
'Std Chartered Bank (FD Interest Rs 12,000): TDS Rs 1,200\n' +
'================================================================\n' +
'TOTAL TDS DEDUCTED: Rs 56,200\n' +
'SELF-ASSESSMENT TAX: Rs 3,032 | Paid 25/07/2025\n' +
'TAX LIABILITY: Rs 58,032 | STATUS: Fully Paid\n' +
'MF Dividend TDS: Rs 800 | Total TDS+SAT: Rs 60,032\n' +
'Generated: TRACES | Date: 01/04/2026'
)));

insert cvs;
System.debug('Inserted ' + cvs.size() + ' Form 26AS TDS certificates for all 10 persons.');
