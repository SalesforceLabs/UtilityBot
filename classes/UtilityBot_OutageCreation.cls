/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
 
/**************************************************************************************
Name: UtilityBot_OutageCreation
Version: 1.0 
Function: Contains invocable method to create an outage when a customer reports it.

Modification Log: 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
Description
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
Original Version
*************************************************************************************/
public with sharing class UtilityBot_OutageCreation {
    //Alert confirmation
    public class OutageOutput{
        @InvocableVariable(required=true)
        public String sOutageId;
        @InvocableVariable(required=true)
        public String sErrorMessage;        
    }
    
    public class OutageInput{
        @InvocableVariable(required=true)
        public String sContactId;        
        @InvocableVariable(required=true)
        public String sZipcode;
    }

    @InvocableMethod(label='Create Outage Record')
    public static List<OutageOutput> createOutage(List<OutageInput> inputParameters) {
        
        // //Get the input parameter
        OutageInput inputparameter = inputParameters.get(0);

        if(inputparameter == null){ return null; }
        
        //List for building output parameters
        List<OutageOutput> outputParameters = new List<OutageOutput>();
        
        //Prepare the Output
        OutageOutput outputParameter = new OutageOutput();
        
        try{
            if(Schema.sObjectType.Outage__c.isCreateable() && 
               Schema.sObjectType.Outage__c.fields.Outage_Start__c.isCreateable() && 
               Schema.sObjectType.Outage__c.fields.Cause__c.isCreateable() && 
               Schema.sObjectType.Outage__c.fields.ZipCode__c.isCreateable() && 
               Schema.sObjectType.Outage__c.fields.Status__c.isCreateable() && 
               Schema.sObjectType.Outage__c.fields.First_Reported_By__c.isCreateable()){
                // Create the Outage Record
                Outage__c newOutage = new Outage__c(Outage_Start__c      = System.now(),
                                                    Cause__c             = UtilityBot_Constants.OUTAGE_CAUSE_UNKNOWN,
                                                    ZipCode__c           = inputparameter.sZipcode,
                                                    Status__c            = UtilityBot_Constants.OUTAGE_STATUS_INVESTIGATING,
                                                    First_Reported_By__c = inputparameter.sContactId);
                //Upsert case
                insert newOutage;
                outputParameter.sOutageId = newOutage.Id; 
                outputParameter.sErrorMessage = UtilityBot_Constants.NO_ERROR;
            }
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