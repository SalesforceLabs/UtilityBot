/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
 
/**************************************************************************************
Name: UtilityBot_AccountVerification
Version: 1.0 
Function: Contains invocable method to lookup and verify the accountnumber provided by the user.


Modification Log: 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
Description
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
Original Version
*************************************************************************************/
public with sharing class UtilityBot_AccountVerification {
    //Alert confirmation
    public class AccountVerificationOutput{
        @InvocableVariable(required=true)
        public Boolean bAccountFound;
        @InvocableVariable
        public String sAccountId; 
        @InvocableVariable
        public String sServiceAddress; 
        @InvocableVariable(required=true)
        public String sErrorMessage;         
    }
    
    public class AccountVerificationInput{
        @InvocableVariable(required=true)
        public String sAccountNumber;        
        @InvocableVariable(required=true)
        public String sContactId;
    }

    @InvocableMethod(label='Verify Account using Account Number')
    public static List<AccountVerificationOutput> verifyAccount(List<AccountVerificationInput> inputParameters) {
        
        // //Get the input parameter
        AccountVerificationInput inputparameter = inputParameters.get(0);

        if(inputparameter == null){ return null; }
        
        //List for building output parameters
        List<AccountVerificationOutput> outputParameters = new List<AccountVerificationOutput>();
        
        //Prepare the Output
        AccountVerificationOutput outputParameter = new AccountVerificationOutput();
        
        try{
            List<Account> anAccount = new List<Account>();

            List<Contact> userContact = new List<Contact>();

            //Check if the object is accessible
            if(Schema.sObjectType.Account.isAccessible() && 
               Schema.sObjectType.Account.fields.Id.isAccessible() && 
               Schema.sObjectType.Account.fields.AccountNumber.isAccessible() && 
               Schema.sObjectType.Account.fields.ShippingAddress.isAccessible()){
                //Lookup Account based on the Account Number
                anAccount = [Select Id, 
                                    AccountNumber,
                                    ShippingAddress
                             From Account 
                             Where AccountNumber = :inputparameter.sAccountNumber];                
            }

            //Check if the object is accessible
            if(Schema.sObjectType.Contact.isAccessible() && 
               Schema.sObjectType.Contact.fields.AccountId.isAccessible()){
                //Lookup Account based on the Contact Id
                userContact = [Select AccountId
                               From Contact 
                               Where Id = :inputparameter.sContactId];                
            }               

                                         
            //Compare 2 Accounts. If they are same send a code to the email associated with Contact.
            //If they are not same, ask customer to check the number
            if(anAccount!=null && 
               !anAccount.isEmpty() && 
               userContact!=null && 
               !userContact.isEmpty() && 
               anAccount[0].Id == userContact[0].AccountId){
                
                //Set the flag to indicate that the account number is valid
                outputParameter.bAccountFound = true; 
                
                //Set the account Id
                outputParameter.sAccountId = anAccount[0].Id;
                
                //Set the Service Address
                outputParameter.sServiceAddress = anAccount[0].ShippingAddress.getStreet() + ',' + 
                                                  anAccount[0].ShippingAddress.getCity() + ',' + 
                                                  anAccount[0].ShippingAddress.getState() + ' ' +
                                                  anAccount[0].ShippingAddress.getPostalCode();
                
                //Create a verification code
                String verificationCode = UtilityBot_Helper.getRandomString(6);
                
                //Update this verification code in the contact record. When the user enters this verification code, 
                //it will verified against the value stored in the Contact. The value will be set to blank after the user is 
                //verified or after an hour
                if(Schema.sObjectType.Contact.isUpdateable() && 
                   Schema.sObjectType.Contact.fields.Verification_Code__c.isUpdateable()){
                    Contact con = new Contact(Id = inputparameter.sContactId,
                                              Verification_Code__c = verificationCode);
                                                    
                    //Update Contact
                    update con;
                }

            }
            else{
                outputParameter.bAccountFound = false;
            }
            
            outputParameter.sErrorMessage = UtilityBot_Constants.NO_ERROR;
        }
        catch(DMLException e){
            outputParameter.sErrorMessage = e.getMessage();
        }

        //Add to the output parameters list
        outputParameters.add(outputParameter);
        
        //Return the output
        return outputParameters;        

    }
}