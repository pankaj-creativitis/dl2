public with sharing class CaseSelectorGPT {
    
    public static Case getCase(Id recordId){
        
        Case cs = [SELECT Id, CaseNumber, Knowledge__c, Subject, Description, Closure_Remarks__c, Closing_Comments__c, (SELECT Id, Subject, ActivityDate, Owner.Name, Who.Name, What.Name, Description FROM Tasks) 
        FROM Case WHERE Id =:recordId AND Status = 'Closed' Order by CreatedDate];
        
        return cs;
    }

   
    // public static List<Case> getCasesByIds(Set<Id> caseIds) {
        
    //     return [SELECT Id, CaseNumber, Subject, Description, Closure_Remarks__c, Closing_Comments__c, (SELECT Id, Subject, ActivityDate, Owner.Name, Who.Name, What.Name, Description FROM Tasks) 
    //     FROM Case WHERE Id IN :caseIds Order by CreatedDate];
    // }

    @AuraEnabled
    public static List<Case> getCasesByIdsAura(List<Id> caseIds) {
        
        Set<Id> Ids = new Set<Id>();
            for(Id c : caseIds){
                Ids.add(c);
            }
        
        return [SELECT Id, CaseNumber, Subject, Knowledge__c, Description, Closure_Remarks__c, Closing_Comments__c, (SELECT Id, Subject, ActivityDate, Owner.Name, Who.Name, What.Name, Description FROM Tasks) 
        FROM Case WHERE Id IN :Ids AND Status = 'Closed' Order by CreatedDate];
    }


    
    public static List<Case> getCasesByArticleId(Id articleId) {        
        return [SELECT Id, CaseNumber, Knowledge__c, Subject, Description, Closure_Remarks__c, Closing_Comments__c, (SELECT Id, Subject, ActivityDate, Owner.Name, Who.Name, What.Name, Description FROM Tasks) 
        FROM Case WHERE Knowledge__c = :articleId AND Status = 'Closed' Order by CreatedDate];
    }
}