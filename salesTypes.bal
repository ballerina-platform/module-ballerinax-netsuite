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
# + internalId - Internal ID of the SalesOrder record
# + entity - The customer of the sales Order    
# + itemList - The list of items
@display{label: "Sales Order"}
public type SalesOrder record {
    @display{label: "Internal ID"}
    string internalId;
    @display{label: "Customer"}
    RecordRef entity?;
    @display{label: "Item List"}
    Item[] itemList?;
    *SalesOrderCommon;
};

# Netsuite Sales Order type record
# 
# + entity - The customer of the sales Order   
# + itemList - The list of items
@display{label: "New Sales Order"}
public type NewSalesOrder record {
    @display{label: "Customer"}
    RecordInputRef entity;
    @display{label: "Item List"}
    Item[] itemList;
    *SalesOrderCommon;
};

# Netsuite Sales Order type record
#
# + internalId - InternalId of the salesOrder record in Netsuite   
# + createdDate - created date of the  salesOrder record in Netsuite  
# + customForm - References the customized sales order form    
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
    @display{label: "Internal ID"}
    string internalId?;
    @display{label: "Created Date"}
    string createdDate?;
    @display{label: "Transaction Date"}
    string tranDate?;
    @display{label: "Transaction ID"}
    string tranId?;
    @display{label: "Order Status"}
    SalesOrderStatus|string orderStatus?;
    @display{label: "Next Billing Date"}
    string nextBill?;
    @display{label: "Start Date"}
    string startDate?;
    @display{label: "End Date"}
    string endDate?;
    @display{label: "Memo"}
    string memo?;
    @display{label: "Is Exclude Transaction"}
    boolean excludeCommission?;
    @display{label: "Estimated Cost"}
    decimal totalCostEstimate?;
    @display{label: "Estimated Gross Profit"}
    decimal estGrossProfit?;
    @display{label: "Estimated Gross Percentage"}
    decimal estGrossProfitPercent?;
    @display{label: "Exchange Rate"}
    decimal exchangeRate?;
    @display{label: "Currency Name"}
    string currencyName?;
    @display{label: "Is Taxable"}
    boolean isTaxable?;
    @display{label: "Email"}
    string email?;
    @display{label: "Shiping Date"}
    string shipDate?;
    @display{label: "Sub Total"}
    decimal subTotal?;
    @display{label: "Discount Total"}
    decimal discountTotal?;
    @display{label: "Total"}
    decimal total?;
    @display{label: "Balance"}
    decimal balance?;
    @display{label: "Status"}
    string status?;
    @display{label: "Billing Address"}
    Address billingAddress?;
    @display{label: "Shipping Adderess"}
    Address shippingAddress?;
    @display{label: "Estimated Subsidiary"}
    RecordRef subsidiary?;
    @display{label: "Customized Sales Order Form"}
    RecordRef customForm?;
    @display{label: "Currency"}
    RecordRef currency?;
    @display{label: "DRR Account"}
    RecordRef drAccount?;
    @display{label: "FCAR Account"}
    RecordRef fxAccount?;
    @display{label: "Opportunity"}
    RecordRef opportunity?;
    @display{label: "Sales Representative"}
    RecordRef salesRep?;
    @display{label: "Partner"}
    RecordRef partner?;
    @display{label: "Sales Group"}
    RecordRef salesGroup?;
    @display{label: "Lead Source"}
    RecordRef leadSource?;
    @display{label: "Tax Registration Number"}
    RecordRef entityTaxRegNum?;
    @display{label: "Opportunity Estimate"}
    RecordRef createdFrom?;
};

# Represents a NetSuite Invoice record
#
# + entity - The customer of the invoice  
# + invoiceId - The ID of the invoice    
# + internalId - The internalId of the invoice  
# + itemList - The item list for the invoice 
@display{label: "Invoice"} 
public type Invoice record {
    @display{label: "Internal ID"}
    string internalId;
    @display{label: "Customer"}
    RecordRef entity?;
    @display{label: "Item List"}
    Item[] itemList?;
    @display{label: "Invoice ID"}
    string invoiceId?;
    *InvoiceCommon;
};


# Represents a NetSuite Invoice record
#
# + entity - The customer of the invoice  
# + itemList - The item list for the invoice  
@display{label: "New Invoice"}
public type NewInvoice record {
    @display{label: "Customer"}
    RecordInputRef entity;
    @display{label: "Item List"}
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
    @display{label: "Recognized Revenue"}
    decimal recognizedRevenue?;
    @display{label: "Discount"}
    decimal discountTotal?;
    @display{label: "Deffered Revenue"}
    decimal deferredRevenue?;
    @display{label: "Total Items"}
    decimal total?;
    @display{label: "Email"}
    string email?;
    @display{label: "Created Date"}
    string createdDate?;
    @display{label: "Last Modified Date"}
    string lastModifiedDate?;
    @display{label: "Status"}
    string status?;
    @display{label: "Classification"}
    Classification classification?;
    @display{label: "Currency"}
    RecordRef currency?;
    @display{label: "Class"}
    RecordRef 'class?;
    @display{label: "Department"}
    RecordRef department?;
    @display{label: "Subsidiary"}
    RecordRef subsidiary?;
};

