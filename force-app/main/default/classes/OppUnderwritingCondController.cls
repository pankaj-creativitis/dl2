public class OppUnderwritingCondController {
    public class ReferToCredit{
        @AuraEnabled public Decimal creditScore{get;set;}
        @AuraEnabled public Decimal dtiRatio{get;set;}
        
    }
    @AuraEnabled public static ReferToCredit getUnderwritingConditions(String recId){
        Opportunity opp = [SELECT AccountId, Account.FinServ__CreditScore__c, Account.DTI_Ratio__c FROM Opportunity WHERE id = :recId];
		ReferToCredit rtc = new ReferToCredit();
        rtc.creditScore = opp.Account.FinServ__CreditScore__c;
        rtc.dtiRatio = opp.Account.DTI_Ratio__c;
        System.debug(rtc);
        return rtc;
    }
}