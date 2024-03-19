trigger AccountObjTrigger on Account (after insert,after update ) {

    /*if(trigger.isAfter  && trigger.isUpdate )
    {
       for(Account account : Trigger.new)
       {
           if (account.AccountUpdateStatus__c == true)
           {
               List<Id> accounts = new List<Id>();
               accounts.add(account.id);
               FinServ__FinancialAccount__c finAccount =  [select Id, FinServ__FinancialAccountType__c,FinServ__PrimaryOwner__c from FinServ__FinancialAccount__c  where FinServ__PrimaryOwner__c = :account.Id and FinServ__RecordTypeName__c = 'Savings Account' order by createddate desc limit 1];
               system.debug('Financial Acc Id --->'+finAccount.id);
               SavingAccountController savingAccount = new SavingAccountController(accounts, finAccount.Id);
               System.enqueueJob(savingAccount);
               SavingAccountController.updateContactForAWS(accounts, finAccount.Id);
           }
           /*if(account.IsPersonAccount == true )
           {
              List<FinServ__FinancialAccount__c> finAccounts =  [select FinServ__FinancialAccountType__c,FinServ__PrimaryOwner__c from FinServ__FinancialAccount__c  where FinServ__FinancialAccountType__c = :account.Id];
               AccountTriggerHandler.processAccounts(finAccounts);
           }
       }
    }*/
}