/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

({
    /**
     * Event which fires the function to start a chat request 
     * (by accessing the chat API component).
     * 
     * @param cmp - The component for this state.
     */
    onStartButtonClick: function(component) {
        var prechatFieldComponents = component.find("prechatField");
        var apiNamesMap = this.createAPINamesMap(component.find("prechatAPI").getPrechatFields());
        var fields;

        // Make an array of field objects for the library.
		//debugger;
        fields = this.createFieldsArray(apiNamesMap, prechatFieldComponents);
        console.log(fields[2].label + ' ' + fields[2].value);
        
        // If the prechat fields pass validation, start a chat.
        if(component.find("prechatAPI").validateFields(fields).valid) {
            if(fields[2].value!=null && fields[2].value!=""){
                //Call action to set the "Community User Logged In" field only if email value is set
                this.setLoggedInField(component, fields);                
            }
            component.find("prechatAPI").startChat(fields);
        } else {
            console.warn("Prechat fields did not pass validation!");
        }
    },
    /**
     * Create an array of field objects to start a chat from an array of prechat fields.
     * 
     * @param fields - Array of prechat field Objects.
     * @returns An array of field objects.
     */
    createFieldsArray: function(apiNames, fieldCmps) {
        if(fieldCmps.length) {
            return fieldCmps.map(function(fieldCmp) {
                return {
                    label: fieldCmp.get("v.label"),
                    value: fieldCmp.get("v.value"),
                    name: apiNames[fieldCmp.get("v.label")]
                };
            }.bind(this));
        } else {
            return [];
        }
    },

    /**
     * Create map of field label to field API name from the pre-chat fields array.
     * 
     * @param fields - Array of prechat field Objects.
     * @returns An array of field objects.
     */
    createAPINamesMap: function(fields) {
        var values = {};

        fields.forEach(function(field) {
            values[field.label] = field.name;
        });
        
        return values;
    },
    
    /**
     * Create an array in the format $A.createComponents expects.
     * 
     * Example:
     * [["componentType", {attributeName: "attributeValue", ...}]]
     * 
     * @param prechatFields - Array of prechat field Objects.
     * @returns Array that can be passed to $A.createComponents
     */
    getPrechatFieldAttributesArray: function(prechatFields) {
        // $A.createComponents first parameter is an array of arrays. Each array contains the type of component being created, and an Object defining the attributes.
        var prechatFieldsInfoArray = [];

        // For each field, prepare the type and attributes to pass to $A.createComponents.
        prechatFields.forEach(function(field) {
                var componentName = (field.type === "inputSplitName" || field.type==="inputEmail" ) ? "input" : field.type;
                var componentInfoArray = ["lightning:" + componentName];
	            var className = field.label==="Email"? "slds-hide" : "" + field.className;
                var attributes = {
                    "aura:id": "prechatField",
                    required: field.required,
                    label: field.label,
                    disabled: field.readOnly,
                    maxlength: field.maxLength,
                    class: className,
                    value: field.value
                };
         
                 // Special handling for options for an input:select (picklist) component.
                if(field.type === "inputSelect" && field.picklistOptions) attributes.options = field.picklistOptions;
                
                // Append the attributes Object containing the required attributes to render this prechat field.
                componentInfoArray.push(attributes);
                
                // Append this componentInfoArray to the fieldAttributesArray.
                prechatFieldsInfoArray.push(componentInfoArray);
        });

        return prechatFieldsInfoArray;
    },    
    /**
     * Check that First Name and Last Name are populated
     * 
     * @param @param cmp - The component for this state.
     */
    validateFields: function(component,event) {
        //Boolean variable to decide if all fields are populated or not
        var validationSuccessful = true;
        
        //Get all fields on the prechat form
        var prechatFieldComponents = component.find("prechatField");
        
        //Loop through each field. Leave the email field.
        for(var i=0; i<prechatFieldComponents.length; i++){
            var pcField = prechatFieldComponents[i];
            if(pcField.get("v.label")!="Email"){
                if(pcField.get("v.value")===null || pcField.get("v.value")===""){
                    validationSuccessful = false;
                }
            }
        }
        //If validation fails set the error message, else clear it.
        if(!validationSuccessful){
            component.set("v.errorMessage", "Please enter First Name and Last Name to start chat.");
        }
        else{
            component.set("v.errorMessage", "");
        }
        
        //Set the validation attribute. This is used for showing the UI:Message
        component.set("v.validationSuccessful", validationSuccessful);
    },
    /**
     * Call apex method to set the field on the contact record
     * 
     * @param @param cmp - The component for this state.
     */    
    setLoggedInField:function(component, fields){
        // create a one-time use instance of the setCommunityLoggedInField action
        // in the server-side controller
        var action = component.get("c.setCommunityLoggedInField");
        
        //Set method params
        action.setParams(
            {firstName : fields[0].value,
             lastName  : fields[1].value,
             email: fields[2].value});
        
		// Create a callback that is executed after the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
				console.log("logged in");
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });

        // $A.enqueueAction adds the server-side action to the queue.
        $A.enqueueAction(action);
    },
    launchChatAutomatically:function(component){
        var prechatFieldComponents = component.find("prechatField");  
        
        //Var to determine if all fields are populated
        var allFieldsFilled = false;
        
        //Check if all fields are populated
        //Loop through each field. Leave the email field.
        for(var i=0; i<prechatFieldComponents.length; i++){
            var pcField = prechatFieldComponents[i];
            if(pcField.get("v.value")!=null && pcField.get("v.value")!=""){
                allFieldsFilled = true;
            }
            else{
                allFieldsFilled = false;
            }
        }
        
        //Fire the startchat code
        if(prechatFieldComponents.length ===3 && allFieldsFilled){
            this.onStartButtonClick(component);
        }
    }
});