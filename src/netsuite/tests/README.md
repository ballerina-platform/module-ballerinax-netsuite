## Compatibility

| Ballerina Language Version | NetSuite API Version |  
|:--------------------------:|:--------------------:|
| 1.2.0                      |        Beta          |

### Prerequisites

1. Visit [NetSuite](https://www.netsuite.com) and create an Account.
2. Enable SuiteTalk Webservice features of the account (Setup->Company->Enable Features).
3. Obtain SuiteTalk Base URL which contains the account ID under company URLs (Setup->Company->Company Information).
    Eg: https://<ACCOUNT_ID>.suitetalk.api.netsuite.com
4. Create an integration application (Setup->Integration->New), enable OAuth 2.0 code grant and scope and obtain the 
following credentials: 
    * Client ID
    * Client Secret
5. Obtain below credentials by following Authorization code Grant Flow in NetSuite documentation. 
    * Access Token
    * Refresh Token
    * Refresh Token URL
    
### Working with NetSuite Connector.

In order to use the NetSuite connector, first you need to create a NetSuite endpoint by passing above mentioned parameters.

Visit `main_test.bal` file to find the way of creating NetSuite endpoint.

### Running NetSuite tests
In order to run the tests, the user will need to have a NetSuite sandbox account ideally and create a configuration 
file named `ballerina.conf` in the project's root directory with the obtained tokens and other parameters.
NetSuite records access management is hierarchical. Hence certain test cases require higher permission role when 
modifying records.
Certain test cases may require prerequisite records already created in the NetSuite Account. So makesure the records 
are created beforehand. Otherwise some operations may fail due to unavailability of particular record in the NetSuite 
Account. NetSuite records can have organization specific mandatory fields. Unavailability of such fields may occur 
failure when record creation/upsertion.


#### ballerina.conf
```ballerina.conf
// Provide SuiteTalk Base URL
BASE_URL="https://<ACCOUNT_ID>.suitetalk.api.netsuite.com"
//Give the credentials and tokens for the authorized user
ACCESS_TOKEN="enter your access token here"
REFRESH_URL="https://<ACCOUNT_ID>.suitetalk.api.netsuite.com/services/rest/auth/oauth2/v1/token"
REFRESH_TOKEN="enter your refresh token here"
CLIENT_ID="enter your client ID here"
CLIENT_SECRET="enter your client secret here"
```

Assign the values for the accessToken, clientId, clientSecret and refreshToken inside constructed endpoint in 
main_test.bal in either way following,

```ballerina
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
```

Run tests :

```
ballerina test netsuite
```
