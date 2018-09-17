/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
 
/**************************************************************************************
Name: Test_UtilityBot_BatchResetVerificationCode
Version: 1.0 
Created Date: 07.02.2018
Function: Test class for UtilityBot_BatchResetVerificationCode class

Modification Log:
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
* Description
* -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                  
* Original Version
*************************************************************************************/
@isTest
private with sharing class Test_UtilityBot_BatchResetVerCode {

    public static testMethod void testBatch() {
        
    //Account
    UtilityBot_TestHelper.AccountBuilder accountBuilder = new UtilityBot_TestHelper.AccountBuilder();
    Account acct = accountBuilder.build().save().getRecord(); 
    
    //Contact tied to the account
    UtilityBot_TestHelper.ContactBuilder contactBuilder = new UtilityBot_TestHelper.ContactBuilder();

    
    // Create 200 test contacts - this simulates one execute.  
       List <Contact> cons = new List<Contact>();
          for(integer i = 0; i<200; i++){
            Contact con = contactBuilder.build().withAccount(acct.Id).withVerificationCode(String.valueOf(i)).withCodeSetTime(DateTime.now().addHours(-2)).getRecord();
             cons.add(con);
          }
       
       insert cons;
       
       Test.StartTest();
       UtilityBot_BatchResetVerificationCode resetCode = new UtilityBot_BatchResetVerificationCode();
       ID batchprocessid = Database.executeBatch(resetCode);
       Test.StopTest();
    
       System.AssertEquals(
               database.countquery('SELECT COUNT()'
                  +' FROM Contact WHERE Verification_Code__c=null'),
               200);  
       
   }
}