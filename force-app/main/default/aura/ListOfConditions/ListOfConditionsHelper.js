({
	getListConditions : function(component,event) {
		
         var action = component.get("c.conditionsList");
         action.setParams({"obj" : "Contact"});
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var nValues=[];   
                var values=response.getReturnValue();
                for(var key in values){
                    nValues.push({key:key, value:values[key]});
                }
                component.set("v.conditions", nValues);
                console.log('nvalues are',nValues);
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        // Send action off to be executed
        $A.enqueueAction(action);
	},
    getSaveMethod : function(component,event,queryString,obj){
         var action =  component.get("c.exprMethod");
        console.log("in helper method",queryString);
        action.setParams({"exp" : queryString, "obj": obj});
            action.setCallback(this, function(response) {
            var state = response.getState();    
            if (state === "SUCCESS") { 
                var values=response.getReturnValue();
                console.log("values",values);
            }
       		})
              $A.enqueueAction(action); 
             var action1 =  component.get("c.exprMethod2");
        
        action1.setParams({"id" : "003S000001G7nRmIAJ"});
          action1.setCallback(this, function(response) {
            var state = response.getState();    
            if (state === "SUCCESS") { 
                var values=response.getReturnValue();
                console.log("expr2",values);
            }
       		})
                         $A.enqueueAction(action1);      
      }
})