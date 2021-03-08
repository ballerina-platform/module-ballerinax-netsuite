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

# Represents the NetSuite sub record `Item`.
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

# Represents the NetSuite sub record `Items`.
#
# + amount - The amount of the item
# + item - The attributes of the item
# + itemSubType - The sub type of the item
# + itemType - The type of the item
public type ItemElement record {
    decimal amount?;
    NsResource item?;
    string itemSubType?;
    string itemType?;
};

# Represents the `AddressBook` NetSuite sub record.
#
# + links - The HATEOAS record links
# + items - The collection of items
# + totalResults - The total of the available items
# + count - The amount of items stated in the collection out of all
# + hasMore - The state of item availability
# + offset - The starting point of the items
public type AddressbookCollection record {|
    Link[] links?;
    AddressElement[] items?;
    int totalResults?;
    int count?;
    boolean hasMore?;
    int offset?;
|};

# Represents the `AddressbookCollection` NetSuite element.
#
# + links - The HATEOAS record links
# + addressBookAddress - The attributes of the item
# + addressId - The string ID of the address element
# + defaultBilling - Whether the value is the default billing address or not
# + defaultShipping - Whether the value is the default shipping address or not
# + id - The ID of the address element
# + internalId - The internal ID of the address element
# + label - The address label
public type AddressElement record {
    Link[] links?;
    AddressbookAddress addressBookAddress?;
    string addressId?;
    boolean defaultBilling?;
    boolean defaultShipping?;
    int id?;
    int internalId?;
    string label?;
};

# Represents the `AddressbookAddress` NetSuite sub record.
# |                                                                                     |
# |:------------------------------------------------------------------------------------|
# | links - The HATEOAS record links                                                    |
# | id - The location number                                                            |
# | addr1 - The first part of the address                                               |
# | addr2 - The second part of the address                                              |
# | addr3 - The third part of the address                                               |
# | addrText - The complete address                                                     |
# | addressee - The name of the entity, which should appear                             |
# | addressformat - The format of the address                                           |
# | attention - The name of the addressed person                                        |
# | city - The city to be used in the address                                           |
# | state - The company's state or province                                             |
# | zip - The postal code                                                               |
# | country - The country to be used in the address                                     |
# | override - The free-form address text field is overridden by the other address if `true`   |
#
# + addressbookAddressType - the description of the `AddressbookAddress` type
public type AddressbookAddress record {
    *Address;
    string addressbookAddressType?;
};

# Represents the `ShippingAddress` NetSuite sub record.
# |                                                                                     |
# |:------------------------------------------------------------------------------------|
# | links - The HATEOAS record links                                                    |
# | id - The location number                                                            |
# | addr1 - The first part of the address                                               |
# | addr2 - The second part of the address                                              |
# | addr3 - The third part of the address                                               |
# | addrText - The complete address                                                     |
# | addressee - The name of the entity, which should appear                             |
# | addressformat - The format of the address                                           |
# | attention - The name of the addressed person                                        |
# | city - The city to be used in the address                                           |
# | state - The company's state or province                                             |
# | zip - The postal code                                                               |
# | country - The country to be used in the address                                     |
# | override - The free-form address text field is overridden by the other address if `true`   |
#
# + shippingAddressType - the description of the `ShippingAddress` type
public type ShippingAddress record {
    *Address;
    string shippingAddressType?;
};

# Represents the `BillingAddress` NetSuite sub record.
# |                                                                                     |
# |:------------------------------------------------------------------------------------|
# | links - The HATEOAS record links                                                    |
# | id - The location number                                                            |
# | addr1 - The first part of the address                                               |
# | addr2 - The second part of the address                                              |
# | addr3 - The third part of the address                                               |
# | addrText - The complete address                                                     |
# | addressee - The name of the entity, which should appear                             |
# | addressformat - The format of the address                                           |
# | attention - The name of the addressed person                                        |
# | city - The city to be used in the address                                           |
# | state - The company's state or province                                             |
# | zip - The postal code                                                               |
# | country - The country to be used in the address                                     |
# | override - The free-form address text field is overridden by the other address if `true`   |
#
# + billingaddressType - the description of the `BillingAddress` type
public type BillingAddress record {
    *Address;
    string billingaddressType?;
};

# Represents the `Visuals` NetSuite sub record.
#
# + links - The HATEOAS record links
# + items - The collection of `VisualsElements`
# + totalResults - The total of the available items
# + count - The amount of items stated in the collection out of all the items
# + hasMore - The state of item availability
# + offset - The starting point of the items
public type VisualsCollection record {
    Link[] links?;
    VisualsElement[] items;
    int totalResults?;
    int count?;
    boolean hasMore?;
    int offset?;
};

# Represents the `VisualsElement` NetSuite element.
#
# + links - The HATEOAS record links
# + flags - The element flag
# + location - The URL
# + refName - The reference name
public type VisualsElement record {
    Link[] links?;
    string flags?;
    string location?;
    string refName?;
};

# Represents the `Currencylist` NetSuite sub record.
#
# + links - The HATEOAS record links
# + items - The collection of `Currencylist`
# + totalResults - The total of the available items
# + count - The amount of items stated in the collection out of all the items
# + hasMore - The state of item availability
# + offset - The starting point of the items
public type CurrencylistCollection record {|
    Link[] links?;
    CurrencylistElement[] items?;
    int totalResults?;
    int count?;
    boolean hasMore?;
    int offset?;
|};

# Represents the `CurrencylistElement` NetSuite element.
#
# + links - The HATEOAS record links
# + currency - The associated `Currency`
# + refName - The reference name
# + balance - The currency balance
# + displaySymbol - The currency display symbol
public type CurrencylistElement record {
    Link[] links?;
    Currency currency?;
    string refName?;
    decimal balance?;
    string displaySymbol?;
};
