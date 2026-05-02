# PDF Document Scripts - Execution Guide

## Overview
These scripts insert PDF-format documents for ALL person accounts in your Salesforce org.
Each script creates real PDF binary files (not text) that Einstein Document AI can process.

## Execution Method

### Option A: Developer Console (Recommended for small scripts)
1. In Salesforce, go to **Setup > Developer Console**
2. Click **Debug > Open Execute Anonymous Window** (Ctrl+E)
3. Paste the entire script content
4. Click **Execute**
5. Check the **Logs** tab for success message

### Option B: SF CLI (Recommended for large scripts, avoids HTTP 431 error)
```bash
sf apex run --file scripts/apex/documents/C01_aadhaar_cards.apex --target-org <your-org-alias>
```

### Option C: VS Code Salesforce Extension
1. Open the .apex file in VS Code
2. Right-click > **SFDX: Execute Anonymous Apex with Editor Contents**

---

## Scripts - Execution Order

| Script | Document Type | For All 50 Accounts |
|--------|--------------|---------------------|
| C01_aadhaar_cards.apex | Aadhaar Card | Yes |
| C02_pan_cards.apex | PAN Card | Yes |
| C03_voter_ids.apex | Voter ID / EPIC Card | Yes |
| C04_birth_certificates.apex | Birth Certificate | Yes |
| C05_passports.apex | Passport | Yes |
| C06_bank_account_details.apex | Bank Account / Passbook | Yes |
| C07_cibil_scores.apex | CIBIL Credit Score Report | Yes |
| C08_credit_card_statements.apex | Credit Card Statement (Mar 2026) | Yes |
| C09_loan_details.apex | Loan Account Statement | Yes |
| C10_loan_agreements.apex | Loan Agreement | Yes |
| C11_form16_itr.apex | Form 16 (TDS Certificate FY2025-26) | Yes |
| C12_form12bb.apex | Form 12BB (Investment Declaration) | Yes |
| C13_salary_slips_march.apex | Salary Slip - March 2026 | Yes |
| C14_salary_slips_feb.apex | Salary Slip - February 2026 | Yes |
| C15_salary_slips_jan.apex | Salary Slip - January 2026 | Yes |
| C16_pf_details.apex | PF / EPF Statement FY2025-26 | Yes |
| C17_uan_details.apex | UAN Details / Employment History | Yes |
| C18_home_loan_agreements.apex | Home Loan Agreement | Yes |
| C19_personal_loan_agreements.apex | Personal Loan Agreement | Yes |
| C20_business_loan_agreements.apex | Business Loan Agreement | Yes |
| C21_mutual_fund_statements.apex | Mutual Fund CAS Statement (Mar 2026) | Yes |
| C22_property_valuation_reports.apex | Property Valuation Report | Yes |

**Total: 22 scripts × ~50 accounts = ~1,100 PDF documents**

---

## What Each Script Does
- Queries ALL IsPersonAccount=true accounts dynamically (no hardcoded IDs)
- Generates realistic Indian financial document data per person
- Creates a valid PDF binary (PDF 1.4 spec) using Apex string builder
- Inserts ContentVersion with `.pdf` extension, linked to the Account
- Batches inserts in groups of 25 to respect governor limits

## Troubleshooting

### HTTP ERROR 431
Script is too large for Developer Console. Use SF CLI instead:
```bash
sf apex run --file <script-path> --target-org <alias>
```

### "Variable does not exist: U"
The class definition might have been split. Ensure the full script is pasted at once.

### INVALID_CROSS_REFERENCE_KEY
Account ID in FirstPublishLocationId is invalid. Run after person accounts are inserted.

### Heap Limit Exceeded
Run fewer accounts at a time by adding `LIMIT 25` to the SOQL query, then remove and re-run.

---

## Document AI Setup
After inserting all documents, configure Einstein Document AI:
- Go to **Setup > Einstein Document AI**
- Create templates: AADHAAR_CARD, PAN_CARD, VOTER_ID, SALARY_SLIP, FORM_16, etc.
- Map extracted fields to Salesforce fields on the Account/FinancialAccount objects
- Enable on the Account page layout to surface extracted data via Agentforce

---

## Verifying Documents Were Inserted
Run this in Execute Anonymous to verify:
```apex
List<ContentVersion> cvs = [SELECT Title, PathOnClient FROM ContentVersion 
    WHERE PathOnClient LIKE '%.pdf' ORDER BY CreatedDate DESC LIMIT 50];
System.debug('PDF docs: ' + cvs.size());
for(ContentVersion cv : cvs) System.debug(cv.Title + ' | ' + cv.PathOnClient);
```
