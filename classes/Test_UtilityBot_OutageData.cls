/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
 
/**************************************************************************************
Name: Test_UtilityBot_OutageData
Version: 1.0 
Created Date: 07.02.2018
Function: Test class for UtilityBot_OutageData class

Modification Log:
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
* Description
* -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                  
* Original Version
*************************************************************************************/
@IsTest
private with sharing class Test_UtilityBot_OutageData {

 /** Scenario 1: 
  * Outage found in the given zip code
  */
  @isTest
  private static void shouldGetOutage(){

    //Account
    UtilityBot_TestHelper.AccountBuilder accountBuilder = new UtilityBot_TestHelper.AccountBuilder();
    Account acct = accountBuilder.build().save().getRecord(); 
    
    //Contact tied to the account
    UtilityBot_TestHelper.ContactBuilder contactBuilder = new UtilityBot_TestHelper.ContactBuilder();
    Contact con = contactBuilder.build().withAccount(acct.Id).save().getRecord();

    //Service Area
    UtilityBot_TestHelper.ServiceAreaBuilder serviceAreaBuilder = new UtilityBot_TestHelper.ServiceAreaBuilder();
    Service_Area__c sa = serviceAreaBuilder.build().withZipCode('98756').save().getRecord();
        
    //Outage
    UtilityBot_TestHelper.OutageBuilder outageBuilder = new UtilityBot_TestHelper.OutageBuilder();
    Outage__c outage = outageBuilder.build().withZipCode('98756').save().getRecord();
    
    test.startTest();
    
    //Create the input parameter class instance
    UtilityBot_OutageData.OutageInput input = new UtilityBot_OutageData.OutageInput();
    input.sZipcode = '98756';
    
    //Create the output parameter list
    List<UtilityBot_OutageData.OutageOutput> outputList = UtilityBot_OutageData.getOutagesForZipCodes(new List<UtilityBot_OutageData.OutageInput>{input});
    
    test.stopTest();
    
    //Validate results
    System.assert(outputList!=null && !outputList.isEmpty() && outputList.size() == 1);
    System.assertEquals(outage.Id, outputList[0].sOutageId);
    System.assert(!outputList[0].bNoOutage);
    System.assert(outputList[0].bZipcodeInServiceArea);
    System.assert(String.isNotBlank((outputList[0].sOutageMessage)));

  }

 /** Scenario 2: 
  * Outage Not found in the given zip code
  */
  @isTest
  private static void shouldNotGetOutage(){

    //Account
    UtilityBot_TestHelper.AccountBuilder accountBuilder = new UtilityBot_TestHelper.AccountBuilder();
    Account acct = accountBuilder.build().save().getRecord(); 
    
    //Contact tied to the account
    UtilityBot_TestHelper.ContactBuilder contactBuilder = new UtilityBot_TestHelper.ContactBuilder();
    Contact con = contactBuilder.build().withAccount(acct.Id).save().getRecord();

    //Service Areas
    UtilityBot_TestHelper.ServiceAreaBuilder serviceAreaBuilder = new UtilityBot_TestHelper.ServiceAreaBuilder();
    Service_Area__c sa1 = serviceAreaBuilder.build().withZipCode('98756').getRecord();
    Service_Area__c sa2 = serviceAreaBuilder.build().withZipCode('44554').getRecord();
    
    List<Service_Area__c> saList = new List<Service_Area__c>{sa1, sa2};
    
    //Insert service areas
    insert saList;
        
    //Outage
    UtilityBot_TestHelper.OutageBuilder outageBuilder = new UtilityBot_TestHelper.OutageBuilder();
    Outage__c outage = outageBuilder.build().withZipCode('98756').save().getRecord();
    
    test.startTest();
    
    //Create the input parameter class instance
    UtilityBot_OutageData.OutageInput input = new UtilityBot_OutageData.OutageInput();
    input.sZipcode = '44554';
    
    //Create the output parameter list
    List<UtilityBot_OutageData.OutageOutput> outputList = UtilityBot_OutageData.getOutagesForZipCodes(new List<UtilityBot_OutageData.OutageInput>{input});
    
    test.stopTest();
    
    //Validate results
    System.assert(outputList!=null && !outputList.isEmpty() && outputList.size() == 1);
    System.assert(String.isEmpty(outputList[0].sOutageId));
    System.assert(outputList[0].bNoOutage);
    System.assert(outputList[0].bZipcodeInServiceArea);
    System.assert(String.isNotBlank((outputList[0].sOutageMessage)));

  }
  
 /** Scenario 3: 
  * Zipcode not in service area
  */
  @isTest
  private static void shouldTellZipcodeNotInServiceArea(){

    //Account
    UtilityBot_TestHelper.AccountBuilder accountBuilder = new UtilityBot_TestHelper.AccountBuilder();
    Account acct = accountBuilder.build().save().getRecord(); 
    
    //Contact tied to the account
    UtilityBot_TestHelper.ContactBuilder contactBuilder = new UtilityBot_TestHelper.ContactBuilder();
    Contact con = contactBuilder.build().withAccount(acct.Id).save().getRecord();

    //Service Area
    UtilityBot_TestHelper.ServiceAreaBuilder serviceAreaBuilder = new UtilityBot_TestHelper.ServiceAreaBuilder();
    Service_Area__c sa = serviceAreaBuilder.build().withZipCode('98756').save().getRecord();
        
    //Outage
    UtilityBot_TestHelper.OutageBuilder outageBuilder = new UtilityBot_TestHelper.OutageBuilder();
    Outage__c outage = outageBuilder.build().withZipCode('98756').save().getRecord();
    
    test.startTest();
    
    //Create the input parameter class instance
    UtilityBot_OutageData.OutageInput input = new UtilityBot_OutageData.OutageInput();
    input.sZipcode = '44544';
    
    //Create the output parameter list
    List<UtilityBot_OutageData.OutageOutput> outputList = UtilityBot_OutageData.getOutagesForZipCodes(new List<UtilityBot_OutageData.OutageInput>{input});
    
    test.stopTest();
    
    //Validate results
    System.assert(outputList!=null && !outputList.isEmpty() && outputList.size() == 1);
    System.assert(String.isEmpty(outputList[0].sOutageId));
    System.assert(!outputList[0].bZipcodeInServiceArea);
    System.assert(String.isNotBlank((outputList[0].sOutageMessage)));

  }  
}