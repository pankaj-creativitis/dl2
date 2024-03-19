({
    createObjectData: function(component, event) {
        // get the contactList from component and add(push) New Object to List  
        var RowItemList = component.get("v.contactList");
        // alert(JSON.stringify(RowItemList));
        
        var appliedAmount = component.get('v.appliedAmt');
        var total = 0;
        
        for (var i  = 0; i < RowItemList.length; i++){
            total  += RowItemList[i].Amount__c;
        }
        // alert(total);
        var eligible = component.get('v.eligibleAmt');
        component.set('v.totalAmt', total);
        
        if(total>eligible){
            component.set('v.showerror', true);
        } else{
            component.set('v.showerror', false);
            RowItemList.push({
                'sobjectType': 'Future_Requirements__c',
                'Requirement_Date__c': '',
                'Amount__c': ''
            });
            
            // set the updated list to attribute (contactList) again    
            component.set("v.contactList", RowItemList);
        }
        
    },
    // helper function for check if first Name is not null/blank on save  
    validateRequired: function(component, event) {
        var isValid = true;
        var allContactRows = component.get("v.contactList");
        for (var indexVar = 0; indexVar < allContactRows.length; indexVar++) {
            if (allContactRows[indexVar].FirstName == '') {
                isValid = false;
                alert('First Name Can\'t be Blank on Row Number ' + (indexVar + 1));
            }
        }
        return isValid;
    },
})