@isTest public class uniteddigitalbankTest {
    @isTest static void uniteddigitalbank_Test(){
        Account a = new Account(Name = 'Test');
        insert a; 
        uniteddigitalbank u = new uniteddigitalbank();
        system.assert(u.accounts.size() > 0);
    }
}