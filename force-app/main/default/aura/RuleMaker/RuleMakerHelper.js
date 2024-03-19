({
	 createObjectData: function(component, event,helper) {
        // get the conditionList from component and add(push) New Object to List  
        var RowItemList = component.get("v.conditionList");
        RowItemList.push({
            'sobjectType': 'Condition__c',
            'Object__c': component.get("v.objectName"),
            'Name': '',
            'Field__c': '',
            'Not__c': false,
            'Operator__c': '',
            'Values__c': '',
        });
        // set the updated list to attribute (conditionList) again    
        component.set("v.conditionList", RowItemList);
    },
    // helper function for check if first Name is not null/blank on save  
    validateRequired: function(component, event) {
        var isValid = true;
        var allConditionRows = component.get("v.conditionList");
        for (var indexVar = 0; indexVar < allConditionRows.length; indexVar++) {
            if (allConditionRows[indexVar].FirstName == '') {
                isValid = false;
                alert('First Name Can\'t be Blank on Row Number ' + (indexVar + 1));
            }
        }
        return isValid;
    },
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
    getFields:function(component, event,helper) {
           
         var getWhichObject = event.getSource().get("v.value");
        alert(getWhichObject);
         component.set('v.objectName', getWhichObject);
         var action = component.get("c.getTierFieldMap");
         action.setParams({"obj" : getWhichObject});
          
         action.setCallback(this, function(response) {
             
             if(response.getState() === "SUCCESS"){           
                 // var response2 = response.getReturnValue().clone();
                 component.set("v.baseFlds",response.getReturnValue());
                 // component.set("v.tierFlds",response.getReturnValue());
                 // alert(JSON.stringify(component.get("v.baseFlds")));
                // component.set("v.tierFlds",response2);
                 
             }
             
         });
         $A.enqueueAction(action);
     },
    getConditions: function(component, event) {
       
         var getWhichObject = event.getSource().get("v.value");
       
 		alert("object selected "+getWhichObject);        
        console.log("object selected "+getWhichObject);
         var action = component.get("c.conditionMaker");
         action.setParams({"obj" : getWhichObject});
        action.setCallback(this, function(response) {
             if(response.getState() === "SUCCESS"){           
                 //component.set("v.baseFlds",response.getReturnValue());
                 
             }  
         });
         $A.enqueueAction(action);
    }
})