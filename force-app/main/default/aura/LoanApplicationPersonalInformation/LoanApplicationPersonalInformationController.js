({  
   /* handleClick: function (component, event, helper) {              	
       var address = component.get("v.recordId");
       var vfUrl ='/apex/ProfilePictureUpload?Id='+address;
       var urlEvent = $A.get("e.force:navigateToURL");
       urlEvent.setParams({
                "url": vfUrl
       });
       urlEvent.fire();
     },*/
    
    openModel: function(component, event, helper) {
      // for Display Model,set the "isOpen" attribute to "true"
      component.set("v.isOpen", true);
   },
     closeModel: function(component, event, helper) {
      // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
      component.set("v.isOpen", false);
   },
})