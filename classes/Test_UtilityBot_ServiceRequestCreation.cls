/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
 
/**************************************************************************************
Name: Test_UtilityBot_ServiceRequestCreation
Version: 1.0 
Created Date: 07.02.2018
Function: Test class for UtilityBot_ServiceRequestCreation class

Modification Log:
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
* Description
* -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                  
* Original Version
*************************************************************************************/
@IsTest
private with sharing class Test_UtilityBot_ServiceRequestCreation {

 /** Scenario 1: 
  * Transfer service request should be created
  */
  @isTest
  private static void shouldTransferServiceRequest(){

    //Account
    UtilityBot_TestHelper.AccountBuilder accountBuilder = new UtilityBot_TestHelper.AccountBuilder();
    Account acct = accountBuilder.build().save().getRecord(); 
    
    //Contact tied to the account
    UtilityBot_TestHelper.ContactBuilder contactBuilder = new UtilityBot_TestHelper.ContactBuilder();
    Contact con = contactBuilder.build().withAccount(acct.Id).save().getRecord();

    test.startTest();
    
    //Create the input parameter class instance
    UtilityBot_ServiceRequestCreation.SRInput input = new UtilityBot_ServiceRequestCreation.SRInput();
    input.sContactId         = con.Id;
    input.sServiceType       = UtilityBot_Constants.SERVICE_TYPE_TRANSFER;
    input.sNewServiceAddress = '678 First St, San Jose, CA 12345';
    input.dtServiceStartDate = DateTime.now().addDays(2);
    input.dtServiceStopDate  = DateTime.now().addDays(1);
    
    //Create the output parameter list
    List<UtilityBot_ServiceRequestCreation.SROutput> outputList = UtilityBot_ServiceRequestCreation.createServiceRequest(new List<UtilityBot_ServiceRequestCreation.SRInput>{input});
    
    test.stopTest();
    
    //Validate results
    System.assert(outputList!=null && !outputList.isEmpty() && outputList.size() == 1 && String.isNotBlank(outputList[0].sCaseNumber));
    
    //Get the case
    Case srCase = [Select Id,
                          New_Service_Address__c,
                          Service_Start_Date__c,
                          Service_End_Date__c,
                          Reason,
                          ContactId,
                          Type
                     From Case 
                     where CaseNumber = :outputList[0].sCaseNumber];
    
    //Check if record was created
    System.assert(srCase!=null);
    
    //Check fields
    System.assertEquals(input.sNewServiceAddress, srCase.New_Service_Address__c);
    System.assertEquals(input.dtServiceStartDate, srCase.Service_Start_Date__c);
    System.assertEquals(input.dtServiceStopDate, srCase.Service_End_Date__c);
    System.assertEquals(UtilityBot_Constants.CASE_REASON_TRANSFER, srCase.Reason);
    System.assertEquals(con.Id, srCase.ContactId);    
    System.assertEquals(UtilityBot_Constants.CASE_TYPE_SERVICE_REQUEST, srCase.Type);
  }

 /** Scenario 2: 
  *  Stop service request should be created
  */
  @isTest
  private static void shouldStopServiceRequest(){
    //Account
    UtilityBot_TestHelper.AccountBuilder accountBuilder = new UtilityBot_TestHelper.AccountBuilder();
    Account acct = accountBuilder.build().save().getRecord(); 
    
    //Contact tied to the account
    UtilityBot_TestHelper.ContactBuilder contactBuilder = new UtilityBot_TestHelper.ContactBuilder();
    Contact con = contactBuilder.build().withAccount(acct.Id).save().getRecord();

    test.startTest();
    
    //Create the input parameter class instance
    UtilityBot_ServiceRequestCreation.SRInput input = new UtilityBot_ServiceRequestCreation.SRInput();
    input.sContactId         = con.Id;
    input.sServiceType       = UtilityBot_Constants.SERVICE_TYPE_STOP;
    input.dtServiceStopDate  = DateTime.now().addDays(1);
    
    //Create the output parameter list
    List<UtilityBot_ServiceRequestCreation.SROutput> outputList = UtilityBot_ServiceRequestCreation.createServiceRequest(new List<UtilityBot_ServiceRequestCreation.SRInput>{input});
    
    test.stopTest();
    
    //Validate results
    System.assert(outputList!=null && !outputList.isEmpty() && outputList.size() == 1 && String.isNotBlank(outputList[0].sCaseNumber));
    
    //Get the case
    Case srCase = [Select Id,
                          New_Service_Address__c,
                          Service_Start_Date__c,
                          Service_End_Date__c,
                          Reason,
                          ContactId,
                          Type
                     From Case 
                     where CaseNumber = :outputList[0].sCaseNumber];
    
    //Check if record was created
    System.assert(srCase!=null);
    
    //Check fields
    System.assert(String.isBlank(srCase.New_Service_Address__c));
    System.assert(srCase.Service_Start_Date__c==null);
    System.assertEquals(input.dtServiceStopDate, srCase.Service_End_Date__c);
    System.assertEquals(UtilityBot_Constants.CASE_REASON_STOP, srCase.Reason);
    System.assertEquals(con.Id, srCase.ContactId);    
    System.assertEquals(UtilityBot_Constants.CASE_TYPE_SERVICE_REQUEST, srCase.Type);
  }
}