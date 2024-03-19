public class AccountTriggerHandler {

    
    
    /*public static void processAccounts(List<FinServ__FinancialAccount__c> finAccounts)
    {
       
        for(FinServ__FinancialAccount__c finAccount : finAccounts)
        {
            if (finAccount.FinServ__FinancialAccountType__c == 'Savings')
                {
                    List<Id> accounts = new List<Id>();
                    accounts.add(finAccount.FinServ__PrimaryOwner__c);
                    SavingAccountController.updateContactForAWS(accounts);
                }
                else if (finAccount.FinServ__FinancialAccountType__c == 'Checking')
                {
                    String onlineId = '';
                    Account acc = [Select onlineId__c from Account where Id = :finAccount.FinServ__PrimaryOwner__c];
                    CheckinAccountController.createCheckInAccount(acc.onlineId__c);
                }
        }
    }*/
}