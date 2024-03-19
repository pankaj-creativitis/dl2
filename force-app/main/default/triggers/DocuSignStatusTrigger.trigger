trigger DocuSignStatusTrigger on dsfs__DocuSign_Status__c(after  insert) {
    if(trigger.isAfter  && (trigger.isInsert || trigger.isUpdate) )
    { 
          List<Id> accIds = new List<Id>();
       for(dsfs__DocuSign_Status__c dc:trigger.new){
      //if(dc.dsfs__Envelope_Status__c =='complete'){
       accIds.add(dc.dsfs__Company__c);    
      // }
    }
     List<FinServ__FinancialAccount__c> finAccounts = [SELECT FinServ__FinancialAccountNumber__c,FinServ__PrimaryOwner__c,FinServ__Balance__c,FinServ__FinancialAccountType__c,Sub_type__c FROM FinServ__FinancialAccount__c where
                  FinServ__PrimaryOwner__c in :accIds];
        System.debug('accountid'+accIds);
         System.debug('finAccounts'+finAccounts);
        /*for (FinServ__FinancialAccount__c financeAcc : finAccounts) {
              if (financeAcc.FinServ__FinancialAccountType__c == 'Savings')
            {
                List<Id> accounts = new List<Id>();
                accounts.add(financeAcc.FinServ__PrimaryOwner__c);
                SavingAccountController.updateContactForAWS(accounts);
            }
            else if (financeAcc.FinServ__FinancialAccountType__c == 'Checking')
            {
                String onlineId = '';
                Account acc = [Select onlineId__c from Account where Id = :financeAcc.FinServ__PrimaryOwner__c];
                CheckinAccountController.createCheckInAccount(acc.onlineId__c);
            }
 
        }*/
	}
}