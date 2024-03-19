trigger LimitTrigger on Limit__c (before insert) {
     for(Limit__c li : Trigger.New) {
         if(li.Limit__c == null){
             li.Level__c = 1;
         } else {
             String pId = li.Limit__c;
             Limit__c pli = [SELECT Id, Level__c FROM Limit__c WHERE Id = :pId];
             li.Level__c = pli.Level__c + 1;
         }
    }   
}