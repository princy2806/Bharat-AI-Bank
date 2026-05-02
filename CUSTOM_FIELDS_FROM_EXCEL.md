# Custom Fields Required from FSC_50_Records_All_Objects.xlsx

## Status: Creating fields based on Excel sheet columns

### Account Object (5 fields)
- [x] CustomerSince__c (Date)
- [x] PreferredLanguage__c (Picklist: English/Hindi/Hinglish)
- [x] ChurnRiskScore__c (Number)
- [ ] CustomerSegment__c (Picklist: Mass Affluent/HNI/Super HNI/Retail/Emerging Affluent)
- [ ] RelationshipManager__c (Text)

### FinServ__FinancialAccount__c (4 fields)
- [ ] RemainingTenureMonths__c (Number)
- [ ] MonthlyEMI__c (Currency)
- [ ] SIPAmount__c (Currency)
- [ ] DocsOnFile__c (Checkbox)

### FinServ__FinancialAccountTransaction__c (6 fields)
- [ ] MerchantName__c (Text)
- [ ] MerchantCity__c (Text)
- [ ] MerchantCategory__c (Picklist)
- [ ] IsDisputed__c (Checkbox)
- [ ] DisputeFlag__c (Picklist: None/Unauthorized/Fraud)
- [ ] RunningBalance__c (Currency)

### Case Object (5 fields)
- [ ] DisputeAmount__c (Currency) 
- [ ] ProvisionalCreditIssued__c (Checkbox)
- [ ] ProvisionalCreditAmount__c (Currency)
- [ ] DisputeStage__c (Picklist: Filed/Evidence Review/Bank Decision/Resolved)
- [ ] InvestigationDays__c (Number)

### Contact Object (6 fields)
- [ ] PreferredLanguage__c (Picklist: English/Hindi/Hinglish)
- [ ] WhatsAppOptIn__c (Checkbox)
- [ ] OTPVerified__c (Checkbox)
- [ ] RelationshipManager__c (Text)
- [ ] RMPhone__c (Phone)
- [ ] CustomerSegment__c (Picklist)

### ContentDocument Object (6 fields)
- [ ] DocType__c (Picklist: Aadhaar/PAN/Income Proof/ITR/etc)
- [ ] IsReusable__c (Checkbox)
- [ ] UploadDate__c (Date)
- [ ] ExpiryDate__c (Date)
- [ ] VerifiedBy__c (Text)
- [ ] VerificationStatus__c (Picklist: Verified/Pending)

## Total: 32 custom fields across 6 standard FSC objects