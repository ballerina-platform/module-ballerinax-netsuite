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
import ballerina/lang.'xml;
import ballerina/lang.'int;
import ballerina/regex;
import ballerina/xmldata;

xmlns "urn:core_2020_2.platform.webservices.netsuite.com" as platformCore;

isolated function getResponseCreationOp(http:Response response) returns @tainted RecordAddResponse|error {
    xml formattedPayload = check formatPayload(response);
    if (response.statusCode == http:STATUS_OK) { 
        string|error statusDetail = formattedPayload/**/<statusDetail>.'type;
        boolean|error isAfterSubmitFailed =  extractBooleanValueFromXMLOrText(formattedPayload/**/<afterSubmitFailed>/*);
        if(statusDetail is string) {
            if(statusDetail == ERROR && isAfterSubmitFailed is error) {
                fail error((formattedPayload/**/<message>/*).toString());
            }
        } 
        if(isAfterSubmitFailed is boolean) {
            xml output  = formattedPayload/**/<status>; 
            boolean isSuccess = check extractBooleanValueFromXMLOrText(output.isSuccess);
            if(isSuccess == true && <boolean>isAfterSubmitFailed == false ) { 
                return  prepareResponseAfterSubmitPassed(formattedPayload);
            } else if(isSuccess == false && <boolean>isAfterSubmitFailed == true) {
                return prepareResponseAfterSubmitFailed(formattedPayload);
            }else {
                xml errorMessage= formattedPayload/**/<statusDetail>/*;
                fail error(errorMessage.toString());
            }
        } else {
            fail error((formattedPayload/**/<message>/*).toString());
        }   
    } else {
        fail error(formattedPayload.toString());
    }
}

isolated function prepareResponseAfterSubmitFailed(xml formattedPayload) returns RecordAddResponse|error {
    xml baseRef  = formattedPayload/**/<baseRef>;
    RecordAddResponse instanceCreationResponse = {
        isSuccess: false,
        afterSubmitFailed: true,
        internalId: check baseRef.internalId,
        recordType: check baseRef.'type,
        warning: (formattedPayload/**/<statusDetail>/<message>/*).toString()
    };
    return instanceCreationResponse;
}

isolated function prepareResponseAfterSubmitPassed(xml formattedPayload) returns RecordAddResponse|error {
    xml baseRef  = formattedPayload/**/<baseRef>;
    RecordAddResponse instanceCreationResponse = {
        isSuccess: true,
        afterSubmitFailed: false,
        internalId: check baseRef.internalId,
        recordType: check baseRef.'type,
        warning: (formattedPayload/**/<statusDetail>/<message>/*).toString()
    };
    return instanceCreationResponse;
}

isolated function getDeleteResponse(http:Response response) returns @tainted RecordDeletionResponse|error {
    xml formattedPayload = check formatPayload(response);
    if (response.statusCode == http:STATUS_OK) {
        xml output  = formattedPayload/**/<status>;
        boolean isSuccess = check extractBooleanValueFromXMLOrText(output.isSuccess);
        if(isSuccess == true) {
            xml baseRef  = formattedPayload/**/<baseRef>;
            RecordDeletionResponse deleteResponse = {
                isSuccess: true,
                internalId: check baseRef.internalId,
                recordType: check baseRef.'type
            };
            return deleteResponse;
        } else {
            json errorMessage= check xmldata:toJson(formattedPayload/**/<statusDetail>/*);
            fail error(errorMessage.toString());
        }    
    } else {
        fail error(formattedPayload.toString());
    }
}

isolated function getUpdateResponse(http:Response response) returns @tainted RecordUpdateResponse|error {
    xml xmlValure = check formatPayload(response);
    if (response.statusCode == http:STATUS_OK) {
        xml output  = xmlValure/**/<status>;
        boolean isSuccess = check extractBooleanValueFromXMLOrText(output.isSuccess);
        if(isSuccess == true) {
            xml baseRef  = xmlValure/**/<baseRef>;
            RecordUpdateResponse updateResponse = {
                isSuccess: true,
                internalId: check baseRef.internalId,
                recordType: check baseRef.'type
            };
            return updateResponse;
        } else {
            json errorMessage= check xmldata:toJson(xmlValure/**/<statusDetail>);
            fail error(errorMessage.toString());
        }    
    } else {
        fail error(xmlValure.toString());
    }
}
 
isolated function formatGetAllResponse(http:Response response) returns @tainted anydata|error {
    xml xmlValure = check formatPayload(response);
    if (response.statusCode == http:STATUS_OK) {
        xml output  = xmlValure/**/<status>;
        boolean isSuccess = check extractBooleanValueFromXMLOrText(output.isSuccess);
        if(isSuccess == true) {
            xml:Element records = <xml:Element> xmlValure/**/<recordList>;
            xml baseRef  = 'xml:getChildren(records);
            return categorizeGetALLResponse(baseRef);
        } else {
            json errorMessage= check xmldata:toJson(xmlValure/**/<platformCore_statusDetail>/*);
            fail error(errorMessage.toString());
        }    
    } else {
        fail error(xmlValure.toString());
    }
}

isolated function categorizeGetALLResponse(xml baseRef) returns @tainted Currency[]|error {
    Currency[] recordLists = [];
    foreach xml platformCoreRecord in baseRef {
        string|error xsiType =  platformCoreRecord.xsi_type;
        if(xsiType is string ) {
            match xsiType {
                CURRENCY_XSI_TYPE => {
                    recordLists.push(check mapCurrencyRecord(platformCoreRecord));
                }  
            }  
        }
    }
    return recordLists;
}

isolated function replaceRegexInXML(xml value, string regex, string replacement = EMPTY_STRING) returns xml|error {
    string formattedXMLResponse = regex:replaceAll(value.toString(), regex, replacement);
    return check 'xml:fromString(formattedXMLResponse);
} 

isolated function formatPayload(http:Response response) returns @tainted xml|error {
    xml elements  = check response.getXmlPayload();
    string formattedXMLResponse = regex:replaceAll(elements.toString(), SOAP_ENV, SOAP_ENV_);
    formattedXMLResponse = regex:replaceAll(formattedXMLResponse, XSI, XSI_);
    formattedXMLResponse = regex:replaceAll(formattedXMLResponse, PLATFORM_CORE, EMPTY_STRING);
    formattedXMLResponse = regex:replaceAll(formattedXMLResponse, PLATFORM_MSGS, PLATFORM_MSGS_);
    formattedXMLResponse = regex:replaceAll(formattedXMLResponse, MESSAGES_NS, EMPTY_STRING);
    formattedXMLResponse = regex:replaceAll(formattedXMLResponse, CORE_NS, EMPTY_STRING);
    formattedXMLResponse = regex:replaceAll(formattedXMLResponse, XSI_NS, EMPTY_STRING);
    return check 'xml:fromString(formattedXMLResponse);
}

isolated function getSavedSearchIDsResponse(http:Response response) returns @tainted SavedSearchResponse|error {
    xml payload = check response.getXmlPayload();
    if (response.statusCode == http:STATUS_OK) {
        string isSuccessInText = check payload/**/<platformCore:status>.isSuccess;
        boolean isSuccess = check extractBooleanValueFromXMLOrText(isSuccessInText);
        if (isSuccess) {
            int totalRecords  = check 'int:fromString((payload/**/<platformCore:totalRecords>/*).toString());
            xml recordList = payload/**/<platformCore:recordRefList>/*;
            SavedSearchReference[] searchReferences = []; 
            foreach int i in 0 ..< totalRecords {
                xml recordItem = 'xml:get(recordList, i);
                searchReferences.push(mapSaveSearchRecords(recordItem));  
            }
            return {
                status: isSuccess,
                totalReferences: totalRecords,
                recordRefList: searchReferences
            };
        } else {
            json errorMessage= check xmldata:toJson(payload/**/<statusDetail>/*);
            fail error(errorMessage.toString());
        }
    } else {
        fail error(payload.toString());
    }
}

isolated function mapSaveSearchRecords(xml recordElement) returns SavedSearchReference {
    return {
        internalId: extractStringFromXML(recordElement.internalId),
        scriptId: extractStringFromXML(recordElement.scriptId),
        name: extractStringFromXML(recordElement/**/<platformCore:name>/*)
    };
}

isolated function getServerTimeResponse(http:Response response) returns @tainted string|error {
    xml payload = check response.getXmlPayload();
    if (response.statusCode == http:STATUS_OK) {
        string isSuccessInText = check payload/**/<platformCore:status>.isSuccess;
        boolean isSuccess = check extractBooleanValueFromXMLOrText(isSuccessInText);
        if (isSuccess) {
            xml serverTimeInText =  payload/**/<platformCore:serverTime>/*;  
            return serverTimeInText.toString();
        } else {
            json errorMessage= check xmldata:toJson(payload/**/<statusDetail>/*);
            fail error(errorMessage.toString());
        }
    } else {
        fail error(payload.toString());
    }
}

isolated function getXMLRecordListFromSearchResult(http:Response response) returns @tainted SearchResultStatus|error {
    xml payload = check formatPayload(response);
    if (response.statusCode == http:STATUS_OK) {
        xml output  = payload/**/<status>;
        boolean isSuccess = check extractBooleanValueFromXMLOrText(output.isSuccess); 
        if(isSuccess == true) {
            int pageIndex = let var value = 'int:fromString((payload/**/<pageIndex>/*).toString()) in value is int ? value : 0; 
            int totalPages = check 'int:fromString((payload/**/<totalPages>/*).toString());
            int totalRecords = check 'int:fromString((payload/**/<totalRecords>/*).toString());
            string searchId = (payload/**/<searchId>/*).toString();
            xml:Element records = <xml:Element> payload/**/<recordList>;
            xml children  = 'xml:getChildren(records); 
            if(children.length() == 0) {
                fail error(NO_RECORD_FOUND);
            }    
            SearchResultStatus searchResultStatus = {
                recordList: children,
                pageIndex: pageIndex,
                totalPages: totalPages,
                searchId: searchId
            };
            return searchResultStatus;
        } else {
            json errorMessage= check xmldata:toJson(payload/**/<statusDetail>);
            errorMessage= check xmldata:toJson(payload/**/<soapenv_Fault>/<faultstring>);
            fail error(errorMessage.toString());
        }    
    } else {
        fail error(payload.toString());
    }
}

isolated function getXMLRecordListFromSavedSearchResult(http:Response response) returns @tainted SavedSearchResult|error {
    xml payload = check response.getXmlPayload();
    if (response.statusCode == http:STATUS_OK) {
        xml output  = payload/**/<platformCore:status>;
        boolean isSuccess = check extractBooleanValueFromXMLOrText(output.isSuccess); 
        if(isSuccess == true) {
            int pageIndex = let var value = 'int:fromString((payload/**/<platformCore:pageIndex>/*).toString()) in value is int ? value : 0; 
            int totalPages = check 'int:fromString((payload/**/<platformCore:totalPages>/*).toString());
            int totalRecords = check 'int:fromString((payload/**/<platformCore:totalRecords>/*).toString());
            string searchId = (payload/**/<platformCore:searchId>/*).toString();
            xml:Element records = <xml:Element> payload/**/<platformCore:searchRowList>;
            xml children  = 'xml:getChildren(records); 
            if(children.length() == 0) {
                fail error(NO_RECORD_FOUND);
            } 
            json searchRows = check xmldata:toJson(payload/**/<platformCore:searchRowList>/*, {preserveNamespaces: false});
            return {
                recordList: <json[]>searchRows,
                pageIndex: pageIndex,
                totalPages: totalPages,
                searchId: searchId
            };
        } else {
            json errorMessage= check xmldata:toJson(payload/**/<platformCore:statusDetail>/*, {preserveNamespaces: false});
            fail error(errorMessage.toString());
        }    
    } else {
        fail error(payload.toString());
    }
}
