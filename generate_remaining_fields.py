#!/usr/bin/env python3
"""
Script to generate remaining FSC custom fields from Excel data structure.
Run this to create all 29 remaining custom field XML files.

Usage: python generate_remaining_fields.py
"""

import os
from pathlib import Path

# Define all remaining fields to create
FIELDS = {
    "Account": [
        {
            "name": "RelationshipManager__c",
            "label": "Relationship Manager",
            "type": "Text",
            "length": 255,
            "description": "Name of the assigned Relationship Manager",
            "helpText": "Enter the name of the RM assigned to this customer"
        }
    ],
    "FinServ__FinancialAccount__c": [
        {
            "name": "RemainingTenureMonths__c",
            "label": "Remaining Tenure (Months)",
            "type": "Number",
            "precision": 4,
            "scale": 0,
            "description": "Remaining loan tenure in months",
            "helpText": "Number of months remaining until loan maturity"
        },
        {
            "name": "MonthlyEMI__c",
            "label": "Monthly EMI",
            "type": "Currency",
            "precision": 18,
            "scale": 2,
            "description": "Monthly EMI amount for loans",
            "helpText": "Enter the monthly EMI payment amount in INR"
        },
        {
            "name": "SIPAmount__c",
            "label": "SIP Amount",
            "type": "Currency",
            "precision": 18,
            "scale": 2,
            "description": "Monthly SIP investment amount for mutual funds",
            "helpText": "Enter the monthly SIP amount in INR"
        },
        {
            "name": "DocsOnFile__c",
            "label": "Docs On File",
            "type": "Checkbox",
            "defaultValue": "false",
            "description": "Indicates if KYC documents are on file",
            "helpText": "Check if all required KYC documents are verified and on file"
        }
    ],
    "FinServ__FinancialAccountTransaction__c": [
        {
            "name": "MerchantName__c",
            "label": "Merchant Name",
            "type": "Text",
            "length": 255,
            "description": "Name of merchant where transaction occurred",
            "helpText": "Enter merchant name as it appears on statement"
        },
        {
            "name": "MerchantCity__c",
            "label": "Merchant City",
            "type": "Text",
            "length": 100,
            "description": "City where merchant is located",
            "helpText": "Enter the city where the transaction occurred"
        },
        {
            "name": "MerchantCategory__c",
            "label": "Merchant Category",
            "type": "Picklist",
            "values": ["E-Commerce", "Food Delivery", "Fuel", "Grocery", "Medical", "Hotel & Lodging", "Transport", "Fashion", "Travel", "Entertainment", "Telecom", "Streaming", "Insurance", "Food & Beverage", "Electronics", "Education", "Refund"],
            "description": "Category of merchant business",
            "helpText": "Select the merchant category"
        },
        {
            "name": "IsDisputed__c",
            "label": "Is Disputed",
            "type": "Checkbox",
            "defaultValue": "false",
            "description": "Indicates if transaction is disputed",
            "helpText": "Check if customer has disputed this transaction"
        },
        {
            "name": "DisputeFlag__c",
            "label": "Dispute Flag",
            "type": "Picklist",
            "values": ["None", "Unauthorized", "Fraud", "Service Not Received", "Wrong Amount"],
            "description": "Type of dispute flagged",
            "helpText": "Select the dispute reason if transaction is disputed"
        },
        {
            "name": "RunningBalance__c",
            "label": "Running Balance",
            "type": "Currency",
            "precision": 18,
            "scale": 2,
            "description": "Running balance after this transaction",
            "helpText": "Balance after this transaction posts"
        }
    ],
    "Case": [
        {
            "name": "DisputeAmount__c",
            "label": "Dispute Amount",
            "type": "Currency",
            "precision": 18,
            "scale": 2,
            "description": "Amount being disputed by customer",
            "helpText": "Enter the disputed transaction amount in INR"
        },
        {
            "name": "ProvisionalCreditIssued__c",
            "label": "Provisional Credit Issued",
            "type": "Checkbox",
            "defaultValue": "false",
            "description": "Indicates if provisional credit issued",
            "helpText": "Check if provisional credit has been issued to customer"
        },
        {
            "name": "ProvisionalCreditAmount__c",
            "label": "Provisional Credit Amount",
            "type": "Currency",
            "precision": 18,
            "scale": 2,
            "description": "Amount of provisional credit issued",
            "helpText": "Enter provisional credit amount issued in INR"
        },
        {
            "name": "DisputeStage__c",
            "label": "Dispute Stage",
            "type": "Picklist",
            "values": ["Filed", "Evidence Review", "Bank Decision", "Resolved"],
            "description": "Current stage of dispute resolution",
            "helpText": "Select the current stage of the dispute investigation"
        },
        {
            "name": "InvestigationDays__c",
            "label": "Investigation Days",
            "type": "Number",
            "precision": 3,
            "scale": 0,
            "description": "Number of days since dispute filed",
            "helpText": "Days elapsed since dispute was filed"
        }
    ],
    "Contact": [
        {
            "name": "PreferredLanguage__c",
            "label": "Preferred Language",
            "type": "Picklist",
            "values": ["English", "Hindi", "Hinglish"],
            "description": "Customer's preferred communication language",
            "helpText": "Select customer's preferred language"
        },
        {
            "name": "WhatsAppOptIn__c",
            "label": "WhatsApp Opt-In",
            "type": "Checkbox",
            "defaultValue": "false",
            "description": "Customer opted in for WhatsApp communications",
            "helpText": "Check if customer has opted in for WhatsApp banking"
        },
        {
            "name": "OTPVerified__c",
            "label": "OTP Verified",
            "type": "Checkbox",
            "defaultValue": "false",
            "description": "Latest OTP verification status",
            "helpText": "Indicates if last OTP was successfully verified"
        },
        {
            "name": "RelationshipManager__c",
            "label": "Relationship Manager",
            "type": "Text",
            "length": 255,
            "description": "Name of assigned Relationship Manager",
            "helpText": "Enter the RM name assigned to this contact"
        },
        {
            "name": "RMPhone__c",
            "label": "RM Phone",
            "type": "Phone",
            "description": "Relationship Manager's phone number",
            "helpText": "Enter the RM's contact phone number"
        },
        {
            "name": "CustomerSegment__c",
            "label": "Customer Segment",
            "type": "Picklist",
            "values": ["Retail", "Mass Affluent", "Emerging Affluent", "HNI", "Super HNI"],
            "description": "Customer wealth segment",
            "helpText": "Select the customer's wealth segment"
        }
    ],
    "ContentDocument": [
        {
            "name": "DocType__c",
            "label": "Document Type",
            "type": "Picklist",
            "values": ["Aadhaar", "PAN", "Income Proof", "ITR", "Address Proof", "Bank Statement", "Salary Slip", "Form 16", "GST Certificate", "Business Registration"],
            "description": "Type of KYC document",
            "helpText": "Select the document type"
        },
        {
            "name": "IsReusable__c",
            "label": "Is Reusable",
            "type": "Checkbox",
            "defaultValue": "true",
            "description": "Indicates if document can be reused",
            "helpText": "Check if this document can be used for multiple accounts"
        },
        {
            "name": "UploadDate__c",
            "label": "Upload Date",
            "type": "Date",
            "description": "Date when document was uploaded",
            "helpText": "Date the document was uploaded to the system"
        },
        {
            "name": "ExpiryDate__c",
            "label": "Expiry Date",
            "type": "Date",
            "description": "Date when document expires",
            "helpText": "Enter the expiration date of the document"
        },
        {
            "name": "VerifiedBy__c",
            "label": "Verified By",
            "type": "Text",
            "length": 255,
            "description": "Person or system that verified document",
            "helpText": "Enter who verified this document (e.g., Branch name, Digital KYC)"
        },
        {
            "name": "VerificationStatus__c",
            "label": "Verification Status",
            "type": "Picklist",
            "values": ["Pending", "Verified", "Rejected"],
            "description": "Current verification status of document",
            "helpText": "Select the current verification status"
        }
    ]
}

def create_field_xml(object_name, field_config):
    """Generate XML content for a custom field."""
    xml = '<?xml version="1.0" encoding="UTF-8"?>\n'
    xml += '<CustomField xmlns="http://soap.sforce.com/2006/04/metadata">\n'
    xml += f'    <fullName>{field_config["name"]}</fullName>\n'
    xml += f'    <label>{field_config["label"]}</label>\n'
    xml += f'    <description>{field_config["description"]}</description>\n'
    xml += f'    <inlineHelpText>{field_config["helpText"]}</inlineHelpText>\n'
    xml += f'    <type>{field_config["type"]}</type>\n'
    
    # Add type-specific attributes
    if field_config["type"] == "Text":
        xml += f'    <length>{field_config["length"]}</length>\n'
    elif field_config["type"] in ["Number", "Currency"]:
        xml += f'    <precision>{field_config["precision"]}</precision>\n'
        xml += f'    <scale>{field_config["scale"]}</scale>\n'
    elif field_config["type"] == "Checkbox":
        xml += f'    <defaultValue>{field_config["defaultValue"]}</defaultValue>\n'
    elif field_config["type"] == "Picklist":
        xml += '    <required>false</required>\n'
        xml += '    <valueSet>\n'
        xml += '        <restricted>true</restricted>\n'
        xml += '        <valueSetDefinition>\n'
        xml += '            <sorted>false</sorted>\n'
        for idx, value in enumerate(field_config["values"]):
            xml += '            <value>\n'
            xml += f'                <fullName>{value}</fullName>\n'
            xml += f'                <default>{str(idx == 0).lower()}</default>\n'
            xml += f'                <label>{value}</label>\n'
            xml += '            </value>\n'
        xml += '        </valueSetDefinition>\n'
        xml += '    </valueSet>\n'
    
    if field_config["type"] not in ["Checkbox", "Picklist"]:
        xml += '    <required>false</required>\n'
    
    xml += '</CustomField>\n'
    return xml

def main():
    """Generate all field XML files."""
    base_path = Path("force-app/main/default/objects")
    created_count = 0
    
    for object_name, fields in FIELDS.items():
        object_path = base_path / object_name / "fields"
        object_path.mkdir(parents=True, exist_ok=True)
        
        for field_config in fields:
            field_file = object_path / f'{field_config["name"]}.field-meta.xml'
            xml_content = create_field_xml(object_name, field_config)
            
            with open(field_file, 'w', encoding='utf-8') as f:
                f.write(xml_content)
            
            print(f"✓ Created: {field_file}")
            created_count += 1
    
    print(f"\n✅ Successfully created {created_count} custom field files!")
    print("\nNext steps:")
    print("1. Review generated files in force-app/main/default/objects/")
    print("2. Update manifest/package.xml to include new fields")
    print("3. Deploy: sf project deploy start --manifest manifest/package.xml")

if __name__ == "__main__":
    main()