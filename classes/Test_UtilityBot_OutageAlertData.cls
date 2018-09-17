/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
 
/**************************************************************************************
Name: Test_UtilityBot_OutageAlertData
Version: 1.0 
Created Date: 07.02.2018
Function: Test class for UtilityBot_OutageAlertData class

Modification Log:
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
* Description
* -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                  
* Original Version
*************************************************************************************/
@IsTest
private with sharing class Test_UtilityBot_OutageAlertData {

 /** Scenario 1: 
  * Email Outage alert case should be created for the contact
  */
  @isTest
  private static void shouldCreateEmailAlert(){

    //Account
    UtilityBot_TestHelper.AccountBuilder accountBuilder = new UtilityBot_TestHelper.AccountBuilder();
    Account acct = accountBuilder.build().save().getRecord(); 
    
    //Contact tied to the account
    UtilityBot_TestHelper.ContactBuilder contactBuilder = new UtilityBot_TestHelper.ContactBuilder();
    Contact con = contactBuilder.build().withAccount(acct.Id).save().getRecord();
    
    //Outage
    UtilityBot_TestHelper.OutageBuilder outageBuilder = new UtilityBot_TestHelper.OutageBuilder();
    Outage__c outage = outageBuilder.build().save().getRecord();
    
    //LiveChatTranscript record
    UtilityBot_TestHelper.LiveChatTranscriptBuilder liveChatBuilder = new UtilityBot_TestHelper.LiveChatTranscriptBuilder();
    LiveChatTranscript lct = liveChatBuilder.build().save().getRecord();    
    
    //Get chat key for the live chat transcript
    String chatKey = [Select ChatKey from LiveChatTranscript where Id = :lct.id].ChatKey;

    test.startTest();
    
    //Create the input parameter class instance
    UtilityBot_OutageAlertData.OutageAlertInput input = new UtilityBot_OutageAlertData.OutageAlertInput();
    input.sChatKey          = chatKey;
    input.sContactId        = con.Id;
    input.sOutageId         = outage.Id;
    input.sStatusUpdateMode = UtilityBot_Constants.EMAIL_ALERT;
    input.sEmail            = 'testemail@test.tst';
    
    //Create the output parameter list
    List<UtilityBot_OutageAlertData.OutageAlertOutput> outputList = UtilityBot_OutageAlertData.setOutageAlerts(new List<UtilityBot_OutageAlertData.OutageAlertInput>{input});
    
    test.stopTest();
    
    //Validate results
    System.assert(outputList!=null && !outputList.isEmpty() && outputList.size() == 1 && String.isNotBlank(outputList[0].sCaseId));
    
    //Get the case
    Case alertCase = [Select Alert_Email__c,
                             Alert_Phone__c,
                             Reason,
                             Outage__c,
                             ContactId,
                             Type 
                     From Case 
                     where Id = :outputList[0].sCaseId];
    
    //Check if record was created
    System.assert(alertCase!=null);
    
    //Check fields
    System.assertEquals(input.sEmail, alertCase.Alert_Email__c);
    System.assert(String.isBlank(alertCase.Alert_Phone__c));
    System.assertEquals(UtilityBot_Constants.CASE_REASON_EMAIL_ALERT, alertCase.Reason);
    System.assertEquals(input.sOutageId, alertCase.Outage__c);
    System.assertEquals(input.sContactId, alertCase.ContactId);
    System.assertEquals(UtilityBot_Constants.CASE_TYPE_OUTAGE_ALERT, alertCase.Type);

  }

 /** Scenario 2: 
  *  Message Outage alert case should be created for the contact
  */
  @isTest
  private static void shouldCreateMessageAlert(){

    //Account
    UtilityBot_TestHelper.AccountBuilder accountBuilder = new UtilityBot_TestHelper.AccountBuilder();
    Account acct = accountBuilder.build().save().getRecord(); 
    
    //Contact tied to the account
    UtilityBot_TestHelper.ContactBuilder contactBuilder = new UtilityBot_TestHelper.ContactBuilder();
    Contact con = contactBuilder.build().withAccount(acct.Id).save().getRecord();
    
    //Contact tied to the account
    UtilityBot_TestHelper.OutageBuilder outageBuilder = new UtilityBot_TestHelper.OutageBuilder();
    Outage__c outage = outageBuilder.build().save().getRecord();
    
    //LiveChatTranscript record
    UtilityBot_TestHelper.LiveChatTranscriptBuilder liveChatBuilder = new UtilityBot_TestHelper.LiveChatTranscriptBuilder();
    LiveChatTranscript lct = liveChatBuilder.build().save().getRecord();    
    
    //Get chat key for the live chat transcript
    String chatKey = [Select ChatKey from LiveChatTranscript where Id = :lct.id].ChatKey;

    test.startTest();
    
    //Create the input parameter class instance
    UtilityBot_OutageAlertData.OutageAlertInput input = new UtilityBot_OutageAlertData.OutageAlertInput();
    input.sChatKey          = chatKey;
    input.sContactId        = con.Id;
    input.sOutageId         = outage.Id;
    input.sStatusUpdateMode = UtilityBot_Constants.MESSAGE_ALERT;
    input.sPhone            = '123-123-1234';
    
    //Create the output parameter list
    List<UtilityBot_OutageAlertData.OutageAlertOutput> outputList = UtilityBot_OutageAlertData.setOutageAlerts(new List<UtilityBot_OutageAlertData.OutageAlertInput>{input});
    
    test.stopTest();
    
    //Validate results
    System.assert(outputList!=null && !outputList.isEmpty() && outputList.size() == 1 && String.isNotBlank(outputList[0].sCaseId));
    
    //Get the case
    Case alertCase = [Select Alert_Email__c,
                             Alert_Phone__c,
                             Reason,
                             Outage__c,
                             ContactId,
                             Type 
                     From Case 
                     where Id = :outputList[0].sCaseId];
    
    //Check if record was created
    System.assert(alertCase!=null);
    
    //Check fields
    System.assertEquals(input.sPhone, alertCase.Alert_Phone__c);
    System.assert(String.isBlank(alertCase.Alert_Email__c));
    System.assertEquals(UtilityBot_Constants.CASE_REASON_MESSAGE_ALERT, alertCase.Reason);
    System.assertEquals(input.sOutageId, alertCase.Outage__c);
    System.assertEquals(input.sContactId, alertCase.ContactId);
    System.assertEquals(UtilityBot_Constants.CASE_TYPE_OUTAGE_ALERT, alertCase.Type);      
  }
}