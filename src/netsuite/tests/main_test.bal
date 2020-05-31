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

import ballerina/config;
import ballerina/log;
import ballerina/system;
import ballerina/test;

string baseUrl = system:getEnv("NS_BASE_URL");
string accessToken = system:getEnv("NS_ACCESS_TOKEN");
string refreshUrl = system:getEnv("NS_REFRESH_URL");
string refreshToken = system:getEnv("NS_REFRESH_TOKEN");
string clientId = system:getEnv("NS_CLIENT_ID");
string clientSecret = system:getEnv("NS_CLIENT_SECRET");

Configuration nsConfig = {
    baseUrl: baseUrl == "" ? config:getAsString("BASE_URL") : baseUrl,
    oauth2Config: {
        accessToken: accessToken == "" ? config:getAsString("ACCESS_TOKEN") : accessToken,
        refreshConfig: {
            refreshUrl: refreshUrl == "" ? config:getAsString("REFRESH_URL") : refreshUrl,
            refreshToken: refreshToken == "" ? config:getAsString("REFRESH_TOKEN") : refreshToken,
            clientId: clientId == "" ? config:getAsString("CLIENT_ID") : clientId,
            clientSecret: clientSecret == "" ? config:getAsString("CLIENT_SECRET") : clientSecret
        }
    }
};

Client nsClient = new(nsConfig);

type BalTestCustomRecord record {
    string id = "";
    string name;
    float custrecord_version;
    string custrecord_address;
};

@test:Config { enable:false }
// Before enabling the test case, create the BalTestCustomRecord type in NetSuite account providing the record type
// id as "customrecord_bal_test".
function testCustomizedCompanySpecificRecord() {
    log:printInfo("Testing Custom Record :");

    string customPath = "/customrecord_bal_test";
    readExistingRecord(BalTestCustomRecord, customPath);

    BalTestCustomRecord customRecord = {
        name: "ballerina testing",
        custrecord_version: 1.2,
        custrecord_address: "Col 3"
    };

    string createdId = createOrSearchIfExist(customRecord, "name IS ballerina testing", customPath);
    customRecord = <BalTestCustomRecord> readRecord(<@untained> createdId, BalTestCustomRecord);

    updateAPartOfARecord(customRecord, { "custrecord_version": 3.13 }, "custrecord_version", "3.13", customPath);

    BalTestCustomRecord replaceCustomRecord = { name: "Replaced ballerina testing", custrecord_version: 1.4,
                                                custrecord_address: "pg" };
    updateCompleteRecord(customRecord, replaceCustomRecord, "custrecord_version", "1.4", customPath);

    BalTestCustomRecord newCustomRecord = { name: "Updated ballerina testing", custrecord_version: 5.1,
                                            custrecord_address: "pg" };
    newCustomRecord = <BalTestCustomRecord> upsertCompleteRecord(newCustomRecord, "168334D", customPath);
    newCustomRecord = <BalTestCustomRecord> upsertAPartOfARecord(<@untainted> newCustomRecord,
                            { "custrecord_address": "USA" }, "168334D", "custrecord_address", "USA", customPath);

    deleteRecordTest(<@untainted> customRecord, customPath);
    deleteRecordTest(<@untainted> newCustomRecord, customPath);
}

type TestMessage record {
    string id = "";
    string subject;
};

@test:Config {}
function testExecuteAction() {
    log:printInfo("Testing Execute action :");

    TestMessage message = {
        subject: "Ballerina test message"
    };

    log:printInfo("Creating...");
    json|Error createResult = nsClient->execute(POST, "/message", message);
    if createResult is Error {
        test:assertFail(msg = "execute operation failed: " + createResult.toString());
    }

    map<json> headers = <map<json>> createResult;
    string locationHeader = headers[LOCATION_HEADER].toString();
    string internalId = spitAndGetLastElement(locationHeader, "/");

    log:printInfo("Reading...");
    json|Error readResult = nsClient->execute(GET, "/message/" + internalId);
    if readResult is Error {
        test:assertFail(msg = "execute operation failed: " + readResult.toString());
    }

    var result = TestMessage.constructFrom(<json> readResult);
    if result is error {
        test:assertFail(msg = "record construct failed: " + result.toString());
    }

    message = <TestMessage> result;
    test:assertTrue(message.id != "", msg = "record retrieval failed");

    log:printInfo("Deleting...");
    json|Error deleteResult = nsClient->execute(DELETE, "/message/" + <@untainted> message.id);
    if deleteResult is Error {
        test:assertFail(msg = "execute operation failed: " + deleteResult.toString());
    }
}

@test:Config {}
// Subsidiary is a prerequisite record for the following test case
function testCustomer() {
    log:printInfo("Testing Customer :");

    Subsidiary? subsidiary = ();
    var recordSubsidiary = getARandomPrerequisiteRecord(Subsidiary);
    if (recordSubsidiary is Subsidiary) {
        subsidiary = recordSubsidiary;
    }

    Subsidiary subs = <Subsidiary> subsidiary;
    Customer customer = {
        entityId: "ballerina",
        companyName: "ballerinalang",
        subsidiary: subs
    };

    // Create customer record
    string createdId = createOrSearchIfExist(customer, "entityId IS ballerina");
    customer = <Customer> readRecord(<@untained> createdId, Customer);

    updateAPartOfARecord(customer, { "creditLimit": 200003.1 }, "creditLimit", "200003.1");
    Customer replaceCustomer = { entityId: "ballerina", companyName: "ballerina.io",
                                    "creditLimit": 3002.0, subsidiary: subs };
    updateCompleteRecord(customer, replaceCustomer, "creditLimit", "3002.0");

    Customer newCustomer = { entityId: "ballerinaUpsert", companyName: "ballerina", "creditLimit": 100000.0,
                                subsidiary : subs };
    newCustomer = <Customer> upsertCompleteRecord(newCustomer, "16835EID");
    newCustomer = <Customer> upsertAPartOfARecord(<@untained> newCustomer, { "creditLimit": 13521.0 }, "16835EID",
                                                    "creditLimit", "13521.0");

    subRecordTest(<@untainted> customer, AddressbookCollection, "totalResults", "0");

    deleteRecordTest(<@untainted> customer);
    deleteRecordTest(<@untainted> newCustomer);
}

@test:Config {}
function testCurrency() {
    log:printInfo("Testing Currency :");

    Currency currency = {
        name: "BLA",
        symbol: "BLA",
        currencyPrecision: 3,
        exchangeRate: 3.89
    };

    // Create currency record
    string createdId = createOrSearchIfExist(currency, "name IS BLA");
    currency = <Currency> readRecord(<@untained> createdId, Currency);

    updateAPartOfARecord(currency, { "currencyPrecisioun": 4, "symbol" : "BBB" }, "symbol", "BBB");
    Currency replaceCurrency = { name: "BLA", symbol: "BFF", currencyPrecision: 3, exchangeRate: 5.89 };
    updateCompleteRecord(currency, replaceCurrency, "symbol", "BFF");

    Currency newCurrency = { name: "BLB", symbol: "BLB", currencyPrecision: 6, exchangeRate: 52.89 };
    newCurrency = <Currency> upsertCompleteRecord(newCurrency, "16834EID");
    newCurrency = <Currency> upsertAPartOfARecord(<@untainted> newCurrency,
                            { "currencyPrecisioun": 4, "symbol" : "BFB" }, "16834EID", "symbol", "BFB");

    deleteRecordTest(<@untainted> currency);
    deleteRecordTest(<@untainted> newCurrency);
}

@test:Config {}
// Subsidiary, Customer and ServiceItem are prerequisite records for the following test case
function testSalesOrder() {
    log:printInfo("Testing SalesOrder :");

    Customer? customer = ();
    var recordCustomer = getARandomPrerequisiteRecord(Customer);
    if recordCustomer is Customer {
        customer = recordCustomer;
    }

    Customer retrievedCustomer = <Customer> customer;
    Currency currency = <Currency> retrievedCustomer["currency"];

    NonInventoryItem? nonInventoryItem = ();
    var recordNonInventoryItem = getARandomPrerequisiteRecord(NonInventoryItem);
    if recordNonInventoryItem is NonInventoryItem {
        nonInventoryItem = recordNonInventoryItem;
    }

    ItemElement serviceItem = {
        amount: 39000.0,
        item: <NonInventoryItem> nonInventoryItem,
        itemSubType: "Sale",
        itemType: "NonInvtPart"
    };

    SalesOrder salesOrder = {
        billAddress: "ballerina",
        entity: retrievedCustomer,
        currency: currency,
        item: {
            items: [serviceItem],
            totalResults: 1
        }
    };

    string createdId = createOrSearchIfExist(salesOrder);
    salesOrder = <SalesOrder> readRecord(<@untained> createdId, SalesOrder);

    updateAPartOfARecord(salesOrder, { "shipAddress": "Germany" }, "shipAddress", "Germany");
    Customer? customerEntity = getDummyCustomer();

    SalesOrder newSalesOrder = { billAddress: "Denmark", entity: <Customer> customer, currency: <Currency>
            currency, item: { items: [serviceItem], totalResults: 1 } };
    newSalesOrder = <SalesOrder> upsertCompleteRecord(newSalesOrder, "16836EID");

    deleteRecordTest(<@untainted> salesOrder);
    deleteRecordTest(<@untainted> newSalesOrder);
}

@test:Config {}
// Customer, Classification and ServiceItem are prerequisite records for the following test case
function testInvoice() {
    log:printInfo("Testing Invoice :");

    readExistingRecord(Invoice);

    // Prerequisite Records
    Customer? customer = getDummyCustomer();

    Classification? class = ();
    var recordClassification = getARandomPrerequisiteRecord(Classification);
    if recordClassification is Classification {
        class = recordClassification;
    }

    NonInventoryItem? nonInventoryItem = ();
    var recordNonInventoryItem = getARandomPrerequisiteRecord(NonInventoryItem);
    if recordNonInventoryItem is NonInventoryItem {
        nonInventoryItem = recordNonInventoryItem;
    }

    ItemElement serviceItem = {
        amount: 39000.0,
        item: <NonInventoryItem> nonInventoryItem,
        itemSubType: "Sale",
        itemType: "NonInvtPart"
    };

    Invoice invoice = {
        entity: <Customer> customer,
        class: <Classification> class,
        item: {
            items: [serviceItem],
            totalResults: 1
        },
        memo: "ballerina test"
    };

    // Create invoice record
    string createdId = createOrSearchIfExist(invoice, "memo IS \"ballerina test\"");
    invoice = <Invoice> readRecord(<@untained> createdId, Invoice);

    updateAPartOfARecord(invoice, { "memo": "updated ballerina test" }, "memo", "updated ballerina test");
    Invoice replaceInvoice = { entity: <Customer> customer, class: <Classification> class, item: { items: [serviceItem]
                                }, memo: "replaced ballerina test" };
    updateCompleteRecord(invoice, replaceInvoice, "memo", "replaced ballerina test");

    Invoice newInvoice = { entity: <Customer> customer, class: <Classification> class, item: { items: [serviceItem]
                                    }, memo: "new invoice ballerina test" };
    newInvoice = <Invoice> upsertCompleteRecord(<@untainted> newInvoice, "16835EID");

    deleteRecordTest(<@untainted> invoice);
    deleteRecordTest(<@untainted> newInvoice);
}

@test:Config {}
function testClassification() {
    log:printInfo("Testing Classification :");

    readExistingRecord(Classification);
    Classification class = {
        name: "Ballerina test class"
    };
    string createdId = createOrSearchIfExist(class, "name IS \"Ballerina test class\"");
    class = <Classification> readRecord(<@untained> createdId, Classification);
    deleteRecordTest(<@untainted> class);
}

@test:Config {}
function testAccountingPeriod() {
    log:printInfo("Testing AccountingPeriod :");

    readExistingRecord(AccountingPeriod);

    AccountingPeriod accountingPeriod = {
        periodName: "Ballerina test accountingPeriod",
        startDate: "2019-09-01",
        endDate: "2019-12-31"
    };
    string searchedId = searchForRecord(accountingPeriod, "isinactive IS false");
}

@test:Config { enable:false}
// Record read operation fails due to NetSuite API issue
function testCustomerPayment() {
    log:printInfo("Testing CustomerPayment :");

    readExistingRecord(CustomerPayment);

    // Prerequisite Records
    Customer? customer = getDummyCustomer();

    CustomerPayment customerPayment = {
        customer: <Customer> customer,
        payment: 32000.5,
        memo: "Ballerina test customerPayment"
    };
    string createdId = createOrSearchIfExist(customerPayment, "memo IS \"Ballerina test customerPayment\"");
    customerPayment = <CustomerPayment> readRecord(<@untained> createdId, CustomerPayment);
    deleteRecordTest(<@untainted> customerPayment);
}

@test:Config {}
function testAccount() {
    log:printInfo("Testing Account :");

    readExistingRecord(Account);

    Currency? currency = ();
    var recordCurrency = getARandomPrerequisiteRecord(Currency);
    if recordCurrency is Currency {
        currency = recordCurrency;
    }

    Account account = {
        acctname: "Ballerina test account",
        currency: <Currency> currency,
        acctnumber: "67425629"
    };
    string createdId = createOrSearchIfExist(account, "acctnumber IS 67425629");
    account = <Account> readRecord(<@untained> createdId, Account);
    updateAPartOfARecord(account, { "acctname": "updated Ballerina test account" }, "acctname",
                                    "updated Ballerina test account");
}

@test:Config {}
function testPartner() {
    log:printInfo("Testing Partner :");

    readExistingRecord(Partner);

    Subsidiary? subsidiary = ();
    var recordSubsidiary = getARandomPrerequisiteRecord(Subsidiary);
    if recordSubsidiary is Subsidiary {
        subsidiary = recordSubsidiary;
    }

    Partner partner = {
        entityId: "Ballerina test partner",
        companyName: "ballerinalang",
        subsidiary: <Subsidiary> subsidiary
    };
    string createdId = createOrSearchIfExist(partner, "companyName IS ballerinalang");
    partner = <Partner> readRecord(<@untained> createdId, Partner);
    deleteRecordTest(<@untainted> partner);
}

@test:Config {}
function testOpportunity() {
    log:printInfo("Testing Opportunity :");

    readExistingRecord(Opportunity);

    Customer? customer = getDummyCustomer();

    Subsidiary? subsidiary = ();
    var recordSubsidiary = getARandomPrerequisiteRecord(Subsidiary);
    if recordSubsidiary is Subsidiary {
        subsidiary = recordSubsidiary;
    }

    Customer? endUser = ();
    var recordCustomer = getARandomPrerequisiteRecord(Customer);
    if recordCustomer is Customer {
        endUser = recordCustomer;
    }

    Opportunity opportunity = {
        entity: <Customer> customer,
        titile: "Ballerina test opportunity",
        "custbody_end_user": <Customer> endUser,
        "custbody_order_type": {
            "id": "1",
            "refName": "Contract - New"
          }
    };
    string createdId = createOrSearchIfExist(opportunity, "titile IS Ballerina test opportunity");
    opportunity = <Opportunity> readRecord(<@untained> createdId, Opportunity);
    deleteRecordTest(<@untainted> opportunity);
}

@test:Config {}
function testVendor() {
    log:printInfo("Testing Vendor :");

    readExistingRecord(Vendor);

    Subsidiary? subsidiary = ();
    var recordSubsidiary = getARandomPrerequisiteRecord(Subsidiary);
    if recordSubsidiary is Subsidiary {
        subsidiary = recordSubsidiary;
    }

    Vendor vendor = {
        entityId: "Ballerina test vendor",
        companyName: "ballerinalang",
        subsidiary: <Subsidiary> subsidiary
    };

    string createdId = createOrSearchIfExist(vendor, "companyName IS ballerinalang");
    vendor = <Vendor> readRecord(<@untained> createdId, Vendor);
    updateAPartOfARecord(vendor, { "entityId": "updated ballerina vendor" }, "entityId", "updated ballerina vendor");
    deleteRecordTest(<@untainted> vendor);
}

//@test:Config {enable:false}
//Error while accessing resource: You have entered an Invalid Field Value 159 for the following field: item
function testVendorBill() {
    log:printInfo("Testing Vendor Bill :");

    readExistingRecord(VendorBill);

    Vendor? vendor = ();
    var recordVendor = getARandomPrerequisiteRecord(Vendor);
    if recordVendor is Vendor {
        vendor = recordVendor;
    }

    Classification? class = ();
    var recordClassification = getARandomPrerequisiteRecord(Classification);
    if recordClassification is Classification {
        class = recordClassification;
    }

    NonInventoryItem? nonInventoryItem = ();
    var recordNonInventoryItem = getARandomPrerequisiteRecord(NonInventoryItem);
    if recordNonInventoryItem is NonInventoryItem {
        nonInventoryItem = recordNonInventoryItem;
    }

    ItemElement serviceItem = {
        amount: 39000.0,
        item: <NonInventoryItem> nonInventoryItem,
        itemSubType: "Sale",
        itemType: "NonInvtPart"
    };

    VendorBill vendorBill = {
        entity: <Vendor> vendor,
        tranId: "100102894",
        item: {
            items: [serviceItem],
            totalResults: 1
        },
        class: <Classification> class,
        memo: "ballerina test"
    };

    string createdId = createOrSearchIfExist(vendorBill, "memo IS \"ballerina test\"");
    vendorBill = <VendorBill> readRecord(<@untained> createdId, VendorBill);
    deleteRecordTest(<@untainted> vendorBill);
}

@test:Config {}
function testVendorBillRead() {
    log:printInfo("Testing Vendor Bill read :");

    readExistingRecord(VendorBill);
}

@test:Config {}
function testContact() {
    log:printInfo("Testing Contact :");

    readExistingRecord(Contact);

    Subsidiary? subsidiary = ();
    var recordSubsidiary = getARandomPrerequisiteRecord(Subsidiary);
    if recordSubsidiary is Subsidiary {
        subsidiary = recordSubsidiary;
    }

    Contact contact = {
        entityId: "Ballerina test contact",
        subsidiary: <Subsidiary> subsidiary
    };
    string createdId = createOrSearchIfExist(contact, "entityId IS \"Ballerina test contact\"");
    contact = <Contact> readRecord(<@untained> createdId, Contact);
    deleteRecordTest(<@untainted> contact);
}

@test:Config {}
function testLocation() {
    log:printInfo("Testing Location :");

    readExistingRecord(Location);
    Location location = {
        name: "Ballerina test location"
    };
    string createdId = createOrSearchIfExist(location, "name IS \"Ballerina test location\"");
    location = <Location> readRecord(<@untained> createdId, Location);
    deleteRecordTest(<@untainted> location);
}

@test:Config {}
function testDepartment() {
    log:printInfo("Testing Department :");

    readExistingRecord(Department);
    Department department = {
        name: "Ballerina test department"
    };
    string createdId = createOrSearchIfExist(department, "name IS \"Ballerina test department\"");
    department = <Department> readRecord(<@untained> createdId, Department);
    deleteRecordTest(<@untainted> department);
}

@test:Config {enable:false}
// Record delete operation fails due to NetSuite API issue
function testPaymentMethod() {
    log:printInfo("Testing PaymentMethod :");

    readExistingRecord(PaymentMethod);
    PaymentMethod paymentMethod = {
        name: "Ballerina test paymentMethod"
    };
    string createdId = createOrSearchIfExist(paymentMethod, "name IS \"Ballerina test paymentMethod\"");
    paymentMethod = <PaymentMethod> readRecord(<@untained> createdId, PaymentMethod);
    deleteRecordTest(<@untainted> paymentMethod);
}

@test:Config {}
function testEmployee() {
    log:printInfo("Testing Employee :");

    readExistingRecord(Employee);

    Subsidiary? subsidiary = ();
    var recordSubsidiary = getARandomPrerequisiteRecord(Subsidiary);
    if recordSubsidiary is Subsidiary {
        subsidiary = recordSubsidiary;
    }

    Subsidiary retrievedSubsidiary = <Subsidiary> subsidiary;
    Currency currency = <Currency> retrievedSubsidiary["currency"];


    Employee employee = {
        entityId: "Ballerina test employee",
        subsidiary: retrievedSubsidiary,
        currency: currency
    };
    string createdId = createOrSearchIfExist(employee, "entityId IS \"Ballerina test employee\"");
    employee = <Employee> readRecord(<@untained> createdId, Employee);
    deleteRecordTest(<@untainted> employee);
}

@test:Config {enable:false}
//Error while accessing resource: You have entered an Invalid Field Value 159 for the following field: item
function testPurchaseOrder() {
    log:printInfo("Testing PurchaseOrder :");

    readExistingRecord(PurchaseOrder);

    Customer? customer = ();
    var recordCustomer = getARandomPrerequisiteRecord(Customer);
    if recordCustomer is Customer {
        customer = recordCustomer;
    }

    Customer retrievedCustomer = <Customer> customer;

    NonInventoryItem? nonInventoryItem = ();
    var recordNonInventoryItem = getARandomPrerequisiteRecord(NonInventoryItem);
    if recordNonInventoryItem is NonInventoryItem {
        nonInventoryItem = recordNonInventoryItem;
    }

    ItemElement serviceElement = {
        amount: 39000.0,
        item: <NonInventoryItem> nonInventoryItem,
        itemSubType: "Sale",
        itemType: "NonInvtPart"
    };

    PurchaseOrder purchaseOrder = {
        entity: retrievedCustomer,
        item: {
            items: [serviceElement]
        },
        memo: "Ballerina test purchaseOrder"
    };

    string createdId = createOrSearchIfExist(purchaseOrder, "memo IS \"Ballerina test location\"");
    purchaseOrder = <PurchaseOrder> readRecord(<@untained> createdId, PurchaseOrder);
    deleteRecordTest(<@untainted> purchaseOrder);
}

@test:Config {}
function testPurchaseOrderRead() {
    log:printInfo("Testing PurchaseOrder read:");

    readExistingRecord(PurchaseOrder);
}
