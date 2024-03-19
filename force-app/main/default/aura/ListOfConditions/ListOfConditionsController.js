({
   
    
	handleClick : function(component, event, helper) {
		
       // var toggleText = component.find("table");
       
        //$A.util.toggleClass(toggleText, "slds-show");
         component.set("v.showMe", !component.get("v.showMe"));
         helper.getListConditions(component,event);
         
    },
    
    save : function(component, event, helper) { 
    var objString ;
        var enteredInput = component.find("comments").get("v.value");
      var indexes=  enteredInput.match(/\d+/g).map(Number);
       var val2,j,finalString;
        var list=component.get("v.conditions");
      console.log("v.condition list",list);
        for(var i in indexes){
            for(j in list){
                if(indexes[i]==list[j].key){
                     objString = list[j].value.Object__c;
                    val2=list[j].value.Condition_Query__c;
                    finalString=enteredInput.replace(indexes[i],val2);
                   enteredInput=finalString;
                }    
            } 
        }
        helper.getSaveMethod(component,event,finalString,objString);
    }                   
})