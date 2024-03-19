public with sharing class AccountHelper {

    public static void testAfterInsert(List<SObject> sAccts){
        // Account acct = (Account)accts[0];
        /* Temp comment for einstein bot data
        List<Account> accts = (List<Account>)sAccts;
        for(Account acct:accts){
            System.debug('After Insert Message >> ' + acct.Name);
            List<Contact> conList = [SELECT Id FROM Contact where AccountId =:acct.Id];
            if(conList.size()>0){
                acct.FinServ__PrimaryContact__c = conList[0].Id;
            } 
        } */
        
        /*
        Opportunity opp = new Opportunity();
            opp.CloseDate=date.today().addMonths(1);
            opp.Name= 'New Opportunity';
            opp.StageName='Needs Analysis';
            opp.Type = 'Web';
            opp.RecordTypeId = '0122E000000YJDmQAO';
            
            opp.AccountId = '0012E00001pI1kUQAS';
            insert opp;
            System.debug('opp >> ' + opp);
*/
    }
}