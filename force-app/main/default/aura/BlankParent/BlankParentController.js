({
	doInit: function(component) 
	{
		var getDocumentTypes = component.get("c.getOppStage");
		getDocumentTypes.setParams(
		{
			"recordID" : component.get("v.recordId")
		});
		getDocumentTypes.setCallback(this, function(response) 
        {
			var state = response.getState();
			var stg = response.getReturnValue();
            if (state === "SUCCESS") 
            {   
				component.set('v.stage', stg);
			}
		});
		$A.enqueueAction(getDocumentTypes);
		
    },
})