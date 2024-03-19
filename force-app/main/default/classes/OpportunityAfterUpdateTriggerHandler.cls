public class OpportunityAfterUpdateTriggerHandler extends TriggerHandlerBase{
    
    public override void mainEntry(TriggerParameters tp) {
        System.debug('trigger============>>>>>>>>'+tp);
       List<Opportunity> opp = tp.newList;
        for(Opportunity op:opp){
            if(op.StageName == 'Verification'){
                OpportunityHelper.getVerificationRecordMetadata(op);
            } else if(op.StageName == 'Underwriting'){
                OpportunityHelper.processUnderwriting(op.Id);
            }else if(op.StageName == 'Disbursement & Closure'){
                OpportunityHelper.createLoanApplication(op.id);
            }
            else if(op.StageName == 'Eligibility Details'){
                // OpportunityHelper.getPicklistValueBasedonRecordType('Opportunity', 'StageName', 'Home_Loan');
                OpportunityHelper.creditScoreandincomeUpdate(op.id);
            }
            
        }
       
    }
}