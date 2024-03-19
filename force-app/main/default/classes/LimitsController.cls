public class LimitsController {
    @AuraEnabled(cacheable=true)
    public static List<Limit__c> getLimits(String oppId) {
        // String key = '%' + searchKey + '%';
        return [
            SELECT Type__c, Name, Amount_Lacs__c, ROI_Commission__c, 
            Margin__c, Tenure_Months__c, Repayment__c, Purpose__c, Level__c, Parent_Application__c, Limit__c
            FROM Limit__c
            WHERE Parent_Application__c = :oppId
            ORDER BY Level__c
        ];
    }
}