/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
 
/**************************************************************************************
Name: Test_UtilityBot_ContactCases
Version: 1.0 
Created Date: 07.02.2018
Function: Test class for UtilityBot_ContactCases class

Modification Log:
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
* Description
* -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                  
* Original Version
*************************************************************************************/
@IsTest
private with sharing class Test_UtilityBot_ContactCases {

 /** Scenario 1: 
  * Fetch cases for the given contact
  */
  @isTest
  private static void shouldFetchCases(){

    //Account
    UtilityBot_TestHelper.AccountBuilder accountBuilder = new UtilityBot_TestHelper.AccountBuilder();
    Account acct = accountBuilder.build().save().getRecord(); 
    
    //Contact tied to the account
    UtilityBot_TestHelper.ContactBuilder contactBuilder = new UtilityBot_TestHelper.ContactBuilder();
    Contact con = contactBuilder.build().withAccount(acct.Id).save().getRecord();
    
    //Case
    UtilityBot_TestHelper.CaseBuilder caseBuilder = new UtilityBot_TestHelper.CaseBuilder();
    Case newCase = caseBuilder.build().withContact(con.Id).withReason(UtilityBot_Constants.CASE_REASON_TRANSFER).withType(UtilityBot_Constants.CASE_TYPE_SERVICE_REQUEST).save().getRecord();

    test.startTest();
    
    //Call the method.
    List<List<Case>> casesList = UtilityBot_ContactCases.getCases(new List<String>{String.valueOf(con.Id)});
    
    test.stopTest();
    
    //Validate results
    System.assert(casesList!=null && !casesList.isEmpty() && casesList.size() == 1);
    
    System.assert(casesList[0]!=null && !casesList[0].isEmpty() && casesList[0].size() == 1);
    
    //Check fields
    System.assertEquals('New', casesList[0][0].Status);
    System.assertEquals(newCase.Reason, casesList[0][0].Reason);
  }

 /** Scenario 2: 
  * No cases fetched for the given contact
  */
  @isTest
  private static void shouldNotFetchCases(){
    //Account
    UtilityBot_TestHelper.AccountBuilder accountBuilder = new UtilityBot_TestHelper.AccountBuilder();
    Account acct = accountBuilder.build().save().getRecord(); 
    
    //Contact tied to the account
    UtilityBot_TestHelper.ContactBuilder contactBuilder = new UtilityBot_TestHelper.ContactBuilder();
    Contact con1 = contactBuilder.build().withAccount(acct.Id).save().getRecord();
    Contact con2 = contactBuilder.build().withAccount(acct.Id).withFirstName('Jon').withLastName('Snow').withEmail('jsnow@nw.tst').save().getRecord();
    
    //Case
    UtilityBot_TestHelper.CaseBuilder caseBuilder = new UtilityBot_TestHelper.CaseBuilder();
    Case newCase = caseBuilder.build().withContact(con1.Id).withReason(UtilityBot_Constants.CASE_REASON_TRANSFER).withType(UtilityBot_Constants.CASE_TYPE_SERVICE_REQUEST).save().getRecord();

    test.startTest();
    
    //Call the method.
    List<List<Case>> casesList = UtilityBot_ContactCases.getCases(new List<String>{String.valueOf(con2.Id)});
    
    test.stopTest();
    
    //Validate results
    System.assert(casesList!=null && !casesList.isEmpty() && casesList.size() == 1);
    System.assert(casesList[0]==null || casesList[0].isEmpty());
  }
}