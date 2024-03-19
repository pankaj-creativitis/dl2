trigger BRETrigger on BREObject__c (before insert,before update,after insert, after update) {

    Set<Id> acid = new Set<Id>();
   
   for(BREObject__c ct:Trigger.new) {
      
      acid.add(ct.id);
   
   }
    system.debug('BREObject__c ids  '+acid);
}