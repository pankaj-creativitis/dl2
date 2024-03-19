({
	doInit : function(component, event, helper) {
		var action = component.get("c.getUnderwritingChecks");
        action.setParams({
            "oppId":component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            // alert(state);
            if(state === "SUCCESS"){
                component.set("v.conditions",response.getReturnValue());
                //alert(response.getReturnValue().creditScore);
                var test = component.get("v.conditions");
                // alert(JSON.stringify(response.getReturnValue()));
            }
        });
        $A.enqueueAction(action);
	}
})