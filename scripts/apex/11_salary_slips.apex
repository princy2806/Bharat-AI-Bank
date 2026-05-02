// Step 11: Salary Slips (Last 3 Months) for Salaried Employees
// Persons: Priya Patel, Amit Kumar, Vikram Singh, Meera Nair, Kavitha Reddy, Rohit Verma
// Document AI Template: SALARY_SLIP
// Fields: Employee Name, Employee ID, Month, Basic, HRA, Gross, PF Deduction,
//         TDS Deduction, Professional Tax, Net Salary

Map<String, Id> accMap = new Map<String, Id>();
for (Account a : [SELECT Id, FirstName, LastName FROM Account WHERE IsPersonAccount = true
    AND LastName IN ('Patel','Kumar','Singh','Nair','Reddy','Verma')
    ORDER BY CreatedDate DESC]) {
    String key = a.FirstName + ' ' + a.LastName;
    if (!accMap.containsKey(key)) accMap.put(key, a.Id);
}

List<ContentVersion> cvs = new List<ContentVersion>();

// ===== PRIYA PATEL - TCS (Monthly: 1,00,000 take-home) =====
String priyaSlipTemplate = 'TATA CONSULTANCY SERVICES LIMITED\n' +
    'PAYSLIP FOR {MONTH} 2026\n' +
    '============================================================\n' +
    'Employee Name   : PRIYA PATEL\n' +
    'Employee ID     : TCS-MH-78901\n' +
    'Designation     : Senior Data Analyst\n' +
    'Department      : Analytics & Insights\n' +
    'Location        : Mumbai\n' +
    'Bank Account    : XXXXXXX7890 | IFSC: AXIS0001234\n' +
    'PAN             : BCDPP5678Q | PF Account: MH/MUM/1234567/000/0000012\n' +
    '============================================================\n' +
    'EARNINGS:\n' +
    'Basic Salary        : Rs 50,000\n' +
    'HRA                 : Rs 20,000\n' +
    'Special Allowance   : Rs 20,000\n' +
    'Variable Pay        : Rs 15,000\n' +
    'GROSS EARNINGS      : Rs 1,05,000\n' +
    '============================================================\n' +
    'DEDUCTIONS:\n' +
    'Provident Fund (12%): Rs 6,000\n' +
    'Professional Tax    : Rs 200\n' +
    'Income Tax (TDS)    : Rs {TDS}\n' +
    'Total Deductions    : Rs {TOTAL_DED}\n' +
    '============================================================\n' +
    'NET PAY             : Rs {NET}\n' +
    '(Credited to bank on {DATE})\n' +
    '============================================================\n' +
    'PF Contribution (Employer 12%): Rs 6,000\n' +
    'Cumulative PF (YTD)           : Rs {CUMULATIVE_PF}\n' +
    'This is a computer-generated payslip. No signature required.';

cvs.add(new ContentVersion(Title='Salary Slip - Priya Patel (March 2026)', PathOnClient='SalarySlip_Priya_Patel_Mar2026.txt',
FirstPublishLocationId=accMap.get('Priya Patel'),
VersionData=Blob.valueOf(priyaSlipTemplate.replace('{MONTH}','MARCH').replace('{TDS}','6,633').replace('{TOTAL_DED}','12,833').replace('{NET}','92,167').replace('{DATE}','31-Mar-2026').replace('{CUMULATIVE_PF}','72,000'))));

cvs.add(new ContentVersion(Title='Salary Slip - Priya Patel (February 2026)', PathOnClient='SalarySlip_Priya_Patel_Feb2026.txt',
FirstPublishLocationId=accMap.get('Priya Patel'),
VersionData=Blob.valueOf(priyaSlipTemplate.replace('{MONTH}','FEBRUARY').replace('{TDS}','6,633').replace('{TOTAL_DED}','12,833').replace('{NET}','92,167').replace('{DATE}','28-Feb-2026').replace('{CUMULATIVE_PF}','66,000'))));

cvs.add(new ContentVersion(Title='Salary Slip - Priya Patel (January 2026)', PathOnClient='SalarySlip_Priya_Patel_Jan2026.txt',
FirstPublishLocationId=accMap.get('Priya Patel'),
VersionData=Blob.valueOf(priyaSlipTemplate.replace('{MONTH}','JANUARY').replace('{TDS}','6,633').replace('{TOTAL_DED}','12,833').replace('{NET}','92,167').replace('{DATE}','31-Jan-2026').replace('{CUMULATIVE_PF}','60,000'))));

// ===== AMIT KUMAR - Govt of Delhi =====
String amitSlip = 'GOVERNMENT OF NCT OF DELHI\n' +
    'PAY SLIP FOR {MONTH} 2026\n' +
    '============================================================\n' +
    'Employee Name   : AMIT KUMAR\n' +
    'Employee ID     : DL-GOV-45678\n' +
    'Designation     : Section Officer (Grade-B Gazetted)\n' +
    'Pay Level       : Level 9, Cell 4 (7th CPC)\n' +
    'Department      : Revenue Department\n' +
    'GPF Account     : DL/SOF/0034567\n' +
    'PAN             : CDEAKXXXX3F\n' +
    '============================================================\n' +
    'EARNINGS:\n' +
    'Basic Pay           : Rs 45,000\n' +
    'Dearness Allowance (50%): Rs 22,500\n' +
    'HRA (27% of Basic)  : Rs 12,150\n' +
    'Transport Allowance : Rs 3,600\n' +
    'Medical Allowance   : Rs 1,250\n' +
    'GROSS PAY           : Rs 84,500\n' +
    '============================================================\n' +
    'DEDUCTIONS:\n' +
    'GPF (10% of Basic)  : Rs 4,500\n' +
    'NPS (10% of Basic+DA): Rs 6,750\n' +
    'CGHS Contribution   : Rs 500\n' +
    'Professional Tax    : Rs 200\n' +
    'Income Tax (TDS)    : Rs 4,650\n' +
    'Total Deductions    : Rs 16,600\n' +
    '============================================================\n' +
    'NET PAY             : Rs 67,900\n' +
    'Credit Date: {DATE}\n' +
    'GPF Balance (YTD)   : Rs 1,45,000';

cvs.add(new ContentVersion(Title='Salary Slip - Amit Kumar (March 2026)', PathOnClient='SalarySlip_Amit_Kumar_Mar2026.txt',
FirstPublishLocationId=accMap.get('Amit Kumar'), VersionData=Blob.valueOf(amitSlip.replace('{MONTH}','MARCH').replace('{DATE}','31-Mar-2026'))));
cvs.add(new ContentVersion(Title='Salary Slip - Amit Kumar (February 2026)', PathOnClient='SalarySlip_Amit_Kumar_Feb2026.txt',
FirstPublishLocationId=accMap.get('Amit Kumar'), VersionData=Blob.valueOf(amitSlip.replace('{MONTH}','FEBRUARY').replace('{DATE}','28-Feb-2026'))));
cvs.add(new ContentVersion(Title='Salary Slip - Amit Kumar (January 2026)', PathOnClient='SalarySlip_Amit_Kumar_Jan2026.txt',
FirstPublishLocationId=accMap.get('Amit Kumar'), VersionData=Blob.valueOf(amitSlip.replace('{MONTH}','JANUARY').replace('{DATE}','31-Jan-2026'))));

// ===== VIKRAM SINGH - Infosys =====
String vikramSlip = 'INFOSYS LIMITED\nPAY ADVICE FOR {MONTH} 2026\n' +
    'Employee: VIKRAM SINGH | ID: INFY-PUN-56789 | Sr. Software Engineer\n' +
    'PAN: EFGVS2345S | PF UAN: 100789456123\n' +
    '============================================================\n' +
    'EARNINGS:\n' +
    'Basic           : Rs 62,500   HRA: Rs 25,000\n' +
    'Special Allowance: Rs 15,000  Variable: Rs 18,750\n' +
    'GROSS           : Rs 1,21,250\n' +
    'DEDUCTIONS:\n' +
    'PF (12%)        : Rs 7,500   PT: Rs 200\n' +
    'ESIC            : Nil (Salary > Rs 21,000)\n' +
    'TDS             : Rs 7,800\n' +
    'Total Deductions: Rs 15,500\n' +
    'NET PAY         : Rs 1,05,750\n' +
    'Month: {MONTH} | Credit: {DATE}';

cvs.add(new ContentVersion(Title='Salary Slip - Vikram Singh (March 2026)', PathOnClient='SalarySlip_Vikram_Singh_Mar2026.txt',
FirstPublishLocationId=accMap.get('Vikram Singh'), VersionData=Blob.valueOf(vikramSlip.replace('{MONTH}','MARCH').replace('{DATE}','31-Mar-2026'))));
cvs.add(new ContentVersion(Title='Salary Slip - Vikram Singh (February 2026)', PathOnClient='SalarySlip_Vikram_Singh_Feb2026.txt',
FirstPublishLocationId=accMap.get('Vikram Singh'), VersionData=Blob.valueOf(vikramSlip.replace('{MONTH}','FEBRUARY').replace('{DATE}','28-Feb-2026'))));
cvs.add(new ContentVersion(Title='Salary Slip - Vikram Singh (January 2026)', PathOnClient='SalarySlip_Vikram_Singh_Jan2026.txt',
FirstPublishLocationId=accMap.get('Vikram Singh'), VersionData=Blob.valueOf(vikramSlip.replace('{MONTH}','JANUARY').replace('{DATE}','31-Jan-2026'))));

// ===== MEERA NAIR - Wipro =====
String meeraSlip = 'WIPRO LIMITED\nPAY STUB - {MONTH} 2026\n' +
    'Employee: MEERA NAIR | ID: WIPRO-BLR-67890 | Data Science Lead\n' +
    'PAN: GHIMN3456T | UAN: 100567891234\n' +
    '============================================================\n' +
    'EARNINGS:\n' +
    'Basic           : Rs 75,000   HRA: Rs 30,000\n' +
    'Special Allow   : Rs 18,000   Variable Pay: Rs 22,500\n' +
    'GROSS           : Rs 1,45,500\n' +
    'DEDUCTIONS:\n' +
    'PF (12%)        : Rs 9,000   PT: Rs 200\n' +
    'TDS             : Rs 12,969\n' +
    'Total Deductions: Rs 22,169\n' +
    'NET PAY         : Rs 1,23,331\n' +
    'Month: {MONTH} | Credit: {DATE}';

cvs.add(new ContentVersion(Title='Salary Slip - Meera Nair (March 2026)', PathOnClient='SalarySlip_Meera_Nair_Mar2026.txt',
FirstPublishLocationId=accMap.get('Meera Nair'), VersionData=Blob.valueOf(meeraSlip.replace('{MONTH}','MARCH').replace('{DATE}','31-Mar-2026'))));
cvs.add(new ContentVersion(Title='Salary Slip - Meera Nair (February 2026)', PathOnClient='SalarySlip_Meera_Nair_Feb2026.txt',
FirstPublishLocationId=accMap.get('Meera Nair'), VersionData=Blob.valueOf(meeraSlip.replace('{MONTH}','FEBRUARY').replace('{DATE}','28-Feb-2026'))));
cvs.add(new ContentVersion(Title='Salary Slip - Meera Nair (January 2026)', PathOnClient='SalarySlip_Meera_Nair_Jan2026.txt',
FirstPublishLocationId=accMap.get('Meera Nair'), VersionData=Blob.valueOf(meeraSlip.replace('{MONTH}','JANUARY').replace('{DATE}','31-Jan-2026'))));

// ===== KAVITHA REDDY - Dr Reddys =====
String kavithaSlip = 'DR. REDDYS LABORATORIES LTD\nPAY SLIP - {MONTH} 2026\n' +
    'Employee: KAVITHA REDDY | ID: DRL-HYD-78901 | Sr. Research Associate\n' +
    'PAN: IJKKR5678V | UAN: 100345678901\n' +
    '============================================================\n' +
    'EARNINGS:\n' +
    'Basic           : Rs 45,833   HRA: Rs 18,333\n' +
    'Special Allow   : Rs 11,000   Variable: Rs 13,750\n' +
    'GROSS           : Rs 88,916\n' +
    'DEDUCTIONS:\n' +
    'PF (12%)        : Rs 5,500   PT: Rs 200\n' +
    'TDS             : Rs 4,134\n' +
    'Total Deductions: Rs 9,834\n' +
    'NET PAY         : Rs 79,082\n' +
    'Month: {MONTH} | Credit: {DATE}';

cvs.add(new ContentVersion(Title='Salary Slip - Kavitha Reddy (March 2026)', PathOnClient='SalarySlip_Kavitha_Reddy_Mar2026.txt',
FirstPublishLocationId=accMap.get('Kavitha Reddy'), VersionData=Blob.valueOf(kavithaSlip.replace('{MONTH}','MARCH').replace('{DATE}','31-Mar-2026'))));
cvs.add(new ContentVersion(Title='Salary Slip - Kavitha Reddy (February 2026)', PathOnClient='SalarySlip_Kavitha_Reddy_Feb2026.txt',
FirstPublishLocationId=accMap.get('Kavitha Reddy'), VersionData=Blob.valueOf(kavithaSlip.replace('{MONTH}','FEBRUARY').replace('{DATE}','28-Feb-2026'))));
cvs.add(new ContentVersion(Title='Salary Slip - Kavitha Reddy (January 2026)', PathOnClient='SalarySlip_Kavitha_Reddy_Jan2026.txt',
FirstPublishLocationId=accMap.get('Kavitha Reddy'), VersionData=Blob.valueOf(kavithaSlip.replace('{MONTH}','JANUARY').replace('{DATE}','31-Jan-2026'))));

// ===== ROHIT VERMA - Hyundai =====
String rohitSlip = 'HYUNDAI MOTOR INDIA LIMITED\nSALARY ADVICE - {MONTH} 2026\n' +
    'Employee: ROHIT VERMA | ID: HMIL-CHN-89012 | Sr. Production Engineer\n' +
    'PAN: JKLRV6789W | UAN: 100234567890\n' +
    '============================================================\n' +
    'EARNINGS:\n' +
    'Basic           : Rs 54,167   HRA: Rs 21,667\n' +
    'Special Allow   : Rs 13,000   Variable: Rs 16,250\n' +
    'GROSS           : Rs 1,05,084\n' +
    'DEDUCTIONS:\n' +
    'PF (12%)        : Rs 6,500   PT: Rs 200\n' +
    'TDS             : Rs 3,605\n' +
    'Total Deductions: Rs 10,305\n' +
    'NET PAY         : Rs 94,779\n' +
    'Month: {MONTH} | Credit: {DATE}';

cvs.add(new ContentVersion(Title='Salary Slip - Rohit Verma (March 2026)', PathOnClient='SalarySlip_Rohit_Verma_Mar2026.txt',
FirstPublishLocationId=accMap.get('Rohit Verma'), VersionData=Blob.valueOf(rohitSlip.replace('{MONTH}','MARCH').replace('{DATE}','31-Mar-2026'))));
cvs.add(new ContentVersion(Title='Salary Slip - Rohit Verma (February 2026)', PathOnClient='SalarySlip_Rohit_Verma_Feb2026.txt',
FirstPublishLocationId=accMap.get('Rohit Verma'), VersionData=Blob.valueOf(rohitSlip.replace('{MONTH}','FEBRUARY').replace('{DATE}','28-Feb-2026'))));
cvs.add(new ContentVersion(Title='Salary Slip - Rohit Verma (January 2026)', PathOnClient='SalarySlip_Rohit_Verma_Jan2026.txt',
FirstPublishLocationId=accMap.get('Rohit Verma'), VersionData=Blob.valueOf(rohitSlip.replace('{MONTH}','JANUARY').replace('{DATE}','31-Jan-2026'))));

insert cvs;
System.debug('Inserted ' + cvs.size() + ' Salary Slips (3 months x 6 employees = 18 records).');
