// Copyright (c) 2021 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

# NetSuite VendorBill type record
#
# + subsidiary - The subsidiary reference  
# + entity - Vendor of the Bill 
@display{label: "New Vendor Bill"} 
public type NewVendorBill record {
    @display{label: "Subsidiary"}
    RecordRef subsidiary?;
    @display{label: "Vendor"}
    RecordRef entity;
    *VendorBillCommon;
};

# NetSuite VendorBill type record
#
# + internalId - Internal Id of the Bill
# + subsidiary - The subsidiary of the bill
# + entity - The vendor of the bill
@display{label: "Vendor Bill"}   
public type VendorBill record {
    @display{label: "Internal ID"}
    string internalId;
    @display{label: "Subsidiary"}
    RecordRef subsidiary?;
    @display{label: "Vendor"}
    RecordRef entity?;
    *VendorBillCommon;
};

# NetSuite VendorBill type record
#
# + createdDate - The created date of the record
# + lastModifiedDate - The last modified date of the record  
# + nexus - This field shows the nexus of the transaction. NetSuite automatically populates this field based on the nexus 
# lookup logic. You can override the transaction nexus and tax registration number that NetSuite automatically selects 
# by checking the Nexus Override box. When you select a different nexus in the dropdown list, the corresponding tax 
# registration number is automatically selected in the Subsidiary Tax Reg. Number field 
# + subsidiaryTaxRegNum - This field shows the tax registration number of the transaction nexus. NetSuite automatically 
# populates this field based on the nexus lookup logic
# + taxRegOverride -  Overrides the values in the Nexus and Subsidiary Tax Reg. Number fields
# + taxDetailsOverride - Override the tax information on the Tax Details subtab of the transaction
# + customForm - The appropriate standard or custom form to use.  
# + billAddressList - The billing address displayed in the Vendor field
# + account - The Accounts Payable account that will be affected by this transaction  
# + approvalStatus - The approval status of this bill 
# + nextApprover - The next person set to approve this bill via approval routing 
# + vatRegNum - The vat Registration Number
# + postingPeriod - Required on Add when the Accounting Periods feature is enabled
# + tranDate - Required on Add. Defaults to the current date 
# + currencyName - A read only field that defaults to the currency associated with the customer referenced by the entity field 
# + billingAddress - The billing address of the bill
# + exchangeRate - Required on Add. Defaults to the rate associated with the Vendor set in the entity field. 
# + entityTaxRegNum - The tax registration number for this entity displays here 
# + taxPointDate - Tax point date is a legal requirement in many countries
# + terms - NetSuite multiplies the tax rate by the taxable total of line items and enters it here  
# + dueDate - Sets the due date for the bill. Defaults to the current date.  
# + discountDate - A read-only field that returns the last day you can pay this bill in order to receive a discount
# + tranId - Sets the number to identify this transaction, such as the vendor's invoice number.  
# + userTotal - A read-only field that returns the total amount of the transaction
# + discountAmount - A read-only field that returns the amount discounted on this bill
# + taxTotal - NetSuite multiplies the tax rate by the taxable total of line items and enters it here 
# + paymentHold - The Payment Hold box to apply a payment hold on a disputed bill
# + memo - A memo that will appear on such reports as the 2-line Accounts Payable Register
# + tax2Total - NetSuite multiplies the tax rate by the taxable total of line items and enters it here
# + creditLimit - This is a read-only field that returns the credit limit set for the vendor 
# + availableVendorCredit - From the web services perspective, this field is available only with the get, getList, and asyncGetList operations
# + currency - The transaction currency for this bill is shown here  
# + 'class - The class that applies to this item  
# + department - References a value in a user-defined list at Setup > Company > Classifications > Departments
# + location - A location to associate with this line item 
# + status - VendorBill status 
# + landedCostMethod - 	Available values are: _quantity _value _weight
# + landedCostPerLine - Check this box to enter a landed cost per line item  
# + transactionNumber - By default, transaction lists display only the Number field in searches and reporting 
# + overrideInstallments - This box to override the default calculated installment amounts and enter custom ones
# + expenseList - The expense list  
# + accountingBookDetailList - The accounting book list 
# + itemList - The item list 
# + installmentList - The installment list  
# + landedCostsList - The landed costs list
# + purchaseOrderList - The purchase order list 
# + taxDetailsList - The tax details list 
# + customFieldList - The custom field list
public type VendorBillCommon record {
    @display{label: "Created Date"}
    string createdDate?;
    @display{label: "Last Modified Date"}
    string lastModifiedDate?;
    @display{label: "Nexus"}
    RecordRef nexus?;
    @display{label: "Subsidiary Tax Reg Number"}
    RecordRef subsidiaryTaxRegNum?;
    @display{label: "Tax Reg Override"}
    boolean taxRegOverride?;
    @display{label: "Tax Details Override"}
    boolean taxDetailsOverride?;
    @display{label: "Custom Form"}
    RecordRef customForm?;
    @display{label: "Bill Address List"}
    RecordRef billAddressList?;
    @display{label: "Account"}
    RecordRef account?;
    @display{label: "Approval Status"}
    RecordRef approvalStatus?;
    @display{label: "Next Approver"}
    RecordRef nextApprover?;
    @display{label: "VAT Reg Number"}
    string vatRegNum?;
    @display{label: "Posting Period"}
    RecordRef postingPeriod?;
    @display{label: "Transaction Date"}
    string tranDate?;
    @display{label: "Currency Name"}
    string currencyName?;
    @display{label: "Billing Address"}
    Address billingAddress?;
    @display{label: "Exchange Rate"}
    decimal? exchangeRate?;
    @display{label: "Entity Tax Reg Number"}
    RecordRef entityTaxRegNum?;
    @display{label: "Tax Point Date"}
    string taxPointDate?;
    @display{label: "Terms"}
    RecordRef terms?;
    @display{label: "Due Date"}
    string dueDate?;
    @display{label: "Discount Date"}
    string discountDate?;
    @display{label: "Transaction ID"}
    string tranId?;
    @display{label: "User Total"}
    decimal? userTotal?;
    @display{label: "Discount Amount"}
    decimal? discountAmount?;
    @display{label: "Tax Total"}
    decimal? taxTotal?;
    @display{label: "Payment Hold"}
    boolean paymentHold?;
    @display{label: "Memo"}
    string memo?;
    @display{label: "Tax2 Total"}
    decimal? tax2Total?;
    @display{label: "Credit Limit"}
    decimal? creditLimit?;
    @display{label: "Available Vendor Credit"}
    decimal? availableVendorCredit?;
    @display{label: "Currency"}
    RecordRef currency?;
    @display{label: "Class"}
    RecordRef 'class?;
    @display{label: "Department"}
    RecordRef department?;
    @display{label: "Location"}
    RecordRef location?;
    @display{label: "Status"}
    string status?;
    @display{label: "Landed Cost Method"}
    string landedCostMethod?;
    @display{label: "Landed Cost Per Line"}
    boolean landedCostPerLine?;
    @display{label: "Transaction Number"}
    string transactionNumber?;
    @display{label: "Override Installments"}
    boolean overrideInstallments?;
    @display{label: "Expense List"}
    VendorBillExpenseList expenseList?;
    @display{label: "Accounting Book Detail List"}
    AccountingBookDetailList accountingBookDetailList?;
    @display{label: "Item List"}
    VendorBillItemList itemList?;
    @display{label: "Installment List"}
    Installment[] installmentList?;
    @display{label: "Landed Costs List"}
    PurchLandedCostList landedCostsList?;
    @display{label: "Purchase Order List"}
    RecordRef[] purchaseOrderList?;
    @display{label: "Tax Details List"}
    TaxDetailsList taxDetailsList?;
    @display{label: "Custom Field List"}
    CustomFieldList customFieldList?;
};

# Represents TaxDetailsList type record
#
# + replaceAll - Whether to replace current values
# + taxDetails - Array of tax detail records  
public type TaxDetailsList record {
    boolean replaceAll = true;
    TaxDetails[] taxDetails;
};

# Represents PurchLandedCostList type record
#
# + replaceAll - Whether to replace current values  
# + landedCosts - The landed costs 
public type PurchLandedCostList record {|
    boolean replaceAll = true;
    LandedCostSummary[] landedCosts;

|};

# Represents tax details
#
# + taxDetailsReference - Tax details reference  
# + lineType - Type of the line  
# + lineName - Name of the line  
# + netAmount - Net amount 
# + grossAmount - Gross amount
# + taxType - Type of the tax
# + taxCode - Tax code 
# + taxBasis - Tax basis
# + taxRate - Tax rates
# + taxAmount - Tax amount  
# + calcDetail - Calculation details
public type TaxDetails record {
    string taxDetailsReference?;
    string lineType?;
    string lineName?;
    decimal netAmount?;
    decimal grossAmount?;
    RecordRef taxType?;
    RecordRef taxCode?;
    decimal taxBasis?;
    decimal taxRate?;
    decimal taxAmount?;
    string calcDetail?;
};

# NetSuite LandedCostSummary type record
#
# + category - The category of the landed cost summary 
# + amount - The amount  
# + 'source - The source of the landed cost summary  
# + 'transaction - Reference to landed cost summary  
public type LandedCostSummary record {
    RecordRef category?;
    decimal amount?;
    string 'source?;
    RecordRef 'transaction?;
};


# NetSuite Installment type record
#
# + amount - The amount  
# + dueDate - The due date   
# + amountDue - The due amount    
# + seqNum - Sequence number
# + status - The status  
public type Installment record {|
    string amount?;
    string dueDate?;
    decimal amountDue?;
    int seqNum?;
    string status?;
|};

# NetSuite VendorBillExpenseList type record
#
# + replaceAll - Whether to replace current values
# + expenses - An array of expenses  
public type VendorBillExpenseList record {|
    boolean replaceAll = true;
    VendorBillExpense[] expenses; 
|};

# NetSuite VendorBillExpense type record
#
# + orderDoc - Netsuite expenses orderDoc value  
# + orderLine - The order line  
# + line - The line number of Netsuite list 
# + category - The expense category  
# + account - The Accounts Payable account that will be affected by this transaction  
# + amount - The expense amount
# + taxAmount - The tax amount  
# + tax1Amt - The tax amount  
# + memo - A memo that will appear on such reports as the 2-line Accounts Payable Register 
# + grossAmt - The gross amount  
# + taxDetailsReference - Tax details reference  
# + department - The department that applies to this item
# + 'class - The class that applies to this item
# + location - The location of the item
# + customer - The Customer of the expense  
# + isBillable - Whether this is billable or not 
# + projectTask - The project task 
# + taxCode - Tax code  
# + taxRate1 - Tax rate 1
# + taxRate2 - Tax rate 2
# + amortizationSched - Amortization schedule 
# + amortizStartDate - Amortization start date
# + amortizationEndDate - Amortization end date
# + amortizationResidual - Amortization residual
# + customFieldList - Custom field list
public type VendorBillExpense record {
    int? orderDoc?;
    int? orderLine?;
    int? line;
    RecordRef category?;
    RecordRef account?;
    decimal? amount;
    decimal? taxAmount?;
    decimal? tax1Amt?;
    string memo?;
    decimal? grossAmt?;
    string taxDetailsReference?;
    RecordRef department?;
    RecordRef 'class?;
    RecordRef location?;
    RecordRef customer?;
    boolean isBillable?;
    RecordRef projectTask?;
    RecordRef taxCode?;
    decimal? taxRate1?;
    decimal? taxRate2?;
    RecordRef amortizationSched?;
    string amortizStartDate?;
    string amortizationEndDate?;
    string amortizationResidual?;
    CustomFieldList customFieldList?;
};

# NetSuite AccountingBookDetailList type record
#
# + replaceAll - Whether to replace the current values
# + accountingBookDetail - An array of accounting book details  
public type AccountingBookDetailList record {|
    boolean replaceAll = true;
    AccountingBookDetail[] accountingBookDetail;
|};

# NetSuite AccountingBookDetail type record
#
# + accountingBook - Accounting Book  
# + currency - The currency is used
# + exchangeRate - The exchange rate  
public type AccountingBookDetail record {|
    RecordRef accountingBook?;
    RecordRef currency?;
    decimal? exchangeRate?;
|};

# NetSuite VendorBillItemList type record
#
# + replaceAll - Whether to replace current values  
# + item - An array of VendorBillItem records  
public type VendorBillItemList record {|
    boolean replaceAll = true;
    VendorBillItem[] item;
|};

# NetSuite VendorBillItem type record
#
# + item - The vendorBill item  
# + vendorName - Name of the vendor  
# + line - The line number  
# + orderDoc - The order doc  
# + orderLine - The order line  
# + quantity - The quantity  
# + unit - The unit  
# + inventoryDetail - The inventory details  
# + description - Description on the item  
# + serialNumbers - Serial num  
# + binNumbers - The bin numbers  
# + expirationDate - The expiration date  
# + taxCode -   Tax code
# + taxRate1 - Tax rate1  
# + taxRate2 - Tax rate2  
# + grossAmt - Gross amount 
# + tax1Amt - Tax amount  
# + rate - The vendorBillItem rate value
# + amount - The amount  
# + options - The options of the vendorBillItem  
# + department - The department of the item  
# + 'class - The class of the item  
# + location - The location of the item  
# + customer - The customer of the item  
# + landedCostCategory - The landed cost category  
# + isBillable - Whether item is billable or not  
# + billVarianceStatus - The bill variance status  
# + billreceiptsList - The bill receipt list  
# + amortizStartDate - Amortization start date  
# + amortizationEndDate - Amortization end date  
# + amortizationResidual - Amortization residual  
# + taxAmount - The tax amount  
# + taxDetailsReference - The Details reference  
# + landedCost - The landed cost  
# + customFieldList - The custom field list  
public type VendorBillItem record {
    RecordRef item?;
    string vendorName?;
    int line?;
    int orderDoc?;
    int orderLine?;
    decimal? quantity?;
    RecordRef unit?;
    InventoryAssignmentList inventoryDetail?;
    string description?;
    string serialNumbers?;
    string binNumbers?;
    string expirationDate?;
    RecordRef taxCode?;
    decimal? taxRate1?;
    decimal? taxRate2?;
    decimal? grossAmt?;
    decimal? tax1Amt?;
    string rate?;
    decimal amount?;
    CustomFieldList options?;
    RecordRef department?;
    RecordRef 'class?;
    RecordRef location?;
    RecordRef customer?;
    RecordRef landedCostCategory?;
    boolean isBillable?;
    string billVarianceStatus?;
    RecordRef[] billreceiptsList?;
    string amortizStartDate?;
    string amortizationEndDate?;
    string amortizationResidual?;
    decimal? taxAmount?;
    string taxDetailsReference?;
    LandedCostDataList landedCost?;
    CustomFieldList customFieldList?;
};


# NetSuite LandedCostDataList type record
#
# + landedCostData - An array of landed cost data  
public type LandedCostDataList record {
    LandedCostData[] landedCostData;
};

# NetSuite LandedCostData type record
#
# + costCategory - The cost category  
# + amount - The amount  
public type LandedCostData record {
    RecordRef costCategory?;
    decimal amount?;
};

# NetSuite InventoryAssignmentList type record
#
# + inventoryAssignment - An array of inventory assignments  
# + customForm - Reference to a custom form  
public type InventoryAssignmentList record {
    InventoryAssignment[] inventoryAssignment;
    RecordRef? customForm;
};

# NetSuite InventoryAssignment type record
#
# + internalId - The internal ID of the inventory assignment
# + issueInventoryNumber - The issue inventory number  
# + receiptInventoryNumber - The receipt inventory number  
# + binNumber - Bin number  
# + toBinNumber - To Bin number  
# + quantity - The quantity  
# + expirationDate - The expiration date  
# + quantityAvailable - The available quantity  
# + inventoryStatus - The inventory status  
# + toInventoryStatus - To inventory status  
public type InventoryAssignment record {
    string internalId?;
    RecordRef issueInventoryNumber?;
    string receiptInventoryNumber?;
    RecordRef binNumber?;
    RecordRef toBinNumber?;
    decimal quantity?;
    string expirationDate?;
    decimal quantityAvailable?;
    RecordRef inventoryStatus?;
    RecordRef toInventoryStatus?;
};
