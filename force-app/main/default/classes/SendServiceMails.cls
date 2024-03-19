public class SendServiceMails {
    @AuraEnabled
    public static void sendEmail(string caseId)
    {
        List<Case> cases = [select Id, Contact.id from case where Id = :caseId LIMIT 1];
        
        Case selectedCase = cases[0];
        String conId = selectedCase.Contact.id;
        System.debug('conId >>> ' + conId);
            
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
        // mail.setTargetObjectId(UserInfo.getUserId()); 
        //Change with Template ID
        mail.setTemplateId('00XS0000001tUqo'); 
        
        //Record ID for which letter will be generated
        mail.setTargetObjectId(conId);
        // mail.setTargetObjectId(selectedCase.Id);
        mail.setWhatId(selectedCase.Id); 
        mail.setBccSender(false); 
        mail.setUseSignature(false); 
        mail.setSenderDisplayName('Ford Support Service'); 
        mail.setSaveAsActivity(true); 
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
    }
    
    @AuraEnabled
    public static void updateAddressNew(string caseId)
    {
        List<Case> cases = [select Contact.id,State__c,City__c,Country__c,Street_Address__c,PIN__c from case where Id = :caseId LIMIT 1];
        
        Case selectedCase = cases[0];
        String conId = selectedCase.Contact.id;
        
        Contact cont = [select Id,MailingCity,MailingCountry,MailingState,MailingStreet,MailingPostalCode from Contact where Id = :conId];
        
        cont.MailingCity = selectedCase.City__c;
        cont.MailingCountry = selectedCase.Country__c;
        cont.MailingPostalCode = selectedCase.PIN__c;
        cont.MailingStreet = selectedCase.Street_Address__c;
        cont.MailingState = selectedCase.State__c;
        
        update cont;
        
        // List<Case> cases = [select Contact.id,State__c,City__c,Country__c,Street_Address__c,PIN__c from case where Id = :caseId LIMIT 1];
        
    }
    
}