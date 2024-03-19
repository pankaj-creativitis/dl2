@IsTest
global class EmailToLeadTest{   
    
    static testMethod void testCreateLeadFrmEmail() {       
        EmailToLead createlead = new EmailToLead(); 
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env  = new Messaging.InboundEnvelope();
        email.subject = 'Create Lead';
        email.plainTextBody = 'Hello, this a test email body for testing purposes only';
        
        Messaging.InboundEmail.BinaryAttachment binaryAttachment = new Messaging.InboundEmail.BinaryAttachment();        
        binaryAttachment.Filename = 'test.pdf';
        binaryAttachment.body = blob.valueOf('my attachment text');
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { binaryattachment };
            
        Messaging.InboundEmail.TextAttachment textAttachment = new Messaging.InboundEmail.TextAttachment();  
        textAttachment.Filename = 'test.txt';
        textAttachment.body = 'my attachment text';
        email.textAttachments = new Messaging.InboundEmail.textAttachment[] { textAttachment };
        
        env.fromAddress = 'pranjali_watkar@persistent.com';
        createlead.handleInboundEmail(email, env); 
    }
}   
  

     /*  
      //Code to test Binary Attachment
 
         Lead lead = new Lead();
         lead.LastName = 'Email Lead';
       	 lead.Email = email.fromAddress;  
         lead.Company = email.subject;          
         insert lead;
        
         Lead testlead = [select id, LastName from Lead where id = :lead.id]; */
 
    //   email.subject = testlead.LastName;
    //   email.subject = 'Create Lead';
     //  email.plainTextBody = 'Blank';
     //  env.fromAddress = 'johnsmith@gmail.com';      
     
    /*   Messaging.InboundEmail.BinaryAttachment binaryAttachment = new Messaging.InboundEmail.BinaryAttachment();

        binaryAttachment.Filename = 'test.pdf';
        binaryAttachment.body = blob.valueOf('my attachment text');
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { binaryattachment };
            
        createlead.handleInboundEmail(email, env );        
        Messaging.InboundEmailResult result = createlead.handleInboundEmail(email, env);
        System.assertEquals(result.success,true);       
        update testlead;
        
        Lead testld = [select id, LastName from Lead where id = :testlead.id];
        List<Attachment> att = [Select id, name from Attachment where parentid = :testld.id and name = :'test.pdf'];
        System.assertEquals(att[0].name, 'test.pdf');
      */