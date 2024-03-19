trigger AttachmenttTrigger on Attachment (before insert, after insert) {
   // OCR ocr = new OCR();
        List<Id> accountList = new List<Id>();
    Set<Id> accIds = new Set<Id>();
    for(Attachment att : trigger.New){
         //Check if added attachment is related to Account or not
         if(att.ParentId.getSobjectType() == Asset.SobjectType){
              accIds.add(att.ParentId);
             OCR.getDocumentData(att.Id,att.ParentId);
         }
    }
    /*
    accountList = [select id, has_Attachment__c from Account where id in : accIds];
    if(accountList!=null && accountList.size()>0){
        for(Account acc : accountList){
            acc.has_Attachment__c = true;
        }
        update accountList;
    }
*/
/*
        List <Id> attachmentIds = new List<Id>();

    for(Attachment  attach: Trigger.old){
            attachmentIds.add(attach.ParentID);
        }
    
        Map<ID, Contact> contactMap = new Map<ID, Contact>([SELECT Id,Name FROM Contact WHERE Id IN: attachmentIds]);
    
    Set<Id> contactIds = contactMap.keySet();
    Map<ID, Attachment> attachmentMap = new Map<ID, Attachment>([select id,Name from attachment where parentId In : contactIds]);
   
    Map<Id, String> contactBase64EncodeData = new Map<Id, String>();
    for (Id id : attachmentMap.keySet() )
    {
        Attachment attachment= attachmentMap.get(Id);
        String bodyContent = attachment.body.toString();
        String data = EncodingUtil.base64Decode(bodyContent).toString();   
        contactBase64EncodeData.put(attachment.ParentId, data);
       // Http http = new Http();
       //HttpRequest request = new HttpRequest();
      // request.setEndpoint('https://stg-tenant1.persistentdigitalbank.tk/authservice/identitymindkyc');
       //request.setMethod('POST');
      //request.setHeader('Content-Type', 'application/json;charset=UTF-8');
      //request.setBody('{"name":"mighty moose"}');
      //'grant_type=password&client_id=' + ClientId + '&client_secret=' + ClientSecret + '&username=' + username +'&password=' + password
    }
    
    List <Contact> contactUpdated= new List<Contact>();
    for ( Id contactId : contactBase64EncodeData.keySet())
    {
      Contact con =[SELECT Id, Name FROM Contact WHERE Id =: contactId];
        //con.encodedString__c=contactBase64EncodeData.get(contactId);
        contactUpdated.add(con);
    }

    update contactUpdated;
*/
}