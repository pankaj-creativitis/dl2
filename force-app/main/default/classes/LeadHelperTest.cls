@isTest
public class LeadHelperTest {
    
    @isTest static void addLeadOrOpportunityTest()
	{
        Account ac1 = new Account();
        ac1.Name = 'Account One';
        insert ac1;
        
        Contact cont1 = new Contact();
        cont1.AccountId = ac1.Id;
        cont1.FirstName = 'Account';
        cont1.LastName = 'One';
        cont1.Email = 'lastone@gmail.com';
        insert cont1;
        
        Account ac2 = new Account();
        ac2.Name = 'Account Two';
        insert ac2;
        
        Contact cont2 = new Contact();
        cont2.AccountId = ac2.Id;
        cont2.FirstName = 'Account';
        cont2.LastName = 'Two';
        cont2.MobilePhone = '3992837774';
        insert cont2;
        
        List<Lead> testLeads = new List<Lead>();
        Lead ld3 = new Lead();
        ld3.LastName = 'LastTwo';
        ld3.Email = 'lasttwo@gmail.com';
        testLeads.add(ld3);
		
        Lead ld1 = new Lead();
        ld1.LastName = 'Last';
        ld1.MobilePhone = '3992837774';
        testLeads.add(ld1);
        
        Lead ld2 = new Lead();
        ld2.LastName = 'LastOne';
        ld2.Email = 'lastone@gmail.com';
        testLeads.add(ld2);
        
        insert testLeads;
       
        LeadHelper.convertLeads(testLeads);
        LeadHelper.addLeadOrOpportunity(testLeads);
	}
}