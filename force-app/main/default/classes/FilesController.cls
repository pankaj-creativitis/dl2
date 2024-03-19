public class FilesController {
    @AuraEnabled
    (cacheable=true)
    public static List<ContentDocumentLink> getFileIds(string objId)
    {
        return [Select id, ContentDocumentId from ContentDocumentLink where LinkedEntityId = :objId];
        // return [Select id, ContentDocumentId, ContentDocument.LatestPublishedVersionId from ContentDocumentLink where LinkedEntityId = :objId];
        // system.debug('ids >> ' + cIds);
    }
}