@isTest public class OppUnderwritingCondControllerTest {
    @isTest static void getUnderwritingConditions_Test(){
        Account a = new Account(Name='Test a', Debt__c= 20000, FinServ__CreditScore__c=750);
        insert a;
        Opportunity o = new Opportunity(AccountId=a.Id,Name='Test o',StageName='Underwriting',closedate=Date.today()+100, Mandatory_Documents_Uploaded__c=true);
        insert o;
        OppUnderwritingCondController.ReferToCredit rtc = OppUnderwritingCondController.getUnderwritingConditions(o.Id);
        System.AssertEquals(rtc.creditScore, a.FinServ__CreditScore__c, 'Expected same credit score');
        
        
    }
}