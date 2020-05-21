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

function getRecordName(ReadableRecordType|WritableRecordType|SubRecordType recordTypedesc)
                       returns string|Error {
    if (recordTypedesc is typedesc<Customer>) {
        return RECORD_NAME_CUSTOMER;
    } else if (recordTypedesc is typedesc<SalesOrder>) {
        return RECORD_NAME_SALES_ORDER;
    } else if (recordTypedesc is typedesc<Subsidiary>) {
        return RECORD_NAME_SUBSIDIARY;
    } else if (recordTypedesc is typedesc<AddressBook>) {
        return RECORD_NAME_ADDRESSBOOK;
    } else if (recordTypedesc is typedesc<Currency>) {
        return RECORD_NAME_CURRENCY;
    } else if (recordTypedesc is typedesc<NonInventoryItem>) {
        return RECORD_NAME_NON_INVENTORY_ITEM;
    } else if (recordTypedesc is typedesc<ItemCollection>) {
        return RECORD_NAME_ITEM_COLLECTION;
    } else if (recordTypedesc is typedesc<Invoice>) {
        return RECORD_NAME_INVOICE;
    } else if (recordTypedesc is typedesc<AccountingPeriod>) {
        return RECORD_NAME_ACCOUNTING_PERIOD;
    } else if (recordTypedesc is typedesc<CustomerPayment>) {
        return RECORD_NAME_CUSTOMER_PAYMENT;
    } else if (recordTypedesc is typedesc<Account>) {
        return RECORD_NAME_ACCOUNT;
    } else if (recordTypedesc is typedesc<Opportunity>) {
        return RECORD_NAME_OPPORTUNITY;
    } else if (recordTypedesc is typedesc<Partner>) {
        return RECORD_NAME_PARTNER;
    } else if (recordTypedesc is typedesc<Classification>) {
        return RECORD_NAME_CLASSIFICATION;
    } else {
        return getErrorFromMessage("operation not implemented for " + recordTypedesc.toString());
    }
}


function constructRecord(ReadableRecordType|WritableRecordType|SubRecordType recordTypedesc, json payload)
                         returns ReadableRecord|WritableRecord|SubRecord|error {
    if (recordTypedesc is typedesc<Customer>) {
        return Customer.constructFrom(payload);
    } else if (recordTypedesc is typedesc<SalesOrder>) {
        return SalesOrder.constructFrom(payload);
    } else if (recordTypedesc is typedesc<Subsidiary>) {
        return Subsidiary.constructFrom(payload);
    } else if (recordTypedesc is typedesc<AddressBook>) {
        return AddressBook.constructFrom(payload);
    } else if (recordTypedesc is typedesc<Currency>) {
        return Currency.constructFrom(payload);
    } else if (recordTypedesc is typedesc<NonInventoryItem>) {
        return NonInventoryItem.constructFrom(payload);
    } else if (recordTypedesc is typedesc<ItemCollection>) {
        return ItemCollection.constructFrom(payload);
    } else if (recordTypedesc is typedesc<Invoice>) {
        return Invoice.constructFrom(payload);
    } else if (recordTypedesc is typedesc<AccountingPeriod>) {
        return AccountingPeriod.constructFrom(payload);
    } else if (recordTypedesc is typedesc<CustomerPayment>) {
        return CustomerPayment.constructFrom(payload);
    } else if (recordTypedesc is typedesc<Account>) {
        return Account.constructFrom(payload);
    } else if (recordTypedesc is typedesc<Opportunity>) {
        return Opportunity.constructFrom(payload);
    } else if (recordTypedesc is typedesc<Partner>) {
        return Partner.constructFrom(payload);
    } else if (recordTypedesc is typedesc<Classification>) {
        return Classification.constructFrom(payload);
    } else {
        return getErrorFromMessage("operation not implemented for " + recordTypedesc.toString());
    }
}

function updatePassedInRecord(http:Client nsclient, string internalId, @tainted WritableRecord passedInValue)
                              returns @tainted Error? {
    ReadableRecord|Error nsRecordValue = getRecord(nsclient, internalId, typeof passedInValue, INTERNAL);
    if (nsRecordValue is Error) {
        return getError("NetSuite record updated successful. But local record population failed", nsRecordValue);
    } else if (nsRecordValue is Customer) {
        foreach var [key, val] in nsRecordValue.entries() {
            passedInValue[key] = val;
        }
    } else if (nsRecordValue is SalesOrder) {
        foreach var [key, val] in nsRecordValue.entries() {
            passedInValue[key] = val;
        }
    } else if (nsRecordValue is Currency) {
        foreach var [key, val] in nsRecordValue.entries() {
            passedInValue[key] = val;
        }
    } else if (nsRecordValue is NonInventoryItem) {
        foreach var [key, val] in nsRecordValue.entries() {
            passedInValue[key] = val;
        }
    } else if (nsRecordValue is Invoice) {
        foreach var [key, val] in nsRecordValue.entries() {
            passedInValue[key] = val;
        }
    } else if (nsRecordValue is AccountingPeriod) {
        foreach var [key, val] in nsRecordValue.entries() {
            passedInValue[key] = val;
        }
    } else if (nsRecordValue is CustomerPayment) {
        foreach var [key, val] in nsRecordValue.entries() {
            passedInValue[key] = val;
        }
    } else if (nsRecordValue is Opportunity) {
        foreach var [key, val] in nsRecordValue.entries() {
            passedInValue[key] = val;
        }
    } else if (nsRecordValue is Partner) {
        foreach var [key, val] in nsRecordValue.entries() {
            passedInValue[key] = val;
        }
    } else if (nsRecordValue is Classification) {
        foreach var [key, val] in nsRecordValue.entries() {
            passedInValue[key] = val;
        }
    } else {
        Account value = <Account> nsRecordValue;
        foreach var [key, val] in value.entries() {
            passedInValue[key] = val;
        }
    }
}

function getJsonPayload(http:Client nsclient, string resourcePath, string recordName) returns @tainted json|Error {
    http:Response|error result = nsclient->get(resourcePath);
    if result is error {
        return getError("'" + recordName + "' record retrival request failed", result);
    }
    return processJson(<http:Response> result, recordName);
}

function processJson(http:Response response, string? recordName = ()) returns @tainted json|Error{
    json|error responsePayload = response.getJsonPayload();
    if responsePayload is error {
        string identifier = recordName is () ? "JSON payload" : "'" + recordName + "' record";
        return getError(identifier + " retrieval failed: Invalid payload", responsePayload);
    } else {
        if (isErrorResponse(response)) {
            return getErrorFromPayload(<map<json>> responsePayload);
        }
        return responsePayload;
    }
}

function isErrorResponse(http:Response response) returns boolean {
    if (!response.hasHeader("Content-Type")) {
        return false;
    }

    string contentType = response.getHeader("Content-Type");
    log:printDebug(function () returns string {
            return "Error response content type: " + contentType;
        });
    var value = http:parseHeader(contentType);
    if value is error {
        return false;
    }

    var [val, params] = <[string, map<any>]> value;
    if (params["type"].toString() == "error") {
        return true;
    }
    return false;
}

function extractInternalId(http:Response response) returns string {
    string locationHeader = response.getHeader("Location");
    return spitAndGetLastElement(locationHeader, "/");
}

function spitAndGetLastElement(string receiver, string delimiter) returns string {
    string[] directives = stringutils:split(receiver, delimiter);
    return directives[directives.length() - 1];
}

