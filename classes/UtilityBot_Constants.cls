/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
 
/**************************************************************************************
Name: UtilityBot_Constants
Version: 1.0 
Function: Contains constants used across all classes

Modification Log: 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
Description
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
Original Version
*************************************************************************************/
public with sharing class  UtilityBot_Constants {
    
    //Case Reasons
    public static final String CASE_REASON_EMAIL_ALERT   = 'Email Alert';
    public static final String CASE_REASON_MESSAGE_ALERT = 'Message Alert';
    public static final String CASE_REASON_TRANSFER      = 'Transfer';
    public static final String CASE_REASON_STOP          = 'Stop';
    
    //Alert Modes
    public static final String EMAIL_ALERT = 'Email';
    public static final String MESSAGE_ALERT = 'Text Message';
    
    //Case Types
    public static final String CASE_TYPE_OUTAGE_ALERT    = 'Outage Alert';
    public static final String CASE_TYPE_SERVICE_REQUEST = 'Service Request';
    
    //Outage Cause
    public static final String OUTAGE_CAUSE_FAULTY_DEVICE = 'Faulty Device';
    public static final String OUTAGE_CAUSE_MAINTENANCE   = 'Planned Maintenance';
    public static final String OUTAGE_CAUSE_UNKNOWN       = 'Unknown';

    //Outage Status
    public static final String OUTAGE_STATUS_INVESTIGATING = 'Investigating';
    public static final String OUTAGE_STATUS_CREW_ASSIGNED = 'Crew assigned';
    public static final String OUTAGE_STATUS_CREW_ON_WAY   = 'Crew on its way';
    public static final String OUTAGE_STATUS_CREW_ONSITE   = 'Crew is onsite';
    public static final String OUTAGE_STATUS_RESOLVED      = 'Resolved';
    
    //No error message
    public static final String NO_ERROR = 'No Error';
    
    //Unknown
    public static final String UNKNOWN = 'Unknown';    
    
    //Characters for random number generation
    public static final String RANDOM_CHARS = '0123456789';
    
    //Service Types
    public static final String SERVICE_TYPE_TRANSFER = 'Transfer_Service_Information';
    public static final String SERVICE_TYPE_STOP     = 'Stop_Service_Information';
    
    //Characters for random number generation
    public static final String UTILITY_UNIT_KWH = 'kWh';
    
}