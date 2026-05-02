/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-19-2026
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
// Step 9: Voter / Election ID Cards for all 10 Person Accounts
// Document AI Template: VOTER_ID
// Fields to extract: Name, DOB, Gender, Constituency, EPIC Number, Address

Map<String, Id> accMap = new Map<String, Id>();
for (Account a : [SELECT Id, FirstName, LastName FROM Account WHERE IsPersonAccount = true
    AND LastName IN ('Sharma','Patel','Kumar','Devi','Singh','Nair','Gupta','Reddy','Verma')
    ORDER BY CreatedDate DESC]) {
    String key = a.FirstName + ' ' + a.LastName;
    if (!accMap.containsKey(key)) accMap.put(key, a.Id);
}

List<ContentVersion> cvs = new List<ContentVersion>{

new ContentVersion(Title='Voter ID Card - Rajesh Sharma', PathOnClient='VoterID_Rajesh_Sharma.txt',
FirstPublishLocationId = accMap.get('Rajesh Sharma'),
VersionData = Blob.valueOf(
    'ELECTION COMMISSION OF INDIA\n' +
    'ELECTORS PHOTO IDENTITY CARD (EPIC)\n' +
    '============================================\n' +
    'EPIC Number    : MPC/01/234/567890\n' +
    'State          : Madhya Pradesh\n' +
    'District       : Indore\n' +
    'Assembly       : 229 - Indore-1\n' +
    'Part No        : 145 | Serial No: 321\n' +
    '============================================\n' +
    'Name           : RAJESH SHARMA\n' +
    'Relation       : S/O RAMESH SHARMA\n' +
    'Date of Birth  : 15/06/1985\n' +
    'Age            : 40 Years\n' +
    'Gender         : MALE\n' +
    '============================================\n' +
    'Residential Address:\n' +
    '45, MG Road, Vijay Nagar,\n' +
    'Indore, Madhya Pradesh - 452001\n' +
    '============================================\n' +
    'Issue Date     : 20/08/2005\n' +
    'Issuing Officer: District Election Officer, Indore\n' +
    'This card is the property of Election Commission of India.'
)),

new ContentVersion(Title='Voter ID Card - Priya Patel', PathOnClient='VoterID_Priya_Patel.txt',
FirstPublishLocationId = accMap.get('Priya Patel'),
VersionData = Blob.valueOf(
    'ELECTION COMMISSION OF INDIA\n' +
    'ELECTORS PHOTO IDENTITY CARD (EPIC)\n' +
    '============================================\n' +
    'EPIC Number    : MHC/14/678/123456\n' +
    'State          : Maharashtra\n' +
    'District       : Mumbai Suburban\n' +
    'Assembly       : 173 - Bandra West\n' +
    'Part No        : 089 | Serial No: 456\n' +
    '============================================\n' +
    'Name           : PRIYA PATEL\n' +
    'Relation       : D/O SURESH PATEL\n' +
    'Date of Birth  : 22/03/1990\n' +
    'Age            : 36 Years\n' +
    'Gender         : FEMALE\n' +
    '============================================\n' +
    'Residential Address:\n' +
    '12, Linking Road, Bandra West,\n' +
    'Mumbai, Maharashtra - 400050\n' +
    '============================================\n' +
    'Issue Date     : 15/04/2011\n' +
    'Issuing Officer: District Election Officer, Mumbai'
)),

new ContentVersion(Title='Voter ID Card - Amit Patel', PathOnClient='VoterID_Amit_Patel.txt',
FirstPublishLocationId = accMap.get('Amit Patel'),
VersionData = Blob.valueOf(
    'ELECTION COMMISSION OF INDIA\n' +
    'ELECTORS PHOTO IDENTITY CARD (EPIC)\n' +
    '============================================\n' +
    'EPIC Number    : DLC/04/112/789012\n' +
    'State          : Delhi\n' +
    'District       : South Delhi\n' +
    'Assembly       : 048 - Greater Kailash\n' +
    'Part No        : 203 | Serial No: 178\n' +
    '============================================\n' +
    'Name           : AMIT KUMAR\n' +
    'Relation       : S/O SURESH KUMAR\n' +
    'Date of Birth  : 08/11/1982\n' +
    'Age            : 43 Years\n' +
    'Gender         : MALE\n' +
    '============================================\n' +
    'Residential Address:\n' +
    '78, Lajpat Nagar III, South Delhi - 110024\n' +
    '============================================\n' +
    'Issue Date     : 10/01/2003\n' +
    'Issuing Officer: District Election Officer, South Delhi'
)),

new ContentVersion(Title='Voter ID Card - Sunita Devi', PathOnClient='VoterID_Sunita_Devi.txt',
FirstPublishLocationId = accMap.get('Sunita Devi'),
VersionData = Blob.valueOf(
    'ELECTION COMMISSION OF INDIA\n' +
    'ELECTORS PHOTO IDENTITY CARD (EPIC)\n' +
    '============================================\n' +
    'EPIC Number    : RJC/20/345/234567\n' +
    'State          : Rajasthan\n' +
    'District       : Jaipur\n' +
    'Assembly       : 061 - Sodala\n' +
    'Part No        : 127 | Serial No: 089\n' +
    '============================================\n' +
    'Name           : SUNITA DEVI\n' +
    'Relation       : W/O RAKESH AGARWAL\n' +
    'Date of Birth  : 30/07/1978\n' +
    'Age            : 47 Years\n' +
    'Gender         : FEMALE\n' +
    '============================================\n' +
    'Residential Address:\n' +
    '23, C-Scheme, Jaipur, Rajasthan - 302001\n' +
    '============================================\n' +
    'Issue Date     : 05/09/1999\n' +
    'Issuing Officer: District Election Officer, Jaipur'
)),

new ContentVersion(Title='Voter ID Card - Vikram Singh', PathOnClient='VoterID_Vikram_Singh.txt',
FirstPublishLocationId = accMap.get('Vikram Singh'),
VersionData = Blob.valueOf(
    'ELECTION COMMISSION OF INDIA\n' +
    'ELECTORS PHOTO IDENTITY CARD (EPIC)\n' +
    '============================================\n' +
    'EPIC Number    : MHC/25/890/345678\n' +
    'State          : Maharashtra\n' +
    'District       : Pune\n' +
    'Assembly       : 214 - Shivajinagar\n' +
    'Part No        : 056 | Serial No: 234\n' +
    '============================================\n' +
    'Name           : VIKRAM SINGH\n' +
    'Relation       : S/O BALVIR SINGH\n' +
    'Date of Birth  : 12/04/1988\n' +
    'Age            : 38 Years\n' +
    'Gender         : MALE\n' +
    '============================================\n' +
    'Residential Address:\n' +
    '55, Koregaon Park, Pune, Maharashtra - 411001\n' +
    '============================================\n' +
    'Issue Date     : 18/06/2009\n' +
    'Issuing Officer: District Election Officer, Pune'
)),

new ContentVersion(Title='Voter ID Card - Meera Nair', PathOnClient='VoterID_Meera_Nair.txt',
FirstPublishLocationId = accMap.get('Meera Nair'),
VersionData = Blob.valueOf(
    'ELECTION COMMISSION OF INDIA\n' +
    'ELECTORS PHOTO IDENTITY CARD (EPIC)\n' +
    '============================================\n' +
    'EPIC Number    : KAC/19/456/456789\n' +
    'State          : Karnataka\n' +
    'District       : Bengaluru Urban\n' +
    'Assembly       : 149 - Indiranagar\n' +
    'Part No        : 078 | Serial No: 512\n' +
    '============================================\n' +
    'Name           : MEERA NAIR\n' +
    'Relation       : D/O KRISHNA NAIR\n' +
    'Date of Birth  : 05/09/1993\n' +
    'Age            : 32 Years\n' +
    'Gender         : FEMALE\n' +
    '============================================\n' +
    'Residential Address:\n' +
    '34, Indiranagar 100 Feet Road, Bengaluru - 560038\n' +
    '============================================\n' +
    'Issue Date     : 22/11/2014\n' +
    'Issuing Officer: District Election Officer, Bengaluru'
)),

new ContentVersion(Title='Voter ID Card - Suresh Gupta', PathOnClient='VoterID_Suresh_Gupta.txt',
FirstPublishLocationId = accMap.get('Suresh Gupta'),
VersionData = Blob.valueOf(
    'ELECTION COMMISSION OF INDIA\n' +
    'ELECTORS PHOTO IDENTITY CARD (EPIC)\n' +
    '============================================\n' +
    'EPIC Number    : GJC/07/789/567890\n' +
    'State          : Gujarat\n' +
    'District       : Ahmedabad\n' +
    'Assembly       : 065 - Navrangpura\n' +
    'Part No        : 112 | Serial No: 067\n' +
    '============================================\n' +
    'Name           : SURESH GUPTA\n' +
    'Relation       : S/O RAMESH GUPTA\n' +
    'Date of Birth  : 18/01/1975\n' +
    'Age            : 51 Years\n' +
    'Gender         : MALE\n' +
    '============================================\n' +
    'Residential Address:\n' +
    '89, CG Road, Navrangpura, Ahmedabad - 380009\n' +
    '============================================\n' +
    'Issue Date     : 30/04/1996\n' +
    'Issuing Officer: District Election Officer, Ahmedabad'
)),

new ContentVersion(Title='Voter ID Card - Kavitha Reddy', PathOnClient='VoterID_Kavitha_Reddy.txt',
FirstPublishLocationId = accMap.get('Kavitha Reddy'),
VersionData = Blob.valueOf(
    'ELECTION COMMISSION OF INDIA\n' +
    'ELECTORS PHOTO IDENTITY CARD (EPIC)\n' +
    '============================================\n' +
    'EPIC Number    : TLC/22/123/678901\n' +
    'State          : Telangana\n' +
    'District       : Hyderabad\n' +
    'Assembly       : 093 - Jubilee Hills\n' +
    'Part No        : 167 | Serial No: 398\n' +
    '============================================\n' +
    'Name           : KAVITHA REDDY\n' +
    'Relation       : D/O VENKATESH REDDY\n' +
    'Date of Birth  : 25/12/1991\n' +
    'Age            : 34 Years\n' +
    'Gender         : FEMALE\n' +
    '============================================\n' +
    'Residential Address:\n' +
    '67, Jubilee Hills Road No 36, Hyderabad - 500033\n' +
    '============================================\n' +
    'Issue Date     : 14/03/2013\n' +
    'Issuing Officer: District Election Officer, Hyderabad'
)),

new ContentVersion(Title='Voter ID Card - Rohit Verma', PathOnClient='VoterID_Rohit_Verma.txt',
FirstPublishLocationId = accMap.get('Rohit Verma'),
VersionData = Blob.valueOf(
    'ELECTION COMMISSION OF INDIA\n' +
    'ELECTORS PHOTO IDENTITY CARD (EPIC)\n' +
    '============================================\n' +
    'EPIC Number    : TNC/32/567/789012\n' +
    'State          : Tamil Nadu\n' +
    'District       : Chennai\n' +
    'Assembly       : 038 - Anna Nagar West\n' +
    'Part No        : 094 | Serial No: 287\n' +
    '============================================\n' +
    'Name           : ROHIT VERMA\n' +
    'Relation       : S/O ANIL VERMA\n' +
    'Date of Birth  : 20/08/1986\n' +
    'Age            : 39 Years\n' +
    'Gender         : MALE\n' +
    '============================================\n' +
    'Residential Address:\n' +
    '14, Anna Nagar 2nd Avenue, Chennai - 600040\n' +
    '============================================\n' +
    'Issue Date     : 12/09/2007\n' +
    'Issuing Officer: District Election Officer, Chennai'
)),

new ContentVersion(Title='Voter ID Card - Anita Sharma', PathOnClient='VoterID_Anita_Sharma.txt',
FirstPublishLocationId = accMap.get('Anita Sharma'),
VersionData = Blob.valueOf(
    'ELECTION COMMISSION OF INDIA\n' +
    'ELECTORS PHOTO IDENTITY CARD (EPIC)\n' +
    '============================================\n' +
    'EPIC Number    : WBC/08/901/890123\n' +
    'State          : West Bengal\n' +
    'District       : Kolkata\n' +
    'Assembly       : 025 - Rashbehari\n' +
    'Part No        : 043 | Serial No: 156\n' +
    '============================================\n' +
    'Name           : ANITA SHARMA\n' +
    'Relation       : D/O MOHAN SHARMA\n' +
    'Date of Birth  : 14/05/1980\n' +
    'Age            : 45 Years\n' +
    'Gender         : FEMALE\n' +
    '============================================\n' +
    'Residential Address:\n' +
    '29, Park Street, Kolkata, West Bengal - 700016\n' +
    '============================================\n' +
    'Issue Date     : 28/06/2001\n' +
    'Issuing Officer: District Election Officer, Kolkata'
))

}; // end of list

insert cvs;
System.debug('Inserted ' + cvs.size() + ' Voter ID cards.');
