({
	handleRP : function(component, event, helper) {
		component.set("v.showSpinner",true);
                    //Call Your Apex Controller Method.
            var action = component.get("c.sendEmail");
            action.setParams({
                'caseId': component.get('v.recordId')
            });

            action.setCallback(this, function(response) {
                var state = response.getState();
                    if (state === "SUCCESS") {
                        //after code
                        response.getReturnValue();
                        setTimeout(function(){ 
                            component.set("v.sentRepayment",true);
                            component.set("v.showSpinner",false);
                        }, 3000);
                    } 
            });
            
            $A.enqueueAction(action);
	},
    handleAddressValidation : function(component, event, helper) {
		component.set("v.showSpinner",true);
                        setTimeout(function(){ 
                            component.set("v.validateAddress",true);
                            component.set("v.showSpinner",false);
                        }, 3000);
            
            $A.enqueueAction(action);
	},
    handleERC : function(component, event, helper) {
		component.set("v.showSpinner",true);
                        setTimeout(function(){ 
                            component.set("v.flagERC",true);
                            component.set("v.showSpinner",false);
                        }, 3000);
            
            $A.enqueueAction(action);
	},
    handleAddressUpdate : function(component, event, helper) {
        // updateAddressNew
        component.set("v.showSpinner",true);
        var action = component.get("c.updateAddressNew");
        action.setParams({
            'caseId': component.get('v.recordId')
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //after code
                response.getReturnValue();
                setTimeout(function(){ 
                    component.set("v.updateAddress",true);
                    component.set("v.showSpinner",false);
                }, 3000);
            } 
        });
        
        $A.enqueueAction(action);
    }
    
})