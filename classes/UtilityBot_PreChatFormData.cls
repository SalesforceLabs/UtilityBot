/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
 
/**************************************************************************************
Name: UtilityBot_PreChatFormData
Version: 1.0 
Function: Contains invocable method to get Pre Chat form data and set LiveChatTranscript
          object fields

Modification Log: 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
Description
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
Original Version
*************************************************************************************/
public with sharing class UtilityBot_PreChatFormData {
    //Output of the prechat form
    public class PrechatOutput{
        @InvocableVariable(required=true)
        public String sFirstName;
        @InvocableVariable(required=true)
        public String sLastName;
        @InvocableVariable(required=true)
        public String sContactId;
        @InvocableVariable
        public Boolean bAccountFound;
        @InvocableVariable
        public String sAccountId;
        @InvocableVariable
        public String sAccountNumber;
        @InvocableVariable
        public String sServiceAddress;        
        @InvocableVariable
        public Boolean bCodeVerified;
        @InvocableVariable(required=true)
        public String sErrorMessage;         
    }
    
    //Input provided to the prechat
    public class PrechatInput{
        @InvocableVariable(required=true)
        public String sChatKey;
	}
    
    //Core invocable function
    @InvocableMethod(label='Get PreChat Form Data')
    public static List<PrechatOutput> getPreChatFormData(List<PrechatInput> inputParameters)
    {
        String sChatKey = inputParameters[0].sChatKey; //get the chat key passed to this class
        String sContactId = null;					   //Variable for Contact Id
        
        //List for building the output parameters
        List<PrechatOutput> outputParameters = new List<PrechatOutput>();
        
        //Preapre the Output
        PrechatOutput outputParameter = new PrechatOutput();
        
        try{
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
                        //Get case Id and contact id
                        sContactId = transcripts[0].ContactId;
                        outputParameter.sContactId = transcripts[0].ContactId;
                    }
                }             

    		}
            
            //Contact Id found in the transcript record
            if (sContactId != null && sContactId != '')
            {
                List<Contact> contacts = new List<Contact>();

                if(Schema.sObjectType.Contact.isAccessible() && 
                   Schema.sObjectType.Contact.fields.Id.isAccessible() && 
                   Schema.sObjectType.Contact.fields.FirstName.isAccessible() && 
                   Schema.sObjectType.Contact.fields.LastName.isAccessible() && 
                   Schema.sObjectType.Contact.fields.Email.isAccessible() && 
                   Schema.sObjectType.Contact.fields.AccountId.isAccessible() && 
                   Schema.sObjectType.Contact.fields.Community_User_Logged_In__c.isAccessible()){
                    contacts = [SELECT Id, 
                                       FirstName, 
                                       LastName, 
                                       Email,
                                       AccountId,
                                       Account.AccountNumber,
                                       Account.ShippingAddress,
                                       Community_User_Logged_In__c
                                FROM Contact 
                                WHERE Id = :sContactId];

                }

                
                //Contact found
                if (contacts.size()>0)
                {	
                    //Set the name in the output parameter
                    outputParameter.sFirstName = contacts[0].FirstName;
                    outputParameter.sLastName  = contacts[0].LastName;
                    
                    //Check if the community user is logged in. If yes, then get all Account information
                    if(contacts[0].Community_User_Logged_In__c){
                        outputParameter.bAccountFound = true;
                        outputParameter.sAccountId = contacts[0].AccountId;
                        outputParameter.sAccountNumber = contacts[0].Account.AccountNumber;
                        //Set the Service Address
                        outputParameter.sServiceAddress = contacts[0].Account.ShippingAddress.getStreet() + ',' + 
                                                          contacts[0].Account.ShippingAddress.getCity() + ',' + 
                                                          contacts[0].Account.ShippingAddress.getState() + ' ' +
                                                          contacts[0].Account.ShippingAddress.getPostalCode();
                        outputParameter.bCodeVerified = true;
                        
                        //Update Contact to set Community_User_Logged_In__c to false. 
                        //So that next time when user launches chat without loggin in they are asked for verification.
                        if(Schema.sObjectType.Contact.isUpdateable() && 
                           Schema.sObjectType.Contact.fields.Community_User_Logged_In__c.isUpdateable()){
                            Contact con = new Contact(Id = contacts[0].Id,
                                                      Community_User_Logged_In__c = false);
                                                      
                            update con;                            
                        }
                    }
    			}                
            }
            outputParameter.sErrorMessage = UtilityBot_Constants.NO_ERROR;             
        }
        catch(DMLException e){
            outputParameter.sErrorMessage = e.getMessage();
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