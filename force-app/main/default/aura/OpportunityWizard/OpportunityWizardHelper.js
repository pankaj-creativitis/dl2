({
	getRecordMetadatas : function(component,event) {
		var action = component.get("c.getRecordMetadata");
        action.setParams({ "recId" : component.get("v.recordId") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                // alert('Refresh! -->' + response.getReturnValue());
               // alert("From server: " + JSON.stringify(response.getReturnValue()));
                component.set("v.recMetadatas",response.getReturnValue());
                }else if (state === "INCOMPLETE"){
                    alert('Incomplete');
                // do something
            }else if (state === "ERROR") {
                var errors = response.getError();
                if(errors){
                    if(errors[0] && errors[0].message){
                        console.log("Error message: " + errors[0].message);
                        alert(errors[0].message);
                    }
                }else{
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
	},
    
    getLstMetadatas : function(component,event) {
		var action = component.get("c.getRelatedLists");
        action.setParams({ 
            "objectName" :'Opportunity',
            "recId" : component.get("v.recordId") 
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                // alert('Refresh! -->' + response.getReturnValue().StageName);
                // alert("From server: " + JSON.stringify(response.getReturnValue()));
                component.set("v.lstMetadatas",response.getReturnValue());
                }else if (state === "INCOMPLETE"){
                    alert('Incomplete');
                // do something
            }else if (state === "ERROR") {
                var errors = response.getError();
                if(errors){
                    if(errors[0] && errors[0].message){
                        console.log("Error message: " + errors[0].message);
                        alert(errors[0].message);
                    }
                }else{
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
	}
})