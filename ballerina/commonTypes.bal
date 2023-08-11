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
import ballerinax/'client.config;

# Netsuite Client Config.
@display {label: "Connection Config"}
public type ConnectionConfig record {|
    *config:ConnectionConfig;
    never auth?;
    # NetSuite Account ID
    string accountId;
    # Netsuite Integration App consumer ID
    string consumerId;
    # Netsuite Integration application consumer secret
    @display{
        label: "",
        kind: "password"
    }
    string consumerSecret;
    # Netsuite user role access token
    @display{
        label: "",
        kind: "password"
    }
    string token;
    # Netsuite user role access secret
    @display{
        label: "",
        kind: "password"
    }
    string tokenSecret;
    # Netsuite SuiteTalk URLs for SOAP web services (Available at Setup->Company->Company Information->Company URLs)
    string baseURL;
    # The HTTP version understood by the client
    http:HttpVersion httpVersion = http:HTTP_1_1;
|};

# Represents an address record in NetSuite
#
# + internalId - Netsuite Internal ID  
# + country - Country from NetSuite country List
# + attention - Field Description  
# + addressee - addressee of this record  
# + addrPhone - Address phone  
# + addr1 - Address Part01
# + addr2 - Address Part02  
# + addr3 - Address Part03  
# + city - City of the Address 
# + state - State of the Address  
# + zip - Zip code the area 
# + addrText - Address stress 
# + override - override the existing address 
public type Address record {
    string internalId?;
    Country|string country?;
    string attention?;
    string addressee?;
    string addrPhone?;
    string addr1?;
    string addr2?;
    string addr3?;
    string city?;
    string state?;
    string zip?;
    string addrText?;
    boolean override?;
};

# Represents NetSuite CustomFieldList type record
#
# + customFields - An array of customFields  
public type CustomFieldList record {|
    CustomField[] customFields;
|};

# Represents a union type for custom field types.
public type CustomField LongCustomFieldRef|DoubleCustomFieldRef|BooleanCustomFieldRef|StringOrDateCustomFieldRef|SelectCustomFieldRef|MultiSelectCustomFieldRef;

# Represents integer custom Field Type in NetSuite UI
#
# + internalId - References a unique instance of a custom field type
# + scriptId - Script Id
# + value - Integer value
public type LongCustomFieldRef record {|
    string internalId;
    string scriptId?;
    int? value;
|};

# Represents decimal number custom Field Type in NetSuite UI
#
# + internalId - References a unique instance of a custom field type
# + scriptId - Script Id
# + value - decimal value  
public type DoubleCustomFieldRef record {|
    string internalId;
    string scriptId?;
    decimal? value;
|};

# Represents boolean number custom Field Type in NetSuite UI
#
# + internalId - References a unique instance of a custom field type
# + scriptId - Script Id
# + value - boolean value  
public type BooleanCustomFieldRef record {|
    string internalId;
    string scriptId?;
    boolean value;
|};

# Represents free-form text, text area, phone number, e-mail address, hyperlink, rich text custom Field Type, date and time in NetSuite UI
#
# + internalId - References a unique instance of a custom field type
# + scriptId - Script Id
# + value - Custom field value  
public type StringOrDateCustomFieldRef record {|
    string internalId;
    string scriptId?;
    string value;
|};

# Represents list/record, document custom Field Type in NetSuite UI
#
# + internalId - References a unique instance of a custom field type
# + scriptId - Script Id
# + value - The list/record or document
public type SelectCustomFieldRef record {|
    string internalId;
    string scriptId?;
    ListOrRecordRef value;
|};

# Represents Multiple Select custom Field Type in NetSuite UI
#
# + internalId - References a unique instance of a custom field type
# + scriptId - Script Id
# + value - An array of lists/records or documents
public type MultiSelectCustomFieldRef record {|
    string internalId;
    string scriptId?;
    ListOrRecordRef[] value;
|};

# Represents an array of type RecordRef
# 
# + recordName - name of the record
# + internalId - internal Id of the record ref  
public type ListOrRecordRef record {
    string recordName;
    string internalId;
};
