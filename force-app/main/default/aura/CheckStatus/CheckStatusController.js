({
	checkEmiB : function(component, event, helper) {
        // alert('action');
        var action = component.get("c.checkEMIBounce");
        action.setParams({
            "recId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            if(response.getState() == "SUCCESS")
            {
           //     alert('Success');
               component.set("v.emib",response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
	},
    doInit : function(component, event, helper) {
		var action = component.get("c.getSchemeRepayment");
        action.setParams({
            "OppId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            if(response.getState() == "SUCCESS")
            {
           // alert(JSON.stringify(response.getReturnValue()));
               component.set("v.repSumm",response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
	},
})