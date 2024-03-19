public class SendConsent {
// 00XS0000002DsyM
    @InvocableMethod(label='Send consent mails' description='Send consent mails.' )
    public static void sendEmail()
    {
        String Leadid = '00QS000000C2N0jMAF';
       // List<Lead> cases = [select Lead.id from Lead where Id = :Leadid LIMIT 1];
        
       // Lead selectedCase = cases[0];
        // String conId = selectedCase.Contact.id;
        // System.debug('conId >>> ' + conId);
            List<String> mailIds = new List<String>();
        mailIds.add('pankaj_pandit@persistent.com');
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
        mail.setTargetObjectId(UserInfo.getUserId()); 
        //Change with Template ID
        mail.setTemplateId('00XS0000002DsyM'); 
        
        //Record ID for which letter will be generated
       // mail.setTargetObjectId(conId);
        // mail.setWhatId(conId); 
        mail.setBccSender(false); 
        mail.setUseSignature(false); 
        mail.setSenderDisplayName('Kotak Consent Mail'); 
        mail.setSaveAsActivity(false); 
        mail.setToAddresses(mailIds);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}