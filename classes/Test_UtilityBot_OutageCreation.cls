/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
 
/**************************************************************************************
Name: Test_UtilityBot_OutageCreation
Version: 1.0 
Created Date: 07.02.2018
Function: Test class for UtilityBot_OutageCreation class

Modification Log:
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
* Description
* -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                  
* Original Version
*************************************************************************************/
@IsTest
private with sharing class Test_UtilityBot_OutageCreation {

 /** Scenario 1: 
  * Creates an Outage for a given contact and zipcode
  */
  @isTest
  private static void shouldCreateOutage(){

    //Account
    UtilityBot_TestHelper.AccountBuilder accountBuilder = new UtilityBot_TestHelper.AccountBuilder();
    Account acct = accountBuilder.build().save().getRecord(); 
    
    //Contact tied to the account
    UtilityBot_TestHelper.ContactBuilder contactBuilder = new UtilityBot_TestHelper.ContactBuilder();
    Contact con = contactBuilder.build().withAccount(acct.Id).save().getRecord();
    
    test.startTest();
    
    //Create the input parameter class instance
    UtilityBot_OutageCreation.OutageInput input = new UtilityBot_OutageCreation.OutageInput();
    input.sContactId        = con.Id;
    input.sZipcode          = '78956';
    
    //Create the output parameter list
    List<UtilityBot_OutageCreation.OutageOutput> outputList = UtilityBot_OutageCreation.createOutage(new List<UtilityBot_OutageCreation.OutageInput>{input});
    
    test.stopTest();
    
    //Validate results
    System.assert(outputList!=null && !outputList.isEmpty() && outputList.size() == 1);
    
    //Get the Outage
    Outage__c reportedOutage = [Select Id,
                                       Cause__c,
                                       ZipCode__c,
                                       Status__c,
                                       First_Reported_By__c
                                From Outage__c
                                where Id = :outputList[0].sOutageId];
    
    //Check if record was created
    System.assert(reportedOutage!=null);
    
    //Check fields
    System.assertEquals(UtilityBot_Constants.OUTAGE_CAUSE_UNKNOWN, reportedOutage.Cause__c);
    System.assertEquals(input.sZipcode, reportedOutage.ZipCode__c);
    System.assertEquals(UtilityBot_Constants.OUTAGE_STATUS_INVESTIGATING, reportedOutage.Status__c);
    System.assertEquals(input.sContactId, reportedOutage.First_Reported_By__c);

  }
}