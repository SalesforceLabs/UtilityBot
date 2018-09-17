/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
 
/**************************************************************************************
Name: UtilityBot_ServiceRequestCreation
Version: 1.0 
Function: Contains invocable method to set alerts for the user

Modification Log: 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
Description
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
Original Version
*************************************************************************************/
public with sharing class UtilityBot_ServiceRequestCreation {
    //Alert confirmation
    public class SROutput{
        @InvocableVariable(required=true)
        public String sCaseNumber;
        @InvocableVariable(required=true)
        public String sErrormessage;        
    }
    
    public class SRInput{
        @InvocableVariable(required=true)
        public String sContactId;
        @InvocableVariable(required=true)
        public String sServiceType;        
        @InvocableVariable
        public String sNewServiceAddress;
        @InvocableVariable
        public DateTime dtServiceStartDate;
        @InvocableVariable(required=true)
        public DateTime dtServiceStopDate;
    }

    @InvocableMethod(label='Create Service Request')
    public static List<SROutput> createServiceRequest(List<SRInput> inputParameters) {
        
        //Get the input parameter
        SRInput inputparameter = inputParameters.get(0);

        if(inputparameter == null){ return null; }
        
        //List for building the output parameters
        List<SROutput> outputParameters = new List<SROutput>();
        
        //Preapre the Output
        SROutput outputParameter = new SROutput();
        
        //Case to be created/updated
        Case srCase = new Case();
        
        try{
            if(Schema.sObjectType.Case.isCreateable() && 
               Schema.sObjectType.Case.fields.New_Service_Address__c.isCreateable() && 
               Schema.sObjectType.Case.fields.Service_Start_Date__c.isCreateable() && 
               Schema.sObjectType.Case.fields.Reason.isCreateable() && 
               Schema.sObjectType.Case.fields.Service_End_Date__c.isCreateable() && 
               Schema.sObjectType.Case.fields.ContactId.isCreateable() && 
               Schema.sObjectType.Case.fields.Type.isCreateable()){
                //Set Case fields based on the service request type
                if(inputParameter.sServiceType==UtilityBot_Constants.SERVICE_TYPE_TRANSFER){
                    srCase.New_Service_Address__c = inputParameter.sNewServiceAddress;
                    srCase.Service_Start_Date__c = inputParameter.dtServiceStartDate;
                    srCase.Reason = UtilityBot_Constants.CASE_REASON_TRANSFER;
                }
                else if(inputParameter.sServiceType==UtilityBot_Constants.SERVICE_TYPE_STOP) {
                    srCase.Reason = UtilityBot_Constants.CASE_REASON_STOP;
                }
                
                //Service End Date
                srCase.Service_End_Date__c = inputParameter.dtServiceStopDate;
                
                //Case type
                srCase.Type = UtilityBot_Constants.CASE_TYPE_SERVICE_REQUEST;
                
                //Outage
                srCase.ContactId = inputParameter.sContactId;
        
                //Upsert case
                insert srCase;                
            }  
            
            //Fetch the Case Name
            Case newCase = [Select CaseNumber from Case where Id = :srCase.Id];
            
            //Get case Id
            outputParameter.sCaseNumber = newCase.CaseNumber;            
            outputParameter.sErrorMessage = UtilityBot_Constants.NO_ERROR;
        }
        catch(DMLException ex){
            outputParameter.sErrorMessage = ex.getMessage();
        }
        catch(Exception ex){
            outputParameter.sErrorMessage = ex.getMessage();
        }

        //Add to the output parameters list
        outputParameters.add(outputParameter);
        
        //Return the output
        return outputParameters;        

    }
}