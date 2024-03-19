trigger ContentDocumentLinkTrigger on ContentDocumentLink (before insert, after insert) {
    
    if(trigger.isAfter  && trigger.isInsert) {
            boolean idTypeImage = false;
            boolean selfieTypeImage = false;  
            ContentVersion cv ;
            for (ContentDocumentLink cdl : Trigger.new) {
               List<ContentDocumentLink> existingDocuments = [Select LinkedEntityId, ContentDocumentId from ContentDocumentLink where LinkedEntityId = : cdl.LinkedEntityId ];
               if(existingDocuments.size()>0)
               {
                    for(ContentDocumentLink cntDoc : existingDocuments )
                   {
                       if (String.valueOf(cntDoc.LinkedEntityId.getSobjectType()).equals('Account'))
                       {
                          cv = [Select Id ,Title,VersionData from ContentVersion Where ContentDocumentId = :cntDoc.ContentDocumentId];
                           System.debug('cv is ...'+cv+'***Cv t'+cv.title);
                          if (cv != null && (cv.title.equalsIgnoreCase('Selfie') ||cv.title.equalsIgnoreCase('ID')))
                          {
                            if(cv.title.equalsIgnoreCase('Selfie'))
                            {
                                
                                selfieTypeImage = true;
                            }else{
                                idTypeImage = true;
                            }
                            system.debug('selfieTypeImage'+selfieTypeImage);                      
                            system.debug('idTypeImage'+idTypeImage);
                            break;
                          }
                       }
                   }
               }
                if (idTypeImage || selfieTypeImage || existingDocuments.size()==0)
                {
                    system.debug('hello2'); 
                    /*system.debug('cdl details >> ' + cdl.LinkedEntityId + ' <> ' + cdl.Id );
                    system.debug(String.valueOf(cdl.LinkedEntityId.getSobjectType()));
                    system.debug('cdl.LinkedEntityId.getSobjectType()'+cdl.LinkedEntityId.getSobjectType());*/
                    
                    if(String.valueOf(cdl.LinkedEntityId.getSobjectType()).equals('Account')){
                        ContentDocument cd = [Select Id ,Title from ContentDocument Where ID = :cdl.ContentDocumentId];
                        System.debug('cdl.id is '+cdl.ContentDocumentId);
                        if ((cd.title.equalsIgnoreCase('Selfie') && idTypeImage)|| (cd.title.equalsIgnoreCase('ID') && selfieTypeImage))
                        {
                         ContentVersion contentVersionData = [SELECT VersionData,ContentDocumentId FROM ContentVersion where 
                         contentDocumentId = : cdl.ContentDocumentId ];
                        system.debug('JSON DATA Passed***************'+contentVersionData);
                        Account account;
                        if (cd.title.equalsIgnoreCase('Selfie'))
                        {
                        
                            account = [Select Id, IsImageVerified__c from Account where 
                                               Id = : cdl.LinkedEntityId];
                            account.IsImageVerified__c = true;
                            
                            
                           ContentTriggerHandler.invokeEndpoint(cv, contentVersionData);

                        }else{
                            account = [Select Id, IsImageVerified__c from Account where 
                                               Id = : cdl.LinkedEntityId];
                            account.IsImageVerified__c = true;
                            ContentTriggerHandler.invokeEndpoint(contentVersionData,cv);
                        }
                            update account;
                        }
                       
                    }
                      
                }
            }
       } 
                               
   

}