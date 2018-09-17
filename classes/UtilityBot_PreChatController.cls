/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
 
/**************************************************************************************
Name: UtilityBot_PreChatController
Version: 1.0 
Function: Controller for the UtilityChatPreChat lightning component. 

Modification Log: 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
Description
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
Original Version
*************************************************************************************/
public with sharing class UtilityBot_PreChatController {
    
    @AuraEnabled
    public static void setCommunityLoggedInField(String firstName, String lastName, String email) {

        if(Schema.sObjectType.Contact.isAccessible() && 
           Schema.sObjectType.Contact.fields.Id.isAccessible() && 
           Schema.sObjectType.Contact.fields.Community_User_Logged_In__c.isAccessible() && 
           Schema.sObjectType.Contact.fields.FirstName.isAccessible() && 
           Schema.sObjectType.Contact.fields.LastName.isAccessible() && 
           Schema.sObjectType.Contact.fields.Email.isAccessible()){
            //Get the contact based on the passed parameters
            List<Contact> userContact = [Select Id,
                                                Community_User_Logged_In__c 
                                         From Contact 
                                         Where FirstName = :firstName 
                                         And LastName = :lastName 
                                         And Email = :email];
                                         
            //Contact found
            if(userContact!=null && !userContact.isEmpty()){
                if(Schema.sObjectType.Contact.isUpdateable() && 
                   Schema.sObjectType.Contact.fields.Community_User_Logged_In__c.isUpdateable()){
                    userContact[0].Community_User_Logged_In__c = true;
                    update userContact;
                }
            }
        }

    }

}