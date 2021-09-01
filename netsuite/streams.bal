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
    ConnectionConfig config;

    isolated function  init(http:Client httpClient, SearchResultStatus resultStatus, ConnectionConfig config) 
                            returns @tainted error? {
        self.httpClient = httpClient;
        self.customerEntries = check getCustomersFromSearchResults(resultStatus.recordList);
        self.totalPages = resultStatus.totalPages;
        self.currentPage = resultStatus.pageIndex;
        self.searchId = resultStatus.searchId;
        self.config = config;
    }

    public isolated function next() returns @tainted record {| Customer value; |}|error? {
        if(self.index < self.customerEntries.length()) {
            record {| Customer value; |} singleRecord = {value: self.customerEntries[self.index]};
            self.index += 1;
            return singleRecord;
        }else if (self.totalPages != self.currentPage ) {
            self.index = 0;
            self.customerEntries = check self.fetchCustomers();
            record {| Customer value; |} singleRecord = {value: self.customerEntries[self.index]};
            self.index += 1;
            return singleRecord;
        }
    }

    isolated function fetchCustomers() returns @tainted Customer[]|error {
        xml payload = check buildSearchMoreWithIdPayload(self.config, self.currentPage + 1, self.searchId);
        http:Response response = check sendRequest(self.httpClient, SEARCH_MORE_WITH_ID, payload);
        record {|Customer[] customers; SearchResultStatus status;|} newPage = check getCustomersNextPageResult(
            response);
        self.currentPage=newPage.status.pageIndex;
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
    ConnectionConfig config;

    isolated function  init(http:Client httpClient, SearchResultStatus resultStatus, ConnectionConfig config) 
                            returns @tainted error? {
        self.httpClient = httpClient;
        self.accountEntries = check getAccountsFromSearchResults(resultStatus.recordList);
        self.totalPages = resultStatus.totalPages;
        self.currentPage = resultStatus.pageIndex;
        self.searchId = resultStatus.searchId;
        self.config = config;
    }

    public isolated function next() returns @tainted record {| Account value; |}|error? {
        if(self.index < self.accountEntries.length()) {
            record {| Account value; |} singleRecord = {value: self.accountEntries[self.index]};
            self.index += 1;
            return singleRecord;
        }else if (self.totalPages != self.currentPage ) {
            self.index = 0;
            self.accountEntries = check self.fetchAccounts();
            record {| Account value; |} singleRecord = {value: self.accountEntries[self.index]};
            self.index += 1;
            return singleRecord;
        }
    }

    isolated function fetchAccounts() returns @tainted Account[]|error {
        log:printDebug(REQUEST_NEXT_PAGE);
        xml payload = check buildSearchMoreWithIdPayload(self.config, self.currentPage + 1, self.searchId);
        http:Response response = check sendRequest(self.httpClient, SEARCH_MORE_WITH_ID, payload);
        record {|Account[] accounts; SearchResultStatus status;|} newPage = check getAccountsNextPageResult(response);
        self.currentPage=newPage.status.pageIndex;
        return newPage.accounts;
    }
}

class TransactionStream {
    private RecordRef[] transactionEntries = [];
    int index = 0;
    private final http:Client httpClient;
    int totalPages;
    int currentPage;
    string searchId;
    ConnectionConfig config;

    isolated function  init(http:Client httpClient, SearchResultStatus resultStatus, ConnectionConfig config) 
                            returns @tainted error? {
        self.httpClient = httpClient;
        self.transactionEntries = check getTransactionsFromSearchResults(resultStatus.recordList);
        self.totalPages = resultStatus.totalPages;
        self.currentPage = resultStatus.pageIndex;
        self.searchId = resultStatus.searchId;
        self.config = config;
    }

    public isolated function next() returns @tainted record {| RecordRef value; |}|error? {
        if(self.index < self.transactionEntries.length()) {
            record {| RecordRef value; |} singleRecord = {value: self.transactionEntries[self.index]};
            self.index += 1;
            return singleRecord;
        }else if (self.totalPages != self.currentPage ) {
            self.index = 0;
            self.transactionEntries = check self.fetchTransactions();
            record {| RecordRef value; |} singleRecord = {value: self.transactionEntries[self.index]};
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
        self.currentPage=newPage.status.pageIndex;
        return newPage.recordRefs;
    }
}

class ContactStream {
    private Contact[] contactEntries = [];
    int index = 0;
    private final http:Client httpClient;
    int totalPages;
    int currentPage;
    string searchId;
    ConnectionConfig config;

    isolated function  init(http:Client httpClient, SearchResultStatus resultStatus, ConnectionConfig config) 
                            returns @tainted error? {
        self.httpClient = httpClient;
        self.contactEntries = check getTransactionsFromSearchResults(resultStatus.recordList);
        self.totalPages = resultStatus.totalPages;
        self.currentPage = resultStatus.pageIndex;
        self.searchId = resultStatus.searchId;
        self.config = config;
    }

    public isolated function next() returns @tainted record {| Contact value; |}|error? {
        if(self.index < self.contactEntries.length()) {
            record {| Contact value; |} singleRecord = {value: self.contactEntries[self.index]};
            self.index += 1;
            return singleRecord;
        }else if (self.totalPages != self.currentPage ) {
            self.index = 0;
            self.contactEntries = check self.fetchTransactions();
            record {| Contact value; |} singleRecord = {value: self.contactEntries[self.index]};
            self.index += 1;
            return singleRecord;
        }
    }

    isolated function fetchTransactions() returns @tainted Contact[]|error {
        log:printInfo(REQUEST_NEXT_PAGE);
        xml payload = check buildSearchMoreWithIdPayload(self.config, self.currentPage + 1, self.searchId);
        http:Response response = check sendRequest(self.httpClient, SEARCH_MORE_WITH_ID, payload);
        record {|Contact[] contacts; SearchResultStatus status;|} newPage = check getContactsNextPageResult(response);
        self.currentPage=newPage.status.pageIndex;
        return newPage.contacts;
    }
}

class SavedSearchStream {
    private json[] savedSearchRowEntries = [];
    int index = 0;
    private final http:Client httpClient;
    int totalPages;
    int currentPage;
    string searchId;
    ConnectionConfig config;

    isolated function  init(http:Client httpClient, SavedSearchResult resultStatus, ConnectionConfig config) 
                            returns @tainted error? {
        self.httpClient = httpClient;
        self.savedSearchRowEntries = resultStatus.recordList;
        self.totalPages = resultStatus.totalPages;
        self.currentPage = resultStatus.pageIndex;
        self.searchId = resultStatus.searchId;
        self.config = config;
    }

    public isolated function next() returns @tainted record {| json value; |}|error? {
        if(self.index < self.savedSearchRowEntries.length()) {
            record {| json value; |} singleRecord = {value: self.savedSearchRowEntries[self.index]};
            self.index += 1;
            return singleRecord;
        }else if (self.totalPages != self.currentPage ) {
            self.index = 0;
            self.savedSearchRowEntries = check self.fetchNextSavedSearchResults();
            record {| json value; |} singleRecord = {value: self.savedSearchRowEntries[self.index]};
            self.index += 1;
            return singleRecord;
        }
    }

    isolated function fetchNextSavedSearchResults() returns @tainted json[]|error {
        xml payload = check buildSearchMoreWithIdPayload(self.config, self.currentPage + 1, self.searchId);
        http:Response response = check sendRequest(self.httpClient, SEARCH_MORE_WITH_ID, payload);
        record {|json[] savedSearchRows; SavedSearchResult status;|} newPage = check getSavedSearchNextPageResult(response);
        self.currentPage=newPage.status.pageIndex;
        return newPage.savedSearchRows;
    }
}
