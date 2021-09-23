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

import ballerina/http;

isolated function mapNewVendorBillRecordFields(NewVendorBill vendorBill) returns string|error {
    string finalResult = EMPTY_STRING;
    map<anydata>|error vendorMap = vendorBill.cloneWithType(MapAnyData);
    if (vendorMap is map<anydata>) {
        string[] keys = vendorMap.keys();
        int position = 0;
        foreach var item in vendorBill {
            if (item is string|boolean|int|decimal) {
                finalResult += setSimpleType(keys[position], item, "tranPurch");
            } else if (item is RecordRef) {
                finalResult += getXMLRecordRef(<RecordRef>item);
            } else if (item is RecordInputRef) {
                finalResult += getXMLRecordInputRef(<RecordInputRef>item);
            } else if (item is CustomFieldList) {
                finalResult += check getCustomElementList(<CustomFieldList>item, "tranPurch");
            } else if (item is VendorBillExpenseList) {
                finalResult += check getXMLVendorBillExpenseList(<VendorBillExpenseList>item);
            } else if (item is AccountingBookDetailList) {
                finalResult += check getXMLAccountingBookDetailList(<AccountingBookDetailList>item);
            } else if (item is VendorBillItemList) {
                finalResult += check getXMLVendorBillItemList(<VendorBillItemList>item);
            } else if (item is Installment[]) {
                finalResult += check getXMLInstallmentList(<Installment[]>item);
            } else if (item is PurchLandedCostList) {
                finalResult += check getXMLPurchLandedCostList(<PurchLandedCostList>item);
            } else if (item is RecordRef[]) {
                finalResult += getXMLRecordRefList(<RecordRef[]>item);
            } else if (item is TaxDetailsList) {
                finalResult += getXMLTaxDetailsList(<TaxDetailsList>item);
            } else if (item is CustomFieldList) {
                finalResult += check getCustomElementList(<CustomFieldList>item, "tranPurch");
            }
            position += 1;
        }
    }
    return finalResult;
}

isolated function getXMLTaxDetailsList(TaxDetailsList taxDetailsList) returns string {
    string landedCostList = string `<tranPurch:taxDetailsList replaceAll="${taxDetailsList.replaceAll}"`;
    foreach TaxDetails tax in taxDetailsList.taxDetails {
        landedCostList += getXMLTaxDetails(tax);
    } 
    return landedCostList + "</tranPurch:taxDetailsList>";
}

isolated function getXMLTaxDetails(TaxDetails tax) returns string {
    string taxes = string `<platformCommon:taxDetails xmlns:platformCommon="urn:common_2020_2.platform.webservices.netsuite.com">`;
    map<anydata>|error taxMap = tax.cloneWithType(MapAnyData);
    if (taxMap is map<anydata>) {
        string[] keys = tax.keys();
        int position = 0;
        foreach var item in tax {
            if (item is string|boolean|int|decimal) {
                taxes += setSimpleType(keys[position], item, "platformCommon");
            } else if (item is RecordRef) {
                taxes += getXMLRecordRef(<RecordRef>item);
            }
            position += 1;
        }
    }
    return taxes + "</platformCommon:taxDetails>";
}

isolated function getXMLRecordRefList(RecordRef[] purchaseOrderList) returns string {
    string purchaseOrder = "<tranPurch:purchaseOrderList>";
    foreach RecordRef orderDetail in purchaseOrderList {
        purchaseOrder +=  getXMLRecordRef(orderDetail);
    } 
    return purchaseOrder + "</tranPurch:purchaseOrderList>";
}


isolated function getXMLPurchLandedCostList(PurchLandedCostList purchLandedCosts) returns string|error {
    string landedCostList = string `<tranPurch:landedCostsList replaceAll="${purchLandedCosts.replaceAll}">`;
    foreach LandedCostSummary landedCost in purchLandedCosts.landedCosts {
        landedCostList += check getXMLLandedCostSummary(landedCost);
    } 
    return landedCostList + "</tranPurch:landedCostsList>";
}

isolated function getXMLLandedCostSummary(LandedCostSummary landedCost) returns string|error {
    string landCostSummery = string `<platformCommon:landedCost xmlns:platformCommon="urn:common_2020_2.platform.webservices.netsuite.com">`;
    map<anydata>|error landCostMap = landedCost.cloneWithType(MapAnyData);
    if (landCostMap is map<anydata>) {
        string[] keys = landCostMap.keys();
        int position = 0;
        foreach var item in landedCost {
            if (item is string|boolean|int|decimal) {
                landCostSummery += setSimpleType(keys[position], item, "tranPurch");
            } else if (item is RecordRef) {
                landCostSummery += getXMLRecordRef(<RecordRef>item);
            }
            position += 1;
        }
    }
    return landCostSummery + "</platformCommon:landedCost>";
}

isolated function getXMLInstallmentList(Installment[] installments) returns string|error {
    string childElements = EMPTY_STRING;
    foreach Installment installment in installments {
        childElements += "<platformCommon:installment>";
        map<anydata>|error installmentsMap = installment.cloneWithType(MapAnyData);
        if (installmentsMap is map<anydata>) {
            string[] keys = installmentsMap.keys();
            int position = 0;
            foreach var item in installment {
                childElements += setSimpleType(keys[position], item, "platformCommon");
                position += 1;
            }
        }
        childElements += "</platformCommon:installment>";
    }
    return string `<tranPurch:installmentList xmlns:platformCommon="urn:common_2020_2.platform.webservices.netsuite.com">${childElements}</tranPurch:installmentList>`;
}

isolated function getXMLVendorBillItemList(VendorBillItemList billItemList) returns string|error {
    string itemList = string `<tranPurch:itemList replaceAll="${billItemList.replaceAll}">`;
    foreach VendorBillItem billItem in billItemList.item {
        itemList += check getXMLVendorBillItem(billItem);
    } 
    return itemList + "</tranPurch:itemList>";
}

isolated function getXMLVendorBillItem(VendorBillItem vbillItem) returns string|error {
    string billItem = string `<tranPurch:item>`;
    map<anydata>|error expenseMap = vbillItem.cloneWithType(MapAnyData);
    if (expenseMap is map<anydata>) {
        string[] keys = expenseMap.keys();
        int position = 0;
        foreach var item in vbillItem {
            if (item is string|boolean|int|decimal) {
                billItem += setSimpleType(keys[position], item, "tranPurch");
            } else if (item is RecordRef) {
                billItem += getXMLRecordRef(<RecordRef>item);
            } else if (item is InventoryAssignmentList) {
                billItem += check getXMLInventoryAssignmentList(<InventoryAssignmentList>item);
            }
            position += 1;
        }
    }
    return billItem + "</tranPurch:item>";
}

isolated function getXMLInventoryAssignmentList(InventoryAssignmentList inAssignmentList) returns string|error {
    string assignmentList = string `<tranPurch:inventoryDetail>`;
    foreach InventoryAssignment assignments in inAssignmentList.inventoryAssignment {
        assignmentList += check getXMLInventoryAssignments(assignments);
    } 
    if(inAssignmentList.customForm is RecordRef) {
        assignmentList += getXMLRecordRef(<RecordRef>inAssignmentList.customForm);
    }
    return assignmentList + "</tranPurch:inventoryDetail>";
}


isolated function getXMLInventoryAssignments(InventoryAssignment assignments) returns string|error {
    string assignmentsDetail = string `<platformCommon:inventoryAssignment xmlns:platformCommon="urn:common_2020_2.platform.webservices.netsuite.com">`;
    map<anydata>|error expenseMap = assignments.cloneWithType(MapAnyData);
    if (expenseMap is map<anydata>) {
        string[] keys = expenseMap.keys();
        int position = 0;
        foreach var item in assignments {
            if (item is string|boolean|int|decimal) {
                assignmentsDetail += setSimpleType(keys[position], item, "platformCommon");
            } else if (item is RecordRef) {
                assignmentsDetail += getXMLRecordRef(<RecordRef>item);
            }
            position += 1;
        }
    }
    return assignmentsDetail + "</platformCommon:inventoryAssignment>";
}

isolated function getXMLAccountingBookDetailList(AccountingBookDetailList accBookList) returns string|error {
    string accountingBookDetailList = string `<tranPurch:accountingBookDetailList replaceAll="${accBookList.replaceAll}">`;
    foreach AccountingBookDetail bookDetail in accBookList.accountingBookDetail {
        accountingBookDetailList += check getXMLAccountingBookDetail(bookDetail);
    } 
    return accountingBookDetailList + "</tranPurch:accountingBookDetailList>";
}

isolated function getXMLAccountingBookDetail(AccountingBookDetail accbookDetail) returns string|error {
    string bookDetails = string `<platformCommon:accountingBookDetail xmlns:platformCommon="urn:common_2020_2.platform.webservices.netsuite.com">`;
    map<anydata>|error expenseMap = accbookDetail.cloneWithType(MapAnyData);
    if (expenseMap is map<anydata>) {
        string[] keys = expenseMap.keys();
        int position = 0;
        foreach var item in accbookDetail {
            if (item is string|boolean|int|decimal) {
                bookDetails += setSimpleType(keys[position], item, "platformCommon");
            } else if (item is RecordRef) {
                bookDetails += getXMLRecordRef(<RecordRef>item);
            }
            position += 1;
        }
    }
    return bookDetails + "</platformCommon:accountingBookDetail>";
}

isolated function getXMLVendorBillExpenseList(VendorBillExpenseList expenseList) returns string|error {
    string vendorBillExpenselist = string `<tranPurch:expenseList replaceAll="${expenseList.replaceAll}">`;
    foreach VendorBillExpense expense in expenseList.expenses {
        vendorBillExpenselist += check getXMLVendorBillExpense(expense);
    } 
    return vendorBillExpenselist + "</tranPurch:expenseList>";
}

isolated function getXMLVendorBillExpense(VendorBillExpense billExpense) returns string|error {
    string expense = "<tranPurch:expense>";
    map<anydata>|error expenseMap = billExpense.cloneWithType(MapAnyData);
    if (expenseMap is map<anydata>) {
        string[] keys = expenseMap.keys();
        int position = 0;
        foreach var item in billExpense {
            if (item is string|boolean|int|decimal) {
                expense += setSimpleType(keys[position], item, "tranPurch");
            } else if (item is RecordRef) {
                expense += getXMLRecordRef(<RecordRef>item);
            } else if (item is RecordInputRef) {
                expense += getXMLRecordInputRef(<RecordInputRef>item);
            } else if (item is CustomFieldList) {
                expense += check getCustomElementList(<CustomFieldList>item, "tranPurch");
            }
            position += 1;
        }
    }
    return expense + "</tranPurch:expense>";
}

isolated function wrapVendorBillElements(string subElements) returns string {
    return string `<urn:record xsi:type="tranPurch:VendorBill" xmlns:tranPurch="urn:purchases_2020_2.transactions.webservices.netsuite.com">
            ${subElements}
        </urn:record>`;
}

isolated function getVendorBillResult(http:Response response) returns Vendor|error {
    xml payload = check formatPayload(response);
    if (response.statusCode == http:STATUS_OK) { 
        xml output  = payload/**/<status>;
        boolean isSuccess = check extractBooleanValueFromXMLOrText(output.isSuccess);
        if(isSuccess) {
            return mapVendorBillRecord(payload);
        } else {
            fail error(NO_RECORD_CHECK);
        }
    } else {
        fail error(payload.toString());
    }  
}

isolated function mapVendorBillRecord(xml payload) returns VendorBill {
    xmlns "urn:purchases_2020_2.transactions.webservices.netsuite.com" as tranPurch;
    VendorBill vendorBill = {
        internalId: extractRecordInternalIdFromXMLAttribute(payload/**/<'record>),
        subsidiary: extractRecordRefFromXML(payload/**/<tranPurch:subsidiary>),
        createdDate : extractStringFromXML(payload/**/<tranPurch:createdDate>/*),
        lastModifiedDate : extractStringFromXML(payload/**/<tranPurch:lastModifiedDate>/*),
        nexus: extractRecordRefFromXML(payload/**/<tranPurch:nexus>),
        subsidiaryTaxRegNum: extractRecordRefFromXML(payload/**/<tranPurch:subsidiaryTaxRegNum>),
        customForm: extractRecordRefFromXML(payload/**/<tranPurch:customForm>),
        billAddressList: extractRecordRefFromXML(payload/**/<tranPurch:billAddressList>),
        account: extractRecordRefFromXML(payload/**/<tranPurch:account>),
        approvalStatus: extractRecordRefFromXML(payload/**/<tranPurch:approvalStatus>),
        nextApprover: extractRecordRefFromXML(payload/**/<tranPurch:nextApprover>),
        vatRegNum : extractStringFromXML(payload/**/<tranPurch:vatRegNum>/*),
        postingPeriod: extractRecordRefFromXML(payload/**/<tranPurch:postingPeriod>),
        tranDate: extractRecordRefFromXML(payload/**/<tranPurch:tranDate>),
        currencyName : extractStringFromXML(payload/**/<tranPurch:currencyName>/*),
        exchangeRate: extractDecimalFromXML(payload/**/<tranPurch:exchangeRate>/*),
        entityTaxRegNum: extractRecordRefFromXML(payload/**/<tranPurch:entityTaxRegNum>),
        taxPointDate : extractStringFromXML(payload/**/<tranPurch:taxPointDate>/*),
        terms: extractRecordRefFromXML(payload/**/<tranPurch:terms>),
        dueDate : extractStringFromXML(payload/**/<tranPurch:dueDate>/*),
        discountDate : extractStringFromXML(payload/**/<tranPurch:discountDate>/*),
        tranId : extractStringFromXML(payload/**/<tranPurch:tranId>/*),
        userTotal: extractDecimalFromXML(payload/**/<tranPurch:userTotal>/*),
        discountAmount: extractDecimalFromXML(payload/**/<tranPurch:discountAmount>/*),
        taxTotal: extractDecimalFromXML(payload/**/<tranPurch:taxTotal>/*),
        memo : extractStringFromXML(payload/**/<tranPurch:memo>/*),
        tax2Total: extractDecimalFromXML(payload/**/<tranPurch:tax2Total>/*),
        creditLimit: extractDecimalFromXML(payload/**/<tranPurch:creditLimit>/*),
        availableVendorCredit: extractDecimalFromXML(payload/**/<tranPurch:availableVendorCredit>/*),
        currency: extractRecordRefFromXML(payload/**/<tranPurch:currency>),
        'class: extractRecordRefFromXML(payload/**/<tranPurch:'class>),
        department: extractRecordRefFromXML(payload/**/<tranPurch:department>),
        location: extractRecordRefFromXML(payload/**/<tranPurch:location>),
        status : extractStringFromXML(payload/**/<tranPurch:status>/*),
        landedCostMethod : extractStringFromXML(payload/**/<tranPurch:landedCostMethod>/*),
        transactionNumber : extractStringFromXML(payload/**/<tranPurch:transactionNumber>/*)
    };
    var customFields = extractCustomFiledListFromXML(payload/**/<tranPurch:customFieldList>/*);
    if (customFields is CustomFieldList) {
        vendorBill.customFieldList = customFields;
    }

    boolean|error value = extractBooleanValueFromXMLOrText(payload/**/<tranPurch:overrideInstallments>/*);
    if (value is boolean) {
        vendorBill.overrideInstallments = value;
    }

    value = extractBooleanValueFromXMLOrText(payload/**/<tranPurch:landedCostPerLine>/*);
    if (value is boolean) {
        vendorBill.landedCostPerLine = value;
    }

    value = extractBooleanValueFromXMLOrText(payload/**/<tranPurch:paymentHold>/*);
    if (value is boolean) {
        vendorBill.paymentHold = value;
    }

    value = extractBooleanValueFromXMLOrText(payload/**/<tranPurch:taxRegOverride>/*);
    if (value is boolean) {
        vendorBill.taxRegOverride = value;
    }

    value = extractBooleanValueFromXMLOrText(payload/**/<tranPurch:taxDetailsOverride>/*);
    if (value is boolean) {
        vendorBill.taxDetailsOverride = value;
    }
    return vendorBill;
}
