({
    launchFlow : function(component, event, helper) {
        component.set("v.isModalOpen", true);
        // Find the component whose aura:id is "flowData"
        var flow = component.find("flowData");
        // In that component, start your flow. Reference the flow's API Name.
        flow.startFlow("Purchase_Carbon_Credits");
    },
    
    closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.isModalOpen", false);
    },
    
        setUFModalOpen : function(component, event, helper) {
        component.set("v.isUFModalOpen", true);
        
    },
    
    closeUFModel: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.isUFModalOpen", false);
    },
    
    handleUploadFinished: function (cmp, event) {
        // Get the list of uploaded files
        var uploadedFiles = event.getParam("files");
        // alert("Files uploaded : " + uploadedFiles.length);

        // Get the file name
        uploadedFiles.forEach(file => console.log(file.name));
    },
    handleUploadFinishedEsg: function (cmp, event) {
        // Get the list of uploaded files
        var uploadedFiles = event.getParam("files");
        // alert("Files uploaded : " + uploadedFiles.length);

        // Get the file name
        uploadedFiles.forEach(file => console.log(file.name));
        
         var urlEvent = $A.get("e.force:navigateToURL");
          urlEvent.setParams({
            'url': '/esgdashboard'
          });
          urlEvent.fire();
        
    },
    
    
    submitDetails: function(component, event, helper) {
        // Set isModalOpen attribute to false
        //Add your code to call apex method or do some processing
        component.set("v.isModalOpen", false);
    },
})