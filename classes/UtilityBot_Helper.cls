/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
 
/**************************************************************************************
Name: UtilityBot_Helper
Version: 1.0 
Function: Contains methods that can be used by other classes

Modification Log: 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
Description
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
Original Version
*************************************************************************************/
public with sharing class  UtilityBot_Helper {
    
    //Method to generate random number. Used to generate the verification code
    public static String getRandomString(Integer length){
        String randomString = '';
        
        while(randomString.length() < length){
            Integer charIndex = Math.mod(Math.abs(Crypto.getRandomInteger()),UtilityBot_Constants.RANDOM_CHARS.length());
            randomString += UtilityBot_Constants.RANDOM_CHARS.substring(charIndex, charIndex+1);
        }
        
        return randomString;
    }
    
}