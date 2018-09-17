/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
 
/**************************************************************************************
Name: Test_UtilityBot_PreChatFormData
Version: 1.0 
Created Date: 07.02.2018
Function: Test class for UtilityBot_PreChatFormData class

Modification Log:
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
* Description
* -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                  
* Original Version
*************************************************************************************/
@IsTest
private with sharing class Test_UtilityBot_PreChatFormData {

 /** Scenario 1: 
  * Get the pre chat form data and account data for logged in user
  */
  @isTest
  private static void shouldGetPreChatAndAccountData(){

    //Account
    UtilityBot_TestHelper.AccountBuilder accountBuilder = new UtilityBot_TestHelper.AccountBuilder();
    Account acct = accountBuilder.build().save().getRecord(); 
    
    //Contact tied to the account
    UtilityBot_TestHelper.ContactBuilder contactBuilder = new UtilityBot_TestHelper.ContactBuilder();
    Contact con = contactBuilder.build().withAccount(acct.Id).withCommunityUserLoggedIn(true).save().getRecord();
    
    //LiveChatTranscript record
    UtilityBot_TestHelper.LiveChatTranscriptBuilder liveChatBuilder = new UtilityBot_TestHelper.LiveChatTranscriptBuilder();
    LiveChatTranscript lct = liveChatBuilder.build().withContactId(con.Id).save().getRecord();    
    
    //Get chat key for the live chat transcript
    String chatKey = [Select ChatKey from LiveChatTranscript where Id = :lct.id].ChatKey;

    test.startTest();
    
    //Create the input parameter class instance
    UtilityBot_PreChatFormData.PrechatInput input = new UtilityBot_PreChatFormData.PrechatInput();
    input.sChatKey          = chatKey;
    
    //Create the output parameter list
    List<UtilityBot_PreChatFormData.PrechatOutput> outputList = UtilityBot_PreChatFormData.getPreChatFormData(new List<UtilityBot_PreChatFormData.PrechatInput>{input});
    
    test.stopTest();
    
    //Validate results
    System.assert(outputList!=null && !outputList.isEmpty() && outputList.size() == 1);
    
    //Check fields
    System.assertEquals(con.FirstName, outputList[0].sFirstName);
    System.assertEquals(con.LastName, outputList[0].sLastName);
    System.assertEquals(con.Id, outputList[0].sContactId);
    System.assert(outputList[0].bAccountFound);
    System.assertEquals(acct.Id, outputList[0].sAccountId);
    System.assertEquals(acct.AccountNumber, outputList[0].sAccountNumber);
    System.assertEquals(outputList[0].sServiceAddress, acct.ShippingStreet + ',' + 
                                                       acct.ShippingCity + ',' + 
                                                       acct.ShippingState + ' ' +
                                                       acct.ShippingPostalCode); 
    System.assert(outputList[0].bCodeVerified);
    System.assertEquals(outputList[0].sErrorMessage, UtilityBot_Constants.NO_ERROR);

  }

 /** Scenario 2: 
  *  Get the pre chat form data and but no account data for users not logged into community
  */
  @isTest
  private static void shouldGetPreChatData(){

    //Account
    UtilityBot_TestHelper.AccountBuilder accountBuilder = new UtilityBot_TestHelper.AccountBuilder();
    Account acct = accountBuilder.build().save().getRecord(); 
    
    //Contact tied to the account
    UtilityBot_TestHelper.ContactBuilder contactBuilder = new UtilityBot_TestHelper.ContactBuilder();
    Contact con = contactBuilder.build().withAccount(acct.Id).withCommunityUserLoggedIn(false).save().getRecord();
    
    //LiveChatTranscript record
    UtilityBot_TestHelper.LiveChatTranscriptBuilder liveChatBuilder = new UtilityBot_TestHelper.LiveChatTranscriptBuilder();
    LiveChatTranscript lct = liveChatBuilder.build().withContactId(con.Id).save().getRecord();    
    
    //Get chat key for the live chat transcript
    String chatKey = [Select ChatKey from LiveChatTranscript where Id = :lct.id].ChatKey;

    test.startTest();
    
    //Create the input parameter class instance
    UtilityBot_PreChatFormData.PrechatInput input = new UtilityBot_PreChatFormData.PrechatInput();
    input.sChatKey          = chatKey;
    
    //Create the output parameter list
    List<UtilityBot_PreChatFormData.PrechatOutput> outputList = UtilityBot_PreChatFormData.getPreChatFormData(new List<UtilityBot_PreChatFormData.PrechatInput>{input});
    
    test.stopTest();
    
    //Validate results
    System.assert(outputList!=null && !outputList.isEmpty() && outputList.size() == 1);
    
    //Check fields
    System.assertEquals(con.FirstName, outputList[0].sFirstName);
    System.assertEquals(con.LastName, outputList[0].sLastName);
    System.assertEquals(con.Id, outputList[0].sContactId);
    System.assert(outputList[0].bAccountFound == null);
    System.assert(String.isBlank(outputList[0].sAccountId));
    System.assert(String.isBlank(outputList[0].sAccountNumber));
    System.assert(String.isBlank(outputList[0].sServiceAddress)); 
    System.assert(outputList[0].bCodeVerified == null);
    System.assertEquals(outputList[0].sErrorMessage, UtilityBot_Constants.NO_ERROR);     
  }
}