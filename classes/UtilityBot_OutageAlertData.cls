/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
 
/**************************************************************************************
Name: UtilityBot_OutageAlertData
Version: 1.0 
Function: Contains invocable method to set alerts for the user

Modification Log: 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
Description
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
Original Version
*************************************************************************************/
public with sharing class UtilityBot_OutageAlertData {
    //Alert confirmation
    public class OutageAlertOutput{
        @InvocableVariable(required=true)
        public String sCaseId;
    }
    
    public class OutageAlertInput{
        @InvocableVariable(required=true)
        public String sChatKey;
        @InvocableVariable(required=true)
        public String sContactId;        
        @InvocableVariable(required=true)
        public String sOutageId;
        @InvocableVariable
        public String sStatusUpdateMode;
        @InvocableVariable
        public String sEmail;
        @InvocableVariable
        public String sPhone;
    }

    @InvocableMethod(label='Set Outage Alerts')
    public static List<OutageAlertOutput> setOutageAlerts(List<OutageAlertInput> inputParameters) {
        
        //Get the input parameter
        OutageAlertInput inputparameter = inputParameters.get(0);

        if(inputparameter == null){ return null; }
        
        //List for cases
        List<Case> cases = new List<Case>();
        
        //get the input parameter
        String sChatKey = inputParameter.sChatKey; //get the chat key passed to this class
        
        //List for building the output parameters
        List<OutageAlertOutput> outputParameters = new List<OutageAlertOutput>();
        
        //Preapre the Output
        OutageAlertOutput outputParameter = new OutageAlertOutput();
        
        //Case to be created/updated
        Case outageCase;
        
        //Check that the chatkey is not null. For snap-ins the chat key is not null
        if (sChatKey != null && sChatKey != '')
        {
            if(Schema.sObjectType.LiveChatTranscript.isAccessible() && 
               Schema.sObjectType.LiveChatTranscript.fields.Id.isAccessible() && 
               Schema.sObjectType.LiveChatTranscript.fields.CaseId.isAccessible() && 
               Schema.sObjectType.LiveChatTranscript.fields.ContactId.isAccessible() && 
               Schema.sObjectType.LiveChatTranscript.fields.ChatKey.isAccessible()){
                //Get the LiveChattranscript record based on the chatkey
                List<LiveChatTranscript> transcripts = [SELECT Id, 
                                                               CaseId,
                                                               ContactId 
                                                        FROM LiveChatTranscript 
                                                        WHERE ChatKey = :sChatKey];
                if (transcripts.size()>0)
                {
                    //Get case Id
                    outputParameter.sCaseId = transcripts[0].CaseId;
                }
            }	

		}
        
        //Case Id found in the transcript record
        if (!String.isBlank(outputParameter.sCaseId))
        {
            if(Schema.sObjectType.Case.isAccessible() && 
               Schema.sObjectType.Case.fields.Id.isAccessible() && 
               Schema.sObjectType.Case.fields.Alert_Email__c.isAccessible() && 
               Schema.sObjectType.Case.fields.Alert_Phone__c.isAccessible() && 
               Schema.sObjectType.Case.fields.Outage__c.isAccessible() && 
               Schema.sObjectType.Case.fields.Reason.isAccessible() && 
               Schema.sObjectType.Case.fields.Type.isAccessible()){
                cases = [SELECT Id, 
                                Alert_Email__c,
                                Alert_Phone__c,
                                Outage__c,
                                Reason,
                                Type
                        FROM Case 
                        WHERE Id = :outputParameter.sCaseId];
            }

        }
        
        //Set the outage case variable
        if(cases!=null & !cases.isEmpty()){
            outageCase = cases[0];
        }
        else{
            outageCase = new Case();
        }
        
        //Set Case fields
        //Email
        if(inputParameter.sStatusUpdateMode==UtilityBot_Constants.EMAIL_ALERT && 
          !String.isBlank(inputParameter.sEmail)){
            outageCase.Alert_Email__c = inputParameter.sEmail;
            outageCase.Reason = UtilityBot_Constants.CASE_REASON_EMAIL_ALERT;
        }
        
        //Phone
        if(inputParameter.sStatusUpdateMode==UtilityBot_Constants.MESSAGE_ALERT && 
          !String.isBlank(inputParameter.sPhone)){
            outageCase.Alert_Phone__c = inputParameter.sPhone.trim();
            outageCase.Reason = UtilityBot_Constants.CASE_REASON_MESSAGE_ALERT;                    
        }
        //Outage
        outageCase.Outage__c = inputParameter.sOutageId;
        
        //Outage
        outageCase.ContactId = inputParameter.sContactId;

        //Case type
        outageCase.Type = UtilityBot_Constants.CASE_TYPE_OUTAGE_ALERT;
        
        //Perform CRUD and FLS checks
        if(cases!=null & !cases.isEmpty()){
            if(Schema.sObjectType.Case.isUpdateable() && 
               Schema.sObjectType.Case.fields.Alert_Email__c.isUpdateable() && 
               Schema.sObjectType.Case.fields.Alert_Phone__c.isUpdateable() && 
               Schema.sObjectType.Case.fields.Reason.isUpdateable() && 
               Schema.sObjectType.Case.fields.Outage__c.isUpdateable() && 
               Schema.sObjectType.Case.fields.ContactId.isUpdateable()  && 
               Schema.sObjectType.Case.fields.Type.isUpdateable()){
                update outageCase; 
            }
        }
        else{
            if(Schema.sObjectType.Case.isCreateable() && 
               Schema.sObjectType.Case.fields.Alert_Email__c.isCreateable() && 
               Schema.sObjectType.Case.fields.Alert_Phone__c.isCreateable() && 
               Schema.sObjectType.Case.fields.Reason.isCreateable() && 
               Schema.sObjectType.Case.fields.Outage__c.isCreateable() && 
               Schema.sObjectType.Case.fields.ContactId.isCreateable() && 
               Schema.sObjectType.Case.fields.Type.isCreateable()){
                insert outageCase;              
            }            
        }

        //Get case Id
        outputParameter.sCaseId = outageCase.Id;
        
        //Add to the output parameters list
        outputParameters.add(outputParameter);
        
        //Return the output
        return outputParameters;        

    }
}