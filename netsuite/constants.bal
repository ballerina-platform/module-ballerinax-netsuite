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
public const string & readonly ADD_SOAP_ACTION = "add";
public const string & readonly DELETE_SOAP_ACTION = "delete";
public const string & readonly UPDATE_SOAP_ACTION = "update";
public const string & readonly GET_ALL_SOAP_ACTION = "getAll";
public const string & readonly SEARCH_SOAP_ACTION = "search";
public const string & readonly GET_SOAP_ACTION = "get";
public const string & readonly GET_SAVED_SEARCH_SOAP_ACTION = "getSavedSearch";
public const string & readonly SOAP_ACTION_HEADER = "SOAPAction";
public const string & readonly GET_SERVER_TIME_ACTION = "getServerTime";

//Error Messages
public const string & readonly UNKNOWN_TYPE = "Unknown record type provided!";
public const string & readonly NO_RECORD_FOUND = "No record found!";
public const string & readonly NO_RECORD_CHECK = "No record found, Check the record detail!";
public const string & readonly NOT_SUCCESS = "Sorry, Search was not successful in Netsuite!";
public const string & readonly ERROR_IN_RESULTS = "An error occurred when retrieving the search results!";

//XSD types
public const string & readonly LIST_ACCT = "listAcct";
public const string & readonly TRAN_SALES = "tranSales";

//String Replacements
public const string & readonly MESSAGES_NS = "xmlns=\"urn:messages_2020_2.platform.webservices.netsuite.com\"";
public const string & readonly CORE_NS = "xmlns:platformCore=\"urn:core_2020_2.platform.webservices.netsuite.com\"";
public const string & readonly XSI_NS = "xmlns:xsi=\"http://www.w3.org/http:STATUS_OK1/XMLSchema-instance\"";
public const string & readonly PLATFORM_MSGS = "platformMsgs:";
public const string & readonly PLATFORM_MSGS_ = "platformMsgs_";
public const string & readonly PLATFORM_CORE = "platformCore:";
public const string & readonly XSI = "xsi:";
public const string & readonly XSI_ = "xsi_";
public const string & readonly SOAP_ENV = "soapenv:";
public const string & readonly SOAP_ENV_ = "soapenv_";
public const string & readonly LIST_ACCT_WITH_COLON = "listAcct:";
public const string & readonly LIST_MRK_WITH_COLON = "listMkt:";
public const string & readonly LIST_REL_WITH_COLON = "listRel:";
public const string & readonly LIST_REL = "listRel";
public const string & readonly EMPTY_STRING = "";
public const string & readonly AMPERSAND = "&";
public const string & readonly ERROR = "ERROR";
public const string & readonly CURRENCY_XSI_TYPE = "listAcct:Currency";
//Constant values
public const decimal DEFAULT_ZERO_VALUE = 0.0;
