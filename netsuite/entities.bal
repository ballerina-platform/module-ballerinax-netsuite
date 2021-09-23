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
# + homePhone -  Home phone number 
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

# NetSuite Vendor type record
#
# + companyName - Company Name  
# + subsidiary - Refers the subsidiary
@display{label: "New Vendor"}  
public type NewVendor record {
    @display{label: "Company Name"}
    string companyName;
    @display{label: "Subsidiary"}
    RecordRef subsidiary;
    *VendorCommon;
};

# NetSuite Vendor type record
#
# + customForm - Refers the custom form 
# + externalId - The external ID  
# + entityId - The entity ID  
# + altName - This is the name of this person or company
# + isPerson - By default, this is set to True which specifies the type of vendor record as Individual. If set to False, 
# the vendor record is set as a Company type 
# + phoneticName -  The furigana character you want to use to sort this record  
# + salutation - The salutation  
# + firstName - First name   
# + middleName - Middle name  
# + lastName - Last name  
# + phone - Phone number  
# + fax - Fax
# + email - Email  
# + url - Only available when isPerson is set to FALSE  
# + defaultAddress - Read-only field that returns the default address for the vendor  
# + isInactive - This field is false by default  
# + lastModifiedDate - The last modified date  
# + dateCreated - The record created date
# + category - References a value in a user-defined list at Lists > Accounting > Currencies. This value sets the currency 
# that all transactions involving this vendor are conducted in. 
# + title - Job title  
# + printOnCheckAs - Sets the Pay to the Order of line of a check instead of what you entered in the Vendor field  
# + altPhone - Phone numbers can be entered in the following formats: 999-999-9999, 1-999-999-9999, (999) 999-9999, 
# 1(999) 999-9999 or 999-999-9999 ext 9999
# + homePhone - Home page
# + mobilePhone - Mobile Phone  
# + altEmail - Email   
# + comments - Any other information you wish to track for this vendor  
# + image - References an image file that has already been uploaded to the account
# + representingSubsidiary - Indicates that this entity is an intercompany vendor 
# + accountNumber - The account number for vendors to reference  
# + legalName - The legal name for this vendor for financial purposes 
# + vatRegNumber - For the UK edition only. Note that this field is not validated when submitted via Web services.  
# + expenseAccount - References an existing account to be used for goods and services you purchase from this vendor  
# + payablesAccount - The default payable account for this vendor record  
# + terms - References a value in a user-defined list at Setup > Accounting > Setup Tasks > Accounting Lists > Term and 
# sets the standard discount terms for this Vendor's invoices  
# + incoterm - The standardized three-letter trade term to be used on transactions related to this vendor 
# + creditLimit - A credit limit for your purchases from the vendor  
# + balancePrimary - This is a read-only calculated field that returns the vendor's current accounts payable balance in 
# the specified currency 
# + openingBalance - The opening balance of your account with this vendor
# + openingBalanceDate - The date of the balance entered in the Opening Balance field  
# + openingBalanceAccount - The account this opening balance is applied to  
# + balance - This is a read-only calculated field that returns the vendor's current accounts payable balance
# + unbilledOrdersPrimary - This field displays the total amount of orders that have been entered but not yet billed in 
# the specified currency  
# + bcn - The 15-digit registration number that identifies this vendor as a client of the Canada Customs and Revenue 
# Agency (CCRA) 
# + unbilledOrders - Tffhe total amount of orders that have been entered but not yet billed in the specified currency
# + currency - References a value in a user-defined list at Lists > Accounting > Currencies. This value sets the currency 
# that all transactions involving this vendor are conducted in 
# + is1099Eligible - If set to TRUE, this vendor is 1099 eligible  
# + isJobResourceVend - This vendor as a resource on tasks and jobs
# + laborCost - The cost of labor for this vendor in order to be able to calculate profitability on jobs
# + purchaseOrderQuantity - The tolerance limit for the discrepancy between the quantity on the vendor bill and purchase 
# order 
# + purchaseOrderAmount - The tolerance limit for the discrepancy between the amount on the vendor bill and purchase order
# + purchaseOrderQuantityDiff - The difference limit for the discrepancy between the quantity on the vendor bill and 
# purchase order 
# + receiptQuantity - The tolerance limit for the discrepancy between the quantity on the vendor bill and item receipt
# + receiptAmount - The tolerance limit for the discrepancy between the amount on the vendor bill and item receipt 
# + receiptQuantityDiff - The difference limit for the discrepancy between the quantity on the vendor bill and item 
# receipt
# + workCalendar - The work calendar for this vendor
# + taxIdNum - The Vendor's Tax ID number
# + taxItem - The default tax code you want applied to purchase orders and bills for this vendor
# + giveAccess - Access to your NetSuite account for the vendor
# + sendEmail - This field can only be set on ADD. When set to TRUE, an email notification is sent to the Vendor to 
# inform them that they have been granted access to your account  
# + billPay - Allows to send this vendor payments online. Before you can use this feature, you must set up Online Bill Pay at 
# Setup > Accounting > Online Bill Pay.  
# + isAccountant - If set to TRUE, this vendor has free access to the NetSuite account and the isAccountant field is set
#  to FALSE for any vendor record previously defined as the Free Accountant 
# + password - The password assigned to allow this vendor access to NetSuite  
# + password2 -  The password confirmation field
# + requirePwdChange - If set to TRUE, the vendor is required to change the default password assign on the next login 
# attempt  
# + eligibleForCommission - Indicates eligible for commission  
# + emailTransactions - Sets a preferred transaction delivery method for this vendor
# + printTransactions - Sets a preferred transaction delivery method for this vendor 
# + faxTransactions - Sets a preferred transaction delivery method for this vendor  
# + defaultTaxReg - The default tax registration number for this entity  
# + predictedDays - How late or early you expect this vendor to provide the required material in number of days. 
# To indicate days early, enter a negative number 
# + predConfidence - The confidence you have that this vendor will provide the required material expressed as a percentage
# + customFieldList - Custom field list
public type VendorCommon  record {
    @display{label: "Custom Form"}
    RecordRef customForm?;
    @display{label: "External ID"}
    string externalId?;
    @display{label: "Entity ID"}
    string entityId?;
    @display{label: "Vendor Name"}
    string altName?;
    @display{label: "Is Individual"}
    boolean isPerson?;
    @display{label: "Furigana"}
    string phoneticName?;
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
    @display{label: "URL"}
    string url?;
    @display{label: "Default Address"}
    string defaultAddress?;
    @display{label: "Vendor is Inactive"}
    boolean isInactive?;
    @display{label: "Last Modified Date"}
    string lastModifiedDate?;
    @display{label: "Date Created"}
    string dateCreated?;
    @display{label: "Category"}
    RecordRef category?;
    @display{label: "Job Title"}
    string title?;
    @display{label: "Print on Check As"}
    string printOnCheckAs?;
    @display{label: "Alt. Phone"}
    string altPhone?;
    @display{label: "Home Phone"}
    string homePhone?;
    @display{label: "Mobile Phone"}
    string mobilePhone?;
    @display{label: "Alt. Email"}
    string altEmail?;
    @display{label: "Comments"}
    string comments?;
    @display{label: "Image"}
    RecordRef image?;
    @display{label: "Representing Subsidiary"}
    RecordRef representingSubsidiary?;
    @display{label: "Account Number"}
    string accountNumber?;
    @display{label: "Legal Name"}
    string legalName?;
    @display{label: "VAT Registration No."}
    string vatRegNumber?;
    @display{label: "Default Expense Account"}
    RecordRef expenseAccount?;
    @display{label: "Payables Account"}
    RecordRef payablesAccount?;
    @display{label: "Terms"}
    RecordRef terms?;
    @display{label: "Incoterm"}
    RecordRef incoterm?;
    @display{label: "Credit Limit"}
    decimal? creditLimit?;
    @display{label: "Balance"}
    decimal? balancePrimary?;
    @display{label: "Opening Balance"}
    decimal? openingBalance?;
    @display{label: "Opening Balance Date"}
    string openingBalanceDate?;
    @display{label: "Opening Balance Account"}
    RecordRef openingBalanceAccount?;
    @display{label: "Balance (Base)"}
    decimal? balance?;
    @display{label: "Unbilled Orders (Base)"}
    decimal? unbilledOrdersPrimary?;
    @display{label: "Business Number"}
    string bcn?;
    @display{label: "Unbilled Orders (Base)"}
    decimal? unbilledOrders?;
    @display{label: "Currency"}
    RecordRef currency?;
    @display{label: "1099 Eligible"}
    boolean is1099Eligible?;
    @display{label: "Job Resource"}
    boolean isJobResourceVend?;
    @display{label: "Labor Cost"}
    decimal? laborCost?;
    @display{label: "Vendor Bill - Purchase Order Quantity Tolerance"}
    decimal? purchaseOrderQuantity?;
    @display{label: "Vendor Bill - Purchase Order Amount Tolerance"}
    decimal? purchaseOrderAmount?;
    @display{label: "Vendor Bill - Purchase Order Quantity Difference"}
    decimal? purchaseOrderQuantityDiff?;
    @display{label: "Vendor Bill - Item Receipt Quantity Tolerance"}
    decimal? receiptQuantity?;
    @display{label: "Vendor Bill - Item Receipt Amount Tolerance"}
    decimal? receiptAmount?;
    @display{label: "Vendor Bill - Item Receipt Quantity Difference"}
    decimal? receiptQuantityDiff?;
    @display{label: "Work Calendar"}
    RecordRef workCalendar?;
    @display{label: "Tax ID"}
    string taxIdNum?;
    @display{label: "Tax Code"}
    RecordRef taxItem?;
    @display{label: "Login Access"}
    boolean giveAccess?;
    @display{label: "Send New Access Notification Email"}
    boolean sendEmail?;
    @display{label: "Enable Online Bill Pay"}
    boolean billPay?;
    @display{label: "Is Accountant"}
    boolean isAccountant?;
    @display{label: "Password"}
    string password?;
    @display{label: "Confirm Password"}
    string password2?;
    @display{label: "Require Password Change On Next Login"}
    boolean requirePwdChange?;
    @display{label: "Eligible for Commission"}
    boolean eligibleForCommission?;
    @display{label: "Email Transactions"}
    boolean emailTransactions?;
    @display{label: "Print Transactions"}
    boolean printTransactions?;
    @display{label: "Fax Transactions"}
    boolean faxTransactions?;
    @display{label: "Default Tax Reg. Number"}
    RecordRef defaultTaxReg?;
    @display{label: "Predicted Days Late/Early"}
    int? predictedDays?;
    @display{label: "Predicted Risk Confidence"}
    decimal? predConfidence?;
    @display{label: "Custom Field List"}
    CustomFieldList customFieldList?;
};

# NetSuite Vendor type record
#
# + internalId - Internal ID  
# + companyName - The Company name  
# + subsidiary - Refers subsidiary 
@display{label: "Vendor"} 
public type Vendor record {
    @display{label: "Internal ID"}
    string internalId;
    @display{label: "Company Name"}
    string companyName?;
    @display{label: "Subsidiary"}
    RecordRef subsidiary?;
    *VendorCommon; 
};



