({
	 // function call on component Load
    doInit: function(component, event, helper) {
        // create a Default RowItem [Condition Instance] on first time Component Load
        // by call this helper function  
        // helper.createObjectData(component, event);
        helper.getObjectList(component, event);
        
    },
    
    objectSelected: function(component, event, helper) {
        // create a Default RowItem [Condition Instance] on first time Component Load
        // by call this helper function  
        helper.getFields(component, event);
       helper.createObjectData(component, event);
        helper.getConditions(component,event);
        console.log("inside obj selected");
        
    },
 
    // function for save the Records 
    Save: function(component, event, helper) {
        // first call the helper function in if block which will return true or false.
        // this helper function check the "first Name" will not be blank on each row.
        // if (helper.validateRequired(component, event)) {
            // call the apex class method for save the Contact List
            // with pass the contact List attribute to method param.  
            var action = component.get("c.saveRules");
            action.setParams({
                "lstCondition": component.get("v.conditionList")
            });
            // set call back 
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    // if response if success then reset/blank the 'conditionList' Attribute 
                    // and call the common helper method for create a default Object Data to Contact List 
                    component.set("v.conditionList", []);
                    helper.createObjectData(component, event);
                    alert('Record Saved');
                }
            });
            // enqueue the server side action  
            $A.enqueueAction(action);
        // }
    },
 
    // function for create new object Row in Contact List 
    addNewRow: function(component, event, helper) {
        // call the comman "createObjectData" helper method for add new Object Row to List  
        helper.createObjectData(component, event);
    },
 
    // function for delete the row 
    removeDeletedRow: function(component, event, helper) {
        // get the selected row Index for delete, from Lightning Event Attribute  
        var index = event.getParam("indexVar");
        // get the all List (contactList attribute) and remove the Object Element Using splice method    
        var AllRowsList = component.get("v.conditionList");
        AllRowsList.splice(index, 1);
        // set the contactList after remove selected row element  
        component.set("v.conditionList", AllRowsList);
    },
})