({
    doInit : function(component, event, helper) {
        debugger;
        var roi = component.get("v.roiVal");
        if(roi == "0"){
            component.set("v.IsROI",false);
        }
        else{
            component.set("v.IsROI",true);
        }
    },
    
    backBtn : function(component,event, helper) {
         		helper.backBtnToEligibilty(component, event);  
    },
    
    calculateEMI: function(cmp, event, helper) {
    	debugger;
        helper.calculateEMI(cmp); 	     
        cmp.set("v.isModalOpen", true);
    },
    
    handleNext : function(component, event, helper) {
        //debugger;
        helper.createOpportunityOrGotoCReateCustomer(component,event);
    },
    
    /*loanAmtChangeValidation : function(component, event, helper) {
        debugger;
        var reqLoanCom = component.find('txtReqLoanAmt');
        var reqLoanAmt = reqLoanCom.get('v.value');
        var maLoanAmt = component.get('v.loanResult.loanAmt');
        if(reqLoanAmt <= maLoanAmt) {
            reqLoanAmt.set('v.validity', {valid:false, badInput :true});
            reqLoanAmt.showHelpMessageIfInvalid();
            
        }
    }*/
})