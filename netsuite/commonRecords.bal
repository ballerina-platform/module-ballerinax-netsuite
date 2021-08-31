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
@display{label: "Add Operation Response"} 
public type RecordAddResponse record {
    @display{label: "Is Success"}
    boolean isSuccess;
    @display{label: "Is After-Submission Failed"}
    boolean afterSubmitFailed?;
    @display{label: "Internal ID"}
    string internalId;
    @display{label: "Record Type"}
    string recordType;
    @display{label: "Warning"}
    string warning?;
};


# Netsuite saveSearch list response record
#
# + recordRefList - Netsuite record reference list
# + totalReferences - The total number of records for this search. Depending on the pageSize value, some or all the 
# records may be returned in this response
# + status - Boolean for checking submission NetSuite failures
public type SavedSearchResponse record {
    boolean status;
    int totalReferences;
    SavedSearchReference[] recordRefList;
};

# Saved search reference
#
# + internalId - Internal Id of the saved search record
# + scriptId - ScriptId of the saved search  
# + name - Name of the Saved search  
public type SavedSearchReference record {
    string internalId;
    string scriptId;
    string name;
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
# + deletionReasonMemo - NetSuite Reason memo for deletion   
@display{label: "Record Details"}
public type RecordDetail record {
    *RecordInfo;
    @display{label: "Record Delete Reason ID"}
    string deletionReasonId?;
    @display{label: "Record Delete Reason Memo"}
    string deletionReasonMemo?;
};

# Ballerina record for Netsuite record delete response
#
# + recordType - NetSuite Record type Eg: "currency","invoice", netsuite:INVOICE etc. 
# + recordInternalId - Internal ID of the Netsuite record
@display{label: "Record Information"}
public type RecordInfo record {
    @display{label: "Record Type"}
    string recordType;
    @display{label: "Record Internal ID"}
    string recordInternalId;
};

# RecordType Connector supports for creation operation for now.  
public type NewRecordType NewCustomer|NewContact|NewCurrency|NewInvoice|NewClassification|NewAccount|NewSalesOrder;

# RecordType Connector supports for update operation for now.   
public type ExistingRecordType Customer|Contact|Currency|Invoice|Classification|Account|SalesOrder;

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
# + fieldName - Name of the search field (Eg: name, type)   
# + operator - Searching operator (optional for boolean searches)  
# + searchType - Netsuite search field type    
# + value1 - Primary search value   
# + value2 - Secondary search value  
# + multiValues - An array of strings for multi values in case there are more values excepts primary and secondary
@display{label: "Search Element"}
public type SearchElement record {
    @display{label: "Search Field Name"}
    string fieldName;
    @display{label: "Search Operator"}
    string|BasicSearchOperator operator;
    @display{label: "Search Type"}
    SearchType searchType;
    @display{label: "First Search Value"}
    string value1;
    @display{label: "Second Search Value"}
    string value2?;
    @display{label: "More Search Values"}
    string[] multiValues?;
};

type SearchResultStatus record {
    *CommonSearchResult;
    xml recordList;
};

type SavedSearchResult record {
    *CommonSearchResult;
    json[] recordList;
};

type CommonSearchResult record {
    int pageIndex;
    int totalPages;
    string searchId;
};
