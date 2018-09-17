/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
 
/**************************************************************************************
Name: Test_UtilityBot_PreChatController
Version: 1.0 
Created Date: 07.02.2018
Function: Test class for UtilityBot_PreChatController class

Modification Log:
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
* Description
* -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                  
* Original Version
*************************************************************************************/
@IsTest
private with sharing class Test_UtilityBot_PreChatController {

 /** Scenario 1: 
  * Contact is found and Community_Logged_In__c field is set
  */
  @isTest
  private static void shouldSetLoggedInField(){

    //Account
    UtilityBot_TestHelper.AccountBuilder accountBuilder = new UtilityBot_TestHelper.AccountBuilder();
    Account acct = accountBuilder.build().save().getRecord(); 
    
    //Contact tied to the account
    UtilityBot_TestHelper.ContactBuilder contactBuilder = new UtilityBot_TestHelper.ContactBuilder();
    Contact con = contactBuilder.build().withAccount(acct.Id).save().getRecord();

    test.startTest();
    
    //Call the static method with required parametes
    UtilityBot_PreChatController.setCommunityLoggedInField('Ned', 'Stark', 'nstark@winterfell.tst');
    
    test.stopTest();
    
    //Query the contact to get the Community_User_Logged_In__c field
    Contact updatedContact = [Select Community_User_Logged_In__c from Contact where Id = :con.Id];
    
    //Validate results for Account
    System.assert(updatedContact!=null);
    System.assert(updatedContact.Community_User_Logged_In__c);
  }

 /** Scenario 2: 
  *  Contact is not found and Community_Logged_In__c field is not set
  */
  @isTest
  private static void shouldNotSetLoggedInField(){
      
    //Account
    UtilityBot_TestHelper.AccountBuilder accountBuilder = new UtilityBot_TestHelper.AccountBuilder();
    Account acct = accountBuilder.build().save().getRecord(); 
    
    //Contact tied to the account
    UtilityBot_TestHelper.ContactBuilder contactBuilder = new UtilityBot_TestHelper.ContactBuilder();
    Contact con = contactBuilder.build().withAccount(acct.Id).save().getRecord();

    test.startTest();
    
    //Call the static method with required parametes
    UtilityBot_PreChatController.setCommunityLoggedInField('Jon', 'Snow', 'jsnow@winterfell.tst');
    
    test.stopTest();
    
    //Query the contact to get the Community_User_Logged_In__c field
    Contact updatedContact = [Select Community_User_Logged_In__c from Contact where Id = :con.Id];
    
    //Validate results for Account
    System.assert(updatedContact!=null);
    System.assert(!updatedContact.Community_User_Logged_In__c);
  }
}