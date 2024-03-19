({
    sendForTraining: function(component){
    	try{
    		var action = component.get("c.trainDataset");
    		action.setCallback(this, function(response) {
    			var state = response.getState();
    			if (state === "SUCCESS") {
    				var modelID = response.getReturnValue();
    				component.set("v.modelIdForTrainingStatus", modelID);
    			}else{
    				console.log('failed');
    			}
    		});
    		$A.enqueueAction(action);
    	}
    	catch(ex){
    		console.log(ex);
    	}
    },
    
    createObjectData: function(component, event) {
        var RowItemList = component.get("v.sentimentWrapList");
        RowItemList.push({
            'sobjectType': 'SentimateUpdate.sentimentWrapper',
            'sentimentText': '',
             'sentimentType': ''
        });
        component.set("v.sentimentWrapList", RowItemList);
    }
    
   
})