/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

/**************************************************************************************
Name: UtilityBot_OutageData
Version: 1.0 
Function: Contains invocable method to get outage data. By default the bot uses the custom object, 
          but this class can be leveraged to get data from an external service or system

Modification Log: 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
Description
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
Original Version
*************************************************************************************/
public with sharing class UtilityBot_OutageData {

    //Output of the prechat form
    public class OutageOutput{
        @InvocableVariable(required=true)
        public String sOutageId;
        @InvocableVariable(required=true)
        public Boolean bNoOutage;         
        @InvocableVariable(required=true)
        public Boolean bZipcodeInServiceArea;   
        @InvocableVariable(required=true)
        public String sOutageMessage;          
    }

    //OutageOutput class containing data to be received as input
    public class OutageInput{
        @InvocableVariable(required=true)
        public String sZipcode;
    }
    
	@InvocableMethod(label='Get outages in the area')
	public static List<OutageOutput> getOutagesForZipCodes(List<OutageInput> outageInputs)
    {
        //Get the first zipcode. We are expecting only one zipcode. 
		String sZipcode = outageInputs[0].sZipcode;
		
		//Prepare the output
        List<OutageOutput> outageOutputs = new List<OutageOutput>();
        
		//Object for sending output parameters
        OutageOutput oo = new OutageOutput();
        
		//Check if the zipcode is in service area or not.
		//if yes, the proceed else stop and return null in other fields
        List<Service_Area__c> serviceAreas = new List<Service_Area__c>();
        if(Schema.sObjectType.Service_Area__c.isAccessible() && 
           Schema.sObjectType.Service_Area__c.fields.Id.isAccessible() && 
           Schema.sObjectType.Service_Area__c.fields.ZipCode__c.isAccessible()){
            serviceAreas = [Select Id 
                            From Service_Area__c 
                            Where ZipCode__c = :sZipcode];
        }

        
        if(serviceAreas==null || serviceAreas.isEmpty()){
            oo.bZipcodeInServiceArea = false;
            oo.sOutageMessage = String.format(Label.Message_Out_of_Service_Area, new List<String>{sZipcode});
        }
        else{
            oo.bZipcodeInServiceArea = true;
    		//We need current time so that we can determine the outage that is applicable to the current time
    		DateTime currentTime = System.now();
    		
            //Get Outages for the zipcode provided
            List<Outage__c> outages =  new List<Outage__c>();
            if(Schema.sObjectType.Outage__c.isAccessible() && 
               Schema.sObjectType.Outage__c.fields.Id.isAccessible() && 
               Schema.sObjectType.Outage__c.fields.Cause__c.isAccessible() &&
               Schema.sObjectType.Outage__c.fields.Estimated_End__c.isAccessible() && 
               Schema.sObjectType.Outage__c.fields.Outage_Start__c.isAccessible() && 
               Schema.sObjectType.Outage__c.fields.Status__c.isAccessible() && 
               Schema.sObjectType.Outage__c.fields.ZipCode__c.isAccessible()){
                outages = [Select Id, 
                                  Cause__c,
                                  Estimated_End__c,
                                  Outage_Start__c,
                                  Status__c,
                                  ZipCode__c
                           From Outage__c 
                           Where ZipCode__c = :sZipcode 
                           And Status__c in (:UtilityBot_Constants.OUTAGE_STATUS_INVESTIGATING,
                                          :UtilityBot_Constants.OUTAGE_STATUS_CREW_ASSIGNED, 
                                          :UtilityBot_Constants.OUTAGE_STATUS_CREW_ON_WAY, 
                                          :UtilityBot_Constants.OUTAGE_STATUS_CREW_ONSITE) 
                           And Outage_Start__c < :currentTime];    
            }

            
            if(outages!=null && !outages.isEmpty()){
                oo.bNoOutage        = false;
                oo.sOutageId        = outages[0].Id;
                String cause        = outages[0].Cause__c;
                String status       = outages[0].Status__c;
                String outageStart  = outages[0].Outage_Start__c==null? UtilityBot_Constants.UNKNOWN : outages[0].Outage_Start__c.format('MMM dd yyyy, h:mm a');
                String outageEstEnd = outages[0].Estimated_End__c==null? UtilityBot_Constants.UNKNOWN : outages[0].Estimated_End__c.format('MMM dd yyyy, h:mm a');
                oo.sOutageMessage = String.format(Label.Message_Outage_Information, new List<String>{sZipcode, outageStart,cause, status, outageEstEnd});
            }
            else{
                oo.bNoOutage      = true;
                oo.sOutageMessage = String.format(Label.Message_No_Outage, new List<String>{sZipcode});
            }
        }
        
        outageOutputs.add(oo);
		return outageOutputs;
	}

}