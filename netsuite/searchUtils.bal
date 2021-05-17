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

import ballerina/lang.'xml as xmlLib;

isolated  function getSearchElement(SearchElement[] searchElements) returns string{
    string searchElementInPayloadBody = EMPTY_STRING;
    foreach SearchElement element in searchElements {
        searchElementInPayloadBody += getXMLSearchElement(element);
    }
    return searchElementInPayloadBody;
}

isolated  function getXMLSearchElement(SearchElement element) returns string {
    return string `<ns1:${element.fieldName} 
        operator="${element.operator}" 
        xsi:type="urn1:${element.searchType.toString()}">
        <urn1:searchValue>${element.value1}</urn1:searchValue>
        ${getOptionalSearchValue(element).toString()}
        </ns1:${element.fieldName}>`;
}

isolated  function getOptionalSearchValue(SearchElement searchElement) returns string?{
    if(searchElement?.value2 is string) {
        return string `<urn1:searchValue2>${searchElement?.value2.toString()}</urn1:searchValue2>`;
    }
}

isolated  function getSoapPayload(string header, string body) returns xml|error {
    string requestPayload = header + body;
    return check xmlLib:fromString(requestPayload);
}
