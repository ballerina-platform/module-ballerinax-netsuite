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
# + internalId - Internal Id
public type Classification record {
    string internalId;
    string name?;
    RecordRef parent?;
    boolean includeChildren?;
    *ClassificationCommon;
};

# Netsuite Classification type record
#
# + name - Name of the classification   
# + parent - References parent classifications 
public type NewClassification record {
    string name;
    RecordInputRef parent?;
    *ClassificationCommon;
};

# Netsuite Classification type record for common fields.
#
# + name - Name of the classification  
# + includeChildren - Checks for child classifications  
# + isInactive - shows whether classification is active or not  
# + subsidiaryList - Subsidiary List   
# + externalId - external Id  
type ClassificationCommon record {
    string name?;
    boolean includeChildren?;
    boolean isInactive?;
    RecordRef subsidiaryList?;
    string externalId?;
};

# NetSuite Account type record
#
# + internalId - Internal Id  
# + externalId - External Id   
# + acctNumber - Account Number  
# + acctName - Account Name  
# + legalName - Legal Name of the Account   
# + currency - Account currency  
public type Account record {
    string internalId?;
    string externalId?;   
    string acctNumber?;
    string acctName?;
    string legalName?;
    RecordRef currency?;
    *AccountCommon;
};

# NetSuite Account type record
#  
# + acctNumber - Account Number  
# + acctName - Account Name  
# + currency - Account currency  
public type NewAccount record {
    string acctNumber?;
    string acctName?;
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
    string acctType?;
    RecordRef unitsType?;
    RecordRef unit?;
    boolean includeChildren?;
    string exchangeRate?;
    string generalRate?;
    ConsolidatedRate|string cashFlowRate?;
    RecordRef billableExpensesAcct?;
    RecordRef deferralAcct?;
    string description?;
    decimal curDocNum?;
    boolean isInactive?;
    RecordRef department?;
    RecordRef 'class?;
    RecordRef location?;
    boolean inventory?;
    boolean eliminate?;
    decimal openingBalance?;
    boolean revalue?;
    Subsidiary subsidiary?;
};
