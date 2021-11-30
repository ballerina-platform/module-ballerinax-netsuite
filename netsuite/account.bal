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

isolated function mapAccountRecordFields(Account account) returns string {
    string finalResult = EMPTY_STRING;
    map<anydata>|error accountMap = account.cloneWithType(MapAnyData);
    if (accountMap is map<anydata>) {
        string[] keys = accountMap.keys();
        int position = 0;
        foreach var item in account {
            if (item is string|boolean|decimal) {
                finalResult += setSimpleType(keys[position], item, LIST_ACCT);
            } else if (item is RecordRef) {
                finalResult += getXMLRecordRef(<RecordRef>item);
            }
            position += 1;
        }
    }
    return finalResult;
}

isolated function mapNewAccountRecordFields(NewAccount account) returns string {
    string finalResult = EMPTY_STRING;
    map<anydata>|error accountMap = account.cloneWithType(MapAnyData);
    if (accountMap is map<anydata>) {
        string[] keys = accountMap.keys();
        int position = 0;
        foreach var item in account {
            if (item is string|boolean|decimal) {
                finalResult += setSimpleType(keys[position], item, LIST_ACCT);
            } else if (item is RecordInputRef) {
                finalResult += getXMLRecordInputRef(<RecordInputRef>item);
            } else if (item is RecordRef) {
                finalResult += getXMLRecordRef(<RecordRef>item);
            }
            position += 1;
        }
    }
    return finalResult;
}

isolated function wrapAccountElements(string subElements) returns string {
    return string `<urn:record xsi:type="listAcct:Account" 
    xmlns:listAcct="urn:accounting_2020_2.lists.webservices.netsuite.com">
            ${subElements}
        </urn:record>`;
}

isolated function wrapAccountElementsToUpdatedWithParentElement(string subElements, string internalId) returns string {
    return string `<urn:record xsi:type="listAcct:Account" internalId="${internalId}" 
    xmlns:listAcct="urn:accounting_2020_2.lists.webservices.netsuite.com">
            ${subElements}
        </urn:record>`;
}

isolated function getAccountSearchRequestBody(SearchElement[] searchElements) returns string {
    return string `<soapenv:Body> <urn:search xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"> 
    <urn:searchRecord xsi:type="listAcct:AccountSearch" 
    xmlns:listAcct="urn:accounting_2020_2.lists.webservices.netsuite.com">
    <basic xsi:type="ns1:AccountSearchBasic" 
    xmlns:ns1="urn:common_2020_2.platform.webservices.netsuite.com">${getSearchElement(searchElements)}</basic>
    </urn:searchRecord></urn:search></soapenv:Body></soapenv:Envelope>`;
}

isolated function buildAccountSearchPayload(ConnectionConfig config,SearchElement[] searchElement) returns xml|error {
    string requestHeader = check buildXMLPayloadHeader(config);
    string requestBody = getAccountSearchRequestBody(searchElement);
    return check getSoapPayload(requestHeader, requestBody);   
}

isolated function getAccountsFromSearchResults(xml accountData) returns Account[]|error{
    int size = accountData.length();
    Account[] accounts =[];
    foreach int i in 0 ..< size {
        xml recordItem = 'xml:get(accountData, i);
        accounts.push(check mapAccountRecord(recordItem));  
    }
    return accounts;
}

isolated function getAccountsNextPageResult(http:Response response) returns @tainted record {|Account[] accounts; 
                                            SearchResultStatus status;|}|error {
    SearchResultStatus resultStatus = check getXMLRecordListFromSearchResult(response);
    return {accounts :check getAccountsFromSearchResults(resultStatus.recordList), status: resultStatus};
}

isolated function getAccountSearchResult(http:Response response, http:Client httpClient, ConnectionConfig config) 
                                         returns stream<SearchResult, error?>|error {
    SearchResultStatus resultStatus = check getXMLRecordListFromSearchResult(response);
    AccountStream objectInstance = check new (httpClient,resultStatus,config);
    stream<SearchResult, error?> finalStream = new (objectInstance);
    return finalStream;
}


isolated function mapAccountFields(json accountTypeJson, Account account) returns error? {
    json valueList = getValidJson(accountTypeJson.'record.'record);
    account.acctName = getValidJson(valueList.acctName).toString();
    account.acctNumber = getValidJson(valueList.acctNumber).toString(); 
    account.legalName = getValidJson(valueList.legalName).toString();
    account.acctType = getValidJson(valueList.acctType).toString();
    account.generalRate = getValidJson(valueList.generalRate).toString();
    account.cashFlowRate = getValidJson(valueList.cashFlowRate).toString();
    return;   
}

isolated function getAccountResult(http:Response response) returns @tainted Account|error {
    xml xmlValue = check formatPayload(response);
    if (response.statusCode == http:STATUS_OK) { 
        xml output  = xmlValue/**/<status>;
        boolean isSuccess = check extractBooleanValueFromXMLOrText(output.isSuccess);
        if(isSuccess) {
            return mapAccountRecord(xmlValue);
        } else {
            fail error(NO_RECORD_CHECK);
        }
    } else {
        fail error(NO_RECORD_CHECK);
    }
}

isolated function mapAccountRecord(xml response) returns Account|error {
    xmlns "urn:accounting_2020_2.lists.webservices.netsuite.com" as listAcct;
    Account account = {
        internalId: extractRecordInternalIdFromXMLAttribute(response/**/<'record>),
        acctType: extractStringFromXML(response/**/<listAcct:acctType>/*),
        acctNumber: extractStringFromXML(response/**/<listAcct:acctNumber>/*),
        acctName: extractStringFromXML(response/**/<listAcct:acctName>/*),
        generalRate : extractStringFromXML(response/**/<listAcct:generalRate>/*),
        cashFlowRate: extractStringFromXML(response/**/<listAcct:cashFlowRate>/*),
        currency:extractRecordRefFromXML(response/**/<listAcct:currency>)   
    };

    boolean|error value = extractBooleanValueFromXMLOrText(response/**/<listAcct:includeChildren>/*);
    if (value is boolean) {
        account.includeChildren = value;
    }

    value = extractBooleanValueFromXMLOrText(response/**/<listAcct:isInactive>/*);
    if(value is boolean) {
        account.isInactive = value;
    }
    value = extractBooleanValueFromXMLOrText(response/**/<listAcct:inventory>/*);
    if (value is boolean) {
        account.inventory = value;
    }
    value = extractBooleanValueFromXMLOrText(response/**/<listAcct:revalue>/*);
    if (value is boolean) {
        account.revalue = value;
    }
    value = extractBooleanValueFromXMLOrText(response/**/<listAcct:eliminate>/*);
    if (value is boolean) {
        account.eliminate = value;
    }
    return account;
}
