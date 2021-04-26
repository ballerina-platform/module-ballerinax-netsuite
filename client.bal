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
@display {label: "NetSuite Client"} 
public client class Client {
    public http:Client basicClient;
    private NetSuiteConfiguration config;

    public function init(NetSuiteConfiguration config)returns error? {
        self.config = config;
        self.basicClient = check new (config.baseURL);
    }

    # This isolated remote operation creates a record instance in NetSuite according to the given detail
    #
    # + customer - Details of NetSuite record instance creation
    # + return - If success returns a RecordAddResponse type record otherwise the relevant error
    @display {label: "Add new customer"}
    isolated remote function addNewCustomer(@display {label: "Customer"} Customer customer) returns @tainted RecordAddResponse|error{
        xml payload = check buildAddRecord(customer, CUSTOMER, self.config);
        http:Response response = check sendRequest(self.basicClient, ADD_SOAP_ACTION, payload);
        return getCreateResponse(response); 
    }

    # This isolated remote operation creates a record instance in NetSuite according to the given detail
    #
    # + contact - Details of NetSuite record instance creation
    # + return - If success returns a RecordAddResponse type record otherwise the relevant error
    @display {label: "Add new contact"}
    isolated remote function addNewContact(@display {label: "Contact"} Contact contact) returns @tainted RecordAddResponse|error{
        xml payload = check buildAddRecord(contact, CONTACT, self.config);
        http:Response response = check sendRequest(self.basicClient, ADD_SOAP_ACTION, payload);
        return getCreateResponse(response); 
    }

    # This isolated remote operation creates a record instance in NetSuite according to the given detail
    #
    # + invoice - Invoice type record with detail
    # + return - If success returns a RecordAddResponse type record otherwise the relevant error
    @display {label: "Add new invoice"}  
    isolated remote function addNewInvoice(@display {label: "Invoice"} Invoice invoice) returns @tainted RecordAddResponse|error{
        xml payload = check buildAddRecord(invoice, INVOICE, self.config);
        http:Response response = check sendRequest(self.basicClient, ADD_SOAP_ACTION, payload);
        return getCreateResponse(response); 
    }

    # This isolated remote operation creates a record instance in NetSuite according to the given detail
    #
    # + currency - Currency type record with detail
    # + return - If success returns a RecordAddResponse type record otherwise the relevant error
    @display {label: "Add new currency"} 
    isolated remote function addNewCurrency(@display {label: "Currency"} Currency currency) returns @tainted RecordAddResponse|error{
        xml payload = check buildAddRecord(currency, CURRENCY, self.config);
        http:Response response = check sendRequest(self.basicClient, ADD_SOAP_ACTION, payload);
        return getCreateResponse(response); 
    }

    # This isolated remote operation creates a record instance in NetSuite according to the given detail
    #
    # + salesOrder - SalesOrder type record with detail
    # + return - If success returns a RecordAddResponse type record otherwise the relevant error
    @display {label: "Add new sales order"} 
    isolated remote function addNewSalesOrder(@display {label: "Sales Order"} SalesOrder salesOrder) returns @tainted RecordAddResponse|error{
        xml payload = check buildAddRecord(salesOrder, SALES_ORDER, self.config);
        http:Response response = check sendRequest(self.basicClient, ADD_SOAP_ACTION, payload);
        return getCreateResponse(response); 
    }

    # This isolated remote operation creates a record instance in NetSuite according to the given detail
    #
    # + classification - Classification type record with detail
    # + return - If success returns a RecordAddResponse type record otherwise the relevant error
    @display {label: "Add new classification"}
    isolated remote function addNewClassification(@display {label: "Classification"} Classification classification) returns @tainted RecordAddResponse|error {
        xml payload = check buildAddRecord(classification, CLASSIFICATION, self.config);
        http:Response response = check sendRequest(self.basicClient, ADD_SOAP_ACTION, payload);
        return getCreateResponse(response); 
    }

    # This isolated remote operation creates a record instance in NetSuite according to the given detail
    #
    # + account - Account type record with detail
    # + return - If success returns a RecordAddResponse type record otherwise the relevant error
    @display {label: "Add new account"}
    isolated remote function addNewAccount(@display {label: "Account"} Account account) returns @tainted RecordAddResponse|error {
        xml payload = check buildAddRecord(account, ACCOUNT, self.config);
        http:Response response = check sendRequest(self.basicClient, ADD_SOAP_ACTION, payload);
        return getCreateResponse(response); 
    }

    # This isolated remote operation deletes a record instance from NetSuite according to the given detail if they are valid.
    #
    # + info - Details of NetSuite record instance to be deleted
    # + return - If success returns a RecordDeletionResponse type record otherwise the relevant error
    @display {label: "Delete a record"}
    isolated remote function deleteRecord(@display {label: "Record Detail"} RecordDetail info) returns @tainted RecordDeletionResponse|error{
        xml payload = check buildDeletePayload(info, self.config);
        http:Response response = check sendRequest(self.basicClient, DELETE_SOAP_ACTION, payload);
        //getDeleteResponse
        return getDeleteResponse(response); 
    }
    
    # Updates a NetSuite customer instance by internalId
    #
    # + customer - Customer record with details and internalId
    # + return - If success returns a RecordUpdateResponse type record otherwise the relevant error
    @display {label: "Update customer record"}   
    isolated remote function updateCustomerRecord(@display {label: "Customer"} Customer customer) returns @tainted RecordUpdateResponse|error {
        xml payload = check buildUpdateRecord(customer, CUSTOMER , self.config);
        //sendRequest
        http:Response response = check sendRequest(self.basicClient, UPDATE_SOAP_ACTION, payload);
        return getUpdateResponse(response); 
    }

    # Updates a NetSuite contact instance by internalId
    #
    # + contact - Contact record with details and internalId
    # + return - If success returns a RecordUpdateResponse type record otherwise the relevant error
    @display {label: "Update contact record"} 
    isolated remote function updateContactRecord(@display {label: "Contact"} Contact contact) returns @tainted RecordUpdateResponse|error {
        xml payload = check buildUpdateRecord(contact, CONTACT , self.config);
        http:Response response = check sendRequest(self.basicClient, UPDATE_SOAP_ACTION, payload);
        return getUpdateResponse(response); 
    }
    
    # Updates a NetSuite currency instance by internalId
    #
    # + currency - Currency record with details and internalId
    # + return - If success returns a RecordUpdateResponse type record otherwise the relevant error
    @display {label: "Update currency record"} 
    isolated remote function updateCurrencyRecord(@display {label: "Currency"} Currency currency) returns @tainted RecordUpdateResponse|error {
        xml payload = check buildUpdateRecord(currency, CURRENCY , self.config);
        http:Response response = check sendRequest(self.basicClient, UPDATE_SOAP_ACTION, payload);
        return getUpdateResponse(response); 
    }

    # Updates a NetSuite invoice instance by internalId
    #
    # + invoice - Invoice record with details and internalId
    # + return - If success returns a RecordUpdateResponse type record otherwise the relevant error 
    @display {label: "Update invoice record"}
    isolated remote function updateInvoiceRecord(@display {label: "Invoice"} Invoice invoice) returns @tainted RecordUpdateResponse|error {
        xml payload = check buildUpdateRecord(invoice, INVOICE , self.config);
        http:Response response = check sendRequest(self.basicClient, UPDATE_SOAP_ACTION, payload);
        return getUpdateResponse(response); 
    }

    # Updates a NetSuite salesOrder instance by internalId
    #
    # + salesOrder - SalesOrder record with details and internalId
    # + return - If success returns a RecordUpdateResponse type record otherwise the relevant error
    @display {label: "Update sales order record"} 
    isolated remote function updateSalesOrderRecord(@display {label: "Sales Order"} SalesOrder salesOrder) returns @tainted RecordUpdateResponse|error {
        xml payload = check buildUpdateRecord(salesOrder, SALES_ORDER , self.config);
        http:Response response = check sendRequest(self.basicClient, UPDATE_SOAP_ACTION, payload);
        return getUpdateResponse(response); 
    }

    # Updates a NetSuite classification instance by internalId
    #
    # + classification - Classification record with details and internalId
    # + return - If success returns a RecordUpdateResponse type record otherwise the relevant error
    @display {label: "Update classification record"} 
    isolated remote function updateClassificationRecord(@display {label: "Classification"} Classification classification) returns @tainted RecordUpdateResponse|
                                                error {
        xml payload = check buildUpdateRecord(classification, CLASSIFICATION , self.config);
        http:Response response = check sendRequest(self.basicClient, UPDATE_SOAP_ACTION, payload);
        return getUpdateResponse(response); 
    }

    # Updates a NetSuite Account instance by internalId
    #
    # + account - Account record with details and internalId
    # + return - If success returns a RecordUpdateResponse type record otherwise the relevant error
    @display {label: "Update account record"} 
    isolated remote function updateAccountRecord(@display {label: "Account"} Account account) returns @tainted RecordUpdateResponse|error {
        xml payload = check buildUpdateRecord(account, ACCOUNT , self.config);
        http:Response response = check sendRequest(self.basicClient, UPDATE_SOAP_ACTION, payload);
        return getUpdateResponse(response); 
    }

    # This isolated remote operation retrieves instances from NetSuite according to a given type  if they are valid
    #
    # + recordInfo - A NetSuite record instance to be retrieved from NetSuite
    # + return - If success returns a json array otherwise the relevant error
    @display {label: "Get all records"} 
    remote function getAll(@display {label: "Record type(GetAll supported)"} RecordGetAllType recordInfo) returns @tainted json[]|error {
        xml payload = check buildGetAllPayload(recordInfo, self.config);
        http:Response response = check sendRequest(self.basicClient, GET_ALL_SOAP_ACTION, payload);
        return formatGetAllResponse(response);
    }

    # This isolated remote operation retrieves a savedSearch type instance from NetSuite according to the given detail 
    # if they are valid
    #
    # + recordInfo - A NetSuite SavedSearch record type to be retrieved from NetSuite
    # + return - If success returns a json array otherwise the relevant error
    @display {label: "Get saved search"} 
    remote function getSavedSearch(@display {label: "Record type(SavedSearch supported)"} RecordSaveSearchType recordInfo) returns @tainted json[]|error {
        xml payload = check buildGetSavedSearchPayload(recordInfo, self.config);
        http:Response response = check sendRequest(self.basicClient, GET_SAVED_SEARCH_SOAP_ACTION, payload);
        return getSavedSearchResponse(response);
    }

    # This isolated remote operation retrieves NetSuite Client instances from NetSuite according to the given detail 
    # if they are valid
    #
    # + searchElements - Details of a NetSuite record to be retrieved from NetSuite
    # + return - If success returns a json otherwise the relevant error
    @display {label: "Search a customer record"} 
    isolated remote function searchCustomerRecord(@display {label: "Search elements"} SearchElement[] searchElements) returns @tainted Customer|error {
        xml payload = check buildCustomerSearchPayload(self.config, searchElements);
        http:Response response = check sendRequest(self.basicClient, SEARCH_SOAP_ACTION, payload);
        return getCustomerSearchResult(response);
    }

    # This isolated remote operation retrieves NetSuite Transaction instances from NetSuite according to the given detail 
    # if they are valid
    #
    # + searchElements - Details of a NetSuite record to be retrieved from NetSuite
    # + return - If success returns a json otherwise the relevant error
    @display {label: "Search a transaction record"}
    isolated remote function searchTransactionRecord(@display {label: "Search elements"} SearchElement[] searchElements) returns @tainted RecordList|error {
        xml payload = check buildTransactionSearchPayload(self.config, searchElements);
        http:Response response = check sendRequest(self.basicClient, SEARCH_SOAP_ACTION, payload);
        return getTransactionSearchResult(response);
    }

    # This isolated remote operation retrieves NetSuite account record instances from NetSuite according to the given detail 
    # if they are valid
    #
    # + searchElements - Details of a NetSuite record to be retrieved from NetSuite
    # + return - If success returns a json otherwise the relevant error
    @display {label: "Search a account record"}
    isolated remote function searchAccountRecord(@display {label: "Search elements"} SearchElement[] searchElements) returns @tainted Account|error {
        xml payload = check buildAccountSearchPayload(self.config, searchElements);
        http:Response response = check sendRequest(self.basicClient, SEARCH_SOAP_ACTION, payload);
        return getAccountSearchResult(response);
    }

    # Gets a customer record from Netsuite by using internal ID
    #
    # + recordDetail - Ballerina record for Netsuite record information
    # + return - If success returns a Customer type record otherwise the relevant error
    @display {label: "Get a customer record"}
    isolated remote function getCustomerRecord(@display {label: "Record detail"} RecordDetail recordDetail) returns @tainted Customer|error {
        http:Request request = new;
        xml payload = check buildGetOperationPayload(recordDetail, self.config);
        http:Response response = check sendRequest(self.basicClient, GET_SOAP_ACTION, payload);
        return getCustomerResult(response, CUSTOMER);
    }

    # Gets a contact record from Netsuite by using internal ID
    #
    # + recordDetail - Ballerina record for Netsuite record information
    # + return - If success returns a Contact type record otherwise the relevant error
    @display {label: "Get a contact record"}  
    isolated remote function getContactRecord(@display {label: "Record detail"} RecordDetail recordDetail) returns @tainted Contact|error {
        http:Request request = new;
        xml payload = check buildGetOperationPayload(recordDetail, self.config);
        http:Response response = check sendRequest(self.basicClient, GET_SOAP_ACTION, payload);
        return getContactResult(response);
    }

    # Gets a currency record from Netsuite by using internal ID
    #
    # + recordDetail - Ballerina record for Netsuite record information
    # + return - If success returns a Currency type record otherwise the relevant error
    @display {label: "Get a currency record"}
    isolated remote function getCurrencyRecord(@display {label: "Record detail"} RecordDetail recordDetail) returns @tainted Currency|error {
        http:Request request = new;
        xml payload = check buildGetOperationPayload(recordDetail, self.config);
        http:Response response = check sendRequest(self.basicClient, GET_SOAP_ACTION, payload);
        return getCurrencyResult(response, CURRENCY);
    }

    # Gets a currency record from Netsuite by using internal ID
    #
    # + recordDetail - Ballerina record for Netsuite record information
    # + return - If success returns a Classification type record otherwise the relevant error
    @display {label: "Get a classification record"}
    isolated remote function getClassificationRecord(@display {label: "Record detail"} RecordDetail recordDetail) returns @tainted Classification|error {
        http:Request request = new;
        xml payload = check buildGetOperationPayload(recordDetail, self.config);
        http:Response response = check sendRequest(self.basicClient, GET_SOAP_ACTION, payload);
        return getClassificationResult(response, CLASSIFICATION);
    }

    # Gets a invoice record from Netsuite by using internal ID
    #
    # + recordDetail - Ballerina record for Netsuite record information
    # + return - If success returns a invoice type record otherwise the relevant error
    @display {label: "Get a invoice record"}
    isolated remote function getInvoiceRecord(@display {label: "Record detail"} RecordDetail recordDetail) returns @tainted Invoice|error {
        http:Request request = new;
        xml payload = check buildGetOperationPayload(recordDetail, self.config);
        http:Response response = check sendRequest(self.basicClient, GET_SOAP_ACTION, payload);
        return getInvoiceResult(response, INVOICE);
    }

    # Gets a salesOrder record from Netsuite by using internal ID
    #
    # + recordDetail - Ballerina record for Netsuite record information
    # + return - If success returns a SalesOrder type record otherwise the relevant error
    @display {label: "Get a sales order record"}
    isolated remote function getSalesOrderRecord(@display {label: "Record detail"} RecordDetail recordDetail) returns @tainted SalesOrder|error {
        http:Request request = new;
        xml payload = check buildGetOperationPayload(recordDetail, self.config);
        http:Response response = check sendRequest(self.basicClient, GET_SOAP_ACTION, payload);
        return getSalesOrderResult(response, SALES_ORDER);
    }
 }

# Configuration record for NetSuite
#
# + accountId - NetSuite account ID  
# + consumerSecret - Netsuite Integration App consumer secret
# + baseURL - Netsuite baseURL for web services   
# + consumerId - Netsuite Integration App consumer ID   
# + tokenSecret - Netsuite user role access secret 
# + token - Netsuite user role access token 
public type NetSuiteConfiguration record {
    string accountId;
    string consumerId;
    string consumerSecret;
    string tokenSecret;
    string token;
    string baseURL;
};
