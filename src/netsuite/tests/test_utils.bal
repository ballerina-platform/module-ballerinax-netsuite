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

function createOrSearchIfExist(@tainted WritableRecord recordValue, string? filter = (), string? customPath = ())
                               returns @tainted string {
    log:printInfo("Creating...");
    var created = nsClient->create(<@untained> recordValue, customPath);
    if (created is Error) {
        log:printInfo("Search...");
        return searchForRecord(recordValue, filter, customPath);
    } else {
        test:assertTrue(created != "", msg = "record creation failed");
        return created;
    }
}

function searchForRecord(@tainted WritableRecord recordValue, string? filter = (), string? customPath = ()) returns
                         @tainted string {
    var searched = nsClient->search(<@untainted>typeof recordValue, filter, customPath);
    if (searched is Error) {
        test:assertFail(msg = "search operation failed: " + searched.toString());
        return "";
    } else {
        test:assertTrue(searched[0] != "", msg = "record search failed");
        return searched[0];
    }
}

function updateAPartOfARecord(@tainted WritableRecord recordValue, json input, string key, string value,
                              string? customPath = ()) {
    log:printInfo("Updating a part of the record...");
    var updated = nsClient->update(<@untainted> recordValue, input, customPath);
    if (updated is Error) {
        test:assertFail(msg = "JSON part update operation failed: " + updated.toString());
    }
    var updatedRecord = readRecord(<@untained string> updated, typeof recordValue, customPath);
    if (updatedRecord is ()) {
        test:assertFail(msg = "retrieval after update operation failed: " + updatedRecord.toString());
    } else {
        test:assertEquals(updatedRecord[key].toString(), value, msg = "JSON part update failed");
    }
}

function readRecord(string id, ReadableRecordType recordType, string? customPath = ()) returns @tainted ReadableRecord? {
    var retrieved = nsClient->get(id, recordType, customRecordPath = customPath);
    if (retrieved is Error) {
        test:assertFail(msg = " read operation failed: " + retrieved.toString());
    } else {
        test:assertTrue(retrieved.id != "", msg = "read failed");
        return retrieved;
    }
}

function updateCompleteRecord(@tainted WritableRecord recordValue, WritableRecord newValue, string key,
                              string value, string? customPath = ()) {
    log:printInfo("Updating a complete record...");
    var updated = nsClient->update(<@untainted> recordValue, <@untained> newValue, customPath);
    if (updated is Error) {
        test:assertFail(msg = "complete record update operation failed: " + updated.toString());
    }

    var updatedRecord = readRecord(<@untained string> updated, typeof recordValue, customPath);
    test:assertEquals(updatedRecord[key].toString(), value, msg = "complete record update failed");
}

function deleteRecordTest(@tainted WritableRecord recordValue, string? customPath = ()) {
    log:printInfo("Deleting...");
    var deleted = nsClient->delete(recordValue, customPath);
    if (deleted is Error) {
        test:assertFail(msg = "delete operation failed: " + deleted.toString());
    }

    var res = nsClient->get(recordValue.id, typeof recordValue, customRecordPath = customPath);
    if (res is Error) {
        test:assertEquals(res.detail()["errorCode"].toString(), "NONEXISTENT_ID", msg = "record deletion failed");
    } else {
        test:assertFail(msg = "delete operation failed: " + res.toString());
    }
}

function upsertCompleteRecord(WritableRecord newValue, string exId, string? customPath = ()) returns @tainted ReadableRecord? {
    log:printInfo("Upserting a complete record...");
    var upserted = nsClient->upsert(exId, typeof newValue, <@untained> newValue, customPath);
    if (upserted is Error) {
        test:assertFail(msg = "upsert record operation failed: " + upserted.toString());
    }

    var updatedRecord = readRecord(<string> upserted, typeof newValue, customPath);
    if (updatedRecord is ()) {
        test:assertFail(msg = "retrieval after upsert operation failed: " + updatedRecord.toString());
    } else {
        test:assertTrue(updatedRecord.id != "", msg = "upsertion failed");
        test:assertEquals(updatedRecord["externalId"], exId, msg = "upsertion failed");
        return updatedRecord;
    }
}

function upsertAPartOfARecord(@tainted WritableRecord recordValue, json input, string exId, string key, string value,
                              string? customPath = ()) returns @tainted ReadableRecord? {
    log:printInfo("Upsert a part of the record...");
    var upserted = nsClient->upsert(exId, typeof recordValue, input, customPath);
    if (upserted is Error) {
        test:assertFail(msg = "upsert json operation failed: " + upserted.toString());
    }

    var updatedRecord = readRecord(<@untained string> upserted, typeof recordValue, customPath);
    if (updatedRecord is ()) {
        test:assertFail(msg = "retrieval after upsert operation failed: " + updatedRecord.toString());
    } else {
        test:assertEquals(updatedRecord[key].toString(), value, msg = "upsertion failed");
        return updatedRecord;
    }
}

function subRecordTest(@tainted ReadableRecord recordValue, SubRecordType subRecordType, string key, string value) {
    log:printInfo("Accessing Sub Record...");
    var subRecord = nsClient->getSubRecord(recordValue, subRecordType);
    if (subRecord is Error) {
        test:assertFail(msg = "getSubRecord operation failed: " + subRecord.toString());
    } else {
        test:assertEquals(subRecord[key].toString(), value,  msg = "getSubRecord operation failed");
    }
}

function readExistingRecord(ReadableRecordType recordType, string? customPath = ()) {
    log:printInfo("Reading...");
    string[]|Error lists = nsClient->search(recordType, customRecordPath = customPath);
    if (lists is Error) {
        if (lists is NoResultError) {
            return;
        }
        test:assertFail(msg = "search operation failed: " + lists.toString());
    }

    string[] ids = <string[]> lists;
    var updatedRecord = readRecord(<@untained> ids[0], recordType, customPath);
    if (updatedRecord is ()) {
        test:assertFail(msg = "retrieval failed: " + updatedRecord.toString());
    } else {
        test:assertTrue(updatedRecord.id != "", msg = "Record retrieval failed");
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
            return <Customer> readRecord(<@untained> searched[0], Customer);
            //return searchedRecord;
        }
    }
    var createdCustomer = readRecord(<string> created, Customer);
    if (createdCustomer is ()) {
        test:assertFail(msg = "retrieval failed: " + createdCustomer.toString());
    } else {
        test:assertTrue(createdCustomer.id != "", msg = "Test customer creation failed");
        return <Customer> createdCustomer;
    }
}
