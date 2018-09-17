/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
 
 /**************************************************************************************
Name: UtilityBot_BatchResetVerificationCode
Version: 1.0 
Created Date: 07.02.2018
Function: Batch job to reset verification code on an account

Modification Log:
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
* Developer
* -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                  
*Original Version
**********************************************************************************************************************/
global class UtilityBot_BatchResetVerificationCode implements Database.Batchable<sObject> {
	
	String query;
	
	global UtilityBot_BatchResetVerificationCode() {
		
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		
		//Get all Multi Office
		query = 'Select Id, Verification_Code__c, Code_CleanUp_Time__c ' + 
		        'from Contact WHERE Code_CleanUp_Time__c>10';

    //check object access        
    if(Schema.sObjectType.Contact.isAccessible() && 
       Schema.sObjectType.Contact.fields.Id.isAccessible() && 
       Schema.sObjectType.Contact.fields.Verification_Code__c.isAccessible() && 
       Schema.sObjectType.Contact.fields.Code_CleanUp_Time__c.isAccessible()){
      return Database.getQueryLocator(query);
    }
    else{
      return null;
    }

	}

    global void execute(Database.BatchableContext BC, List<Contact> scope) {
    
    	List<Contact> contactsToUpdate = new List<Contact>();
      
      if(Schema.sObjectType.Contact.isUpdateable() && 
        Schema.sObjectType.Contact.fields.Verification_Code__c.isUpdateable()){
        for(Contact con : scope){
            con.Verification_Code__c = '';
            contactsToUpdate.add(con);
        }
        
        update contactsToUpdate;
      }
    
    }
	
	global void finish(Database.BatchableContext BC) {
	    if(!Test.isRunningTest()){
            System.scheduleBatch(new UtilityBot_BatchResetVerificationCode(), 'VerificationCodeResetJob', 60);
        }
	}
	
}