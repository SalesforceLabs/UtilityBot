/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
/**************************************************************************************
Name: UtilityBot_TestHelper
Version: 1.0 
Created Date: 07.02.2018
Function: Class used in unit test to prepare test data

Modification Log:
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
* Developer
* -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                  
*Original Version
**********************************************************************************************************************/
@IsTest
public with sharing class UtilityBot_TestHelper {

   /**
    *  Builder for Accounts
    */
    public class AccountBuilder {
        private Account obj;

        public AccountBuilder build() {
            obj = new Account( Name                = 'ChatBot Account',
                               BillingCity         = 'San Francisco',
                               BillingState        = 'California',
                               BillingCountry      = 'United States',
                               BillingPostalCode   = '91007',
                               BillingStreet      = '123 Main Street',
                               ShippingCity        = 'San Francisco',
                               ShippingState       = 'California',
                               ShippingCountry     = 'United States',
                               ShippingPostalCode  = '91007',
                               ShippingStreet      = '123 Main Street',
                               AccountNumber       = 'AN-12345678'
            );
            
            return this;
        }

        public AccountBuilder withName(String name){
            obj.Name = name;
            return this;
        }

        public AccountBuilder save() {
            insert obj;
            return this;
        }

        public Account getRecord() {
            return obj;
        }
    }

   /**
    *  Builder for Contacts
    */
    public class ContactBuilder {
        private Contact obj;

        public ContactBuilder build() {
            obj = new Contact( FirstName                   = 'Ned',
                               LastName                    = 'Stark',
                               Email                       = 'nstark@winterfell.tst',
                               Community_User_Logged_In__c = false,
                               Verification_Code__c        = ''
                    );
            return this;
        }

        public ContactBuilder withAccount(Id accountId) {
            obj.AccountId = accountId;
            return this;
        }

        public ContactBuilder withFirstName(String firstName) {
            obj.FirstName = firstName;
            return this;
        }
        
        public ContactBuilder withLastName(String lastName) {
            obj.LastName = lastName;
            return this;
        }
        
        public ContactBuilder withEmail(String email) {
            obj.Email = email;
            return this;
        }
        
        public ContactBuilder withVerificationCode(String verificationCode) {
            obj.Verification_Code__c = verificationCode;
            return this;
        }
        
        public ContactBuilder withCodeSetTime(DateTime codeSetTime) {
            obj.Code_Set_Time__c = codeSetTime;
            return this;
        }
        
        public ContactBuilder withCommunityUserLoggedIn(Boolean isLoggedIn) {
            obj.Community_User_Logged_In__c = isLoggedIn;
            return this;
        }
        
        public ContactBuilder save() {
            insert obj;
            return this;
        }

        public Contact getRecord() {
            return obj;
        }
    }
    
   /**
    *  Builder for Cases
    */
    public class CaseBuilder {
        private Case obj;

        public CaseBuilder build() {
            obj = new Case();
            return this;
        }

        public CaseBuilder withContact(Id contactId) {
            obj.ContactId = contactId;
            return this;
        }
        
        public CaseBuilder withReason(String reason) {
            obj.Reason = reason;
            return this;
        }
        
        public CaseBuilder withType(String type) {
            obj.Type = type;
            return this;
        }        
        
        public CaseBuilder save() {
            insert obj;
            return this;
        }

        public Case getRecord() {
            return obj;
        }
    }    
    
   /**
    *  Builder for Outage
    */
    public class OutageBuilder {
        private Outage__c obj;

        public OutageBuilder build() {
            obj = new Outage__c(Cause__c         = UtilityBot_Constants.OUTAGE_CAUSE_MAINTENANCE,
                                Estimated_End__c = DateTime.now().addDays(1),
                                Outage_Start__c  = DateTime.now().addDays(-1),
                                Status__c        = UtilityBot_Constants.OUTAGE_STATUS_INVESTIGATING,
                                ZipCode__c       = '12345');
            return this;
        }     

        public OutageBuilder withCause(String cause) {
            obj.Cause__c = cause;
            return this;
        }
        
        public OutageBuilder withEstimatedEndDate(DateTime endDate) {
            obj.Estimated_End__c = endDate;
            return this;
        }

        public OutageBuilder withOutageStartDate(DateTime startDate) {
            obj.Outage_Start__c = startDate;
            return this;
        }
        
        public OutageBuilder withStatus(String status) {
            obj.Status__c = status;
            return this;
        }

        public OutageBuilder withZipCode(String zipcode) {
            obj.ZipCode__c = zipcode;
            return this;
        }
        
        public OutageBuilder save() {
            insert obj;
            return this;
        }

        public Outage__c getRecord() {
            return obj;
        }
    }   

   /**
    *  Builder for Service Area
    */
    public class ServiceAreaBuilder {
        private Service_Area__c obj;

        public ServiceAreaBuilder build() {
            obj = new Service_Area__c(ZipCode__c  = '12345');
            return this;
        }     

        public ServiceAreaBuilder withZipCode(String zipcode) {
            obj.ZipCode__c = zipcode;
            return this;
        }
        
        public ServiceAreaBuilder save() {
            insert obj;
            return this;
        }

        public Service_Area__c getRecord() {
            return obj;
        }
    } 

   /**
    *  Builder for Consumption
    */
    public class ConsumptionBuilder {
        private Consumption__c obj;

        public ConsumptionBuilder build() {
            obj = new Consumption__c(Amount_Due__c             = 100,
                                     Is_Bill_Paid__c           = true,
                                     Due_Date__c               = DateTime.now().addDays(45),
                                     End_Date__c               = DateTime.now().addDays(30),
                                     Meter_Reading__c          = 1000,
                                     Previous_Meter_Reading__c = 800,
                                     Start_Date__c             = DateTime.now(),
                                     Unit__c                   = UtilityBot_Constants.UTILITY_UNIT_KWH);
            return this;
        }     

        public ConsumptionBuilder withAccount(Id accountId) {
            obj.Account__c = accountId;
            return this;
        }
        
        public ConsumptionBuilder withAmountDue(Decimal amount) {
            obj.Amount_Due__c = amount;
            return this;
        }
        
        public ConsumptionBuilder withBillPaid(Boolean billPaid) {
            obj.Is_Bill_Paid__c = billPaid;
            return this;
        }

        public ConsumptionBuilder withDueDate(DateTime dueDate) {
            obj.Due_Date__c = dueDate;
            return this;
        }
        
        public ConsumptionBuilder withEndDate(DateTime endDate) {
            obj.End_Date__c = endDate;
            return this;
        }

        public ConsumptionBuilder withMeterReading(Decimal reading) {
            obj.Meter_Reading__c = reading;
            return this;
        }

        public ConsumptionBuilder withPrevMeterReading(Decimal reading) {
            obj.Previous_Meter_Reading__c = reading;
            return this;
        }        
        
        public ConsumptionBuilder withStartDate(DateTime startDate) {
            obj.Start_Date__c = startDate;
            return this;
        }  
        
        public ConsumptionBuilder withUnit(String unit) {
            obj.Unit__c = unit;
            return this;
        } 
        
        public ConsumptionBuilder save() {
            insert obj;
            return this;
        }

        public Consumption__c getRecord() {
            return obj;
        }
    } 
    
   /**
    *  Builder for LiveChatTranscript
    */
    public class LiveChatTranscriptBuilder {
        private LiveChatTranscript obj;

        public LiveChatTranscriptBuilder build() {
            
            //Create a visitor
            LiveChatVisitor lcv = new LiveChatVisitor();
            insert lcv;
            
            obj = new LiveChatTranscript(LiveChatVisitorid = lcv.Id,
                                         ChatKey = '1234');
            return this;
        }     

        public LiveChatTranscriptBuilder withContactId(String contactId) {
            obj.ContactId = contactId;
            return this;
        }
        
        public LiveChatTranscriptBuilder save() {
            insert obj;
            return this;
        }

        public LiveChatTranscript getRecord() {
            return obj;
        }
    }     
}