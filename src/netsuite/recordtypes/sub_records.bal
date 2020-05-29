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

# Represents the `AddressBook` NetSuite sub record.
#
# + id - The internal ID of the record
# + addressBookType - The type of the address book
public type AddressBook record {
    string id = "";
    string addressBookType?;
};

# Represents the `Item` NetSuite sub record.
#
# + links - The HATEOAS record links
# + items - The collection of items
# + totalResults - The total of the available items
# + count - The amount of items stated in the collection out of all
# + hasMore - The state of item availability
# + offset - The starting point of the items
public type ItemCollection record {
    Link[] links?;
    ItemElement[] items;
    int totalResults?;
    int count?;
    boolean hasMore?;
    int offset?;
};

# Represents the `Items` NetSuite sub record.
#
# + id - The internal ID of the record
# + amount - The amount of the item
# + item - The attributes of the item
# + itemSubType - The sub type of the item
# + itemType - The type of the item
public type ItemElement record {
    //string id = "";
    float amount;
    NsResource item;
    string itemSubType?;
    string itemType?;
};

# Represents the commont fields of service, inventory item NetSuite records.
#
# + id - The internal ID of the record
# + amount - The amount of the item
# + item - The attributes of the item
# + itemSubType - The sub type of item
# + itemType - The type of item
type Item record {
    *NsResource;
    string itemId?;
    NsResource taxSchedule?;
    string itemType?;
    Subsidiary subsidiary?;
    NsResource sitecategory?;
    string displayName?;
    string createdDate?;
    string lastModifiedDate?;
    Account incomeAccount?;
    boolean isInactive?;
};
