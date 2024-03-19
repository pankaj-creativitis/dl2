trigger DocumentUploadTrigger on Document_Validation__c (before insert, before update) {
   
    		List<Id> docId = new List<Id>();
            for(Document_Validation__c newDoc : trigger.new) {
                docId.add(newDoc.Id);
            }

  
            List<Document_Validation__c> DocReview = [SELECT id, Name, Parent_Record_ID__c,Attachment__c,Status__c FROM Document_Validation__c 
                                                  		WHERE Parent_Record_ID__c = :docId];
            System.debug('DocReview=====>> ' + DocReview);
            for(Document_Validation__c d: DocReview){
               
            }                
          
  
}