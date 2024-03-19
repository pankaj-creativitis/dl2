({
    doInit : function(component, event, helper) {
        // alert(component.get("v.stages"));
        if(component.get("v.stages")){
            helper.getStageArray(component, event);
        }
         helper.getStage(component, event);
        
        // alert(component.get("v.stage"));
	},
    
	refreshComponents : function(component, event, helper) {
        // alert('refresh me');
        // var childComponent = component.find('OpportunityWizard');
           // childComponent.refreshMe();
        var stageArr = JSON.parse(component.get("v.stages"));
        var stageName = component.get("v.stage");
        console.log(stageName);
        console.log(stageArr);
        var result = stageArr.find(x => x.value === stageName);
        var nxtIndex = result.index + 1;
        var nxtObj = stageArr.find(x => x.index === nxtIndex);
        console.log(nxtObj);
        /*
        for (var key in stageArr) {
            var obj = stageArr[key];
            
            console.log(obj);
        }
        */
        
        var action = component.get('c.moveNextStage');
        action.setParams(
		{
			recId : component.get("v.recordId"), 
			nxtStage : nxtObj.value
		});
        action.setCallback(component,
                           function(response) {
                               var state = response.getState();
                               if (state === 'SUCCESS'){
                                   component.set("v.stage", nxtObj.value);
                                   
                                   // var childCmp = component.find("OpportunityWizard")
                                   // childCmp.refreshMe();
                                   $A.get('e.force:refreshView').fire();
                               // alert('SUCCESS');
                               var container = component.find("container");
                                   $A.createComponent("c:OpportunityWizard",
                                                      {"recordId": component.get("v.recordId"),
                                                      "stg": component.get("v.stage")},
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