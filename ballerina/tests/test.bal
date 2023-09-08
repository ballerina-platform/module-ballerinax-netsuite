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

ConnectionConfig config = {
    accountId: accountId,
    consumerId: consumerId,
    consumerSecret: consumerSecret,
    token: token,
    tokenSecret: tokenSecret,
    baseURL: baseURL,
    timeout: 120
};

Client netsuiteClient = check new (config);
string customerId = EMPTY_STRING;
string contactId = EMPTY_STRING;
string currencyId = EMPTY_STRING;
string salesOrderId = EMPTY_STRING;
string classificationId = EMPTY_STRING;
string customerAccountId = EMPTY_STRING;
string invoiceId = EMPTY_STRING;
string vendorId = EMPTY_STRING;
string vendorBillId = EMPTY_STRING;
string itemGroupId = EMPTY_STRING;

@test:Config {enable: false}
function testAddItemGroupRecordOperation() {
    log:printInfo("testItemGroupRecord");
    RecordInputRef subsidiary = {
        internalId: "1",
        'type: "subsidiary"
    };
    ItemMember itemMember01 = {
        quantity: 1,
        item: {
            internalId: "8",
            'type: "item"
        }
    };
    ItemMember itemMember02 = {
        quantity: 2,
        item: {
            internalId: "14",
            'type: "item"
        }
    };
    NewItemGroup itemGroup = {
        isVsoeBundle: false,
        itemId: "Netsuite Test Item Group_04",
        displayName: "Netsuite  test item group_04",
        description: "This is test item group",
        subsidiaryList: [subsidiary],
        memberList:[itemMember01, itemMember02]
    };
    RecordAddResponse|error output = netsuiteClient->addNewItemGroup(itemGroup);
    if output is RecordAddResponse {
        log:printInfo(output.toString());
        itemGroupId = output.internalId;
    } else {
        test:assertFail(output.toString());
    }
}

@test:Config {enable: false, dependsOn: [testAddItemGroupRecordOperation]}
function testGetItemGroupRecord() {
    log:printInfo("testGetItemGroupRecord");
    RecordInfo ref = {
        recordInternalId: itemGroupId,
        recordType: "itemGroup"
    };
    ItemGroup|error output = netsuiteClient->getItemGroupRecord(ref);
    if output is ItemGroup {
        log:printInfo(output.internalId.toString());
    } else {
        test:assertFalse(true, output.toString());
    }
}

@test:Config {enable: false}
function testAddContactRecordOperation() {
    log:printInfo("testAddContactRecord");
    RecordRef cusForm = {
        internalId: "-40",
        'type: "customForm"
    };

    RecordInputRef subsidiary = {
        internalId: "1",
        'type: "subsidiary"
    };

    Address ad01 = {
        country: "_sriLanka",
        addr1: "address01_1",
        addr2: "address02_1",
        city: "Colombo",
        override: true
    };

    Address ad02 = {
        country: "_sriLanka",
        addr1: "address01_2",
        addr2: "address02_2",
        city: "Colombo07",
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

    NewContact contact = {
        customForm: cusForm,
        firstName: "testContact_01",
        middleName: "sandu",
        isPrivate: false,
        subsidiary: subsidiary,
        //globalSubscriptionStatus: "_confirmedOptIn",
        addressBookList: [contactAddressBook, contactAddressBook2]
    };
    RecordAddResponse|error output = netsuiteClient->addNewContact(contact);
    if (output is RecordAddResponse) {
        log:printInfo(output.toString());
        contactId = <@untainted>output.internalId;
    } else {
        test:assertFail(output.toString());
    }
}

@test:Config {enable: false}
function testAddNewCustomerRecord() {
    log:printInfo("testAddCustomerRecord");
    RecordInputRef subsidiary = {
        internalId: "1",
        'type: "subsidiary"
    };

    Address ad02 = {
        country: "_sriLanka",
        addr1: "RuwanmagaBombuwala",
        addr2: "Dodangoda",
        city: "Colombo07",
        override: true
    };

    CustomerAddressbook customerAddressbook = {
        defaultShipping: true,
        defaultBilling: true,
        label: "myAddress",
        isResidential: true,
        addressBookAddress: [ad02]
    };

    NewCustomer customer = {
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
        test:assertFail(output.toString());
    }

}

@test:Config {enable: false}
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
        test:assertFail(output.toString());
    }
}

@test:Config {enable: false}
function testAddInvoiceRecord() {
    log:printInfo("testAddInvoiceRecord");
    RecordInputRef entity = {
        internalId: "1306",
        'type: "entity"
    };
    Item item01 = {
        item: {
            internalId: "5",
            'type: "item"
        },
        amount: 1000
    };
    Item item02 = {
        item: {
            internalId: "8",
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
        invoiceId = output.internalId;
    } else {
        test:assertFail(output.toString());
    }
}

@test:Config {enable: false}
function testAddSalesOrderOperation() {
    log:printInfo("testSalesOrderRecordOperation");
    RecordInputRef entity = {
        internalId: "1407",
        'type: "entity"
    };
    RecordRef itemValue = {
        internalId: "8",
        'type: "item"
    };
    Item item = {
        item: itemValue,
        amount: 100.00
    };
    NewSalesOrder salesOrder = {
        entity: entity,
        itemList: [item]
    };
    RecordAddResponse|error output = netsuiteClient->addNewSalesOrder(salesOrder);
    if (output is RecordAddResponse) {
        log:printInfo(output.toString());
        salesOrderId = output.internalId;
    } else {
        test:assertFail(output.toString());
    }
}

@test:Config {enable: false}
function testAddClassificationRecord() {
    log:printInfo("testAddClassificationRecord");
    RecordInputRef recordRef = {
        internalId: "1",
        'type: "parent"
    };
    NewClassification classification = {
        name: "Ballerina test class",
        parent: recordRef,
        isInactive: false
    };
    RecordAddResponse|error output = netsuiteClient->addNewClassification(classification);
    if (output is RecordAddResponse) {
        log:printInfo(output.toString());
        classificationId = output.internalId;
    } else {
        test:assertFail(output.toString());
    }
}

@test:Config {enable: false}
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
        //acctType: ACCOUNTS_PAYABLE
    };
    RecordAddResponse|error output = netsuiteClient->addNewAccount(account);
    if (output is RecordAddResponse) {
        log:printInfo(output.toString());
        customerAccountId = output.internalId;
    } else {
        test:assertFail(output.toString());
    }
}

@test:Config {
      enable: false,
    dependsOn: [testAddNewCustomerRecord]
}
function testUpdateCustomerRecord() {
    log:printInfo("testUpdateCustomerRecord");
    RecordRef subsidiary = {
        internalId: "1",
        'type: "subsidiary"
    };

    Address ad02 = {
        country: "_sriLanka",
        addr1: "address01_4",
        addr2: "address02_4",
        city: "Colombo07",
        override: true
    };

    CustomerAddressbook customerAddressbook = {
        defaultShipping: true,
        defaultBilling: true,
        label: "myAddress",
        isResidential: true,
        addressBookAddress: [ad02]
    };

    Customer customer = {
        internalId: customerId,
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

@test:Config {
      enable: false,
    dependsOn: [testAddSalesOrderOperation]
}
function testSalesOrderUpdateOperation() {
    log:printInfo("testSalesOrderUpdateOperation");
    RecordRef itemValue = {
        internalId: "8",
        'type: "item"
    };
    Item item = {
        item: itemValue,
        amount: 200.00
    };
    SalesOrder salesOrder = {
        itemList: [item],
        internalId: salesOrderId
    };
    RecordUpdateResponse|error output = netsuiteClient->updateSalesOrderRecord(salesOrder);
    if (output is RecordUpdateResponse) {
        log:printInfo(output.toString());
        salesOrderId = output.internalId;
    } else {
        test:assertFail(output.toString());
    }
}

@test:Config {
      enable: false,
    dependsOn: [testAddClassificationRecord]
}
function testUpdateClassificationRecord() {
    log:printInfo("testUpdateClassificationRecord");
    Classification classification = {
        name: "Ballerina test class_Updated",
        internalId: classificationId
    };
    RecordUpdateResponse|error output = netsuiteClient->updateClassificationRecord(classification);
    if (output is RecordAddResponse) {
        log:printInfo(output.toString());
    } else {
        test:assertFail(output.toString());
    }
}

@test:Config {
      enable: false,
    dependsOn: [testAddAccountRecord]
}
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
        test:assertFail(output.toString());
    }
}

@test:Config {
      enable: false,
        dependsOn: [testAddInvoiceRecord]
}
function testUpdateInvoiceRecord() {
    log:printInfo("testUpdateInvoiceRecord");
    Item item01 = {
        item: {
            internalId: "14",
            'type: "item"
        },
        quantity: 20,
        amount: 1040,
        line: 2
    }; 
    Invoice invoice = {
        internalId: invoiceId,
        email: "test@ecosystem.com",
        itemList: [item01]
    };
    RecordUpdateResponse|error output = netsuiteClient->updateInvoiceRecord(invoice, false);
    if (output is RecordAddResponse) {
        log:printInfo(output.toString());
    } else {
        test:assertFail(output.toString());
    }
}

@test:Config {
      enable: false,
    dependsOn: [testAddContactRecordOperation]
}
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
        test:assertFail(output.toString());
    }
}

@test:Config {enable: false}
function testCustomerSearchOperation() {
    log:printInfo("testCustomerSearchOperation");
    SearchElement searchRecord = {
        fieldName: "isInactive",
        operator: "is",
        searchType: SEARCH_BOOLEAN_FIELD,
        value1: "false"
    };
    SearchElement[] searchData = [];
    searchData.push(searchRecord);
    var output = netsuiteClient->searchCustomerRecords(searchData);
    if (output is stream<SearchResult, error?>) {
        int index = 0;
        error? response = output.forEach(function(SearchResult queryResult) {
                                      index = index + 1;
                                  });
        log:printInfo("Total count of records : " + index.toString());
    } else {
        test:assertFail(msg = output.toString());
    }
}

@test:Config {enable: false}
function testAccountSearchOperation() {
    log:printInfo("testAccountSearchOperation");
    SearchElement searchRecord = {
        fieldName: "name",
        searchType: SEARCH_STRING_FIELD,
        operator: "contains",
        value1: "Ballerina"
    };
    SearchElement[] searchElements = [searchRecord];
    var output = netsuiteClient->searchAccountRecords(searchElements);
    if (output is stream<SearchResult, error?>) {
        int index = 0;
        error? response = output.forEach(function(SearchResult account) {
                                      index = index + 1;
                                  });
        log:printInfo("Total count of records : " + index.toString());
    } else {
        test:assertFail(msg = output.toString());
    }
}

@test:Config {enable: false}
function testContactSearchOperation() {
    log:printInfo("testContactSearchOperation");
    SearchElement searchRecord = {
        fieldName: "firstName",
        searchType: SEARCH_STRING_FIELD,
        operator: OP_DOES_NOT_CONTAIN,
        value1: "Wso2"
    };
    SearchElement[] searchElements = [searchRecord];
    var output = netsuiteClient->searchContactRecords(searchElements);
    if (output is stream<SearchResult, error?>) {
        int index = 0;
        error? response = output.forEach(function(SearchResult contact) {
                                      index = index + 1;
                                  });
        log:printInfo("Total count of records : " + index.toString());
    } else {
        test:assertFail(msg = output.toString());
    }
}

@test:Config {enable: false}
function testTransactionSearchOperation() {
    log:printInfo("testTransactionSearchOperation");
    SearchElement searchRecord1 = {
        fieldName: "amount",
        searchType: SEARCH_DOUBLE_FIELD,
        operator: "between",
        value1: "150000",
        value2: "200000"
    };
    SearchElement[] searchElements = [searchRecord1];
    var output = netsuiteClient->searchTransactionRecords(searchElements);
    if (output is stream<SearchResult, error?>) {
        int index = 0;
        error? response = output.forEach(function(SearchResult recordRef) {
                                      index = index + 1;
                                  });
        log:printInfo("Total count of records : " + index.toString());
    } else {
        test:assertFail(msg = output.toString());
    }
}

@test:Config {
      enable: false,
    dependsOn: [testCustomerSearchOperation, testUpdateCustomerRecord, testCustomerRecordGetOperation]
}
function testCustomerDeleteRecord() {
    log:printInfo("Record Deletion Start");
    log:printInfo("testCustomerDeleteRecord");
    RecordDetail recordDeletionInfo = {
        recordInternalId: customerId,
        recordType: "customer"
    };
    RecordDeletionResponse|error output = netsuiteClient->deleteRecord(recordDeletionInfo);
    if (output is RecordDeletionResponse) {
        log:printInfo(output.toString());
    } else {
        test:assertFail(output.toString());
    }
}

@test:Config {
      enable: false,
    dependsOn: [testUpdateContactRecord, testContactGetOperation]
}
function testContactDeleteOperation() {
    log:printInfo("testContactDeleteRecord");
    RecordDetail recordDeletionInfo = {
        recordInternalId: contactId,
        recordType: "contact"
    };
    RecordDeletionResponse|error output = netsuiteClient->deleteRecord(recordDeletionInfo);
    if (output is RecordDeletionResponse) {
        log:printInfo(output.toString());
    } else {
        test:assertFail(output.toString());
    }
}

@test:Config {
      enable: false,
    dependsOn: [testAddCurrencyRecord, testCurrencyRecordGetOperation]
}
function testCurrencyDeleteOperation() {
    log:printInfo("testCurrencyDeleteRecord");
    RecordDetail recordDeletionInfo = {
        recordInternalId: currencyId,
        recordType: "currency"
    };
    RecordDeletionResponse|error output = netsuiteClient->deleteRecord(recordDeletionInfo);
    if (output is RecordDeletionResponse) {
        log:printInfo(output.toString());
    } else {
        test:assertFail(output.toString());
    }
}

@test:Config {
      enable: false,
    dependsOn: [testGetClassificationRecordOperation]
}
function testDeleteClassificationRecord() {
    log:printInfo("testDeleteClassificationRecord");
    RecordDetail recordDeletionInfo = {
        recordInternalId: classificationId,
        recordType: "classification"
    };
    RecordDeletionResponse|error output = netsuiteClient->deleteRecord(recordDeletionInfo);
    if (output is RecordDeletionResponse) {
        log:printInfo(output.toString());
    } else {
        test:assertFail(output.toString());
    }
}

@test:Config {
      enable: false,
    dependsOn: [testAccountSearchOperation, testUpdateAccountRecord]
}
function testDeleteAccountRecord() {
    log:printInfo("testDeleteAccountRecord");
    RecordDetail recordDeletionInfo = {
        recordInternalId: customerAccountId,
        recordType: ACCOUNT
    };
    RecordDeletionResponse|error output = netsuiteClient->deleteRecord(recordDeletionInfo);
    if (output is RecordDeletionResponse) {
        log:printInfo(output.toString());
    } else {
        test:assertFail(output.toString());
    }
}

@test:Config {
      enable: false,
    dependsOn: [testSalesOrderGetOperation, testSalesOrderUpdateOperation]
}
function testDeleteSalesOrderRecord() {
    log:printInfo("testDeleteSalesOrderRecord");
    RecordDetail recordDeletionInfo = {
        recordInternalId: salesOrderId,
        recordType: SALES_ORDER
    };
    RecordDeletionResponse|error output = netsuiteClient->deleteRecord(recordDeletionInfo);
    if (output is RecordDeletionResponse) {
        log:printInfo(output.toString());
    } else {
        test:assertFail(output.toString());
    }
}

@test:Config {
      enable: false,
    dependsOn: [testInvoiceRecordGetOperation, testUpdateInvoiceRecord]
}
function testDeleteInvoiceRecord() {
    log:printInfo("testDeleteInvoiceRecord");
    RecordDetail recordDeletionInfo = {
        recordInternalId: invoiceId,
        recordType: INVOICE
    };
    RecordDeletionResponse|error output = netsuiteClient->deleteRecord(recordDeletionInfo);
    if (output is RecordDeletionResponse) {
        log:printInfo(output.toString());
    } else {
        test:assertFail(output.toString());
    }
}

@test:Config {
      enable: false,
    dependsOn: [testAddItemGroupRecordOperation, testGetItemGroupRecord]
}
function testDeleteItemGroupRecord() {
    log:printInfo("testDeleteItemGroupRecord");
    RecordDetail recordDeletionInfo = {
        recordInternalId: itemGroupId,
        recordType: ITEM_GROUP
    };
    RecordDeletionResponse|error output = netsuiteClient->deleteRecord(recordDeletionInfo);
    if (output is RecordDeletionResponse) {
        log:printInfo(output.toString());
    } else {
        test:assertFail(output.toString());
    }
}

@test:Config {enable: false}
function testGetAllCurrencyRecords() {
    log:printInfo("testGetAllCurrencyRecords");
    Currency[]|error output = netsuiteClient->getAllCurrencyRecords();
    if (output is Currency[]) {
        log:printInfo("Number of records found: " + output.length().toString());
    } else {
        test:assertFalse(true, output.toString());
    }
}

@test:Config {enable: false}
function testGetServerTime() {
    log:printInfo("testGetNetSuiteServerTime");
    string|error output = netsuiteClient->getNetSuiteServerTime();
    if (output is string) {
        log:printInfo(output.toString());
    } else {
        test:assertFalse(true, output.toString());
    }
}

string savedSearchID = EMPTY_STRING;

@test:Config {enable: false}
function testGetSavedSearchIds() {
    log:printInfo("testGetSavedSearchIds");
    SavedSearchResponse|error output = netsuiteClient->getSavedSearchIDs("vendor");
    if (output is SavedSearchResponse) {
        savedSearchID = output.recordRefList[0].internalId;
    } else {
        test:assertFalse(true, output.toString());
    }
}

@test:Config {
      enable: false,
    dependsOn: [testGetSavedSearchIds]
}
function testPerformSavedSearchById() {
    log:printInfo("testPerformSavedSearchById");
    var output = netsuiteClient->performSavedSearchById(savedSearchID, "VendorSearchAdvanced");
    if (output is stream<SearchResult, error?>) {
        int index = 0;
        error? response = output.forEach(function(SearchResult queryResult) {
                                      index = index + 1;
                                      if (index == 1) {
                                          log:printInfo(queryResult.toString());
                                      }
                                  });
        log:printInfo("Total count of records in SavedSearchResults : " + index.toString());
    } else {
        test:assertFalse(true, output.toString());
    }
}

@test:Config {
      enable: false,
    dependsOn: [testAddNewCustomerRecord]
}
function testCustomerRecordGetOperation() {
    log:printInfo("testCustomerRecordGetOperation");
    RecordInfo recordDetail = {
        recordInternalId: customerId,
        recordType: "customer"
    };
    Customer|error output = netsuiteClient->getCustomerRecord(recordDetail);
    if (output is error) {
        test:assertFalse(true, output.toString());
    } else {
        log:printInfo(output.toString());
    }
}

@test:Config {
      enable: false,
    dependsOn: [testAddCurrencyRecord]
}
function testCurrencyRecordGetOperation() {
    log:printInfo("testCurrencyRecordGetOperation");
    RecordInfo recordDetail = {
        recordInternalId: currencyId,
        recordType: "currency"
    };
    Currency|error output = netsuiteClient->getCurrencyRecord(recordDetail);
    if (output is error) {
        test:assertFalse(true, output.toString());
    } else {
        log:printInfo(output.toString());
    }
}

@test:Config {
      enable: false,
    dependsOn: [testUpdateClassificationRecord]
}
function testGetClassificationRecordOperation() {
    log:printInfo("testGetClassificationRecordOperation");
    RecordInfo recordDetail = {
        recordInternalId: classificationId,
        recordType: "classification"
    };
    Classification|error output = netsuiteClient->getClassificationRecord(recordDetail);
    if (output is error) {
        test:assertFalse(true, output.toString());
    } else {
        log:printInfo(output.toString());
    }
}

@test:Config {
      enable: false,
      dependsOn: [testAddInvoiceRecord]
}
function testInvoiceRecordGetOperation() {
    log:printInfo("testInvoiceRecordGetOperation");
    RecordInfo recordDetail = {
        recordInternalId: invoiceId,
        recordType: INVOICE
    };
    Invoice|error output = netsuiteClient->getInvoiceRecord(recordDetail);
    if (output is error) {
        test:assertFalse(true, output.toString());
    } else {
        log:printInfo(output.toString());
    }
}

@test:Config {
      enable: false,
    dependsOn: [testAddSalesOrderOperation]
}
function testSalesOrderGetOperation() {
    log:printInfo("testSalesOrderGetOperation");
    RecordInfo recordDetail = {
        recordInternalId: salesOrderId,
        recordType: SALES_ORDER
    };
    SalesOrder|error output = netsuiteClient->getSalesOrderRecord(recordDetail);
    if (output is error) {
        test:assertFalse(true, output.toString());
    } else {
        log:printInfo(output.toString());
    }
}

@test:Config {
      enable: false,
    dependsOn: [testAddContactRecordOperation]
}
function testContactGetOperation() {
    log:printInfo("testContactGetOperation");
    RecordInfo recordDetail = {
        recordInternalId: contactId,
        recordType: CONTACT
    };
    Contact|error output = netsuiteClient->getContactRecord(recordDetail);
    if (output is error) {
        test:assertFalse(true, output.toString());
    } else {
        log:printInfo(output.toString());
    }
}

@test:Config {
      enable: false,
    dependsOn: [testUpdateAccountRecord]
}
function testAccountGetOperation() {
    log:printInfo("testAccountGetOperation");
    RecordInfo recordDetail = {
        recordInternalId: customerAccountId,
        recordType: ACCOUNT
    };
    Account|error output = netsuiteClient->getAccountRecord(recordDetail);
    if (output is error) {
        test:assertFalse(true, output.toString());
    } else {
        log:printInfo(output.toString());
    }
}

@test:Config {enable: false}
function testAddNewVendor() {
    log:printInfo("testAddNewVendor");
    LongCustomFieldRef longCustomFieldRef = {
        internalId: "11",
        scriptId: "100_lk",
        value: 30
    };

    StringOrDateCustomFieldRef stringCustomFieldRef = {
        internalId: "21",
        scriptId: "100_lk",
        value: "test value"
    };

    BooleanCustomFieldRef booleanCustomFieldRef = {
        internalId: "221",
        scriptId: "bool_lk",
        value: false
    };

    DoubleCustomFieldRef doubleCustomFieldRef = {
        internalId: "2342",
        scriptId: "wso2_script",
        value: 2.34
    };

    MultiSelectCustomFieldRef multiSelectCustomFieldRef = {
        internalId: "2342_multi",
        scriptId: "wso2_script_2",
        value: [{
            recordName: "test_multiSelect1",
            internalId: "1"
        }, {
            recordName: "test_multiSelect2",
            internalId: "2"
        }]
    };

    NewVendor vendor = {
        subsidiary: {
            internalId: "1",
            'type: "subsidiary"
        },
        companyName: "Wso2Test",
        isPerson: true,
        lastName: "wso2",
        firstName: "wso2_lanka",
        customFieldList: {customFields: [booleanCustomFieldRef, longCustomFieldRef, stringCustomFieldRef, 
            doubleCustomFieldRef, multiSelectCustomFieldRef]}
    };
    var output = netsuiteClient->addNewVendor(vendor);
    if (output is RecordAddResponse) {
        log:printInfo(output.toString());
        vendorId = output.internalId;
    } else {
        test:assertFail(output.toString());
    }
}

@test:Config {
      enable: false,
    dependsOn: [testAddNewVendor]
}
function testUpdateVendor() {
    log:printInfo("testUpdateVendor");
    Vendor vendor = {
        internalId: vendorId,
        companyName: "Wso2Test_updated"
    };
    var output = netsuiteClient->updateVendorRecord(vendor);
    if (output is RecordAddResponse) {
        log:printInfo(output.toString());
    } else {
        test:assertFail(output.toString());
    }
}

@test:Config {enable: false}
function testVendorGetOperation() {
    log:printInfo("testVendorGetOperation");
    RecordInfo recordInfo = {
        recordInternalId: vendorId,
        recordType: "vendor"
    };
    Vendor|error output = netsuiteClient->getVendorRecord(recordInfo);
    if (output is Vendor) {
        log:printInfo(output.toString());
    } else {
        test:assertFail(output.toString());
    }
}

@test:Config {
      enable: false,
    dependsOn: [testVendorGetOperation]
}
function testVendorRecordDeleteOperation() {
    log:printInfo("testVendorDeleteOperation");
    RecordDetail recordDeletionInfo = {
        recordInternalId: vendorId,
        recordType: "vendor"
    };
    RecordDeletionResponse|error output = netsuiteClient->deleteRecord(recordDeletionInfo);
    if (output is RecordDeletionResponse) {
        log:printInfo(output.toString());
    } else {
        test:assertFail(output.toString());
    }
}

@test:Config {enable: false}
function testAddNewVendorBill() {
    log:printInfo("testAddNewVendorBill");
    VendorBillExpenseList vendorBillExpenseList = {expenses: [{
            line: 1,
            account: {
                internalId: "58",
                'type: "account"
            },
            amount: 105.7
        }]};
    NewVendorBill vendorBill = {
        subsidiary: {
            internalId: "1",
            'type: "subsidiary"
        },
        entity: {
            'type: "entity",
            internalId: "1305"
        },
        expenseList: vendorBillExpenseList,
        accountingBookDetailList: {accountingBookDetail: [{
                accountingBook: {
                    'type: "accountingBook",
                    internalId: "201"
                },
                exchangeRate: 1
            }]}
    };
    var output = netsuiteClient->addNewVendorBill(vendorBill);
    if (output is RecordAddResponse) {
        log:printInfo(output.toString());
        vendorBillId = output.internalId;
    } else {
        test:assertFail(output.toString());
    }
}

@test:Config {enable: false, dependsOn: [testAddNewVendorBill]}
function testUpdateVendorBill() {
    log:printInfo("testUpdateVendorBill");

    VendorBill vendorBill = {
        internalId: vendorBillId,
        subsidiary: {
            internalId: "1",
            'type: "subsidiary"
        },
        entity: {
            'type: "entity",
            internalId: "1305"
        },
        memo: "test_bill"
    };
    var output = netsuiteClient->updateVendorBillRecord(vendorBill);
    if (output is RecordAddResponse) {
        log:printInfo(output.toString());
        vendorBillId = output.internalId;
    } else {
        test:assertFail(output.toString());
    }
}

@test:Config {
      enable: false,
    dependsOn: [testUpdateVendorBill]
}
function testVendorBillGetOperation() {
    log:printInfo("testVendorBillGetOperation");
    RecordInfo recordInfo = {
        recordInternalId: vendorBillId,
        recordType: "vendorBill"
    };
    VendorBill|error output = netsuiteClient->getVendorBillRecord(recordInfo);
    if (output is VendorBill) {
        log:printInfo(output.toString());
    } else {
        test:assertFail(output.toString());
    }
}

@test:Config {
      enable: false,
    dependsOn: [testVendorBillGetOperation]
}
function testVendorBillRecordDeleteOperation() {
    log:printInfo("testVendorBillDeleteOperation");
    RecordDetail recordDeletionInfo = {
        recordInternalId: vendorBillId,
        recordType: "vendorBill"
    };
    RecordDeletionResponse|error output = netsuiteClient->deleteRecord(recordDeletionInfo);
    if (output is RecordDeletionResponse) {
        log:printInfo(output.toString());
    } else {
        test:assertFail(output.toString());
    }
}

@test:Config {enable: false}
function testVendorSearchOperation() {
    log:printInfo("testVendorSearchOperation");
    SearchElement searchRecord2 = {
        fieldName: "email",
        operator: "contains",
        searchType: SEARCH_STRING_FIELD,
        value1: "com"
    };
    SearchElement[] searchData = [searchRecord2];
    var output = netsuiteClient->searchVendorRecords(searchData);
    if (output is stream<SearchResult, error?>) {
        int index = 0;
        error? response = output.forEach(function(SearchResult queryResult) {
                                      index = index + 1;
                                  });
        log:printInfo("Total count of records : " + index.toString());
    } else {
        test:assertFail(msg = output.toString());
    }
}

@test:Config {enable: false}
function testSendCustomRequest() {
    log:printInfo("testCustomOperation");
    string body = string ` <urn:getServerTime/>`;
    xml|error output = netsuiteClient->makeCustomRequest(body, "getServerTime");
    if (output is xml) {
        log:printInfo(output.toString());
    } else {
        test:assertFail(output.toString());
    }
}
