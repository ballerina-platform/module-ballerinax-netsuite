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

import ballerina/http;
import ballerina/log;
import ballerina/oauth2;

# The NetSuite Client object that allows ballerina to connector with NetSuite Account to execute CRUD and search
# operations to perform business processing on NetSuite records and to navigate dynamically between records.
public client class Client {
    private http:Client netsuiteClient;

    # Gets invoked to initialize the `client`.
    #
    # + netsuiteConfig - The configurations to be used when initializing the `client`
    public function init(Configuration netsuiteConfig) {
        oauth2:OutboundOAuth2Provider oauth2Provider = new (netsuiteConfig.oauth2Config);
        http:BearerAuthHandler bearerHandler = new (oauth2Provider);

        http:ClientConfiguration httpClientConfig = {
            auth: {
                authHandler: bearerHandler
            },
            secureSocket: netsuiteConfig?.secureSocketConfig,
            timeoutInMillis: netsuiteConfig.timeoutInMillis,
            retryConfig: netsuiteConfig?.retryConfig,
            http1Settings: {
                keepAlive: http:KEEPALIVE_NEVER,
                proxy: netsuiteConfig?.proxy
            }
        };

        self.netsuiteClient = new(netsuiteConfig.baseUrl, httpClientConfig);
    }

    # Creates the NetSuite record and returns it's internal identifier.
    #
    # + value - The value that needs to be inserted as a NetSuite record
    # + customRecordPath - The optional parameter to indicate the resource path, if the record is a custom,
    #                      company-specific or not implemented yet. Eg: "/customrecord_path"
    # + return - The `netsuite:Error` if it is a failure or else the internal ID of created record
    public remote function create(@tainted WritableRecord value, string? customRecordPath = ()) returns
                                  @tainted string|Error {
        return createRecord(self.netsuiteClient, value, customRecordPath);
    }

    # Retrieves the NetSuite record for a given internal/external identifier. Relevant record is uniquely identified
    # by the record type and ID.
    #
    #
    # + id - The internal/external identifier
    # + targetType - The typedesc of targeted record type
    # + idType - The type of the provided record identifier, either INTERNAL or EXTERNAL
    # + customRecordPath - The optional parameter to indicate the resource path, if the record is a custom,
    #                      company-specific or not implemented yet. Eg: "/customrecord_path"
    # + return - The `netsuite:Error` if it is a failure or else the record
    public remote function get(string id, ReadableRecordType targetType, IdType idType = INTERNAL,
                               string? customRecordPath = ()) returns @tainted ReadableRecord|Error {
        return getRecord(self.netsuiteClient, id, targetType, idType, customRecordPath);
    }

    # Updates the NetSuite record with the given record or JSON and updates the passed-in existing record.
    #
    # + existingValue - The original NetSuite record
    # + newValue - The record or a part of record which needs to be replaced with
    # + customRecordPath - The optional parameter to indicate the resource path, if the record is a custom,
    #                      company-specific or not implemented yet. Eg: "/customrecord_path"
    # + return - The `netsuite:Error` if it is a failure or else the internal ID of updated record
    public remote function update(@tainted WritableRecord existingValue, WritableRecord|json newValue,
                                   string? customRecordPath = ()) returns @tainted string|Error {
        return updateRecord(self.netsuiteClient, existingValue, newValue, customRecordPath);
    }

    # Deletes the given record from NetSuite account. Local record values are not deleted.
    #
    # + value - The record that needs to be deleted from NetSuite
    # + customRecordPath - The optional parameter to indicate the resource path, if the record is a custom,
    #                      company-specific or not implemented yet. Eg: "/customrecord_path"
    # + return - The `netsuite:Error` if it is a failure or else `()`
    public remote function delete(WritableRecord value, string? customRecordPath = ()) returns @tainted Error? {
        return deleteRecord(self.netsuiteClient, value, customRecordPath);
    }

    # Creates the NetSuite record or updates an existing record using external ID. The relevant record is uniquely
    # identified by the record type and externalId. The passed-in value is also populated if the values is record type.
    #
    # + externalId - The external identifier
    # + targetType - The typedesc of targeted record
    # + value - The record or a part of a record, which needs to be created or updated
    # + customRecordPath - The optional parameter to indicate the resource path, if the record is a custom,
    #                      company-specific or not implemented yet. Eg: "/customrecord_path"
    # + return - The `netsuite:Error` if it is a failure or else the internal ID of created or updated record
    public remote function upsert(string externalId, WritableRecordType targetType, WritableRecord|json value,
                                   string? customRecordPath = ()) returns @tainted string|Error {
        return upsertRecord(self.netsuiteClient, targetType, externalId, value, customRecordPath);
    }

    # Retrieves the list of records ids. The list can be filtered with given filter string. Since paginated results are
    # returned as per the specified limit, make subsequent remote function invocations by changing the offset to obtain
    # total results.
    #
    # + targetType - The typedesc of targeted record
    # + filter - The condition to filter the list using operators. Each condition consists of a field name, an
    #            operator, and a value. Several conditions can be joined using the AND / OR logical operators
    #            Eg:"id BETWEEN_NOT[1,42]", "dateCreated ON_OR_AFTER1/1/2019 AND dateCreated BEFORE 1/1/2020"
    # + customRecordPath - The optional parameter to indicate the resource path, if the record is a custom,
    #                      company-specific or not implemented yet. Eg: "/customrecord_path"
    # + maxLimit - The limit used to specify the number of results on a single request
    # + offset - The offset used for selecting a specific starting point of a set of results
    # + return - The `netsuite:Error` if it is a failure or else a tuple with an array of string IDs and boolean
    #            to indicate the availability of more search results
    public remote function search(ReadableRecordType targetType,  string? filter = (), string?
                                  customRecordPath = (),  int maxLimit = 1000,  int offset = 0) returns
                                  @tainted [string[], boolean]|Error {
        return searchRecord(self.netsuiteClient, targetType, filter, customRecordPath, maxLimit, offset);
    }

    # Retrieves the nested records of the NetSuite record.
    #
    # + parent - The parent record of subrecord
    # + subRecordType - The typedesc of targeted record type
    # + customRecordPath - The optional parameter to indicate the resource path, if the record is a custom,
    #                      company-specific or not implemented yet. Eg: "/customrecord_path"
    # + return - The `netsuite:Error` if it is a failure or else the nested record
    public remote function getSubRecord(ReadableRecord parent, SubRecordType subRecordType,
                                         string? customRecordPath = ()) returns @tainted SubRecord|Error {
        string parentRecordName = check resolveRecordName(customRecordPath, typeof parent);
        string subRecordName = check getRecordName(subRecordType);
        string recordId = parent.id;
        if (recordId == "") {
            return Error("invalid internal ID: field cannot be empty");
        }

        string resourcePath = REST_RESOURCE + parentRecordName + "/" + recordId + "/" + subRecordName + EXPAND_SUB_RESOURCES;
        json payload = check getJsonPayload(self.netsuiteClient, resourcePath, subRecordName);
        var result =  constructRecord(subRecordType, payload);
        if (result is SubRecord) {
            return result;
        }
        if (result is WritableRecord|ReadableRecord) {
            panic Error("subrecord retrieval failed: illegal state error");
        }
        return Error("subrecord mapping failed", <error> result);
    }

    # Common action to execute all queries in a generic manner. This action can be use as an alternative for
    # unsupported operations. The metadata can be accessed via API docs
    # [https://system.netsuite.com/help/helpcenter/en_US/APIs/REST_API_Browser/record/v1/2020.1/index.html].
    #
    # + httpMethod - The respective HTTP method
    # + path - The resource path including path and query params eg: "/customer/{id}/!transform/vendor"
    # + requestBody - The union of custom record or JSON to be set as request body
    # + return - The `netsuite:Error` if it is a failure or else the response body. If the response status code is a
    #            204, headers will be returned as a JSON
    public remote function execute(HttpMethod httpMethod, string path, CustomRecord|json requestBody = ())
                                   returns @tainted json|Error {
        json jsonPayload;
        if (requestBody is CustomRecord) {
            json|error payload = requestBody.cloneWithType(json);
            if (payload is error) {
                return Error("Error while constructing request payload for execute operation", payload);
            }
            jsonPayload = <json> payload;
        } else {
            jsonPayload = requestBody;
        }

        http:Response|http:Payload|error result =  self.netsuiteClient->execute(httpMethod, REST_RESOURCE + path, jsonPayload);
        if (result is error) {
        	 return Error("execution failed", result);
        }

        http:Response response = <http:Response> result;
        if (response.statusCode == 204) {
            map<json> headers = {};
            foreach string key in response.getHeaderNames() {
                headers[key] = response.getHeader(<@untainted> key);
            }
            return headers;
        }
        return processJson(response);
    }
}

function createRecord(http:Client nsClient, @tainted WritableRecord recordValue, string? customRecordPath)
                      returns @tainted string|Error {
    string recordName = check resolveRecordName(customRecordPath, typeof recordValue);
    json|error payload = recordValue.cloneWithType(json);
    if (payload is error) {
        return Error("Error while constructing request payload for create operation", payload);
    }
    json jsonValue = <json> payload;
    http:Response|http:Payload|error result = nsClient->post(REST_RESOURCE + recordName, jsonValue);
    if (result is error) {
         return Error("record creation request failed", result);
    }

    http:Response response = <http:Response> result;
    if (response.statusCode == 204 && response.hasHeader(LOCATION_HEADER)) {
        return extractInternalId(response);
    }

    json|error responsePayload = response.getJsonPayload(); 
    if (responsePayload is error) {
        return Error("record creation failed", responsePayload);
    }
    return createErrorFromPayload(<map<json>> responsePayload,<json>responsePayload);
}

function getRecord(http:Client nsClient, string id, ReadableRecordType targetType, IdType idType,
                   string? customRecordPath) returns @tainted ReadableRecord|Error {
    string targetRecordName = check resolveRecordName(customRecordPath, targetType);
    if (id == "") {
        return Error("invalid internal ID: field cannot be empty");
    }

    string recordId = "/" + (idType is INTERNAL ? id : <string> EID + id);
    string resourcePath = REST_RESOURCE + targetRecordName + recordId + EXPAND_SUB_RESOURCES;
    json payload = check getJsonPayload(nsClient, resourcePath, targetRecordName);
    log:printDebug(function () returns string {
            return "Inbound JSON payload: " + payload.toString();
        });

    var result = constructRecord(targetType, payload);
    if (result is ReadableRecord) {
        return result;
    } else if (result is error) {
        return Error("record mapping failed", result);
    } else {
        panic Error("get operation failed: illegal state error");
    }
}

function updateRecord(http:Client nsClient, @tainted WritableRecord existingValue, WritableRecord|json newValue,
                      string? customRecordPath) returns @tainted string|Error {
    string recordName = check resolveRecordName(customRecordPath, typeof existingValue);
    string recordId = existingValue.id;
    if (recordId == "") {
        return Error("invalid internal ID: field cannot be empty");
    }

    json payload;
    if (newValue is WritableRecord) {
        json|error jsonValue = newValue.cloneWithType(json);
        if (jsonValue is error) {
            return Error("Error while constructing request payload for update operation", jsonValue);
        }
        payload = <json> jsonValue;
    } else {
        payload = newValue;
    }
    
    http:Response|http:Payload|error result = nsClient->patch(REST_RESOURCE + recordName + "/" + recordId, payload);
    if (result is error) {
         return Error("record update request failed", result);
    }

    http:Response response = <http:Response> result;
    if (response.statusCode == 204 && response.hasHeader(LOCATION_HEADER)) {
        return extractInternalId(response);
    }

    json|error responsePayload = response.getJsonPayload();
    if (responsePayload is error) {
        return Error("record update failed", responsePayload);
    }
    return createErrorFromPayload(<map<json>> responsePayload);
}

function deleteRecord(http:Client nsClient, WritableRecord value, string? customRecordPath) returns @tainted Error? {
    string recordName = check resolveRecordName(customRecordPath, typeof value);
    string id = value.id;
    if (id == "") {
        return Error("invalid internal ID: field cannot be empty");
    }

    http:Response|http:Payload|error result = nsClient->delete(REST_RESOURCE + recordName + "/" + id);
    if (result is error) {
        return Error("record deletion request failed", result);
    }

    http:Response response = <http:Response> result;
    if (response.statusCode == 204) {
        return;
    }

    json|error responsePayload = response.getJsonPayload();
    if (responsePayload is error) {
        return Error("record deletion failed", responsePayload);
    }
    return createErrorFromPayload(<map<json>> responsePayload,<json>responsePayload);
}

function upsertRecord(http:Client nsClient, WritableRecordType targetType, string recordId,
                      WritableRecord|json newValue, string? customRecordPath) returns @tainted string|Error {

    string recordName = check resolveRecordName(customRecordPath, targetType);
    json payload;
    if newValue is WritableRecord {
        json|error jsonValue = newValue.cloneWithType(json);
        if jsonValue is error {
            return Error("Error while constructing request payload for upsert operation", jsonValue);
        }
        payload = <json> jsonValue;
    } else {
        payload = newValue;
    }

    http:Response|http:Payload|error result = nsClient->put(REST_RESOURCE + recordName + "/" + EID + recordId, payload);
    if (result is error) {
        return Error("record upsertion request failed", result);
    }

    http:Response response = <http:Response> result;
    if (response.statusCode == 204 && response.hasHeader(LOCATION_HEADER)) {
        return extractInternalId(response);
    }

    json|error responsePayload = response.getJsonPayload();
    if responsePayload is error {
        return Error("record upsertion failed", responsePayload);
    }
    return createErrorFromPayload(<map<json>> responsePayload);
}

function searchRecord(http:Client nsClient, ReadableRecordType targetType, string? filter, string? customRecordPath,
                      int maxLimit, int offset) returns @tainted [string[], boolean]|Error {

    string recordName = check resolveRecordName(customRecordPath, targetType);
    string range = "limit=" + maxLimit.toString() + "&offset=" + offset.toString();
    string queryStr = filter is () ? "?" + range : "?q=" + filter + "&" + range;

    log:printDebug(function () returns string {
            return "Search query param: " + queryStr;
        });
        
    http:Response|http:Payload|error result = nsClient->get(REST_RESOURCE + recordName + queryStr);
    if (result is error) {
        return Error("record search() request failed", result);
    }
    http:Response response = <http:Response> result;
    if (response.statusCode != 200) {
        json|error responsePayload = response.getJsonPayload();
        if (responsePayload is error) {
            return Error("record search failed", responsePayload);
        }
        return createErrorFromPayload(<map<json>> responsePayload);
    }

    json|error responsePayload = response.getJsonPayload();
    if (responsePayload is error) {
        return Error("record search failed", responsePayload);
    }

    string[] collection = [];
    map<json> jsonPayload = <map<json>> responsePayload;
    var convetResult = jsonPayload.cloneWithType(Collection);
    if (convetResult is error) {
        return Error("failed search operation: Invalid content", convetResult);
    }

    Collection listOfItem = <Collection> convetResult;
    if (<int> listOfItem["totalResults"] == 0) {
        return [collection, false];
    }

    NsResource[] items = <NsResource[]> listOfItem["items"];
    foreach NsResource item in items {
        collection.push(item.id);
    }
    return [collection, <boolean> listOfItem["hasMore"]];
}
