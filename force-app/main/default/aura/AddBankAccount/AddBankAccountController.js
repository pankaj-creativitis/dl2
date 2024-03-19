({
	clickHandler : function(component, event, helper) {
		component.set("v.showbank", true);
	},
    goPerfios : function(component, event, helper) {
        component.set("v.showLoginCmp", true);
		component.set("v.showbank", false);
	},
    showOtpComp : function(component, event, helper) {
        component.set("v.showotp", true);
		component.set("v.showbank", false);
	},
    showLinkedBank : function(component, event, helper) {
        component.set("v.showaddedbank", true);
		component.set("v.showLoginCmp", false);
        component.set("v.showbank", false);
	}
})