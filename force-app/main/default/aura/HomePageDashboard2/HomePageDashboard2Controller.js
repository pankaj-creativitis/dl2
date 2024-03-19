({
    doInit : function(component, event, helper) {
        var data = [
    		{'label':'Summary', 'value':'100','color':'light-green'},
            {'label':'Gross Total', 'value':'200','color':'light-blue'},
            {'label':'Extra', 'value':'400','color':'gray'}
			];
        component.set('v.outputData',data);
    }
})