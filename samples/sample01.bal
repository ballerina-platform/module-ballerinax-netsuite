
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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  In this sample, Netsuite client is created and then using that client, an invoice is created with item lists      //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
import ballerinax/netsuite;
import ballerina/log;
import ballerina/os;

configurable string accountId = os:getEnv("NS_ACCOUNTID");
configurable string consumerId = os:getEnv("NS_CLIENT_ID");
configurable string consumerSecret = os:getEnv("NS_CLIENT_SECRET");
configurable string token = os:getEnv("NS_TOKEN");
configurable string tokenSecret = os:getEnv("NS_TOKEN_SECRET");
configurable string baseURL = os:getEnv("NS_BASE_URL");

public function main() returns error? {

    //Preparing the netsuite configuration with TBA authentication tokens.
    netsuite:NetSuiteConfiguration config = {
        accountId: accountId,
        consumerId: consumerId,
        consumerSecret: consumerSecret,
        token: token,
        tokenSecret: tokenSecret,
        baseURL: baseURL
    };

    //get all currency type records
    netsuite:Client netSuiteClient = check new (config);

    //create a Netsuite customer record
    log:printInfo("AddCustomerRecord");
    netsuite:RecordInputRef subsidiary = {
        internalId : "12",
        'type: "subsidiary"
    };

    netsuite:Address ad02 = {
        country: "_sriLanka",
        addr1: "Wso2_address_part01",
        addr2:"Wso2_address_part02",
        city:"wso2_city",
        override: true
    };

    netsuite:RecordRef currencyReference = {
        internalId : "1",
        'type: "currency"
    };

    netsuite:CustomerAddressbook customerAddressbook = {
        defaultShipping: true,
        defaultBilling: true,
        label: "Ballerina_Address",
        isResidential: true,
        addressBookAddress: [ad02]
    };

    netsuite:CustomerCurrency  cur = {
        currency: currencyReference,
        balance: 1200.13,
        depositBalance: 10000,
        overdueBalance: 120,
        unbilledOrders: 1000,
        overrideCurrencyFormat: false
    };
    
    netsuite:NewCustomer customer= {
        entityId: "Ballerina_Test_Customer_Sample",
        isPerson: true,
        salutation: "Mr",
        firstName: "Test_FirstName",
        middleName: "Test_MiddleName",
        lastName: "Test_LastName",
        companyName: "Wso2",
        phone: "1234567890",
        fax: "1234567891",
        email: "ecosystem@wso2.com",
        subsidiary: subsidiary,
        isInactive: false,
        title: "Test_Tilte",
        homePhone: "1234567892",
        mobilePhone: "1234567893",
        accountNumber: "ac1234567894",
        addressbookList: [customerAddressbook]
        
    };

    netsuite:RecordAddResponse customerRecordResponse = check netSuiteClient->addNewCustomer(customer);

    //Creates a Netsuite invoice record
    //Adds Netsuite entity instance for the invoice record
    log:printInfo("AddInvoiceRecord");
    netsuite:RecordInputRef entity = {
        internalId : customerRecordResponse.internalId,
        'type: "entity"
    };

    //Creates an item for the invoice list
    netsuite:Item item01 = {
        item: {
            internalId: "560",
            'type: "item"
         },
        amount: 1000
    };

    //Creates an item for the invoice item list
    netsuite: Item item02 = {
        item: {
            internalId: "570",
            'type: "item"
         },
        amount: 2000
    };

    //Creates the invoice record to be created in Netsuite
    netsuite:NewInvoice invoice = {
        entity: entity,
        itemList: [item01, item02],
        currency : {
            internalId: currencyReference.internalId,
            'type: netsuite:CURRENCY
        }
    };

    //Makes the http request to the Netsuite SOAP web service.
    netsuite:RecordAddResponse invoiceRecordResponse = check netSuiteClient->addNewInvoice(invoice);
    log:printInfo(invoiceRecordResponse.toString());

    //Delete the record from Netsuite
    log:printInfo("DeleteInvoiceRecord");
    netsuite:RecordDetail recordDeletionInfo = {
        recordInternalId : invoiceRecordResponse.internalId,
        recordType: netsuite:INVOICE
    };
    netsuite:RecordDeletionResponse output = check netSuiteClient->deleteRecord(recordDeletionInfo);
    log:printInfo(output.toString());
}
