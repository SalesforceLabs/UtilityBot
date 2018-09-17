/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
 
/**************************************************************************************
Name: Test_UtilityBot_AccountVerification
Version: 1.0 
Created Date: 07.02.2018
Function: Test class for UtilityBot_AccountVerification class

Modification Log:
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
* Description
* -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                  
* Original Version
*************************************************************************************/
@IsTest
private with sharing class Test_UtilityBot_AccountVerification {

 /** Scenario 1: 
  * The Account number provided matches the account tied to the contact
  * Verification code is set on the contact
  */
  @isTest
  private static void shouldFindAnAccount(){

    //Account
    UtilityBot_TestHelper.AccountBuilder accountBuilder = new UtilityBot_TestHelper.AccountBuilder();
    Account acct = accountBuilder.build().save().getRecord(); 
    
    //Contact tied to the account
    UtilityBot_TestHelper.ContactBuilder contactBuilder = new UtilityBot_TestHelper.ContactBuilder();
    Contact con = contactBuilder.build().withAccount(acct.Id).save().getRecord();

    test.startTest();
    
    //Create the input parameter class instance
    UtilityBot_AccountVerification.AccountVerificationInput input = new UtilityBot_AccountVerification.AccountVerificationInput();
    input.sAccountNumber = acct.AccountNumber;
    input.sContactId     = con.Id;
    
    //Create the output parameter list
    List<UtilityBot_AccountVerification.AccountVerificationOutput> outputList = UtilityBot_AccountVerification.verifyAccount(new List<UtilityBot_AccountVerification.AccountVerificationInput>{input});
    
    test.stopTest();
    
    //Validate results for Account
    System.assert(outputList!=null && !outputList.isEmpty() && outputList.size() == 1);
    System.assert(outputList[0].bAccountFound);
    System.assertEquals(outputList[0].sAccountId, acct.Id);    
    System.assertEquals(outputList[0].sServiceAddress, acct.ShippingStreet + ',' + 
                                                       acct.ShippingCity + ',' + 
                                                       acct.ShippingState + ' ' +
                                                       acct.ShippingPostalCode); 
    System.assertEquals(outputList[0].sErrorMessage, UtilityBot_Constants.NO_ERROR);
    
    //Validate results for the Contact
    //Get the verification code from the contact
    Contact updatedContact = [Select Verification_Code__c from Contact where Id = :con.id];
    System.assert(String.isNotBlank(updatedContact.Verification_Code__c));
  }

 /** Scenario 2: 
  * The Account number provided does not match the account tied to the contact
  * Verification code is not generated for the contact
  */
  @isTest
  private static void shouldNotFindAnAccount(){

    //Account
    UtilityBot_TestHelper.AccountBuilder accountBuilder = new UtilityBot_TestHelper.AccountBuilder();
    Account acct = accountBuilder.build().save().getRecord(); 
    
    //Contact tied to the account
    UtilityBot_TestHelper.ContactBuilder contactBuilder = new UtilityBot_TestHelper.ContactBuilder();
    Contact con = contactBuilder.build().withAccount(acct.Id).save().getRecord();

    test.startTest();
    
    //Create the input parameter class instance
    UtilityBot_AccountVerification.AccountVerificationInput input = new UtilityBot_AccountVerification.AccountVerificationInput();
    input.sAccountNumber = 'AN-12121212';
    input.sContactId     = con.Id;
    
    //Create the output parameter list
    List<UtilityBot_AccountVerification.AccountVerificationOutput> outputList = UtilityBot_AccountVerification.verifyAccount(new List<UtilityBot_AccountVerification.AccountVerificationInput>{input});
    
    test.stopTest();
    
    //Validate results for Account
    System.assert(outputList!=null && !outputList.isEmpty() && outputList.size() == 1);
    System.assert(!outputList[0].bAccountFound);
    System.assertEquals(outputList[0].sErrorMessage, UtilityBot_Constants.NO_ERROR);
    
    //Validate results for the Contact
    //Get the verification code from the contact
    Contact updatedContact = [Select Verification_Code__c from Contact where Id = :con.id];
    System.assert(String.isBlank(updatedContact.Verification_Code__c));    
  }
}