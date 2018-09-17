/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
 
/**************************************************************************************
Name: UtilityBot_ContactCases
Version: 1.0 
Created Date: 07.02.2018
Function: Class used to get cases for a contact

Modification Log:
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
* Developer
* -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                  
*Original Version
**********************************************************************************************************************/
public with sharing class UtilityBot_ContactCases {
    
    @InvocableMethod(label='Get cases' description='Returns a list of cases for the contact')
    public static List<List<Case>> getCases(List<String> contactId) {

        List<List<Case>> contactCases = new List<List<Case>>();

        //Check Object access
        if(Schema.sObjectType.Case.isAccessible() && 
           Schema.sObjectType.Case.fields.Id.isAccessible() && 
           Schema.sObjectType.Case.fields.CaseNumber.isAccessible() && 
           Schema.sObjectType.Case.fields.Reason.isAccessible() && 
           Schema.sObjectType.Case.fields.Status.isAccessible() && 
           Schema.sObjectType.Case.fields.CreatedDate.isAccessible() && 
           Schema.sObjectType.Case.fields.Type.isAccessible() && 
           Schema.sObjectType.Case.fields.ContactId.isAccessible()){

            List<Case> cases = [select Id,
                                       CaseNumber,
                                       Reason,
                                       Status
                                from Case 
                                where CreatedDate = LAST_N_DAYS:30 
                                and Type = :UtilityBot_Constants.CASE_TYPE_SERVICE_REQUEST 
                                and ContactId = :contactId[0]
                                order by CreatedDate DESC
                                limit 5];
            
            contactCases.add(cases);            

        }

        return contactCases;
    }
}