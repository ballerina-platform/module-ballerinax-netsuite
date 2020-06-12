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

# Represents a set of commonly-used attributes across NetSuite records.
#
# + id - The internal ID of the record
# + externalId - The external ID of the record
# + links - The HATEOAS links
# + refName - The reference name
public type NsResource record {
    string id = "";
    string externalId?;
    Link[] links?;
    string refName?;
};

# Represents the common values of the entities such as Customer, Partner, etc.
#
# + id - The internal ID of the record
# + links - The HATEOAS links
# + refName - The reference name
public type Entity record {
    string id = "";
    Link[] links?;
    string refName?;
};

# Represents the `Link` nested record with the HATEOAS links.
#
# + rel - The relative identifier
# + href - The hyperlink reference
public type Link record {
    string rel = "";
    string href = "";
};

# Represents the common fields of the `service` and `inventory item` NetSuite records.
# |                                            |
# |:-------------------------------------------|
# | id - The internal ID of the record         |
# | externalId - The external ID of the record |
# | links - The HATEOAS links                  |
# | refName - The reference name               |
#
# + itemId - The unique item ID
# + itemType - The type of the item
# + taxSchedule - The tax schedule of the item
# + subsidiary - The associated `Subsidiary`
# + sitecategory - The category of the item to be listed on the website
# + displayName - The public name to be appeared in the sales forms
# + createdDate - The date on when the item was created in the account
# + lastModifiedDate - The last modified date of the record
# + incomeAccount - The income account associated with the item
# + isInactive - Whether the record is no longer active or used in the account
type Item record {
    *NsResource;
    string itemId?;
    string itemType?;
    NsResource taxSchedule?;
    Subsidiary subsidiary?;
    NsResource sitecategory?;
    string displayName?;
    string createdDate?;
    string lastModifiedDate?;
    Account incomeAccount?;
    boolean isInactive?;
};

# Represents a collection of NetSuite records.
#
# + links - The HATEOAS record links
# + items - The collection of items
# + totalResults - The total of the available items
# + count - The amount of items stated in the collection out of all the items
# + hasMore - The state of item availability
# + offset - The starting point of the items
public type Collection record {
    Link[] links?;
    NsResource[] items?;
    int totalResults?;
    int count?;
    boolean hasMore?;
    int offset?;
};

# Represents the common `Address` elements.
#
# + links - The HATEOAS record links
# + id - The location number
# + addr1 - The first part of the address
# + addr2 - The second part of the address
# + addr3 - The third part of the address
# + addrText - The complete address
# + addressee - The name of the entity, which should appear
# + addressformat - The format of the address
# + attention - The name of the addressed person
# + city - The city to be used in the address
# + state - The company's state or province
# + zip - The postal code
# + country - The country to be used in the address
# + override - The free-form address text field is overridden by the other address if `true`
type Address record {
    Link[] links?;
    int id?;
    string addr1?;
    string addr2?;
    string addr3?;
    string addrText?;
    string addressee?;
    string addressformat?;
    string attention?;
    string city?;
    string state?;
    string zip?;
    string country?;
    boolean override?;
};
