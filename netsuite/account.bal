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

isolated function mapNewItemGroupRecordFields(NewItemGroup itemGroup) returns string|error {
    string finalResult = EMPTY_STRING;
    map<anydata>|error itemGroupMap = itemGroup.cloneWithType(MapAnyData);
    if itemGroupMap is map<anydata> {
        string[] keys = itemGroupMap.keys();
        int position = 0;
        foreach var item in itemGroup {
            if item is string|boolean|decimal {
                finalResult += setSimpleType(keys[position], item, LIST_ACCT);
            } else if item is RecordInputRef {
                finalResult += getXMLRecordInputRef(<RecordInputRef>item);
            } else if item is RecordRef {
                finalResult += getXMLRecordRef(<RecordRef>item);
            } else if item is RecordRef[] {
                string recordRefList = check getRecordRefListInXML(<RecordRef[]>item);
                finalResult += string `<${LIST_ACCT}:${keys[position]} xsi:type="nsCore:RecordRefList" 
                    xmlns:nsCore="urn:core_2020_2.platform.webservices.netsuite.com">
                    ${recordRefList}
                    </${LIST_ACCT}:${keys[position]}>`;
            } else if item is ItemMember[] {
                string itemMemberList = EMPTY_STRING;
                foreach ItemMember itemMember in item {
                    itemMemberList += string `
                        <${LIST_ACCT}:itemMember xsi:type="${LIST_ACCT}:ItemMember">
                        ${getItemMemberInXML(itemMember)}
                        </${LIST_ACCT}:itemMember>`;     
                }
                finalResult += string `
                    <${LIST_ACCT}:memberList xsi:type="${LIST_ACCT}:ItemMemberList" replaceAll="false">
                            ${itemMemberList}
                    </${LIST_ACCT}:memberList>`;
            } else if (item is Translation[]) {
                string translationList = EMPTY_STRING;
                foreach Translation translation in item {
                    translationList += string `
                        <${LIST_ACCT}:translation xsi:type="${LIST_ACCT}:Translation">
                        ${getTranslationOrHierarchyVRecordsInXML(translation)}
                        </${LIST_ACCT}:translation>`;     
                }
                finalResult += string `
                    <${LIST_ACCT}:translationsList xsi:type="${LIST_ACCT}:TranslationsList">
                            ${translationList}
                    </${LIST_ACCT}:translationsList>`;
            } else if item is ItemGroupHierarchyVersions[] {
                string hierarchyList = EMPTY_STRING;
                foreach ItemGroupHierarchyVersions hVersion in item {
                    hierarchyList += string `
                        <${LIST_ACCT}:itemGroupHierarchyVersions xsi:type="${LIST_ACCT}:ItemGroupHierarchyVersions">
                        ${getTranslationOrHierarchyVRecordsInXML(hVersion)}
                        </${LIST_ACCT}:itemGroupHierarchyVersions>`;     
                }
                finalResult += string `
                    <${LIST_ACCT}:hierarchyVersionsList xsi:type="${LIST_ACCT}:ItemGroupHierarchyVersionsList">
                            ${hierarchyList}
                    </${LIST_ACCT}:hierarchyVersionsList>`;
            } else if item is CustomFieldList {
                finalResult += check getCustomElementList(item, LIST_ACCT);
            }
            position += 1;
        }
    }
    return finalResult;
}

isolated function getTranslationOrHierarchyVRecordsInXML(Translation translation) returns string {
    string finalResult = EMPTY_STRING;
    map<anydata>|error translationMap = translation.cloneWithType(MapAnyData);
    if (translationMap is map<anydata>) {
        string[] keys = translationMap.keys();
        int position = 0;
        foreach var item in translation {
            if item is string|boolean|decimal {
                finalResult += setSimpleType(keys[position], item, LIST_ACCT);
            } else if item is RecordInputRef {
                finalResult += getXMLRecordInputRef(<RecordInputRef>item);
            } else if item is RecordRef {
                finalResult += getXMLRecordRef(<RecordRef>item);
            }
            position += 1;
        }
    }
    return finalResult;
}

isolated function getItemMemberInXML(ItemMember itemMember) returns string {
    string finalResult = EMPTY_STRING;
    map<anydata>|error itemMemberMap = itemMember.cloneWithType(MapAnyData);
    if (itemMemberMap is map<anydata>) {
        string[] keys = itemMemberMap.keys();
        int position = 0;
        foreach var item in itemMember {
            if item is string|boolean|decimal {
                if(keys[position] == "vsoeDeferral") {
                    finalResult += string `<nsCommon:vsoeDeferral xsi:type="nsCommon:VsoeDeferral">
                    ${item}</nsCommon:vsoeDeferral>`;
                } else if keys[position] == "vsoePermitDiscount" {
                    finalResult += string `
                    <nsCommon:vsoePermitDiscount xsi:type="nsCommon:VsoePermitDiscount">
                    ${item}
                    </nsCommon:vsoePermitDiscount>`;
                } else if keys[position]== "itemSource" {
                    finalResult += string `
                    <nsCommon:itemSource xsi:type="nsCommon:ItemSource">
                    ${item}
                    </nsCommon:itemSource>`;
                } else {
                    finalResult += setSimpleType(keys[position], item, LIST_ACCT);
                } 
            } else if item is RecordInputRef {
                finalResult += getXMLRecordInputRef(<RecordInputRef>item);
            } else if item is RecordRef {
                finalResult += getXMLRecordRef(<RecordRef>item);
            }
            position += 1;
        }
    }
    return finalResult;  
}

isolated function getRecordRefListInXML(RecordRef[] records) returns string|error {
    string recordListInXML = EMPTY_STRING;
    foreach RecordRef ref in records {
        recordListInXML += string `<nsCore:recordRef xsi:type="nsCore:RecordRef" type="${ref.'type.toString()}" 
            internalId="${check ref.internalId.ensureType(string)}"/>`;
    }
    return recordListInXML;
}

isolated function wrapItemGroupElements(string subElements) returns string {
    return string `<urn:record xsi:type="listAcct:ItemGroup" 
    xmlns:listAcct="urn:accounting_2020_2.lists.webservices.netsuite.com" 
    xmlns:nsCore="urn:core_2020_2.platform.webservices.netsuite.com" 
    xmlns:nsCommon="urn:types.common_2020_2.platform.webservices.netsuite.com">
            ${subElements}
        </urn:record>`;
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

isolated function getAccountResult(http:Response response) returns Account|error {
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

isolated function getItemGroupResult(http:Response response) returns ItemGroup|error {
    xml xmlValue = check formatPayload(response);
    if (response.statusCode == http:STATUS_OK) { 
        xml output  = xmlValue/**/<status>;
        boolean isSuccess = check extractBooleanValueFromXMLOrText(output.isSuccess);
        if(isSuccess) {
            ItemGroup itemGroup = check mapItemGroupRecord(xmlValue);
            return itemGroup;
        } else {
            fail error(NO_RECORD_CHECK);
        }
    } else {
        fail error(NO_RECORD_CHECK);
    }
}

isolated function mapItemMemberRecord(xml itemMembersXml) returns ItemMember[]|error {
    xmlns "urn:accounting_2020_2.lists.webservices.netsuite.com" as listAcct;
    ItemMember[] itemMembers = [];
    foreach xml element in itemMembersXml {
        ItemMember itemMember = {
            memberDescr:extractStringFromXML(element/**/<listAcct:memberDescr>/*),
            componentYield:extractDecimalFromXML(element/**/<listAcct:componentYield>/*),
            bomQuantity:extractDecimalFromXML(element/**/<listAcct:bomQuantity>/*),
            itemSource:extractStringFromXML(element/**/<listAcct:itemSource>/*),
            quantity:extractDecimalFromXML(element/**/<listAcct:quantity>/*),
            memberUnit:extractRecordRefFromXML(element/**/<listAcct:memberUnit>),
            vsoeDeferral:extractStringFromXML(element/**/<listAcct:vsoeDeferral>/*),
            vsoePermitDiscount:extractStringFromXML(element/**/<listAcct:vsoePermitDiscount>/*),
            taxSchedule:extractRecordRefFromXML(element/**/<listAcct:taxSchedule>),
            taxcode:extractStringFromXML(element/**/<listAcct:taxcode>/*),
            item:extractRecordRefFromXML(element/**/<listAcct:item>),
            taxrate:extractDecimalFromXML(element/**/<listAcct:taxrate>/*),
            effectiveDate:extractStringFromXML(element/**/<listAcct:effectiveDate>/*),
            obsoleteDate:extractStringFromXML(element/**/<listAcct:obsoleteDate>/*),
            effectiveRevision:extractRecordRefFromXML(element/**/<listAcct:effectiveRevision>),
            obsoleteRevision:extractRecordRefFromXML(element/**/<listAcct:obsoleteRevision>),
            lineNumber:extractDecimalFromXML(element/**/<listAcct:lineNumber>/*),
            memberKey:extractStringFromXML(element/**/<listAcct:memberKey>/*)
        };
        boolean|error value = extractBooleanValueFromXMLOrText(element/**/<listAcct:vsoeDelivered>/*);
        if (value is boolean) {
            itemMember.vsoeDelivered = value;
        }
        itemMembers.push(itemMember);
    }
    return itemMembers;
}

isolated function mapItemGroupRecord(xml response) returns ItemGroup|error {
    xmlns "urn:accounting_2020_2.lists.webservices.netsuite.com" as listAcct;
    ItemGroup itemGroup = {
        internalId: extractRecordInternalIdFromXMLAttribute(response/**/<'record>),
        createdDate: extractStringFromXML(response/**/<listAcct:createdDate>/*),
        lastModifiedDate: extractStringFromXML(response/**/<listAcct:lastModifiedDate>/*),
        customForm: extractRecordRefFromXML(response/**/<listAcct:customForm>),
        defaultItemShipMethod: extractRecordRefFromXML(response/**/<listAcct:defaultItemShipMethod>),
        itemId: extractStringFromXML(response/**/<listAcct:itemId>/*),
        upcCode: extractStringFromXML(response/**/<listAcct:upcCode>/*),
        displayName: extractStringFromXML(response/**/<listAcct:displayName>/*),
        vendorName: extractStringFromXML(response/**/<listAcct:vendorName>/*),
        issueProduct: extractRecordRefFromXML(response/**/<listAcct:issueProduct>),
        parent: extractRecordRefFromXML(response/**/<listAcct:parent>),
        description: extractStringFromXML(response/**/<listAcct:description>/*),
        department: extractRecordRefFromXML(response/**/<listAcct:department>),
        'class: extractRecordRefFromXML(response/**/<listAcct:'class>),
        location: extractRecordRefFromXML(response/**/<listAcct:location>),
        memberList: check mapItemMemberRecord(response/**/<listAcct:memberList>/*),
        customFieldList: check extractCustomFiledListFromXML(response/**/<listAcct:customFieldList>/*)
    };
    boolean|error value = extractBooleanValueFromXMLOrText(response/**/<listAcct:includeStartEndLines>/*);
    if (value is boolean) {
        itemGroup.includeStartEndLines = value;
    }
    value = extractBooleanValueFromXMLOrText(response/**/<listAcct:isVsoeBundle>/*);
    if (value is boolean) {
        itemGroup.isVsoeBundle = value;
    }
    value = extractBooleanValueFromXMLOrText(response/**/<listAcct:availableToPartners>/*);
    if (value is boolean) {
        itemGroup.availableToPartners = value;
    }
    value = extractBooleanValueFromXMLOrText(response/**/<listAcct:isInactive>/*);
    if (value is boolean) {
        itemGroup.isInactive = value;
    }
    value = extractBooleanValueFromXMLOrText(response/**/<listAcct:printItems>/*);
    if (value is boolean) {
        itemGroup.printItems = value;
    }
    return itemGroup;
}

isolated function mapAccountRecord(xml response) returns Account|error {
    xmlns "urn:accounting_2020_2.lists.webservices.netsuite.com" as listAcct;
    Account account = {
        internalId: extractRecordInternalIdFromXMLAttribute(response/**/<'record>),
        acctType: extractStringFromXML(response/**/<listAcct:acctType>/*),
        acctNumber: extractStringFromXML(response/**/<listAcct:acctNumber>/*),
        acctName: extractStringFromXML(response/**/<listAcct:acctName>/*),
        generalRate: extractStringFromXML(response/**/<listAcct:generalRate>/*),
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
