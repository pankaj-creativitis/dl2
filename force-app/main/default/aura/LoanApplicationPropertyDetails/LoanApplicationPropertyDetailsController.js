({
	handleCancel: function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },    
    handleOnSuccess: function (component, event, helper) {  
       component.find('notificationsLibrary').showToast({
            "title": "Record updated!",
            "message": "The record has been updated successfully.",
            "variant": "success"
        });
         $A.get("e.force:refreshView").fire();
        
        /*  
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The record has been updated successfully.",
            "type": "success"
        });
        toastEvent.fire();        
        var sObjectEvent = $A.get("e.force:navigateToSObject");
        sObjectEvent.setParams({
            "recordId": component.get("v.recordId")
        });
        sObjectEvent.fire();
        */ 
    }, 
    handleOnError: function (component, event, helper) {
       		component.find('notificationsLibrary').showToast({
            "title": "Something has gone wrong!",
            "message": event.getParam("message"),
            "variant": "error"
        });
    },  
})