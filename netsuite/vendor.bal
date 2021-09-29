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

isolated function mapNewVendorRecordFields(NewVendor vendor) returns string|error {
    string finalResult = EMPTY_STRING;
    map<anydata>|error vendorMap = vendor.cloneWithType(MapAnyData);
    if (vendorMap is map<anydata>) {
        string[] keys = vendorMap.keys();
        int position = 0;
        foreach var item in vendor {
            if (item is string|boolean) {
                finalResult += setSimpleType(keys[position], item, "listRel");
            } else if (item is RecordRef) {
                finalResult += getXMLRecordRef(<RecordRef>item);
            } else if (item is RecordInputRef) {
                finalResult += getXMLRecordInputRef(<RecordInputRef>item);
            } else if (item is CustomFieldList) {
                finalResult += check getCustomElementList(<CustomFieldList>item, "listRel");
            }
            position += 1;
        }
    }
    return finalResult;
}

isolated function mapVendorRecordFields(Vendor vendor) returns string|error {
    string finalResult = EMPTY_STRING;
    map<anydata>|error vendorMap = vendor.cloneWithType(MapAnyData);
    if (vendorMap is map<anydata>) {
        string[] keys = vendorMap.keys();
        int position = 0;
        foreach var item in vendor {
            if (item is string|boolean) {
                finalResult += setSimpleType(keys[position], item, "listRel");
            } else if (item is RecordRef) {
                finalResult += getXMLRecordRef(<RecordRef>item);
            } else if (item is RecordInputRef) {
                finalResult += getXMLRecordInputRef(<RecordInputRef>item);
            } else if (item is CustomFieldList) {
                finalResult += check getCustomElementList(<CustomFieldList>item, "listRel");
            }
            position += 1;
        }
    }
    return finalResult;
}

isolated function wrapVendorElements(string subElements) returns string {
    return string `<urn:record xsi:type="listRel:Vendor" xmlns:listRel="urn:relationships_2020_2.lists.webservices.netsuite.com">
            ${subElements}
        </urn:record>`;
}

isolated function wrapVendorElementsWithParent(string subElements, string internalId) returns string {
    return string `<urn:record xsi:type="listRel:Vendor" internalId="${internalId}" 
        xmlns:listRel="urn:relationships_2020_2.lists.webservices.netsuite.com">
            ${subElements}
         </urn:record>`;
}

isolated function getVendorResult(http:Response response) returns Vendor|error {
    xml payload = check formatPayload(response);
    if (response.statusCode == http:STATUS_OK) {
        xml output = payload/**/<status>;
        boolean isSuccess = check extractBooleanValueFromXMLOrText(output.isSuccess);
        if (isSuccess) {
            return mapVendorRecord(payload);
        } else {
            fail error(NO_RECORD_CHECK);
        }
    } else {
        fail error(payload.toString());
    }
}

isolated function mapVendorRecord(xml response) returns Vendor|error {
    xmlns "urn:relationships_2020_2.lists.webservices.netsuite.com" as listRel;
    Vendor vendor = {
        internalId: extractRecordInternalIdFromXMLAttribute(response/**/<'record>),
        companyName: extractStringFromXML(response/**/<listRel:companyName>/*),
        subsidiary: extractRecordRefFromXML(response/**/<listRel:subsidiary>),
        customForm: extractRecordRefFromXML(response/**/<listRel:customForm>),
        externalId: extractStringFromXML(response/**/<listRel:externalId>/*),
        entityId: extractStringFromXML(response/**/<listRel:entityId>/*),
        altName: extractStringFromXML(response/**/<listRel:altName>/*),
        phoneticName: extractStringFromXML(response/**/<listRel:phoneticName>/*),
        salutation: extractStringFromXML(response/**/<listRel:salutation>/*),
        firstName: extractStringFromXML(response/**/<listRel:firstName>/*),
        middleName: extractStringFromXML(response/**/<listRel:middleName>/*),
        lastName: extractStringFromXML(response/**/<listRel:lastName>/*),
        phone: extractStringFromXML(response/**/<listRel:phone>/*),
        fax: extractStringFromXML(response/**/<listRel:fax>/*),
        email: extractStringFromXML(response/**/<listRel:email>/*),
        url: extractStringFromXML(response/**/<listRel:url>/*),
        defaultAddress: extractStringFromXML(response/**/<listRel:defaultAddress>/*),
        lastModifiedDate: extractStringFromXML(response/**/<listRel:lastModifiedDate>/*),
        dateCreated: extractStringFromXML(response/**/<listRel:dateCreated>/*),
        category: extractRecordRefFromXML(response/**/<listRel:category>),
        title: extractStringFromXML(response/**/<listRel:title>/*),
        printOnCheckAs: extractStringFromXML(response/**/<listRel:printOnCheckAs>/*),
        altPhone: extractStringFromXML(response/**/<listRel:altPhone>/*),
        homePhone: extractStringFromXML(response/**/<listRel:homePhone>/*),
        mobilePhone: extractStringFromXML(response/**/<listRel:mobilePhone>/*),
        altEmail: extractStringFromXML(response/**/<listRel:altEmail>/*),
        comments: extractStringFromXML(response/**/<listRel:comments>/*),
        image: extractRecordRefFromXML(response/**/<listRel:image>),
        representingSubsidiary: extractRecordRefFromXML(response/**/<listRel:representingSubsidiary>),
        accountNumber: extractStringFromXML(response/**/<listRel:accountNumber>/*),
        legalName: extractStringFromXML(response/**/<listRel:legalName>/*),
        vatRegNumber: extractStringFromXML(response/**/<listRel:vatRegNumber>/*),
        expenseAccount: extractRecordRefFromXML(response/**/<listRel:expenseAccount>),
        payablesAccount: extractRecordRefFromXML(response/**/<listRel:payablesAccount>),
        terms: extractRecordRefFromXML(response/**/<listRel:terms>),
        incoterm: extractRecordRefFromXML(response/**/<listRel:incoterm>),
        creditLimit: extractDecimalFromXML(response/**/<listRel:creditLimit>/*),
        balancePrimary: extractDecimalFromXML(response/**/<listRel:balancePrimary>/*),
        openingBalance: extractDecimalFromXML(response/**/<listRel:openingBalance>/*),
        openingBalanceDate: extractStringFromXML(response/**/<listRel:openingBalanceDate>/*),
        openingBalanceAccount: extractRecordRefFromXML(response/**/<listRel:openingBalanceAccount>),
        balance: extractDecimalFromXML(response/**/<listRel:balance>/*),
        unbilledOrdersPrimary: extractDecimalFromXML(response/**/<listRel:unbilledOrdersPrimary>/*),
        bcn: extractStringFromXML(response/**/<listRel:bcn>/*),
        unbilledOrders: extractDecimalFromXML(response/**/<listRel:unbilledOrders>/*),
        currency: extractRecordRefFromXML(response/**/<listRel:currency>),
        laborCost: extractDecimalFromXML(response/**/<listRel:laborCost>/*),
        purchaseOrderQuantity: extractDecimalFromXML(response/**/<listRel:purchaseOrderQuantity>/*),
        purchaseOrderAmount: extractDecimalFromXML(response/**/<listRel:purchaseOrderAmount>/*),
        purchaseOrderQuantityDiff: extractDecimalFromXML(response/**/<listRel:purchaseOrderQuantityDiff>/*),
        receiptQuantity: extractDecimalFromXML(response/**/<listRel:receiptQuantity>/*),
        receiptAmount: extractDecimalFromXML(response/**/<listRel:receiptAmount>/*),
        receiptQuantityDiff: extractDecimalFromXML(response/**/<listRel:receiptQuantityDiff>/*),
        workCalendar: extractRecordRefFromXML(response/**/<listRel:workCalendar>),
        taxIdNum: extractStringFromXML(response/**/<listRel:taxIdNum>/*),
        taxItem: extractRecordRefFromXML(response/**/<listRel:taxItem>),
        password: extractStringFromXML(response/**/<listRel:password>/*),
        password2: extractStringFromXML(response/**/<listRel:password2>/*),
        defaultTaxReg: extractRecordRefFromXML(response/**/<listRel:defaultTaxReg>),
        predictedDays: extractIntegerFromXML(response/**/<listRel:predictedDays>),
        predConfidence: extractDecimalFromXML(response/**/<listRel:predConfidence>/*)
    };

    CustomFieldList|error customFields = extractCustomFiledListFromXML(response/**/<listRel:customFieldList>/*);
    if (customFields is CustomFieldList) {
        vendor.customFieldList = customFields;
    }

    boolean|error value = extractBooleanValueFromXMLOrText(response/**/<listRel:isInactive>/*);
    if (value is boolean) {
        vendor.isInactive = value;
    }
    
    value = extractBooleanValueFromXMLOrText(response/**/<listRel:requirePwdChange>/*);
    if (value is boolean) {
        vendor.requirePwdChange = value;
    }

    value = extractBooleanValueFromXMLOrText(response/**/<listRel:eligibleForCommission>/*);
    if (value is boolean) {
        vendor.eligibleForCommission = value;
    }

    value = extractBooleanValueFromXMLOrText(response/**/<listRel:emailTransactions>/*);
    if (value is boolean) {
        vendor.emailTransactions = value;
    }

    value = extractBooleanValueFromXMLOrText(response/**/<listRel:printTransactions>/*);
    if (value is boolean) {
        vendor.printTransactions = value;
    }

    value = extractBooleanValueFromXMLOrText(response/**/<listRel:faxTransactions>/*);
    if (value is boolean) {
        vendor.faxTransactions = value;
    }

    value = extractBooleanValueFromXMLOrText(response/**/<listRel:giveAccess>/*);
    if (value is boolean) {
        vendor.giveAccess = value;
    }

    value = extractBooleanValueFromXMLOrText(response/**/<listRel:sendEmail>/*);
    if (value is boolean) {
        vendor.sendEmail = value;
    }

    value = extractBooleanValueFromXMLOrText(response/**/<listRel:billPay>/*);
    if (value is boolean) {
        vendor.billPay = value;
    }

    value = extractBooleanValueFromXMLOrText(response/**/<listRel:isAccountant>/*);
    if (value is boolean) {
        vendor.isAccountant = value;
    }
    value = extractBooleanValueFromXMLOrText(response/**/<listRel:is1099Eligible>/*);
    if (value is boolean) {
        vendor.is1099Eligible = value;
    }

    value = extractBooleanValueFromXMLOrText(response/**/<listRel:isJobResourceVend>/*);
    if (value is boolean) {
        vendor.isJobResourceVend = value;
    }

    return vendor;
}

isolated function getVendorSearchRequestBody(SearchElement[] searchElements) returns string {
    return string `<soapenv:Body> <urn:search xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"> 
    <urn:searchRecord xsi:type="listRel:VendorSearch" 
    xmlns:listRel="urn:relationships_2020_2.lists.webservices.netsuite.com">
    <basic xsi:type="ns1:VendorSearchBasic" 
    xmlns:ns1="urn:common_2020_2.platform.webservices.netsuite.com">${getSearchElement(searchElements)}</basic>
    </urn:searchRecord></urn:search></soapenv:Body></soapenv:Envelope>`;
}

isolated function buildVendorSearchPayload(ConnectionConfig config, SearchElement[] searchElement) returns xml|error {
    string requestHeader = check buildXMLPayloadHeader(config);
    string requestBody = getVendorSearchRequestBody(searchElement);
    return check getSoapPayload(requestHeader, requestBody);
}

isolated function getVendorSearchResult(http:Response response, http:Client httpClient, ConnectionConfig config)
                                        returns @tainted stream<Vendor, error?>|error {
    SearchResultStatus resultStatus = check getXMLRecordListFromSearchResult(response);
    VendorStream objectInstance = check new (httpClient, resultStatus, config);
    stream<Vendor, error?> finalStream = new (objectInstance);
    return finalStream;
}

isolated function getVendorsNextPageResult(http:Response response) returns @tainted record {| Vendor[] vendors;
                                           SearchResultStatus status; |}|error {
    SearchResultStatus resultStatus = check getXMLRecordListFromSearchResult(response);
    return {vendors: check getVendorsFromSearchResults(resultStatus.recordList), status: resultStatus};
}

isolated function getVendorsFromSearchResults(xml vendorData) returns Vendor[]|error {
    int size = vendorData.length();
    Vendor[] vendors = [];
    foreach int i in 0 ..< size {
        xml recordItem = 'xml:get(vendorData, i);
        vendors.push(check mapVendorRecord(recordItem));
    }
    return vendors;
}
