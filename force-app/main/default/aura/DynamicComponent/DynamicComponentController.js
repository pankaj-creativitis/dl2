({
    doInit : function(component, event, helper) {
         // alert(component.get("v.rawflds"));
        // if(!component.get("v.rawflds")){
		var names = component.get("v.rawflds");
        
        component.set("v.flds", names.split(','));
            // alert(component.get("v.flds")[0]);
        // }
	},
    handleOnSuccess : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The record has been updated.",
            "type": "success"
        });
        toastEvent.fire();
        
    }
})