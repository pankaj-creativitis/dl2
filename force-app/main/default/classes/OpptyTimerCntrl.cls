public class OpptyTimerCntrl {
    
    @AuraEnabled
    public static Date fetchOpptyCreatedDate(String recId){
        Opportunity opp = [select createddate from Opportunity where id =: recId];   
        return Date.valueof(opp.createddate);
    }
}