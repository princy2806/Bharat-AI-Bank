# Data Entry Guide for Excel Sheets

## 📋 Object Mapping for Data Entry

Based on your FSC org configuration, here's where to enter data from each Excel sheet:

---

## ✅ Sheet 01 - Account
**Enter data in:** `Account` (Standard Object)
- Use the standard Account object in your org
- Add the 5 custom fields we created:
  - Customer Since
  - Preferred Language
  - Churn Risk Score
  - Customer Segment
  - Relationship Manager

---

## ✅ Sheet 02 - FinancialAccount
**Enter data in:** `PartyFinancialAsset` (FSC Standard Object)

### Why PartyFinancialAsset?
Your FSC org uses **PartyFinancialAsset** instead of FinServ__FinancialAccount__c. This is the correct FSC object for storing financial account information like:
- Credit Cards
- Savings Accounts
- Loans
- Investments (Mutual Funds, SIPs)

### How to Access PartyFinancialAsset:
1. Go to **App Launcher** in your org
2. Search for **"Party Financial Assets"** or **"Financial Accounts"**
3. Click **New** to create records

### Fields to Populate:
**Standard FSC Fields (already exist):**
- Name
- Account (lookup to Account)
- Financial Account Type (Credit Card, Loan, Investment, etc.)
- Balance
- Status

**Custom Fields (we created):**
- Remaining Tenure (Months) - `RemainingTenureMonths__c`
- Monthly EMI - `MonthlyEMI__c`
- SIP Amount - `SIPAmount__c`
- Docs On File - `DocsOnFile__c`

### Example Data Mapping:
```
Excel Row → PartyFinancialAsset Record

Account Name: "Rahul Sharma" 
→ Account: Link to Account record

Financial Account Type: "Credit Card"
→ Financial Account Type: Credit Card

Balance: "45,000"
→ Balance: 45000

Monthly EMI: "5,000"
→ Monthly EMI: 5000

SIP Amount: "3,000"
→ SIP Amount: 3000

Remaining Tenure: "24"
→ Remaining Tenure (Months): 24

Docs On File: "Yes"
→ Docs On File: Checked
```

---

## ✅ Sheet 03 - FATransaction
**Enter data in:** `Credit_Card_Transaction__c` (Custom Object)

### How to Access:
1. Go to **App Launcher**
2. Search for **"Credit Card Transactions"**
3. Click **New** to create records

### Fields to Populate:
- Transaction Date - `Transaction_Date__c`
- Amount - `Amount__c`
- Merchant Name - `Merchant_Name__c`
- Merchant City - `Merchant_City__c` ✨ (new field)
- Merchant Category - `Merchant_Category__c` ✨ (new field)
- Transaction Type - `Transaction_Type__c`
- Status - `Status__c`
- Financial Account - `Financial_Account__c` (lookup)
- Is Disputed - `Is_Disputed__c` ✨ (new field)
- Dispute Flag - `Dispute_Flag__c` ✨ (new field)
- Running Balance - `Running_Balance__c` ✨ (new field)

---

## ✅ Sheet 04 - Case Dispute
**Enter data in:** `Case` (Standard Object)

### How to Access:
1. Go to **Service Console** or **Cases** tab
2. Click **New Case**
3. Set Record Type to dispute-related if you have one

### Fields to Populate:
**Standard Fields:**
- Case Number (auto-generated)
- Subject
- Status
- Priority
- Description

**Custom Fields (we created):**
- Dispute Amount - `DisputeAmount__c`
- Provisional Credit Issued - `ProvisionalCreditIssued__c`
- Provisional Credit Amount - `ProvisionalCreditAmount__c`
- Dispute Stage - `DisputeStage__c`
- Investigation Days - `InvestigationDays__c`

---

## ✅ Sheet 05 - ContentDocument
**Enter data in:** `ContentDocument` (Standard Object)

### How to Upload Files:
1. Go to the **Files** tab
2. Click **Upload Files**
3. After upload, add custom field values:

**Custom Fields (we created):**
- Doc Type - `DocType__c`
- Is Reusable - `IsReusable__c`
- Upload Date - `UploadDate__c`
- Expiry Date - `ExpiryDate__c`
- Verified By - `VerifiedBy__c`
- Verification Status - `VerificationStatus__c`

**Note:** You may need to use Data Loader or Apex to populate custom fields on ContentDocument, as the standard UI has limitations.

---

## ✅ Sheet 06 - Contact
**Enter data in:** `Contact` (Standard Object)

### How to Access:
1. Go to **Contacts** tab
2. Click **New Contact**

### Fields to Populate:
**Standard Fields:**
- First Name
- Last Name
- Email
- Phone
- Account (lookup)

**Custom Fields (we created):**
- Preferred Language - `PreferredLanguage__c`
- WhatsApp Opt In - `WhatsAppOptIn__c`
- OTP Verified - `OTPVerified__c`
- Relationship Manager - `RelationshipManager__c`
- RM Phone - `RMPhone__c`
- Customer Segment - `CustomerSegment__c`

---

## 🔄 Data Load Methods

### Option 1: Manual Entry (Small Dataset)
- Use the Salesforce UI to create records manually
- Good for testing and small datasets

### Option 2: Data Import Wizard (Medium Dataset)
1. Go to **Setup** → **Data Import Wizard**
2. Choose object (Accounts, Contacts, etc.)
3. Upload CSV file
4. Map fields
5. Import

### Option 3: Data Loader (Large Dataset)
1. Download **Salesforce Data Loader**
2. Login to your org
3. Choose **Insert** operation
4. Select object (Account, Contact, PartyFinancialAsset, etc.)
5. Map CSV columns to Salesforce fields
6. Run the import

---

## 📊 Summary: Excel Sheet → Salesforce Object

| Excel Sheet | Salesforce Object | Access Method |
|-------------|-------------------|---------------|
| Sheet 01 - Account | Account | Accounts tab |
| Sheet 02 - FinancialAccount | **PartyFinancialAsset** | App Launcher → Party Financial Assets |
| Sheet 03 - FATransaction | Credit_Card_Transaction__c | App Launcher → Credit Card Transactions |
| Sheet 04 - Case Dispute | Case | Cases tab |
| Sheet 05 - ContentDocument | ContentDocument | Files tab |
| Sheet 06 - Contact | Contact | Contacts tab |

---

## ⚠️ Important Notes

1. **PartyFinancialAsset** is the correct object for your financial account data
2. Deploy the custom fields first before entering data
3. Ensure parent records (Account, Contact) exist before creating related records
4. Use Data Loader for bulk imports (50+ records)
5. Test with a few records first before bulk loading

---

## 🎯 Recommended Data Entry Order

1. **Account** (parent records)
2. **Contact** (linked to Accounts)
3. **PartyFinancialAsset** (linked to Accounts)
4. **Credit_Card_Transaction__c** (linked to PartyFinancialAsset)
5. **Case** (linked to Accounts/Contacts)
6. **ContentDocument** (files)

This order ensures all lookup relationships work correctly!