public with sharing class CaseTriggerHandler {
    
    public static void callEinsteinSentimentService(List<case> caseList){
        /*
for(Case cs: caseList){
System.debug('Case >>>> ' + cs);
if(cs.RecordTypeId == '012S0000001fLMBIA2'){
cs.OwnerId='00GS000000A55Jm';
}
}
*/
        // commented working code on 24th Aug 2020 to avoid complications
        // EinsteinCalloutService.callEinsteinService(caseList);
    }
    
    /*
public static void updateStage(List<case> caseList){
for(Case cs: caseList){
if(cs.Subject == 'Field Investigation' || cs.Subject == 'Technical Verification' ){
if(cs.Status == 'Closed'){

}
}
}
}
*/
    public static void sendClosureMail(Case cs){
        Messaging.reserveSingleEmailCapacity(2);
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {'kelly_kite@persistent.com'}; 
                    // String[] ccAddresses = new String[] {'smith@gmail.com'};
                    mail.setToAddresses(toAddresses);
                // Specify the name used as the display name.
                mail.setSenderDisplayName('Salesforce Support');
                // Specify the subject line for your email address.
                mail.setSubject('New Case Created : ' + cs.Id);
                // Optionally append the Salesforce email signature to the email.
                // The email address of the user executing the Apex Code will be used.
                mail.setUseSignature(false);
                // Specify the text content of the email.
                mail.setPlainTextBody('Your Case with reference number-' + cs.CaseNumber + ' has been closed.');
                mail.setHtmlBody('Your Case with reference number-' + cs.CaseNumber + ' has been closed.' +
                                 'To view your case <a href=https://MyDomainName.my.salesforce.com/'+cs.Id+'>click here.</a>');
                
                // Send the email you have created.
                // Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    public static void setOwner(List<case> caseList){
        for(Case cs: caseList){
            System.debug('Case >>>> ' + cs);
            cs.EntitlementId = '550S0000000RK8bIAG';
            if(cs.Type == 'Overpayment'){
                Id usrId = UserInfo.getUserId();
                System.debug('usrId');
                User usr = [Select ContactId from User where Id = :usrId];
                cs.ContactId = usr.ContactId;
                cs.RecordTypeId='012S0000001fP7XIAU';
                cs.OwnerId='00GS000000A55Jm'; 
                // cs.Status = 'New';
            }
            else if(cs.RecordTypeId == '012S0000001fLMBIA2'){
                Id usrId = UserInfo.getUserId();
                System.debug('usrId');
                User usr = [Select ContactId from User where Id = :usrId];
                cs.ContactId = usr.ContactId;
                cs.OwnerId='00GS000000A55Jm'; 
            }
            
            else if(cs.Type == 'Update Address'){
                cs.RecordTypeId='012S0000001fPLj';
                cs.OwnerId='00GS000000A55Jm';
                String mailId = cs.SuppliedEmail;
                String contactId = '003S0000017SynpIAC';
                // Contact cnt = [Select Id from Contact where email = :mailId LIMIT 1];
                Contact cnt = [Select Id from Contact where Id = :contactId];
                cs.ContactId = cnt.Id;
                cs.Subject = 'Update Address';
                // cs.Status = 'New';
                Messaging.reserveSingleEmailCapacity(2);
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {'kelly_kite@persistent.com'}; 
                    // String[] ccAddresses = new String[] {'smith@gmail.com'};
                    mail.setToAddresses(toAddresses);
                // Specify the name used as the display name.
                mail.setSenderDisplayName('Salesforce Support');
                // Specify the subject line for your email address.
                mail.setSubject('New Case Created : ' + cs.Id);
                // Optionally append the Salesforce email signature to the email.
                // The email address of the user executing the Apex Code will be used.
                mail.setUseSignature(false);
                // Specify the text content of the email.
                mail.setPlainTextBody('Your Case: ' + cs.Id +' has been created.');
                mail.setHtmlBody('Your case:<b> ' + cs.Id +' </b>has been created.<p>'+
                                 'To view your case <a href=https://MyDomainName.my.salesforce.com/'+cs.Id+'>click here.</a>');
                
                // Send the email you have created.
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                
            } else if(cs.Type == 'General'){
                cs.RecordTypeId='012S0000001fLMB';
                cs.OwnerId='00GS000000A55Jm';
                String mailId = cs.SuppliedEmail;
                Contact cnt = [Select Id from Contact where email = :mailId LIMIT 1];
                cs.ContactId = cnt.Id;
                cs.Status = 'New';
            } else if(cs.RecordTypeId == '012S0000001fPbsIAE'){
                // 012S0000001fPbsIAE
                String mailId = cs.SuppliedEmail;
                Contact cnt = [Select Id from Contact where email = :mailId LIMIT 1];
                cs.ContactId = cnt.Id;
                
                
            }else if(cs.Origin == 'Twitter'){
                cs.RecordTypeId='012S000000252TlIAI';
                cs.OwnerId='00GS000000A55Jm';
            }
            
        }
        
    }    
}