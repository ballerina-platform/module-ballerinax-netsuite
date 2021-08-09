## Overview

NetSuite's [SuiteTalk SOAP API](https://www.netsuite.com/portal/developers/resources/suitetalk-documentation.shtml) provides the capability to access NetSuite operations related to different kinds of NetSuite records such as Account, Client, Transactions, Invoice, Classifications etc.

This module supports [NetSuite WSDL 2020.2.0](https://system.netsuite.com/help/helpcenter/en_US/srbrowser/Browser2020_2/schema/record/account.html) version.

## Prerequisites
Before using this connector in your Ballerina application, complete the following:
* Create a [NetSuite account](https://www.netsuite.com/portal/home.shtml)
* Obtain tokens tokens
    1. Go to [NetSuite](https://www.netsuite.com) and sign in to your account.
    2. If you have NetSuite permission to create an integration application, the following steps may be helpful. If not, proceed to step 3.
        1. Enable the SuiteTalk Web service features of the account (**Setup->Company->Enable Features**).
    
        2. Create an integration application (**Setup->Integration->New**), enable TBA code grant and scope, and obtain the following credentials: 
        * Client ID
        * Client secret
    3. If you have client ID, client secret from your administrator, obtain the credentials below by following the token based authorization in the [NetSuite documentation](https://www.netsuite.com/portal/developers/resources/suitetalk-documentation.shtml). 
        * Access token
        * Access token Secret
    4. Obtain the SuitTalk Base URL that contains the account ID under the company URLs (**Setup->Company->Company
    Information**).

        e.g., https://<ACCOUNT_ID>.suitetalk.api.netsuite.com

## Quickstart
To use the NetSuite connector in your Ballerina application, update the .bal file as follows:
### Step 1 - Import connector
* Create a Ballerina file and import the following Netsuite module.
```ballerina
import ballerinax/netsuite;
```
### Step 2 - Create a new connector instance
* Create a NetSuite client by providing credentials. Initialize the connector by giving authentication details in the HTTP client configuration, which has built-in support for Token Based Authentication(TBA). The NetSuite connector can be initialized by the HTTP client configuration using the client ID, client secret, access token, and the access token secret. You can use the Ballerina [Configuration variable](https://ballerina.io/learn/by-example/configurable.html) to store your credentials.
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

    netsuite:Client netsuiteClient = check new(nsConfig);
```
### Step 3 - Invoke connector operation
1. Invoke the connector operation using the client.
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
    netsuite:RecordAddResponse newAccount = check netsuiteClient->addNewAccount(account);
}
```
2. Use `bal run` command to compile and run the Ballerina program.

**[You can find a list of samples here](https://github.com/ballerina-platform/module-ballerinax-netsuite/tree/master/netsuite/samples).**
