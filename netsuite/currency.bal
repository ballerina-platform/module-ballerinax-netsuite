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

isolated function mapCurrencyRecordFields(Currency currency) returns string {
    string finalResult = EMPTY_STRING;
    map<anydata>|error currencyMap = currency.cloneWithType(MapAnyData);
    if (currencyMap is map<anydata>) {
        string[] keys = currencyMap.keys();
        int position = 0;
        foreach var item in currency {
            if (item is string|boolean|decimal|int) {
                finalResult += setSimpleType(keys[position], item, LIST_ACCT);
            } else if (item is RecordRef) {
                finalResult += getXMLRecordRef(<RecordRef>item);
            }
            position += 1;
        }
    }
    return finalResult;
}

isolated function mapNewCurrencyRecordFields(NewCurrency currency) returns string {
    string finalResult = EMPTY_STRING;
    map<anydata>|error currencyMap = currency.cloneWithType(MapAnyData);
    if (currencyMap is map<anydata>) {
        string[] keys = currencyMap.keys();
        int position = 0;
        foreach var item in currency {
            if (item is string|boolean|decimal|int) {
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

isolated function wrapCurrencyElements(string subElements) returns string{
    return string `<urn:record xsi:type="listAcct:Currency" 
        xmlns:listAcct="urn:accounting_2020_2.lists.webservices.netsuite.com">
            ${subElements}
         </urn:record>`;
}

isolated function wrapCurrencyElementsToBeUpdatedWithParentElement(string subElements, string internalId) returns 
                                                                    string {
    return string `<urn:record xsi:type="listAcct:Currency" internalId="${internalId}"
        xmlns:listAcct="urn:accounting_2020_2.lists.webservices.netsuite.com">
            ${subElements}
         </urn:record>`;
}

isolated function mapCurrencyRecord(xml response) returns Currency|error {
    xmlns "urn:accounting_2020_2.lists.webservices.netsuite.com" as listAcct;
    Currency currency  = {
        internalId: extractRecordInternalIdFromXMLAttribute(response/**/<'record>), 
        name: extractStringFromXML(response/**/<listAcct:name>/*),
        symbol: extractStringFromXML(response/**/<listAcct:symbol>/*),
        currencyPrecision: extractStringFromXML(response/**/<listAcct:currencyPrecision>/*)
    };
    boolean|error value = extractBooleanValueFromXMLOrText(response/**/<listAcct:isInactive>/*);
    if(value is boolean) {
        currency.isInactive = value;
    }
    value = extractBooleanValueFromXMLOrText(response/**/<listAcct:isBaseCurrency>/*);
    if(value is boolean) {
        currency.isBaseCurrency = value;
    }
    return currency;
}

isolated function getCurrencyResult(http:Response response) returns @tainted Currency|error{
    xml xmlValue = check formatPayload(response);
    if (response.statusCode == http:STATUS_OK) { 
        xml output  = xmlValue/**/<status>;
        boolean isSuccess = check extractBooleanValueFromXMLOrText(output.isSuccess);
        if(isSuccess) {
            return mapCurrencyRecord(xmlValue);
        } else {
            fail error(NO_RECORD_CHECK);
        }
    } else {
        fail error(xmlValue.toString());
    }
}
