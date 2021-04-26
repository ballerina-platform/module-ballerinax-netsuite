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
import ballerina/lang.'xml as xmlLib;
import ballerina/regex;
import ballerina/xmldata;

isolated function getCreateResponse(http:Response response) returns @tainted RecordAddResponse|error {
    xml formattedPayload = check formatPayload(response);
    if (response.statusCode == http:STATUS_OK) { 
        string|error statusDetail = formattedPayload/**/<statusDetail>.'type;
        boolean|error isAfterSubmitFailed =  extractBooleanValueFromXMLOrText(formattedPayload/**/<afterSubmitFailed>/*);
        if(statusDetail is string) {
            if(statusDetail == "ERROR" && isAfterSubmitFailed is error) {
                fail error((formattedPayload/**/<message>/*).toString());
            }
        } 
        if(isAfterSubmitFailed is boolean) {
            xml output  = formattedPayload/**/<status>; 
            boolean isSuccess = check extractBooleanValueFromXMLOrText(output.isSuccess);
            if(isSuccess == true && isAfterSubmitFailed == false ) { 
                return  prepareResponseAfterSubmitPassed(formattedPayload);
            } else if(isSuccess == false && isAfterSubmitFailed == true) {
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
 
 function formatGetAllResponse(http:Response response) returns @tainted json[]|error {
    xml xmlValure = check formatPayload(response);
    if (response.statusCode == http:STATUS_OK) {
        xml output  = xmlValure/**/<status>;
        boolean isSuccess = check extractBooleanValueFromXMLOrText(output.isSuccess);
        if(isSuccess == true) {
            xml:Element records = <xml:Element> xmlValure/**/<recordList>;
            xml baseRef  = xmlLib:getChildren(records);
            return categorizeGetALLResponse(baseRef);
        } else {
            json errorMessage= check xmldata:toJson(xmlValure/**/<platformCore_statusDetail>/*);
            fail error(errorMessage.toString());
        }    
    } else {
        fail error(xmlValure.toString());
    }
}

function categorizeGetALLResponse(xml baseRef) returns @tainted json[] {
    json[] recordList = [];
    xmlLib:forEach(baseRef, function(xml platformCoreRecord) {
        string|error count =  platformCoreRecord.xsi_type;
        if(count is string ) {
            match count {
                "listAcct:Currency" => {
                    xml recordItems = checkpanic replaceRegexInXML(platformCoreRecord, LIST_ACCT_WITH_COLON);
                    json|error  afterSubmissionResponse = xmldata:toJson(recordItems/*);
                    if(afterSubmissionResponse is json) {
                        recordList.push(afterSubmissionResponse);
                    }
                }
                "listAcct:budgetCategory" => {
                    xml recordItems = checkpanic replaceRegexInXML(platformCoreRecord, LIST_ACCT_WITH_COLON);
                    json|error  afterSubmissionResponse = xmldata:toJson(recordItems/*);
                    if(afterSubmissionResponse is json) {
                        recordList.push(afterSubmissionResponse);
                    }  
                }
                "listMkt:campaignAudience" => {
                    xml recordItems = checkpanic replaceRegexInXML(platformCoreRecord, LIST_MRK_WITH_COLON);
                    json|error  afterSubmissionResponse = xmldata:toJson(recordItems/*);
                    if(afterSubmissionResponse is json) {
                        recordList.push(afterSubmissionResponse);
                    }  
                }
                "listAcct:taxAcct" => {
                    xml recordItems = checkpanic replaceRegexInXML(platformCoreRecord, LIST_ACCT_WITH_COLON);
                    json|error  afterSubmissionResponse = xmldata:toJson(recordItems/*);
                    if(afterSubmissionResponse is json) {
                        recordList.push(afterSubmissionResponse);
                    }  
                }
                "listRel:state" => {
                    xml recordItems = checkpanic replaceRegexInXML(platformCoreRecord, LIST_REL_WITH_COLON);
                    json|error  afterSubmissionResponse = xmldata:toJson(recordItems/*);
                    if(afterSubmissionResponse is json) {
                        recordList.push(afterSubmissionResponse);
                    }  
                }
            }
            
        }
    });
    return recordList;
}

isolated function replaceRegexInXML(xml value, string regex, string replacement = EMPTY_STRING) returns xml|error {
    string formattedXMLResponse = regex:replaceAll(value.toString(), regex, replacement);
    return check xmlLib:fromString(formattedXMLResponse);
} 

isolated function formatPayload(http:Response response) returns @tainted xml|error {
    xml xmlValure  = check response.getXmlPayload();
    string formattedXMLResponse = regex:replaceAll(xmlValure.toString(), SOAP_ENV, SOAP_ENV_);
    formattedXMLResponse = regex:replaceAll(formattedXMLResponse, XSI, XSI_);
    formattedXMLResponse = regex:replaceAll(formattedXMLResponse, PLATFORM_CORE, EMPTY_STRING);
    formattedXMLResponse = regex:replaceAll(formattedXMLResponse, PLATFORM_MSGS, PLATFORM_MSGS_);
    formattedXMLResponse = regex:replaceAll(formattedXMLResponse, MESSAGES_NS, EMPTY_STRING);
    formattedXMLResponse = regex:replaceAll(formattedXMLResponse, CORE_NS, EMPTY_STRING);
    formattedXMLResponse = regex:replaceAll(formattedXMLResponse, XSI_NS, EMPTY_STRING);
    return check xmlLib:fromString(formattedXMLResponse);
}

function getSavedSearchResponse(http:Response response) returns @tainted json[]|error {
    xml formattedPayload = check formatPayload(response);
    if (response.statusCode == http:STATUS_OK) {
        xml output  = formattedPayload/**/<status>;
        boolean isSuccess = check extractBooleanValueFromXMLOrText(output.isSuccess);
        if(isSuccess == true) {
            xml:Element records = <xml:Element> formattedPayload/**/<recordRefList>;
            xml recordElements  = xmlLib:getChildren(records);
            json[] recordList = [];
            xmlLib:forEach(recordElements, function(xml platformCoreRecord) { 
                string|error count =  platformCoreRecord.xsi_type;
                if(count is string ) {
                    match count {
                        "CustomizationRef" => {
                            xml recordItems = checkpanic replaceRegexInXML(platformCoreRecord, LIST_ACCT_WITH_COLON);
                            json|error  afterSubmissionResponse = xmldata:toJson(recordItems/*);
                            if(afterSubmissionResponse is json) {
                                recordList.push(afterSubmissionResponse);
                            }
                        }
                    }
                }
            });          
            return recordList;
        } else {
            json errorMessage= check xmldata:toJson(formattedPayload/**/<statusDetail>/*);
            fail error(errorMessage.toString());
        }    
    } else {
        fail error(formattedPayload.toString());
    }
}

isolated function getXMLRecordListFromSearchResult(http:Response response) returns @tainted xml|error {
    xml xmlValue = check formatPayload(response);
    if (response.statusCode == http:STATUS_OK) {
        xml output  = xmlValue/**/<status>;
        boolean isSuccess = check extractBooleanValueFromXMLOrText(output.isSuccess);
        if(isSuccess == true) {
            xml:Element records = <xml:Element> xmlValue/**/<recordList>;
            xml baseRef  = xmlLib:getChildren(records); 
            if(baseRef.length() == 0) {
                fail error(NO_RECORD_FOUND);
            }    
            return baseRef;
        } else {
            json errorMessage= check xmldata:toJson(xmlValue/**/<statusDetail>);
            errorMessage= check xmldata:toJson(xmlValue/**/<soapenv_Fault>/<faultstring>);
            fail error(errorMessage.toString());
        }    
    } else {
        fail error(xmlValue.toString());
    }
}
