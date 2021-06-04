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

import ballerina/test;
import ballerina/log;
import ballerina/os;

configurable string accountId = os:getEnv("NS_ACCOUNTID");
configurable string consumerId = os:getEnv("NS_CLIENT_ID");
configurable string consumerSecret = os:getEnv("NS_CLIENT_SECRET");
configurable string token = os:getEnv("NS_TOKEN");
configurable string tokenSecret = os:getEnv("NS_TOKEN_SECRET");
configurable string baseURL = os:getEnv("NS_BASE_URL");

NetSuiteConfiguration config = {
    accountId: accountId,
    consumerId: consumerId,
    consumerSecret: consumerSecret,
    token: token,
    tokenSecret: tokenSecret,
    baseURL: baseURL
};

Client netsuiteClient = check new (config);
string customerId = EMPTY_STRING;
string contactId =EMPTY_STRING;
string currencyId = EMPTY_STRING;
string salesOrderId = EMPTY_STRING;
string classificationId = EMPTY_STRING;
string customerAccountId = EMPTY_STRING;
string invoiceId = EMPTY_STRING;

@test:Config {enable: true}
function testAddContactRecordOperation() {
    log:printInfo("testAddContactRecord");
    RecordRef cusForm = {
        internalId : "-40",
        'type: "customForm"
    };

    RecordInputRef subsidiary = {
        internalId : "11",
        'type: "subsidiary"
    };

    RecordRef category = {
        internalId : "12",
        'type: "category"
    };

    Address ad01 = {
        country: "_sriLanka",
        addr1: "address01_1",
        addr2:"address02_1",
        city:"Colombo",
        override: true
    };

    Address ad02 = {
        country: "_sriLanka",
        addr1: "address01_2",
        addr2:"address02_2",
        city:"Colombo07",
        override: true
    };

    ContactAddressBook contactAddressBook = {
        defaultShipping: true,
        defaultBilling: true,
        label: "myAddress",
        addressBookAddress: [ad01]
    };
    
    ContactAddressBook contactAddressBook2 = {
        defaultShipping: true,
        defaultBilling: true,
        label: "myAddress",
        addressBookAddress: [ad02]
    };

    NewContact contact= {
        customForm :cusForm,
        firstName: "testContact_01",
        middleName: "sandu",
        isPrivate: false,
        subsidiary: subsidiary,
        //globalSubscriptionStatus: "_confirmedOptIn",
        addressBookList : [contactAddressBook, contactAddressBook2]

    };
    RecordAddResponse|error output = netsuiteClient->addNewContact(contact);
    if (output is RecordAddResponse) {
        log:printInfo(output.toString());
        contactId = <@untainted>output.internalId;
    } else {
        test:assertFail(output.message());
    }
}


@test:Config {enable: true}
function testAddNewCustomerRecord() {
    log:printInfo("testAddCustomerRecord");
    RecordInputRef subsidiary = {
        internalId : "11",
        'type: "subsidiary"
    };

    Address ad02 = {
        country: "_sriLanka",
        addr1: "RuwanmagaBombuwala",
        addr2:"Dodangoda",
        city:"Colombo07",
        override: true
    };

    RecordRef currency = {
        internalId : "1",
        'type: "currency"
    };

    CustomerAddressbook customerAddressbook = {
        defaultShipping: true,
        defaultBilling: true,
        label: "myAddress",
        isResidential: true,
        addressBookAddress: [ad02]
    };

    CustomerCurrency  cur = {
        currency:currency,
        balance: 1200.13,
        depositBalance: 10000,
        overdueBalance: 120,
        unbilledOrders: 1000,
        overrideCurrencyFormat: false
    };
    
    NewCustomer customer = {
        entityId: "BallerinaTest01",
        isPerson: true,
        salutation: "Mr",
        firstName: "TestName",
        middleName: "TestMiddleName",
        lastName: "TestLastName",
        companyName: "Wso2",
        phone: "0123456789",
        fax: "0123456781",
        email: "ecosystem@wso2.com",
        subsidiary: subsidiary,
        isInactive: false,
        title: "TestTilte",
        homePhone: "0123456782",
        mobilePhone: "0123456783",
        accountNumber: "0123456784",
        addressbookList: [customerAddressbook]

    };
    RecordAddResponse|error output = netsuiteClient->addNewCustomer(customer);
    if (output is RecordAddResponse) {
        log:printInfo(output.toString());
        customerId = <@untainted>output.internalId;
    } else {
        test:assertFail(output.message());
    }

}

@test:Config {enable: true}
function testAddCurrencyRecord() {
    log:printInfo("testAddCurrencyRecord");
    NewCurrency currency = {
        name: "BLA",
        symbol: "BLA",
        exchangeRate: 3.89,
        isInactive: false,
        isBaseCurrency: false
    };
    RecordAddResponse|error output = netsuiteClient->addNewCurrency(currency);
    if (output is RecordAddResponse) {
        log:printInfo(output.toString());
        currencyId = <@untainted>output.internalId;
    } else {
        test:assertFail(output.message());
    }
}

@test:Config {enable: true}
function testAddInvoiceRecord() {
    log:printInfo("testAddInvoiceRecord");
    RecordInputRef entity = {
        internalId : "5530",
        'type: "entity"
    };
    Item item01 = {
        item: {
            internalId: "560",
            'type: "item"
         },
        amount: 1000
    };
    Item item02 = {
        item: {
            internalId: "570",
            'type: "item"
         },
        amount: 2000
    };
    NewInvoice invoice = {
        entity: entity,
        itemList: [item01, item02]
    };
    RecordAddResponse|error output = netsuiteClient->addNewInvoice(invoice);
    if (output is RecordAddResponse) {
        log:printInfo(output.toString());
        invoiceId = <@untainted>output.internalId;
    } else {
        test:assertFail(output.message());
    }
}

@test:Config {enable: true}
function testAddSalesOrderOperation() {
    log:printInfo("testSalesOrderRecordOperation");
    RecordInputRef entity = {
        internalId : "4045",
        'type: "entity"
    };
    RecordRef itemValue = {
        internalId : "961",
        'type: "item"
    };
    Address address = {
        country: "_sriLanka",
        addr1: "address01_3",
        addr2:"address02_3",
        city:"Colombo07",
        override: true
    };
    RecordRef currency = {
        internalId : "1",
        'type: "currency"
    };

    RecordRef location = {
        internalId : "23",
        'type: "location"
    };
    Item item = {
        item: itemValue,
        amount: 100,
        location: location
    };
    NewSalesOrder salesOrder = {
        entity:entity,
        billingAddress: address,
        currency: currency,
        itemList:[item]
    };
    RecordAddResponse|error output = netsuiteClient->addNewSalesOrder(salesOrder);
    if (output is RecordAddResponse) {
        log:printInfo(output.toString());
        salesOrderId = <@untainted>output.internalId;
    } else {
        test:assertFail(output.message());
    }
}

@test:Config {enable: true}
function testAddClassificationRecord() {
    log:printInfo("testAddClassificationRecord");
    RecordInputRef recordRef = {
        internalId: "10",
        'type: "parent"
    };
    NewClassification classification = {
        name:"Ballerina test class",
        parent: recordRef,
        isInactive:false
    };
    RecordAddResponse|error output = netsuiteClient->addNewClassification(classification);
    if (output is RecordAddResponse) {
        log:printInfo(output.toString());
        classificationId = <@untainted>output.internalId;
    } else {
        test:assertFail(output.message());
    }
}

@test:Config {enable: true}
function testAddAccountRecord() {
    log:printInfo("testAddAccountRecord");
    RecordInputRef currency = {
        internalId: "1",
        'type: "currency"
    };
    NewAccount account = {
        acctNumber: "67425630",
        acctName: "Ballerina test account",
        currency: currency
    };
    RecordAddResponse|error output = netsuiteClient->addNewAccount(account);
    if (output is RecordAddResponse) {
        log:printInfo(output.toString());
       customerAccountId = <@untainted>output.internalId;
    } else {
        test:assertFail(output.message());
    }
}

@test:Config {enable: true, dependsOn: [testAddNewCustomerRecord, testCustomerSearchOperation]}
function testUpdateCustomerRecord() {
    log:printInfo("testUpdateCustomerRecord");
    RecordRef subsidiary = {
        internalId : "11",
        'type: "subsidiary"
    };

    Address ad02 = {
        country: "_sriLanka",
        addr1: "address01_4",
        addr2:"address02_4",
        city:"Colombo07",
        override: true
    };

    RecordRef currency = {
        internalId : "1",
        'type: "currency"
    };

    CustomerAddressbook customerAddressbook = {
        defaultShipping: true,
        defaultBilling: true,
        label: "myAddress",
        isResidential: true,
        addressBookAddress: [ad02]
    };

    CustomerCurrency  cur = {
        currency:currency,
        balance: 1200.13,
        depositBalance: 10000,
        overdueBalance: 120,
        unbilledOrders: 1000,
        overrideCurrencyFormat: false
    };
    
    Customer customer= {
        internalId: customerId,
        entityId: "Test_Customer_test_Update",
        isPerson: true,
        salutation: "Mr",
        firstName: "TestFirstName",
        middleName: "TestMiddleName",
        lastName: "TestLastName", 
        companyName: "Wso2",
        phone: "0123456784",
        fax: "0123456784",
        email: "updatedecosysytem@wso2.com",
        subsidiary: subsidiary,
        isInactive: false,
        title: "TestTilte",
        homePhone: "0123456784",
        mobilePhone: "0123456784",
        accountNumber: "ac9092328483",
        addressbookList: [customerAddressbook]


    };
    RecordUpdateResponse|error output = netsuiteClient->updateCustomerRecord(customer);
    if (output is RecordUpdateResponse) {
        log:printInfo(output.toString());
    } else {
        test:assertFail(output.toString());
    }
}

@test:Config {enable: true, dependsOn: [testAddSalesOrderOperation]}
function testSalesOrderUpdateOperation() {
    log:printInfo("testSalesOrderUpdateOperation");
    RecordRef itemValue = {
        internalId : "961",
        'type: "item"
    };
    Item item = {
        item: itemValue,
        amount: 1000
    };
    SalesOrder salesOrder = {
        itemList:[item],
        internalId: salesOrderId
    };
    RecordUpdateResponse|error output = netsuiteClient->updateSalesOrderRecord(salesOrder);
    if (output is RecordUpdateResponse) {
        log:printInfo(output.toString());
        salesOrderId = <@untainted>output.internalId;
    } else {
        test:assertFail(output.message());
    }
}

@test:Config {enable: true, dependsOn: [testAddClassificationRecord]}
function testUpdateClassificationRecord() {
    log:printInfo("testUpdateClassificationRecord");
    Classification classification = {
        name:"Ballerina test class_Updated",
        internalId: classificationId
    };
    RecordUpdateResponse|error output = netsuiteClient->updateClassificationRecord(classification);
    if (output is RecordAddResponse) {
        log:printInfo(output.toString());
    } else {
        test:assertFail(output.message());
    }
}

@test:Config {enable: true, dependsOn: [testAddAccountRecord]}
function testUpdateAccountRecord() {
    log:printInfo("testUpdateAccountRecord");
    Account account = {
        acctName: "Ballerina test account_updated",
        internalId: customerAccountId
    };
    RecordUpdateResponse|error output = netsuiteClient->updateAccountRecord(account);
    if (output is RecordAddResponse) {
        log:printInfo(output.toString());
    } else {
        test:assertFail(output.message());
    }
}

@test:Config {enable: true, dependsOn: [testAddInvoiceRecord]}
function testUpdateInvoiceRecord() {
    log:printInfo("testUpdateInvoiceRecord");
    Invoice invoice = {
        internalId: invoiceId,
        email: "test@ecosystem.com"
    };
    RecordUpdateResponse|error output = netsuiteClient->updateInvoiceRecord(invoice);
    if (output is RecordAddResponse) {
        log:printInfo(output.toString());
    } else {
        test:assertFail(output.message());
    }
}

@test:Config {enable: true, dependsOn: [testAddContactRecordOperation]}
function testUpdateContactRecord() {
    log:printInfo("testUpdateContactRecord");
    Contact contact = {
        internalId: contactId,
        email: "test@ecosystem.com"
    };
    RecordUpdateResponse|error output = netsuiteClient->updateContactRecord(contact);
    if (output is RecordAddResponse) {
        log:printInfo(output.toString());
    } else {
        test:assertFail(output.message());
    }
}


@test:Config {enable: true, dependsOn: [testAddNewCustomerRecord]}
function testCustomerSearchOperation() {
    log:printInfo("testCustomerSearchOperation");
    SearchElement searchRecord = {
        fieldName: "lastName",
        searchType: SEARCH_STRING_FIELD,
        operator: "is",
        value1: "TestLastName"
    };
    SearchElement[] searchData = [];
    searchData.push(searchRecord);
    Customer|error output = netsuiteClient->searchCustomerRecord(searchData);
    if (output is Customer) {
        log:printInfo(output?.entityId.toString());     
    } else {
        test:assertFalse(true, output.message());
    }
}

@test:Config {enable: true, dependsOn: [testUpdateAccountRecord]}
function testAccountSearchOperation() {
    log:printInfo("testAccountSearchOperation");
    SearchElement searchRecord = {
        fieldName: "name",
        searchType: SEARCH_STRING_FIELD,
        operator: "is",
        value1: "Ballerina test account_updated"
    };
    SearchElement[] searchElements = [searchRecord];
    Account|error output = netsuiteClient->searchAccountRecord(searchElements);
    if (output is Account) {
        log:printInfo(output.toString());     
    } else {
        test:assertFalse(true, output.message());
    }
}

@test:Config {enable: true}
function testTransactionSearchOperation() {
    log:printInfo("testTransactionSearchOperation");
    SearchElement searchRecord1 = {
        fieldName: "amount",
        searchType: SEARCH_DOUBLE_FIELD,
        operator: "between",
        value1: "100000",
        value2: "2000000"
    };

    SearchElement searchRecord2 = {
        fieldName: "lastModifiedDate",
        searchType: SEARCH_DATE_FIELD,
        operator: "within",
        value1 : "2021-01-23T10:20:15",
        value2 : "2021-03-23T10:20:15"
    };
    SearchElement[] searchElements = [searchRecord2];
    RecordList|error output = netsuiteClient->searchTransactionRecord(searchElements);
    if (output is RecordList) {
        log:printInfo(output.toString());     
    } else {
        test:assertFalse(true, output.message());
    }
}

@test:Config {enable: true, dependsOn: [testCustomerSearchOperation, testUpdateCustomerRecord, 
testCustomerRecordGetOperation]}
function testCustomerDeleteRecord() {
    log:printInfo("Record Deletion Start");
    log:printInfo("testCustomerDeleteRecord");
    RecordDetail recordDeletionInfo = {
        recordInternalId : customerId,
        recordType: "customer"
    };
    RecordDeletionResponse|error output = netsuiteClient->deleteRecord(recordDeletionInfo);
    if (output is RecordDeletionResponse) {
        log:printInfo(output.toString());
    } else {
        test:assertFail(output.toString());
    }
}
@test:Config {enable: true, dependsOn:[testUpdateContactRecord, testContactGetOperation]}
function testContactDeleteOperation() {
    log:printInfo("testContactDeleteRecord");
    RecordDetail recordDeletionInfo = {
        recordInternalId : contactId,
        recordType: "contact"
    };
    RecordDeletionResponse|error output = netsuiteClient->deleteRecord(recordDeletionInfo);
    if (output is RecordDeletionResponse) {
        log:printInfo(output.toString());
    } else {
        test:assertFail(output.toString());
    }
}

@test:Config {enable: true, dependsOn:[testAddCurrencyRecord, testCurrencyRecordGetOperation]}
function testCurrencyDeleteOperation() {
    log:printInfo("testCurrencyDeleteRecord");
    RecordDetail recordDeletionInfo = {
        recordInternalId : currencyId,
        recordType: "currency"
    };
    RecordDeletionResponse|error output = netsuiteClient->deleteRecord(recordDeletionInfo);
    if (output is RecordDeletionResponse) {
        log:printInfo(output.toString());
    } else {
        test:assertFail(output.toString());
    }
}   
    
@test:Config {enable: true, dependsOn:[testGetClassificationRecordOperation]}
function testDeleteClassificationRecord() {
    log:printInfo("testDeleteClassificationRecord");
    RecordDetail recordDeletionInfo = {
        recordInternalId : classificationId,
        recordType: "classification"
    };
    RecordDeletionResponse|error output = netsuiteClient->deleteRecord(recordDeletionInfo);
    if (output is RecordDeletionResponse) {
        log:printInfo(output.toString());
    } else {
        test:assertFail(output.toString());
    }
}

@test:Config {enable: true, dependsOn:[testAccountSearchOperation,testUpdateAccountRecord]}
function testDeleteAccountRecord() {
    log:printInfo("testDeleteAccountRecord");
    RecordDetail recordDeletionInfo = {
        recordInternalId : customerAccountId,
        recordType: ACCOUNT
    };
    RecordDeletionResponse|error output = netsuiteClient->deleteRecord(recordDeletionInfo);
    if (output is RecordDeletionResponse) {
        log:printInfo(output.toString());
    } else {
        test:assertFail(output.toString());
    }
}

@test:Config {enable: true, dependsOn:[testSalesOrderGetOperation, testSalesOrderUpdateOperation]}
function testDeleteSalesOrderRecord() {
    log:printInfo("testDeleteAccountRecord");
    RecordDetail recordDeletionInfo = {
        recordInternalId : salesOrderId,
        recordType: SALES_ORDER
    };
    RecordDeletionResponse|error output = netsuiteClient->deleteRecord(recordDeletionInfo);
    if (output is RecordDeletionResponse) {
        log:printInfo(output.toString());
    } else {
        test:assertFail(output.toString());
    }
}

@test:Config {enable: true, dependsOn:[testInvoiceRecordGetOperation, testUpdateInvoiceRecord]}
function testDeleteInvoiceRecord() {
    log:printInfo("testDeleteInvoiceRecord");
    RecordDetail recordDeletionInfo = {
        recordInternalId : invoiceId,
        recordType: INVOICE
    };
    RecordDeletionResponse|error output = netsuiteClient->deleteRecord(recordDeletionInfo);
    if (output is RecordDeletionResponse) {
        log:printInfo(output.toString());
    } else {
        test:assertFail(output.toString());
    }
}

@test:Config {enable: true}
function testGetAllCurrencyRecords() {
    log:printInfo("testGetAllCurrencyRecords");
    Currency[]|error output = netsuiteClient->getAllCurrencyRecords();
    if (output is Currency[]) {
        log:printInfo("Number of records found: " + output.length().toString());
    } else {
        test:assertFalse(true, output.message());
    }
}

@test:Config {enable: true}
function testGetServerTime() {
    log:printInfo("testGetNetSuiteServerTime");
    string|error output = netsuiteClient->getNetSuiteServerTime();
    if (output is string) {
        log:printInfo(output.toString());
    } else {
        test:assertFalse(true, output.message());
    }
}

@test:Config {enable: true, dependsOn: [testAddNewCustomerRecord]} 
function testCustomerRecordGetOperation() {
    log:printInfo("testCustomerRecordGetOperation");
    RecordInfo recordDetail = {
        recordInternalId: customerId,
        recordType: "customer"
    };
    Customer|error output = netsuiteClient->getCustomerRecord(recordDetail);
    if (output is error) {
        test:assertFalse(true, output.message());
    } else {
       log:printInfo(output.toString()); 
    }
}

@test:Config {enable: true, dependsOn: [testAddCurrencyRecord]} 
function testCurrencyRecordGetOperation() {
    log:printInfo("testCurrencyRecordGetOperation");
    RecordInfo recordDetail = {
        recordInternalId: currencyId,
        recordType: "currency"
    };
    Currency|error output = netsuiteClient->getCurrencyRecord(recordDetail);
    if (output is error) {
        test:assertFalse(true, output.message());
    } else {
       log:printInfo(output.toString()); 
    }
}

@test:Config {enable: true, dependsOn: [testUpdateClassificationRecord]} 
function testGetClassificationRecordOperation() {
    log:printInfo("testGetClassificationRecordOperation");
    RecordInfo recordDetail = {
        recordInternalId: classificationId,
        recordType: "classification"
    };
    Classification|error output = netsuiteClient->getClassificationRecord(recordDetail);
    if (output is error) {
        test:assertFalse(true, output.message());
    } else {
        log:printInfo(output.toString());  
    }
}

@test:Config {enable: true, dependsOn: [testAddInvoiceRecord]} 
function testInvoiceRecordGetOperation() {
    log:printInfo("testInvoiceRecordGetOperation");
    RecordInfo recordDetail = {
        recordInternalId: invoiceId,
        recordType: INVOICE
    };
    Invoice|error output = netsuiteClient->getInvoiceRecord(recordDetail);
    if (output is error) {
        test:assertFalse(true, output.message());
    } else {
       log:printInfo(output.toString()); 
    }
}

@test:Config {enable: true, dependsOn: [testAddSalesOrderOperation]}
function testSalesOrderGetOperation() {
    log:printInfo("testSalesOrderGetOperation");
    RecordInfo recordDetail = {
        recordInternalId: salesOrderId,
        recordType: SALES_ORDER
    };
    SalesOrder|error output = netsuiteClient->getSalesOrderRecord(recordDetail);
    if (output is error) {
        test:assertFalse(true, output.message());
    } else {
       log:printInfo(output.toString()); 
    }
}

@test:Config {enable: true, dependsOn: [testAddContactRecordOperation]}
function testContactGetOperation() {
    log:printInfo("testContactGetOperation");
    RecordInfo recordDetail = {
        recordInternalId: contactId,
        recordType: CONTACT
    };
    Contact|error output = netsuiteClient->getContactRecord(recordDetail);
    if (output is error) {
        test:assertFalse(true, output.message());
    } else {
       log:printInfo(output.toString()); 
    }
}

@test:Config {enable: true, dependsOn: [testUpdateAccountRecord] }
function testAccountGetOperation() {
    log:printInfo("testAccountGetOperation");
    RecordInfo recordDetail = {
        recordInternalId: customerAccountId,
        recordType: ACCOUNT
    };
    Account|error output = netsuiteClient->getAccountRecord(recordDetail);
    if (output is error) {
        test:assertFalse(true, output.message());
    } else {
       log:printInfo(output.toString()); 
    }
}