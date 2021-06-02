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

# Netsuite Contact type record
#
# + salutation - The contact's salutation  
# + firstName - First name of the contact    
# + subsidiary - The subsidiary to associate with this contact
public type Contact record {
    string salutation?;
    string firstName?;
    *ContactCommon;
    RecordRef subsidiary?;
};

# Netsuite Contact type record
# 
# + firstName - First name of the contact   
# + subsidiary - The subsidiary to associate with this contact   
public type NewContact record {
    string firstName;
    RecordInputRef subsidiary;
    *ContactCommon;
};

# Netsuite Contact type record
#
# + middleName - Middle name of the contact   
# + lastName - Last name of the contact   
# + entityId - Entity Id    
# + title - Contact's title at his or her company  
# + phone - Main phone number    
# + fax - Fax number    
# + email - Email address   
# + defaultAddress - The default billing address   
# + isPrivate - If true the contact can only be viewed by the user that entered the contact record.(default: false)  
# + isInactive - If true, this contact is not displayed on the Contacts list in the UI.(default: false)       
# + altEmail - An alternate email address for this contact  
# + officePhone - Office phone number    
# + homePhone - Home phone number    
# + mobilePhone - Mobile phone number  
# + supervisorPhone - SuperVisor phone number    
# + assistantPhone - Assistant Phone number    
# + comments - Any other information  
# + image - References an existing file    
# + billPay - BillPay value    
# + dateCreated - The date of record creation   
# + lastModifiedDate - The date of the last modification   
# + addressBookList - List of Address Books   
# + SubscriptionsList - List of subscriptions    
# + assistant - References to an existing contact   
# + supervisor - References an existing contact    
# + contactSource - The way how this contact came to do business with the company    
# + company - The company this contact works for 
# + customForm - NetSuite custom form record reference
type ContactCommon record {
    string middleName?;
    string lastName?;
    string entityId?;
    string title?;
    string phone?;
    string fax?;
    string email?;
    string defaultAddress?;
    boolean isPrivate?;
    boolean isInactive?;
    string altEmail?;
    string officePhone?;
    string homePhone?;
    string mobilePhone?;
    string supervisorPhone?;
    string assistantPhone?;
    string comments?;
    string image?;
    boolean billPay?;
    string dateCreated?;
    string lastModifiedDate?;
    ContactAddressBook[] addressBookList?;
    Subscription[] SubscriptionsList?;
    RecordRef assistant?;
    RecordRef supervisor?;
    RecordRef contactSource?;
    RecordRef company?;
    RecordRef customForm?;
};

# Netsuite Customer type record 
#
# + companyName - Company name  
# + subsidiary - Selects the subsidiary to associate with this entity or job   
public type Customer record {
    *CustomerCommon;
    string companyName?;
    RecordRef subsidiary?;
};

# Netsuite Customer type record 
#
# + companyName - Company name  
# + subsidiary - Selects the subsidiary to associate with this entity or job  
public type NewCustomer record {
    string companyName;
    RecordInputRef subsidiary;
    *CustomerCommon;
};

# Netsuite Customer type record 
#
# + internalId - Internal ID  
# + entityId - Entity ID
# + isPerson - This is set to True which specifies the type 
# + salutation - The title of this person  
# + firstName - First name  
# + middleName - Middle name  
# + lastName - Last name  
# + phone - Main phone number  
# + fax - Fax phone number
# + email - Email Address  
# + defaultAddress - Default Address  
# + isInactive - This field is false by default, shows whether active or not
# + category - References a value in a user defined list at Setup
# + title - The job title
# + homePhone -   
# + mobilePhone - Field Description  
# + accountNumber - Field Description  
# + addressbookList - Field Description  
# + currencyList - Field Description  
type CustomerCommon record {
    string salutation?;
    string firstName?;
    string middleName?;
    string lastName?;
    string phone?;
    string fax?;
    string email?;
    string defaultAddress?;
    string title?;
    string homePhone?;
    string mobilePhone?;
    string accountNumber?;
    string internalId?;
    string entityId?;
    boolean isInactive?;
    boolean isPerson?;
    RecordRef category?;
    CustomerAddressbook[] addressbookList?;
    CustomerCurrency[] currencyList?;
};

# Netsuite Subsidiary type record
#
# + name - Name of the subsidiary  
# + country - Country of the subsidiary 
# + email - Email of the subsidiary  
# + isElimination - The elimination status of the subsidiary 
# + isInactive -  Shows whether subsidiary is active or not
# + legalName - Legal name of the subsidiary    
# + url - URL for the subsidiary
public type Subsidiary record {
    string name?;
    string country?;
    string email?;
    boolean isElimination?;
    boolean isInactive?;
    string legalName?;
    string url?;
};

# Netsuite Currency type record
#
# + name - Name of the record
# + symbol - Symbol of the record 
# + exchangeRate - The exchange rate of the currency
public type Currency record {
    string name?;
    string symbol?;
    decimal exchangeRate?;
    *CurrencyCommon;
};

# Netsuite Currency type record
#
# + name - Name of the record
# + symbol - Symbol of the record 
# + exchangeRate - The exchange rate of the currency
public type NewCurrency record {
    string name;
    string symbol;
    decimal exchangeRate;
    *CurrencyCommon;
};

# Netsuite Currency type record
#
# + displaySymbol - Display symbol of the currency type 
# + currencyPrecision - Precision symbol of the currency type 
# + isInactive - Shows whether the currency type is active or not 
# + isBaseCurrency - Shows whether the currency type is a NetSuite base currency or not  
type CurrencyCommon record {
    string displaySymbol?;
    string currencyPrecision?;
    boolean isInactive?;
    boolean isBaseCurrency?;
};
