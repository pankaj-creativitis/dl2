@isTest
public class ConvertLeadsTest {
    @isTest static void LeadAssign_Test(){
        List<Lead> leads = new List<Lead>();
        for(Integer i=0; i<10; i++){
            Lead l = new Lead(Company = 'Company '+i, LastName='LastName '+i, Status='New');
            leads.add(l);
        }
        insert leads;
        List<id> leadIds = new List<id>();
        for(Lead ld:leads){
            leadIds.add(ld.Id);
        }
        ConvertLeads.LeadAssign(leadIds);
    }
}