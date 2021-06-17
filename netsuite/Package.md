# Ballerina NetSuite Connector
based on SOAP webservice

[![CI](https://github.com/ballerina-platform/module-ballerinax-netsuite/actions/workflows/ci.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-netsuite/actions/workflows/ci.yml)
![GitHub release (latest by date including pre-releases)](https://img.shields.io/github/v/release/ballerina-platform/module-ballerinax-netsuite?color=green&include_prereleases&label=latest%20release)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
# Introduction

This module allows you to access the NetSuite's SuiteTalk REST Web services API though Ballerina. NetSuite is used for 
Enterprise Resource Planning (ERP) and to manage inventory, track their financials, host e-commerce stores, and maintain 
Customer Relationship Management (CRM) systems. The NetSuite connector can execute CRUD (create, read, update, delete) 
and search operations to perform business processing on NetSuite records and to navigate dynamically between records.

## Supported Versions and Limitations

|                             |           Version                    |
|:---------------------------:|:------------------------------------:|
| Ballerina Language          |     Swan Lake Beta 1                 |
| NetSuite SOAP API           |     SOAP 1.1                         |
| WSDL version                |     2020.2.0                         |

### Prerequisites
1. Download and install [Ballerina](https://ballerinalang.org/downloads/).
2. NetSuite Account

### Configuration

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


## Quickstart(s)
1. Create a Ballerina file and import the following Netsuite module and the others.
```ballerina
import ballerinax/netsuite;
```
2. Create a NetSuite Client by providing credentials.
```ballerina
public function main() returns error? {
    netsuite:NetsuiteConfiguration nsConfig = {
        accountId: "<accountId>",
        consumerId: "<consumerId>",
        consumerSecret: "<consumerSecret>",
        token: "<token>",
        tokenSecret: "<tokenSecret>",
        baseURL: "<webServiceURL>/services/NetSuitePort_2020_2"
    };
    netsuite:Client netsuiteClient = check new(nsConfig);
```
3. Use remote functions of the connector to create, read, update, and delete records in NetSuite.
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
4. Open an terminal and change directory to where your file is saved and use `bal run <YOUR_BALLERINA_FILE_NAME>.bal` command to run the ballerina file.

## Samples

Instantiate the connector by giving authentication details in the HTTP client config, which has built-in support for 
TBA . NetSuite uses TBA to authenticate and authorize requests. The NetSuite connector can be instantiated 
in the HTTP client config using the client ID, client secret, access token and access token secret. You may use Ballerina [Configuration variable](https://ballerina.io/learn/by-example/configurable.html) to store your credentials.

**More samples are available [here](samples).**
