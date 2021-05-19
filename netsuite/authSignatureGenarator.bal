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

import ballerina/crypto;
import ballerina/lang.'array;
import ballerina/uuid;
import ballerina/regex;

isolated function getNetsuiteSignature(string timeNow, string UUID, NetSuiteConfiguration config) returns string|error {
    TokenData tokenData = {
        accountId: config.accountId,
        consumerId: config.consumerId,
        consumerSecret: config.consumerSecret,
        tokenSecret: config.tokenSecret,
        token: config.token,
        nounce: UUID,
        timestamp: timeNow
    };
    string token = check generateSignature(tokenData);
    return token;
}

isolated function getRandomString() returns string { //Maker private
    string uuid1String = uuid:createType1AsString();
    return regex:replaceAll(uuid1String, "-", "s");
}

isolated function makeBaseString(TokenData values) returns string {
    string token = values.accountId + AMPERSAND + values.consumerId + AMPERSAND + values.token + AMPERSAND 
    + values.nounce + AMPERSAND + values.timestamp;
    return token;
}

isolated function createKey(TokenData values) returns string {
    string keyValue = values.consumerSecret + AMPERSAND + values.tokenSecret;
    return keyValue;
}

isolated function generateSignature(TokenData values) returns string|error {
    string baseString = makeBaseString(values);
    string keyValue = createKey(values);
    byte[] data = baseString.toBytes();
    byte[] key = keyValue.toBytes();
    byte[] hmac = check crypto:hmacSha256(data, key);
    return 'array:toBase64(hmac);
}