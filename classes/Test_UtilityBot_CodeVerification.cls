/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
 
/**************************************************************************************
Name: Test_UtilityBot_CodeVerification
Version: 1.0 
Created Date: 07.02.2018
Function: Test class for UtilityBot_CodeVerification class

Modification Log:
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
* Description
* -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                  
* Original Version
*************************************************************************************/
@IsTest
private with sharing class Test_UtilityBot_CodeVerification {

 /** Scenario 1: 
  * Verification code provided matches the one in the contact
  */
  @isTest
  private static void shouldVerifyCode(){

    //Account
    UtilityBot_TestHelper.AccountBuilder accountBuilder = new UtilityBot_TestHelper.AccountBuilder();
    Account acct = accountBuilder.build().save().getRecord(); 
    
    //Contact tied to the account
    UtilityBot_TestHelper.ContactBuilder contactBuilder = new UtilityBot_TestHelper.ContactBuilder();
    Contact con = contactBuilder.build().withAccount(acct.Id).withVerificationCode('987654').save().getRecord();

    test.startTest();
    
    //Create the input parameter class instance
    UtilityBot_CodeVerification.CodeVerificationInput input = new UtilityBot_CodeVerification.CodeVerificationInput();
    input.sVerificationCode = '987654';
    input.sContactId     = con.Id;
    
    //Create the output parameter list
    List<UtilityBot_CodeVerification.CodeVerificationOutput> outputList = UtilityBot_CodeVerification.verifyCode(new List<UtilityBot_CodeVerification.CodeVerificationInput>{input});
    
    test.stopTest();
    
    //Validate results for Account
    System.assert(outputList!=null && !outputList.isEmpty() && outputList.size() == 1);
    System.assert(outputList[0].bCodeVerfied);
    System.assertEquals(outputList[0].sErrorMessage, UtilityBot_Constants.NO_ERROR);
  }

 /** Scenario 2: 
  *  Verification code provided does not match the one in the contact
  */
  @isTest
  private static void shouldNotVerifyCode(){

    //Account
    UtilityBot_TestHelper.AccountBuilder accountBuilder = new UtilityBot_TestHelper.AccountBuilder();
    Account acct = accountBuilder.build().save().getRecord(); 
    
    //Contact tied to the account
    UtilityBot_TestHelper.ContactBuilder contactBuilder = new UtilityBot_TestHelper.ContactBuilder();
    Contact con = contactBuilder.build().withAccount(acct.Id).withVerificationCode('987654').save().getRecord();

    test.startTest();
    
    //Create the input parameter class instance
    UtilityBot_CodeVerification.CodeVerificationInput input = new UtilityBot_CodeVerification.CodeVerificationInput();
    input.sVerificationCode = '123456';
    input.sContactId     = con.Id;
    
    //Create the output parameter list
    List<UtilityBot_CodeVerification.CodeVerificationOutput> outputList = UtilityBot_CodeVerification.verifyCode(new List<UtilityBot_CodeVerification.CodeVerificationInput>{input});
    
    test.stopTest();
    
    //Validate results for Account
    System.assert(outputList!=null && !outputList.isEmpty() && outputList.size() == 1);
    System.assert(!outputList[0].bCodeVerfied);
    System.assertEquals(outputList[0].sErrorMessage, UtilityBot_Constants.NO_ERROR);
  }
}