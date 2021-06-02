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

# Represents record reference base to NetSuite Records
#
# + name - Name of the Record  
# + internalId - NetSuite Internal Id 
# + externalId - NetSuite external Id
@display{label: "Record Base type"}
public type RecordBaseRef record {
    @display{label: "Record Internal Id"}
    string internalId;
    @display{label: "Record external Id"}
    string externalId?;
    @display{label: "Record name"}
    string name?;
};

# References to NetSuite Records
#
# + 'type - Type of the Record 
@display{label: "Record reference"} 
public type RecordRef record {
    *RecordBaseRef;
    @display{label: "Record type"}
    string 'type?;
};

# References to NetSuite Records for Input operations
# 
# + 'type - Type of the Record Eg: "currency" or netsuite:CURRENCY
@display{label: "Record reference"}
public type RecordInputRef record {
    *RecordBaseRef;
    @display{label: "Record type"}
    string 'type;
};
