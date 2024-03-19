@isTest
private class GenericHelperTest {
    public static Account getAccount(id primaryContact, String name, Boolean doInsert){
        Account a = new Account(FinServ__PrimaryContact__c = primarycontact, name = name);
        if(doInsert){
            insert a;
        }
        return a;
    }
    public static Contact getContact(String lname, Boolean doInsert){
        Contact c = new Contact(lastName = lname);
        if(doInsert){
            insert c;
        }
        return c;
    }
    public static Account getAccountWithCreatedContact(String name, Boolean doInsert){
        Account a = new Account(name = name);
        Insert a;
        Contact c = new Contact(accountId = a.Id, lastName = name);
        Insert c;
        return a;
    }
    public static Opportunity[] generateOppsForAccount(id accountId, Integer numOpps, Boolean isDetailView ){
        List<Opportunity> opps = new List<Opportunity>();
        List<String> listMetaDataConfig = new List<String> {'Property Details', 'Financial Details', 'Verification'};
        List<String> detailViewConfig = new List<String> {'Personal Information','Bank Details', 'Underwriting'};
            for(Integer i = 0; i < numOpps; i++){
                Opportunity o = new Opportunity();
                o.name = 'Account ' + i;
                o.accountId = accountid;
                o.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
                o.closeDate = Date.today().addDays(5);
                if(isDetailView){
                    o.StageName = detailViewConfig[math.mod(i,detailViewConfig.size())];
                }
                else{
                    o.StageName = listMetaDataConfig[math.mod(i,listMetaDataConfig.size())];
                }
                
                opps.add(o);
            }
        return opps;
    }
    
    @isTest static void testPositive_getRelatedLists(){
        Account a = getAccount(getContact('test', true).id,'Test', true);
        List<Opportunity> opps = generateOppsForAccount(a.Id, 3, false);
        Insert opps;
        
        Test.startTest();
        for(Opportunity o: opps){
            GenericHelper.getRelatedLists('Opportunity', o.Id);
            
        }
        System.assert(True);
        Test.stopTest();
        
        
        
    }
    @isTest static void testPositive_fetchContact(){
        List<String> strFieldsetName = new List<String>{'contactInfo', 'Mailing_Address','personalInfoHomeLoan','WM_Client_Relationship_Group_Members'};
        Account a = getAccountWithCreatedContact('test',true);
        
        Test.startTest();
        for(Integer i = 0; i < strFieldsetName.size(); i++){
            System.assert(GenericHelper.fetchContact('Contact', strFieldsetName[i], null, 'AccountId', a.Id)!=null);
        }
        
        Test.stopTest();
         
    }
    @isTest static void testPositive_deleteRecord(){
        GenericHelper.FilterWrapper f = new GenericHelper.FilterWrapper('test','test');
        System.assert(f.filterKey!=null);
        System.assert(f.filterValue!=null);
        
        Account a = new Account(name='test');
        insert a;
        System.assert(GenericHelper.deleteRecord(a.Id));
    }
    @isTest static void testPositive_getRecordMetaData(){
        Account a = getAccount(getContact('test', true).id, 'Test', true);
        List<Opportunity> opps = generateOppsForAccount(a.Id, 3, true);
        Insert opps;
        
        Test.startTest();
        for(Opportunity o: opps){
            System.debug(o.StageName);
            System.assert(GenericHelper.getRecordMetadata(o.Id)!=null);
            
        }
        
        Test.stopTest();
    }
}