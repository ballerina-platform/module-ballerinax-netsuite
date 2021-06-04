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

# NetSuite general Item record
#
# + subscription - Subscription of salesOrderItem
# + item - References an item type record
# + quantityAvailable - The available quantity  
# + quantityOnHand - Sets the quantity on hand for this item
# + quantity - Quantity of the item
# + units - Number of item units
# + description -Item description 
# + price - Price of the item
# + rate - Defines the rate for this item.   
# + amount - Amount of the item  
# + isTaxable - Shows whether item is taxable
# + location - Locations for details 
public type Item record {
    RecordRef subscription?;
    RecordRef item;
    decimal quantityAvailable?;
    decimal quantityOnHand?;
    decimal quantity?;
    RecordRef units?;
    string description?;
    RecordRef price?;
    string rate?;
    decimal amount;
    boolean isTaxable?;
    RecordRef location?;
};

# Netsuite Sales Order type record
#
# + internalId - Internal Id of the SalesOrder record
# + entity - The customer of the sales Order    
# + itemList - The list of items
public type SalesOrder record {
    string internalId;
    RecordRef entity?;
    Item[] itemList?;
    *SalesOrderCommon;
};

# Netsuite Sales Order type record
# 
# + entity - The customer of the sales Order   
# + itemList - The list of items
public type NewSalesOrder record {
    RecordInputRef entity;
    Item[] itemList;
    *SalesOrderCommon;
};

# Netsuite Sales Order type record
#
# + internalId - InternalId of the salesOrder record in Netsuite   
# + createdDate - created date of the  salesOrder record in Netsuite  
# + customForm - References the customized a sales order form    
# + currency - The currency of the sales Order   
# + drAccount - Deferred revenue reclassification account   
# + fxAccount - Foreign currency adjustment revenue account  
# + tranDate - The posting date of this sales order  
# + tranId - Sales Order number   
# + entityTaxRegNum - The customer's tax registration number associated with this sales order  
# + createdFrom - The opportunity or estimate used to create this sales order   
# + orderStatus - status of sales orders     
# + nextBill - Date of the next bill    
# + opportunity - References an Netsuite Opportunity   
# + salesRep - The sales representative associated with the company on the customer record     
# + partner - A partner to associate with this transaction    
# + salesGroup - A sales team to associate with this transaction  
# + leadSource - The lead source associated with this transaction    
# + startDate - The date for the first invoice to be created   
# + endDate - The end date of the order   
# + memo - A memo to describe this sales order    
# + excludeCommission - Option to exclude this transaction  
# + totalCostEstimate - Estimated Cost    
# + estGrossProfit - Estimated Gross Profit   
# + estGrossProfitPercent - Estimated Gross Profit Margin    
# + exchangeRate - The currency's exchange rate    
# + currencyName - Name of the currency  
# + isTaxable - A check mark in this box if this order is taxable   
# + email - The email address  
# + billingAddress - The billing address
# + shippingAddress - The shipping address 
# + shipDate - Type or pick a shipping date for this order  
# + subTotal - Total before any discounts, shipping cost, handling cost or tax     
# + discountTotal - NetSuite enters the amount discounted on this sales order     
# + total - The total of line items, tax and shipping costs   
# + balance - The balance owed by this customer    
# + status - Status of the sales Order  
# + subsidiary - Subsidiary of the Sales Order  
public type SalesOrderCommon record {
    string internalId?;
    string createdDate?;
    string tranDate?;
    string tranId?;
    SalesOrderStatus|string orderStatus?;
    string nextBill?;
    string startDate?;
    string endDate?;
    string memo?;
    boolean excludeCommission?;
    decimal totalCostEstimate?;
    decimal estGrossProfit?;
    decimal estGrossProfitPercent?;
    decimal exchangeRate?;
    string currencyName?;
    boolean isTaxable?;
    string email?;
    string shipDate?;
    decimal subTotal?;
    decimal discountTotal?;
    decimal total?;
    decimal balance?;
    string status?;
    Address billingAddress?;
    Address shippingAddress?;
    RecordRef subsidiary?;
    RecordRef customForm?;
    RecordRef currency?;
    RecordRef drAccount?;
    RecordRef fxAccount?;
    RecordRef opportunity?;
    RecordRef salesRep?;
    RecordRef partner?;
    RecordRef salesGroup?;
    RecordRef leadSource?;
    RecordRef entityTaxRegNum?;
    RecordRef createdFrom?;
};

# Represents a NetSuite Invoice record
#
# + entity - The customer of the invoice  
# + invoiceId - The Id of the invoice    
# + internalId - The internalId of the invoice  
# + itemList - The item list for the invoice  
public type Invoice record {
    string internalId;
    RecordRef entity?;
    Item[] itemList?;
    string invoiceId?;
    *InvoiceCommon;
};


# Represents a NetSuite Invoice record
#
# + entity - The customer of the invoice  
# + itemList - The item list for the invoice  
public type NewInvoice record {
    RecordInputRef entity;
    Item[] itemList;
    *InvoiceCommon;
};


# Represents a NetSuite Invoice record
#
# + recognizedRevenue - Recognized Revenue: cumulative amount of revenue recognized for this transaction 
# + discountTotal - The amount discounted on this invoice  
# + deferredRevenue - The amount of revenue deferred on this transaction   
# + total - The total of line items, tax and shipping costs 
# + department - A department to associate with this invoice 
# + createdDate - Created date of the invoice  
# + currency - The currency of the invoice  
# + email - References an email for the invoice  
# + lastModifiedDate - The last modified Date of the invoice  
# + status - The status of the Invoice  
# + classification - The classification of the invoice  
# + subsidiary - The subsidiary of the invoice    
# + 'class - The class of the invoice   
public type InvoiceCommon record {
    decimal recognizedRevenue?;
    decimal discountTotal?;
    decimal deferredRevenue?;
    decimal total?;
    string email?;
    string createdDate?;
    string lastModifiedDate?;
    string status?;
    Classification classification?;
    RecordRef currency?;
    RecordRef 'class?;
    RecordRef department?;
    RecordRef subsidiary?;
};

