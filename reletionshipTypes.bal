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

# NeSuite contactAddressBook type record
#
# + defaultShipping - default shipping address  
# + defaultBilling - default billing address  
# + label - contactBookLabel  
# + addressBookAddress - AddressBook address  
# + internalId - InternalID of the record  
public type ContactAddressBook record {
    boolean defaultShipping?;
    boolean defaultBilling?;
    string label?;
    Address[] addressBookAddress?;
    string internalId?;
};

# Netsuite CustomerAddressbook type record
#
# + isResidential - Whether addressBook is residential or not  
public type CustomerAddressbook record {
    *ContactAddressBook;
    boolean isResidential;

};

# Netsuite Subscription type record
#
# + subscribed - Subscription Id  
# + subscription - Subscription Detail  
# + lastModifiedDate - Last modified date of the subscription  
public type Subscription record {
    boolean subscribed;
    RecordRef subscription;
    string lastModifiedDate;
};
  
# NetSuite category type record  
public type Category record {
    *RecordRef;
};

# NetSuite CustomerCurrency type record
#
# + currency - The NetSuite currency  
# + balance - balance of the customerCurrency  
# + consolBalance - Consolidated balance  
# + depositBalance - Deposit Balance  
# + consolDepositBalance - Consolidated Deposit  
# + overdueBalance - OverDue Balance  
# + consolOverdueBalance - Consolidated overdue balance
# + unbilledOrders - Unbilled orders  
# + consolUnbilledOrders - Consolidated unbilled orders   
# + overrideCurrencyFormat - checks whether override the currency format  
public type CustomerCurrency record {
    RecordRef currency?;
    decimal balance?;
    decimal consolBalance?;
    decimal depositBalance?;
    decimal consolDepositBalance?;
    decimal overdueBalance?;
    decimal consolOverdueBalance?;
    decimal unbilledOrders?;
    decimal consolUnbilledOrders?;
    boolean overrideCurrencyFormat?;
};
