({
	saveFile : function(component, docType, file, event) 
	{
        var t0 = performance.now();
        
        var fr = new FileReader();
        var self = this;
        fr.onloadend = function() {
            var dataURL = fr.result;            
            var base64Mark = 'base64,';
            var dataStart = dataURL.indexOf(base64Mark) + base64Mark.length;
            
            dataURL = dataURL.substring(dataStart);
            
            var t1 = performance.now();
            
            self.uploadFile(component, file, 
                            dataURL, docType, event);
        };
        
        fr.readAsDataURL(file);
        
    },

	makeComment  : function(component, actionDone)
	{ 
		var comment = component.find("commentBox").get("v.value");
		var docId = component.get("v.docId");
		var recordId = component.get("v.recordId");

		var handleAction = component.get("c.handleAction");
		handleAction.setParams(
		{
			"docId" : docId,
			"actionTaken" : actionDone,
			"commentMsg" : comment,
			"recordID" : recordId
		});


		handleAction.setCallback(this, function(response) 
        {
			var state = response.getState();
			var objectList = response.getReturnValue();
			console.log(objectList);
            if (state === "SUCCESS") 
            {   
				if(objectList.sucess)
				{
					component.set('v.documentTypes', objectList.docs);
					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						"title": "Success!",
						"type": "success",
						"message": "The record has been updated successfully."
					});
					toastEvent.fire();
				}
				else
				{
					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						"title": "Error!",
						"type": "error",
						"message": objectList.errorMessage
					});
					toastEvent.fire();
				}
				component.set("v.imageModal", false);
			}
		});
		$A.enqueueAction(handleAction);		
	},
    
    uploadFile: function(component, file, base64Data, docType, event) 
	{
        var t2 = performance.now();
        
        
         window.setTimeout(
            $A.getCallback(function() {
                var action = component.get("c.saveTheFile"); 
                // alert('base64Data-->'+ base64Data);
                action.setParams({
                    parentId: component.get("v.recordId"),
                    fileName: file.name,
                    description: docType,
                    base64Data: encodeURIComponent(base64Data), 
                    contentType: file.type
                });
                
                var t3 = performance.now();
                action.setCallback(this, function(a) {
                    var state = a.getState();
                    // alert(t4);
                    var t4 = performance.now();
                    if (state === 'SUCCESS'){
                        var t5 = performance.now();
                        alert('File Uploaded Successfully!');
                        component.set("v.showSpinner",false);
                        component.set("v.isOpen",false);
						//the below is not working known issue
                        //$A.get('e.force:refreshView').fire();  
						//workaround below
						// location.reload();
                    } 
                    else if (state === "ERROR") {
                        var errors = a.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                alert("Error message: " + 
                                            errors[0].message);
                            }
                        } else {
                            console.log("Unknown error");
                        }
                    }
                        else {
                            // alert(JSON.stringify(a));
                            alert('Something went wrong, Please upload again..');
                        }
                    
                });
                
                $A.enqueueAction(action); 
                
            })
            , 5000
         );
    },
})