// Copyright (c) 2021, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

# Netsuite Classification type record
#
# + name - Name of the classification  
# + includeChildren - Checks for child classifications  
# + parent - References parent classifications 
# + internalId - Internal ID
public type Classification record {
    @display{label: "Internal ID"}
    string internalId;
    @display{label: "Classification Name"}
    string name?;
    @display{label: "Parent Classification"}
    RecordRef parent?;
    @display{label: "Is Include Children"}
    boolean includeChildren?;
    *ClassificationCommon;
};

# Netsuite Classification type record
#
# + name - Name of the classification   
# + parent - References parent classifications 
@display{label: "Classification"} 
public type NewClassification record {
    @display{label: "Classification Name"}
    string name;
    @display{label: "Parent Classification"}
    RecordInputRef parent?;
    *ClassificationCommon;
};

# Netsuite Classification type record for common fields.
#
# + name - Name of the classification  
# + includeChildren - Checks for child classifications  
# + isInactive - shows whether classification is active or not  
# + subsidiaryList - Subsidiary List   
# + externalId - external ID  
type ClassificationCommon record {
    @display{label: "Name"}
    string name?;
    @display{label: "Is Include Children"}
    boolean includeChildren?;
    @display{label: "Is Inactive"}
    boolean isInactive?;
    @display{label: "Subsidiary List"}
    RecordRef subsidiaryList?;
    @display{label: "External ID"}
    string externalId?;
};

# NetSuite Account type record
#
# + internalId - Internal ID  
# + externalId - External ID   
# + acctNumber - Account Number  
# + acctName - Account Name  
# + legalName - Legal Name of the Account   
# + currency - Account currency
@display{label: "Account"}  
public type Account record {
    @display{label: "Internal ID"}
    string internalId;
    @display{label: "External ID"}
    string externalId?;   
    @display{label: "Account Number"}
    string acctNumber?;
    @display{label: "Account Name"}
    string acctName?;
    @display{label: "Legal Name"}
    string legalName?;
    @display{label: "Account Currency"}
    RecordRef currency?;
    *AccountCommon;
};

# NetSuite Account type record
#  
# + acctNumber - Account Number  
# + acctName - Account Name  
# + currency - Account Currency Detail(Type: netsuite:CURRENCY)
@display{label: "New Account"}
public type NewAccount record {
    @display{label: "Account Number"}
    string acctNumber;
    @display{label: "Account Name"}
    string acctName;
    @display{label: "Currency Detail"}
    RecordInputRef currency?;
    *AccountCommon;
};

# NetSuite Account type record for common fields
#
# + acctType - Account type  
# + unitsType - Units type  
# + unit -  Displays the base unit assigned to the unitsType   
# + includeChildren - checks for children   
# + exchangeRate - Exchange rate 
# + generalRate - General Rate of the Account  
# + cashFlowRate -  The type of exchange rate that is used to translate foreign currency amounts for this account  
# + billableExpensesAcct - Track Billable Expenses in  
# + deferralAcct - Deferral Account  
# + description - Account description  
# + curDocNum - Next Check Number  
# + isInactive - Checks whether active or not  
# + department - Netsuite Department  
# + 'class - Class of the Account  
# + location - Restrict to Location  
# + inventory - If TRUE, the account balance is included in the Inventory KPI  
# + eliminate - Eliminate Intercompany Transactions  
# + openingBalance - Opening Balance of the account  
# + revalue - Revalue Open Balance for Foreign Currency Transactions
# + subsidiary - A subsidiary of the account  
public type AccountCommon record {
    @display{label: "Account Type"}
    AccountType|string acctType?;
    @display{label: "Units Type"}
    RecordRef unitsType?;
    @display{label: "Unit"}
    RecordRef unit?;
    @display{label: "Is Include Children"}
    boolean includeChildren?;
    @display{label: "Exchange Rate"}
    string exchangeRate?;
    @display{label: "General Rate"}
    string generalRate?;
    @display{label: "Cash Flow Rate"}
    ConsolidatedRate|string cashFlowRate?;
    @display{label: "Billable Expense"}
    RecordRef billableExpensesAcct?;
    @display{label: "Deferral Account"}
    RecordRef deferralAcct?;
    @display{label: "Description"}
    string description?;
    @display{label: "Next Check Number"}
    decimal curDocNum?;
    @display{label: "Is Inactive"}
    boolean isInactive?;
    @display{label: "Department"}
    RecordRef department?;
    @display{label: "Class Of The Account"}
    RecordRef 'class?;
    @display{label: "Location"}
    RecordRef location?;
    @display{label: "Include In Inventory KPI"}
    boolean inventory?;
    @display{label: "Eliminate Intercompany Transactions"}
    boolean eliminate?;
    @display{label: "Opening Balance"}
    decimal openingBalance?;
    @display{label: "Revalue"}
    boolean revalue?;
    @display{label: "Account Subsidiary"}
    Subsidiary subsidiary?;
};

# Represents an item(member) of an item group
#
# + memberDescr - Description of the member
# + componentYield - Component yield  
# + bomQuantity - BOM quantity
# + itemSource - Item source values:(_stock, _phantom, _workOrder, _purchaseOrder) 
# + quantity - Quantity of the member  
# + memberUnit - Units  
# + vsoeDeferral - Deferral value (_deferBundleUntilDelivered, _deferUntilItemDelivered)
# + vsoePermitDiscount - Permit Discount value (_asAllowed, _never)  
# + vsoeDelivered - Default as Delivered
# + taxSchedule - Tax schedule  
# + taxcode - Tax Code  
# + item - Item reference  
# + taxrate - Tax rate  
# + effectiveDate - Effective date  
# + obsoleteDate - ObsoleteDate  
# + effectiveRevision - Effective Revision  
# + obsoleteRevision - ObsoleteRevision
# + lineNumber - Line number  
# + memberKey - Member Key
@display{label: "Item member"}
public type ItemMember record {
    @display{label: "Member Description"}
    string memberDescr?;
    @display{label: "Company Yield"}
    decimal? componentYield?;
    @display{label: "BOM Quantity"}
    decimal? bomQuantity?;
    @display{label: "Item Source"}
    string itemSource?;
    @display{label: "Quantity"}
    decimal? quantity?;
    @display{label: "Member Unit"}
    RecordRef memberUnit?;
    @display{label: "VSO Deferral"}
    string vsoeDeferral?;
    @display{label: "VSO Permit Discount"}
    string vsoePermitDiscount?;
    @display{label: "VSO Delivered"}
    boolean vsoeDelivered?;
    @display{label: "Tax Schedule"}
    RecordRef taxSchedule?;
    @display{label: "Tax Code"}
    string taxcode?;
    @display{label: "Item Reference"}
    RecordRef item;
    @display{label: "Tax Rate"}
    decimal? taxrate?;
    @display{label: "Effective Date"}
    string effectiveDate?;
    @display{label: "Obsolete Date"}
    string obsoleteDate?;
    @display{label: "Effective Revision"}
    RecordRef effectiveRevision?;
    @display{label: "Obsolete Revision"}
    RecordRef obsoleteRevision?;
    @display{label: "Line Number"}
    decimal? lineNumber?;
    @display{label: "Member Key"}
    string memberKey?; 
};

#  Netsuite itemGroup type record
#
# + internalId - Internal Id of the group  
# + externalId - External id of the group
@display{label: "Item Group"}
public type ItemGroup record {
    @display{label: "Internal ID"}
    string internalId?;
    @display{label: "External ID"}
    string externalId?;
    *ItemGroupCommon;
};

# Represents Item Group record in record creation
# 
@display{label: "New Item Group"}
public type NewItemGroup record {
    *ItemGroupCommon;
};

# Netsuite itemGroup type record common fields
#
# + createdDate - Created date
# + lastModifiedDate - Last modified date  
# + customForm - Custom form  
# + includeStartEndLines - Include Start/End Lines  
# + isVsoeBundle - ItemGroup Is VSOE Bundle or not  
# + defaultItemShipMethod - Default item ship method  
# + availableToPartners - Available to Adv. Partners 
# + isInactive - ItemGroup is inactive  or not 
# + itemId - Item name/number
# + upcCode - UPC Code
# + displayName - Display name/code  
# + vendorName - Vendor name  
# + issueProduct - The product this item is associated with
# + parent -  Parent item 
# + description - Item description  
# + subsidiaryList - Subsidiary list  
# + includeChildren - Include Children field to share the item with all the sub-subsidiaries associated with each 
# subsidiary selected in the Subsidiary field.   
# + department - Department to associate with this item 
# + 'class - Class to associate with this item.  
# + location - Location to associate with this item 
# + itemShipMethodList - Shipping method list  
# + printItems -  To display the member items with their respective display names, quantities and descriptions on sales and purchase forms 
# + memberList - List of items of the group  
# + translationsList - List translations of the group  
# + hierarchyVersionsList - List of version hierarchies.  
# + customFieldList - Custom Fields
@display{label: "Item Group Common Fields"}
public type ItemGroupCommon record {
    @display{label: "Created Date"}
    string createdDate?;
    @display{label: "LastModified Date"}
    string lastModifiedDate?;
    @display{label: "Custom Form Reference"}
    RecordRef customForm?;
    @display{label: "Include Start-End Lines"}
    boolean includeStartEndLines?;
    @display{label: "Is Vsoe Bundle"}
    boolean isVsoeBundle?;
    @display{label: "Default Item Ship Method"}
    RecordRef defaultItemShipMethod?;
    @display{label: "Available To Partners"}
    boolean availableToPartners?;
    @display{label: "Is Inactive"}
    boolean isInactive?;
    @display{label: "Item ID"}
    string itemId?;
    @display{label: "UPC Code"}
    string upcCode?;
    @display{label: "Display Name"}
    string displayName?;
    @display{label: "Vendor Name"}
    string vendorName?;
    @display{label: "Issue Product"}
    RecordRef issueProduct?;
    @display{label: "Parent"}
    RecordRef parent?;
    @display{label: "Description"}
    string description?;
    @display{label: "Subsidiary List"}
    RecordRef[] subsidiaryList?;
    @display{label: "Include Children"}
    boolean includeChildren?;
    @display{label: "Department"}
    RecordRef department?;
    @display{label: "Class"}
    RecordRef 'class?;
    @display{label: "Location"}
    RecordRef location?;
    @display{label: "Item Ship Method List"}
    RecordRef[] itemShipMethodList?;
    @display{label: "Print Items"}
    boolean printItems?;
    @display{label: "Member List"}
    ItemMember[] memberList?;
    @display{label: "Translations List"}
    Translation[] translationsList?;
    @display{label: "Hierarchy Versions List"}
    ItemGroupHierarchyVersions[] hierarchyVersionsList?;
    @display{label: "Custom Field List"}
    CustomFieldList customFieldList?;
};

# Netsuite Translation element for the itemGroup
#
# + locale - The location  
# + language - language of the translation  
# + displayName - Display Name  
# + description - Description  
# + salesDescription - Sales description  
# + storeDisplayName - Store display name  
# + storeDescription - Store description  
# + storeDetailedDescription - store detail Description  
# + featuredDescription - featured Description  
# + specialsDescription - special translation Description  
# + pageTitle - page Title  
# + noPriceMessage - No price message  
# + outOfStockMessage - Out of stock message
@display{label: "Netsuite Translation Record"}
public type Translation record {
    @display{label: "Netsuite Locale"}
    string locale?;
    @display{label: "Language"}
    string language?;
    @display{label: "Display Name"}
    string displayName?;
    @display{label: "Description"}
    string description?;
    @display{label: "Sales Description"}
    string salesDescription?;
    @display{label: "Store Display Name"}
    string storeDisplayName?;
    @display{label: "Store Description"}
    string storeDescription?;
    @display{label: "Store Detailed Description"}
    string storeDetailedDescription?;
    @display{label: "Featured Description"}
    string featuredDescription?;
    @display{label: "Specials Description"}
    string specialsDescription?;
    @display{label: "Page Title"}
    string pageTitle?;
    @display{label: "No Price Message"}
    string noPriceMessage?;
    @display{label: "Out Of Stock Message"}
    string outOfStockMessage?;
};

# Represents item group version hierarchies
#
# + isIncluded - Whether it is included  
# + hierarchyVersion - Hierarchy version  
# + startDate - Start date  
# + endDate - End date  
# + hierarchyNode - hierarchy node
 @display{label: "Netsuite Item Group Hierarchy Versions Record"}
public type ItemGroupHierarchyVersions record {
    @display{label: "Is Included"}
    boolean isIncluded?;
    @display{label: "Hierarchy Version"}
    RecordRef hierarchyVersion?;
    @display{label: "Start Date"}
    string startDate?;
    @display{label: "End Date"}
    string endDate?;
    @display{label: "Hierarchy Node"}
    RecordRef hierarchyNode?;   
};
