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

# Holds the value for the record path of the REST web services.
const string REST_RESOURCE = "/services/rest/record/v1";
const string EID = "eid:";
const string EXPAND_SUB_RESOURCES = "?expandSubResources=true";
const string LOCATION_HEADER = "Location";
const string CONTENT_TYPE_HEADER = "Content-Type";

# Internal record ID is referred when retrieving the records.
public const INTERNAL = "INTERNAL";

# External record ID is referred when retrieving the records.
public const EXTERNAL = "EXTERNAL";

# Supported HTTP methods.
public const GET = "GET";
public const PUT = "PUT";
public const POST = "POST";
public const PATCH = "PATCH";
public const DELETE = "DELETE";

# Available filter query operators
# The unary operator `EMPTY` does not accept any values. For example: companyName EMPTY
public const EMPTY = "EMPTY";
# The unary operator `EMPTY_NOT` does not accept any values. For example: companyName EMPTY_NOT
public const EMPTY_NOT = "EMPTY_NOT";
# The boolean operator `IS`. For example: companyName IS SomeName
public const IS = "IS";
# The boolean operator `IS_NOT`. For example: companyName IS_NOT SomeName
public const IS_NOT = "IS_NOT";

# Double, Integer, Float, Number, Duration operators
# The ANY_OF n-ary operator accepts one or any higher number of values. For example: id ANY_OF [1, 2, 3, 4, 5]
public const ANY_OF = "ANY_OF";
# The ANY_OF_NOT n-ary operator accepts one or any higher number of values. For example: ?q=id ANY_OF_NOT [1, 4, 5]
public const ANY_OF_NOT = "ANY_OF_NOT";
# The BETWEEN ternary operator accepts two values. For example: id BETWEEN [1, 42]
public const BETWEEN = "BETWEEN";
# The BETWEEN_NOT ternary operator accepts two values. For example: id BETWEEN_NOT [1, 42]
public const BETWEEN_NOT = "BETWEEN_NOT";
public const EQUAL = "EQUAL";
public const EQUAL_NOT = "EQUAL_NOT";
public const GREATER = "GREATER";
public const GREATER_NOT = "GREATER_NOT";
public const GREATER_OR_EQUAL = "GREATER_OR_EQUAL";
public const GREATER_OR_EQUAL_NOT = "GREATER_OR_EQUAL_NOT";
public const LESS = "LESS";
public const LESS_NOT = "LESS_NOT";
public const LESS_OR_EQUAL = "LESS_OR_EQUAL";
public const LESS_OR_EQUAL_NOT = "LESS_OR_EQUAL_NOT";
# The WITHIN ternary operator accepts two values. For example: id WITHIN [1, 42]
public const WITHIN = "WITHIN";
# The WITHIN_NOT ternary operator accepts two values. For example: id WITHIN_NOT [1, 42]
public const WITHIN_NOT = "WITHIN_NOT";

# String operator
public const CONTAIN = "CONTAIN";
public const CONTAIN_NOT = "CONTAIN_NOT";

# The `companyname` START_WITH `Another Company`
public const START_WITH = "START_WITH";
public const START_WITH_NOT = "START_WITH_NOT";
public const END_WITH = "END_WITH";
public const END_WITH_NOT = "END_WITH_NOT";

# Date / Time operator
public const AFTER = "AFTER";
public const AFTER_NOT = "AFTER_NOT";
public const BEFORE = "BEFORE";
public const BEFORE_NOT = "BEFORE_NOT";
public const ON = "ON";
public const ON_NOT = "ON_NOT";
public const ON_OR_AFTER = "ON_OR_AFTER";
public const ON_OR_AFTER_NOT = "ON_OR_AFTER_NOT";
public const ON_OR_BEFORE = "ON_OR_BEFORE";
public const ON_OR_BEFORE_NOT = "ON_OR_BEFORE_NOT";

# Holds the value for the paths of the NetSuite record.
const string RECORD_PATH_CUSTOMER = "/customer";
const string RECORD_PATH_SALES_ORDER = "/salesOrder";
const string RECORD_PATH_SUBSIDIARY = "/subsidiary";
const string RECORD_PATH_ADDRESSBOOK = "/addressBook";
const string RECORD_PATH_ADDRESSBOOK_ADDRESS = "/addressbookaddress";
const string RECORD_PATH_SHIPPING_ADDRESS = "/shippingAddress";
const string RECORD_PATH_BILLING_ADDRESS = "/billingaddress";
const string RECORD_PATH_CURRENCY = "/currency";
//-------SLP4----------Should change into 3 types of Sales,ReSale etc.
const string RECORD_PATH_NON_INVENTORY_ITEM = "/nonInventorySaleItem";
//-----------------
const string RECORD_PATH_ITEM_COLLECTION = "/item";
const string RECORD_PATH_INVOICE = "/invoice";
const string RECORD_PATH_ACCOUNTING_PERIOD = "/accountingPeriod";
const string RECORD_PATH_CUSTOMER_PAYMENT = "/customerPayment";
const string RECORD_PATH_ACCOUNT = "/account";
const string RECORD_PATH_OPPORTUNITY = "/opportunity";
const string RECORD_PATH_PARTNER = "/partner";
const string RECORD_PATH_CLASSIFICATION = "/classification";
const string RECORD_PATH_VENDOR = "/vendor";
const string RECORD_PATH_VENDOR_BILL = "/vendorBill";
const string RECORD_PATH_SERVICE_ITEM = "/serviceItem";
const string RECORD_PATH_INVENTORY_ITEM = "/inventoryItem";
const string RECORD_PATH_OTHER_CHARGE_ITEM = "/otherChargeItem";
const string RECORD_PATH_SHIP_ITEM = "/shipItem";
const string RECORD_PATH_DISCOUNT_ITEM = "/discountItem";
const string RECORD_PATH_PAYMENT_ITEM = "/paymentItem";
const string RECORD_PATH_PAYMENT_METHOD = "/paymentMethod";
const string RECORD_PATH_DEPARTMENT = "/department";
const string RECORD_PATH_LOCATION = "/location";
const string RECORD_PATH_CONTACT = "/contact";
const string RECORD_PATH_VISUALS = "/visuals";
const string RECORD_PATH_EMPLOYEE = "/employee";
const string RECORD_PATH_CURRENCY_LIST = "/currencylist";
const string RECORD_PATH_PURCHASE_ORDER = "/purchaseOrder";
