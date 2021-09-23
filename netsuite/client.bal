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

# NetSuite's [SuiteTalk SOAP API](https://www.netsuite.com/portal/developers/resources/suitetalk-documentation.shtml) provides 
# capability to access NetSuite operations related different kind of NetSuite records such as Account, Client, Transactions, 
# Invoice, Classifications etc.
#
# + basicClient - NetSuite HTTP Client
@display{label: "NetSuite Client", iconPath: "resources/netsuite.svg"} 
public isolated client class Client {
    final http:Client basicClient;
    final readonly & ConnectionConfig config;

    # Gets invoked to initialize the `connector`.
    # The connector initialization requires setting the API credentials. 
    # This connector supports NetSuite Token Based Authentication. 
    # Follow [this guide](https://docs.oracle.com/en/cloud/saas/netsuite/ns-online-help/section_N3445710.html)
    # to Obtain token for NetSuite connector configuration.
    #
    # + config - NetSuite connection configuration
    # + httpClientConfig - HTTP configuration
    # + return - `http:Error` in case of failure to initialize or `null` if successfully initialized 
    public isolated function init(ConnectionConfig config, http:ClientConfiguration httpClientConfig = {})returns error? {
        self.config = config.cloneReadOnly();
        self.basicClient = check new (config.baseURL + NETSUITE_ENDPOINT, httpClientConfig);
    }

    # Creates a record instance in NetSuite according to the given detail
    #
    # + vendor - Details of NetSuite record instance creation
    # + return - RecordAddResponse type record or else the relevant error 
    @display{label: "Add New Vendor"} 
    isolated remote function addNewVendor(@display{label: "Vendor"} NewVendor vendor) returns @display{label: "Response"} 
                                          RecordAddResponse|error {
        xml payload = check getPayloadAddOp(vendor, VENDOR, self.config);
        http:Response response = check sendRequest(self.basicClient, ADD_SOAP_ACTION, payload);
        return getResponseCreationOp(response);
    }

    # Creates a record instance in NetSuite according to the given detail
    #
    # + vendorBill - Details of NetSuite record instance creation
    # + return - RecordAddResponse type record or else the relevant error
    @display{label: "Add New Vendor Bill"}
    isolated remote function addNewVendorBill(@display{label: "VendorBill"} NewVendorBill vendorBill) returns 
                                              @display{label: "Response"} RecordAddResponse|error {
        xml payload =  check getPayloadAddOp(vendorBill, VENDOR_BILL, self.config);
        http:Response response = check sendRequest(self.basicClient, ADD_SOAP_ACTION, payload);
        return getResponseCreationOp(response);
    }

    # Creates a record instance in NetSuite according to the given detail
    #
    # + customer - Details of NetSuite record instance creation
    # + return - RecordAddResponse type record or else the relevant error
    @display{label: "Add New Customer"}
    isolated remote function addNewCustomer(@display{label: "Customer"} NewCustomer customer) returns @tainted 
                                            @display{label: "Response"} RecordAddResponse|error{
        xml payload = check getPayloadAddOp(customer, CUSTOMER, self.config);
        http:Response response = check sendRequest(self.basicClient, ADD_SOAP_ACTION, payload);
        return getResponseCreationOp(response); 
    }

    # Creates a record instance in NetSuite according to the given detail
    #
    # + contact - Details of NetSuite record instance creation
    # + return - RecordAddResponse type record or else the relevant error
    @display{label: "Add New Contact"}
    isolated remote function addNewContact(@display{label: "Contact"} NewContact contact) returns @tainted 
                                           @display{label: "Response"} RecordAddResponse|error{
        xml payload = check getPayloadAddOp(contact, CONTACT, self.config);
        http:Response response = check sendRequest(self.basicClient, ADD_SOAP_ACTION, payload);
        return getResponseCreationOp(response); 
    }

    # Creates a record instance in NetSuite according to the given detail
    #
    # + invoice - Invoice type record with detail
    # + return - RecordAddResponse type record otherwise the relevant error
    @display{label: "Add New Invoice"}  
    isolated remote function addNewInvoice(@display{label: "Invoice"} NewInvoice invoice) returns @tainted 
                                           @display{label: "Response"} RecordAddResponse|error{
        xml payload = check getPayloadAddOp(invoice, INVOICE, self.config);
        http:Response response = check sendRequest(self.basicClient, ADD_SOAP_ACTION, payload);
        return getResponseCreationOp(response); 
    }

    # Creates a record instance in NetSuite according to the given detail
    #
    # + currency - Currency type record with detail
    # + return - RecordAddResponse type record otherwise the relevant error
    @display{label: "Add New Currency Type"} 
    isolated remote function addNewCurrency(@display{label: "Currency"} NewCurrency currency) returns @tainted
                                            @display{label: "Response"} RecordAddResponse|error{
        xml payload = check getPayloadAddOp(currency, CURRENCY, self.config);
        http:Response response = check sendRequest(self.basicClient, ADD_SOAP_ACTION, payload);
        return getResponseCreationOp(response); 
    }

    # Creates a record instance in NetSuite according to the given detail
    #
    # + salesOrder - SalesOrder type record with detail
    # + return - RecordAddResponse type record otherwise the relevant error
    @display{label: "Add New Sales Order"} 
    isolated remote function addNewSalesOrder(@display{label: "Sales Order"} NewSalesOrder salesOrder) returns @tainted
                                              @display{label: "Response"} RecordAddResponse|error{
        xml payload = check getPayloadAddOp(salesOrder, SALES_ORDER, self.config);
        http:Response response = check sendRequest(self.basicClient, ADD_SOAP_ACTION, payload);
        return getResponseCreationOp(response); 
    }

    # Creates a record instance in NetSuite according to the given detail
    #
    # + classification - Classification type record with detail
    # + return - RecordAddResponse type record otherwise the relevant error
    @display{label: "Add New Classification"}
    isolated remote function addNewClassification(@display{label: "Classification"} NewClassification classification) 
                                                  returns @tainted @display{label: "Response"} RecordAddResponse|error {
        xml payload = check getPayloadAddOp(classification, CLASSIFICATION, self.config);
        http:Response response = check sendRequest(self.basicClient, ADD_SOAP_ACTION, payload);
        return getResponseCreationOp(response); 
    }

    # Creates a record instance in NetSuite according to the given detail
    #
    # + account - Account type record with detail
    # + return - RecordAddResponse type record otherwise the relevant error
    @display{label: "Add New Account"}
    isolated remote function addNewAccount(@display{label: "Account"} NewAccount account) returns @tainted
                                           @display{label: "Response"} RecordAddResponse|error {
        xml payload = check getPayloadAddOp(account, ACCOUNT, self.config);
        http:Response response = check sendRequest(self.basicClient, ADD_SOAP_ACTION, payload);
        return getResponseCreationOp(response); 
    }

    # Deletes a record instance from NetSuite according to the given detail if they are valid
    #
    # + info - Details of NetSuite record instance to be deleted
    # + return - RecordDeletionResponse type record otherwise the relevant error
    @display{label: "Delete Record"}
    isolated remote function deleteRecord(@display{label: "Record Detail"} RecordDetail info) returns @tainted
                                          @display{label: "Response"} RecordDeletionResponse|error{
        xml payload = check buildDeletePayload(info, self.config);
        http:Response response = check sendRequest(self.basicClient, DELETE_SOAP_ACTION, payload);
        return getDeleteResponse(response); 
    }

    # Updates a NetSuite vendor instance by internal ID
    #
    # + vendor - Vendor record with details and internal ID
    # + return - RecordUpdateResponse type record otherwise the relevant error
    @display{label: "Update Vendor"}
    isolated remote function updateVendorRecord(@display{label: "Vendor"} Vendor vendor) returns 
                                                @display{label: "Response"} RecordUpdateResponse|error {
        xml payload = check buildUpdateRecord(vendor, VENDOR , self.config);
        http:Response response = check sendRequest(self.basicClient, UPDATE_SOAP_ACTION, payload);
        return getUpdateResponse(response); 
    }
    
    # Updates a NetSuite customer instance by internal ID
    #
    # + customer - Customer record with details and internal ID
    # + return - RecordUpdateResponse type record otherwise the relevant error
    @display{label: "Update Customer"}   
    isolated remote function updateCustomerRecord(@display{label: "Customer"} Customer customer) returns @tainted
                                                  @display{label: "Response"} RecordUpdateResponse|error {
        xml payload = check buildUpdateRecord(customer, CUSTOMER , self.config);
        http:Response response = check sendRequest(self.basicClient, UPDATE_SOAP_ACTION, payload);
        return getUpdateResponse(response); 
    }

    # Updates a NetSuite contact instance by internal ID
    #
    # + contact - Contact record with details and internal ID
    # + return - RecordUpdateResponse type record otherwise the relevant error
    @display{label: "Update Contact"} 
    isolated remote function updateContactRecord(@display{label: "Contact"} Contact contact) returns @tainted
                                                 @display{label: "Response"} RecordUpdateResponse|error {
        xml payload = check buildUpdateRecord(contact, CONTACT , self.config);
        http:Response response = check sendRequest(self.basicClient, UPDATE_SOAP_ACTION, payload);
        return getUpdateResponse(response); 
    }
    
    # Updates a NetSuite currency instance by internal ID
    #
    # + currency - Currency record with details and internal ID
    # + return - RecordUpdateResponse type record otherwise the relevant error
    @display{label: "Update Currency"} 
    isolated remote function updateCurrencyRecord(@display{label: "Currency"} Currency currency) returns @tainted
                                                  @display{label: "Response"} RecordUpdateResponse|error {
        xml payload = check buildUpdateRecord(currency, CURRENCY , self.config);
        http:Response response = check sendRequest(self.basicClient, UPDATE_SOAP_ACTION, payload);
        return getUpdateResponse(response); 
    }

    # Updates a NetSuite invoice instance by internal ID
    #
    # + invoice - Invoice record with details and internalId
    # + return - RecordUpdateResponse type record otherwise the relevant error 
    @display{label: "Update Invoice"}
    isolated remote function updateInvoiceRecord(@display{label: "Invoice"} Invoice invoice) returns @tainted
                                                 @display{label: "Response"} RecordUpdateResponse|error {
        xml payload = check buildUpdateRecord(invoice, INVOICE , self.config);
        http:Response response = check sendRequest(self.basicClient, UPDATE_SOAP_ACTION, payload);
        return getUpdateResponse(response); 
    }

    # Updates a NetSuite salesOrder instance by internal ID
    #
    # + salesOrder - SalesOrder record with details and internalId
    # + return - RecordUpdateResponse type record otherwise the relevant error
    @display{label: "Update Sales Order"} 
    isolated remote function updateSalesOrderRecord(@display{label: "Sales Order"} SalesOrder salesOrder) returns 
                                                    @tainted @display{label: "Response"} RecordUpdateResponse|error {
        xml payload = check buildUpdateRecord(salesOrder, SALES_ORDER , self.config);
        http:Response response = check sendRequest(self.basicClient, UPDATE_SOAP_ACTION, payload);
        return getUpdateResponse(response); 
    }

    # Updates a NetSuite classification instance by internal ID
    #
    # + classification - Classification record with details and internalId
    # + return - RecordUpdateResponse type record otherwise the relevant error
    @display{label: "Update Classification"} 
    isolated remote function updateClassificationRecord(@display{label: "Classification"} Classification classification) 
                                                        returns @tainted @display{label: "Response"} 
                                                        RecordUpdateResponse|error {
        xml payload = check buildUpdateRecord(classification, CLASSIFICATION , self.config);
        http:Response response = check sendRequest(self.basicClient, UPDATE_SOAP_ACTION, payload);
        return getUpdateResponse(response); 
    }

    # Updates a NetSuite account instance by internal ID
    #
    # + account - Account record with details and internal ID
    # + return - RecordUpdateResponse type record otherwise the relevant error
    @display{label: "Update Account"} 
    isolated remote function updateAccountRecord(@display{label: "Account"} Account account) returns @tainted @display 
                                                {label: "Response"} RecordUpdateResponse|error {
        xml payload = check buildUpdateRecord(account, ACCOUNT , self.config);
        http:Response response = check sendRequest(self.basicClient, UPDATE_SOAP_ACTION, payload);
        return getUpdateResponse(response); 
    }

    # Retrieves all currency types instances from NetSuite.
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

    # Retrieve a list of existing saved search IDs on a per-record-type basis
    #
    # + searchType - Netsuite saved search types
    # + return - If success returns the list of saved search references otherwise the relevant error
    @display{label: "Get saved search IDs by record type"} 
    isolated remote function getSavedSearchIDs(@display{label: "Record type"} string searchType) returns @tainted 
                                               @display{label: "Response"} SavedSearchResponse|error {
        xml payload = check BuildSavedSearchRequestPayload(self.config, searchType);
        http:Response response = check sendRequest(self.basicClient, GET_SAVED_SEARCH_ACTION, payload);
        return getSavedSearchIDsResponse(response);
    }
 
    # Perform a saved search search operation using the saved search ID.
    #
    # + savedSearchId - Saved search ID (Internal ID)
    # + advancedSearchType - Type of the saved search from the list given here: [CalendarEventSearchAdvanced,
    # PhoneCallSearchAdvanced, FileSearchAdvanced, FolderSearchAdvanced, NoteSearchAdvanced, MessageSearchAdvanced, 
    # BinSearchAdvanced, ClassificationSearchAdvanced, DepartmentSearchAdvanced, LocationSearchAdvanced,
    # SalesTaxItemSearchAdvanced, SubsidiarySearchAdvanced, EmployeeSearchAdvanced, CampaignSearchAdvanced,
    # ContactSearchAdvanced, CustomerSearchAdvanced, PartnerSearchAdvanced, VendorSearchAdvanced, EntityGroupSearchAdvanced,
    # JobSearchAdvanced, SiteCategorySearchAdvanced, SupportCaseSearchAdvanced, SolutionSearchAdvanced, TopicSearchAdvanced,
    # IssueSearchAdvanced,CustomRecordSearchAdvanced, TimeBillSearchAdvanced, BudgetSearchAdvanced, AccountSearchAdvanced,
    # AccountingTransactionSearchAdvanced, OpportunitySearchAdvanced, TransactionSearchAdvanced, TaskSearchAdvanced,
    # ItemSearchAdvanced, GiftCertificateSearchAdvanced, PromotionCodeSearchAdvanced]
    # + return - Ballerina stream of json type otherwise the relevant error
    @display{label: "Perform saved search by ID"}
    isolated remote function performSavedSearchById(@display{label: "Saved Search ID"} string savedSearchId, 
                                                    @display{label: "Advanced Search type"} string advancedSearchType) returns 
                                                    @tainted stream<json, error?>|error {
        xml payload = check buildSavedSearchByIDPayload(self.config, savedSearchId, advancedSearchType);
        http:Response response = check sendRequest(self.basicClient, SEARCH_SOAP_ACTION, payload);
        return getSavedSearchResult(response, self.basicClient, self.config);
    }


    # Retrieves NetSuite client instances from NetSuite according to the given detail 
    # if they are valid.
    #
    # + searchElements - Details of a NetSuite record to be retrieved from NetSuite
    # + return - Ballerina stream of customer type records otherwise the relevant error
    @display{label: "Search Customers"} 
    isolated remote function searchCustomerRecords(@display{label: "Search Elements"} SearchElement[] searchElements) 
                                                  returns @tainted @display{label: "Response"} 
                                                  stream<Customer, error?>|error {
        xml payload = check buildCustomerSearchPayload(self.config, searchElements);
        http:Response response = check sendRequest(self.basicClient, SEARCH_SOAP_ACTION, payload);
        return getCustomerSearchResult(response,self.basicClient, self.config);
    }

    # Retrieves NetSuite transaction instances from NetSuite according to the given detail if they are valid.
    #
    # + searchElements - Details of a NetSuite record to be retrieved from NetSuite
    # + return -  Ballerina stream of transaction type records otherwise the relevant error
    @display{label: "Search Transactions"}
    isolated remote function searchTransactionRecords(@display{label: "Search Elements"} SearchElement[] searchElements) 
                                                     returns @tainted @display{label: "Response"} stream<RecordRef, 
                                                     error?>|error {
        xml payload = check buildTransactionSearchPayload(self.config, searchElements);
        http:Response response = check sendRequest(self.basicClient, SEARCH_SOAP_ACTION, payload);
        return getTransactionSearchResult(response,self.basicClient, self.config);
    }

    # Retrieves NetSuite account record instances from NetSuite according to the given detail.
    #
    # + searchElements - Details of a NetSuite record to be retrieved from NetSuite
    # + return - Ballerina stream of account type records otherwise the relevant error
    @display{label: "Search Accounts"}
    isolated remote function searchAccountRecords(@display{label: "Search Elements"} SearchElement[] searchElements) 
                                                 returns @tainted @display{label: "Response"} stream<Account, 
                                                 error?>|error {
        xml payload = check buildAccountSearchPayload(self.config, searchElements);
        http:Response response = check sendRequest(self.basicClient, SEARCH_SOAP_ACTION, payload);
        return getAccountSearchResult(response, self.basicClient, self.config);
    }

    # Retrieves NetSuite contact record instances from NetSuite according to the given detail
    #
    # + searchElements - Details of a NetSuite record to be retrieved from NetSuite
    # + return - Ballerina stream of contact type records otherwise the relevant error
    @display{label: "Search Contacts"}
    isolated remote function searchContactRecords(@display{label: "Search Elements"} SearchElement[] searchElements) 
                                                 returns @tainted @display{label: "Response"} stream<Contact, 
                                                 error?>|error {
        xml payload = check buildContactSearchPayload(self.config, searchElements);
        http:Response response = check sendRequest(self.basicClient, SEARCH_SOAP_ACTION, payload);
        return getContactsSearchResult(response, self.basicClient, self.config);
    }

    # Retrieves NetSuite vendor record instances from NetSuite according to the given detail
    #
    # + searchElements -  Details of a NetSuite record to be retrieved from NetSuite
    # + return - Ballerina stream of vendor type records otherwise the relevant error
    @display{label: "Search Vendors"}
    isolated remote function searchVendorRecords(@display{label: "Search Elements"} SearchElement[] searchElements) 
                                                 returns @tainted @display{label: "Response"} stream<Vendor, 
                                                 error?>|error {
        xml payload = check buildVendorSearchPayload(self.config, searchElements);
        http:Response response = check sendRequest(self.basicClient, SEARCH_SOAP_ACTION, payload);
        return getVendorSearchResult(response, self.basicClient, self.config);
    }

    # Gets a vendor record from Netsuite by using internal ID.
    #
    # + recordInfo - Ballerina record for Netsuite record information
    # + return - Vendor type record otherwise the relevant error
    @display{label: "Get Vendor"}
    isolated remote function getVendorRecord(@display{label: "Record Detail"} RecordInfo recordInfo) returns 
                                             @display{label: "Response"} Vendor|error {
        xml payload = check buildGetOperationPayload(recordInfo, self.config);
        http:Response response = check sendRequest(self.basicClient, GET_SOAP_ACTION, payload);
        return getVendorResult(response);
    }

    # Gets a vendorBill record from Netsuite by using internal ID.
    #
    # + recordInfo - Ballerina record for Netsuite record information
    # + return - VendorBill type record otherwise the relevant error
    @display{label: "Get VendorBill"}
    isolated remote function getVendorBillRecord(@display{label: "Record Detail"} RecordInfo recordInfo) returns 
                                                 @display{label: "Response"} VendorBill|error {
        xml payload = check buildGetOperationPayload(recordInfo, self.config);
        http:Response response = check sendRequest(self.basicClient, GET_SOAP_ACTION, payload);
        return getVendorBillResult(response);
    }

    # Gets a customer record from Netsuite by using internal ID.
    #
    # + recordInfo - Ballerina record for Netsuite record information
    # + return - Customer type record otherwise the relevant error
    @display{label: "Get Customer"}
    isolated remote function getCustomerRecord(@display{label: "Record Detail"} RecordInfo recordInfo) returns 
                                               @tainted @display{label: "Response"} Customer|error {
        xml payload = check buildGetOperationPayload(recordInfo, self.config);
        http:Response response = check sendRequest(self.basicClient, GET_SOAP_ACTION, payload);
        return getCustomerResult(response);
    }

    # Gets a contact record from Netsuite by using internal ID.
    #
    # + recordInfo - Ballerina record for Netsuite record information
    # + return - Contact type record otherwise the relevant error
    @display{label: "Get Contact"}  
    isolated remote function getContactRecord(@display{label: "Record Detail"} RecordInfo recordInfo) returns 
                                              @tainted @display{label: "Response"} Contact|error {
        http:Request request = new;
        xml payload = check buildGetOperationPayload(recordInfo, self.config);
        http:Response response = check sendRequest(self.basicClient, GET_SOAP_ACTION, payload);
        return getContactResult(response);
    }

    # Gets a currency record from Netsuite by using internal ID.
    #
    # + recordInfo - Ballerina record for Netsuite record information
    # + return - Currency type record otherwise the relevant error
    @display{label: "Get Currency"}
    isolated remote function getCurrencyRecord(@display{label: "Record Detail"} RecordInfo recordInfo) returns 
                                               @tainted @display{label: "Response"} Currency|error {
        http:Request request = new;
        xml payload = check buildGetOperationPayload(recordInfo, self.config);
        http:Response response = check sendRequest(self.basicClient, GET_SOAP_ACTION, payload);
        return getCurrencyResult(response);
    }

    # Gets a currency record from Netsuite by using internal ID.
    #
    # + recordInfo - Ballerina record for Netsuite record information
    # + return - Classification type record otherwise the relevant error
    @display{label: "Get Classification"}
    isolated remote function getClassificationRecord(@display{label: "Record Detail"} RecordInfo recordInfo) returns 
                                                     @tainted @display{label: "Response"} Classification|error {
        http:Request request = new;
        xml payload = check buildGetOperationPayload(recordInfo, self.config);
        http:Response response = check sendRequest(self.basicClient, GET_SOAP_ACTION, payload);
        return getClassificationResult(response);
    }

    # Gets a invoice record from Netsuite by using internal ID.
    #
    # + recordInfo - Ballerina record for Netsuite record information
    # + return - invoice type record otherwise the relevant error
    @display{label: "Get Invoice"}
    isolated remote function getInvoiceRecord(@display{label: "Record Detail"} RecordInfo recordInfo) returns 
                                              @tainted @display{label: "Response"} Invoice|error {
        http:Request request = new;
        xml payload = check buildGetOperationPayload(recordInfo, self.config);
        http:Response response = check sendRequest(self.basicClient, GET_SOAP_ACTION, payload);
        return getInvoiceResult(response);
    }

    # Gets a salesOrder record from Netsuite by using internal ID.
    #
    # + recordInfo - Ballerina record for Netsuite record information
    # + return - SalesOrder type record otherwise the relevant error
    @display{label: "Get Sales Order"}
    isolated remote function getSalesOrderRecord(@display{label: "Record Detail"} RecordInfo recordInfo) returns 
                                                 @tainted @display{label: "Response"} SalesOrder|error {
        http:Request request = new;
        xml payload = check buildGetOperationPayload(recordInfo, self.config);
        http:Response response = check sendRequest(self.basicClient, GET_SOAP_ACTION, payload);
        return getSalesOrderResult(response);
    }

    # Gets a account record from Netsuite by using internal Id.
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

    # Returns the NetSuite server time in GMT, regardless of a user's time zone.
    #
    # + return - If success returns the server time otherwise the relevant error
    @display{label: "Get Netsuite Server Time"} 
    isolated remote function getNetSuiteServerTime() returns @tainted @display{label: "Response"} string|error {
        xml payload = check buildGetServerTime(self.config);
        http:Response response = check sendRequest(self.basicClient, GET_SERVER_TIME_ACTION, payload);
        return getServerTimeResponse(response);
    }

    # Provides ability to send a SOAP based request with custom xml body
    #
    # + body - Custom xml body
    # + soapAction - SOAP action of the operation
    # + return - Response in XML or an error
    @display{label: "Send Custom Request"}   
    isolated remote function makeCustomRequest(@display{label: "Custom XML body elements"} xml|string body, 
                                               @display{label: "SOAP Action"} string soapAction) returns 
                                               @display{label: "Response"} xml|error {
        xml payload = check getCustomXMLBodyWithParentElement(body, self.config);
        http:Response response = check sendRequest(self.basicClient, soapAction, payload);
        return response.getXmlPayload();
    }
 }

# Configuration record for NetSuite.
#
# + accountId - NetSuite Account ID  
# + consumerSecret - Netsuite Integration application consumer secret
# + baseURL - Netsuite SuiteTalk URLs for SOAP web services (Available at Setup->Company->Company Information->Company 
# URLs)
# + consumerId - Netsuite Integration App consumer ID   
# + tokenSecret - Netsuite user role access secret 
# + token - Netsuite user role access token
@display{label: "Connection Config"}  
public type ConnectionConfig record {
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
