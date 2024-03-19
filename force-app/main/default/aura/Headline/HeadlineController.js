({
    doInit: function(component){
        var fldSet = component.get("v.fldStr").split(',');
        component.set('v.flds', fldSet);
    },
	toggle : function(component, event, helper) {
        
        var toggleText = event.getSource();
        
        var icn = toggleText.get("v.iconName");
        var id = toggleText.get("v.id");
        var cmpSummary = component.find("summary");        
        // var x = document.getElementById(component.get("v.detailsApi"));
       // var x = document.getElementById(component.get("v.detailsApi"));
        // var x = component.find(cmpName);
        // alert(x);
        if(icn == 'utility:dash') {
            toggleText.set("v.iconName","utility:add");
            // x.style.display = "none";
            $A.util.addClass(cmpSummary, "slds-hide");
        }else {
            toggleText.set("v.iconName","utility:dash");
            // x.style.display = "block";
            $A.util.removeClass(cmpSummary, "slds-hide");
        }
        /*
        if (x.style.display === "block") {
            x.style.display = "none";
            toggleText.set("v.iconName","utility:add");
        } else {
            x.style.display = "block";
            toggleText.set("v.iconName","utility:dash");
        }
        */
    },
    handleOnSuccess : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The record has been updated.",
            "type": "success"
        });
        toastEvent.fire();
        
    }
})