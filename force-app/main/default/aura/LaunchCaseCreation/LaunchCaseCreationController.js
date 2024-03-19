({
	handleClick : function(component, event, helper) {
        component.set("v.launched",false);
		var flow = component.find("flowData");
    flow.startFlow("Case_Authentication");
	}
})