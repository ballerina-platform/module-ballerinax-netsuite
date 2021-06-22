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

import ballerina/http;

# HTTP Client for NetSuite SOAP web service
#
# + basicClient - NetSuite HTTP Client
@display{label: "NetSuite Client", iconPath: "logo.svg"} 
public client class Client {
    public http:Client basicClient;
    private NetSuiteConfiguration config;

    public isolated function init(NetSuiteConfiguration config)returns error? {
        self.config = config;
        self.basicClient = check new (config.baseURL + NETSUITE_ENDPOINT, {timeout: 120});
    }

    # Creates a record instance in NetSuite according to the given detail
    #
    # + customer - Details of NetSuite record instance creation
    # + return - If success returns a RecordAddResponse type record otherwise the relevant error
    @display{label: "Add New Customer"}
    isolated remote function addNewCustomer(@display{label: "Customer"} NewCustomer customer) returns @tainted 
                                            @display{label: "Response"} RecordAddResponse|error{
        xml payload = check buildAddRecord(customer, CUSTOMER, self.config);
        http:Response response = check sendRequest(self.basicClient, ADD_SOAP_ACTION, payload);
        return getCreateResponse(response); 
    }

    # Creates a record instance in NetSuite according to the given detail
    #
    # + contact - Details of NetSuite record instance creation
    # + return - If success returns a RecordAddResponse type record otherwise the relevant error
    @display{label: "Add New Contact"}
    isolated remote function addNewContact(@display{label: "Contact"} NewContact contact) returns @tainted 
                                           @display{label: "Response"} RecordAddResponse|error{
        xml payload = check buildAddRecord(contact, CONTACT, self.config);
        http:Response response = check sendRequest(self.basicClient, ADD_SOAP_ACTION, payload);
        return getCreateResponse(response); 
    }

    # Creates a record instance in NetSuite according to the given detail
    #
    # + invoice - Invoice type record with detail
    # + return - If success returns a RecordAddResponse type record otherwise the relevant error
    @display{label: "Add New Invoice"}  
    isolated remote function addNewInvoice(@display{label: "Invoice"} NewInvoice invoice) returns @tainted 
                                           @display{label: "Response"} RecordAddResponse|error{
        xml payload = check buildAddRecord(invoice, INVOICE, self.config);
        http:Response response = check sendRequest(self.basicClient, ADD_SOAP_ACTION, payload);
        return getCreateResponse(response); 
    }

    # Creates a record instance in NetSuite according to the given detail
    #
    # + currency - Currency type record with detail
    # + return - If success returns a RecordAddResponse type record otherwise the relevant error
    @display{label: "Add New Currency Type"} 
    isolated remote function addNewCurrency(@display{label: "Currency"} NewCurrency currency) returns @tainted
                                            @display{label: "Response"} RecordAddResponse|error{
        xml payload = check buildAddRecord(currency, CURRENCY, self.config);
        http:Response response = check sendRequest(self.basicClient, ADD_SOAP_ACTION, payload);
        return getCreateResponse(response); 
    }

    # Creates a record instance in NetSuite according to the given detail
    #
    # + salesOrder - SalesOrder type record with detail
    # + return - If success returns a RecordAddResponse type record otherwise the relevant error
    @display{label: "Add New Sales Order"} 
    isolated remote function addNewSalesOrder(@display{label: "Sales Order"} NewSalesOrder salesOrder) returns @tainted
                                              @display{label: "Response"} RecordAddResponse|error{
        xml payload = check buildAddRecord(salesOrder, SALES_ORDER, self.config);
        http:Response response = check sendRequest(self.basicClient, ADD_SOAP_ACTION, payload);
        return getCreateResponse(response); 
    }

    # Creates a record instance in NetSuite according to the given detail
    #
    # + classification - Classification type record with detail
    # + return - If success returns a RecordAddResponse type record otherwise the relevant error
    @display{label: "Add New Classification"}
    isolated remote function addNewClassification(@display{label: "Classification"} NewClassification classification) 
                                                  returns @tainted @display{label: "Response"} RecordAddResponse|error {
        xml payload = check buildAddRecord(classification, CLASSIFICATION, self.config);
        http:Response response = check sendRequest(self.basicClient, ADD_SOAP_ACTION, payload);
        return getCreateResponse(response); 
    }

    # Creates a record instance in NetSuite according to the given detail
    #
    # + account - Account type record with detail
    # + return - If success returns a RecordAddResponse type record otherwise the relevant error
    @display{label: "Add New Account"}
    isolated remote function addNewAccount(@display{label: "Account"} NewAccount account) returns @tainted
                                           @display{label: "Response"} RecordAddResponse|error {
        xml payload = check buildAddRecord(account, ACCOUNT, self.config);
        http:Response response = check sendRequest(self.basicClient, ADD_SOAP_ACTION, payload);
        return getCreateResponse(response); 
    }

    # Deletes a record instance from NetSuite according to the given detail if they are valid.
    #
    # + info - Details of NetSuite record instance to be deleted
    # + return - If success returns a RecordDeletionResponse type record otherwise the relevant error
    @display{label: "Delete Record"}
    isolated remote function deleteRecord(@display{label: "Record Detail"} RecordDetail info) returns @tainted
                                          @display{label: "Response"} RecordDeletionResponse|error{
        xml payload = check buildDeletePayload(info, self.config);
        http:Response response = check sendRequest(self.basicClient, DELETE_SOAP_ACTION, payload);
        //getDeleteResponse
        return getDeleteResponse(response); 
    }
    
    # Updates a NetSuite customer instance by internalId
    #
    # + customer - Customer record with details and internalId
    # + return - If success returns a RecordUpdateResponse type record otherwise the relevant error
    @display{label: "Update Customer"}   
    isolated remote function updateCustomerRecord(@display{label: "Customer"} Customer customer) returns @tainted
                                                  @display{label: "Response"} RecordUpdateResponse|error {
        xml payload = check buildUpdateRecord(customer, CUSTOMER , self.config);
        http:Response response = check sendRequest(self.basicClient, UPDATE_SOAP_ACTION, payload);
        return getUpdateResponse(response); 
    }

    # Updates a NetSuite contact instance by internalId
    #
    # + contact - Contact record with details and internalId
    # + return - If success returns a RecordUpdateResponse type record otherwise the relevant error
    @display{label: "Update Contact"} 
    isolated remote function updateContactRecord(@display{label: "Contact"} Contact contact) returns @tainted
                                                 @display{label: "Response"} RecordUpdateResponse|error {
        xml payload = check buildUpdateRecord(contact, CONTACT , self.config);
        http:Response response = check sendRequest(self.basicClient, UPDATE_SOAP_ACTION, payload);
        return getUpdateResponse(response); 
    }
    
    # Updates a NetSuite currency instance by internalId
    #
    # + currency - Currency record with details and internalId
    # + return - If success returns a RecordUpdateResponse type record otherwise the relevant error
    @display{label: "Update Currency"} 
    isolated remote function updateCurrencyRecord(@display{label: "Currency"} Currency currency) returns @tainted
                                                  @display{label: "Response"} RecordUpdateResponse|error {
        xml payload = check buildUpdateRecord(currency, CURRENCY , self.config);
        http:Response response = check sendRequest(self.basicClient, UPDATE_SOAP_ACTION, payload);
        return getUpdateResponse(response); 
    }

    # Updates a NetSuite invoice instance by internalId
    #
    # + invoice - Invoice record with details and internalId
    # + return - If success returns a RecordUpdateResponse type record otherwise the relevant error 
    @display{label: "Update Invoice"}
    isolated remote function updateInvoiceRecord(@display{label: "Invoice"} Invoice invoice) returns @tainted
                                                 @display{label: "Response"} RecordUpdateResponse|error {
        xml payload = check buildUpdateRecord(invoice, INVOICE , self.config);
        http:Response response = check sendRequest(self.basicClient, UPDATE_SOAP_ACTION, payload);
        return getUpdateResponse(response); 
    }

    # Updates a NetSuite salesOrder instance by internalId
    #
    # + salesOrder - SalesOrder record with details and internalId
    # + return - If success returns a RecordUpdateResponse type record otherwise the relevant error
    @display{label: "Update Sales Order"} 
    isolated remote function updateSalesOrderRecord(@display{label: "Sales Order"} SalesOrder salesOrder) returns 
                                                    @tainted @display{label: "Response"} RecordUpdateResponse|error {
        xml payload = check buildUpdateRecord(salesOrder, SALES_ORDER , self.config);
        http:Response response = check sendRequest(self.basicClient, UPDATE_SOAP_ACTION, payload);
        return getUpdateResponse(response); 
    }

    # Updates a NetSuite classification instance by internalId
    #
    # + classification - Classification record with details and internalId
    # + return - If success returns a RecordUpdateResponse type record otherwise the relevant error
    @display{label: "Update Classification"} 
    isolated remote function updateClassificationRecord(@display{label: "Classification"} Classification classification) 
                                                        returns @tainted @display{label: "Response"} 
                                                        RecordUpdateResponse|error {
        xml payload = check buildUpdateRecord(classification, CLASSIFICATION , self.config);
        http:Response response = check sendRequest(self.basicClient, UPDATE_SOAP_ACTION, payload);
        return getUpdateResponse(response); 
    }

    # Updates a NetSuite account instance by internalId
    #
    # + account - Account record with details and internalId
    # + return - If success returns a RecordUpdateResponse type record otherwise the relevant error
    @display{label: "Update Account"} 
    isolated remote function updateAccountRecord(@display{label: "Account"} Account account) returns @tainted @display 
                                                {label: "Response"} RecordUpdateResponse|error {
        xml payload = check buildUpdateRecord(account, ACCOUNT , self.config);
        http:Response response = check sendRequest(self.basicClient, UPDATE_SOAP_ACTION, payload);
        return getUpdateResponse(response); 
    }

    # Retrieves all currency types instances from NetSuite
    #
    # + return - If success returns an array of currency records otherwise the relevant error
    @display{label: "Get All Currency Types"} 
    isolated remote function getAllCurrencyRecords() returns @display{label: "Response"} @tainted Currency[]|error {
        xml payload = check buildGetAllPayload(CURRENCY_All_TYPES, self.config);
        http:Response response = check sendRequest(self.basicClient, GET_ALL_SOAP_ACTION, payload);
        var output = formatGetAllResponse(response);
        if(output is anydata) {
            return <Currency[]>output;
        } else {
            fail error(output.message());
        }  
    }

    # Retrieves NetSuite client instances from NetSuite according to the given detail 
    # if they are valid
    #
    # + searchElements - Details of a NetSuite record to be retrieved from NetSuite
    # + return - If success returns a json otherwise the relevant error
    @display{label: "Search Customers"} 
    isolated remote function searchCustomerRecords(@display{label: "Search Elements"} SearchElement[] searchElements) 
                                                  returns @tainted @display{label: "Response"} stream<Customer, error>|error {
        xml payload = check buildCustomerSearchPayload(self.config, searchElements);
        http:Response response = check sendRequest(self.basicClient, SEARCH_SOAP_ACTION, payload);
        return getCustomerSearchResult(response,self.basicClient, self.config);
    }

    # Retrieves NetSuite transaction instances from NetSuite according to the given detail 
    # if they are valid
    #
    # + searchElements - Details of a NetSuite record to be retrieved from NetSuite
    # + return - If success returns a json otherwise the relevant error
    @display{label: "Search Transactions"}
    isolated remote function searchTransactionRecords(@display{label: "Search Elements"} SearchElement[] searchElements) 
                                                     returns @tainted @display{label: "Response"} stream<RecordRef, 
                                                     error>|error {
        xml payload = check buildTransactionSearchPayload(self.config, searchElements);
        http:Response response = check sendRequest(self.basicClient, SEARCH_SOAP_ACTION, payload);
        return getTransactionSearchResult(response,self.basicClient, self.config);
    }

    # Retrieves NetSuite account record instances from NetSuite according to the given detail 
    #
    # + searchElements - Details of a NetSuite record to be retrieved from NetSuite
    # + return - If success returns a account stream otherwise the relevant error
    @display{label: "Search Accounts"}
    isolated remote function searchAccountRecords(@display{label: "Search Elements"} SearchElement[] searchElements) 
                                                 returns @tainted @display{label: "Response"} stream<Account, 
                                                 error>|error {
        xml payload = check buildAccountSearchPayload(self.config, searchElements);
        http:Response response = check sendRequest(self.basicClient, SEARCH_SOAP_ACTION, payload);
        return getAccountSearchResult(response, self.basicClient, self.config);
    }

    # Retrieves NetSuite contact record instances from NetSuite according to the given detail
    #
    # + searchElements - Details of a NetSuite record to be retrieved from NetSuite
    # + return - If success returns a contact stream otherwise the relevant error
    @display{label: "Search Contacts"}
    isolated remote function searchContactRecords(@display{label: "Search Elements"} SearchElement[] searchElements) 
                                                 returns @tainted @display{label: "Response"} stream<Contact, 
                                                 error>|error {
        xml payload = check BuildContactSearchPayload(self.config, searchElements);
        http:Response response = check sendRequest(self.basicClient, SEARCH_SOAP_ACTION, payload);
        return getContactsSearchResult(response, self.basicClient, self.config);
    }

    # Gets a customer record from Netsuite by using internal ID
    #
    # + recordInfo - Ballerina record for Netsuite record information
    # + return - If success returns a Customer type record otherwise the relevant error
    @display{label: "Get Customer"}
    isolated remote function getCustomerRecord(@display{label: "Record Detail"} RecordInfo recordInfo) returns 
                                               @tainted @display{label: "Response"} Customer|error {
        http:Request request = new;
        xml payload = check buildGetOperationPayload(recordInfo, self.config);
        http:Response response = check sendRequest(self.basicClient, GET_SOAP_ACTION, payload);
        return getCustomerResult(response);
    }

    # Gets a contact record from Netsuite by using internal ID
    #
    # + recordInfo - Ballerina record for Netsuite record information
    # + return - If success returns a Contact type record otherwise the relevant error
    @display{label: "Get Contact"}  
    isolated remote function getContactRecord(@display{label: "Record Detail"} RecordInfo recordInfo) returns 
                                              @tainted @display{label: "Response"} Contact|error {
        http:Request request = new;
        xml payload = check buildGetOperationPayload(recordInfo, self.config);
        http:Response response = check sendRequest(self.basicClient, GET_SOAP_ACTION, payload);
        return getContactResult(response);
    }

    # Gets a currency record from Netsuite by using internal ID
    #
    # + recordInfo - Ballerina record for Netsuite record information
    # + return - If success returns a Currency type record otherwise the relevant error
    @display{label: "Get Currency"}
    isolated remote function getCurrencyRecord(@display{label: "Record Detail"} RecordInfo recordInfo) returns 
                                               @tainted @display{label: "Response"} Currency|error {
        http:Request request = new;
        xml payload = check buildGetOperationPayload(recordInfo, self.config);
        http:Response response = check sendRequest(self.basicClient, GET_SOAP_ACTION, payload);
        return getCurrencyResult(response);
    }

    # Gets a currency record from Netsuite by using internal ID
    #
    # + recordInfo - Ballerina record for Netsuite record information
    # + return - If success returns a Classification type record otherwise the relevant error
    @display{label: "Get Classification"}
    isolated remote function getClassificationRecord(@display{label: "Record Detail"} RecordInfo recordInfo) returns 
                                                     @tainted @display{label: "Response"} Classification|error {
        http:Request request = new;
        xml payload = check buildGetOperationPayload(recordInfo, self.config);
        http:Response response = check sendRequest(self.basicClient, GET_SOAP_ACTION, payload);
        return getClassificationResult(response);
    }

    # Gets a invoice record from Netsuite by using internal Id
    #
    # + recordInfo - Ballerina record for Netsuite record information
    # + return - If success returns a invoice type record otherwise the relevant error
    @display{label: "Get Invoice"}
    isolated remote function getInvoiceRecord(@display{label: "Record Detail"} RecordInfo recordInfo) returns 
                                              @tainted @display{label: "Response"} Invoice|error {
        http:Request request = new;
        xml payload = check buildGetOperationPayload(recordInfo, self.config);
        http:Response response = check sendRequest(self.basicClient, GET_SOAP_ACTION, payload);
        return getInvoiceResult(response);
    }

    # Gets a salesOrder record from Netsuite by using internal ID
    #
    # + recordInfo - Ballerina record for Netsuite record information
    # + return - If success returns a SalesOrder type record otherwise the relevant error
    @display{label: "Get Sales Order"}
    isolated remote function getSalesOrderRecord(@display{label: "Record Detail"} RecordInfo recordInfo) returns 
                                                 @tainted @display{label: "Response"} SalesOrder|error {
        http:Request request = new;
        xml payload = check buildGetOperationPayload(recordInfo, self.config);
        http:Response response = check sendRequest(self.basicClient, GET_SOAP_ACTION, payload);
        return getSalesOrderResult(response);
    }

    # Gets a account record from Netsuite by using internal Id
    #
    # + recordInfo - Ballerina record for Netsuite record information
    # + return - If success returns an account type record otherwise the relevant error
    @display{label: "Get Account"}
    isolated remote function getAccountRecord(@display{label: "Record Detail"} RecordInfo recordInfo) returns 
                                                 @tainted @display{label: "Response"} Account|error {
        http:Request request = new;
        xml payload = check buildGetOperationPayload(recordInfo, self.config);
        http:Response response = check sendRequest(self.basicClient, GET_SOAP_ACTION, payload);
        return getAccountResult(response);
    }

    # Returns the NetSuite server time in GMT, regardless of a user's time zone 
    #
    # + return - If success returns the server time otherwise the relevant error
    @display{label: "Get Netsuite Server Time"} 
    isolated remote function getNetSuiteServerTime() returns @tainted @display{label: "Response"} string|error {
        xml payload = check buildGetServerTime(self.config);
        http:Response response = check sendRequest(self.basicClient, GET_SERVER_TIME_ACTION, payload);
        return getServerTimeResponse(response);
    }
 }

# Configuration record for NetSuite
#
# + accountId - NetSuite Account ID  
# + consumerSecret - Netsuite Integration application consumer secret
# + baseURL - Netsuite SuiteTalk URLs for SOAP web services (Available at Setup->Company->Company Information->Company 
# URLs)
# + consumerId - Netsuite Integration App consumer ID   
# + tokenSecret - Netsuite user role access secret 
# + token - Netsuite user role access token
@display{label: "Connection Config"}  
public type NetSuiteConfiguration record {
    @display{label: "Account ID"}
    string accountId;
    @display{label: "Consumer Id"}
    string consumerId;
    @display{label: "Consumer Secret"}
    string consumerSecret;
    @display{label: "Access Token"}
    string token;
    @display{label: "Access Secret"}
    string tokenSecret;
    @display{label: "NetSuite SuiteTalk WebService URL"}
    string baseURL;
};
