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
public type Customer record {
    *NsResource;
    string entityId;
    string companyName;
    Subsidiary subsidiary;
    boolean isPerson?;
    Currency currency?;
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
    float exchangeRate?;
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
    Classification class?;
    string tranId?;
    AccountingPeriod postingperiod?;
    string trandate?;
    string memo?;
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
public type Classification record { //complete, all fields added
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
    Customer customer;
    float payment;
    Currency currency?;
    Account araccount?;
    string tranId?;
    float exchangeRate?;
    string trandate?;
    AccountingPeriod postingperiod?;
    string memo?;
    float balance?;
    float pending?;
    Subsidiary subsidiary?;
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
    float probability?;
    string expectedCloseDate?;
    NsResource winLossReason?;
    string memo?;
    float projectedtotal?;
    Currency currency?;
    Subsidiary subsidiary?;
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
    string companyName;
    Subsidiary subsidiary;
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
# + companyName - The
# + subtype - The sub type of item
# + itemId - The unique item id
public type Vendor record {
    *NsResource;
    string companyName;
    Subsidiary subsidiary?;
    string entityId?;
    AddressBook addressbook?;
    float balance?;
    Currency currency?;
    boolean isinactive?;
    boolean isPerson?;
    string lastModifiedDate?;
    NsResource workCalendar?;
};

# Represents the writable `VendorBill` NetSuite record.
# |                                            |
# |:-------------------------------------------|
# | id - The internal ID of the record         |
# | externalId - The external ID of the record |
# | links - The HATEOAS links                  |
# | refName - The reference name               |
#
# + entity - The entity such as customer, partner, ..etc that the invoice belongs to, which is a mandatory attribute
# + item - The collection of items available in the invoice, which is a mandatory attribute
# + class - The classification of the invoice, which is a mandatory attribute
# + tranId - The invoice number
# + postingperiod - The accounting period
# + trandate - The transaciton date
# + memo - The memo to describe the invoice
public type VendorBill record {
    *NsResource;
    Entity entity;
    string tranId;
    ItemCollection item;
    float userTotal?;
    Classification class?;
    Currency currency?;
    Subsidiary subsidiary?;
    string trandate?;
    AccountingPeriod postingperiod?;
    string memo?;
};

# Represents the writable `ServiceItem` NetSuite record.
# |                                            |
# |:-------------------------------------------|
# | id - The internal ID of the record         |
# | externalId - The external ID of the record |
# | links - The HATEOAS links                  |
# | refName - The reference name               |
#
# + entity - The entity such as customer, partner, ..etc that the invoice belongs to, which is a mandatory attribute
# + item - The collection of items available in the invoice, which is a mandatory attribute
# + class - The classification of the invoice, which is a mandatory attribute
# + tranId - The invoice number
# + postingperiod - The accounting period
# + trandate - The transaciton date
# + memo - The memo to describe the invoice
public type ServiceItem record {
    *Item;
    string serviceItemType?;
    string subtype?;
    string VSOESopGroup?;
    boolean VSOEDelivered?;
    NsResource productfeed?;
};

# Represents the writable `NonInventoryItem` NetSuite record.
#
# + id - The internal ID of the record
# + subtype - The sub type of item
# + itemId - The unique item ID
public type NonInventoryItem record {
    *Item;
    string subtype?; //
    boolean isFulfillable?; //
    string VSOESopGroup?;
    boolean VSOEDelivered?;
    string nonInventoryItemType?;
    NsResource productfeed?;

};

# Represents the writable `InventoryItem` NetSuite record.
#
# + id - The internal ID of the record
# + subtype - The sub type of item
# + itemId - The unique item id
public type InventoryItem record {
    *Item;
    string inventoryItemType?;
    string VSOESopGroup?;
    boolean VSOEDelivered?;
    NsResource productfeed?;
};

# Represents the writable `InventoryItem` NetSuite record.
#
# + id - The internal ID of the record
# + subtype - The sub type of item
# + itemId - The unique item id
public type OtherChargeItem record {
    *Item;
    string otherChargeItemType?;
    string VSOESopGroup?;
    boolean VSOEDelivered?;
};

# Represents the writable `InventoryItem` NetSuite record.
#
# + id - The internal ID of the record
# + subtype - The sub type of item
# + itemId - The unique item id
public type ShipItem record {
    *Item;
    string shipItemType?;
    string description?;
    string edition?;
    string shipItemCurrency?;
    boolean omitPackaging?;
};

# Represents the writable `DiscountItem` NetSuite record.
#
# + id - The internal ID of the record
# + subtype - The sub type of item
# + itemId - The unique item id
public type DiscountItem record {
    *Item;
    string discountItemType?;
    Account account?;
    float rate?;
    string description?;
    string edition?;
    string shipItemCurrency?;
    boolean omitPackaging?;
};

# Represents the writable `DiscountItem` NetSuite record.
#
# + id - The internal ID of the record
# + subtype - The sub type of item
# + itemId - The unique item id
public type PaymentItem record {
    *Item;
    Account account?;
    Classification class?;
    Department department?;
    PaymentMethod paymentMethod?;
};

# Represents the writable `PaymentMethod` NetSuite record.
#
# + id - The internal ID of the record
# + subtype - The sub type of item
# + itemId - The unique item id
public type PaymentMethod record {
    *NsResource;
    string paymentMethodType?;
    Account account?;
    boolean creditCard?;
    boolean isDebitCard?;
    boolean isOnline?;
    boolean isinactive?;
    ItemCollection merchantAccounts?;
    string name?;
    ItemCollection visuals?;
};

# Represents the writable `Department` NetSuite record.
#
# + id - The internal ID of the record
# + subtype - The sub type of item
# + itemId - The unique item id
public type Department record {
    *NsResource;
    string departmentType?;
    boolean includechildren?;
    boolean isinactive?;
    string name?;
    ItemCollection subsidiary?;
};

# Represents the writable `Location` NetSuite record.
#
# + id - The internal ID of the record
# + subtype - The sub type of item
# + itemId - The unique item id
public type Location record {
    *NsResource;
    string locationType?;
    boolean isinactive?;
    string name?;
    ItemCollection subsidiary?;
    string timeZone?;
    float latitude?;
};

