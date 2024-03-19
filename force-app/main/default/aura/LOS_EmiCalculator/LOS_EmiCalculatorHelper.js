({
    showToastError : function(message){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "message": message,
            "duration":' 5000',
        });
        toastEvent.fire(); 
    }, 
    
    backBtnToEligibilty :function(component,event) {
        debugger;             
        
        //var months = component.get("v.tentureVal");   
        var eliDetails = component.get("v.eliDetails");
        //var netIncomeVal =  '' + eliDetails.netIncomeVal;
        //var obligationVal = '' + eliDetails.obligationVal;
        //var selectedEmployeeMaster = '' + eliDetails.selectedEmployeeMaster;
        
        
        var evt = $A.get("e.c:NavigateComponent");
        evt.setParams({"componentToRedirect": "EligibilityCalculator", 
                       "existingCustomerNameVal": component.get("v.existingCustomerNameVal"),
                       //"netIncomeVal" : netIncomeVal,
                       //"obligationVal" : obligationVal,
                       //"eliDetails":eliDetails,
                       //"selectedEmployeeMaster" : selectedEmployeeMaster,
                       "newCustomerNameVal": component.get("v.newCustomerNameVal"),
                       "isExistingCustomer": component.get("v.isExistingCustomer")});
        evt.fire();
    },
    
    calculateEMI : function(component, event) {
        //debugger;
        var existCust = component.get("v.existingCustomerNameVal.Id");
        var newCust = component.get("v.newCustomerNameVal");
        var loanAmount = component.get("v.requiredLoanAmtVal");
        var rate = component.get("v.roiVal");
        var months = component.get("v.tentureVal");
        var isExiCust = component.get("v.isExistingCustomer");
        console.log(isExiCust);
        console.log($A.util.isEmpty(newCust));
        var processingFeePercent = component.get("v.processingFeeVal");
        var gst = component.get("v.gstVal");
        var showProcessFee = !(processingFeePercent == null || processingFeePercent == 0 || processingFeePercent.length == 0);
        
        //Mohini
        if(loanAmount > 2500000){ 
            this.showToastError('Required Loan Amount Can Not Be Greater Than 25 LaKH.');
        }//End
        if($A.util.isEmpty(newCust) && (isExiCust == false || $A.util.isUndefinedOrNull(isExiCust))){// $A.util.isEmpty(newCust)){
            this.showToastError('Please Enter Customer Name.'); 
        }
        else if($A.util.isEmpty(loanAmount) || loanAmount == 0){
            this.showToastError('Please Enter Loan Amount.');
        }
            else if($A.util.isEmpty(rate) || rate == 0){
                this.showToastError('Please Enter ROI.'); 
            }
                else if($A.util.isEmpty(months) || months == 0){
                    this.showToastError('Please Enter Loan Tunere.'); 
                }
                    else if(months > 84){
                    this.showToastError('Loan Tenure should not be exceeds more than 84 Months.'); 
                }
                    else if($A.util.isEmpty(processingFeePercent) || processingFeePercent == 0){
                        this.showToastError('Please Enter Processing Fee.');
                    }
                        else if($A.util.isEmpty(gst) || gst == 0){
                            this.showToastError('Please Enter GST.');
                        }
                            else if (!(loanAmount == null || loanAmount.length == 0 || loanAmount == 0 || months == null || months.length == 0 || months == 0 || rate == null || rate.length == 0 || rate == 0)) {
                                debugger;
                                var rate1 = rate / 1200;
                                var emi= loanAmount * rate1 / (1 - (Math.pow(1 / (1 + rate1), months)));
                                var interest = (emi * months) - loanAmount;
                                var processingFee;
                                if(processingFeePercent>100){
                                    processingFee = processingFeePercent;
                                }
                                else{
                                    processingFee = loanAmount * (processingFeePercent/100);
                                }        
                                var totalAmount = emi * months;
                                var gstAmount = (gst * processingFee) / 100;
                                var processingFeeIncludingGst = processingFee + gstAmount;
                                
                                component.set("v.GstInRupees", gstAmount.toFixed(2));
                                component.set("v.PayableEMI" , Math.round(emi));
                                component.set("v.GstAndProcessingFeesInRupees", Math.round(processingFeeIncludingGst)); 
                                //cmp.set("v.TotalAmount" , totalAmount.toFixed(2) ); 
                                component.set("v.ProcessingFeeInRs" , processingFee.toFixed(2));
                                //cmp.set("v.InterestPayable", interest.toFixed(2));
                                
                                //Mohini
                                //component.set("v.emiVal", emi.toFixed(2) );
                                component.set("v.emiVal", Math.round(emi) );
                                //End
                                //console.log("emiCalculate===>"+emi);
                                //var txtArea = component.find("txtArea");
                                //txtArea.set("v.value", emi.toFixed(2));
                                //component.set("v.result", false);
                                component.set("v.result", true);
                                component.set("v.processingFeeAmount", processingFee);
                            }
    },
    createOpportunityOrGotoCReateCustomer : function(component,event){        
        
        debugger;
        var extCustomer = component.get("v.existingCustomerNameVal");
        var newCustomer = component.get("v.newCustomerNameVal");
        //var isDefined = !$A.util.isUndefined(extCustomer.Id);
        //var isEmpty = $A.util.isEmpty(extCustomer.Id);
        var isExistingCustomer = component.get("v.isExistingCustomer");
        
        if(isExistingCustomer)
        {
            console.log('extCustomer >> ' + extCustomer.Id + ' # ' + extCustomer.Name);
            debugger;
            /*var params = {existingCustomerVal : component.get("v.existingCustomerNameVal"),
                      emiDetails : {roi : component.get("v.roiVal"), 
                                    reqLoanAmt : component.get("v.requiredLoanAmtVal"),
                                    tenure : component.get("v.tentureVal"),
                                    processingFee : component.get("v.processingFeeVal"),
                                    emi : component.get("v.emiVal"),
                                    maxEligibleAmt : component.find("netIncome").get("v.max")
                                   },
                      isExistingCustomer : isExistingCustomer};
        console.log('===params==='+params);
        this.navigateToCustomCmp("PLA_CreateAccount", params);   */  
        
        
        debugger
        
        var emiDetails = {roi : component.get("v.roiVal"), 
                          reqLoanAmt : component.get("v.requiredLoanAmtVal"),
                          tenure : component.get("v.tentureVal"),
                          processingFee : component.get("v.processingFeeVal"),
                          emi : component.get("v.emiVal"),
                          maxEligibleAmt : component.get("v.loanResult.loanAmt"),
                          processingFeeAmount : component.get("v.processingFeeAmount")
                         }
        var evt = $A.get("e.c:NavigateComponent");
        evt.setParams({"componentToRedirect": "CustomerEntry", 
                       "existingCustomerNameVal" : component.get("v.existingCustomerNameVal"),
                       "isUsingOffer" : component.get("v.isUsingOffer"),
                       "emiDetails" : emiDetails,
                       "isExistingCustomer" : isExistingCustomer,
                       "isUserValidForOffer" :component.get("v.isUserValidForOffer"),
                       "IsUsingNew" : component.get("v.IsUsingNew")
                      });
        evt.fire();
        
    }
    else
    {
        debugger;
        /*  var params = {newCustomerNameVal : component.get("v.newCustomerNameVal"),
                      emiDetails : {roi : component.get("v.roiVal"), 
                                    reqLoanAmt : component.get("v.requiredLoanAmtVal"),
                                    tenure : component.get("v.tentureVal"),
                                    processingFee : component.get("v.processingFeeVal"),
                                    emi : component.get("v.emiVal"),
                                    maxEligibleAmt : component.find("netIncome").get("v.max")
                                   },
                      isExistingCustomer : isExistingCustomer};
        console.log('===params==='+params);
        this.navigateToCustomCmp("PLA_CreateAccount", params);*/
        
        var emiDetails = {roi : component.get("v.roiVal"), 
                          reqLoanAmt : component.get("v.requiredLoanAmtVal"),
                          tenure : component.get("v.tentureVal"),
                          processingFee : component.get("v.processingFeeVal"),
                          emi : component.get("v.emiVal"),
                          maxEligibleAmt : component.get("v.loanResult.loanAmt"),
                          processingFeeAmount : component.get("v.processingFeeAmount")
                         }
        
        var evt = $A.get("e.c:NavigateComponent");
        evt.setParams({"componentToRedirect": "CustomerEntry", 
                       
                       "emiDetails" : emiDetails,
                       "existingCustomerNameVal" :component.get("v.existingCustomerNameVal"),
                       "isExistingCustomer" : isExistingCustomer,
                       "isUserValidForOffer" :component.get("v.isUserValidForOffer"),
                       "IsUsingNew" : component.get("v.IsUsingNew")
                      });
        evt.fire();
    }
}
    
})