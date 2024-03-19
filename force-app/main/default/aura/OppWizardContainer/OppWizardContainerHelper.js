({
	getStageArray : function(component, event) {
		  var action = component.get('c.getPicklistValueBasedonRecordType');
        action.setParams(
		{
			objectAPIName : "Opportunity", 
			fieldAPIName : "StageName",
			recordTypeDeveloperName : "Home_Loan"
		});
        action.setCallback(component,
                           function(response) {
                               var state = response.getState();
                               if (state === 'SUCCESS'){
                                   component.set("v.stages",response.getReturnValue());
                                   // alert(component.get("v.stages"));
                                   // $A.get('e.force:refreshView').fire();
                               } else {
                                   //do something
                               }
                           }
                          );
        $A.enqueueAction(action);
	},
    getStage : function(component, event) {
		  var action = component.get('c.getCurrentStage');
        // alert(component.get("v.recordId"));
        action.setParams(
		{
			recId : component.get("v.recordId")
		});
        action.setCallback(component,
                           function(response) {
                               var state = response.getState();
                               if (state === 'SUCCESS'){
                                   component.set("v.stage",response.getReturnValue());
                                    $A.get('e.force:refreshView').fire();
                                   var container = component.find("container");
                                   $A.createComponent("c:OpportunityWizard",
                                                      {"recordId": component.get("v.recordId"),
                                                       "stg": component.get("v.stage")
                                                      
                                                      },
                                                      function(cmp) {
                                                          container.set("v.body", [cmp]);
                                                      });
                               } else {
                                   //do something
                               }
                           }
                          );
        $A.enqueueAction(action);
	}
})