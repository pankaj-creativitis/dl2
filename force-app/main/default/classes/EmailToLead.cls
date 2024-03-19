global class EmailToLead implements Messaging.InboundEmailHandler { 	
     
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) { 
		
            Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();           
        
            Lead lead = new Lead();
            lead.LastName = 'Email Lead';
        lead.Email_Subject__c = email.subject;
        lead.Email_Body__c = email.plainTextBody;
            lead.Email = email.fromAddress;  
        lead.RecordTypeId='012S0000001dHJKIA2';
            lead.Company = 'Email Lead';          
            insert lead;
        
                // Save attachments, if any
            if(email.textAttachments != null){                
            for (Messaging.Inboundemail.TextAttachment tAttachment : email.textAttachments) {
            Attachment attachment = new Attachment();
            attachment.Name = tAttachment.fileName;
            attachment.Body = Blob.valueOf(tAttachment.body);
            attachment.ParentId = lead.Id;
            insert attachment;
            	}
     		}
            //Save any Binary Attachment
            if(email.binaryAttachments != null){
            for (Messaging.Inboundemail.BinaryAttachment bAttachment : email.binaryAttachments) {
            Attachment attachment = new Attachment(); 
            attachment.Name = bAttachment.fileName;
            attachment.Body = bAttachment.body;
            attachment.ParentId = lead.Id;
            insert attachment;
            }
       }
    		result.success = true;
       		return result;
    }
}