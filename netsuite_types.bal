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
import ballerina/oauth2;

# The configuration used to create a NetSuite `Client`.
#
# + baseUrl - The account specific service URL for SuiteTalk REST web services(Setup > Company > Setup Tasks >
#             Company information on the Company URLs sub tab)
# + oauth2Config - The OAuth2 client configuration
# + secureSocketConfig - The secure connection configuration
# + proxy - The proxy server related options
# + timeoutInMillis - The maximum time to wait (in milliseconds) for a response before closing the connection
# + retryConfig - The configurations associated with retrying
public type Configuration record {|
    string baseUrl;
    oauth2:DirectTokenConfig oauth2Config;
    http:ClientSecureSocket secureSocketConfig?;
    http:ProxyConfig proxy?;
    int timeoutInMillis = 60000;
    http:RetryConfig retryConfig?;
|};

# The type of the user-defined custom record.
#
# + id - The internal ID of the record
type CustomRecord record {|
    string id;
    anydata...;
|};

# The types of records, which support the writable NetSuite operations such as create, update, and delete.
public type WritableRecord Customer|SalesOrder|Currency|NonInventoryItem|Invoice|AccountingPeriod|CustomerPayment|
                           Account|Opportunity|Partner|Classification|CustomRecord|Vendor|VendorBill|ServiceItem|
                           InventoryItem|OtherChargeItem|ShipItem|DiscountItem|PaymentItem|PaymentMethod|Department|
                           Location|Contact|Employee|PurchaseOrder;
# The types of records, which support the readable NetSuite operations such as read and search.
public type ReadableRecord Subsidiary|WritableRecord;
# The types of nested records, which reside inside a parent record.
public type SubRecord AddressbookCollection|AddressbookAddress|Currency|ItemCollection|AccountingPeriod|CustomRecord|
                      VisualsCollection|CurrencylistCollection|ShippingAddress|BillingAddress;

# The type description of records, which support the writable NetSuite operations.
public type WritableRecordType typedesc<WritableRecord>;
# The type description of records, which support the readable NetSuite operations.
public type ReadableRecordType typedesc<ReadableRecord>;
# The type description of the nested records.
public type SubRecordType typedesc<SubRecord>;

# The types of the record identifiers.
public type IdType INTERNAL|EXTERNAL;
# The types of the HTTP methods, which NetSuite API supports.
public type HttpMethod GET|POST|PATCH|DELETE|PUT;
# The types of the `ItemEntity`, which are available and supported.
public type ItemEntity ServiceItem|NonInventoryItem|InventoryItem|OtherChargeItem|ShipItem|DiscountItem|PaymentItem|
                       NsResource;
