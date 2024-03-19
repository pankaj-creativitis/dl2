public class LoanServicingHelper {
    
     @AuraEnabled
    public static List<RepaymentDetail> getSchemeRepayment(string OppId) {
        system.debug('In getSchemeRepayment'+OppId);
        
        // if(firstLoad=='wrong'){
        Opportunity existingOpp =         [select Id, EMI_Start_Date__c, Approved_Loan_Amount__c, Approved_ROI__c 
                                           FROM Opportunity WHERE Id = :OppId];
         
      system.debug('In existingOpp '+existingOpp);
        // Integer addMonths = Integer.valueOf(lst[0].Tenure__c);
        Date endDate = date.valueOf(existingOpp.EMI_Start_Date__c).addMonths(60);
        // existingOpp.Installment_End_Date__c = endDate;
        // permonth =  (amount * ((interest*(Math.pow((1+interest), tenure)))/(Math.pow((1+interest),tenure)-1)));
        // New Code begins:
        // var amount =component.get("v.Repaymentdata")[key].Scheme_Opportunity__r.Loan_Amount__c;
        Decimal permonth = 0;
        Decimal amount =existingOpp.Approved_Loan_Amount__c;
        Decimal interest=existingOpp.Approved_ROI__c;
        Integer tenure = 60;
                    
                    interest = (interest/100)/integer.valueof(12);
                    // permonth = Math.round(((amount * ((interest*(Math.pow((1+interest), tenure)))/(Math.pow((1+interest),tenure)-1)))*100)/100);
        Decimal onePlusInterest = 1+interest;  
        permonth =  (amount * ((interest*(onePlusInterest.pow(tenure)))/(onePlusInterest.pow(tenure)-1)));
                    permonth = permonth.setScale(2);
        system.debug('In permonth '+permonth);
                    Decimal totalAmount = (permonth*tenure).setScale(2);
                    Decimal interestPayable =     (totalAmount-amount).setScale(2);
                    // existingOpp.Loan_EMI__c = permonth;
        // existingOpp.Total_Interest_Payable__c = interestPayable;
                    // Decimal displayPerMonth = (permonth/factor).setScale(2);
                    // update existingOpp;
                    // New code ends
                    // 
          
        List<RepaymentDetail> repSummary = new List<RepaymentDetail>();
        
        for(integer i=1;i<61;i++){
            RepaymentDetail rep = new RepaymentDetail();
            if(i==1){
                rep.emiDate = existingOpp.EMI_Start_Date__c;
            } else {
                rep.emiDate = date.valueOf(existingOpp.EMI_Start_Date__c).addMonths(i);
            }
            
            rep.emi = permonth;
            if(Date.today()>rep.emiDate){
                rep.Status = 'PAID';
            } else {
                rep.Status = 'PENDING';
            }
            repSummary.add(rep);
            
        }
        return repSummary;
    }
    
     public class RepaymentDetail{            
        @AuraEnabled public Date emiDate{ get;set;}
        @AuraEnabled public Decimal emi { get;set;}
        @AuraEnabled public String Status { get;set;}
    }
}