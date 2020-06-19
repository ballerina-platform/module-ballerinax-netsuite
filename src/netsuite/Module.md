Connects to NetSuite from Ballerina.

## Module Overview

Ballerina NetSuite Connector provides the capability to create, read, update, delete, upsert, and search NetSuite 
records to perform business processing and to navigate dynamically between records through the SuiteTalk REST Web 
services API.

## Compatibility
|                     |    Version           |
|:-------------------:|:--------------------:|
| Ballerina Language  | Swan Lake Preview1   |
| NetSuite REST API   | Beta                 |

## Configurations

Instantiate the connector by giving authentication details in the NetSuite client config, which has built-in support 
for OAuth 2.0. NetSuite uses OAuth 2.0 to authenticate and authorize requests. The NetSuite connector can be 
instantiated minimally in the NetSuite client config using the Access Token or by using the Client ID, Client Secret, 
and Refresh Token.

**Obtaining Tokens to Run the Sample**

1. Visit [NetSuite](https://www.netsuite.com) and create an Account.
2. Enable the SuiteTalk Webservice features of the account (Setup->Company->Enable Features).
3. Obtain the SuiteTalk Base URL, which contains the account ID under the company URLs (Setup->Company->Company 
Information).
    E.g., https://<ACCOUNT_ID>.suitetalk.api.netsuite.com
4. Create an integration application (Setup->Integration->New), enable OAuth 2.0 code grant and scope, and obtain the 
following credentials: 
    * Client ID
    * Client Secret
5. Obtain the below credentials by following the Authorization code Grant Flow in the [NetSuite documentation](https://system.na0.netsuite.com/app/help/helpcenter.nl?fid=book_1559132836.html&vid=_BLm3ruuApc_9HXr&chrole=17&ck=9Ie2K7uuApI_9PHO&cktime=175797&promocode=&promocodeaction=overwrite&sj=7bfNB5rzdVQdIKGhDJFE6knJf%3B1590725099%3B165665000).
    * Access Token
    * Refresh Token
    * Refresh Token URL

```ballerina
// Create a NetSuite client configuration by reading from the config file.
netsuite:Configuration nsConfig = {
    baseUrl: "<BASE_URL>",
    clientConfig: {
        accessToken: "<ACCESS_TOKEN>",
        refreshConfig: {
            clientId: "<CLIENT_ID>",
            clientSecret: "<CLIENT_SECRET>",
            refreshToken: "<REFRESH_TOKEN>",
            refreshUrl: "<REFRESH_URL>"
        }
    }
};

netsuite:Client nsClient = new(nsConfig);
```

## Sample

```ballerina
import ballerina/io;
import ballerinax/netsuite;

public function main() {
    netsuite:Currency currency = {
        name: "US Dollar",
        symbol: "USD",
        currencyPrecision: 2,
        exchangeRate: 1.0
    };

    // Create the currency record in NetSuite and return the internal ID.
    string|netsuite:Error created = nsClient->create(<@untainted> currency);
    if created is netsuite:Error {
        io:println("Error: " + created.detail()?.message.toString());
    }
    string id = <string> created;
    io:println("Currency ID = " + id);


    // Confirm the record creation.
    netsuite:ReadableRecord|netsuite:Error retrieved = nsClient->get(<@untainted> id, netsuite:Currency);
    if (retrieved is netsuite:Error) {
        io:println("Error: " + retrieved.detail()?.message.toString());
    }
    currency = <netsuite:Currency> retrieved;
    io:println("Verify the name = " + currency["name"].toString());


    // Update the currency record with the `displaySymbol`.
    json symbol = { displaySymbol: "$" };
    string|netsuite:Error updated = nsClient->update(<@untainted> currency, symbol);
    if updated is netsuite:Error {
        io:println("Error: " + updated.detail()?.message.toString());
    }


    // Check the NetSuite currency record and confirm the update.
    netsuite:ReadableRecord|netsuite:Error getUpdated = nsClient->get(<@untainted> currency.id, netsuite:Currency);
    if (getUpdated is netsuite:Error) {
        io:println("Error: " + getUpdated.detail()?.message.toString());
    }
    currency = <netsuite:Currency> getUpdated;
    io:println("Verify the displaySymbol = " + currency["displaySymbol"].toString());


    // Upsert (update if exists or otherwise create) a different currency, which is used in a third party system.
    netsuite:Currency externalCurrency = {
        name: "British pound",
        symbol: "GBP",
        currencyPrecision: 2,
        exchangeRate: 1.21753
    };

    string|netsuite:Error upserted = nsClient->upsert("163572E", netsuite:Currency, externalCurrency);
    if upserted is netsuite:Error {
        io:println("Error: " + upserted.detail()?.message.toString());
    }
    string exId = <string> upserted;
    io:println("External currency ID = " + exId);


    // Confirm the upsertion.
    netsuite:ReadableRecord|netsuite:Error getUpserted = nsClient->get(<@untainted> exId, netsuite:Currency);
    if (getUpserted is netsuite:Error) {
        io:println("Error: " + getUpserted.detail()?.message.toString());
    }
    externalCurrency = <netsuite:Currency> getUpserted;
    io:println("Verify the upserted name = " + externalCurrency["name"].toString());


    // Search for some other popular currency in the account using a filter.
    [string[], boolean]|netsuite:Error result = nsClient->search(netsuite:Currency, "symbol IS LKR");
    if result is netsuite:Error {
        io:println("Error: " + result.detail()?.message.toString());
    } else {
        var [idArr, hasMore] = result;
        if (idArr.length() == 0) {
            io:println("LKR currency not found in the account");
        } else {
            io:println("LKR currency ID = " + idArr[0]);
        }
    }


    // Delete the inserted records.
    netsuite:Error? deletedCurrency = nsClient->delete(<@untainted> currency);
    if deletedCurrency is netsuite:Error {
        io:println("Error: " + deletedCurrency.detail()?.message.toString());
    }

    netsuite:Error? deletedExCurrency = nsClient->delete(<@untainted> externalCurrency);
    if deletedExCurrency is netsuite:Error {
        io:println("Error: " + deletedExCurrency.detail()?.message.toString());
    }
}
```
