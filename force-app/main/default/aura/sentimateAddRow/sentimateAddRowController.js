({
    AddRow : function(component, event, helper){
        component.getEvent("AddRowEvt").fire();     
    },
    
    removeRow : function(component, event, helper){
       var evt =component.getEvent("DeleteRowEvt");
       evt.setParams({
           "indexVar" : component.get("v.rowIndex")
       });
        
        evt.fire();
    }, 
  
})