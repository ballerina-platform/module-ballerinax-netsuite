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
# + internalId - internal ID  of the record
# + salutation - The contact's salutation    
# + firstName - First name of the contact      
# + subsidiary - The subsidiary to associate with this contact
@display{label: "Contact"}
public type Contact record {
    @display{label: "Internal ID"}
    string internalId;
    @display{label: "Salutation"}
    string salutation?;
    @display{label: "First Name"}
    string firstName?;
    *ContactCommon;
    @display{label: "Subsidiary"}
    RecordRef subsidiary?;
};

# Netsuite Contact type record
# 
# + firstName - First name of the contact   
# + subsidiary - The subsidiary to associate with this contact 
@display{label: "New Contact"}
public type NewContact record {
    @display{label: "First Name"}
    string firstName;
    @display{label: "Subsidiary"}
    RecordInputRef subsidiary;
    *ContactCommon;
};

# Netsuite Contact type record
#
# + middleName - Middle name of the contact   
# + lastName - Last name of the contact   
# + entityId - Entity ID    
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
    @display{label: "Middle Name"}
    string middleName?;
    @display{label: "Last Name"}
    string lastName?;
    @display{label: "Entity ID"}
    string entityId?;
    @display{label: "Title"}
    string title?;
    @display{label: "Phone Number"}
    string phone?; 
    @display{label: "Fax"}
    string fax?;
    @display{label: "Email"}
    string email?;
    @display{label: "Address"}
    string defaultAddress?;
    @display{label: "Is Private"}
    boolean isPrivate?;
    @display{label: "Is Inactive"}
    boolean isInactive?;
    @display{label: "Alternative Email Address"}
    string altEmail?;
    @display{label: "Office Phone Number"}
    string officePhone?;
    @display{label: "Home Phone Number"}
    string homePhone?;
    @display{label: "Mobile Phone Number"}
    string mobilePhone?;
    @display{label: "Supervisor Phone Number"}
    string supervisorPhone?;
    @display{label: "Assistant Phone Number"}
    string assistantPhone?;
    @display{label: "Other Information"}
    string comments?;
    @display{label: "Image"}
    string image?;
    @display{label: "Billing Value"}
    boolean billPay?;
    @display{label: "Created Date"}
    string dateCreated?;
    @display{label: "Last Modified Date"}
    string lastModifiedDate?;
    @display{label: "Address Book List"}
    ContactAddressBook[] addressBookList?;
    @display{label: "Subscription List"}
    Subscription[] SubscriptionsList?;
    @display{label: "Assistant"}
    RecordRef assistant?;
    @display{label: "Supervisor"}
    RecordRef supervisor?;
    @display{label: "Contact Source"}
    RecordRef contactSource?;
    @display{label: "Company"}
    RecordRef company?;
    @display{label: "Custom Form"}
    RecordRef customForm?;
};

# Netsuite Customer type record 
# + internalId - Internal ID of the customer record
# + companyName - Company name  
# + subsidiary - Selects the subsidiary to associate with this entity or job   
@display{label: "Customer"}
public type Customer record {
    @display{label: "Internal ID"}
    string internalId;
    *CustomerCommon;
    @display{label: "Company Name"}
    string companyName?;
    @display{label: "Subsidiary"}
    RecordRef subsidiary?;
};

# Netsuite Customer type record 
#
# + companyName - Company name  
# + subsidiary - Selects the subsidiary to associate with this entity or job  
@display{label: "New Customer"}
public type NewCustomer record {
    @display{label: "Company Name"}
    string companyName;
    @display{label: "Subsidiary"}
    RecordInputRef subsidiary;
    *CustomerCommon;
};

# Netsuite Customer type record 
#
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
# + homePhone - Home phone number  
# + mobilePhone - Field Description  
# + accountNumber - Field Description  
# + addressbookList - Field Description  
# + currencyList - Field Description  
type CustomerCommon record {
    @display{label: "Salutation"}
    string salutation?;
    @display{label: "First Name"}
    string firstName?;
    @display{label: "Middle Name"}
    string middleName?;
    @display{label: "Last Name"}
    string lastName?;
    @display{label: "Phone Number"}
    string phone?;
    @display{label: "Fax"}
    string fax?;
    @display{label: "Email"}
    string email?;
    @display{label: "Address"}
    string defaultAddress?;
    @display{label: "Job Title"}
    string title?;
    @display{label: "Home Phone Number"}
    string homePhone?;
    @display{label: "Mobile Phone Number"}
    string mobilePhone?;
    @display{label: "Account Number"}
    string accountNumber?;
    @display{label: "Entity ID"}
    string entityId?;
    @display{label: "Is Inactive"}
    boolean isInactive?;
    @display{label: "Is Person"}
    boolean isPerson?;
    @display{label: "Category"}
    RecordRef category?;
    @display{label: "Address Book List"}
    CustomerAddressbook[] addressbookList?;
    @display{label: "Currency List"}
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
# + internalId - Internal ID of the currency record  
# + name - Name of the record  
# + symbol - Symbol of the record   
# + exchangeRate - The exchange rate of the currency
@display{label: "Currency"}
public type Currency record {
    @display{label: "Internal ID"}
    string internalId;
    @display{label: "Currency Name"}
    string name?;
    @display{label: "Symbol"}
    string symbol?;
    @display{label: "Exchange Rate"}
    decimal exchangeRate?;
    *CurrencyCommon;
};

# Netsuite Currency type record
#
# + name - Name of the record
# + symbol - Symbol of the record 
# + exchangeRate - The exchange rate of the currency
@display{label: "New Currency"}
public type NewCurrency record {
    @display{label: "Currency Name"}
    string name;
    @display{label: "Symbol"}
    string symbol;
    @display{label: "Exchange Rate"}
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
    @display{label: "Display Symbol"}
    string displaySymbol?;
    @display{label: "Precision Symbol"}
    string currencyPrecision?;
    @display{label: "Is Inactive"}
    boolean isInactive?;
    @display{label: "Is Base Currency"}
    boolean isBaseCurrency?;
};
