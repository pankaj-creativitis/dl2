({
    doInit: function(component) 
	{
        
        // $A.enqueueAction(noRM);
        // alert('running');
		var getDocumentTypes = component.get("c.getDocumentTypes");
		getDocumentTypes.setParams(
		{
			"recordID" : component.get("v.recordId")
		});
		getDocumentTypes.setCallback(this, function(response) 
        {
			var state = response.getState();
			
            if (state === "SUCCESS") 
            {   
                var objectList = response.getReturnValue();
                component.set('v.documentTypes', objectList);
                console.log('documentTypes >> ' + JSON.stringify(response));
                console.log('documentTypes2 >> ' + response);
                /*
                var noRM = component.get("c.isNotRM");
                noRM.setCallback(this, function(response1) 
                                 {
                                     var state1 = response1.getState();
                                     var response1 = response1.getReturnValue();
                                     alert('Hello');
                                     if (state1 === "SUCCESS") 
                                     {   
                                         alert(response1.getReturnValue());
                                         component.set('v.notRM', response1);
                                     }
                                 });
                                 */

			}
		});
		$A.enqueueAction(getDocumentTypes);
		
        /* Temporary comment for demo
		var isUserReviewer = component.get("c.isUserReviewer");
		isUserReviewer.setCallback(this, function(response) 
        {
			var state = response.getState();
			var response = response.getReturnValue();
            if (state === "SUCCESS") 
            {   
				component.set('v.reviewer', response);
			}
		});
		$A.enqueueAction(isUserReviewer);	
        */
				
    },

    openModal: function(component, event, helper) 
	{
        component.set("v.isOpen", true);
    },

	closeImageModel: function(component, event, helper) 
	{
		component.set("v.imageModal", false);
	},

	approveImage: function(component, event, helper) 
	{
		helper.makeComment(component, "approve");
	},

	rejectImage: function(component, event, helper) 
	{
		helper.makeComment(component, "reject");
	},

	commentImage: function(component, event, helper) 
	{
		helper.makeComment(component, "comment");
	},


    handleView: function(component, event, helper) 
	{
		component.set("v.attchid" , event.getSource().get("v.title"));
		var documentList = component.get("v.documentTypes");
		for (var i = 0; i < documentList.length; i++) 
		{
			if( event.getSource().get("v.title") === documentList[i].attachmentId)
			{
				component.set("v.comments", documentList[i].commentList);
				component.set("v.docId" , documentList[i].documentValidationId);
			}
		}
        component.set("v.imageModal", true);
    },

    closeModel: function(component, event, helper) 
	{
        component.set("v.isOpen", false);
    },

    handleFilesChange : function(component, event, helper) {
        component.set("v.showSpinner",true);
        var documentType = component.find("selectDocType").get("v.value");
        var file = component.find("uploadedDocument").get("v.files")[0];
        
        helper.saveFile(component, documentType, file, event);
        component.find("uploadedDocument").set("v.value",'');
        component.find("uploadedDocument").set("v.files",'');        
    },
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