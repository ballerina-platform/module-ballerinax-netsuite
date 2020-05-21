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
import ballerina/lang.'int;
import ballerina/log;
import ballerina/oauth2;
import ballerina/stringutils;

# The NetSuite Client object that allows ballerina to connecto with NetSuite Account to execute CRUD and search
# operations to perform business processing on NetSuite records and to navigate dynamically between records.
public type Client client object {
    private http:Client netsuiteClient;

    # Gets invoked to initialize the `client`.
    #
    # + netSuiteConfig - The configurations to be used when initializing the `client`
    public function __init(Configuration netSuiteConfig) {
        oauth2:OutboundOAuth2Provider oauth2Provider = new (netSuiteConfig.oauth2Config);
        http:BearerAuthHandler bearerHandler = new (oauth2Provider);

        http:ClientConfiguration httpClientConfig = {
            auth: {
                authHandler: bearerHandler
            },
            secureSocket: netSuiteConfig?.secureSocketConfig,
            timeoutInMillis: netSuiteConfig.timeoutInMillis,
            retryConfig: netSuiteConfig?.retryConfig,
            http1Settings: {
                keepAlive: http:KEEPALIVE_NEVER
            }
        };

        self.netsuiteClient = new(netSuiteConfig.baseUrl, httpClientConfig);
    }

    # Creates the NetSuite record and populates the passed-in record.
    #
    # + value - The value that needs to be inserted as a NetSuite record
    # + return - The `netSuite:Error` if it is a failure or else `()`
    public remote function create(@tainted WritableRecord value) returns @tainted Error? {
        return createRecord(self.netsuiteClient, value);
    }

    # Retrieves the NetSuite record for a given internal/external identifier. Relevant record is uniquely identified
    # by the record type and id.
    #
    #
    # + id - The internal/external identifier
    # + targetType - The typedesc of targeted record type
    # + idType - The type of the provided record identifier, either INTERNAL or EXTERNAL
    # + return - The `netSuite:Error` if it is a failure or else the record
    public remote function get(string id, ReadableRecordType targetType, public IdType idType = INTERNAL) returns
                               @tainted ReadableRecord|Error {
        return getRecord(self.netsuiteClient, id, targetType, idType);
    }

    # Updates the NetSuite record with the given record or JSON and updates the passed-in existing record.
    #
    # + existingValue - The original NetSuite record
    # + newValue - The record or a part of record which needs to be replaced with
    # + return - The `netSuite:Error` if it is a failure or else `()`
    public remote function update(@tainted WritableRecord existingValue, WritableRecord|json newValue) returns
                                  @tainted Error? {
        return updateRecord(self.netsuiteClient, existingValue, newValue);
    }

    # Deletes the given record from NetSuite account. Local record values are not deleted.
    #
    # + value - The record that needs to be deleted from NetSuite
    # + return - The `netSuite:Error` if it is a failure or else `()`
    public remote function delete(WritableRecord value) returns @tainted Error? {
        return deleteRecord(self.netsuiteClient, value);
    }

    # Creates the NetSuite record or updates an existing record using external id. The relevant record is uniquely
    # identified by the record type and externalId. The passed-in value is also populated if the values is record type.
    #
    # + externalId - The external identifier
    # + targetType - The typedesc of targeted record type
    # + value - The record or a part of a record, which needs to be created or updated
    # + return - The `netSuite:Error` if it is a failure or else `()` if created or updated
    public remote function upsert(string externalId, WritableRecordType targetType, WritableRecord|json value)
                                  returns @tainted Error? {
        return upsertRecord(self.netsuiteClient, targetType, externalId, value);
    }

    # Retrieves the list of records ids. The list can be filtered with given filter string.
    #
    # + targetType - The typedesc of targeted record type
    # + filter - The condition to filter the list using operators. Each condition consists of a field name, an
    #            operator, and a value. Several conditions can be joined using the AND / OR logical operators
    #            Eg:"id BETWEEN_NOT[1,42]", "dateCreated ON_OR_AFTER1/1/2019 AND dateCreated BEFORE 1/1/2020"
    # + limit - The limit used to specify the number of results on a single request
    # + offset - The offset used for selecting a specific starting point of a set of results.
    # + return - The `netSuite:Error` if it is a failure or else an array of string ids
    public remote function search(ReadableRecordType targetType, public string? filter = (), public int limit = 1000,
                                  public int offset = 0) returns @tainted string[]|Error {
        string[] collection = [];
        var result = searchRecord(self.netsuiteClient, targetType, filter, limit, offset, collection);
        if (result is Error) {
            return result;
        }
        return collection;
    }

    # Retrieves the nested records of the NetSuite record.
    #
    # + parent - The parent record of subrecord
    # + subRecordType - The typedesc of targeted record type
    # + return - The `netSuite:Error` if it is a failure or else the nested record
    public remote function getSubRecord(ReadableRecord parent, SubRecordType subRecordType) returns @tainted
                                        SubRecord|Error {
        string parentRecordName = check getRecordName(typeof parent);
        string subRecordName = check getRecordName(subRecordType);
        string recordId = parent.id;
        if (recordId == "") {
            return getErrorFromMessage("invalid internal id: '" + parentRecordName + "' id field cannot be empty");
        }

        string resourcePath = REST_RESOURCE + parentRecordName + "/" + recordId + "/" + subRecordName + EXPAND_SUB_RESOURCES;
        json payload = check getJsonPayload(self.netsuiteClient, resourcePath, subRecordName);
        var result =  constructRecord(subRecordType, payload);
        if (result is SubRecord) {
            return result;
        }
        if (result is WritableRecord|ReadableRecord) {
            panic getErrorFromMessage("subrecord retrieval failed: illegal state error");
        }
        return getError("'" + subRecordName + "' subrecord mapping failed", <error> result);
    }

    # Common action to execute all queries including custom records in a generic manner. This action can be use as an
    # alternative for unsupported entities and actions. The metadata can be accessed via API docs
    # [https://system.netsuite.com/help/helpcenter/en_US/APIs/REST_API_Browser/record/v1/2020.1/index.html].
    #
    # + httpMethod - The respective HTTP method
    # + path - The resource path including path and query params(eg:"/customer/{id}/transform/vendor")
    # + requestBody - The JSON request body
    # + return - The `netSuite:Error` if it is a failure or else the response body. If the response status code is a
    #            204, headers will be returned as a JSON
    public remote function execute(HttpMethod httpMethod, string path, public json? requestBody = ()) returns
                                   @tainted json|Error {
        http:Response|error result = self.netsuiteClient->execute(httpMethod, BASE_RESOURCE + path, requestBody);
        if (result is error) {
        	 return getError("execution failed", result);
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
};

function createRecord(http:Client nsClient, @tainted WritableRecord recordValue) returns @tainted Error? {
    string recordName = check getRecordName(typeof recordValue);

    json|error payload = json.constructFrom(recordValue);
    if (payload is error) {
        return getError("Error while constructing request payload for create operation", payload);
    }

    json jsonValue = <json> payload;
    http:Response|error result = nsClient->post(REST_RESOURCE + recordName, jsonValue);
    if (result is error) {
         return getError("'" + recordName + "' record creation request failed", result);
    }

    http:Response response = <http:Response> result;
    if (response.statusCode == 204 && response.hasHeader(LOCATION_HEADER)) {
        check updatePassedInRecord(nsClient, extractInternalId(response), recordValue);
        return ();
    }

    json|error responsePayload = response.getJsonPayload();
    if (responsePayload is error) {
        return getError("'" + recordName + "' record creation failed", responsePayload);
    }
    return getErrorFromPayload(<map<json>> responsePayload);
}

function getRecord(http:Client nsClient, string id, ReadableRecordType targetType, IdType idType = INTERNAL)
                   returns @tainted ReadableRecord|Error {
    string targetRecordName = check getRecordName(targetType);
    if (id == "") {
        return getErrorFromMessage("invalid internal id: '" + targetRecordName + "' id field cannot be empty");
    }

    string recordId = "/" + (idType is INTERNAL ? id : EID + id);
    string resourcePath = REST_RESOURCE + targetRecordName + recordId + EXPAND_SUB_RESOURCES;
    json payload = check getJsonPayload(nsClient, resourcePath, targetRecordName);
    log:printDebug(function () returns string {
            return "Inbound JSON payload: " + payload.toString();
        });
    var result =  constructRecord(targetType, payload);
    if (result is ReadableRecord) {
        return result;
    } else if (result is error) {
        return getError("'" + targetRecordName + "' record mapping failed", result);
    } else {
        panic getErrorFromMessage("get operation failed: illegal state error");
    }
}

function updateRecord(http:Client nsClient, @tainted WritableRecord existingValue, WritableRecord|json newValue)
                      returns @tainted Error? {
    string recordName = check getRecordName(typeof existingValue);
    string recordId = existingValue.id;
    if (recordId == "") {
        return getErrorFromMessage("invalid internal id: '" + recordName + "' id field cannot be empty");
    }

    json payload;
    if (newValue is WritableRecord) {
        json|error jsonValue = json.constructFrom(newValue);
        if (jsonValue is error) {
            return getError("Error while constructing request payload for update operation", jsonValue);
        }
        payload = <json> jsonValue;
    } else {
        payload = newValue;
    }

    http:Response|error result = nsClient->patch(REST_RESOURCE + recordName + "/" + recordId, payload);
    if (result is error) {
         return getError("'" + recordName + "' record update request failed", result);
    }

    http:Response response = <http:Response> result;
    if (response.statusCode == 204 && response.hasHeader(LOCATION_HEADER)) {
        check updatePassedInRecord(nsClient, recordId, existingValue);
        return;
    }

    json|error responsePayload = response.getJsonPayload();
    if (responsePayload is error) {
        return getError("'" + recordName + "' record update failed", responsePayload);
    }
    return getErrorFromPayload(<map<json>> responsePayload);
}

function deleteRecord(http:Client nsClient, WritableRecord value) returns @tainted Error? {
    string recordName = check getRecordName(typeof value);
    string id = value.id;
    if (id == "") {
        return getErrorFromMessage("invalid internal id: '" + recordName + "' id field cannot be empty");
    }

    http:Response|error result = nsClient->delete(REST_RESOURCE + recordName + "/" + id);
    if (result is error) {
        return getError("'" + recordName + "' record deletion request failed", result);
    }

    http:Response response = <http:Response> result;
    if (response.statusCode == 204) {
        return;
    }

    json|error responsePayload = response.getJsonPayload();
    if (responsePayload is error) {
        return getError("'" + recordName + "' record deletion failed", responsePayload);
    }
    return getErrorFromPayload(<map<json>> responsePayload);
}

function upsertRecord(http:Client nsClient, WritableRecordType targetType, string recordId, WritableRecord|json newValue)
                      returns @tainted Error? {
    string recordName = check getRecordName(targetType);

    json payload;
    if newValue is WritableRecord {
        json|error jsonValue = json.constructFrom(newValue);
        if jsonValue is error {
            return getError("Error while constructing request payload for upsert operation", jsonValue);
        }
        payload = <json> jsonValue;
    } else {
        payload = newValue;
    }

    http:Response|error result = nsClient->put(REST_RESOURCE + recordName + "/" + EID + recordId, payload);
    if (result is error) {
        return getError("'" + recordName + "' record upsertion request failed", result);
    }

    http:Response response = <http:Response> result;
    if (response.statusCode == 204 && response.hasHeader(LOCATION_HEADER)) {
        if newValue is WritableRecord {
            check updatePassedInRecord(nsClient, extractInternalId(response), newValue);
        }
        return;
    }

    json|error responsePayload = response.getJsonPayload();
    if responsePayload is error {
        return getError("'" + recordName + "' record upsertion failed", responsePayload);
    }
    return getErrorFromPayload(<map<json>> responsePayload);
}

function searchRecord(http:Client nsClient, ReadableRecordType targetType, string? filter, int limit, int offset,
                      string[] collection) returns @tainted string[]|Error {
    string recordName = check getRecordName(targetType);
    string range = "limit=" + limit.toString() + "&offset=" + offset.toString();
    string queryStr = filter is () ? "?" + range : "?q=" + filter + "&" + range;
    log:printDebug(function () returns string {
            return "Search query param: " + queryStr;
        });

    http:Response|error result = nsClient->get(REST_RESOURCE + recordName + queryStr);
    if (result is error) {
        return getError("'" + recordName + "' record search() request failed", result);
    }
    http:Response response = <http:Response> result;
    if (response.statusCode != 200) {
        json|error responsePayload = response.getJsonPayload();
        if (responsePayload is error) {
            return getError("'" + recordName + "' record search failed", responsePayload);
        }
        return getErrorFromPayload(<map<json>> responsePayload);
    }

    json|error responsePayload = response.getJsonPayload();
    if (responsePayload is error) {
        return getError("'" + recordName + "' record search failed", responsePayload);
    }

    var convetResult = Collection.constructFrom(<map<json>> responsePayload);
    if (convetResult is error) {
        return getError("failed search operation: Invalid content", convetResult);
    }

    Collection listOfItem = <Collection> convetResult;
    if (listOfItem.totalResults == 0) {
        return NoResultError(message = "No results found");
    }

    if (!listOfItem.hasMore) {
        NsResource[] items = listOfItem.items;
        foreach NsResource item in listOfItem.items {
            collection.push(item.id);
        }
        return collection;
    }

    NsResource[] items = listOfItem.items;
    foreach NsResource item in listOfItem.items {
        collection.push(item.id);
    }

    Link[] moreLinks = listOfItem.links;
    string nextUrl = "";
    foreach var link in moreLinks {
        if (link.rel == "next") {
            nextUrl = link.href;
            break;
        }
    }
    int nextLimit = 0;
    int nextOffset = 0;
    string queryParams = spitAndGetLastElement(nextUrl, "\\?");
    string[] keyValuePairs = stringutils:split(queryParams, "&");
    foreach string keyValue in keyValuePairs {
        if (stringutils:contains(keyValue, "limit")) {
            var res = 'int:fromString(spitAndGetLastElement(keyValue, "="));
            nextLimit = res is error ? 0 : <int> res;
            continue;
        }
        if (stringutils:contains(keyValue, "offset")) {
            var res = 'int:fromString(spitAndGetLastElement(keyValue, "="));
            nextOffset = res is error ? 0 : <int> res;
            continue;
        }
    }
    return searchRecord(nsClient, targetType, filter, nextLimit, nextOffset, collection);
}
