({
	doInit : function(component, event, helper) {
		var action = component.get("c.getUnderwritingConditions");
        action.setParams({
            "recId":component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                component.set("v.conditions",response.getReturnValue());
                //alert(response.getReturnValue().creditScore);
                //var test = component.get("v.conditions");
                //alert(test.creditScore);
            }
        });
        $A.enqueueAction(action);
	}
})