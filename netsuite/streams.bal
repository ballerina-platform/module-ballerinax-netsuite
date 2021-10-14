// Copyright (c) 2021 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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
import ballerina/log;

class CustomerStream {
    private Customer[] customerEntries = [];
    int index = 0;
    private final http:Client httpClient;
    int totalPages;
    int currentPage;
    string searchId;
    int totalRecords;
    int pageSize;
    ConnectionConfig config;

    isolated function init(http:Client httpClient, SearchResultStatus resultStatus, ConnectionConfig config)
                            returns @tainted error? {
        self.httpClient = httpClient;
        self.customerEntries = check getCustomersFromSearchResults(resultStatus.recordList);
        self.totalPages = resultStatus.totalPages;
        self.currentPage = resultStatus.pageIndex;
        self.totalPages = resultStatus.totalPages;
        self.pageSize = resultStatus?.pageSize;
        self.totalRecords = resultStatus.totalRecords;
        self.searchId = resultStatus.searchId;
        self.config = config;
    }

    public isolated function next() returns @tainted record {|SearchResult value;|}|error? {
        CommonSearchResult commonSearchResult = {
            pageIndex: self.currentPage,
            totalPages: self.totalPages,
            searchId: self.searchId,
            totalRecords: self.totalRecords,
            pageSize: self.pageSize  
        };
        if (self.index < self.customerEntries.length()) {
            record {|SearchResult value;|} singleRecord = {value: { result: self.customerEntries[self.index], 
                commonSearchResult: commonSearchResult}};
            self.index += 1;
            return singleRecord;
        } else if (self.totalPages != self.currentPage) {
            self.index = 0;
            self.customerEntries = check self.fetchCustomers();
            record {|SearchResult value;|} singleRecord = {value: { result: self.customerEntries[self.index], 
                commonSearchResult: commonSearchResult}};
            self.index += 1;
            return singleRecord;
        }
    }

    isolated function fetchCustomers() returns @tainted Customer[]|error {
        xml payload = check buildSearchMoreWithIdPayload(self.config, self.currentPage + 1, self.searchId);
        http:Response response = check sendRequest(self.httpClient, SEARCH_MORE_WITH_ID, payload);
        record {|Customer[] customers; SearchResultStatus status;|} newPage = check getCustomersNextPageResult(
            response);
        self.currentPage = newPage.status.pageIndex;
        return newPage.customers;
    }
}

class AccountStream {
    private Account[] accountEntries = [];
    int index = 0;
    private final http:Client httpClient;
    int totalPages;
    int currentPage;
    string searchId;
    int totalRecords;
    int pageSize;
    ConnectionConfig config;

    isolated function init(http:Client httpClient, SearchResultStatus resultStatus, ConnectionConfig config)
                            returns @tainted error? {
        self.httpClient = httpClient;
        self.accountEntries = check getAccountsFromSearchResults(resultStatus.recordList);
        self.totalPages = resultStatus.totalPages;
        self.currentPage = resultStatus.pageIndex;
        self.searchId = resultStatus.searchId;
        self.totalRecords = resultStatus.totalRecords;
        self.pageSize = resultStatus?.pageSize;
        self.config = config;
    }

    public isolated function next() returns @tainted record {|SearchResult value;|}|error? {
        CommonSearchResult commonSearchResult = {
            pageIndex: self.currentPage,
            totalPages: self.totalPages,
            searchId: self.searchId,
            totalRecords: self.totalRecords,
            pageSize: self.pageSize  
        };
        if (self.index < self.accountEntries.length()) {
            record {|SearchResult value;|} singleRecord = {value: { result: self.accountEntries[self.index], 
                commonSearchResult: commonSearchResult }};
            self.index += 1;
            return singleRecord;
        } else if (self.totalPages != self.currentPage) {
            self.index = 0;
            self.accountEntries = check self.fetchAccounts();
            record {|SearchResult value;|} singleRecord = {value: { result: self.accountEntries[self.index], 
                commonSearchResult: commonSearchResult }};
            self.index += 1;
            return singleRecord;
        }
    }

    isolated function fetchAccounts() returns @tainted Account[]|error {
        log:printDebug(REQUEST_NEXT_PAGE);
        xml payload = check buildSearchMoreWithIdPayload(self.config, self.currentPage + 1, self.searchId);
        http:Response response = check sendRequest(self.httpClient, SEARCH_MORE_WITH_ID, payload);
        record {|Account[] accounts; SearchResultStatus status;|} newPage = check getAccountsNextPageResult(response);
        self.currentPage = newPage.status.pageIndex;
        return newPage.accounts;
    }
}

class TransactionStream {
    private RecordRef[] transactionEntries = [];
    int index = 0;
    private final http:Client httpClient;
    int totalPages;
    int currentPage;
    int totalRecords;
    int pageSize;
    string searchId;
    ConnectionConfig config;

    isolated function init(http:Client httpClient, SearchResultStatus resultStatus, ConnectionConfig config)
                            returns @tainted error? {
        self.httpClient = httpClient;
        self.transactionEntries = check getTransactionsFromSearchResults(resultStatus.recordList);
        self.totalPages = resultStatus.totalPages;
        self.currentPage = resultStatus.pageIndex;
        self.totalRecords = resultStatus.totalRecords;
        self.pageSize = resultStatus?.pageSize;        
        self.searchId = resultStatus.searchId;
        self.config = config;
    }

    public isolated function next() returns @tainted record {|SearchResult value;|}|error? {
        CommonSearchResult commonSearchResult = {
            pageIndex: self.currentPage,
            totalPages: self.totalPages,
            searchId: self.searchId,
            totalRecords: self.totalRecords,
            pageSize: self.pageSize  
        };
        if (self.index < self.transactionEntries.length()) {
            record {|SearchResult value;|} singleRecord = {value: {result: self.transactionEntries[self.index], 
                commonSearchResult: commonSearchResult}};
            self.index += 1;
            return singleRecord;
        } else if (self.totalPages != self.currentPage) {
            self.index = 0;
            self.transactionEntries = check self.fetchTransactions();
            record {|SearchResult value;|} singleRecord = {value: {result: self.transactionEntries[self.index], 
                commonSearchResult: commonSearchResult}};
            self.index += 1;
            return singleRecord;
        }
    }

    isolated function fetchTransactions() returns @tainted RecordRef[]|error {
        log:printDebug(REQUEST_NEXT_PAGE);
        xml payload = check buildSearchMoreWithIdPayload(self.config, self.currentPage + 1, self.searchId);
        http:Response response = check sendRequest(self.httpClient, SEARCH_MORE_WITH_ID, payload);
        record {|RecordRef[] recordRefs; SearchResultStatus status;|} newPage = check getTransactionsNextPageResult(
            response);
        self.currentPage = newPage.status.pageIndex;
        return newPage.recordRefs;
    }
}

class ContactStream {
    private Contact[] contactEntries = [];
    int index = 0;
    private final http:Client httpClient;
    int totalPages;
    int currentPage;
    int totalRecords;
    int pageSize;
    string searchId;
    ConnectionConfig config;

    isolated function init(http:Client httpClient, SearchResultStatus resultStatus, ConnectionConfig config)
                            returns @tainted error? {
        self.httpClient = httpClient;
        self.contactEntries = check getContactsFromSearchResults(resultStatus.recordList);
        self.totalPages = resultStatus.totalPages;
        self.currentPage = resultStatus.pageIndex;
        self.totalRecords = resultStatus.totalRecords;
        self.pageSize = resultStatus?.pageSize;
        self.searchId = resultStatus.searchId;
        self.config = config;
    }

    public isolated function next() returns @tainted record {|SearchResult value;|}|error? {
        CommonSearchResult commonSearchResult = {
            pageIndex: self.currentPage,
            totalPages: self.totalPages,
            searchId: self.searchId,
            totalRecords: self.totalRecords,
            pageSize: self.pageSize  
        };
        if (self.index < self.contactEntries.length()) {
            record {|SearchResult value;|} singleRecord = {value: {result: self.contactEntries[self.index], 
                commonSearchResult: commonSearchResult}};
            self.index += 1;
            return singleRecord;
        } else if (self.totalPages != self.currentPage) {
            self.index = 0;
            self.contactEntries = check self.fetchTransactions();
            record {|SearchResult value;|} singleRecord = {value: {result: self.contactEntries[self.index], 
                commonSearchResult: commonSearchResult}};
            self.index += 1;
            return singleRecord;
        }
    }

    isolated function fetchTransactions() returns @tainted Contact[]|error {
        log:printInfo(REQUEST_NEXT_PAGE);
        xml payload = check buildSearchMoreWithIdPayload(self.config, self.currentPage + 1, self.searchId);
        http:Response response = check sendRequest(self.httpClient, SEARCH_MORE_WITH_ID, payload);
        record {|Contact[] contacts; SearchResultStatus status;|} newPage = check getContactsNextPageResult(response);
        self.currentPage = newPage.status.pageIndex;
        return newPage.contacts;
    }
}

class SavedSearchStream {
    private json[] savedSearchRowEntries = [];
    int index = 0;
    private final http:Client httpClient;
    int totalPages;
    int currentPage;
    int totalRecords;
    int pageSize;
    string searchId;
    ConnectionConfig config;

    isolated function init(http:Client httpClient, SavedSearchResult resultStatus, ConnectionConfig config)
                            returns @tainted error? {
        self.httpClient = httpClient;
        self.savedSearchRowEntries = resultStatus.recordList;
        self.totalPages = resultStatus.totalPages;
        self.currentPage = resultStatus.pageIndex;
        self.totalRecords = resultStatus.totalRecords;
        self.pageSize = resultStatus?.pageSize;
        self.searchId = resultStatus.searchId;
        self.config = config;
    }

    public isolated function next() returns @tainted record {|SearchResult value;|}|error? {
        CommonSearchResult commonSearchResult = {
            pageIndex: self.currentPage,
            totalPages: self.totalPages,
            searchId: self.searchId,
            totalRecords: self.totalRecords,
            pageSize: self.pageSize  
        };
        if (self.index < self.savedSearchRowEntries.length()) {
            record {|SearchResult value;|} singleRecord = {value: {result: self.savedSearchRowEntries[self.index], 
                commonSearchResult: commonSearchResult}};
            self.index += 1;
            return singleRecord;
        } else if (self.totalPages != self.currentPage) {
            self.index = 0;
            self.savedSearchRowEntries = check self.fetchNextSavedSearchResults();
            record {|SearchResult value;|} singleRecord = {value: {result: self.savedSearchRowEntries[self.index], 
                commonSearchResult: commonSearchResult}};
            self.index += 1;
            return singleRecord;
        }
    }

    isolated function fetchNextSavedSearchResults() returns @tainted json[]|error {
        xml payload = check buildSearchMoreWithIdPayload(self.config, self.currentPage + 1, self.searchId);
        http:Response response = check sendRequest(self.httpClient, SEARCH_MORE_WITH_ID, payload);
        record {|json[] savedSearchRows; SavedSearchResult status;|} newPage = check getSavedSearchNextPageResult(response);
        self.currentPage = newPage.status.pageIndex;
        return newPage.savedSearchRows;
    }
}

class VendorStream {
    private Vendor[] vendorEntries = [];
    int index = 0;
    private final http:Client httpClient;
    int totalPages;
    int currentPage;
    int totalRecords;
    int pageSize;
    string searchId;
    ConnectionConfig config;

    isolated function init(http:Client httpClient, SearchResultStatus resultStatus, ConnectionConfig config)
                            returns error? {
        self.httpClient = httpClient;
        self.vendorEntries = check getVendorsFromSearchResults(resultStatus.recordList);
        self.totalPages = resultStatus.totalPages;
        self.currentPage = resultStatus.pageIndex;
        self.totalRecords = resultStatus.totalRecords;
        self.pageSize = resultStatus?.pageSize;
        self.searchId = resultStatus.searchId;
        self.config = config;
    }

    public isolated function next() returns record {|SearchResult value;|}|error? {
        CommonSearchResult commonSearchResult = {
            pageIndex: self.currentPage,
            totalPages: self.totalPages,
            searchId: self.searchId,
            totalRecords: self.totalRecords,
            pageSize: self.pageSize  
        };
        if (self.index < self.vendorEntries.length()) {
            record {|SearchResult value;|} singleRecord = { value:{ result :self.vendorEntries[self.index], 
                commonSearchResult: commonSearchResult}};
            self.index += 1;
            return singleRecord;
        } else if (self.totalPages != self.currentPage) {
            self.index = 0;
            self.vendorEntries = check self.fetchTransactions();
            record {|SearchResult value;|} singleRecord = { value:{ result :self.vendorEntries[self.index], 
                commonSearchResult: commonSearchResult}};
            self.index += 1;
            return singleRecord;
        }
    }

    isolated function fetchTransactions() returns Vendor[]|error {
        log:printInfo(REQUEST_NEXT_PAGE);
        xml payload = check buildSearchMoreWithIdPayload(self.config, self.currentPage + 1, self.searchId);
        http:Response response = check sendRequest(self.httpClient, SEARCH_MORE_WITH_ID, payload);
        record {|Vendor[] vendors; SearchResultStatus status;|} newPage = check getVendorsNextPageResult(response);
        self.currentPage = newPage.status.pageIndex;
        return newPage.vendors;
    }
}
