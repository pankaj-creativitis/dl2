public with sharing class LeadHelper {
    // Convert Leads
    @InvocableMethod
    public static void convertLeads(List<Lead> lds) {
        List<Account> acctList = new List<Account>();
        List<Contact> contList = new List<Contact>();
        List<Opportunity> oppList = new List<Opportunity>();
        for(Lead ld : lds){
            String recordType = ld.Loan_Type__c;
            String leadSource = ld.LeadSource;
            
            Database.LeadConvert lc = new Database.LeadConvert();
            lc.setLeadId(ld.id);
            
            LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
            lc.setConvertedStatus(convertStatus.MasterLabel);
            
            Database.LeadConvertResult lcr = Database.convertLead(lc);
            System.assert(lcr.isSuccess());
            Contact cont = new Contact(Id=lcr.getContactId(), RecordTypeId='0122E000000YJDRQA4');
            // insert cont;
            contList.add(cont);
            
            Account acc = new Account(Id=lcr.getAccountId(), RecordTypeId='0122E000000YJDIQA4');
            // acc.FinServ__PrimaryContact__c = cont.Id;
            acctList.add(acc);
            // Contact convertedContact = [SELECT Id, FirstName, LastName, FinServ__LastFourDigitSSN__c FROM Contact WHERE Id = :lcr.getContactId()];
            
            
            Opportunity opp = new Opportunity(Id = lcr.getOpportunityId());
            if(recordType != null && recordType != ''){
                system.debug('recordType >> ' + recordType);
                // opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(recordType).getRecordTypeId();  
                opp.RecordTypeId = '012S0000000dmk4IAA';
            }
            opp.CloseDate=date.today().addMonths(1);
            if(leadSource==null || leadSource ==''){
                leadSource='Web';
            }
            opp.Name= cont.FirstName + ' Opportunity';
            opp.StageName='Personal Information';
            opp.AccountId=cont.AccountId;
            system.debug('masterCont ' + cont.AccountId);
            // opp.Primary_Contact__c = acc.FinServ__PrimaryContact__c;
            oppList.add(opp);
        }
        // upsert acctList;
        // upsert contList;
        // upsert oppList; 
    }
    
    
    // Duplicate detector, 
    // TBD: Below Method needs bulkification
    public static List<Contact> addLeadOrOpportunity(List<Lead> lds) {
        List<Lead> foundLeads = new List<Lead>();
        List<Account> acctList = new List<Account>();
        List<Contact> contList = new List<Contact>();
        List<Opportunity> oppList = new List<Opportunity>();
        List<Datacloud.FindDuplicatesResult> results;
        // try {
            results = Datacloud.FindDuplicates.findDuplicates(lds);
            // system.debug('results >> ' + results);
            
        // } catch (Exception ex) {
        //    return null;
        // }
        
        system.debug('results >>>> ' + results.size());
        // for (Integer i = 0; i < lds.size(); i++) {
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true];
        for (Integer i = 0; i < lds.size(); i++) {
            // system.debug('lds[i] >>>> ' + lds[i].Name + ' >>><<< ' + results[i].getDuplicateResults()[0]);
            // Find the first duplicate result with a match result, then use the first match record.
             if (results.size() > i)
            for (Datacloud.DuplicateResult dr : results[i].getDuplicateResults()) {
                if (dr.matchResults.size() > 0 && dr.getMatchResults()[0].matchRecords.size() > 0) {
                    Lead ldMatch = lds[i];
                    system.debug('lds[i] >> ' + lds[i]);
                    String recordType = lds[i].Loan_Type__c;
                    String leadSource = lds[i].LeadSource;
                    
                    if(dr.getMatchResults()[0].getEntityType() == 'Contact'){
                        Contact foundCon = (Contact) dr.getMatchResults()[0].getMatchRecords()[0].getRecord();
                        System.debug('foundCon >> '+ foundCon);
                        Contact fetchAcc = [SELECT Id, AccountId FROM Contact WHERE Id = :foundCon.Id];
                        Contact masterCont = new Contact(Id=foundCon.Id);
                         
                        Database.LeadConvert lc = new Database.LeadConvert();
                        Database.DMLOptions dml = new Database.DMLOptions();
                        
                        lc.setLeadId(lds[i].Id);
                        
                        // LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true];
                        lc.setConvertedStatus(convertStatus.MasterLabel);
                        System.debug('Lead >> '+ lc);
                        // lc.setAccountId(cont.AccountId);
                        
                        // Database.LeadConvertResult lcr = Database.convertLead(lc, dml);
                        Database.LeadConvertResult lcr = Database.convertLead(lc);
                        System.assert(lcr.isSuccess());
 
                        Contact convertedContact = new Contact(Id=lcr.getContactId());
                        system.debug('convertedContact >> ' + convertedContact);
                        merge masterCont convertedContact;
                        contList.add(masterCont);
                        
                        Opportunity opp = new Opportunity(Id = lcr.getOpportunityId());
                        if(recordType != null && recordType != ''){
                            system.debug('recordType >> ' + recordType);
                            opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(recordType).getRecordTypeId();                           
                        }
                        opp.CloseDate=date.today().addMonths(1);
                        if(leadSource==null || leadSource ==''){
                            leadSource='Web';
                        }
                        // TBD: Remove Home Loan Hard Coding
                        opp.Name= foundCon.Name + ' Home Loan';
                        opp.StageName='Personal Information';
                        opp.AccountId=fetchAcc.AccountId;
                        opp.Primary_Contact__c = masterCont.Id;
                        system.debug('masterCont ' + masterCont.AccountId);
                        oppList.add(opp);
                        // update opp;
                    }
                }
                break;
            }
            
        
        }
        update oppList;
        // delete acctList;
        return contList;
    }   
}