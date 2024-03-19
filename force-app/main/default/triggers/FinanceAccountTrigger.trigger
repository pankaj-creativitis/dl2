trigger FinanceAccountTrigger on FinServ__FinancialAccount__c (after  insert) {
    if(trigger.isAfter  && trigger.isInsert )
    { 
        for (FinServ__FinancialAccount__c financeAcc : Trigger.new) {
            
            system.debug('AccountType is-----> '+financeAcc.FinServ__RecordTypeName__c);
            if (financeAcc.FinServ__RecordTypeName__c == 'Savings Account')
            {
                List<Id> accounts = new List<Id>();
                //SavingAccountController.updateAccountStatus(financeAcc.FinServ__PrimaryOwner__c,'Saving');
                system.debug('Account creation saving account id '+financeAcc.FinServ__PrimaryOwner__c);
                accounts.add(financeAcc.FinServ__PrimaryOwner__c);
                SavingAccountController.updateContactForAWS(accounts,financeAcc.Id);
                system.debug('Webmerge Accout Id----->'+financeAcc.FinServ__PrimaryOwner__c);
                WebmergeBulkRecordProcessed.goRecordsToProcess(financeAcc.FinServ__PrimaryOwner__c);
            }
            else 
            //else
            {
                String onlineId = '';
                //SavingAccountController.updateAccountStatus(financeAcc.FinServ__PrimaryOwner__c,'CheckIn');
                
                Account acc = [Select SavingAccountStatus__c,onlineId__c from Account where Id = :financeAcc.FinServ__PrimaryOwner__c];
                system.debug('Account creation checkin account id '+financeAcc.FinServ__PrimaryOwner__c+'Online Id'+acc.onlineId__c);
                system.debug('Finance Account Id'+financeAcc.Id+ 'Mambu API Status---->'+acc.SavingAccountStatus__c);
                if (acc.SavingAccountStatus__c)
                {
                	CheckinAccountController.createCheckInAccount(acc.onlineId__c,financeAcc.FinServ__PrimaryOwner__c, 
                                                                  financeAcc.Id);
                }
                
            }
            
        }
   
    }
}