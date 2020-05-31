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
# + amount - The amount of the item
# + item - The attributes of the item
# + itemSubType - The sub type of the item
# + itemType - The type of the item
public type ItemElement record {
    float amount;
    NsResource item;
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
public type AddressbookCollection record {
    Link[] links?;
    AddressElement[] items;
    int totalResults?;
    int count?;
    boolean hasMore?;
    int offset?;
};

# Represents the `AddressbookCollection` NetSuite element.
#
# + links - The HATEOAS record links
# + addressbookaddress - The attributes of the item
# + addressId - The string id of the address element
# + defaultBilling - Whether the default billing address
# + defaultShipping - Whether the default shipping address
# + id - The id of the address element
# + internalId - The internal id of the address element
# + label - The address label
public type AddressElement record {
    Link[] links?;
    AddressbookAddress addressbookaddress;
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
# | addr1 - A part of the address                                                       |
# | addr2 - A part of the address                                                       |
# | addr3 - A part of the address                                                       |
# | addrText - The complete address                                                     |
# | addressee - The name of the entity that should appeared.                            |
# | addressformat - The format of the address                                           |
# | attention - The name of the addressed person                                        |
# | city - The city to be used in the address                                           |
# | state - The company's state or the province                                         |
# | zip - The postal code                                                               |
# | country - The country to be used in the address                                     |
# | override - The free-form address text field is overriden by other address if true   |
#
# + addressbookAddressType - the description of `AddressbookAddress` Type
public type AddressbookAddress record {
    *Address;
    string addressbookAddressType?;
};

# Represents the `ShippingAddress` NetSuite sub record.
# |                                                                                     |
# |:------------------------------------------------------------------------------------|
# | links - The HATEOAS record links                                                    |
# | id - The location number                                                            |
# | addr1 - A part of the address                                                       |
# | addr2 - A part of the address                                                       |
# | addr3 - A part of the address                                                       |
# | addrText - The complete address                                                     |
# | addressee - The name of the entity that should appeared.                            |
# | addressformat - The format of the address                                           |
# | attention - The name of the addressed person                                        |
# | city - The city to be used in the address                                           |
# | state - The company's state or the province                                         |
# | zip - The postal code                                                               |
# | country - The country to be used in the address                                     |
# | override - The free-form address text field is overriden by other address if true   |
#
# + shippingAddressType - the description of `ShippingAddress` Type
public type ShippingAddress record {
    *Address;
    string shippingAddressType?;
};

# Represents the `BillingAddress` NetSuite sub record.
# |                                                                                     |
# |:------------------------------------------------------------------------------------|
# | links - The HATEOAS record links                                                    |
# | id - The location number                                                            |
# | addr1 - A part of the address                                                       |
# | addr2 - A part of the address                                                       |
# | addr3 - A part of the address                                                       |
# | addrText - The complete address                                                     |
# | addressee - The name of the entity that should appeared.                            |
# | addressformat - The format of the address                                           |
# | attention - The name of the addressed person                                        |
# | city - The city to be used in the address                                           |
# | state - The company's state or the province                                         |
# | zip - The postal code                                                               |
# | country - The country to be used in the address                                     |
# | override - The free-form address text field is overriden by other address if true   |
#
# + billingaddressType - the description of `BillingAddress` Type
public type BillingAddress record {
    *Address;
    string billingaddressType?;
};

# Represents the `Visuals` NetSuite sub record.
#
# + links - The HATEOAS record links
# + items - The collection of VisualsElements
# + totalResults - The total of the available items
# + count - The amount of items stated in the collection out of all
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
# + items - The collection of currencylist
# + totalResults - The total of the available items
# + count - The amount of items stated in the collection out of all
# + hasMore - The state of item availability
# + offset - The starting point of the items
public type CurrencylistCollection record {
    Link[] links?;
    CurrencylistElement[] items;
    int totalResults?;
    int count?;
    boolean hasMore?;
    int offset?;
};

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
    float balance?;
    string displaySymbol?;
};
