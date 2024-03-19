({
    
   
    doInit: function(component, event, helper) {
       helper.createObjectData(component, event);
    },
    
    Save: function(component, event, helper) {
        
        var action = component.get("c.updateSentimentValues");
        action.setParams({
            "sentWrap": component.get("v.sentimentWrapList")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                component.set("v.sentimentWrapList", []);
                helper.createObjectData(component, event);
                alert('record Save');
            }
        });
        $A.enqueueAction(action);
        
    },
    
   
    addNewRow: function(component, event, helper) {
        helper.createObjectData(component, event);
    },
    
   
    removeDeletedRow: function(component, event, helper) {
        var index = event.getParam("indexVar");
        var AllRowsList = component.get("v.sentimentWrapList");
        AllRowsList.splice(index, 1); 
        component.set("v.sentimentWrapList", AllRowsList);
    },
    
    trainNow: function(component, event, helper) {
    	var action = component.get("c.startTraining");
    	action.setCallback(this, function(response) {
    		var state = response.getState();
    		if (state === "SUCCESS") {
    			var returnVal = response.getReturnValue();
    			component.set("v.newDataSetID", returnVal);
    			helper.sendForTraining(component);
    		}
    	});
    	$A.enqueueAction(action);
        
    },
    
    trainingStatus: function(component, event, helper) {
    	var action = component.get("c.trainingStatusMethod");
    	var modelId = component.get("v.modelIdForTrainingStatus");
    	action.setParams({
            "modelID":modelId   
        });
    	action.setCallback(this, function(response) {
    		var state = response.getState();
    		if (state === "SUCCESS") {
    			var status = response.getReturnValue();
                component.set("v.trainingStatusAttr", status);
    		}
    	});
    	$A.enqueueAction(action);
        
    },
    
    showSpinner: function(component, event, helper) {
        // make Spinner attribute true for displaying loading spinner 
        component.set("v.spinner", true); 
    },
     
    // function automatic called by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hiding loading spinner    
        component.set("v.spinner", false);
    }    
    
})