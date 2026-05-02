# Financial Services Cloud Object Alternatives

## Issue
The `FinServ__FinancialAccount__c` and `FinServ__FinancialAccountTransaction__c` objects are not available in your org.

## Common FSC Standard Objects

Financial Services Cloud typically provides these standard objects (depending on your FSC version):

### For Financial Account Information:
1. **Account** (Standard Salesforce object) - Can store customer banking relationships
2. **Asset** (Standard Salesforce object) - Often used for financial products like loans, accounts, investments
3. **FinServ__FinancialHolding__c** - Represents customer's financial holdings
4. **FinServ__Card__c** - For credit/debit card information
5. **FinServ__FinancialGoal__c** - Customer financial goals
6. **InsurancePolicy** (if you have Industry Insurance)

### For Transaction Information:
1. **FinServ__FinancialHoldingTransaction__c** - Transactions against holdings
2. **Custom Transaction Object** - You already created `Credit_Card_Transaction__c`
3. **Opportunity** - Can be adapted for financial transactions

## Recommended Approach

Since you already have a **Credit_Card_Transaction__c** custom object, I recommend:

### Option 1: Use Your Custom Objects (RECOMMENDED)
Your existing custom objects are perfect for the hackathon:
- ✅ **Account** (standard) - Customer information with our 5 custom fields
- ✅ **Credit_Card_Transaction__c** (custom) - For transactions (already has fields)
- ✅ **Dispute_Case__c** (custom) - For disputes
- ✅ **Loan_Restructure_Request__c** (custom) - For loan products
- ✅ **Case** (standard) - With our 5 custom dispute fields
- ✅ **Contact** (standard) - With our 6 custom fields
- ✅ **ContentDocument** (standard) - With our 6 custom fields

### Option 2: Use Asset Object
If you need to track financial accounts (loans, credit cards, investments), use the standard **Asset** object:

**Move the 4 FinancialAccount fields to Asset:**
- RemainingTenureMonths__c
- MonthlyEMI__c
- SIPAmount__c
- DocsOnFile__c

**Move the 6 Transaction fields to your Credit_Card_Transaction__c** (which you already have):
- MerchantName__c ✅ (already exists)
- MerchantCity__c
- MerchantCategory__c
- IsDisputed__c
- DisputeFlag__c
- RunningBalance__c

## Next Steps

**OPTION A: Delete FSC Fields and Use Custom Objects Only**
```bash
# Remove the FSC object directories
rm -rf force-app/main/default/objects/FinServ__FinancialAccount__c
rm -rf force-app/main/default/objects/FinServ__FinancialAccountTransaction__c
```

**OPTION B: Move Fields to Asset Object**
I can recreate those 4 fields on the **Asset** object instead.

**OPTION C: Check What's Actually in Your Org**
Run this command to see all FSC objects:
```bash
sf sobject list --sobject-type-category custom --target-org YOUR_ORG_ALIAS | grep -i "finserv\|financial\|asset"
```

## What Should We Do?

Please let me know:
1. Should I delete the FinServ__FinancialAccount__c and FinServ__FinancialAccountTransaction__c folders?
2. Should I recreate those fields on the **Asset** object?
3. Or should we just use your existing **Credit_Card_Transaction__c** object (which already has most transaction fields)?

For the hackathon, **Option A** (using your existing custom objects) is the cleanest and fastest approach!