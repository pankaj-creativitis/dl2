public class AddLimitRec {
    @AuraEnabled
    public static void saveLimitRecord(Limit_Assessments__c objLimit){
        try{
            insert objLimit;
        }
        catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }
}