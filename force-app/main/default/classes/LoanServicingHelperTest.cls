@isTest
private class LoanServicingHelperTest {
    @isTest static void test(){
        List<opportunity> opps = new List<opportunity>();
        opps.add(new Opportunity(Name = 'opTest',
                                              EMI_Start_Date__c = Date.today(),
                                              Approved_Loan_Amount__c = 50000,
                                              Approved_ROI__c = 1,
        						              StageName = 'Personal Information',
        						              RecordTypeId = schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId(),
        						              closeDate = Date.today().addDays(5)));
        opps.add(new Opportunity(Name = 'opTest2',
                                              EMI_Start_Date__c = Date.today().addDays(-10000),
                                              Approved_Loan_Amount__c = 50000,
                                              Approved_ROI__c = 1,
        						              StageName = 'Personal Information',
        						              RecordTypeId = schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId(),
        						              closeDate = Date.today().addDays(5)));
        
        insert opps;
        for(Opportunity o: opps){
            LoanServicingHelper.getSchemeRepayment(o.Id);
        }
        
        
    }
}