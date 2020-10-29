// Copyright (c) 2020 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

# Represents the writable `Customer` NetSuite record.
# |                                            |
# |:-------------------------------------------|
# | id - The internal ID of the record         |
# | externalId - The external ID of the record |
# | links - The HATEOAS links                  |
# | refName - The reference name               |
#
# + entityId - The unique name of the customer, which is a mandatory attribute
# + companyName - The legal name of the customer, which is a mandatory attribute
# + subsidiary - The associated `Subsidiary`, which is a mandatory attribute
# + isPerson - The type of the customer whether its a company or an individual
# + currency - The base currency used for the customer
# + addressbook - The collection of addresses associated to the customer
# + currencylist - The list of currecncies used by the customer
public type Customer record {
    *NsResource;
    string entityId?;
    string companyName?;
    Subsidiary subsidiary?;
    boolean isPerson?;
    Currency currency?;
    AddressbookCollection addressbook?;
    CurrencylistCollection currencyList?;
    decimal balance?;
    decimal overduebalance?;
    decimal depositbalance?;
    decimal unbilledorders?;
    decimal creditLimit?;
    
};

# Represents the writable `SalesOrder` NetSuite record.
# |                                            |
# |:-------------------------------------------|
# | id - The internal ID of the record         |
# | externalId - The external ID of the record |
# | links - The HATEOAS links                  |
# | refName - The reference name               |
#
# + entity - The entity such as customer, partner, etc. that the sales order belongs to, which is a mandatory attribute
# + currency - The base currency used by the sales order, which is a mandatory attribute
# + item - The collection of items available in the sales order, which is a mandatory attribute
# + orderStatus - The status of the sales order
# + tranId - The order number
# + trandate - The transaciton date
# + startDate - The date on when the first invoice is to be created
# + endDate - The order ending date
# + memo - The memo to describe the sales order
# + billAddress - The default billing address
public type SalesOrder record {
    *NsResource;
    Entity entity;
    Currency currency;
    ItemCollection item;
    string orderStatus?;
    string tranId?;
    string trandate?;
    string startDate?;
    string endDate?;
    string memo?;
    string billAddress?;
};

# Represents the writable `Currency` NetSuite record.
# |                                            |
# |:-------------------------------------------|
# | id - The internal ID of the record         |
# | externalId - The external ID of the record |
# | links - The HATEOAS links                  |
# | refName - The reference name               |
#
# + name - The currency name, which is a mandatory attribute
# + symbol - The symbol to represent the currecy, which is a mandatory attribute
# + exchangeRate - The currency exchange rate
# + displaySymbol - The unique display symbol
# + currencyPrecision - The precision values of the currency
# + isInactive - The state of the currency record whether its no longer active or used in the account
# + isBaseCurrency - The base currency state
public type Currency record {
    *NsResource;
    string name?;
    string symbol?;
    decimal exchangeRate?;
    string displaySymbol?;
    int currencyPrecision?;
    boolean isInactive?;
    boolean isBaseCurrency?;
};

# Represents the writable `Invoice` NetSuite record.
# |                                            |
# |:-------------------------------------------|
# | id - The internal ID of the record         |
# | externalId - The external ID of the record |
# | links - The HATEOAS links                  |
# | refName - The reference name               |
#
# + entity - The entity such as customer, partner, etc. that the invoice belongs to, which is a mandatory attribute
# + item - The collection of the items available in the invoice, which is a mandatory attribute
# + class - The classification of the invoice, which is a mandatory attribute
# + tranId - The invoice number
# + postingperiod - The accounting period
# + trandate - The transaciton date
# + memo - The memo to describe the invoice
public type Invoice record {
    *NsResource;
    Entity entity;
    ItemCollection item;
    Classification 'class?;
    string tranId?;
    AccountingPeriod postingperiod?;
    string trandate?;
    string memo?;
    //----------------SLP4 Update Temp WorkArounds--------------
    decimal amountpaid?;
    decimal amountremaining?;
    decimal amountremainingtotalbox?;
    decimal balance?;
    decimal discountTotal?;
    decimal estGrossProfit?;
    decimal estGrossProfitPercent?;
    decimal exchangeRate?;
    decimal handlingCost?;
    decimal overallbalance?;
    decimal overallunbilledorders?;
    decimal subtotal?;
    decimal taxTotal?;
    decimal total?;
    decimal totalCostEstimate?;
    decimal primarycurrencyfxrate?;
    decimal primarycurrency?;
    Installments installment?;
    decimal deferredrevenue?;
    decimal giftCertApplied?;
    decimal recognizedrevenue?;
};

# Represents the writable `Classification` NetSuite record.
# |                                            |
# |:-------------------------------------------|
# | id - The internal ID of the record         |
# | externalId - The external ID of the record |
# | links - The HATEOAS links                  |
# | refName - The reference name               |
#
# + name - The classification name, which is a mandatory attribute
# + isinactive - The state of the classification record whether its no longer active or used in the account
# + includechildren - Whether the classification includes sub classes or not
# + parent - The parent classification
# + subsidiary - The associated `Subsidiary`
public type Classification record {
    *NsResource;
    string name?;
    boolean isinactive?;
    boolean includechildren?;
    Classification parent?;
    Subsidiary subsidiary?;
};

# Represents the writable `AccountingPeriod` NetSuite record.
#
# + id - The internal ID of the record
# + periodName - The name of the period, which is a mandatory attribute
# + startDate - The start date of the period, which is a mandatory attribute
# + endDate - The end date of the period, which is a mandatory attribute
# + links - The HATEOAS record links
# + refName - The reference name
public type AccountingPeriod record {
    string id = "";
    string periodName?;
    string startDate?;
    string endDate?;
    Link[] links?;
    string refName?;
};

# Represents the writable `CustomerPayment` NetSuite record.
# |                                            |
# |:-------------------------------------------|
# | id - The internal ID of the record         |
# | externalId - The external ID of the record |
# | links - The HATEOAS links                  |
# | refName - The reference name               |
#
# + customer - The assiciated `Customer` record, which is a mandatory attribute
# + payment - The amount of the payment, which is a mandatory attribute
# + currency - The base currency used for the customer payment
# + araccount - The accounts receivable account, which will be affected by the transaction
# + tranId - The auto-generated payment number
# + exchangeRate - The currency's exchange rate
# + trandate - The transaction date
# + postingperiod - The accounting period
# + memo - The memo to describe the payment
# + balance - The balance of the customer account
# + pending - The balance of the pending customer payments
# + subsidiary - The associated `Subsidiary`
public type CustomerPayment record {
    *NsResource;
    Customer customer?;
    decimal payment?;
    Currency currency?;
    Account araccount?;
    string tranId?;
    decimal exchangeRate?;
    string trandate?;
    AccountingPeriod postingperiod?;
    string memo?;
    decimal balance?;
    decimal pending?;
    //----------------SLP4 Update Temp WorkArounds--------------
    Subsidiary subsidiary?;
    decimal applied?;
    PayApply apply?;
    decimal unapplied?;
    decimal total?;
    
    
};

public type PayApply record{
    Link[] links?;
    PayItem[] items?;

};
public type PayItem record{
    Link[] links?;
    decimal due?;
    decimal total?;
    decimal amount?;
};

# Represents the writable `Account` NetSuite record.
# |                                            |
# |:-------------------------------------------|
# | id - The internal ID of the record         |
# | externalId - The external ID of the record |
# | links - The HATEOAS links                  |
# | refName - The reference name               |
#
# + acctname - The account name, which is a mandatory attribute
# + acctnumber - The account number, which is a mandatory attribute
# + currency - The base currency used by the account, which is a mandatory attribute
# + accttype - The account type
# + subsidiary - The associated `Subsidiary`
public type Account record {
    *NsResource;
    string acctname?;
    string acctnumber?;
    Currency currency?;
    string accttype?;
    Subsidiary subsidiary?;
};

# Represents the writable `Opportunity` NetSuite record.
# |                                            |
# |:-------------------------------------------|
# | id - The internal ID of the record         |
# | externalId - The external ID of the record |
# | links - The HATEOAS links                  |
# | refName - The reference name               |
#
# + entity - The entity such as customer, partner, etc. that the opportunity belongs to, which is a mandatory attribute
# + titile - The title of the opportunity
# + item - The collection of items available in the opportunity
# + tranId - The auto-generated transaction ID
# + partner - The associated partner
# + salesRep - The associated sales representative
# + probability -  The probability of winning the opportunity
# + expectedCloseDate - The date on which the opportunity will close
# + winLossReason - The reason for winning or losing the deal
# + memo - The memo to describe the opportunity
# + projectedtotal - The projected value of the opportunity
# + currency - The base currency used by the account
# + subsidiary - The associated `Subsidiary`
public type Opportunity record {
    *NsResource;
    Entity entity?;
    string titile?;
    ItemCollection item?;
    string tranId?;
    Partner partner?;
    Entity salesRep?;
    decimal probability?;
    string expectedCloseDate?;
    NsResource winLossReason?;
    string memo?;
    decimal projectedTotal?;
    Currency currency?;
    Subsidiary subsidiary?;
    //----------------SLP4 Update Temp WorkArounds--------------
    decimal balance?;
    decimal credlim?;
    decimal estGrossProfit?;
    decimal estGrossProfitPercent?;
    decimal exchangeRate?;
    decimal overallbalance?;
    decimal overallunbilledorders?;
    decimal rangeHigh?;
    decimal rangeLow?;
    decimal total?;
    decimal totalCostEstimate?;
    decimal weightedTotal?;
    decimal primarycurrency?;
    decimal primarycurrencyfxrate?;


};

# Represents the writable `Partner` NetSuite record.
# |                                            |
# |:-------------------------------------------|
# | id - The internal ID of the record         |
# | externalId - The external ID of the record |
# | links - The HATEOAS links                  |
# | refName - The reference name               |
#
# + entityId - The unique name of the partner
# + companyName - The legal name of the partner's company, which is a mandatory attribute
# + subsidiary - The associated `Subsidiary`, which is a mandatory attribute
# + partnerCode - The unique code to identify the partner
# + isPerson - The type of the partner whether its a company or individual
# + url - The Partner's Web Site address or URL
# + category - The role category, which applies to the partner
public type Partner record {
    *NsResource;
    string entityId?;
    string companyName?;
    Subsidiary subsidiary?;
    string partnerCode?;
    boolean isPerson?;
    string url?;
    ItemCollection category?;
};

# Represents the writable `Vendor` NetSuite record.
# |                                            |
# |:-------------------------------------------|
# | id - The internal ID of the record         |
# | externalId - The external ID of the record |
# | links - The HATEOAS links                  |
# | refName - The reference name               |
#
# + companyName - The legal name of the vendor's company, which is a mandatory attribute
# + subsidiary - The associated `Subsidiary`
# + entityId - The unique name of the vendor
# + addressbook - The collection of addresses associated to the vendor
# + balance - The balance of the vendor account
# + currency - The base currency used by the vendor
# + currencylist - The list of currecncies used by the vendor
# + isinactive - Whether the record is no longer active or used in the account
# + isPerson - The type of the vendor whether its a company or individual
# + lastModifiedDate - The last modified date of the record
# + workCalendar - The work schedule of the week
public type Vendor record {
    *NsResource;
    string companyName?;
    Subsidiary subsidiary?;
    string entityId?;
    AddressbookCollection addressBook?;
    decimal balance?;
    Currency currency?;
    CurrencylistCollection currencylist?;
    boolean isInactive?;
    boolean isPerson?;
    string lastModifiedDate?;
    NsResource workCalendar?;
    //----------------SLP4 Update Temp WorkArounds--------------
    decimal balancePrimary?;
    SubMachine subMachine?;
    decimal unbilledOrders?;
    decimal unbilledOrdersPrimary?;

};

//----------------SLP4 Update Temp WorkArounds--------------
public type SubMachine record{
    Link[] links?;
    SubMachineItems[] items?;

};
public type SubMachineItems record{
    Link[] links?;
    decimal balance?;
    decimal baseBalance?;
    decimal baseUnbilledOrders?;
    Subsidiary subsidiary?;
    decimal unbilledOrders?;

};





# Represents the writable `VendorBill` NetSuite record.
# |                                            |
# |:-------------------------------------------|
# | id - The internal ID of the record         |
# | externalId - The external ID of the record |
# | links - The HATEOAS links                  |
# | refName - The reference name               |
#
# + entity - The entity such as customer, partner, ..etc that the vendor bill belongs to, which is a mandatory attribute
# + tranId - The vendor bill number, which is a mandatory attribute
# + item - The collection of items available in the vendor bill, which is a mandatory attribute
# + userTotal - The total amount of the vendor bill
# + class - The classification of the vendor bill
# + currency - The base currency used by the vendor bill
# + subsidiary - The associated `Subsidiary`
# + trandate - The transaciton date
# + postingperiod - The accounting period
# + memo - The memo to describe the vendor bill
public type VendorBill record {
    *NsResource;
    Entity entity?;
    string tranId?;
    ItemCollection item?;
    decimal userTotal?;
    Classification 'class?;
    Currency currency?;
    Subsidiary subsidiary?;
    string trandate?;
    AccountingPeriod postingperiod?;
    string memo?;
    //----------------SLP4 Update Temp WorkArounds--------------
    decimal discpct?;
    decimal total?;
    decimal balance?;
    decimal exchangeRate?;


};

# Represents the writable `ServiceItem` NetSuite record.
# |                                            |
# |:-------------------------------------------|
# | id - The internal ID of the record         |
# | externalId - The external ID of the record |
# | links - The HATEOAS links                  |
# | refName - The reference name               |
# | itemId - The unique item ID                |
# | itemType - The type of item                |
# | taxSchedule - The item tax schedule        |
# | subsidiary - The associated `Subsidiary`   |
# | sitecategory - The category of the item to be listed on the website |
# | displayName - The public name to be appeared in sales forms |
# | createdDate - The item created date in the account  |
# | lastModifiedDate - The last modified date of the record |
# | incomeAccount - The income account associate with the item  |
# | isInactive - Whether the record is no longer active or used in the account  |
#
# + serviceItemType - The description of the item
# + subtype - The sub type of the service item
# + VSOESopGroup - The allocation type [Exclude, Normal, Software]
# + VSOEDelivered - Whether the default as delivered
public type ServiceItem record {
    *Item;
    string serviceItemType?;
    string subtype?;
    string VSOESopGroup?;
    boolean VSOEDelivered?;
};

# Represents the writable `NonInventoryItem` NetSuite record.
# |                                            |
# |:-------------------------------------------|
# | id - The internal ID of the record         |
# | externalId - The external ID of the record |
# | links - The HATEOAS links                  |
# | refName - The reference name               |
# | itemId - The unique item ID                |
# | itemType - The type of item                |
# | taxSchedule - The item tax schedule        |
# | subsidiary - The associated `Subsidiary`   |
# | sitecategory - The category of the item to be listed on the website |
# | displayName - The public name to be appeared in sales forms |
# | createdDate - The item created date in the account  |
# | lastModifiedDate - The last modified date of the record |
# | incomeAccount - The income account associate with the item  |
# | isInactive - Whether the record is no longer active or used in the account  |
#
# + subtype - The sub type of item
# + isFulfillable - Whether the item can be fulfilled
# + VSOESopGroup - The allocation type [Exclude, Normal, Software]
# + VSOEDelivered - Whether the default as delivered
# + nonInventoryItemType - The description of the item
# + productfeed - The feed related to product item
public type NonInventoryItem record {
    *Item;
    string subtype?;
    boolean isFulfillable?;
    string VSOESopGroup?;
    boolean VSOEDelivered?;
    string nonInventoryItemType?;
    NsResource productfeed?;
    //----------------SLP4 Update Temp WorkArounds--------------
     PriceList price?;

};

//----------------SLP4 Update Temp WorkArounds--------------
public type PriceList record{
    Link[] links?;
    PriceItem[] items?;
};
public type PriceItem record{
    Link[] links?;
    decimal price?;
    decimal discountDisplay?;
    
};

# Represents the writable `InventoryItem` NetSuite record.
# |                                            |
# |:-------------------------------------------|
# | id - The internal ID of the record         |
# | externalId - The external ID of the record |
# | links - The HATEOAS links                  |
# | refName - The reference name               |
# | itemId - The unique item ID                |
# | itemType - The type of item                |
# | taxSchedule - The item tax schedule        |
# | subsidiary - The associated `Subsidiary`   |
# | sitecategory - The category of the item to be listed on the website |
# | displayName - The public name to be appeared in sales forms |
# | createdDate - The item created date in the account  |
# | lastModifiedDate - The last modified date of the record |
# | incomeAccount - The income account associate with the item  |
# | isInactive - Whether the record is no longer active or used in the account  |
#
# + inventoryItemType - The description of the item
# + VSOESopGroup - The allocation type [Exclude, Normal, Software]
# + VSOEDelivered - Whether the default as delivered
# + productfeed - The feed related to product item
public type InventoryItem record {
    *Item;
    string inventoryItemType?;
    string VSOESopGroup?;
    boolean VSOEDelivered?;
    NsResource productfeed?;
   
};
# Represents the writable `InventoryItem` NetSuite record.
# |                                            |
# |:-------------------------------------------|
# | id - The internal ID of the record         |
# | externalId - The external ID of the record |
# | links - The HATEOAS links                  |
# | refName - The reference name               |
# | itemId - The unique item ID                |
# | itemType - The type of item                |
# | taxSchedule - The item tax schedule        |
# | subsidiary - The associated `Subsidiary`   |
# | sitecategory - The category of the item to be listed on the website |
# | displayName - The public name to be appeared in sales forms |
# | createdDate - The item created date in the account  |
# | lastModifiedDate - The last modified date of the record |
# | incomeAccount - The income account associate with the item  |
# | isInactive - Whether the record is no longer active or used in the account  |
#
# + otherChargeItemType - The description of the item
# + VSOESopGroup - The allocation type [Exclude, Normal, Software]
# + VSOEDelivered - Whether the default as delivered
public type OtherChargeItem record {
    *Item;
    string otherChargeItemType?;
    string VSOESopGroup?;
    boolean VSOEDelivered?;
};

# Represents the writable `InventoryItem` NetSuite record.
# |                                            |
# |:-------------------------------------------|
# | id - The internal ID of the record         |
# | externalId - The external ID of the record |
# | links - The HATEOAS links                  |
# | refName - The reference name               |
# | itemId - The unique item ID                |
# | itemType - The type of item                |
# | taxSchedule - The item tax schedule        |
# | subsidiary - The associated `Subsidiary`   |
# | sitecategory - The category of the item to be listed on the website |
# | displayName - The public name to be appeared in sales forms |
# | createdDate - The item created date in the account  |
# | lastModifiedDate - The last modified date of the record |
# | incomeAccount - The income account associate with the item  |
# | isInactive - Whether the record is no longer active or used in the account  |
#
# + shipItemType - The description of the item type
# + description - The description of the item
# + edition - The edition
# + shipItemCurrency - The associated currency name
# + omitPackaging - Whether to omit the packaging
public type ShipItem record {
    *Item;
    string shipItemType?;
    string description?;
    string edition?;
    string shipItemCurrency?;
    boolean omitPackaging?;
};

# Represents the writable `DiscountItem` NetSuite record.
# |                                            |
# |:-------------------------------------------|
# | id - The internal ID of the record         |
# | externalId - The external ID of the record |
# | links - The HATEOAS links                  |
# | refName - The reference name               |
# | itemId - The unique item ID                |
# | itemType - The type of item                |
# | taxSchedule - The item tax schedule        |
# | subsidiary - The associated `Subsidiary`   |
# | sitecategory - The category of the item to be listed on the website |
# | displayName - The public name to be appeared in sales forms |
# | createdDate - The item created date in the account  |
# | lastModifiedDate - The last modified date of the record |
# | incomeAccount - The income account associate with the item  |
# | isInactive - Whether the record is no longer active or used in the account  |
#
# + discountItemType - The description of the item type
# + account - The associated `Account`
# + rate - The discount rate
public type DiscountItem record {
    *Item;
    string discountItemType?;
    Account account?;
    int|decimal rate?;
};

# Represents the writable `DiscountItem` NetSuite record.
# |                                            |
# |:-------------------------------------------|
# | id - The internal ID of the record         |
# | externalId - The external ID of the record |
# | links - The HATEOAS links                  |
# | refName - The reference name               |
# | itemId - The unique item ID                |
# | itemType - The type of item                |
# | taxSchedule - The item tax schedule        |
# | subsidiary - The associated `Subsidiary`   |
# | sitecategory - The category of the item to be listed on the website |
# | displayName - The public name to be appeared in sales forms |
# | createdDate - The item created date in the account  |
# | lastModifiedDate - The last modified date of the record |
# | incomeAccount - The income account associate with the item  |
# | isInactive - Whether the record is no longer active or used in the account  |
#
# + account - The associated `Account`
# + class - The classification of the `PaymentItem`
# + department - The associated `Department`
# + paymentMethod - The associated `PaymentMethod`
public type PaymentItem record {
    *Item;
    Account account?;
    Classification 'class?;
    Department department?;
    PaymentMethod paymentMethod?;
};

# Represents the writable `PaymentMethod` NetSuite record.
# |                                            |
# |:-------------------------------------------|
# | id - The internal ID of the record         |
# | externalId - The external ID of the record |
# | links - The HATEOAS links                  |
# | refName - The reference name               |
#
# + paymentMethodType - The type of the payment method type
# + account - The associated `Account`
# + creditCard - Whether the method is credit card
# + isDebitCard - Whether the method is debit card
# + isOnline - Whether the payment to be displayed in Web Site
# + isinactive - Whether the record is no longer active or used in the account
# + merchantAccounts - The collection of merchant accounts
# + name - The unique method name
# + visuals - The collection of visuals
public type PaymentMethod record {
    *NsResource;
    string paymentMethodType?;
    Account account?;
    boolean creditCard?;
    boolean isDebitCard?;
    boolean isOnline?;
    boolean isinactive?;
    Collection merchantAccounts?;
    string name?;
    VisualsCollection visuals?;
};

# Represents the writable `Department` NetSuite record.
# |                                            |
# |:-------------------------------------------|
# | id - The internal ID of the record         |
# | externalId - The external ID of the record |
# | links - The HATEOAS links                  |
# | refName - The reference name               |
#
# + departmentType - The description of the department type
# + includechildren - Whether to include children
# + isinactive - Whether the record is no longer active or used in the account
# + name - The unique department name
# + subsidiary - The associated `Subsidiary` collection
public type Department record {
    *NsResource;
    string departmentType?;
    boolean includechildren?;
    boolean isinactive?;
    string name?;
    Collection subsidiary?;
};

# Represents the writable `Location` NetSuite record.
# |                                            |
# |:-------------------------------------------|
# | id - The internal ID of the record         |
# | externalId - The external ID of the record |
# | links - The HATEOAS links                  |
# | refName - The reference name               |
#
# + locationType - The description of the location type
# + isinactive - Whether the record is no longer active or used in the account
# + name - The location name
# + subsidiary - The associated `Subsidiary` collection
# + timeZone - The related timezone
# + latitude - The latitude of the location
public type Location record {
    *NsResource;
    string locationType?;
    boolean isinactive?;
    string name?;
    Collection subsidiary?;
    string timeZone?;
    int|decimal latitude?;
};

# Represents the writable `Contact` NetSuite record.
# |                                            |
# |:-------------------------------------------|
# | id - The internal ID of the record         |
# | externalId - The external ID of the record |
# | links - The HATEOAS links                  |
# | refName - The reference name               |
#
# + entityId - The unique name of the Contact
# + subsidiary - The associated `Subsidiary`
# + addressbook - The collction of addressbook
# + company - The associated `Entity` [customer, partner, vendor, entity, employee, contact]
# + category - The collction of category
# + owner - The owner id
# + isinactive - Whether the record is no longer active or used in the account
# + defaultAddress - The default address
# + dateCreated - The item created date in the account
# + lastModifiedDate - The last modified date of the record
public type Contact record {
    *NsResource;
    string entityId?;
    Subsidiary subsidiary?;
    AddressbookCollection addressbook?;
    Entity company?;
    Collection category?;
    int owner?;
    boolean isinactive?;
    string defaultAddress?;
    string dateCreated?;
    string lastModifiedDate?;
};

# Represents the writable `Employee` NetSuite record.
# |                                            |
# |:-------------------------------------------|
# | id - The internal ID of the record         |
# | externalId - The external ID of the record |
# | links - The HATEOAS links                  |
# | refName - The reference name               |
#
# + entityId - The unique name of the `Employee`, which is a mandatory attribute
# + subsidiary - The associated `Subsidiary`, which is a mandatory attribute
# + currency - The associated `Currency`, which is a mandatory attribute
# + title - The title of the `Employee`
# + currencylist - The collction of currency list
# + addressbook - The collction of addressbook
# + firstName - The collction of addressbook
# + lastName - The collction of addressbook
# + isinactive - Whether the record is no longer active or used in the account
# + dateCreated - The record created date in the account
# + lastModifiedDate - The last modified date of the record
# + email - The employee email
# + workCalendar - The work schedule of the week
# + defaultexpensereportcurrency - The default expense report currency
# + class - The classification of the `PaymentItem`
# + department - The associated `Department`
# + location - The associated `Location`
public type Employee record {
    *NsResource;
    string entityId?;
    Subsidiary subsidiary?;
    Currency currency?;
    string title?;
    CurrencylistCollection currencylist?;
    AddressbookCollection addressbook?;
    string firstName?;
    string lastName?;
    boolean isInactive?;
    string dateCreated?;
    string lastModifiedDate?;
    string email?;
    NsResource workCalendar?;
    NsResource defaultexpensereportcurrency?;
    Classification 'class?;
    Department department?;
    Location location?;
    //----------------SLP4 Update Temp WorkArounds--------------
    decimal targetUtilization?;
    decimal purchaseorderlimit?;
};

# Represents the writable `PurchaseOrder` NetSuite record.
# |                                            |
# |:-------------------------------------------|
# | id - The internal ID of the record         |
# | externalId - The external ID of the record |
# | links - The HATEOAS links                  |
# | refName - The reference name               |
#
# + entity - The associated `Entity` [customer, partner, vendor, entity, employee, contact], which is a mandatory attribute
# + item - The collection of items available in the `PurchaseOrder`
# + currency - The associated `Currency`
# + currencyName - The associated `Currency` name
# + currencysymbol - The associated `Currency` symbol
# + employee - The associated `Employee`
# + entityNexus - The associated entity nexus
# + dateCreated - The record created date in the account
# + lastModifiedDate - The last modified date of the record
# + subsidiary - The associated `Subsidiary`
# + shipAddress - The ship address
# + tranId - The order number
# + trandate - The transaciton date
# + total - The order total
# + class - The classification of the `PaymentItem`
# + department - The associated `Department`
# + location - The associated `Location`
# + shipTo - The related `Customer`, which the order be ship to
# + memo - The memo to describe the sales order
# + billingaddress - The billing address
# + shippingAddress - The shipping address
public type PurchaseOrder record {
    *NsResource;
    Entity entity?;
    ItemCollection item?;
    Currency currency?;
    string currencyName?;
    string currencysymbol?;
    Employee employee?;
    NsResource entityNexus?;
    string dateCreated?;
    string lastModifiedDate?;
    Subsidiary subsidiary?;
    string shipAddress?;
    string tranId?;
    string trandate?;
    decimal total?;
    Classification 'class?;
    Department department?;
    Location location?;
    Customer shipTo?;
    string memo?;
    BillingAddress billingaddress?;
    ShippingAddress shippingAddress?;
    //----------------SLP4 Update Temp WorkArounds--------------
    decimal exchangeRate?;
    Expense expense?;

};
//----------------SLP4 Update Temp WorkArounds--------------
public type Expense record{
    Link[] links?;
    ExpenseItem[] items?;

};

public type ExpenseItem record{
    Link[] links?;
    decimal amount?;
};
