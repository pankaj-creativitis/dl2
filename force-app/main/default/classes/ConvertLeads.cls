public class ConvertLeads {
    //--------------------------------------------------------------
    // Properties
    private static LeadAutoConvertSetting__c config = LeadAutoConvertSetting__c.getOrgDefaults();
    
    //--------------------------------------------------------------
    // Methods
    @InvocableMethod
    public static void LeadAssign(List<Id> LeadIds) {
        LeadStatus CLeadStatus= [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true AND MasterLabel='Qualify & Convert'];
        
        List<Database.LeadConvert> MassLeadconvert = new List<Database.LeadConvert>();
        for (Id currentlead: LeadIds) {
            
            Database.LeadConvert Leadconvert = new Database.LeadConvert();
            Leadconvert.setLeadId(currentlead);                
            Leadconvert.setConvertedStatus(CLeadStatus.MasterLabel);
            
           
            
            if (null != config.OwnerID__c) {
                Leadconvert.setOwnerId(config.OwnerID__c);    
            }
            
            MassLeadconvert.add(Leadconvert);
        }
        
        if (!MassLeadconvert.isEmpty()) {
            List<Database.LeadConvertResult> lcrs = Database.convertLead(MassLeadconvert);
            for(Database.LeadConvertResult lcr : lcrs){
                Account acc = new Account(Id=lcr.getAccountId());
                Contact convertedContact = new Contact(Id=lcr.getContactId());
            }
             
        }
        
    }
}