/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
 
/**************************************************************************************
Name: UtilityBot_UsageInformation
Version: 1.0 
Function: Contains invocable method to get usage information for an account


Modification Log: 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
Description
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
Original Version
*************************************************************************************/
public with sharing class UtilityBot_UsageInformation {
    //Alert confirmation
    public class UsageOutput{
        @InvocableVariable(required=true)
        public String sUsageInformation; 
        @InvocableVariable(required=true)
        public String sErrorMessage;         
    }
    
    public class UsageInput{
        @InvocableVariable(required=true)
        public String sAccountId;        
    }

    @InvocableMethod(label='Get usage information')
    public static List<UsageOutput> getUsageInformation(List<UsageInput> inputParameters) {
        
        // //Get the input parameter
        UsageInput inputparameter = inputParameters.get(0);

        if(inputparameter == null){ return null; }
        
        //List for building output parameters
        List<UsageOutput> outputParameters = new List<UsageOutput>();
        
        //Prepare the Output
        UsageOutput outputParameter = new UsageOutput();
        
        try{
            List<Consumption__c> utilityConsumption = new List<Consumption__c>();
            if(Schema.sObjectType.Consumption__c.isAccessible() && 
               Schema.sObjectType.Consumption__c.fields.Previous_Meter_Reading__c.isAccessible() &&
               Schema.sObjectType.Consumption__c.fields.Meter_Reading__c.isAccessible() && 
               Schema.sObjectType.Consumption__c.fields.Current_Consumption__c.isAccessible() && 
               Schema.sObjectType.Consumption__c.fields.Unit__c.isAccessible() && 
               Schema.sObjectType.Consumption__c.fields.Amount_Due__c.isAccessible() && 
               Schema.sObjectType.Consumption__c.fields.Due_Date__c.isAccessible() && 
               Schema.sObjectType.Consumption__c.fields.Is_Bill_Paid__c.isAccessible() && 
               Schema.sObjectType.Consumption__c.fields.Start_Date__c.isAccessible() && 
               Schema.sObjectType.Consumption__c.fields.End_Date__c.isAccessible()){
                //Lookup Account based on the Account Id
                utilityConsumption = [Select Previous_Meter_Reading__c, 
                                             Meter_Reading__c,
                                             Current_Consumption__c,
                                             Unit__c,
                                             Amount_Due__c,
                                             Due_Date__c,
                                             Is_Bill_Paid__c,
                                             Start_Date__c,
                                             End_Date__c
                                      From Consumption__c
                                      Where Account__c = :inputparameter.sAccountId 
                                      Order by End_Date__c Desc 
                                      Limit 1];

            }

                                                       
            if(utilityConsumption!=null && !utilityConsumption.isEmpty()){
                Consumption__c cmp = utilityConsumption[0];
                String cycleStart  = cmp.Start_Date__c.format('MMM dd');
                String cycleEnd    = cmp.End_Date__c.format('MMM dd');
                String usage       = String.valueOf(cmp.Current_Consumption__c) + cmp.Unit__c;
                String billAmount  = String.valueOf(cmp.Amount_Due__c);
                String dueDate     = cmp.Due_Date__c.format('MMM dd yyyy');
                
                //Bill Paid
                if(cmp.Is_Bill_Paid__c){
                    outputParameter.sUsageInformation = String.format(Label.Message_Usage_Information_Bill_Paid, new List<String>{cycleStart, cycleEnd, usage, billAmount}); 
                    outputParameter.sErrorMessage = UtilityBot_Constants.NO_ERROR;
                }
                //Bill not paid
                else{
                    outputParameter.sUsageInformation = String.format(Label.Message_Usage_Information_Bill_Due, new List<String>{cycleStart, cycleEnd, usage, billAmount, duedate}); 
                    outputParameter.sErrorMessage = UtilityBot_Constants.NO_ERROR;
                }
                
                //No error
                // outputParameter.sErrorMessage = UtilityBot_Constants.NO_ERROR;                
            }

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