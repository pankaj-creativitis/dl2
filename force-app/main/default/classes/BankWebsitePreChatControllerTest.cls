@isTest
class BankWebsitePreChatControllerTest {
    static testMethod void testCreateLead() {
        ApexPages.currentPage().getParameters().put('endpoint', 'testpage.com');
    
        BankWebsitePreChatController ctrl = new BankWebsitePreChatController();
        ctrl.theLead.FirstName = 'Rick';
        ctrl.theLead.LastName = 'Sanchez';
        ctrl.clickChat();
        
        // verify that lead was created
        List<Lead> verifyLeads = [SELECT ID, FirstName, LastName FROM Lead];
        System.assertEquals(1, verifyLeads.size());
        System.assertEquals('Rick', verifyLeads[0].FirstName);
        System.assertEquals('Sanchez', verifyLeads[0].LastName);
    }
}