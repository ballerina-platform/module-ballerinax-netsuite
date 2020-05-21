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

import ballerina/log;
import ballerina/test;

function createOrSearchIfExist(@tainted WritableRecord recordValue, string? filter = ()) {
    log:printInfo("Creating...");
    var created = nsClient->create(<@untained> recordValue);
    if (created is Error) {
        log:printInfo("Search...");
        searchForRecord(recordValue, filter);
    } else {
        test:assertTrue(recordValue.id != "", msg = "record creation failed");
    }
}

function searchForRecord(@tainted WritableRecord recordValue, string? filter = ()) {
    var searched = nsClient->search(<@untainted>typeof recordValue, filter);
    if (searched is Error) {
        test:assertFail(msg = "search operation failed: " + searched.toString());
    } else {
        recordValue.id = searched[0];
        test:assertTrue(recordValue.id != "", msg = "record search failed");
    }
}

function updateAPartOfARecord(@tainted WritableRecord recordValue, json input, string key, string value) {
    log:printInfo("Updating a part of the record...");
    Error? updated = nsClient->update(<@untainted> recordValue, input);
    if (updated is Error) {
        test:assertFail(msg = " update operation failed: " + updated.toString());
    }
    test:assertTrue(recordValue[key].toString() == value, msg = "update failed");
}

function updateCompleteRecord(@tainted WritableRecord recordValue, WritableRecord newValue, string key,
                                  string value) {
    log:printInfo("Updating a complete record...");
    Error? updateCustom = nsClient->update(<@untainted> recordValue, <@untained> newValue);
    if (updateCustom is Error) {
        test:assertFail(msg = "update operation failed: " + updateCustom.toString());
    }
    test:assertTrue(recordValue[key].toString() == value, msg = "update failed");
}

function deleteRecordTest(@tainted WritableRecord recordValue) {
    log:printInfo("Deleting...");
    var deleted = nsClient->delete(recordValue);
    if (deleted is Error) {
        test:assertFail(msg = "delete operation failed: " + deleted.toString());
    }

    var res = nsClient->get(recordValue.id, typeof recordValue);
    if (res is Error) {
        test:assertTrue(res.detail()["errorCode"].toString() == "NONEXISTENT_ID", msg = "record deletion failed");
    } else {
        test:assertFail(msg = "delete operation failed: " + res.toString());
    }
}

function upsertCompleteRecord(WritableRecord newValue, string exId) {
    log:printInfo("Upserting a complete record...");
    Error? upserted = nsClient->upsert(exId, typeof newValue, <@untained> newValue);
    if (upserted is Error) {
        test:assertFail(msg = "upsert record operation failed: " + upserted.toString());
    }
    test:assertTrue(newValue.id != "", msg = "upsertion failed");
    test:assertTrue(newValue["externalId"] == exId, msg = "upsertion failed");
}

function upsertAPartOfARecord(@tainted WritableRecord recordValue, json input, string exId, string key, string value) {
    log:printInfo("Upsert a part of the record...");
    Error? upserted = nsClient->upsert(exId, typeof recordValue, input);
    if (upserted is Error) {
        test:assertFail(msg = "upsert json operation failed: " + upserted.toString());
    }

    // The upsertion with a JSON does not update any local records as it does not take a record as a param. So user
    // should do a get specifically to verify the change
    ReadableRecord|Error res = nsClient->get(exId, typeof recordValue, EXTERNAL);
    if (res is Error) {
        test:assertFail(msg = "access operation failed: " + res.toString());
    } else {
        test:assertTrue(res[key].toString() == value, msg = "upsertion failed");
    }
}

function subRecordTest(@tainted ReadableRecord recordValue, SubRecordType subRecordType, string key, string value)  {
    log:printInfo("Accessing Sub Record...");
    var subRecord = nsClient->getSubRecord(recordValue, subRecordType);
    if (subRecord is Error) {
        test:assertFail(msg = "getSubRecord operation failed: " + subRecord.toString());
    } else {
        test:assertTrue(subRecord[key].toString() == value,  msg = "getSubRecord operation failed");
    }
}

function readExistingRecord(ReadableRecordType recordType) {
    log:printInfo("Reading...");
    string[]|Error lists = nsClient->search(recordType);
    if (lists is Error) {
        if (lists is NoResultError) {
            return;
        }
        test:assertFail(msg = "search operation failed: " + lists.toString());
    }

    string[] ids = <string[]> lists;
    ReadableRecord|Error getResult = nsClient->get(<@untained> ids[0], recordType);
    if (getResult is Error) {
        test:assertFail(msg = "read operation failed: "+ getResult.toString());
    } else {
        test:assertTrue(getResult.id != "", msg = "Record retrieval failed");
    }
}

function getARandomPrerequisiteRecord(ReadableRecordType recordType, public string? filter = ()) returns
                                      ReadableRecord? {
    string recordName = getRecordNameFromTypeDescForTests(recordType);
    string[]|Error lists = nsClient->search(recordType, filter);
    if (lists is Error) {
        test:assertFail(msg = "test cannot be proceeded without prerequisite '" + recordName + "':" + lists.toString());
    }

    string[] ids = <string[]> lists;
    ReadableRecord|Error getResult = nsClient->get(<@untained> ids[0], recordType);
    if (getResult is Error) {
        test:assertFail(msg = "test cannot be proceeded without prerequisite '" + recordName + "':"
                            + getResult.toString());
        return;
    } else {
        test:assertTrue(getResult.id != "", msg = "record retrieval failed");
        return getResult;
    }
}

function getRecordNameFromTypeDescForTests(ReadableRecordType recordType) returns string {
    var name = getRecordName(recordType);
    if (name is Error) {
        return "NON_EXIST";
    }
    return <string> name;
}

function getDummyCustomer() returns @tainted Customer? {
    Subsidiary? subsidiary = ();
    var recordSubsidiary = getARandomPrerequisiteRecord(Subsidiary);
    if recordSubsidiary is Subsidiary {
        subsidiary = recordSubsidiary;
    }

    Customer customer = {
        entityId: "Ballerina Dummy Customer",
        companyName: "Dummy ballerinalang",
        subsidiary: <Subsidiary> subsidiary
    };

    var created = nsClient->create(<@untained> customer);
    if (created is Error) {
        var searched = nsClient->search(<@untainted>typeof customer, "entityId IS \"Ballerina Dummy Customer\"");
        if (searched is Error) {
            test:assertFail(msg = "test cannot be proceeded without prerequisite 'customer':" + created.toString());
        } else {
            customer.id = searched[0];
            return customer;
        }
    }
    test:assertTrue(customer.id != "", msg = "Test customer creation failed");
    return customer;
}
