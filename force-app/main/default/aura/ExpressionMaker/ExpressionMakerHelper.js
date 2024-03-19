({
	getObjectList: function(component, event) {
        var action = component.get("c.getObjects");
        action.setCallback(this, function(response) {
            if(response.getState() === "SUCCESS"){            
                // alert("Contact fetched!");
            }
            // alert(JSON.stringify(response.getReturnValue()));
            component.set("v.objs", response.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    
    getRuleList:function(component, event) {
           
         var getWhichObject = event.getSource().get("v.value");
        alert(getWhichObject);
         component.set('v.objectName', getWhichObject);
         var action = component.get("c.getConditions");
         action.setParams({"objName" : getWhichObject});
          
         action.setCallback(this, function(response) {
             
             if(response.getState() === "SUCCESS"){           
                 component.set("v.conditions",response.getReturnValue());
                 // alert(JSON.stringify(component.get("v.baseFlds")));       
             }
             
         });
         $A.enqueueAction(action);
    },
})