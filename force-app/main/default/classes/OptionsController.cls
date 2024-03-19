public without sharing class OptionsController {
     @AuraEnabled
    (cacheable=true)
    public static List<optionData> getOptions(string headerFld, string descFld, string objectApi, string filter, string filterName, boolean hasImage)
    {
       String query = 'SELECT Id, ' + headerFld + ', ' + descFld + ' FROM ' + objectApi + ' WHERE ' + filterName + '=\'' + filter + '\' order by Id asc';
        system.debug('query >>> ' + query);
        List<sObject> opts = Database.query(query);
        system.debug('opts >>> ' + opts);
        
        List<optionData> optsData = new List<optionData>();
            
        if(hasImage){
            
        
        for(sObject so : opts){
            
            List<id> cdls=new List<id>();
            for(ContentDocumentLink a : [select ContentDocumentId from ContentDocumentLink where LinkedEntityId = :so.Id]){
                cdls.add(a.ContentDocumentId);
            }
            
            // List<ContentDocumentLink> cdls = [SELECT Id, LinkedEntityId, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :so.Id];
            if(cdls.size()>0){
                // List<contentVersion> cvs = [select id, title from contentVersion where ContentDocumentId = :cdls[0].ContentDocumentId AND title LIKE 'display@%'];
                List<contentVersion> cvs = [select id, title from contentVersion where ContentDocumentId IN :cdls AND title LIKE 'display@%'];
                system.debug('cvs >>> ' + cvs);
                // system.debug('cvs >>> ' + cvs[0].title);
                optionData optData = new optionData();
                optData.optionId = so.Id;
                system.debug('headerFld value>> ' + headerFld);
                optData.headerMsg = (String) so.get(headerFld);
                optData.descriptionMsg = (String) so.get(descFld);
                if(cvs.size() > 0){
                    optData.imgId = '/sfc/servlet.shepherd/version/download/' + (String) cvs[0].Id;
                }
                
                optsData.add(optData);
                system.debug('optData >>> ' + optData);
                
            }
        }
        } else {
            for(sObject so : opts){
            optionData optData = new optionData();
                optData.optionId = so.Id;
                system.debug('headerFld value>> ' + headerFld);
                optData.headerMsg = (String) so.get(headerFld);
                optData.descriptionMsg = (String) so.get(descFld);
            optsData.add(optData);
            }
        }
        return optsData;
        // return [Select id, ContentDocumentId, ContentDocument.LatestPublishedVersionId from ContentDocumentLink where LinkedEntityId = :objId];
        // system.debug('ids >> ' + cIds);
    }
    
    @AuraEnabled
    (cacheable=true)
    public static List<optionData> getOptionsFromMeta(string filter, boolean hasImage){
        Options_Metadata__mdt[] optMappings = [SELECT MasterLabel, Description__c, Image_Name__c, Type__c FROM Options_Metadata__mdt WHERE Type__c = :filter];
        System.debug('optMappings >>> ' + optMappings);
        
        List<optionData> optsData = new List<optionData>();
        
        for(Options_Metadata__mdt optMapping :optMappings){
            optionData optData = new optionData();
            
            // optData.optionId = optMapping.Id;
            optData.optionId = 'metadata';
            optData.headerMsg = optMapping.MasterLabel;
            optData.descriptionMsg = optMapping.Description__c;
            optData.imgId = optMapping.Image_Name__c;
            optsData.add(optData);
        }
        System.debug('optsData >>> ' + optsData);
        return optsData;
    }
    
    // wrapper or Inner class with @AuraEnabled {get;set;} properties*    
    public class optionData{
        @AuraEnabled public String optionId {get;set;}
        @AuraEnabled public String headerMsg {get;set;}
        @AuraEnabled public String descriptionMsg{get;set;}
        @AuraEnabled public String imgId{get;set;}
        
    }
}