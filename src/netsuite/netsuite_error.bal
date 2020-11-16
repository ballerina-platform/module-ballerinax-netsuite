// Copyright (c) 2020 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

# Record type to hold the details of an error.
#
# + statusCode - The HTTP status code
# + errorCode - The standard NetSuite error code
public type Detail record {
    int statusCode?;
    string errorCode?;
};

# Represents the NetSuite error type with details.
public type Error distinct error<Detail>;

isolated function createErrorFromPayload(map<json> errorPayload) returns Error {

    string errMsg = <string> errorPayload["title"];
    int statusCode = <int> errorPayload["status"];
    string errorCode ="";
    foreach var item in errorPayload{
        if(item is json[]){
            json[] errorData = item;
            json errorCodeFull = errorData[0];
            map<json> erCode=<map<json>> errorCodeFull;
            errorCode = <string>erCode["o:errorCode"];
        }
    }
    return Error(errMsg, statusCode = statusCode, errorCode = errorCode);
}
