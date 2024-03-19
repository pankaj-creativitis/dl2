/************************************************************
 Lightning Controller  Details
 Name: CreateCandidateRecordController.js
 Type: Lightning Controller 
 Purpose: Controller for  lightning component 
		  CreateCandidateRecordController.cmp
 ***********************************************************/
({
	create : function(component, event, helper) {
		console.log('Create record');
        
        //getting the candidate information
        var caseObj = component.get("v.case");
        
        //Validation
        if($A.util.isEmpty(caseObj.Subject) || $A.util.isUndefined(caseObj.Subject)){
            alert('Subject is Required');
            return;
        }            
        
        //Calling the Apex Function
        var action = component.get("c.createRecordForCase");
        // alert(component.get("v.userId"));
        //Setting the Apex Parameter
        action.setParams({
            "caseObj" : caseObj,
            "usrId": component.get("v.userId")
            
        });
        
        //Setting the Callback
        action.setCallback(this,function(a){
            //get the response state
            var state = a.getState();
            
            //check if result is successfull
            if(state == "SUCCESS"){
                //Reset Form
                var newCase = {'sobjectType': 'Case',
                                    'Subject': '',
                                    'Description': ''
                                   };
                //resetting the Values in the form
                component.set("v.case",newCase);
                alert('Record is Created Successfully');
            } else if(state == "ERROR"){
                alert('Error in calling server side action');
            }
        });
        
		//adds the server-side action to the queue        
        $A.enqueueAction(action);

	}
})