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
# + isInactive - shows whether classification is active or not  
# + subsidiaryList - Subsidiary List  
# + internalId - Internal ID  
# + externalId - external ID  
public type Classification record {
    string name?;
    boolean includeChildren?;
    RecordRef parent?;
    boolean isInactive?;
    RecordRef subsidiaryList?;
    string internalId?;
    string externalId?;
};

# Netsutie Account type record
#
# + internalId - Internal ID  
# + externalId - External ID  
# + acctType - Account type  
# + unitsType - Units type  
# + unit -  Displays the base unit assigned to the unitsType   
# + acctNumber - Account Number  
# + acctName - Account Name  
# + legalName - Legal Name of the Account  
# + includeChildren - checks for children  
# + currency - Account currency  
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
public type Account record {
    string internalId?;
    string externalId?;   
    string acctType?;
    RecordRef unitsType?;
    RecordRef unit?;
    string acctNumber?;
    string acctName?;
    string legalName?;
    boolean includeChildren?;
    RecordRef currency?;
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