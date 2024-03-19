@isTest public class CustomBotServiceTest {
    @isTest static void validateAccount_Test(){
        Contact c = new Contact(LastName = 'Test Contact', Email='fjsoj398d2@fj99cisj.com');
        Insert c;
        Account a = new Account(FinServ__PrimaryContact__c = c.id, Name = 'Account Test');
        insert a;
        a.AccountNumber = a.Id;
        update a;
        CustomBotService.ValidateAccountRequest req = new CustomBotService.ValidateAccountRequest();
        req.accountId = a.id;
        List<CustomBotService.ValidateAccountRequest> reqs = new List<CustomBotService.ValidateAccountRequest>();
        reqs.add(req);
        CustomBotService.validateAccount(reqs);
        
    }
}