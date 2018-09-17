/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
 
/**************************************************************************************
Name: UtilityBot_CodeVerification
Version: 1.0 
Function: Contains invocable method to verify that the verification code is correct


Modification Log: 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
Description
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
Original Version
*************************************************************************************/
public with sharing class UtilityBot_CodeVerification {
    //Alert confirmation
    public class CodeVerificationOutput{
        @InvocableVariable(required=true)
        public Boolean bCodeVerfied;
        @InvocableVariable(required=true)
        public String sErrorMessage;         
    }
    
    public class CodeVerificationInput{
        @InvocableVariable(required=true)
        public String sVerificationCode;        
        @InvocableVariable(required=true)
        public String sContactId;
    }

    @InvocableMethod(label='Verify Code')
    public static List<CodeVerificationOutput> verifyCode(List<CodeVerificationInput> inputParameters) {
        
        // //Get the input parameter
        CodeVerificationInput inputparameter = inputParameters.get(0);

        if(inputparameter == null){ return null; }
        
        //List for building output parameters
        List<CodeVerificationOutput> outputParameters = new List<CodeVerificationOutput>();
        
        //Prepare the Output
        CodeVerificationOutput outputParameter = new CodeVerificationOutput();
        
        try{

            List<Contact> userContact = new List<Contact>();

            if(Schema.sObjectType.Contact.isAccessible() && 
               Schema.sObjectType.Contact.fields.Id.isAccessible() && 
               Schema.sObjectType.Contact.fields.Verification_Code__c.isAccessible()){
                //Lookup Contact based on the Contact Id and the verfication code
                userContact = [Select Id
                               From Contact 
                               Where Id = :inputparameter.sContactId 
                               And Verification_Code__c = :inputparameter.sVerificationCode];
            }
                                         
            //Check that userContact is not empty. If it is, then the verification code is incorrect
            if(userContact!=null && 
               !userContact.isEmpty()){
                
                //Set the flag to indicate that the code is valid
                outputParameter.bCodeVerfied = true; 

            }
            else{
                outputParameter.bCodeVerfied = false;
            }
            
            outputParameter.sErrorMessage = UtilityBot_Constants.NO_ERROR;
        }
        catch(Exception e){
            outputParameter.sErrorMessage = e.getMessage();
        }

        //Add to the output parameters list
        outputParameters.add(outputParameter);
        
        //Return the output
        return outputParameters;        

    }
}