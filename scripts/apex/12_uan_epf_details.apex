// Step 12: UAN / EPF (Employee Provident Fund) Passbook Statements
// For all salaried employees + business owners with PF
// Document AI Template: UAN_EPF_STATEMENT
// Fields: UAN, Member ID, Employee Name, Employer, Opening Balance,
//         Employee Contribution, Employer Contribution, Closing Balance

Map<String, Id> accMap = new Map<String, Id>();
for (Account a : [SELECT Id, FirstName, LastName FROM Account WHERE IsPersonAccount = true
    AND LastName IN ('Sharma','Patel','Kumar','Devi','Singh','Nair','Gupta','Reddy','Verma')
    ORDER BY CreatedDate DESC]) {
    String key = a.FirstName + ' ' + a.LastName;
    if (!accMap.containsKey(key)) accMap.put(key, a.Id);
}

List<ContentVersion> cvs = new List<ContentVersion>{

// Priya Patel - TCS
new ContentVersion(Title='UAN/EPF Statement - Priya Patel (FY 2024-25)', PathOnClient='UAN_EPF_Priya_Patel_FY2425.txt',
FirstPublishLocationId=accMap.get('Priya Patel'),
VersionData=Blob.valueOf(
'EMPLOYEES PROVIDENT FUND ORGANISATION (EPFO)\n' +
'MINISTRY OF LABOUR & EMPLOYMENT - GOVT OF INDIA\n' +
'MEMBER PASSBOOK\n' +
'================================================================\n' +
'UAN (Universal Account Number)  : 100123456789\n' +
'Member ID                       : MHBAN00012345670000001\n' +
'Member Name                     : PRIYA PATEL\n' +
'Father / Husband Name           : SURESH PATEL\n' +
'Date of Birth                   : 22/03/1990\n' +
'Date of Joining EPF             : 01/08/2018\n' +
'Aadhaar Linked                  : YES (Verified)\n' +
'PAN Linked                      : YES\n' +
'Bank Account                    : AXIS BANK XXXXXXX7890\n' +
'================================================================\n' +
'ESTABLISHMENT DETAILS:\n' +
'Establishment Name              : TATA CONSULTANCY SERVICES LTD\n' +
'Establishment ID                : MHBAN000123456\n' +
'Regional Office                 : EPFO - Mumbai\n' +
'================================================================\n' +
'PASSBOOK STATEMENT (FY 2024-25)\n' +
'Opening Balance (01-Apr-2024)   : Rs 2,58,450.00\n' +
'================================================================\n' +
'Month    | Emp Contribution | Employer PF | Employer EPS | Total\n' +
'Apr-2024 |    6,000.00     |   6,000.00  |   1,250.00   | 13,250\n' +
'May-2024 |    6,000.00     |   6,000.00  |   1,250.00   | 13,250\n' +
'Jun-2024 |    6,000.00     |   6,000.00  |   1,250.00   | 13,250\n' +
'Jul-2024 |    6,000.00     |   6,000.00  |   1,250.00   | 13,250\n' +
'Aug-2024 |    6,000.00     |   6,000.00  |   1,250.00   | 13,250\n' +
'Sep-2024 |    6,000.00     |   6,000.00  |   1,250.00   | 13,250\n' +
'Oct-2024 |    6,000.00     |   6,000.00  |   1,250.00   | 13,250\n' +
'Nov-2024 |    6,000.00     |   6,000.00  |   1,250.00   | 13,250\n' +
'Dec-2024 |    6,000.00     |   6,000.00  |   1,250.00   | 13,250\n' +
'Jan-2025 |    6,000.00     |   6,000.00  |   1,250.00   | 13,250\n' +
'Feb-2025 |    6,000.00     |   6,000.00  |   1,250.00   | 13,250\n' +
'Mar-2025 |    6,000.00     |   6,000.00  |   1,250.00   | 13,250\n' +
'================================================================\n' +
'Interest Credited (8.25% p.a.)  : Rs 22,106.00\n' +
'Closing Balance (31-Mar-2025)   : Rs 4,18,556.00\n' +
'EPF Account Balance             : Rs 2,70,956.00\n' +
'EPS Account Balance             : Rs 1,47,600.00\n' +
'================================================================\n' +
'Total Contribution Since Joining : Rs 5,08,000\n' +
'Projected Corpus at Age 58      : Rs 42,50,000 (estimated)\n' +
'================================================================\n' +
'Withdraw/Transfer via EPFO Portal: www.epfindia.gov.in\n' +
'Grievance: epfigms.gov.in | Helpline: 1800-118-005'
)),

// Amit Kumar - Govt GPF (General Provident Fund - not EPFO but similar)
new ContentVersion(Title='GPF Statement - Amit Kumar (FY 2024-25)', PathOnClient='GPF_Amit_Kumar_FY2425.txt',
FirstPublishLocationId=accMap.get('Amit Kumar'),
VersionData=Blob.valueOf(
'ACCOUNTANT GENERAL (A&E), DELHI\n' +
'GENERAL PROVIDENT FUND STATEMENT\n' +
'(Government Employees - not EPFO)\n' +
'================================================================\n' +
'GPF Account Number              : DL/SOF/0034567\n' +
'Member Name                     : AMIT KUMAR\n' +
'Designation                     : Section Officer (Grade-B)\n' +
'Department                      : Revenue Department, GNCT Delhi\n' +
'Date of Joining Service         : 15/03/2007\n' +
'Date of Superannuation          : 30/11/2042\n' +
'================================================================\n' +
'GPF STATEMENT (FY 2024-25)\n' +
'Opening Balance (01-Apr-2024)   : Rs 12,45,000.00\n' +
'Subscriptions During Year       : Rs 54,000 (Rs 4,500 x 12)\n' +
'Employer Contribution           : N/A (Govt - NPS based)\n' +
'Interest Credited (7.1% p.a.)   : Rs 88,395\n' +
'Closing Balance (31-Mar-2025)   : Rs 13,87,395\n' +
'================================================================\n' +
'NPS ACCOUNT DETAILS:\n' +
'PRAN (Permanent Retirement A/c No): 110023456789\n' +
'Tier I Balance                  : Rs 8,45,000\n' +
'Employee Contribution (10%)     : Rs 67,500 (FY 2024-25)\n' +
'Government Contribution (14%)   : Rs 94,500 (FY 2024-25)\n' +
'================================================================\n' +
'Total Retirement Corpus (GPF+NPS): Rs 22,32,395\n' +
'Projected Corpus at Superannuation: Rs 1,85,00,000 (estimated)'
)),

// Vikram Singh - Infosys (UAN)
new ContentVersion(Title='UAN/EPF Statement - Vikram Singh (FY 2024-25)', PathOnClient='UAN_EPF_Vikram_Singh_FY2425.txt',
FirstPublishLocationId=accMap.get('Vikram Singh'),
VersionData=Blob.valueOf(
'EPFO MEMBER PASSBOOK\n' +
'UAN                             : 100789456123\n' +
'Member ID                       : KABNR000789456\n' +
'Member Name                     : VIKRAM SINGH\n' +
'Establishment                   : INFOSYS LIMITED (BNGI00897B)\n' +
'Regional Office                 : EPFO Pune\n' +
'Date of Joining EPF             : 01/08/2016\n' +
'================================================================\n' +
'PASSBOOK (FY 2024-25)\n' +
'Opening Balance (01-Apr-2024)   : Rs 5,24,800.00\n' +
'Employee Contributions (12%)    : Rs 90,000 (Rs 7,500 x 12)\n' +
'Employer PF Contributions       : Rs 90,000\n' +
'Employer EPS Contributions      : Rs 18,000\n' +
'Interest (8.25% p.a.)           : Rs 46,797\n' +
'Closing Balance (31-Mar-2025)   : Rs 7,69,597\n' +
'EPF Balance                     : Rs 5,12,397\n' +
'EPS Balance                     : Rs 2,57,200\n' +
'================================================================\n' +
'Total Contribution Since Joining: Rs 15,66,000\n' +
'Projected Corpus at 58          : Rs 68,00,000 (estimated)'
)),

// Meera Nair - Wipro (UAN)
new ContentVersion(Title='UAN/EPF Statement - Meera Nair (FY 2024-25)', PathOnClient='UAN_EPF_Meera_Nair_FY2425.txt',
FirstPublishLocationId=accMap.get('Meera Nair'),
VersionData=Blob.valueOf(
'EPFO MEMBER PASSBOOK\n' +
'UAN                             : 100567891234\n' +
'Member ID                       : KABNR000567891\n' +
'Member Name                     : MEERA NAIR\n' +
'Establishment                   : WIPRO LIMITED (BNGI12345W)\n' +
'Regional Office                 : EPFO Bengaluru\n' +
'Date of Joining EPF             : 01/07/2019\n' +
'================================================================\n' +
'PASSBOOK (FY 2024-25)\n' +
'Opening Balance (01-Apr-2024)   : Rs 3,12,000.00\n' +
'Employee Contributions (12%)    : Rs 1,08,000 (Rs 9,000 x 12)\n' +
'Employer PF Contributions       : Rs 1,08,000\n' +
'Employer EPS Contributions      : Rs 18,000\n' +
'Interest (8.25% p.a.)           : Rs 37,638\n' +
'Closing Balance (31-Mar-2025)   : Rs 5,83,638\n' +
'EPF Balance                     : Rs 3,83,638\n' +
'EPS Balance                     : Rs 2,00,000\n' +
'Projected Corpus at 58          : Rs 62,00,000 (estimated)'
)),

// Kavitha Reddy - Dr Reddys (UAN)
new ContentVersion(Title='UAN/EPF Statement - Kavitha Reddy (FY 2024-25)', PathOnClient='UAN_EPF_Kavitha_Reddy_FY2425.txt',
FirstPublishLocationId=accMap.get('Kavitha Reddy'),
VersionData=Blob.valueOf(
'EPFO MEMBER PASSBOOK\n' +
'UAN                             : 100345678901\n' +
'Member ID                       : APBWD000345678\n' +
'Member Name                     : KAVITHA REDDY\n' +
'Establishment                   : DR. REDDYS LABORATORIES (HYDД01234R)\n' +
'Regional Office                 : EPFO Hyderabad\n' +
'Date of Joining EPF             : 15/09/2017\n' +
'================================================================\n' +
'PASSBOOK (FY 2024-25)\n' +
'Opening Balance (01-Apr-2024)   : Rs 3,67,500.00\n' +
'Employee Contributions (12%)    : Rs 66,000 (Rs 5,500 x 12)\n' +
'Employer PF Contributions       : Rs 66,000\n' +
'Employer EPS Contributions      : Rs 18,000\n' +
'Interest (8.25% p.a.)           : Rs 32,569\n' +
'Closing Balance (31-Mar-2025)   : Rs 5,50,069\n' +
'EPF Balance                     : Rs 3,64,069\n' +
'EPS Balance                     : Rs 1,86,000\n' +
'Projected Corpus at 58          : Rs 48,00,000 (estimated)'
)),

// Rohit Verma - Hyundai (UAN)
new ContentVersion(Title='UAN/EPF Statement - Rohit Verma (FY 2024-25)', PathOnClient='UAN_EPF_Rohit_Verma_FY2425.txt',
FirstPublishLocationId=accMap.get('Rohit Verma'),
VersionData=Blob.valueOf(
'EPFO MEMBER PASSBOOK\n' +
'UAN                             : 100234567890\n' +
'Member ID                       : TNCHE000234567\n' +
'Member Name                     : ROHIT VERMA\n' +
'Establishment                   : HYUNDAI MOTOR INDIA LTD (CHET01234H)\n' +
'Regional Office                 : EPFO Chennai\n' +
'Date of Joining EPF             : 01/04/2014\n' +
'================================================================\n' +
'PASSBOOK (FY 2024-25)\n' +
'Opening Balance (01-Apr-2024)   : Rs 7,12,000.00\n' +
'Employee Contributions (12%)    : Rs 78,000 (Rs 6,500 x 12)\n' +
'Employer PF Contributions       : Rs 78,000\n' +
'Employer EPS Contributions      : Rs 18,000\n' +
'Interest (8.25% p.a.)           : Rs 63,690\n' +
'Closing Balance (31-Mar-2025)   : Rs 9,49,690\n' +
'EPF Balance                     : Rs 6,22,690\n' +
'EPS Balance                     : Rs 3,27,000\n' +
'Projected Corpus at 58          : Rs 78,00,000 (estimated)'
)),

// Rajesh Sharma - Self-employed (NPS voluntary)
new ContentVersion(Title='NPS Statement - Rajesh Sharma (FY 2024-25)', PathOnClient='NPS_Rajesh_Sharma_FY2425.txt',
FirstPublishLocationId=accMap.get('Rajesh Sharma'),
VersionData=Blob.valueOf(
'NATIONAL PENSION SYSTEM (NPS)\n' +
'PENSION FUND REGULATORY AND DEVELOPMENT AUTHORITY (PFRDA)\n' +
'SUBSCRIBER ACCOUNT STATEMENT\n' +
'================================================================\n' +
'PRAN (Permanent Retirement Account No): 110099887766\n' +
'Subscriber Name                 : RAJESH SHARMA\n' +
'Date of Birth                   : 15/06/1985\n' +
'Type                            : All Citizens Model (Voluntary)\n' +
'Pension Fund Manager            : SBI Pension Funds Pvt Ltd\n' +
'================================================================\n' +
'TIER I ACCOUNT (FY 2024-25):\n' +
'Opening Balance (01-Apr-2024)   : Rs 1,85,000\n' +
'Contributions During Year       : Rs 50,000\n' +
'Returns Generated               : Rs 14,625 (9.5% approx)\n' +
'Closing Balance (31-Mar-2025)   : Rs 2,49,625\n' +
'Total Invested Since Inception  : Rs 1,85,000\n' +
'Returns Since Inception         : Rs 64,625\n' +
'================================================================\n' +
'NOTE: Self-employed - No EPFO. NPS Tier I contributions\n' +
'eligible for Sec 80CCD(1B) deduction up to Rs 50,000'
)),

// Sunita Devi - Business owner (NPS voluntary)
new ContentVersion(Title='NPS Statement - Sunita Devi (FY 2024-25)', PathOnClient='NPS_Sunita_Devi_FY2425.txt',
FirstPublishLocationId=accMap.get('Sunita Devi'),
VersionData=Blob.valueOf(
'NATIONAL PENSION SYSTEM - SUBSCRIBER STATEMENT\n' +
'PRAN: 110077665544 | Name: SUNITA DEVI\n' +
'Type: All Citizens Model | PFM: LIC Pension Fund\n' +
'TIER I (FY 2024-25):\n' +
'Opening Balance: Rs 3,25,000 | Contributions: Rs 60,000\n' +
'Returns (10.2%): Rs 39,525 | Closing: Rs 4,24,525\n' +
'Self-employed business owner. No EPFO membership.'
)),

// Suresh Gupta - Business (NPS)
new ContentVersion(Title='NPS Statement - Suresh Gupta (FY 2024-25)', PathOnClient='NPS_Suresh_Gupta_FY2425.txt',
FirstPublishLocationId=accMap.get('Suresh Gupta'),
VersionData=Blob.valueOf(
'NATIONAL PENSION SYSTEM - SUBSCRIBER STATEMENT\n' +
'PRAN: 110055443322 | Name: SURESH GUPTA\n' +
'Type: All Citizens Model | PFM: HDFC Pension Fund\n' +
'TIER I (FY 2024-25):\n' +
'Opening Balance: Rs 8,50,000 | Contributions: Rs 1,50,000\n' +
'Returns (11.5%): Rs 1,14,250 | Closing: Rs 11,14,250\n' +
'Textile business owner. No EPFO. Active NPS investor.'
)),

// Anita Sharma - Self-employed (NPS)
new ContentVersion(Title='NPS Statement - Anita Sharma (FY 2024-25)', PathOnClient='NPS_Anita_Sharma_FY2425.txt',
FirstPublishLocationId=accMap.get('Anita Sharma'),
VersionData=Blob.valueOf(
'NATIONAL PENSION SYSTEM - SUBSCRIBER STATEMENT\n' +
'PRAN: 110033221100 | Name: ANITA SHARMA\n' +
'Type: All Citizens Model | PFM: Kotak Pension Fund\n' +
'TIER I (FY 2024-25):\n' +
'Opening Balance: Rs 1,20,000 | Contributions: Rs 50,000\n' +
'Returns (9.8%): Rs 16,660 | Closing: Rs 1,86,660\n' +
'Fashion designer - self-employed. Sec 80CCD(1B) benefit claimed.'
))

};

insert cvs;
System.debug('Inserted ' + cvs.size() + ' UAN/EPF/NPS statements (6 EPF/GPF + 4 NPS).');
