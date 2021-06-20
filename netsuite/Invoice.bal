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

isolated function mapInvoiceRecordFields(Invoice invoice) returns string|error {
    string finalResult = EMPTY_STRING;
    map<anydata>|error invoiceMap = invoice.cloneWithType(MapAnyData);
    if (invoiceMap is map<anydata>) {
        string[] keys = invoiceMap.keys();
        int position = 0;
        foreach var invoiceField in invoice {
            if (invoiceField is string|decimal) {
                finalResult += setSimpleType(keys[position], invoiceField, TRAN_SALES);
            } else if (invoiceField is RecordRef) {
                finalResult += getXMLRecordRef(<RecordRef>invoiceField);
            } else if (invoiceField is Item[]) {
                string itemXMLList = EMPTY_STRING;
                foreach Item item in invoiceField {
                    string itemElements = check buildInvoiceItemElement(item);
                    itemXMLList += itemElements;
                }
                finalResult += string`<itemList>${itemXMLList}</itemList>`;  
            } 
            position += 1;
        }
    }
    return finalResult;
}

isolated function mapNewInvoiceRecordFields(NewInvoice invoice) returns string|error {
    string finalResult = EMPTY_STRING;
    map<anydata>|error invoiceMap = invoice.cloneWithType(MapAnyData);
    if (invoiceMap is map<anydata>) {
        string[] keys = invoiceMap.keys();
        int position = 0;
        foreach var invoiceField in invoice {
            if (invoiceField is string|decimal) {
                finalResult += setSimpleType(keys[position], invoiceField, TRAN_SALES);
            } else if (invoiceField is RecordInputRef) {
                finalResult += getXMLRecordInputRef(<RecordInputRef>invoiceField);
            } else if (invoiceField is RecordRef) {
                finalResult += getXMLRecordRef(<RecordRef>invoiceField);
            } else if (invoiceField is Item[]) {
                string itemXMLList = EMPTY_STRING;
                foreach Item item in invoiceField {
                    string itemElements = check buildInvoiceItemElement(item);
                    itemXMLList += itemElements;
                }
                finalResult += string`<itemList>${itemXMLList}</itemList>`;  
            } 
            position += 1;
        }
    }
    return finalResult;
}

isolated function buildInvoiceItemElement(Item item) returns string|error {
    string itemElements = EMPTY_STRING;
    map<anydata> itemMap = check item.cloneWithType(MapAnyData);
    string[] keys = itemMap.keys();
    int position = 0;
    foreach var itemField in item {
        if(itemField is RecordRef) {
            itemElements += getXMLRecordRef(<RecordRef>itemField);
        }else if (itemField is string|boolean|decimal) {
            itemElements += setSimpleType(keys[position], itemField, TRAN_SALES);
        }
        position += 1;
    }
    return string`<item>${itemElements}</item>`;
}

isolated function wrapInvoiceElements(string subElements) returns string{
    return string `<urn:record xsi:type="tranSales:Invoice" 
        xmlns:tranSales="urn:sales_2020_2.transactions.webservices.netsuite.com">
            ${subElements}
         </urn:record>`;
}

isolated function wrapInvoiceElementsToBeUpdatedWithParentElement(string subElements, string internalId) returns string{
    return string `<urn:record xsi:type="tranSales:Invoice" internalId="${internalId}"
        xmlns:tranSales="urn:sales_2020_2.transactions.webservices.netsuite.com">
            ${subElements}
         </urn:record>`;
}

isolated function mapInvoiceRecord(xml response) returns Invoice|error {
    xmlns "urn:sales_2020_2.transactions.webservices.netsuite.com" as tranSales;
    Invoice invoice  = {
        discountTotal: extractDecimalFromXML(response/**/<tranSales:discountTotal>/*),
        recognizedRevenue: extractDecimalFromXML(response/**/<tranSales:recognizedRevenue>/*),
        deferredRevenue: extractDecimalFromXML(response/**/<tranSales:deferredRevenue>/*),
        subsidiary: extractRecordRefFromXML(response/**/<tranSales:subsidiary>),
        classification:extractRecordRefFromXML(response/**/<tranSales:'class>),
        total:extractDecimalFromXML(response/**/<tranSales:total>/*),
        department: extractRecordRefFromXML(response/**/<tranSales:department>),
        createdDate: (response/**/<tranSales:createdDate>/*).toString(),
        lastModifiedDate: extractStringFromXML(response/**/<tranSales:createdDate>/*),
        status: extractStringFromXML(response/**/<tranSales:status>/*),
        entity: extractRecordRefFromXML(response/**/<tranSales:entity>),
        currency: extractRecordRefFromXML(response/**/<tranSales:currency>),
        internalId: extractRecordInternalIdFromXMLAttribute(response/**/<'record>)
    };
    return invoice;
}

isolated function getInvoiceResult(http:Response response) returns @tainted Invoice|error {
    xml xmlValue = check formatPayload(response);
    if (response.statusCode == http:STATUS_OK) { 
        xml output  = xmlValue/**/<status>;
        boolean isSuccess = check extractBooleanValueFromXMLOrText(output.isSuccess);
        if(isSuccess) {
            return mapInvoiceRecord(xmlValue);
        } else {
            fail error(NO_RECORD_FOUND);
        }
    } else {
        fail error(xmlValue.toString());
    }
}

isolated function buildTransactionSearchPayload(NetSuiteConfiguration config, SearchElement[] searchElement) returns 
                                                xml|error {
    string requestHeader = check buildXMLPayloadHeader(config);
    string requestBody = getTranscationSearchRequestBody(searchElement);
    return check getSoapPayload(requestHeader, requestBody); 
}

isolated function getTranscationSearchRequestBody(SearchElement[] SearchElements) returns string{
    return string `<soapenv:Body><search xmlns="urn:messages_2020_2.platform.webservices.netsuite.com" 
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <searchRecord xsi:type="ns1:TransactionSearchBasic" xmlns:ns1="urn:common_2020_2.platform.webservices.netsuite.com">
    ${getSearchElement(SearchElements)}
    </searchRecord>
    </search></soapenv:Body>
    </soapenv:Envelope>`;
}

isolated function mapTransactionRecords(xml transactionRecord) returns RecordRef|error {
    RecordRef recordRef = {
        internalId: check transactionRecord/**/<'record>.internalId,
        'type: check transactionRecord/**/<'record>.xsi_type
    };
    return recordRef;
}

isolated function getTransactionsFromSearchResults(xml TransactionData) returns RecordRef[]|error{
    int size = TransactionData.length();
    RecordRef[] recordRefs =[];
    foreach int i in 0 ..< size {
        xml recordItem = 'xml:get(TransactionData, i);
        recordRefs.push(check mapTransactionRecords(recordItem));  
    }
    return recordRefs;
}

isolated function getTransactionsNextPageResult(http:Response response) returns @tainted record {|RecordRef[] recordRefs; SearchResultStatus status;|}|error {
    SearchResultStatus resultStatus = check getXMLRecordListFromSearchResult(response);
    return {recordRefs :check getTransactionsFromSearchResults(resultStatus.recordList), status: resultStatus};
}

isolated function getTransactionSearchResult(http:Response response, http:Client httpClient, NetSuiteConfiguration config) returns @tainted stream<RecordRef, error>|error {
    SearchResultStatus resultStatus = check getXMLRecordListFromSearchResult(response);
    TransactionStream objectInstance = check new (httpClient, resultStatus, config);
    stream<RecordRef, error> finalStream = new (objectInstance);
    return finalStream;
}
