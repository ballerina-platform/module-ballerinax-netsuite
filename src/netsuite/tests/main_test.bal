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
import ballerina/test;

Configuration nsConfig = {
    baseUrl: config:getAsString("BASE_URL"),
    oauth2Config: {
        accessToken: config:getAsString("ACCESS_TOKEN"),
        refreshConfig: {
            refreshUrl: config:getAsString("REFRESH_URL"),
            refreshToken: config:getAsString("REFRESH_TOKEN"),
            clientId: config:getAsString("CLIENT_ID"),
            clientSecret: config:getAsString("CLIENT_SECRET")
        }
    }
};

Client nsClient = new(nsConfig);

@test:Config {}
function testCustomer() {
    log:printInfo("Testing Customer :");

    // Search for mandatory field - Subsidiary
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
    createOrSearchIfExist(customer, "entityId IS ballerina");

    updateAPartOfARecord(customer, { "creditLimit": 200003.1 }, "creditLimit", "200003.1");
    Customer replaceCustomer = { entityId: "ballerina", companyName: "ballerina.io", "creditLimit": 3002.0, subsidiary: subs };
    updateCompleteRecord(customer, replaceCustomer, "creditLimit", "3002.0");

    Customer newCustomer = { entityId: "ballerinaUpsert", companyName: "ballerina", "creditLimit": 100000.0, subsidiary : subs };
    upsertCompleteRecord(newCustomer, "16835EID");
    upsertAPartOfARecord(newCustomer, { "creditLimit": 13521.0 }, "16835EID", "creditLimit", "13521.0");

    subRecordTest(<@untainted> customer, AddressBook, "totalResults", "0");

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
    createOrSearchIfExist(currency, "name IS BLA");

    updateAPartOfARecord(currency, { "currencyPrecisioun": 4, "symbol" : "BBB" }, "symbol", "BBB");
    Currency replaceCurrency = { name: "BLA", symbol: "BFF", currencyPrecision: 3, exchangeRate: 5.89 };
    updateCompleteRecord(currency, replaceCurrency, "symbol", "BFF");

    Currency newCurrency = { name: "BLB", symbol: "BLB", currencyPrecision: 6, exchangeRate: 52.89 };
    upsertCompleteRecord(newCurrency, "16834EID");
    upsertAPartOfARecord(newCurrency, { "currencyPrecisioun": 4, "symbol" : "BFB" }, "16834EID", "symbol", "BFB");

    deleteRecordTest(<@untainted> currency);
    deleteRecordTest(<@untainted> newCurrency);
}



@test:Config {}
function testSalesOrder() {
    log:printInfo("Testing SalesOrder :");

    Customer? customer = ();
    var recordCustomer = getARandomPrerequisiteRecord(Customer);
    if recordCustomer is Customer {
        customer = recordCustomer;
    }

    Currency? currency = ();
    var recordCurrency = getARandomPrerequisiteRecord(Currency, "symbol IS USD");
    if recordCurrency is Currency {
        currency = recordCurrency;
    }

    ItemElement serviceItem = {
        amount: 39000.0,
        item: {
            "id": "21",
            "refName": "Development Services"
        },
        "itemSubType": "Sale",
        "itemType": "Service"
    };


    SalesOrder salesOrder = {
        billAddress: "ballerina",
        entity: <Customer> customer,
        currency: <Currency> currency,
        item: {
            items: [serviceItem],
            totalResults: 1
        }
    };

    createOrSearchIfExist(salesOrder);

    updateAPartOfARecord(salesOrder, { "shipAddress": "Germany" }, "shipAddress", "Germany");
    Customer? customerEntity = getDummyCustomer();
    SalesOrder replaceSalesOrder = {
        billAddress: "ballerina.io",
        entity: <Customer> customerEntity,
        currency: <Currency> currency,
        item: { items: [serviceItem], totalResults: 1 }
    };
    updateCompleteRecord(salesOrder, replaceSalesOrder, "billAddress", "ballerina.io");

    SalesOrder newSalesOrder = { billAddress: "Denmark", entity: <Customer> customer, currency: <Currency>
            currency, item: { items: [serviceItem], totalResults: 1 } };
    upsertCompleteRecord(newSalesOrder, "16836EID");

    deleteRecordTest(<@untainted> salesOrder);
    deleteRecordTest(<@untainted> newSalesOrder);
}

@test:Config {}
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

    ItemElement serviceItem = {
        amount: 39000.0,
        item: {
            "id": "21",
            "refName": "Development Services"
        },
        "itemSubType": "Sale",
        "itemType": "Service"
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
    createOrSearchIfExist(invoice, "memo IS \"ballerina test\"");

    updateAPartOfARecord(invoice, { "memo": "updated ballerina test" }, "memo", "updated ballerina test");
    Invoice replaceInvoice = { entity: <Customer> customer, class: <Classification> class, item: { items: [serviceItem]
                                }, memo: "replaced ballerina test" };
    updateCompleteRecord(invoice, replaceInvoice, "memo", "replaced ballerina test");

    Invoice newInvoice = { entity: <Customer> customer, class: <Classification> class, item: { items: [serviceItem]
                                    }, memo: "new invoice ballerina test" };
    upsertCompleteRecord(<@untainted> newInvoice, "16835EID");

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
    createOrSearchIfExist(class, "name IS \"Ballerina test class\"");
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
    searchForRecord(accountingPeriod, "isinactive IS false");
}

//@test:Config { enable:false}
// Record read operation fails due to NetSuite issue
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
    createOrSearchIfExist(customerPayment, "memo IS \"Ballerina test customerPayment\"");
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
    createOrSearchIfExist(account, "acctnumber IS 67425629");
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
    createOrSearchIfExist(partner, "companyName IS ballerinalang");
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
    createOrSearchIfExist(opportunity, "titile IS Ballerina test opportunity");
    deleteRecordTest(<@untainted> opportunity);
}

@test:Config {}
function testSearchOperationWithMultipleResultPages() {
    var res = nsClient->search(Customer, limit = 100, offset = 0);
    if (res is error) {
        test:assertFail(msg = "multiple result page search failed: " + res.toString());
    } else {
        test:assertTrue(res.length() != 0, msg = "search failed");
    }
}
