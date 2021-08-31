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

//SOAP Actions
const string & readonly ADD_SOAP_ACTION = "add";
const string & readonly DELETE_SOAP_ACTION = "delete";
const string & readonly UPDATE_SOAP_ACTION = "update";
const string & readonly GET_ALL_SOAP_ACTION = "getAll";
const string & readonly SEARCH_SOAP_ACTION = "search";
const string & readonly GET_SOAP_ACTION = "get";
const string & readonly GET_SAVED_SEARCH_SOAP_ACTION = "getSavedSearch";
const string & readonly SOAP_ACTION_HEADER = "SOAPAction";
const string & readonly GET_SERVER_TIME_ACTION = "getServerTime";
const string & readonly SEARCH_MORE_WITH_ID = "searchMoreWithId";
const string & readonly GET_SAVED_SEARCH_ACTION = "getSavedSearch";

//Error Messages
const string & readonly UNKNOWN_TYPE = "Unknown record type provided!";
const string & readonly NO_RECORD_FOUND = "No record found!";
const string & readonly NO_RECORD_CHECK = "No record found, Check the record detail!";
const string & readonly NOT_SUCCESS = "Searching was not successful in Netsuite!";
const string NO_TYPE_MATCHED = "No any advanced search type matched with the provided type.";

//String Replacements
const string & readonly MESSAGES_NS = "xmlns=\"urn:messages_2020_2.platform.webservices.netsuite.com\"";
const string & readonly CORE_NS = "xmlns:platformCore=\"urn:core_2020_2.platform.webservices.netsuite.com\"";
const string & readonly XSI_NS = "xmlns:xsi=\"http://www.w3.org/http:STATUS_OK1/XMLSchema-instance\"";
const string & readonly PLATFORM_MSGS = "platformMsgs:";
const string & readonly PLATFORM_MSGS_ = "platformMsgs_";
const string & readonly PLATFORM_CORE = "platformCore:";
const string & readonly XSI = "xsi:";
const string & readonly XSI_ = "xsi_";
const string & readonly SOAP_ENV = "soapenv:";
const string & readonly SOAP_ENV_ = "soapenv_";
const string & readonly LIST_ACCT_WITH_COLON = "listAcct:";
const string & readonly LIST_MRK_WITH_COLON = "listMkt:";
const string & readonly LIST_REL_WITH_COLON = "listRel:";
const string & readonly LIST_REL = "listRel";
const string & readonly EMPTY_STRING = "";
const string & readonly AMPERSAND = "&";
const string & readonly ERROR = "ERROR";
const string & readonly CURRENCY_XSI_TYPE = "listAcct:Currency";
const string & readonly LIST_ACCT = "listAcct";
const string & readonly TRAN_SALES = "tranSales";

//Constant values
public const decimal DEFAULT_ZERO_VALUE = 0.0;
const string & readonly REQUEST_NEXT_PAGE = "Requesting the next page!";

//Netsuite SOAP endpoint
const string & readonly NETSUITE_ENDPOINT = "/services/NetSuitePort_2020_2";

//XSDNameSpaces
const string SCHEDULING_2020_2 = "urn:scheduling_2020_2.activities.webservices.netsuite.com";
const string FILE_CABINET_2020_2 = "urn:filecabinet_2020_2.documents.webservices.netsuite.com";
const string COMMUNICATION_2020_2 = "urn:urn:communication_2020_2.general.webservices.netsuite.com";
const string ACCOUNTING_2020_2 = "urn:accounting_2020_2.lists.webservices.netsuite.com";
const string EMPLOYEES_2020_2 = "urn:employees_2020_2.lists.webservices.netsuite.com";
const string MARKETING_2020_2 = "urn:marketing_2020_2.lists.webservices.netsuite.com";
const string RELATIONSHIPS_2020_2 = "urn:relationships_2020_2.lists.webservices.netsuite.com";
const string WEBSITE_2020_2 = "urn:website_2020_2.lists.webservices.netsuite.com";
const string SUPPORT_2020_2 = "urn:support_2020_2.lists.webservices.netsuite.com";
const string CUSTOMIZATION_2020_2 = "urn:customization_2020_2.setup.webservices.netsuite.com";
const string FINANCIAL_2020_2 = "urn:financial_2020_2.transactions.webservices.netsuite.com";
const string SALES_2020_2 = "urn:sales_2020_2.transactions.webservices.netsuite.com";
