
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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  This sample shows searching transactions happened in a given time period and retrieve list of invoices            //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
import ballerinax/netsuite;
import ballerina/log;
import ballerina/os;

configurable string accountId = os:getEnv("NS_ACCOUNTID");
configurable string consumerId = os:getEnv("NS_CLIENT_ID");
configurable string consumerSecret = os:getEnv("NS_CLIENT_SECRET");
configurable string token = os:getEnv("NS_TOKEN");
configurable string tokenSecret = os:getEnv("NS_TOKEN_SECRET");
configurable string baseURL = os:getEnv("NS_BASE_URL");

public function main() returns error? {

    //Preparing the netsuite configuration with TBA authentication tokens.
    netsuite:ConnectionConfig config = {
        accountId: accountId,
        consumerId: consumerId,
        consumerSecret: consumerSecret,
        token: token,
        tokenSecret: tokenSecret,
        baseURL: baseURL
    };

    //Creates a NetSuite cleint
    netsuite:Client netSuiteClient = check new (config);

    //Searches transactions within the given dates
    netsuite:SearchElement searchRecord1 = {
        fieldName: "lastModifiedDate",
        searchType: netsuite:SEARCH_DATE_FIELD,
        operator: "within",
        value1: "2020-12-23T10:20:15",
        value2: "2021-03-23T10:20:15"
    };
    netsuite:SearchElement[] searchElements = [searchRecord1];
    netsuite:RecordList recordList = check netSuiteClient->searchTransactionRecord(searchElements);

    //Get invoices from the record list provided by the transaction search operation
    netsuite:Invoice[] invoicesList = [];
    foreach netsuite:RecordRef recordRef in recordList.records {
        if (recordRef?.'type == "tranSales:Invoice") {
            netsuite:RecordDetail recordDetail = {
                recordInternalId: recordRef.internalId,
                recordType: netsuite:INVOICE
            };
            netsuite:Invoice invoice = check netSuiteClient->getInvoiceRecord(recordDetail);
            invoicesList.push(invoice);
        }
    }
    log:printInfo(invoicesList.toString());
}
