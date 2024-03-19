({
    getAllCases : function(component, event, helper){
        var action = component.get("c.getCases");
        action.setParams({ "usrId" : component.get("v.userId") });
        action.setCallback(this, function(response){
             var state = response.getState();
             if (state === "SUCCESS") {
               //  alert("response.getReturnValue()="+response.getReturnValue());
            	component.set("v.caseRows", response.getReturnValue());
             }
        });
        $A.enqueueAction(action);
    }
})