/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
 
/**************************************************************************************
Name: Test_UtilityBot_UsageInformation
Version: 1.0 
Created Date: 07.02.2018
Function: Test class for UtilityBot_UsageInformation class

Modification Log:
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
* Description
* -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                  
* Original Version
*************************************************************************************/
@IsTest
private with sharing class Test_UtilityBot_UsageInformation {

 /** Scenario 1: 
  * Usage information for a given account should be fetched. User has paid the bill
  */
  @isTest
  private static void shouldGetUsageInformationBillPaid(){

    //Account
    UtilityBot_TestHelper.AccountBuilder accountBuilder = new UtilityBot_TestHelper.AccountBuilder();
    Account acct = accountBuilder.build().save().getRecord(); 
    
    //Consumption
    UtilityBot_TestHelper.ConsumptionBuilder consumptionBuilder = new UtilityBot_TestHelper.ConsumptionBuilder();
    Consumption__c outage = consumptionBuilder.build().withAccount(acct.Id).withBillPaid(true).save().getRecord();

    test.startTest();
    
    //Create the input parameter class instance
    UtilityBot_UsageInformation.UsageInput input = new UtilityBot_UsageInformation.UsageInput();
    input.sAccountId        = acct.Id;
    
    //Create the output parameter list
    List<UtilityBot_UsageInformation.UsageOutput> outputList = UtilityBot_UsageInformation.getUsageInformation(new List<UtilityBot_UsageInformation.UsageInput>{input});
    
    test.stopTest();
    
    //Validate results
    System.assert(outputList!=null && !outputList.isEmpty() && outputList.size() == 1);
    
    //Check fields
    System.assert(String.isNotBlank(outputList[0].sUsageInformation));
    System.assert(outputList[0].sUsageInformation.contains('paid'));
    System.assertEquals(UtilityBot_Constants.NO_ERROR, outputList[0].sErrorMessage);

  }

 /** Scenario 1: 
  * Usage information for a given account should be fetched. User has paid the bill
  */
  @isTest
  private static void shouldGetUsageInformationBillDue(){

    //Account
    UtilityBot_TestHelper.AccountBuilder accountBuilder = new UtilityBot_TestHelper.AccountBuilder();
    Account acct = accountBuilder.build().save().getRecord(); 
    
    //Consumption
    UtilityBot_TestHelper.ConsumptionBuilder consumptionBuilder = new UtilityBot_TestHelper.ConsumptionBuilder();
    Consumption__c outage = consumptionBuilder.build().withAccount(acct.Id).withBillPaid(false).save().getRecord();

    test.startTest();
    
    //Create the input parameter class instance
    UtilityBot_UsageInformation.UsageInput input = new UtilityBot_UsageInformation.UsageInput();
    input.sAccountId        = acct.Id;
    
    //Create the output parameter list
    List<UtilityBot_UsageInformation.UsageOutput> outputList = UtilityBot_UsageInformation.getUsageInformation(new List<UtilityBot_UsageInformation.UsageInput>{input});
    
    test.stopTest();
    
    //Validate results
    System.assert(outputList!=null && !outputList.isEmpty() && outputList.size() == 1);
    
    //Check fields
    System.assert(String.isNotBlank(outputList[0].sUsageInformation));
    System.assert(outputList[0].sUsageInformation.contains('due'));
    System.assertEquals(UtilityBot_Constants.NO_ERROR, outputList[0].sErrorMessage);

  }  
}