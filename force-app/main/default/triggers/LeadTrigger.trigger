trigger LeadTrigger on Lead (after insert, after update, before insert, before update) {
    TriggerFactory.createTriggerDispatcher(Lead.sObjectType);
}