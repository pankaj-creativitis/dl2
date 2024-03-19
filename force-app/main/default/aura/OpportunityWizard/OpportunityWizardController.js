({
	doInit : function(component, event, helper) {
        // alert('internal call');
		helper.getRecordMetadatas(component,event);
        
        helper.getLstMetadatas(component,event);
	},
    /*
    refreshMe : function(component, event, helper) {
        alert('refresh');
		$A.get('e.force:refreshView').fire();
	},
    */
    // below fn Will be deleted
    showDetail : function(component, event, helper) {
                 var tarBody = event.currentTarget.id + 'body';
        // alert(tarBody);
         // var ctarget = event.currentTarget;
       // ctarget.style.display = "none";
        var x = document.getElementById(tarBody);
         var ctarget = event.currentTarget.id;
        
        if (x.style.display === "block") {
            x.style.display = "none";
        } else {
            x.style.display = "block";
        }
        // alert(ctarget);
        // var id_str = ctarget.getAttribute("data-id");
        
        // console.log(ctarget);
        // alert(ctarget);
    },
    toggle : function(component, event, helper) {
        
        var toggleText = event.getSource();
        
        var icn = toggleText.get("v.iconName");
        var id = toggleText.get("v.id");
        var x = document.getElementById(id + 'body');
        if (x.style.display === "block") {
            x.style.display = "none";
            toggleText.set("v.iconName","utility:add");
        } else {
            x.style.display = "block";
            toggleText.set("v.iconName","utility:dash");
        }
    },
    afterScriptsLoaded : function(component, event, helper){
        
    }
})