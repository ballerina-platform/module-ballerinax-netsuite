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

# Represents a set of commonly used attributes across NetSuite records.
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

# Represents the common values of entities such as Customer, Partner, etc.
#
# + id - The internal ID of the record
# + links - The HATEOAS links
# + refName - The reference name
public type Entity record {
    string id = "";
    Link[] links?;
    string refName?;
};

# Represents the `Link` nested record with HATEOAS links.
#
# + rel - The relative identifier
# + href - The hyperlink reference
public type Link record {
    string rel = "";
    string href = "";
};

type Collection record {
    Link[] links;
    NsResource[] items;
    int totalResults;
    int count;
    boolean hasMore;
    int offset;
};
