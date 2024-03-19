trigger OpportunityTrigger on Opportunity (after insert, after update, before insert, before update) {
    // Hack for Conga START
    /*
    if (Trigger.isInsert || Trigger.isUpdate) {
        for(Opportunity opp : Trigger.New) {
            if(opp.Primary_Contact__c==null){
                Account acc = [SELECT Id, FinServ__PrimaryContact__c
                               FROM Account
                               WHERE Id = :opp.AccountId];
                opp.Primary_Contact__c = acc.FinServ__PrimaryContact__c;
                
            }
        } 
        
    }
*/
    // Hack for Conga END
 	 TriggerFactory.createTriggerDispatcher(Opportunity.sObjectType);
}