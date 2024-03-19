public class LeadBeforeInsertTriggerHandler extends TriggerHandlerBase {

    public override void mainEntry(TriggerParameters tp) {
        List<Lead> lds = tp.newList;
        for(Lead ld: lds){
            if(ld.Company == null){
                ld.Company = 'Salesforce Contact';
            } 
        }
    }
}