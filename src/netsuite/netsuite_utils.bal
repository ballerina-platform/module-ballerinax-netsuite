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

import ballerina/http;
import ballerina/log;
import ballerina/stringutils;

isolated function getRecordName(ReadableRecordType|WritableRecordType|SubRecordType recordTypedesc)
                       returns string|Error {
    if (recordTypedesc is typedesc<Customer>) {
        return RECORD_PATH_CUSTOMER;
    } else if (recordTypedesc is typedesc<SalesOrder>) {
        return RECORD_PATH_SALES_ORDER;
    } else if (recordTypedesc is typedesc<Subsidiary>) {
        return RECORD_PATH_SUBSIDIARY;
    } else if (recordTypedesc is typedesc<AddressbookCollection>) {
        return RECORD_PATH_ADDRESSBOOK;
    } else if (recordTypedesc is typedesc<AddressbookAddress>) {
        return RECORD_PATH_ADDRESSBOOK_ADDRESS;
    } else if (recordTypedesc is typedesc<ShippingAddress>) {
        return RECORD_PATH_SHIPPING_ADDRESS;
    } else if (recordTypedesc is typedesc<BillingAddress>) {
        return RECORD_PATH_BILLING_ADDRESS;
    } else if (recordTypedesc is typedesc<Currency>) {
        return RECORD_PATH_CURRENCY;
    } else if (recordTypedesc is typedesc<NonInventoryItem>) {
        return RECORD_PATH_NON_INVENTORY_ITEM;
    } else if (recordTypedesc is typedesc<ItemCollection>) {
        return RECORD_PATH_ITEM_COLLECTION;
    } else if (recordTypedesc is typedesc<VendorBill>) { // VendorBill should come before Invoice
        return RECORD_PATH_VENDOR_BILL;
    } else if (recordTypedesc is typedesc<Invoice>) {
        return RECORD_PATH_INVOICE;
    } else if (recordTypedesc is typedesc<AccountingPeriod>) {
        return RECORD_PATH_ACCOUNTING_PERIOD;
    } else if (recordTypedesc is typedesc<CustomerPayment>) {
        return RECORD_PATH_CUSTOMER_PAYMENT;
    } else if (recordTypedesc is typedesc<Account>) {
        return RECORD_PATH_ACCOUNT;
    } else if (recordTypedesc is typedesc<Opportunity>) {
        return RECORD_PATH_OPPORTUNITY;
    } else if (recordTypedesc is typedesc<Partner>) {
        return RECORD_PATH_PARTNER;
    } else if (recordTypedesc is typedesc<Classification>) {
        return RECORD_PATH_CLASSIFICATION;
    } else if (recordTypedesc is typedesc<Vendor>) {
        return RECORD_PATH_VENDOR;
    } else if (recordTypedesc is typedesc<ServiceItem>) {
        return RECORD_PATH_SERVICE_ITEM;
    } else if (recordTypedesc is typedesc<InventoryItem>) {
        return RECORD_PATH_INVENTORY_ITEM;
    } else if (recordTypedesc is typedesc<OtherChargeItem>) {
        return RECORD_PATH_OTHER_CHARGE_ITEM;
    } else if (recordTypedesc is typedesc<ShipItem>) {
        return RECORD_PATH_SHIP_ITEM;
    } else if (recordTypedesc is typedesc<DiscountItem>) {
        return RECORD_PATH_DISCOUNT_ITEM;
    } else if (recordTypedesc is typedesc<PaymentItem>) {
        return RECORD_PATH_PAYMENT_ITEM;
    } else if (recordTypedesc is typedesc<PaymentMethod>) {
        return RECORD_PATH_PAYMENT_METHOD;
    } else if (recordTypedesc is typedesc<Department>) {
        return RECORD_PATH_DEPARTMENT;
    } else if (recordTypedesc is typedesc<Location>) {
        return RECORD_PATH_LOCATION;
    } else if (recordTypedesc is typedesc<Contact>) {
        return RECORD_PATH_CONTACT;
    } else if (recordTypedesc is typedesc<VisualsCollection>) {
        return RECORD_PATH_VISUALS;
    } else if (recordTypedesc is typedesc<Employee>) {
        return RECORD_PATH_EMPLOYEE;
    } else if (recordTypedesc is typedesc<CurrencylistCollection>) {
        return RECORD_PATH_CURRENCY_LIST;
    } else if (recordTypedesc is typedesc<PurchaseOrder>) {
        return RECORD_PATH_PURCHASE_ORDER;
    } else {
        return Error("operation not implemented for " + recordTypedesc.toString() +
                                   ", trybvb defining it a custom record");
    }
}

isolated function constructRecord(ReadableRecordType|WritableRecordType|SubRecordType recordTypedesc, json payload)
                         returns ReadableRecord|WritableRecord|SubRecord|error {                             
    if (recordTypedesc is typedesc<Customer>) {
        return payload.cloneWithType(Customer);
    } else if (recordTypedesc is typedesc<SalesOrder>) {
        return payload.cloneWithType(SalesOrder);
    } else if (recordTypedesc is typedesc<Subsidiary>) {
        return payload.cloneWithType(Subsidiary);
    } else if (recordTypedesc is typedesc<AddressbookCollection>) {
        return payload.cloneWithType(AddressbookCollection);
    } else if (recordTypedesc is typedesc<AddressbookAddress>) {
        return payload.cloneWithType(AddressbookAddress);
    } else if (recordTypedesc is typedesc<ShippingAddress>) {
        return payload.cloneWithType(ShippingAddress);
    } else if (recordTypedesc is typedesc<BillingAddress>) {
        return payload.cloneWithType(BillingAddress);
    } else if (recordTypedesc is typedesc<Currency>) {
        return payload.cloneWithType(Currency);
    } else if (recordTypedesc is typedesc<NonInventoryItem>) {
        return payload.cloneWithType(NonInventoryItem);
    } else if (recordTypedesc is typedesc<ItemCollection>) {
        return payload.cloneWithType(ItemCollection);
    } else if (recordTypedesc is typedesc<VendorBill>) { // VendorBill should come before Invoice
        return payload.cloneWithType(VendorBill);
    } else if (recordTypedesc is typedesc<Invoice>) {
        return payload.cloneWithType(Invoice);
    } else if (recordTypedesc is typedesc<AccountingPeriod>) {
        return payload.cloneWithType(AccountingPeriod);
    } else if (recordTypedesc is typedesc<CustomerPayment>) {
        return payload.cloneWithType(CustomerPayment);
    } else if (recordTypedesc is typedesc<Account>) {
        return payload.cloneWithType(Account);
    } else if (recordTypedesc is typedesc<Opportunity>) {
        return payload.cloneWithType(Opportunity);
    } else if (recordTypedesc is typedesc<Partner>) {
        return payload.cloneWithType(Partner);
    } else if (recordTypedesc is typedesc<Classification>) {
        return payload.cloneWithType(Classification);
    } else if (recordTypedesc is typedesc<Vendor>) {
        return payload.cloneWithType(Vendor);
    } else if (recordTypedesc is typedesc<ServiceItem>) {
        return payload.cloneWithType(ServiceItem);
    } else if (recordTypedesc is typedesc<InventoryItem>) {
        return payload.cloneWithType(InventoryItem);
    } else if (recordTypedesc is typedesc<OtherChargeItem>) {
        return payload.cloneWithType(OtherChargeItem);
    } else if (recordTypedesc is typedesc<ShipItem>) {
        return payload.cloneWithType(ShipItem);
    } else if (recordTypedesc is typedesc<DiscountItem>) {
        return payload.cloneWithType(DiscountItem);
    } else if (recordTypedesc is typedesc<PaymentItem>) {
        return payload.cloneWithType(PaymentItem);
    } else if (recordTypedesc is typedesc<PaymentMethod>) {
        return payload.cloneWithType(PaymentMethod);
    } else if (recordTypedesc is typedesc<Department>) {
        return payload.cloneWithType(Department);
    } else if (recordTypedesc is typedesc<Location>) {
        return payload.cloneWithType(Location);
    } else if (recordTypedesc is typedesc<Contact>) {
        return payload.cloneWithType(Contact);
    } else if (recordTypedesc is typedesc<VisualsCollection>) {
        return payload.cloneWithType(VisualsCollection);
    } else if (recordTypedesc is typedesc<Employee>) {
        return payload.cloneWithType(Employee);
    } else if (recordTypedesc is typedesc<CurrencylistCollection>) {
        return payload.cloneWithType(CurrencylistCollection);
    } else if (recordTypedesc is typedesc<PurchaseOrder>) {
        return payload.cloneWithType(PurchaseOrder);
    } else if (recordTypedesc is typedesc<CustomRecord>) {
        return <CustomRecord> payload.cloneWithType(recordTypedesc);
    } else {
        return Error("operation not implemented for " + recordTypedesc.toString() +
                                   ", defining it as a custom record");
    }
}

function getJsonPayload(http:Client nsclient, string resourcePath, string recordName) returns @tainted json|Error {
    http:Response|http:Payload|error result = nsclient->get(resourcePath);
    if (result is error) {
        return Error("'" + recordName + "' record retrival request failed", result);
    }
    return processJson(<http:Response> result, recordName);
}

isolated function processJson(http:Response response, string? recordName = ()) returns @tainted json|Error{
    json|error responsePayload = response.getJsonPayload();
    if (responsePayload is error) {
        string identifier = recordName is () ? "JSON payload" : "'" + recordName + "' record";
        return Error(identifier + " retrieval failed: Invalid payload", responsePayload);
    } else {
        if (isErrorResponse(response)) {
            return createErrorFromPayload(<map<json>> responsePayload);
        }
        return responsePayload;
    }
}

isolated function isErrorResponse(http:Response response) returns boolean {
    if (!response.hasHeader(CONTENT_TYPE_HEADER)) {
        return false;
    }

    string contentType = response.getHeader(CONTENT_TYPE_HEADER);
    log:printDebug(function () returns string {
            return "Error response content type: " + contentType;
        });
    var value = http:parseHeader(contentType);
    if (value is error) {
        return false;
    }

    var [val, params] = <[string, map<any>]> value;
    if (params["type"].toString() == "error") {
        return true;
    }
    return false;
}

isolated function resolveRecordName(string? customRecordPath, ReadableRecordType targetType) returns string|Error {
    if (customRecordPath is string) {
        return customRecordPath;
    }
    return getRecordName(targetType);
}

isolated function extractInternalId(http:Response response) returns string {
    string locationHeader = response.getHeader(LOCATION_HEADER);
    return spitAndGetLastElement(locationHeader, "/");
}

isolated function spitAndGetLastElement(string receiver, string delimiter) returns string {
    string[] directives = stringutils:split(receiver, delimiter);
    return directives[directives.length() - 1];
}
