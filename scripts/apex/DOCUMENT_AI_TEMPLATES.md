# Document AI Template Reference Guide
## All Document Types for Einstein Document AI Configuration

---

## Document Types & Fields to Extract (for each AI Template)

### 1. AADHAAR_CARD
**Script**: `06_insert_content_versions.apex`
| Field to Extract | Type | Example Value |
|---|---|---|
| `name` | Text | RAJESH SHARMA |
| `date_of_birth` | Date | 15/06/1985 |
| `gender` | Text | MALE |
| `aadhaar_number` | Text | 4782 5631 9024 |
| `address` | Textarea | 45 MG Road Vijay Nagar Indore MP |
| `issue_date` | Date | 12/03/2016 |

---

### 2. PAN_CARD
**Script**: `06_insert_content_versions.apex`
| Field to Extract | Type | Example Value |
|---|---|---|
| `name` | Text | RAJESH SHARMA |
| `fathers_name` | Text | RAMESH SHARMA |
| `date_of_birth` | Date | 15/06/1985 |
| `pan_number` | Text | ABCRS1234P |

---

### 3. VOTER_ID_CARD (Election Card)
**Script**: `09_voter_id_cards.apex`
| Field to Extract | Type | Example Value |
|---|---|---|
| `epic_number` | Text | MPC/01/234/567890 |
| `name` | Text | RAJESH SHARMA |
| `date_of_birth` | Date | 15/06/1985 |
| `gender` | Text | MALE |
| `age` | Number | 40 |
| `state` | Text | Madhya Pradesh |
| `assembly_constituency` | Text | 229 - Indore-1 |
| `relation_name` | Text | RAMESH SHARMA |
| `address` | Textarea | 45 MG Road Vijay Nagar Indore |
| `issue_date` | Date | 20/08/2005 |

---

### 4. FORM_16 (TDS Certificate - Salary)
**Script**: `10_form16_and_itr.apex`
| Field to Extract | Type | Example Value |
|---|---|---|
| `assessment_year` | Text | 2025-26 |
| `certificate_number` | Text | TCSPU2025/F16/789012 |
| `employer_name` | Text | TATA CONSULTANCY SERVICES |
| `employer_tan` | Text | MUMТ01234C |
| `employee_name` | Text | PRIYA PATEL |
| `employee_pan` | Text | BCDPP5678Q |
| `gross_salary` | Currency | 11,55,000 |
| `standard_deduction` | Currency | 50,000 |
| `net_taxable_income` | Currency | 7,10,000 |
| `tds_deducted` | Currency | 76,000 |
| `refund_due` | Currency | 18,800 |

---

### 5. ITR_ACKNOWLEDGEMENT
**Script**: `10_form16_and_itr.apex` (for self-employed)
| Field to Extract | Type | Example Value |
|---|---|---|
| `acknowledgement_number` | Text | 234567891234567 |
| `assessment_year` | Text | 2025-26 |
| `taxpayer_name` | Text | RAJESH SHARMA |
| `pan` | Text | ABCRS1234P |
| `gross_total_income` | Currency | 3,51,000 |
| `net_taxable_income` | Currency | 2,26,000 |
| `tax_payable` | Currency | 0 |
| `refund_due` | Currency | 1,500 |
| `filing_date` | Date | 28/07/2025 |
| `verification_mode` | Text | Aadhaar OTP |

---

### 6. SALARY_SLIP
**Script**: `11_salary_slips.apex`
| Field to Extract | Type | Example Value |
|---|---|---|
| `employee_name` | Text | PRIYA PATEL |
| `employee_id` | Text | TCS-MH-78901 |
| `month_year` | Text | MARCH 2026 |
| `employer_name` | Text | TATA CONSULTANCY SERVICES |
| `basic_salary` | Currency | 50,000 |
| `hra` | Currency | 20,000 |
| `gross_earnings` | Currency | 1,05,000 |
| `pf_deduction` | Currency | 6,000 |
| `tds_deduction` | Currency | 6,633 |
| `total_deductions` | Currency | 12,833 |
| `net_pay` | Currency | 92,167 |
| `credit_date` | Date | 31-Mar-2026 |

---

### 7. UAN_EPF_STATEMENT
**Script**: `12_uan_epf_details.apex`
| Field to Extract | Type | Example Value |
|---|---|---|
| `uan` | Text | 100123456789 |
| `member_name` | Text | PRIYA PATEL |
| `establishment_name` | Text | TATA CONSULTANCY SERVICES |
| `date_of_joining` | Date | 01/08/2018 |
| `opening_balance` | Currency | 2,58,450 |
| `employee_contribution` | Currency | 72,000 |
| `employer_pf_contribution` | Currency | 72,000 |
| `interest_credited` | Currency | 22,106 |
| `closing_balance` | Currency | 4,18,556 |
| `epf_balance` | Currency | 2,70,956 |
| `eps_balance` | Currency | 1,47,600 |

---

### 8. FORM_26AS (Annual Tax Statement)
**Script**: `13_tds_form26as.apex`
| Field to Extract | Type | Example Value |
|---|---|---|
| `pan` | Text | BCDPP5678Q |
| `taxpayer_name` | Text | PRIYA PATEL |
| `assessment_year` | Text | 2025-26 |
| `employer_name` | Text | TATA CONSULTANCY SERVICES |
| `employer_tan` | Text | MUMТ01234C |
| `salary_paid` | Currency | 12,60,000 |
| `tds_on_salary` | Currency | 76,000 |
| `bank_tds` | Currency | 0 |
| `total_tds` | Currency | 76,000 |
| `refund_amount` | Currency | 18,800 |
| `refund_status` | Text | Credited |

---

### 9. FORM_12BB (Investment Declaration)
**Script**: `14_form12bb_investment.apex`
| Field to Extract | Type | Example Value |
|---|---|---|
| `employee_name` | Text | PRIYA PATEL |
| `employee_pan` | Text | BCDPP5678Q |
| `employer_name` | Text | TATA CONSULTANCY SERVICES |
| `hra_monthly_rent` | Currency | 22,000 |
| `landlord_pan` | Text | ABCPM1234X |
| `sec_80c_total` | Currency | 1,50,000 |
| `sec_80d_total` | Currency | 43,000 |
| `sec_24b_interest` | Currency | 0 |
| `nps_80ccd` | Currency | 50,000 |
| `total_deductions_declared` | Currency | 2,83,000 |
| `declaration_date` | Date | 15/04/2025 |

---

### 10. GST_REGISTRATION_CERTIFICATE
**Script**: `14_form12bb_investment.apex` (business owners)
| Field to Extract | Type | Example Value |
|---|---|---|
| `gstin` | Text | 23ABCRS1234P1Z5 |
| `legal_name` | Text | RAJESH SHARMA |
| `trade_name` | Text | RS ENTERPRISES |
| `business_type` | Text | Proprietorship |
| `registration_date` | Date | 15/07/2019 |
| `state` | Text | 23 - Madhya Pradesh |
| `annual_turnover` | Currency | 42,00,000 |

---

### 11. HOME_LOAN_EMI_SCHEDULE
**Script**: `15_emi_schedules.apex`
| Field to Extract | Type | Example Value |
|---|---|---|
| `loan_account_no` | Text | HL00123456789 |
| `borrower_name` | Text | RAJESH SHARMA |
| `original_loan_amount` | Currency | 40,00,000 |
| `interest_rate` | Percent | 8.65 |
| `emi_amount` | Currency | 18,450 |
| `outstanding_balance` | Currency | 32,50,000 |
| `emis_paid` | Number | 96 |
| `emis_remaining` | Number | 144 |
| `next_emi_date` | Date | 05-May-2026 |
| `nach_bank` | Text | HDFC Bank |

---

### 12. CREDIT_CARD_STATEMENT
**Script**: `15_emi_schedules.apex`
| Field to Extract | Type | Example Value |
|---|---|---|
| `card_number` | Text | XXXX XXXX XXXX 4891 |
| `card_holder` | Text | RAJESH SHARMA |
| `statement_date` | Date | 28-Mar-2026 |
| `payment_due_date` | Date | 18-Apr-2026 |
| `credit_limit` | Currency | 2,00,000 |
| `closing_balance` | Currency | 45,200 |
| `minimum_amount_due` | Currency | 4,520 |
| `total_amount_due` | Currency | 45,200 |
| `disputed_amount` | Currency | 12,500 |
| `dispute_merchant` | Text | GOA BEACH RESORT |

---

### 13. MUTUAL_FUND_STATEMENT (CAS)
**Script**: `16_mutual_fund_statements.apex`
| Field to Extract | Type | Example Value |
|---|---|---|
| `investor_name` | Text | RAJESH SHARMA |
| `pan` | Text | ABCRS1234P |
| `folio_number` | Text | AXIS/1234567/01 |
| `fund_name` | Text | AXIS BLUECHIP FUND |
| `total_invested` | Currency | 3,75,000 |
| `units_held` | Number | 1450.234 |
| `current_nav` | Currency | 196.55 |
| `current_value` | Currency | 2,85,048 |
| `xirr_return` | Percent | 14.2 |
| `sip_amount` | Currency | 5,000 |
| `sip_date` | Text | 10th of each month |
| `sip_status` | Text | ACTIVE |

---

### 14. BANK_STATEMENT
**Script**: `06_insert_content_versions.apex`
| Field to Extract | Type | Example Value |
|---|---|---|
| `account_holder` | Text | RAJESH SHARMA |
| `account_number` | Text | SB00123456789 |
| `ifsc_code` | Text | HDFC0001234 |
| `branch` | Text | Vijay Nagar Indore |
| `statement_period` | Text | Oct-2025 to Mar-2026 |
| `opening_balance` | Currency | 98,200 |
| `closing_balance` | Currency | 1,25,450.75 |
| `average_monthly_balance` | Currency | 1,15,000 |

---

### 15. HOME_LOAN_PROPERTY_DOC
**Script**: `17_home_loan_documents.apex`
| Field to Extract | Type | Example Value |
|---|---|---|
| `report_type` | Text | Property Valuation / Sale Deed / Disbursement |
| `borrower_name` | Text | RAJESH SHARMA |
| `borrower_pan` | Text | ABCRS1234P |
| `property_address` | Textarea | 45 MG Road Vijay Nagar Indore |
| `property_area_sqft` | Number | 1050 |
| `market_value` | Currency | 55,00,000 |
| `loan_amount` | Currency | 40,00,000 |
| `registration_number` | Text | 1234/2018 |
| `stamp_duty_paid` | Currency | 3,30,000 |

---

### 16. BANK_KYC_DOCUMENT
**Script**: `17_home_loan_documents.apex`
| Field to Extract | Type | Example Value |
|---|---|---|
| `account_holder` | Text | RAJESH SHARMA |
| `kyc_status` | Text | COMPLETED |
| `kyc_date` | Date | 15/03/2024 |
| `kyc_mode` | Text | Digital V-CIP |
| `aadhaar_verified` | Checkbox | YES |
| `pan_verified` | Checkbox | YES |
| `ckyc_number` | Text | 1234578901234 |
| `fatca_us_person` | Text | NO |

---

## Execution Order for New Scripts (After original 08)

```bash
sf apex run --file scripts/apex/09_voter_id_cards.apex --target-org <alias>
sf apex run --file scripts/apex/10_form16_and_itr.apex --target-org <alias>
sf apex run --file scripts/apex/11_salary_slips.apex --target-org <alias>
sf apex run --file scripts/apex/12_uan_epf_details.apex --target-org <alias>
sf apex run --file scripts/apex/13_tds_form26as.apex --target-org <alias>
sf apex run --file scripts/apex/14_form12bb_investment.apex --target-org <alias>
sf apex run --file scripts/apex/15_emi_schedules.apex --target-org <alias>
sf apex run --file scripts/apex/16_mutual_fund_statements.apex --target-org <alias>
sf apex run --file scripts/apex/17_home_loan_documents.apex --target-org <alias>
```

---

## Complete Document Count Per Person

| Person | Aadhaar | PAN | Voter ID | Bank Stmt | Form16/ITR | Salary Slip(3) | UAN/NPS | 26AS | 12BB/GST | EMI | CC Stmt | MF Stmt | Home Loan Docs | KYC | TOTAL |
|--------|---------|-----|----------|-----------|------------|----------------|---------|------|----------|-----|---------|---------|----------------|-----|-------|
| Rajesh Sharma | ✓ | ✓ | ✓ | ✓ | ✓(ITR) | - | ✓(NPS) | ✓ | ✓(GST) | ✓ | ✓ | ✓ | ✓(3) | ✓ | **16** |
| Priya Patel | ✓ | ✓ | ✓ | ✓ | ✓(F16) | ✓✓✓ | ✓(EPF) | ✓ | ✓(12BB) | - | ✓ | ✓ | - | ✓ | **15** |
| Amit Kumar | ✓ | ✓ | ✓ | ✓ | ✓(F16) | ✓✓✓ | ✓(GPF) | ✓ | ✓(12BB) | ✓ | ✓ | - | ✓(2) | ✓ | **15** |
| Sunita Devi | ✓ | ✓ | ✓ | ✓ | ✓(ITR) | - | ✓(NPS) | ✓ | ✓(GST) | - | ✓ | ✓ | - | ✓ | **12** |
| Vikram Singh | ✓ | ✓ | ✓ | ✓ | ✓(F16) | ✓✓✓ | ✓(EPF) | ✓ | ✓(12BB) | ✓ | ✓ | - | ✓(2) | ✓ | **15** |
| Meera Nair | ✓ | ✓ | ✓ | ✓ | ✓(F16) | ✓✓✓ | ✓(EPF) | ✓ | ✓(12BB) | - | ✓ | ✓ | - | ✓ | **15** |
| Suresh Gupta | ✓ | ✓ | ✓ | ✓ | ✓(ITR) | - | ✓(NPS) | ✓ | ✓(GST) | ✓ | ✓ | - | ✓(1) | ✓ | **13** |
| Kavitha Reddy | ✓ | ✓ | ✓ | ✓ | ✓(F16) | ✓✓✓ | ✓(EPF) | ✓ | ✓(12BB) | - | ✓ | ✓ | - | ✓ | **15** |
| Rohit Verma | ✓ | ✓ | ✓ | ✓ | ✓(F16) | ✓✓✓ | ✓(EPF) | ✓ | ✓(12BB) | ✓ | ✓ | - | ✓(1) | ✓ | **15** |
| Anita Sharma | ✓ | ✓ | ✓ | ✓ | ✓(ITR) | - | ✓(NPS) | ✓ | ✓(GST) | - | ✓ | ✓ | - | ✓ | **12** |
| **TOTAL** | **10** | **10** | **10** | **10** | **10** | **18** | **10** | **10** | **10** | **5** | **10** | **6** | **9** | **10** | **~143** |

---

## Document AI Flow for Agentforce

```
WhatsApp → Customer sends photo/document
    ↓
Agentforce receives (Messaging for WhatsApp)
    ↓
ContentVersion created (PathOnClient = filename)
    ↓
Einstein Document AI triggered (based on document type detected)
    ↓
Fields extracted → Mapped to FSC objects:
  - Aadhaar/PAN → Account.FinServ__IndividualIdentificationId
  - Bank Statement → FinServ__FinancialAccount__c.Balance
  - Credit Report → FinServ__CreditInformation__c.CreditScore
  - Salary Slip → Account.AnnualRevenue / FinServ__AnnualIncome
  - EMI Schedule → FinServ__FinancialAccount__c
    ↓
Agentforce confirms extraction to customer via WhatsApp
```
