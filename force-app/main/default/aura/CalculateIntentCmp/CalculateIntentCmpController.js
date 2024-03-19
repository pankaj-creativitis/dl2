({
    callServer : function(component, event, helper) {
        var requestAttribute = component.get("v.requestAttribute");
        
        var action = component.get("c.setAttribute");
        action.setParams({
            "doc":requestAttribute   
        });
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state === "SUCCESS") {
                var responseWrapper = response.getReturnValue();
                console.log(responseWrapper);
                component.set("v.responseAttribute", responseWrapper.finalComputation);
                component.set("v.rawResponseAttribute", responseWrapper.rawResponse);  
            } 
            else {
                console.log(state);
            }
        });
        $A.enqueueAction(action);
    }
})