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

type TokenData record {
    string accountId;
    string consumerId;
    string consumerSecret;
    string tokenSecret;
    string token;
    string nounce;
    string timestamp;
};

# Ballerina record for netsuite record creation response
#
# + internalId - NetSuite record ID 
# + recordType - Netsuite record type  
# + afterSubmitFailed - Boolean for checking  After submission NetSuite failures
# + warning - Netsuite warnings
# + isSuccess -  Boolean for checking submission NetSuite failures  
public type RecordAddResponse record {
    boolean isSuccess;
    boolean afterSubmitFailed?;
    string internalId;
    string recordType;
    string warning?;
};

# Ballerina record for Netsuite record deletion response  
public type RecordDeletionResponse record {
    *RecordAddResponse;
};

# Ballerina record for Netsuite record update response
public type RecordUpdateResponse record {
    *RecordAddResponse;
};

# Ballerina record for Netsuite record delete response
#
# + deletionReasonId - Reason ID for deletion  
# + recordType - NetSuite Record type   
# + deletionReasonMemo - NetSuite Reason memo for deletion   
# + recordInternalId - Internal ID of the Netsuite record
public type RecordDetail record {
    string recordInternalId;
    string recordType;
    string deletionReasonId?;
    string deletionReasonMemo?;
};

# Netsuite saveSearch list response record
#
# + recordRefList - Netsuite record reference list
# + numberOfRecords - Number of records  
# + isSuccess - Boolean for checking submission NetSuite failures
public type SavedSearchResponse record {
    int numberOfRecords?;
    boolean isSuccess;
    RecordRef[] recordRefList = [];
};

# RecordType Connector supports for creation operation for now.  
public type RecordType Customer|Contact|Currency|Invoice|Classification;

#Map type for record to Map conversion
type MapAnyData map<anydata>;

# Ballerina record for storing search results
#
# + records -  Array of record references  
public type RecordList record {|
    RecordRef[] records;
|};

# Ballerina records for search operation
#
# + fieldName - Name of the search field  
# + operator - Searching operator 
# + searchType - Netsuite Search field type  
# + value1 - Primary Search value 
# + value2 - Secondary Search value  
public type SearchElement record {
    string fieldName;
    string operator;
    SearchType searchType;
    string value1;
    string value2?;
};