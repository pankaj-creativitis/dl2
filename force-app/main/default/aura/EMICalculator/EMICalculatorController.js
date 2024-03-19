({
    
    doInit: function(component, event, helper) { 
 
    },
    
    safeToLoad: function(component, event, helper) { 
        component.set("v.scriptsLoaded", true);
        
         // helper.getSchemaList(component,event);
    },

    calculateSummary: function(component, event, helper) { 
        var scriptsLoaded = component.get("v.scriptsLoaded");
        if(scriptsLoaded){
            component.set("v.generateSchedule",true);
            component.set('v.resetSummary', false);
        	helper.getSummaryInfo(component,event);
            // $A.get('e.force:refreshView').fire();
        }
    },

    openModel: function(component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        component.set("v.cssStyle", ".forceStyle .viewport .oneHeader.slds-global-header_container {z-index:0} .forceStyle.desktop .viewport{overflow:hidden}");
        component.set("v.isOpen", true);
        var cmpSummary = component.find('paySummary');
        var newmodal=component.find('newmodal');
        $A.util.removeClass(cmpSummary, 'slds-is-open');
        var cmpTarget = component.find('chevrondown');
        $A.util.addClass(cmpTarget, 'slds-hidden');
        $A.util.addClass(newmodal, 'toggle');
        helper.getRepayments(component,event);     
        
        // var recordPropertyDetail = event.getSource().getElement().getAttribute('data');
        // console.log('record adi' +recordPropertyDetail);
        
        
    },
    
    toggleSummary: function(component, event, helper) {
        var cmpTarget = component.find('paySummary');
        var newmodal = component.find('newmodal');
        // $A.util.toggleClass(cmpTarget, 'slds-is-open');
        var cmpright = component.find('chevronright');
        var cmpdown = component.find('chevrondown');
        $A.util.toggleClass(cmpright, 'slds-hidden');
        $A.util.toggleClass(cmpdown, 'slds-hidden');
        $A.util.toggleClass(cmpTarget, 'slds-is-open');
        $A.util.toggleClass(newmodal, 'toggle');
        
    },
    
    closeModel: function(component, event, helper) {
        component.set("v.cssStyle", ".forceStyle .viewport .oneHeader.slds-global-header_container {z-index:5} .forceStyle.desktop .viewport{overflow:visible}");
        component.set("v.isOpen", false);
    },
    
    
    applyCSS: function(component){
        component.set("v.cssStyle", ".forceStyle .viewport .oneHeader.slds-global-header_container {z-index:0} .forceStyle.desktop .viewport{overflow:hidden}");
    },
    revertCssChange: function(component){
        component.set("v.cssStyle", ".forceStyle .viewport .oneHeader.slds-global-header_container {z-index:5} .forceStyle.desktop .viewport{overflow:visible}");
    }
})