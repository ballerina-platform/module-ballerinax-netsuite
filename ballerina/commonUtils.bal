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
import ballerina/lang.'boolean as booleanLib;
import ballerina/lang.'decimal as decimalLib;
import ballerina/lang.'int as intLib;
import ballerina/time;
import ballerina/lang.'xml as xmlLib;

isolated function sendRequest(http:Client basicClient, string action, xml payload) returns @tainted http:Response|error {
    http:Request request = new;
    request.setXmlPayload(payload);
    request.setHeader(SOAP_ACTION_HEADER, action);
    return <http:Response>check basicClient->post(EMPTY_STRING, request);
}

isolated function buildXMLPayloadHeader(ConnectionConfig config) returns string|error {
    time:Utc timeNow = time:utcNow();
    var [timeInUTC, _] = timeNow;
    string timeToSend = timeInUTC.toString();
    string uuid = getRandomString();
    string signature = check getNetsuiteSignature(timeToSend, uuid, config);
    string header = string `<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" 
    xmlns:urn="urn:messages_2020_2.platform.webservices.netsuite.com" 
    xmlns:urn1="urn:core_2020_2.platform.webservices.netsuite.com"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <soapenv:Header>
    <urn:tokenPassport><urn1:account>${
    config.accountId}</urn1:account>
    <urn1:consumerKey>${config.consumerId}</urn1:consumerKey>
    <urn1:token>${
    config.token}</urn1:token>
    <urn1:nonce>${uuid}</urn1:nonce>
    <urn1:timestamp>${timeToSend}</urn1:timestamp>
    <urn1:signature algorithm="HMAC-SHA256">${
    signature}</urn1:signature>
    </urn:tokenPassport>
    </soapenv:Header>`;
    return header;
}

isolated function getXMLRecordRef(RecordRef recordRef) returns string {
    string xmlRecord = string `<${recordRef?.'type.toString()} xsi:type="urn1:RecordRef" 
    internalId="${recordRef.internalId}"/>`;
    string? externalId = recordRef?.externalId;
    if (externalId is string) {
        xmlRecord = string `<${recordRef?.'type.toString()} xsi:type="urn1:RecordRef" 
        internalId="${recordRef.internalId}" 
        externalId="${externalId}"/>`;
    } 
    return xmlRecord;
}

isolated function getXMLRecordInputRef(RecordInputRef recordRef) returns string {
    string xmlRecord = string `<${recordRef.'type.toString()} xsi:type="urn1:RecordRef" 
    internalId="${recordRef.internalId}"/>`;
    string? externalId = recordRef?.externalId;
    if (externalId is string) {
        xmlRecord = string `<${recordRef?.'type.toString()} xsi:type="urn1:RecordRef" 
        internalId="${recordRef.internalId}" 
        externalId="${externalId}"/>`;
    } 
    return xmlRecord;
}

isolated function setSimpleType(string elementName, string|boolean|decimal|int value, string namespace) returns string {
    return string `<${namespace}:${elementName}>${value.toString()}</${namespace}:${elementName}>`;
}

isolated function getAddXMLBodyWithParentElement(string subElements) returns string {
    return string `<soapenv:Body>
    <urn:add>
            ${subElements}
    </urn:add>
    </soapenv:Body>
    </soapenv:Envelope>`;
}

isolated function buildCustomXMLPayload(xml|string customBody, ConnectionConfig config) returns xml|error {
    string header = check buildXMLPayloadHeader(config);
    string body =  string `<soapenv:Body>${customBody.toString()}</soapenv:Body></soapenv:Envelope>`;
    return getSoapPayload(header, body);
}

isolated function getDeleteXMLBodyWithParentElement(string subElements) returns string {
    return string `<soapenv:Body>
    <urn:delete>
            ${subElements}
    </urn:delete>
    </soapenv:Body>
    </soapenv:Envelope>`;
}

isolated function getUpdateXMLBodyWithParentElement(string subElements) returns string {
    return string `<soapenv:Body>
    <urn:update>
            ${subElements}
    </urn:update>
    </soapenv:Body>
    </soapenv:Envelope>`;
}

isolated function buildAddOperationPayload(NewRecordType recordType, RecordCoreType recordCoreType, ConnectionConfig config) 
                                returns xml|error {
    string header = check buildXMLPayloadHeader(config);
    string subElements = check getAddOperationElements(recordType, recordCoreType);
    string body = getAddXMLBodyWithParentElement(subElements);
    return getSoapPayload(header, body);
}

isolated function buildDeleteOperationPayload(RecordDetail recordType, ConnectionConfig config) returns xml|error {
    string header = check buildXMLPayloadHeader(config);
    string subElements = getDeletePayload(recordType);
    string body = getDeleteXMLBodyWithParentElement(subElements);
    return getSoapPayload(header, body);
}

isolated function buildUpdateOperationPayload(ExistingRecordType recordType, RecordCoreType recordCoreType, ConnectionConfig 
                                    config, boolean replaceAll = false) returns xml|error {
    string header = check buildXMLPayloadHeader(config);
    string elements = check getUpdateOperationElements(recordType, recordCoreType, replaceAll);
    string body = getUpdateXMLBodyWithParentElement(elements);
    return getSoapPayload(header, body);    
}

isolated function getUpdateOperationElements(ExistingRecordType recordType, RecordCoreType recordCoreType, 
        boolean replaceAll= false) returns string|error {
    string subElements = EMPTY_STRING;   
    match recordCoreType {
        CUSTOMER => {
             subElements = mapCustomerRecordFields(<Customer>recordType); 
             return wrapCustomerElementsToBeUpdatedWithParentElement(subElements, recordType?.internalId.toString());
        }
        VENDOR => {
            subElements = check mapVendorRecordFields(<Vendor>recordType);
            return wrapVendorElementsWithParent(subElements, recordType?.internalId.toString());
        }
        VENDOR_BILL => {
            subElements = check mapVendorBillRecordFields(<VendorBill>recordType);
            return wrapVendorBillElementsWithParentElement(subElements, recordType?.internalId.toString());
        }
        CONTACT => {
             subElements = mapContactRecordFields(<Contact>recordType); 
             return wrapContactElementsToBeUpdatedWithParentElement(subElements, recordType?.internalId.toString());
        }
        CURRENCY => {
            subElements = mapCurrencyRecordFields(<Currency>recordType);
            return wrapCurrencyElementsToBeUpdatedWithParentElement(subElements, recordType?.internalId.toString());
        }
        SALES_ORDER => {
            subElements = mapSalesOrderRecordFields(<SalesOrder>recordType);
            return wrapSalesOrderElementsToBeUpdatedWithParentElement(subElements, recordType?.internalId.toString());
        }
        CLASSIFICATION => {
            subElements = mapClassificationRecordFields(<Classification>recordType); 
            return wrapClassificationElementsToBeUpdatedWithParentElement(subElements, recordType?.internalId.toString());
        }
        ACCOUNT => {
            subElements = mapAccountRecordFields(<Account>recordType); 
            return wrapAccountElementsToUpdatedWithParentElement(subElements, recordType?.internalId.toString());
        }
        INVOICE => {
            subElements = check mapInvoiceRecordFields(<Invoice>recordType, replaceAll); 
            return wrapInvoiceElementsToBeUpdatedWithParentElement(subElements, recordType?.internalId.toString());
        }
        _ => {
                fail error(UNKNOWN_TYPE);
        }
    }
}

isolated function getAddOperationElements(NewRecordType recordType, RecordCoreType recordCoreType) returns string|error{ 
    string subElements = EMPTY_STRING;  
    match recordCoreType {
        CUSTOMER => {
            subElements = mapNewCustomerRecordFields(<NewCustomer>recordType); 
            return wrapCustomerElements(subElements);
        }
        VENDOR_BILL => {
            subElements = check mapNewVendorBillRecordFields(<NewVendorBill>recordType);
            return wrapVendorBillElements(subElements);
        }
        VENDOR => {
            subElements = check mapNewVendorRecordFields(<NewVendor>recordType);
            return wrapVendorElements(subElements);
        }
        CONTACT => {
            subElements = mapNewContactRecordFields(<NewContact>recordType); 
            return wrapContactElements(subElements);
        }
        CURRENCY => {
            subElements = mapNewCurrencyRecordFields(<NewCurrency>recordType);
            return wrapCurrencyElements(subElements);
        }
        SALES_ORDER => {
            subElements = mapNewSalesOrderRecordFields(<NewSalesOrder>recordType);
            return wrapSalesOrderElements(subElements);
        }
        INVOICE => {
            subElements = check mapNewInvoiceRecordFields(<NewInvoice>recordType); 
            return wrapInvoiceElements(subElements);
        }
        CLASSIFICATION => {
            subElements = mapNewClassificationRecordFields(<NewClassification>recordType); 
            return wrapClassificationElements(subElements);
        }
        ACCOUNT => {
            subElements = mapNewAccountRecordFields(<NewAccount>recordType); 
            return wrapAccountElements(subElements);
        }
        ITEM_GROUP => {
            subElements = check mapNewItemGroupRecordFields(<NewItemGroup>recordType); 
            return wrapItemGroupElements(subElements);
        }
        _ => {
                fail error(UNKNOWN_TYPE);
        }
    }
}

isolated function buildGetOperationPayload(RecordInfo records, ConnectionConfig config) returns xml|error {
    string header = check buildXMLPayloadHeader(config);
    string elements = prepareElementsForGetOperation(records);
    string body = string `<soapenv:Body><urn:get xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">${elements}
        </urn:get></soapenv:Body></soapenv:Envelope>`;
    return getSoapPayload(header, body);
}

isolated function prepareElementsForGetOperation(RecordInfo recordDetail) returns string {
    string elements = string `<urn:baseRef internalId="${recordDetail.recordInternalId}" type="${recordDetail.recordType}"
        xsi:type="urn1:RecordRef"/>`;
    return elements;
}

isolated function getDeletePayload(RecordDetail recordDetail) returns string{
    if(recordDetail?.deletionReasonId is () || recordDetail?.deletionReasonMemo is ()) {
        return getXMLElementForDeletion(recordDetail);
    } else {
        return getXMLElementForDeletionWithDeleteReason(recordDetail);
    }  
}

isolated function getXMLElementForDeletion(RecordDetail recordDetail) returns string {
    return string `<urn:baseRef type="${recordDetail.recordType}" internalId="${recordDetail.recordInternalId}" 
        xsi:type="urn1:RecordRef"/>`;
}

isolated function getXMLElementForDeletionWithDeleteReason(RecordDetail recordDetail) returns string {
    return string `<urn:baseRef type="${recordDetail.recordType}" internalId="${recordDetail.recordInternalId}" 
        xsi:type="urn1:RecordRef"/>
        <urn1:deletionReason>
        <deletionReasonCode internalId="${recordDetail?.deletionReasonId.toString()}"/>
        <deletionReasonMemo>${recordDetail?.deletionReasonMemo.toString()}</deletionReasonMemo>
        </urn1:deletionReason>`;
}

isolated function buildGetAllPayload(string recordType, ConnectionConfig config) returns xml|error {
    string header = check buildXMLPayloadHeader(config);
    string body = getXMLBodyForGetAllOperation(recordType);
    return getSoapPayload(header, body);
}

isolated function getXMLBodyForGetAllOperation(string recordType) returns string{
    return string `<soapenv:Body><urn:getAll><record recordType="${recordType}"/></urn:getAll></soapenv:Body>
        </soapenv:Envelope>`;
}

isolated function getXMLBodyForGetServerTime() returns string{
    return string`<soapenv:Body><urn:getServerTime/></soapenv:Body></soapenv:Envelope>`;
}

isolated function buildGetServerTimePayload(ConnectionConfig config) returns xml|error {
    string header = check buildXMLPayloadHeader(config);
    string body = getXMLBodyForGetServerTime();
    return getSoapPayload(header, body);
}

isolated function getValidJson(json|error element) returns json?{
    if(element is json) {
        return element;
    } 
    return;
}

isolated function checkXmlElementValidity(xml|error element) returns xml?{
    if(element is xml) {
        return element;
    }
    return;
}

isolated function checkStringValidity(string|error element) returns string?{
    if(element is string) {
        return element;
    }
    return;
}

isolated function extractBooleanValueFromJson(json|error element) returns boolean|error {
    return booleanLib:fromString(getValidJson(element).toString());
}

isolated function extractBooleanValueFromXMLOrText(xml|string|error element) returns boolean|error {
   if(element is xml|string) {
       return booleanLib:fromString(element.toString()); 
   } else {
       return element;
   }
}

isolated function getRecordRef(json element, json elementRecordType) returns RecordRef {
    RecordRef recordRef = {
        name: getValidJson(elementRecordType.name).toString(),
        internalId: getValidJson(element.\@internalId).toString(),
        externalId: getValidJson(element.\@externalId).toString(),
        'type: let var recordType = getValidJson(element.\'type) in recordType is () ? EMPTY_STRING : (recordType.toString())
    };
    return recordRef;
}

isolated function extractDecimalFromXML(xml element) returns decimal? {
    decimal|error castedValue = trap decimalLib:fromString((element).toString());
    if(castedValue is decimal) {
         return castedValue;
    }
    return;
}

isolated function extractIntegerFromXML(xml element) returns int? {
    int|error castedValue = trap intLib:fromString((element).toString());
    if (castedValue is int) {
         return castedValue;
    }
    return;
}

isolated function extractStringFromXML(xml|string|error element) returns string {
    if(element is xml|string) {
         return element.toString();
    } else {
        return EMPTY_STRING;
    }  
}

isolated function extractRecordRefFromXML(xml element) returns RecordRef {
    return {
        internalId: let var  internalId = element.internalId in internalId is error ? EMPTY_STRING : (internalId.toString()),
        name: extractStringFromXML(element/<name>/*),
        'type: let var recordType = element.\'type in recordType is error ? EMPTY_STRING : (recordType.toString())
    }; 
}

isolated function extractClassificationFromXML(xml element) returns Classification {
    return {
        internalId: let var  internalId = element.internalId in internalId is error ? EMPTY_STRING : (internalId.toString()),
        name: extractStringFromXML(element/<name>/*),
        "type": let var recordType = element.\'type in recordType is error ? EMPTY_STRING : (recordType.toString())
    }; 
}

isolated function extractRecordInternalIdFromXMLAttribute(xml element) returns string {
    return let var internalId = element.internalId in internalId is error ? EMPTY_STRING : internalId;
}

isolated function BuildSavedSearchRequestPayload(ConnectionConfig config, string searchType) returns xml|error {
    string header = check buildXMLPayloadHeader(config);
    string body = getXMLBodyForGetSavedSearchIDs(searchType);
    return getSoapPayload(header, body);
}

isolated function getXMLBodyForGetSavedSearchIDs(string searchType) returns string{
    return string `<soapenv:Body><urn:getSavedSearch><record searchType="${searchType}"/></urn:getSavedSearch>
        </soapenv:Body></soapenv:Envelope>`;
}

isolated function getCustomElementList(CustomFieldList customFieldList, string namespace) returns string|error {
    string fieldsWithParentElement = string `<${namespace}:customFieldList xmlns:platformCore="urn:core_2020_2.platform.webservices.netsuite.com">`;
    foreach var item in customFieldList.customFields {
        if (item is LongCustomFieldRef) {
            fieldsWithParentElement += string `<platformCore:customField internalId="${item.internalId}" scriptId="${item?.scriptId.toString()}" xsi:type="platformCore:LongCustomFieldRef">
            <platformCore:value>${item.value.toString()}</platformCore:value></platformCore:customField>`;
        } else if(item is StringOrDateCustomFieldRef) {
            fieldsWithParentElement += string `<platformCore:customField internalId="${item.internalId}" scriptId="${item?.scriptId.toString()}" xsi:type="platformCore:StringCustomFieldRef">
            <platformCore:value>${item.value}</platformCore:value></platformCore:customField>`;
        } else if (item is BooleanCustomFieldRef) {
            fieldsWithParentElement += string `<platformCore:customField internalId="${item.internalId}" scriptId="${item?.scriptId.toString()}" xsi:type="platformCore:BooleanCustomFieldRef">
            <platformCore:value>${item.value}</platformCore:value></platformCore:customField>`;
        } else if (item is SelectCustomFieldRef) {
            fieldsWithParentElement += string `<platformCore:customField internalId="${item.internalId}" scriptId="${item?.scriptId.toString()}" xsi:type="platformCore:SelectCustomFieldRef">
            <platformCore:value internalId="${item.value.internalId}"><platformCore:name>${item.value.recordName}</platformCore:name></platformCore:value></platformCore:customField>`;
        } else if (item is MultiSelectCustomFieldRef) {
            fieldsWithParentElement += string `<platformCore:customField internalId="${item.internalId}" scriptId="${item?.scriptId.toString()}" xsi:type="platformCore:MultiSelectCustomFieldRef">
            ${getMultiSelectCustomFields(item.value)} </platformCore:customField>`;
        } else {
            fieldsWithParentElement += string `<platformCore:customField internalId="${item.internalId}" scriptId="${item?.scriptId.toString()}" xsi:type="platformCore:DoubleCustomFieldRef">
            <platformCore:value>${item.value.toString()}</platformCore:value></platformCore:customField>`;
        }
    }
    return fieldsWithParentElement + string `</${namespace}:customFieldList>`;
}

isolated function getMultiSelectCustomFields(ListOrRecordRef[] value) returns string {
    string multiField = EMPTY_STRING;
    foreach ListOrRecordRef item in value {
        multiField += string  `<platformCore:value internalId="${item.internalId}"><platformCore:name>${item.recordName}</platformCore:name>
        </platformCore:value>`;
    }
    return multiField;
}


isolated function mapLongCustomFieldRef(xml element) returns LongCustomFieldRef{
    return {
        internalId: extractStringFromXML(element.internalId),
        scriptId: extractStringFromXML(element.scriptId),
        value: extractIntegerFromXML(element/<value>/*)
    };
}

isolated function mapDoubleCustomFieldRef(xml element) returns DoubleCustomFieldRef{
    return {
        internalId: extractStringFromXML(element.internalId),
        scriptId: extractStringFromXML(element.scriptId),
        value: extractDecimalFromXML(element/<value>/*)
    };
}

isolated function mapBooleanCustomFieldRef(xml element) returns BooleanCustomFieldRef|error {
    return {
        internalId: extractStringFromXML(element.internalId),
        scriptId: extractStringFromXML(element.scriptId),
        value: check extractBooleanValueFromXMLOrText(element/<value>/*)
    };
}

isolated function mapStringOrDateCustomFieldRef(xml element) returns StringOrDateCustomFieldRef {
    return {
        internalId: extractStringFromXML(element.internalId),
        scriptId: extractStringFromXML(element.scriptId),
        value: extractStringFromXML(element/<value>/*)
    };
}

isolated function mapSelectCustomFieldRef(xml element) returns SelectCustomFieldRef { 
    return {
        internalId: extractStringFromXML(element.internalId),
        scriptId: extractStringFromXML(element.scriptId),
        value: extractListOrRecordRefFromXML(element/<value>)
    };
}

isolated function mapMultiSelectCustomFieldRef(xml element) returns MultiSelectCustomFieldRef {
    return {
        internalId: extractStringFromXML(element.internalId),
        scriptId: extractStringFromXML(element.scriptId),
        value: extractArrayOfListOrRecordRefFromXML(element/*)
    };
}

isolated function extractArrayOfListOrRecordRefFromXML(xml element) returns ListOrRecordRef[] {
   ListOrRecordRef[] listOrRecordRef = [];
   foreach xml item in element {
       listOrRecordRef.push(extractListOrRecordRefFromXML(item));
   }
   return listOrRecordRef;
}


isolated function extractListOrRecordRefFromXML(xml element) returns ListOrRecordRef {
    return {
        recordName: extractStringFromXML(element/<name>/*),
        internalId: extractStringFromXML(element.internalId)
    };
}



isolated function extractCustomFiledListFromXML(xml customFieldList) returns CustomFieldList|error {
    CustomField[] customFields = [];
    foreach xml element in customFieldList {
        string? 'type = extractStringFromXML(element.xsi_type);
        match 'type {
            "LongCustomFieldRef" => {
                customFields.push(mapLongCustomFieldRef(element));
            }
            "DoubleCustomFieldRef"=> {
                customFields.push(mapDoubleCustomFieldRef(element));
            }
            "BooleanCustomFieldRef" => {
                customFields.push(check mapBooleanCustomFieldRef(element));
            }
            "StringCustomFieldRef" | "DateCustomFieldRef" => {
                customFields.push(mapStringOrDateCustomFieldRef(element));
            }
            "SelectCustomFieldRef"=> {
                customFields.push(mapSelectCustomFieldRef(element));
            }
            "MultiSelectCustomFieldRef" => {
                customFields.push(mapMultiSelectCustomFieldRef(element));
            }
        }
    }
    return {
        customFields: customFields
    };
}

isolated  function getSoapPayload(string header, string body) returns xml|error {
    string requestPayload = header + body;
    return check xmlLib:fromString(requestPayload);
}
