({
getSummaryInfo: function(component, event)
    {
        var paymentFrequency;
         var startDate;
         var inpPaymentFrequency;
         var inpStartDate;
        var firstLoad;
        var factor = 1;
        var scale = '';
        var currencySyb = component.get('v.currency');
        // alert(component.get('v.resetSummary'));
        if(component.get('v.resetSummary')){
            // alert('from Server');
            paymentFrequency = parseInt(component.get('v.paymentFrequency'));
            startDate = new Date(component.get('v.installmentStartDate'));
            inpPaymentFrequency = component.get('v.paymentFrequency');
            inpStartDate = component.get('v.installmentStartDate');
            
            firstLoad = 'right';  
        }
        else {

            paymentFrequency = parseInt(component.find("opportunityEmploymentType").get("v.value"));
            startDate = new Date(component.find("startDate").get("v.value"));
            inpPaymentFrequency = component.find("opportunityEmploymentType").get("v.value");
            inpStartDate = component.find("startDate").get("v.value");
            
            firstLoad = 'wrong';
        }
        
        if(currencySyb == 'USD'){
            factor = 1000000;
            component.set('v.scale', 'M');
        } else if(currencySyb == 'INR'){
            factor = 100000;
            component.set('v.scale', 'Lacs');
        }


        var isError = 0;
        if ( Object.prototype.toString.call(startDate) === "[object Date]" ) {
          // it is a date
          if ( isNaN( startDate.getTime() ) ) {  // d.valueOf() could also work
            // date is not valid
              isError = 1;
          }
        }
        else {
          // component.set("v.recordError", "Please select a Start date" );
            isError = 1;
        }

        if (paymentFrequency==0) {
            isError = 1;
        } 
        var noDate = new Date('Thu Jan 01 1970 05:30:00 GMT+0530');
        if(noDate.getTime() === startDate.getTime()){
            isError = 1;
        }
		// alert(isError);
		// alert('inpStartDate '+inpStartDate);
        // alert('inpPaymentFrequency '+inpPaymentFrequency);
        if(!isError){
        var action = component.get('c.getSchemeRepayment');
        
        //Compound Interest formula
        // A = P * ((r*(1+r)^n)/((1+r)^n-1))
        
        // Set up the callback

        action.setParams({
            "OppId": component.get("v.recordId"),
            "paymentFrequency": inpPaymentFrequency,
            "startDate": inpStartDate,
            "firstLoad": firstLoad
        });
        console.log('Adi' +component.get("v.recordId"));
        action.setCallback(this, function(actionResult) {
            var cmpSumm = component.find("repSumm");
            // $A.util.removeClass(cmpSumm, "slds-hide");
            // $A.util.addClass(cmpSumm, "slds-show");
            component.set('v.Repaymentdata', actionResult.getReturnValue());
            var tenure;
            var permonth;
            // alert(JSON.stringify(actionResult.getReturnValue()));
            for(var key in component.get("v.Repaymentdata"))
            {
                var amount =component.get("v.Repaymentdata")[key].Scheme_Opportunity__r.Loan_Amount__c;
                var interest=component.get("v.Repaymentdata")[key].Interest__c;
                tenure = component.get("v.Repaymentdata")[key].Tenure__c;
                var downPayment = component.get("v.Repaymentdata")[key].Scheme_Opportunity__r.Net_Down_Payment__c;
                var totalCost = component.get("v.Repaymentdata")[key].Scheme_Opportunity__r.Amount;
                
                 if(component.get("v.Repaymentdata")[key].Scheme_Opportunity__r.RecordTypeId == '012f4000000FddWAAS'){
                    amount = totalCost;
                }
                
                if(paymentFrequency!==0){
                    if (paymentFrequency ==2){
                        tenure = tenure/6;
                    }
                    else if (paymentFrequency ==4){
                        tenure = tenure/3;
                    }
                        else if (paymentFrequency ==24){
                            tenure = tenure*2;
                        }
                            else if (paymentFrequency ==1){
                                tenure = tenure/12;
                            }
                                else if(paymentFrequency!=12 && paymentFrequency !=24){
                                    tenure = tenure/paymentFrequency;
                                } 
                    
                    interest = (interest/100)/paymentFrequency;
                    // permonth = Math.round(((amount * ((interest*(Math.pow((1+interest), tenure)))/(Math.pow((1+interest),tenure)-1)))*100)/100);
                    permonth =  (amount * ((interest*(Math.pow((1+interest), tenure)))/(Math.pow((1+interest),tenure)-1)));
                    permonth = permonth.toFixed(2);
					console.log('permonth-->'+permonth);
                    
                    var totalAmount = (permonth*tenure).toFixed(2);
                    var interestPayable =     (totalAmount-amount).toFixed(2);
                    
                    var displayPerMonth = (permonth/factor).toFixed(2);
                    var displayTotalAmount;
                    var displayInterest;
                    if(displayPerMonth<1){
                        displayPerMonth = permonth;
                        displayTotalAmount = totalAmount;
                        displayInterest = interestPayable;
                        component.set("v.inLakhs",false);
                    } else{
                        component.set("v.inLakhs",true);
                        displayTotalAmount = (totalAmount/factor).toFixed(2);
                    	displayInterest = (interestPayable/factor).toFixed(2);
                        // displayInterest = (interestPayable/100000).toFixed(2);
                    }
                    
                    component.set('v.totalamount', displayTotalAmount);
                    component.set('v.permonth' , displayPerMonth);
                    component.set('v.interest',displayInterest);
                    
                    //setOppDetails
                    //New code start
                    var action1 = component.get('c.setOppDetails');
        // pass the all selected record's Id's to apex method 
        var tenureStr = String(tenure);
                    var pFStr = String(paymentFrequency);
        action1.setParams({
            "OppId" : component.get("v.recordId"),
            "payFreq" : pFStr,
            "tenure": tenureStr,
            "interestPayable" : component.get("v.interest"),
            "loanEMI": component.get("v.permonth")
        });
        action1.setCallback(this, function(response1) {
            //store state of response
            var state = response1.getState();
            if (state === "SUCCESS") {
                // alert('success!');
            }
        });
        $A.enqueueAction(action1);
                    //New code end
                    
                }
            }
            var data = {
                
                datasets: [{
                    label: 'Break-up of Total Payment',
                    data: [totalAmount, interestPayable],
                    backgroundColor: [
						'#66cc66',
                        '#ffc266'
                    ],
                }],
                labels: [
                    'Principal Loan Amount',
                    'Total Interest'
                ],
                
            };

            console.log('is valid component = '+component.isValid());
            var el = component.find("doughnut_chart").getElement();
            var ctx = el.getContext("2d");
            var myDoughnutChart = new Chart(ctx, {
                type: 'doughnut',
                data: data,
                options:Chart.defaults.doughnut
            });
            $A.util.removeClass(cmpSumm, "slds-hide");
            $A.util.addClass(cmpSumm, "slds-show");
        });
        $A.enqueueAction(action);  
        }
        else {
            var cmpSumm = component.find("repSumm");
            $A.util.removeClass(cmpSumm, "slds-show");
            $A.util.addClass(cmpSumm, "slds-hide");
            
            component.set("v.generateSchedule",false);
        }
    },
    
    getRepayments: function(component, event)
    {
          var paymentFrequency = parseInt(component.find("opportunityEmploymentType").get("v.value"));
          var startDate = new Date(component.find("startDate").get("v.value"));
          var inpPaymentFrequency = component.find("opportunityEmploymentType").get("v.value");
          var inpStartDate = component.find("startDate").get("v.value");
           var firstLoad = 'correct';
        
        var factor = 1;
        var scale = '';
        var currencySyb = component.get('v.currency');
        // var paymentFrequency = parseInt(component.find("opportunityEmploymentType").get("v.value"));
        // var startDate = new Date(component.find("startDate").get("v.value"));
        var isError = 0;
        if ( Object.prototype.toString.call(startDate) === "[object Date]" ) {
          // it is a date
          if ( isNaN( startDate.getTime() ) ) {  // d.valueOf() could also work
            // date is not valid
            component.set("v.recordError", "Please select a Start date" );
              isError = 1;
          }
        }
        else {
          component.set("v.recordError", "Please select a Start date" );
            isError = 1;
        }

        if (paymentFrequency==0) {
            // Set error
            component.set("v.recordError", "Please select a Payment Frequency");
            isError = 1;
        }
        
        /*
        if(currencySyb == 'USD'){
            factor = 1000000;
            component.set('v.scale', 'M');
        } else if(currencySyb == 'INR'){
            factor = 100000;
            component.set('v.scale', 'Lacs');
        }
        */
        
        if(!isError){

        var action = component.get('c.getSchemeRepayment');
        
        //Compound Interest formula
        // A = P * ((r*(1+r)^n)/((1+r)^n-1))
        
        // Set up the callback
        action.setParams({
            "OppId": component.get("v.recordId"),
            "paymentFrequency": inpPaymentFrequency,
            "startDate": inpStartDate,
            "firstLoad": firstLoad
        });
        console.log('Adi' +component.get("v.recordId"));
        action.setCallback(this, function(actionResult) {
            component.set('v.Repaymentdata', actionResult.getReturnValue());
            var tenure;
            var permonth;
            for(var key in component.get("v.Repaymentdata"))
            {
                var amount =component.get("v.Repaymentdata")[key].Scheme_Opportunity__r.Loan_Amount__c;
                var interest=component.get("v.Repaymentdata")[key].Interest__c;
                tenure = component.get("v.Repaymentdata")[key].Tenure__c;
                var downPayment = component.get("v.Repaymentdata")[key].Scheme_Opportunity__r.Net_Down_Payment__c;
                var totalCost = component.get("v.Repaymentdata")[key].Scheme_Opportunity__r.Amount;
                
                if(component.get("v.Repaymentdata")[key].Scheme_Opportunity__r.RecordTypeId == '012f4000000FddWAAS'){
                    amount = totalCost;
                }

                if(paymentFrequency!==0){
                    if (paymentFrequency ==2){
                        tenure = tenure/6;
                    }
                    else if (paymentFrequency ==4){
                        tenure = tenure/3;
                    }
                        else if (paymentFrequency ==24){
                            tenure = tenure*2;
                        }
                            else if (paymentFrequency ==1){
                                tenure = tenure/12;
                            }
                                else if(paymentFrequency!=12 && paymentFrequency !=24){
                                    tenure = tenure/paymentFrequency;
                                } 
                    
                    interest = (interest/100)/paymentFrequency;
                    // permonth = Math.round(((amount * ((interest*(Math.pow((1+interest), tenure)))/(Math.pow((1+interest),tenure)-1)))*100)/100);
                    permonth =  (amount * ((interest*(Math.pow((1+interest), tenure)))/(Math.pow((1+interest),tenure)-1)));
                    permonth = permonth.toFixed(2);

                }
            }
            
            if(paymentFrequency!=0){
                var totalAmount = (permonth*tenure).toFixed(2);
                var interestPayable =     (totalAmount-amount).toFixed(2);
                
                
                    var displayPerMonth = (permonth/1000000).toFixed(2);
                    var displayTotalAmount;
                    var displayInterest;
                    if(displayPerMonth<1){
                        displayPerMonth = permonth;
                        displayTotalAmount = totalAmount;
                        displayInterest = interestPayable;
                        component.set("v.inLakhs",false);
                    } else{
                        component.set("v.inLakhs",true);
                        displayTotalAmount = (totalAmount/1000000).toFixed(2);
                    	displayInterest = (interestPayable/1000000).toFixed(2);
                    }
                
                /*    
                var displayPerMonth = (permonth/100000).toFixed(2);
                    var displayTotalAmount = (totalAmount/100000).toFixed(2);
                    var displayInterest = (interestPayable/100000).toFixed(2);
                    component.set('v.totalamount', displayTotalAmount);
                    component.set('v.permonth' , displayPerMonth);
                    component.set('v.interest',displayInterest);
                    */
                
                var balance = totalAmount - permonth;
                balance = balance.toFixed(2);
                var interestRate = interest*balance;
                interestRate = interestRate.toFixed(2);
                var principal = permonth - interestRate;
                principal = principal.toFixed(2);
                
                var dd = startDate.getDate();
                var mm = startDate.getMonth()+1; //January is 0!
                var yyyy = startDate.getFullYear();
                var arr = [];
                var dateVal;
                var endlimit =0;
                var i=0;
                if(paymentFrequency==4){
                    var qEnd = Math.floor(mm/3);
                    i=qEnd;
                    endlimit =tenure+qEnd;
                }
                else if(paymentFrequency==2){
                    var saEnd = Math.floor(mm/6);
                    i=saEnd;
                    endlimit =tenure+saEnd;
                }
                    else if(paymentFrequency==24){
                        var smEnd = mm*2;
                        i=smEnd;
                        endlimit =tenure+smEnd;
                    }
                        else{
                            i=mm
                            endlimit =tenure+mm;
                        }
                
                while(i< endlimit){
                    
                    
                    if(paymentFrequency==4){
                        mm +=3;
                    }
                    else if(paymentFrequency==2){
                        mm +=6;
                    }
                    else if(paymentFrequency==1){
                        yyyy +=1;
                    }
                        else if(paymentFrequency==24){
                            dd +=15;
                            if(mm<8 && mm%2==0){
                                if(mm==2){
                                    if(dd>28){
                                        mm +=1;
                                        dd=dd-28;
                                    }
                                } else {
                                        if(dd>30){
                                            mm +=1;
                                            dd=dd-30;
                                        } 
                                    }
                            } else if (mm<8 && mm%2!=0){
                                if(dd>31){
                                    mm +=1;
                                    dd=dd-31;
                                } 
                            }
                                else if (mm>=8 && mm%2==0){
                                    if(dd>31){
                                        mm +=1;
                                        dd=dd-31;
                                    } 
                                }
                                    else if (mm>=8 && mm%2!=0){
                                        if(dd>30){
                                            mm +=1;
                                            dd=dd-30;
                                        } 
                                    }
                        }
                            else{
                                mm +=1;
                            }
                    
                    
                    
                    
                    if(mm>12){
                        yyyy +=1;
                        mm = mm - 12;
                    }
                    dateVal = dd+'/'+mm+'/'+yyyy;
                    arr.push({
                        Date: dateVal,
                        EMI: permonth,
                        Interest: interestRate,
                        Principal: principal,
                        Balance: balance
                    });
                    balance -= permonth;
                    balance=balance.toFixed(2);
                    interestRate = interest*balance;
                    interestRate = interestRate.toFixed(2);
                    principal = permonth - interestRate;
                    principal = principal.toFixed(2);
                    i+=1; 
                }
                // alert('arr: '+JSON.stringify(arr));
                var summary = {arr:arr, totalCost:totalCost, downPayment:downPayment, Loan:amount, payAmount:totalAmount, Interest:(totalAmount-amount).toFixed(2)};
                console.log(JSON.stringify(summary));
                component.set("v.paymentSchedule",summary);
                console.log("Schema list Adi"+JSON.stringify(actionResult.getReturnValue()));
            }
        });
        $A.enqueueAction(action);  
        }   
    else{
            // alert('other loop');
            component.set("v.isOpen", false);
        }
        
    },
})