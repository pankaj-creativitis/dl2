trigger ContentVersionTrigger on ContentVersion (after insert) {

        /*List <ContentVersion> contentVersions = new List<ContentVersion>();
        Set<Id> contentDocumentIds = new Set<Id>();
        Set<Id> contactContentDocumentIds = new Set<Id>();
    
        List<ContentDocumentLink> contDocLinks = new List<ContentDocumentLink>();
    
    for(ContentVersion  contVersion: Trigger.new){
            
         contentVersions.add(contVersion);
        }
    
    for(ContentVersion cv :contentVersions)
    {
        contentDocumentIds.add(cv.contentDocumentId);
    }
    
    List<ContentDocumentLink> contentDocLinks = [SELECT Id,LinkedEntityId,contentDocumentId FROM ContentDocumentLink
                                    where contentDocumentId in :contentDocumentIds and 
                                              LinkedEntityId in (Select Id from COntact) ];
    for(ContentDocumentLink conDocLink : contentDocLinks)
    {
        contactContentDocumentIds.add(conDocLink.contentDocumentId);
    }
    
    List<ContentVersion> contentVersionData = [SELECT VersionData,ContentDocumentId FROM ContentVersion where 
                               contentDocumentId in : contactContentDocumentIds];
    system.debug('VersionData***************'+contentVersionData);
    ContentTriggerHandler.invokeEndpoint(contentVersionData);*/
    
}