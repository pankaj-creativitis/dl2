public class LeadAfterInsertTriggerHandler extends TriggerHandlerBase {
    public override void mainEntry(TriggerParameters tp) {
        List<Lead> lds = tp.newList;
        LeadHelper.addLeadOrOpportunity(lds);
    }
}