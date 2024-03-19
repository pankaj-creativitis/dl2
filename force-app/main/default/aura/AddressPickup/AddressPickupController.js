({
    myAction : function(component, event, helper) {
        var address = component.find("myaddress");
        // console.log(address.get("v.province"));
        component.set("v.state", address.get("v.province")); 
        component.set("v.countryValue", address.get("v.country")); 
        component.set("v.postalCodeValue", address.get("v.postalCode")); 
        component.set("v.cityValue", address.get("v.city")); 
        component.set("v.streetValue", address.get("v.street")); 
        
    }
})