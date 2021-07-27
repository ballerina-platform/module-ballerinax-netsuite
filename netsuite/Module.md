## Overview
This module allows you to access the NetSuite's SuiteTalk REST Web services API though Ballerina. NetSuite is used for 
Enterprise Resource Planning (ERP) and to manage inventory, track their financials, host e-commerce stores, and maintain 
Customer Relationship Management (CRM) systems. The NetSuite connector can execute CRUD (create, read, update, delete) 
and search operations to perform business processing on NetSuite records and to navigate dynamically between records.

This module supports Ballerina version.

## Prerequisites
Before using this connector in your Ballerina application, complete the following:
* A NetSuite account
* Obtaining tokens
1. Go to [NetSuite](https://www.netsuite.com) and login to your account.
2. If you have NetSuite Permission to Create Integration APP, The following steps may be helpful or else go to step 03.
    1. Enable the SuiteTalk Web service features of the account (Setup->Company->Enable Features).
    
    2. Create an integration application (Setup->Integration->New), enable TBA code grant and scope, and obtain the 
    following credentials: 
        * Client ID
        * Client Secret
3. If you have Client ID, Client Secret from your administrator, Obtain the below credentials by following the token based authorization in the [NetSuite documentation](https://system.na0.netsuite.com/app/help/helpcenter.nl?fid=book_1559132836.html&vid=_BLm3ruuApc_9HXr&chrole=17&ck=9Ie2K7uuApI_9PHO&cktime=175797&promocode=&promocodeaction=overwrite&sj=7bfNB5rzdVQdIKGhDJFE6knJf%3B1590725099%3B165665000). 
    * Access Token
    * Access Token Secret
4. Obtain the SuiteTalk Base URL, which contains the account ID under the company URLs (Setup->Company->Company
    Information).

        E.g:  https://<ACCOUNT_ID>.suitetalk.api.netsuite.com
* Configure the connector with obtained tokens


## Quickstart
To use the NetSuite connector in your Ballerina application, update the .bal file as follows:
### Step1: Import the module
* Create a Ballerina file and import the following Netsuite module and the others. 
```ballerina
import ballerinax/netsuite;
```
### Step2: Provide Client configuration
2. Create a NetSuite Client by providing credentials. Initialize the connector by giving authentication details in the HTTP client config, which has built-in support for Token Based Authentication(TBA). NetSuite uses TBA to authenticate and authorize requests. The NetSuite connector can be initialized by the HTTP client config using the client ID, client secret, access token and access token secret. You may use Ballerina [Configuration variable](https://ballerina.io/learn/by-example/configurable.html) to store your credentials.
```ballerina
public function main() returns error? {
    netsuite:NetsuiteConfiguration nsConfig = {
        accountId: "<accountId>",
        consumerId: "<consumerId>",
        consumerSecret: "<consumerSecret>",
        token: "<token>",
        tokenSecret: "<tokenSecret>",
        baseURL: "<webServiceURL>"
    };
```
### Step3: Client initialization
```ballerina
    netsuite:Client netsuiteClient = check new(nsConfig);
```
### Step4: Use remote functions of the connector to create, read, update, and delete records in NetSuite.
```ballerina
    netsuite:RecordInputRef currency = {
        internalId: "1",
        'type: "currency"
    };
    netsuite:NewAccount account = {
        acctNumber: "1234567",
        acctName: "Ballerina NetSuite Demo Account",
        currency: currency
    };
    netsuite:RecordAddResponse|error newAccount = netsuiteClient->addNewAccount(account);
    if (newAccount is netsuite:RecordAddResponse) {
        log:printInfo(output.toString());
    } else {
        log:printError(newAccount.message());
    }
}
```

## Quick reference 
Code snippets of some frequently used functions: 

* Add a new contact
```ballerina
    netsuite:RecordInputRef subsidiary = {
        internalId : "11",
        'type: "subsidiary"
    };

    netsuite:Address address = {
        // Should provide the country with correct format Ex: _sriLanka
        // Refer the NetSuite SOAP Documentation
        country: <country>,
        addr1: <address01>,
        addr2:<address02>,
        city: <city>,
        override: true
    };

    netsuite:ContactAddressBook contactAddressBook = {
        defaultShipping: true,
        defaultBilling: true,
        label: "myAddress",
        addressBookAddress: [address]
    };
    
    netsuite:NewContact contact= {
        firstName: <first name>>,
        middleName: <middle name>,
        isPrivate: <true or false>,
        subsidiary: subsidiary,
        addressBookList : [contactAddressBook]
    };
    netsuite:RecordAddResponse|error output = netsuiteClient->addNewContact(contact);
```
* Add an invoice record
```ballerina
    netsuite:RecordInputRef entity = {
        internalId : "5530",
        'type: "entity"
    };
    netsuite::Item item01 = {
        item: {
            internalId: "560",
            'type: "item"
         },
        amount: 1000
    };
    netsuite:Item item02 = {
        item: {
            internalId: "570",
            'type: "item"
         },
        amount: 2000
    };
    netsuite:NewInvoice invoice = {
        entity: entity,
        itemList: [item01, item02]
    };
    netsuite:RecordAddResponse|error output = netsuiteClient->addNewInvoice(invoice);

```
* Search Customers
```ballerina
    netsuite:SearchElement searchElement = {
        fieldName: "isInactive",
        operator:"is",
        searchType: netsuite:SEARCH_BOOLEAN_FIELD ,
        value1: "false"
    };
    netsuite:SearchElement[] searchElements = [searchElement];
    var output = netsuiteClient->searchCustomerRecords(searchElements);
    if (output is stream<netsuite:Customer, error>) {
        int index = 0;
        error? e = output.forEach(function (netsuite:Customer queryResult) {
            index = index + 1;
        });
        log:printInfo("Total count of records : " +  index.toString());        
    } else {
        log:printError(output.toString());     
    }
```
* Delete a record
```ballerina
   netsuite:RecordDetail recordDeletionInfo = {
        recordInternalId : <Record ID>,
        recordType: netsuite:<Record Type Ex: netsuite:SALES_ORDER>
    };
    netsuite:RecordDeletionResponse|error output = netsuiteClient->deleteRecord(recordDeletionInfo);
    if (output is netsuite:RecordDeletionResponse) {
        log:printInfo(output.toString());
    } else {
        log:printError(output.toString());
    }
```
**[You can find a list of samples here](https://github.com/ballerina-platform/module-ballerinax-netsuite/tree/master/netsuite/samples).**
