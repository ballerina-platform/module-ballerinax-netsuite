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
type AccountCommon record {
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
