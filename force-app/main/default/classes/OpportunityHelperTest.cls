@isTest private class OpportunityHelperTest {
    static List<opportunity> generateData(){
        Contact c = new Contact(LastName= 'contTest');
        insert c;
        Account a = new Account(FinServ__PrimaryContact__c = c.Id, name = 'test');
        insert a;
        List<Opportunity> opps = new List<Opportunity>(); 
        Id homeLoan = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
        System.debug('Home Loan Id: ' + homeLoan);
        opps.add(new Opportunity(Name = 'opTest',
        						 AccountId = a.Id,
        						 StageName = 'Personal Information',
        						 RecordTypeId = homeLoan,
        						 closeDate = Date.today().addDays(5)));
        opps.add(new Opportunity(Name = 'opTest2',
        						 AccountId = a.Id,
        						 StageName = 'Personal Information',
        						 RecordTypeId = homeLoan,
        						 closeDate = Date.today().addDays(5)));
        insert opps;
        
        EMI_Bounce__c e = new EMI_Bounce__c(Name='EmiTest', EMI_Bounced__c=True, Opportunity__c = opps[0].Id);
        insert e;
        
        List<Case> cases = new List<case>();
        //Case case1 = new Case(Status = 'Closed', Opportunity_Id__c = opps[0].Id);
        Case case2 = new Case(Status = 'Open', Opportunity_Id__c = opps[1].Id);
        //cases.add(case1);
        cases.add(case2);
        insert cases;
        return opps;
    }
    
    @isTest static void test_allMethods(){
        List<Opportunity> o = generateData();        
    	System.assert(OpportunityHelper.checkEMIBounce(o[0].Id)!=null);
        System.assert(OpportunityHelper.getRecordMetadata(o[0].Id)!=null);
        System.assert(OpportunityHelper.getVerificationRecordMetadata(o[0])==null);
        List<String> oppIds = new List<String>();
        for(Opportunity opp: o){
            oppIds.add(opp.Id);
        }
        OpportunityHelper.checkParentCases(oppIds);
        OpportunityHelper.processUnderwriting(o[1].id);
        OpportunityHelper.createLoanApplication(o[1].id);
        OpportunityHelper.creditScoreandincomeUpdate(o[1].id);
        OpportunityHelper.moveNextStage(o[1].id, 'Property Details');
        System.assertEquals(OpportunityHelper.getCurrentStage(o[1].id), 'Property Details');
    }

}