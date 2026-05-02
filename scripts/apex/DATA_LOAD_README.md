# FSC Hackathon Data Load Guide
## Agentforce Self-Serve Robotic Customer Service Agent

---

## Prerequisites

- Salesforce org with **Financial Services Cloud (FSC)** installed
- **Person Accounts** enabled in the org
- **Einstein Document AI** license available
- **WhatsApp Messaging** configured
- Run all scripts via **Developer Console → Execute Anonymous** (or `sf apex run`)

---

## Execution Order

Run scripts in this exact order:

| # | Script | What it creates |
|---|--------|-----------------|
| 1 | `01_insert_person_accounts.apex` | 10 Indian banking person accounts |
| 2 | `02_insert_financial_accounts.apex` | Savings/Current bank accounts (FSC) |
| 3 | `03_insert_transactions.apex` | 5-7 recent transactions per account |
| 4 | `04_insert_credit_cards_and_loans.apex` | 10 credit cards + 5 home loans |
| 5 | `05_insert_credit_scores.apex` | CIBIL/credit reports per person |
| 6 | `06_insert_content_versions.apex` | Documents: Aadhaar, PAN, Bank Statement, Home Loan Letter, Credit Report |
| 7 | `07_setup_document_ai.apex` | Verification + Document AI checklist |
| 8 | `08_insert_mutual_funds.apex` | MF/SIP accounts for 6 customers |

---

## Person Accounts Created

| Name | City | Products | CIBIL Score |
|------|------|----------|-------------|
| **Rajesh Sharma** | Indore | Home Loan + CC + MF | 742 |
| Priya Patel | Mumbai | Savings + CC + SIP | 798 |
| Amit Kumar | Delhi | Home Loan + CC + FD | 761 |
| Sunita Devi | Jaipur | Current + CC + MF | 715 |
| Vikram Singh | Pune | Home Loan + CC | 778 |
| Meera Nair | Bangalore | Savings + CC + SIP | 812 |
| Suresh Gupta | Ahmedabad | Home Loan + CC + FD | 731 |
| Kavitha Reddy | Hyderabad | Savings + CC + SIP | 784 |
| Rohit Verma | Chennai | Home Loan + CC | 756 |
| Anita Sharma | Kolkata | Savings + CC + MF | 769 |

---

## Documents Created per Person (ContentVersion → Document AI)

| Document | Description | Document AI Fields |
|----------|-------------|-------------------|
| **Aadhaar Card** | UIDAI Aadhaar card text | Name, DOB, Gender, Address, Aadhaar Number |
| **PAN Card** | Income Tax PAN card | Name, Father's Name, DOB, PAN Number |
| **Bank Statement** | 6-month account statement | Account Holder, Account No, Transactions, Closing Balance |
| **Home Loan Letter** | Sanction + restructuring options | Borrower, Loan Amount, Rate, EMI, Outstanding, Options |
| **Credit Score Report** | CIBIL/Experian/CRIF report | Score, Payment History, Accounts, Disputes |

> Home Loan Letters created for: Rajesh Sharma, Amit Kumar, Vikram Singh, Suresh Gupta, Rohit Verma

---

## Enable Document AI (Manual Steps in Salesforce Setup)

### 1. Enable Einstein Document AI
```
Setup → Einstein → Document AI → Toggle ON
```

### 2. Create Document Types
```
Setup → Einstein → Document AI → Document Types → New
```

Create these document types:

**a) Aadhaar Card**
- Name: `Aadhaar_Card`
- Fields to Extract:
  - `full_name` (Text)
  - `date_of_birth` (Date)
  - `gender` (Text)
  - `aadhaar_number` (Text - 12 digits)
  - `address` (Textarea)

**b) PAN Card**
- Name: `PAN_Card`
- Fields to Extract:
  - `full_name` (Text)
  - `fathers_name` (Text)
  - `date_of_birth` (Date)
  - `pan_number` (Text - 10 chars)

**c) Bank Statement**
- Name: `Bank_Statement`
- Fields to Extract:
  - `account_holder` (Text)
  - `account_number` (Text)
  - `statement_period` (Text)
  - `closing_balance` (Currency)
  - `average_monthly_balance` (Currency)

**d) Home Loan Letter**
- Name: `Home_Loan_Letter`
- Fields to Extract:
  - `borrower_name` (Text)
  - `loan_amount` (Currency)
  - `interest_rate` (Percent)
  - `emi_amount` (Currency)
  - `outstanding_balance` (Currency)
  - `loan_account_number` (Text)

**e) Credit Report**
- Name: `Credit_Report`
- Fields to Extract:
  - `full_name` (Text)
  - `credit_score` (Number)
  - `score_agency` (Text)
  - `payment_history` (Text)
  - `total_outstanding` (Currency)

### 3. Map Document Types to Salesforce Fields
```
Setup → Einstein → Document AI → Field Mapping
```
- Map `aadhaar_number` → `Account.FinServ__IndividualIdentificationId__c`
- Map `pan_number` → Custom PAN field on Account
- Map `credit_score` → `FinServ__CreditInformation__c.FinServ__CreditScore__c`
- Map `closing_balance` → `FinServ__FinancialAccount__c.FinServ__Balance__c`

---

## Agentforce Configuration for Document AI

### WhatsApp Flow (Scenario 2 - Credit Card Dispute)
```
Customer sends hotel bill photo via WhatsApp
    ↓
Agentforce receives via Messaging for WhatsApp
    ↓
Einstein Document AI → Extract: Date, Amount, Merchant
    ↓
Match against FinServ__FinancialAccountTransaction__c
    ↓
Create Case with Category = 'Unauthorized Transaction'
    ↓
Issue provisional credit to credit card account
    ↓
Send confirmation in Hindi/English to customer
```

### Agentforce Topics to Configure
1. **Balance Inquiry** - Query FinServ__FinancialAccount__c.Balance
2. **Mini Statement** - Query FinServ__FinancialAccountTransaction__c (last 5)
3. **Credit Card Dispute** - Create Case + Document AI for receipts
4. **Loan Restructuring** - Query loan + present 3 options + OTP confirm
5. **Document Upload** - ContentVersion create + Einstein OCR trigger

---

## Run Scripts via SF CLI

```bash
# From Agentforce_Hackathon directory
sf apex run --file scripts/apex/01_insert_person_accounts.apex --target-org <your-org-alias>
sf apex run --file scripts/apex/02_insert_financial_accounts.apex --target-org <your-org-alias>
sf apex run --file scripts/apex/03_insert_transactions.apex --target-org <your-org-alias>
sf apex run --file scripts/apex/04_insert_credit_cards_and_loans.apex --target-org <your-org-alias>
sf apex run --file scripts/apex/05_insert_credit_scores.apex --target-org <your-org-alias>
sf apex run --file scripts/apex/06_insert_content_versions.apex --target-org <your-org-alias>
sf apex run --file scripts/apex/07_setup_document_ai.apex --target-org <your-org-alias>
sf apex run --file scripts/apex/08_insert_mutual_funds.apex --target-org <your-org-alias>
```

---

## Data Summary

| Object | Records |
|--------|---------|
| Account (Person) | 10 |
| FinServ__FinancialAccount__c (Bank) | 10 |
| FinServ__FinancialAccount__c (Credit Card) | 10 |
| FinServ__FinancialAccount__c (Home Loan) | 5 |
| FinServ__FinancialAccount__c (Mutual Fund) | 6 |
| FinServ__FinancialAccountTransaction__c | ~57 |
| FinServ__CreditInformation__c | 10 |
| ContentVersion (Documents) | ~45 |
| **Total Records** | **~153** |
