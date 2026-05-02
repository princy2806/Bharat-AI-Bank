# Field Deployment Guide

## How to Deploy Custom Fields to Your Salesforce Org

### Progress: 14 of 32 fields created (44%)

### Objects Completed:
- ✅ Account (5/5 fields)
- ✅ FinServ__FinancialAccount__c (4/4 fields)
- ✅ FinServ__FinancialAccountTransaction__c (6/6 fields)

### Objects Remaining:
- ⏳ Case (5 fields)
- ⏳ Contact (6 fields)
- ⏳ ContentDocument (6 fields)

---

## Deployment Methods

### Method 1: Deploy All Fields at Once (Recommended)

Once all 32 field XML files are created, deploy them together:

```bash
# 1. Authenticate to your org (if not already)
sf org login web --alias myOrg

# 2. Set as default org
sf config set target-org myOrg

# 3. Deploy all metadata
sf project deploy start --source-dir force-app/main/default/objects

# Or deploy using manifest
sf project deploy start --manifest manifest/package.xml
```

### Method 2: Deploy Individual Objects

Deploy fields for one object at a time:

```bash
# Deploy Account fields only
sf project deploy start --source-dir force-app/main/default/objects/Account/fields

# Deploy Financial Account fields
sf project deploy start --source-dir force-app/main/default/objects/FinServ__FinancialAccount__c/fields

# Deploy Transaction fields
sf project deploy start --source-dir force-app/main/default/objects/FinServ__FinancialAccountTransaction__c/fields
```

### Method 3: Using VS Code (Easiest)

1. Right-click on any `force-app/main/default/objects` folder
2. Select "Deploy Source to Org"
3. Wait for deployment to complete

---

## After Deployment

### 1. Verify Fields Were Created

In Salesforce Setup:
- Go to **Setup → Object Manager**
- Select the object (e.g., Account)
- Click **Fields & Relationships**
- Verify your custom fields appear in the list

### 2. Add Fields to Page Layouts

For users to see these fields:
- Go to **Setup → Object Manager → [Object] → Page Layouts**
- Edit the page layout
- Drag custom fields from the palette onto the layout
- Save the layout

### 3. Import Data from Excel

Once fields are deployed, you can import your 50 records per object:

```bash
# Use Salesforce Data Loader or
sf data import tree --plan data-import-plan.json
```

---

## Troubleshooting

### Error: "Field already exists"
- Some FSC objects may have similar fields already
- Check existing fields before creating duplicates

### Error: "Invalid field type"
- Verify XML syntax is correct
- Check that field type matches Salesforce metadata types

### Error: "Insufficient access"
- Ensure you have System Administrator or equivalent permissions
- Check your org's field-level security settings

---

## Current Field Status

### Account (5 fields) ✅
- [x] CustomerSince__c
- [x] PreferredLanguage__c
- [x] ChurnRiskScore__c
- [x] CustomerSegment__c
- [x] RelationshipManager__c

### FinServ__FinancialAccount__c (4 fields) ✅
- [x] RemainingTenureMonths__c
- [x] MonthlyEMI__c
- [x] SIPAmount__c
- [x] DocsOnFile__c

### FinServ__FinancialAccountTransaction__c (6 fields) ✅
- [x] MerchantName__c
- [x] MerchantCity__c
- [x] MerchantCategory__c
- [x] IsDisputed__c
- [x] DisputeFlag__c
- [x] RunningBalance__c

### Case (5 fields) ⏳
- [ ] DisputeAmount__c
- [ ] ProvisionalCreditIssued__c
- [ ] ProvisionalCreditAmount__c
- [ ] DisputeStage__c
- [ ] InvestigationDays__c

### Contact (6 fields) ⏳
- [ ] PreferredLanguage__c
- [ ] WhatsAppOptIn__c
- [ ] OTPVerified__c
- [ ] RelationshipManager__c
- [ ] RMPhone__c
- [ ] CustomerSegment__c

### ContentDocument (6 fields) ⏳
- [ ] DocType__c
- [ ] IsReusable__c
- [ ] UploadDate__c
- [ ] ExpiryDate__c
- [ ] VerifiedBy__c
- [ ] VerificationStatus__c

---

## Next Steps

1. ✅ Continue creating remaining 18 fields
2. ⏳ Update manifest/package.xml with all new fields
3. ⏳ Deploy to your Salesforce org
4. ⏳ Import 50 records per object from Excel
5. ⏳ Continue with Phase 2: Build Agentforce Agent