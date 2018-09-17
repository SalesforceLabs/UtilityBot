/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

({
    /**
     * On initialization of this component, 
     * set the prechatFields attribute and render prechat fields.
     * 
     * @param component - The component for this state.
     * @param eventt - The Aura event.
     * @param helper - The helper for this state.
     */
	onInit: function(component, event, helper) {
        // Get prechat fields defined in setup using the prechatAPI component.
		var prechatFields = component.find("prechatAPI").getPrechatFields();

        // Get prechat field types and attributes to be rendered.
        var prechatFieldComponentsArray = helper.getPrechatFieldAttributesArray(prechatFields);
        
        // Make asynchronous Aura call to create prechat field components.
        $A.createComponents(
            prechatFieldComponentsArray,
            function(components, status, errorMessage) {
                if(status === "SUCCESS") {
                    component.set("v.prechatFieldComponents", components);
                    //Call the helper method to start chat if chat has been initiated by logged in user
                    helper.launchChatAutomatically(component);
                }
            }
        );
    },
    
    /**
     * Event which fires when start button is clicked in prechat.
     * 
     * @param component - The component for this state.
     * @param event - The Aura event.
     * @param helper - The helper for this state.
     */
    handleStartButtonClick: function(component, event, helper) {
        //Validate that all required fields are populated
        helper.validateFields(component,event);
        
        //If validation is successful, then call the standard prechat validation 
        if(component.get("v.validationSuccessful")){
            helper.onStartButtonClick(component);
        }
    }
});