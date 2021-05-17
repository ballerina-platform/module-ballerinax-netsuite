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

isolated function mapContactRecordFields(Contact contact) returns string {
    string finalResult = EMPTY_STRING;
    map<anydata>|error contactMap = contact.cloneWithType(MapAnyData);
    if (contactMap is map<anydata>) {
        string[] keys = contactMap.keys();
        int position = 0;
        foreach var item in contact {
            if (item is string|boolean) {
                finalResult += setSimpleType(keys[position], item, LIST_REL);
            } else if (item is RecordRef) {
                finalResult += getXMLRecordRef(<RecordRef>item);
            } else if (item is Category[]) {
                string categoryList = EMPTY_STRING;
                foreach RecordRef category in item {
                    categoryList += getXMLRecordRef(category);
                }
                finalResult += string `<listRel:categoryList>${categoryList}</listRel:categoryList>`;
            } else if (item is GlobalSubscriptionStatusType) {
                finalResult += string `<listRel:globalSubscriptionStatus>${item.toString()}
                </listRel:globalSubscriptionStatus>`;
            } else if (item is ContactAddressBook[]) {
                string addressList = prepareAddressList(item);
                finalResult += string`<listRel:addressbookList>${addressList}</listRel:addressbookList>`;
            } 
            position += 1;
        }
    }
    return finalResult;
}

isolated function wrapContactElementsToBeCreatedWithParentElement(string subElements) returns string{
    return string `<urn:record xsi:type="listRel:Contact" 
        xmlns:listRel="urn:relationships_2020_2.lists.webservices.netsuite.com">
            ${subElements}
         </urn:record>`;
}

isolated function wrapContactElementsToBeUpdatedWithParentElement(string subElements, string internalId) returns string{
    return string `<urn:record xsi:type="listRel:Contact" internalId="${internalId}"
        xmlns:listRel="urn:relationships_2020_2.lists.webservices.netsuite.com">
            ${subElements}
         </urn:record>`;
}

isolated function prepareAddressList(ContactAddressBook[] addressBooks) returns string {
    string contactAddressBook= EMPTY_STRING;
    foreach ContactAddressBook addressBookItem in addressBooks {
        map<anydata>|error AddressItemMap = addressBookItem.cloneWithType(MapAnyData);
        int mainPosition = 0;
        string addressList = EMPTY_STRING;
        if(AddressItemMap is map<anydata>) {
            string[] AddressItemKeys = AddressItemMap.keys();
            foreach var item in addressBookItem {
                if(item is string|boolean) {
                    addressList += string `<${AddressItemKeys[mainPosition]}>${item.toString()}
                    </${AddressItemKeys[mainPosition]}>`;
                } else if(item is Address[]) {
                    addressList = getAddressListInXML(item);
                }
                mainPosition += 1;
            }
        }
        contactAddressBook += string`<addressbook>${addressList}</addressbook>`;
    }
    return contactAddressBook;
}

isolated function getAddressListInXML(Address[] addresses) returns string {
    string addressList = EMPTY_STRING;
    foreach Address addressItem in addresses {
        map<anydata>|error AddressMap = addressItem.cloneWithType(MapAnyData);
        int position = 0;
        string addressBook =EMPTY_STRING;
        foreach var element in addressItem {
            if (AddressMap is map<anydata>) {
                string[] keys = AddressMap.keys();
                addressBook += string `<${keys[position]}>${element.toString()}</${keys[position]}>`;
            }
            position += 1;  
        }
        addressList += string `<addressbookAddress>${addressBook}</addressbookAddress>`;  
    }
    return addressList;
}

isolated function getContactResult(http:Response response) returns @tainted Contact|error{
    xml formattedResponse = check formatPayload(response);
    if (response.statusCode == http:STATUS_OK) { 
        xml output  = formattedResponse/**/<status>;
        boolean isSuccess = check extractBooleanValueFromXMLOrText(output.isSuccess);
        if(isSuccess) {
            return mapContactRecord(formattedResponse);
        } else {
            fail error(NO_RECORD_CHECK);
        }
    } else {
        fail error(formattedResponse.toString());
    }  
}

isolated function mapContactRecord(xml response) returns Contact|error {
    xmlns "urn:relationships_2020_2.lists.webservices.netsuite.com" as listRel;
    Contact contact  = {
        customForm: extractRecordRefFromXML(response/**/<listRel:customForm>),
        entityId: extractStringFromXML(response/**/<listRel:entityId>/*),
        contactSource: extractRecordRefFromXML(response/**/<listRel:contactSource>),
        company: extractRecordRefFromXML(response/**/<listRel:company>),
        salutation: extractStringFromXML(response/**/<listRel:salutation>/*),
        firstName : extractStringFromXML(response/**/<listRel:firstName>/*),
        middleName: extractStringFromXML(response/**/<listRel:middleName>/*),
        lastName: extractStringFromXML(response/**/<listRel:lastName>/*),
        title: extractStringFromXML(response/**/<listRel:title>/*),
        phone: extractStringFromXML(response/**/<listRel:phone>/*),
        fax: extractStringFromXML(response/**/<listRel:fax>/*),
        email: extractStringFromXML(response/**/<listRel:email>/*),
        defaultAddress: extractStringFromXML(response/**/<listRel:defaultAddress>/*),
        subsidiary: extractRecordRefFromXML(response/**/<listRel:subsidiary>),
        altEmail: extractStringFromXML(response/**/<listRel:altEmail>/*),
        officePhone: extractStringFromXML(response/**/<listRel:officePhone>/*),
        homePhone: extractStringFromXML(response/**/<listRel:homePhone>/*),
        mobilePhone: extractStringFromXML(response/**/<listRel:mobilePhone>/*),
        supervisor: extractRecordRefFromXML(response/**/<listRel:supervisor>),
        supervisorPhone: extractStringFromXML(response/**/<listRel:supervisorPhone>/*),
        assistant: extractRecordRefFromXML(response/**/<listRel:assistant>),
        assistantPhone: extractStringFromXML(response/**/<listRel:assistantPhone>/*),
        comments: extractStringFromXML(response/**/<listRel:comments>/*),
        image: extractStringFromXML(response/**/<listRel:image>/*),
        dateCreated: extractStringFromXML(response/**/<listRel:dateCreated>/*),
        lastModifiedDate: extractStringFromXML(response/**/<listRel:lastModifiedDate>/*)
    };
    boolean|error values = extractBooleanValueFromXMLOrText(response/**/<listRel:isPrivate>/*);
    if(values is boolean) {
        contact.isPrivate = values;
    }
    values = extractBooleanValueFromXMLOrText(response/**/<listRel:isInactive>/*);
    if(values is boolean) {
        contact.isInactive = values;
    }
    values = extractBooleanValueFromXMLOrText(response/**/<listRel:billPay>/*);
    if(values is boolean) {
        contact.billPay = values;
    }
    return contact;
}
