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

isolated function mapSalesOrderRecordFields(SalesOrder salesOrder) returns string {
    string finalResult = EMPTY_STRING;
    map<anydata>|error salesOrderMap = salesOrder.cloneWithType(MapAnyData);
    if (salesOrderMap is map<anydata>) {
        string[] keys = salesOrderMap.keys();
        int position = 0;
        foreach var item in salesOrder {
            if (item is string|boolean|decimal|int|SalesOrderStatus) {
                finalResult += setSimpleType(keys[position], item, TRAN_SALES);
            } else if (item is RecordRef) {
                finalResult += getXMLRecordRef(<RecordRef>item);
            } else if (item is Address) {
                string addressBook = prepareSalesOrderXMLAddressElement(item);
                finalResult += string `<billingAddress>${addressBook}</billingAddress>`;        
            } else if (item is Item[]) {
                string itemList = prepareSalesOrderItemListElement(item);
                finalResult +=string `<itemList>${itemList}</itemList>`;
            }       
            position += 1;
        }
    }
    return finalResult;
}

isolated function prepareSalesOrderXMLAddressElement(Address address) returns string {
    map<anydata>|error AddressMap = address.cloneWithType(MapAnyData);
    int index = 0;
    string addressBook = EMPTY_STRING;
    foreach var element in address {
        if (AddressMap is map<anydata>) {
            string[] addressKeys = AddressMap.keys();
            addressBook += string `<${addressKeys[index]}>${element.toString()}</${addressKeys[index]}>`;
        }
        index += 1;  
    }
    return addressBook;
}

isolated function prepareSalesOrderItemListElement(Item[] items) returns string{
    string itemList = EMPTY_STRING;
    foreach Item nsItem in items {
        map<anydata>|error itemMap = nsItem.cloneWithType(MapAnyData);
        int itemPosition = 0;
        string itemValue =EMPTY_STRING;
        foreach var element in nsItem {
            if (itemMap is map<anydata>) {
                  string[] itemKeys = itemMap.keys();
                if(element is string|int|boolean|decimal) {
                    itemValue += string `<${itemKeys[itemPosition]}>${element.toString()}</${itemKeys[itemPosition]}>`;
                } else if (element is RecordRef){
                    itemValue += getXMLRecordRef(<RecordRef>element);
                }
            }
            itemPosition += 1;  
        }
        itemList += string `<item>${itemValue}</item>`;
    }
    return itemList;
}

isolated function wrapSalesOrderElementsToBeCreatedWithParentElement(string subElements) returns string{
    return string `<urn:record xsi:type="tranSales:SalesOrder" 
        xmlns:tranSales="urn:sales_2020_2.transactions.webservices.netsuite.com">
            ${subElements}
         </urn:record>`;
}

isolated function wrapSalesOrderElementsToBeUpdatedWithParentElement(string subElements, string internalId) returns string{
    return string `<urn:record xsi:type="tranSales:SalesOrder" internalId="${internalId}"
        xmlns:tranSales="urn:sales_2020_2.transactions.webservices.netsuite.com">
            ${subElements}
         </urn:record>`;
}

isolated function mapSalesOrderRecord(xml response) returns SalesOrder|error {
    xmlns "urn:sales_2020_2.transactions.webservices.netsuite.com" as tranSales;
    xmlns "urn:common_2020_2.platform.webservices.netsuite.com" as platformCommon;
    SalesOrder salesOrder = {
        internalId: extractRecordInternalIdFromXMLAttribute(response/**/<'record>),
        customForm: extractRecordRefFromXML(response/**/<tranSales:customForm>),
        entity: extractRecordRefFromXML(response/**/<tranSales:entity>),
        currency: extractRecordRefFromXML(response/**/<tranSales:currency>),
        drAccount: extractRecordRefFromXML(response/**/<tranSales:drAccount>),
        fxAccount: extractRecordRefFromXML(response/**/<tranSales:fxAccount>),
        tranId: extractStringFromXML(response/**/<tranSales:fxAccount>/<name>/*),
        orderStatus: extractStringFromXML(response/**/<tranSales:orderStatus>/*),
        tranDate: extractStringFromXML(response/**/<tranSales:tranDate>/*),
        nextBill: extractStringFromXML(response/**/<tranSales:nextBill>/*),
        totalCostEstimate: extractDecimalFromXML(response/**/<tranSales:totalCostEstimate>/*),
        currencyName: extractStringFromXML(response/**/<tranSales:currencyName>/*),
        email: extractStringFromXML(response/**/<tranSales:email>/*),
        shippingAddress: {
            country: extractStringFromXML(response/**/<platformCommon:country>/*),
            addressee: extractStringFromXML(response/**/<platformCommon:addressee>/*),
            addrText: extractStringFromXML(response/**/<platformCommon:addrText>/*)
        },
        shipDate: extractStringFromXML(response/**/<tranSales:shipDate>/*),
        total: extractDecimalFromXML(response/**/<tranSales:total>/*),
        balance:extractDecimalFromXML(response/**/<tranSales:balance>/*),
        subTotal:extractDecimalFromXML(response/**/<tranSales:subTotal>/*),
        subsidiary: extractRecordRefFromXML(response/**/<tranSales:subsidiary>),
        startDate: extractStringFromXML(response/**/<tranSales:startDate>/*),
        endDate: extractStringFromXML(response/**/<tranSales:endDate>/*)
    };
    return salesOrder;
}

isolated function getSalesOrderResult(http:Response response, RecordCoreType recordType) returns @tainted SalesOrder|error{
    xml xmlValue = check formatPayload(response);
    if (response.statusCode == http:STATUS_OK) { 
        xml output  = xmlValue/**/<status>;
        boolean isSuccess = check extractBooleanValueFromXMLOrText(output.isSuccess);
        if(isSuccess) {
            return mapSalesOrderRecord(xmlValue);
        } else {
            fail error("No any record found");
        }
    } else {
        fail error("No any record found");
    }
}
