trigger extractDataFromDocument on ContentDocumentLink (after insert) {
     
    if(trigger.isAfter) {
        if(trigger.isInsert) {
            for (ContentDocumentLink cdl : Trigger.new) {
                system.debug('cdl details >> ' + cdl.LinkedEntityId + ' <> ' + cdl.Id );
                system.debug(String.valueOf(cdl.LinkedEntityId.getSobjectType()));
                if(String.valueOf(cdl.LinkedEntityId.getSobjectType()).equals('Lead')){
                    ContentDocument cd = [Select Id ,Title from ContentDocument Where ID = :cdl.ContentDocumentId]; 
                    ContentDocumentHelper.getDocumentData(cd.Id, cdl.LinkedEntityId);
                }
                
               // Quick fix below - need to fix
              
                // ContentVersion vd = [SELECT VersionData FROM ContentVersion WHERE ContentDocumentId = :cd.Id AND IsLatest = true];
                // system.debug('cd details >> ' + cd.Id );
                // String base64Str = EncodingUtil.base64Encode(vd.VersionData);
            // system.debug('base64Str >> ' + base64Str);
                
            }
        }
    }
    /*
        if(obj=='Lead'){
            String base64Str = EncodingUtil.base64Encode(att.Body);
            system.debug('base64Str >> ' + base64Str);
        }
*/
    
}