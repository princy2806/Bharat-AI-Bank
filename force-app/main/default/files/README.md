# Salesforce Agentforce – Banking Customer Verification & Self-Service
## Deployment Guide

---

## 📁 File Structure

```
sf-banking/
├── apex/
│   ├── BankingCustomerService.cls     ← Customer lookup (InvocableMethod)
│   ├── BankingOTPService.cls          ← OTP generation & validation
│   └── BankingAccountService.cls      ← Balance, transactions, card, loan
├── flows/
│   └── Banking_Customer_Verification_OTP.flow-meta.xml
└── agentforce/
    └── Banking_Agent_Topics_Actions.yaml
```

---

## 🗄️ Step 1 – Custom Object: BankCustomer__c

Create this custom object in Salesforce Setup:

| Field API Name           | Type          | Notes                        |
|--------------------------|---------------|------------------------------|
| CustomerID__c            | Text(20)      | Unique, External ID          |
| MobilePhone__c           | Phone         |                              |
| Email__c                 | Email         |                              |
| AccountBalance__c        | Currency(18,2)|                              |
| CardStatus__c            | Picklist      | Active, Blocked, Expired     |
| CardNumber__c            | Text(16)      | Store encrypted              |
| LoanBalance__c           | Currency(18,2)|                              |
| LoanEMIDate__c           | Date          |                              |
| IsVerified__c            | Checkbox      | Reset on session end         |
| LastOTP__c               | Text(64)      | SHA-256 hash only            |
| OTPExpiry__c             | DateTime      |                              |
| FailedOTPAttempts__c     | Number(2,0)   |                              |
| IsLocked__c              | Checkbox      |                              |

Also create: **BankTransaction__c** (child of BankCustomer__c)

| Field API Name      | Type          |
|---------------------|---------------|
| Customer__c         | Lookup(BankCustomer__c) |
| TransactionDate__c  | DateTime      |
| Description__c      | Text(255)     |
| TransactionType__c  | Picklist: Credit, Debit |
| Amount__c           | Currency(18,2)|

---

## ⚡ Step 2 – Platform Events

Create two platform events in Setup → Integrations → Platform Events:

1. **OTPSendEvent__e**
   - CustomerRecordId__c (Text)
   - OTPCode__c (Text)
   - ExpiryMinutes__c (Number)

2. **StatementRequestEvent__e**
   - CustomerRecordId__c (Text)

Wire these to your SMS/Email provider (Twilio, MuleSoft, etc.) via a
triggered Apex subscriber or MuleSoft flow.

---

## 🚀 Step 3 – Deploy Apex Classes

Option A – Salesforce CLI:
```bash
sf project deploy start --source-dir apex/ --target-org YourOrgAlias
```

Option B – Developer Console:
  File → New → Apex Class → paste each .cls file

---

## 🔄 Step 4 – Deploy Flow

Option A – Salesforce CLI:
```bash
sf project deploy start \
  --source-dir flows/Banking_Customer_Verification_OTP.flow-meta.xml \
  --target-org YourOrgAlias
```

Option B – Flow Builder:
  Setup → Flows → New Flow → Upload XML

---

## 🤖 Step 5 – Configure Agentforce Service Agent

1. Go to: Setup → Einstein → Agentforce → Agents → New Agent
2. Select agent type: **Service Agent**
3. Set System Prompt from the `instructions` section in the YAML
4. For each **Topic** in the YAML:
   - Click "Add Topic"
   - Fill in Label, Description, Scope, Instructions
   - Add the corresponding Actions
5. For each **Action**:
   - Type: Apex Action (for FlowAction types)
   - Select the matching InvocableMethod
   - Map inputs/outputs as defined in the YAML
6. For **Escalate_To_Human**:
   - Use built-in "Route Work" standard action
   - Set Queue: Banking_Support_Queue

---

## 🔐 Step 6 – Security & Permissions

```
Permission Set: Banking_Agent_PS
  - BankCustomer__c: Read, Edit
  - BankTransaction__c: Read
  - Apex Classes: BankingCustomerService, BankingOTPService, BankingAccountService
  - Flow: Banking_Customer_Verification_OTP (Run)
  - Platform Events: OTPSendEvent__e (Create), StatementRequestEvent__e (Create)
```

Assign this Permission Set to your Agent's Connected App / Service User.

---

## 🧪 Step 7 – Test in Agent Builder

1. Setup → Agentforce → Your Agent → Preview
2. Test conversation:
   - Input: `CUST001`  → Expect OTP prompt
   - Input: `[OTP]`   → Expect verified + menu
   - Input: `1`        → Expect balance
   - Input: `human`    → Expect escalation

---

## ✅ Verification Checklist

- [ ] BankCustomer__c and BankTransaction__c created
- [ ] Platform events OTPSendEvent__e and StatementRequestEvent__e created
- [ ] SMS/Email subscriber wired to OTPSendEvent__e
- [ ] All 3 Apex classes deployed with no errors
- [ ] Flow deployed and Active
- [ ] Agent Topics and Actions configured
- [ ] Permission Set assigned to Agent user
- [ ] End-to-end test passed in Agent Builder preview
