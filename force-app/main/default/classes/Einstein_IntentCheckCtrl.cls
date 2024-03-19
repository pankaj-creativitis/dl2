public with sharing class Einstein_IntentCheckCtrl {
    @AuraEnabled
    public static ResponseReturnClass setAttribute(String doc) {
        Einstein_APIs__c eApi = [select Token__c, Model_Id__c
				                    from Einstein_APIs__c limit 1];
        
        doc = doc.replace('\r\n', ' ');
		doc = doc.replace('\n', ' ');
		doc = doc.replace('\r', ' ');
		
        doc = '"' + doc + '"';
        String body = '{"modelId":"'+eApi.Model_Id__c+'", "document":'+doc+'}';
        //String body = '{"modelId":"EEPRMTFDC5RVZTVVNWBPMSCZPQ", "document":'+doc+'}';
        system.debug('***body' + body);
       
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.einstein.ai/v2/language/intent');
        req.setMethod('POST');
        req.setHeader('Authorization', 'Bearer '+ eApi.Token__c);
        req.setHeader('Content-Type','application/json');
        req.setHeader('Cache-Control','no-cache');
        req.setBody(body);
        Http http = new Http();
        HTTPResponse res = http.send(req);
        
        system.debug('***' + res.getBody());
        
        EinsteinCalloutWrapper.EinsteinCalloutResponseWrapper eioo = (EinsteinCalloutWrapper.EinsteinCalloutResponseWrapper)
                    JSON.deserialize(res.getBody().replace('"object":', '"object_x":'), 
                        EinsteinCalloutWrapper.EinsteinCalloutResponseWrapper.class);
        
        String finalComputation = '';
        if(eioo != null && eioo.probabilities != null && eioo.probabilities.size() > 0){
            finalComputation = eioo.probabilities[0].label;
        }
        
        if(finalComputation == 'SOA'){
        	sendSOAPDF();	
        }
        
        ResponseReturnClass rrClass = new ResponseReturnClass();
        rrClass.finalComputation = finalComputation;
        rrClass.rawResponse = res.getBody();
      
        return rrClass;
    }
    
    public static void sendSOAPDF(){
    	List<Messaging.SingleEmailMessage> lstMsgs = new List<Messaging.SingleEmailMessage>();
    	
    	PageReference PDf =  Page.SendSOAPDF;
    	pdf.setRedirect(true);
    	
    	Blob b = PDf.getContent();
    	
		Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
		efa.setFileName('SOA_AccountNo.pdf');
		efa.setBody(b);
    	
    	Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new List<String>{'neel_pupreddiwar@persistent.com'});
        //email.setCcAddresses(new List<String>{});
        email.setSubject('Statement of Account');
		email.setHtmlBody('Hi, Please find the statement of Account Attached');
        email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
        
        lstMsgs.add(email);

        Messaging.sendEmail(lstMsgs);
    }
    
	public class ResponseReturnClass{
		@AuraEnabled
		public String finalComputation;
		@AuraEnabled
		public String rawResponse;
	}
}