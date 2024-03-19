({
	 /* show-hide functionality */
    toggle : function(component, event, helper) {
        
        var toggleText = event.getSource();
        
        var icn = toggleText.get("v.iconName");
        var id = toggleText.get("v.id");
        var x = document.getElementById(id + 'summary');
        if (x.style.display === "block") {
            x.style.display = "none";
            toggleText.set("v.iconName","utility:add");
        } else {
            x.style.display = "block";
            toggleText.set("v.iconName","utility:dash");
        }
    }
})