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
# + customForm - NetSuite custom form record reference
# + entityId - Entity ID  
# + contactSource - The way how this contact came to do business with the company  
# + company - The company this contact works for  
# + salutation - The contact's salutation  
# + firstName - First name of the contact  
# + middleName - Middle name of the contact 
# + lastName - Last name of the contact 
# + title - Contact's title at his or her company
# + phone - Main phone number  
# + fax - Fax number  
# + email - Email address 
# + defaultAddress - The default billing address 
# + isPrivate -  If true the contact can only be viewed by the user that entered the contact record.(default: false)
# + isInactive - If true, this contact is not displayed on the Contacts list in the UI.(default: false)  
# + subsidiary - The subsidiary to associate with this contact   
# + altEmail - An alternate email address for this contact
# + officePhone - Office phone number  
# + homePhone - Home phone number  
# + mobilePhone - Mobile phone number
# + supervisor - References an existing contact  
# + supervisorPhone - SuperVisor phone number  
# + assistant - References to an existing contact 
# + assistantPhone - Assistant Phone number  
# + comments - Any other information
# + image - References an existing file  
# + billPay - BillPay value  
# + dateCreated - The date of record creation 
# + lastModifiedDate - The date of the last modification 
# + addressBookList - List of Address Books 
# + SubscriptionsList - List of subscriptions  
public type Contact record {
    RecordRef customForm?;
    string entityId?;
    RecordRef contactSource?;
    RecordRef company?;
    string salutation?;
    string firstName?;
    string middleName?;
    string lastName?;
    string title?;
    string phone?;
    string fax?;
    string email?;
    string defaultAddress?;
    boolean isPrivate?;
    boolean isInactive?;
    RecordRef subsidiary?;
    string altEmail?;
    string officePhone?;
    string homePhone?;
    string mobilePhone?;
    RecordRef supervisor?;
    string supervisorPhone?;
    RecordRef assistant?;
    string assistantPhone?;
    string comments?;
    string image?;
    boolean billPay?;
    string dateCreated?;
    string lastModifiedDate?;
    ContactAddressBook[] addressBookList?;
    Subscription[] SubscriptionsList?;
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
# + companyName - Company name  
# + phone - Main phone number  
# + fax - Fax phone number
# + email - Email Address  
# + defaultAddress - Default Address  
# + isInactive - This field is false by default, shows whether active or not
# + category - References a value in a user defined list at Setup
# + subsidiary - Selects the subsidiary to associate with this entity or job  
# + title - The job title
# + homePhone -   
# + mobilePhone - Field Description  
# + accountNumber - Field Description  
# + addressbookList - Field Description  
# + currencyList - Field Description  
public type Customer record {
    string internalId?;
    string entityId?;
    boolean isPerson?;
    string salutation?;
    string firstName?;
    string middleName?;
    string lastName?;
    string companyName?;
    string phone?;
    string fax?;
    string email?;
    string defaultAddress?;
    boolean isInactive?;
    RecordRef category?;
    RecordRef subsidiary?;
    string title?;
    string homePhone?;
    string mobilePhone?;
    string accountNumber?;
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
# + displaySymbol - Display symbol of the currency type 
# + currencyPrecision - Precision symbol of the currency type 
# + isInactive - Shows whether the currency type is active or not 
# + isBaseCurrency - Shows whether the currency type is a NetSuite base currency or not  
public type Currency record {
    string name?;
    string symbol?;
    decimal exchangeRate?;
    string displaySymbol?;
    string currencyPrecision?;
    boolean isInactive?;
    boolean isBaseCurrency?;
};
