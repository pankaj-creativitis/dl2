({
    init : function(cmp) {
        $A.createComponent(
            "lightning:button",
            {
                "aura:id": "findableAuraId",
                "label": "Press Me",
                "onclick": cmp.getReference("c.handlePress")
            },
            function(newButton, status, errorMessage){
                //Add the new button to the body array
                if (status === "SUCCESS") {
                    var body = cmp.get("v.body");
                    body.push(newButton);
                    cmp.set("v.body", body);
                }
                else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                    // Show offline error
                }
                else if (status === "ERROR") {
                    console.log("Error: " + errorMessage);
                    // Show error message
                }
            }
        );
    }, 
    
    login: function(cmp){
        let url = cmp.get("v.op_url"); 
        window.location.href = url;  
    },
    
     handlePress : function(cmp) {
     let email = cmp.get("v.email"), 
            fname = cmp.get("v.fname"), 
            lname = cmp.get("v.lname"), 
            pass = cmp.get("v.password"), 
            startUrl = cmp.get("v.starturl"), 
            products = cmp.get("v.products"), 
            hasOptedSolicit = cmp.get("v.hasOptedSolicit"),
            hasOptedTracking = cmp.get("v.hasOptedTracking");
        
        let products_list = (products && products.split('; ')) || [];
       
        let action = cmp.get("c.createExternalUser");
        action.setParams(
            { 
                username: email, 
                password: pass, 
                startUrl: startUrl,
                fname: fname, 
                lname: lname,
                products: products_list,
                hasOptedTracking: hasOptedTracking,
                hasOptedSolicit: hasOptedSolicit
            });

        action.setCallback(this, function(res) {
            if (action.getState() === "SUCCESS") {
                cmp.set("v.op_url", res.getReturnValue());
            } 
        });
        $A.enqueueAction(action);
        console.log("button pressed");
    }


})