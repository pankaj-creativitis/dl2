/*something*/
public class EinsteinCalloutService {
    
    //Implement business and callout logic methods here
    public static void callEinsteinService(List<Case> caseList) {
        
        if(caseList != null && caseList.size() > 0) {
            for(Case caseRec: caseList){
        		callEinsteinSentiment(caseRec.id);
        		//callEinsteinIntent(caseRec.id);
            }
        }
    }
    
    @Future(callout=true)
    public static void callEinsteinIntent(String caseId){
    	try{
			Case caseRec = [Select id, description from Case where id=: caseId];
			
			Einstein_IntentCheckCtrl.ResponseReturnClass rClassInstance = Einstein_IntentCheckCtrl.setAttribute(caseRec.description);
			
			caseRec.Einstein_Intent_Response__c = rClassInstance.rawResponse;
			update caseRec;
			
    	}
    	catch(Exception ex){
    		system.debug('***' + ex.getStackTraceString());	
    	}	
    }
    
    @Future(callout=true)
    public static void callEinsteinSentiment(String caseId) {
    	try{
    		Einstein_APIs__c eApi = [select Token__c from Einstein_APIs__c limit 1];
    		
    		Case caseRec = [Select id, description, SuppliedEmail, Origin, Subject from Case where id=: caseId];
	        String twitterHandle = '';
	        EinsteinCalloutWrapper eio;
	        if(caseRec.Origin == 'Twitter' && caseRec.Subject != null){
	        	twitterHandle = 'https://twitter.com/' + caseRec.Subject.substringBetween('TWEET FROM: ',' @UDBankSupport');
	        	eio = new EinsteinCalloutWrapper('UDB4MCAXRJMK77DPZTO5M6ZYDI', caseRec.Subject.substringAfter('@UDBankSupport '));
	        }
	        else if(caseRec.Origin == 'Email' && caseRec.description != null){
                // CommunitySentiment
		       // eio = new EinsteinCalloutWrapper('UDB4MCAXRJMK77DPZTO5M6ZYDI', caseRec.description);
                 eio = new EinsteinCalloutWrapper('CommunitySentiment', caseRec.description);
	        }
	        
	        if(eio != null){
		        String body = JSON.serialize(eio);
		        HttpRequest req = new HttpRequest();
		        // req.setEndpoint('https://api.einstein.ai/v2/language/intent');
                req.setEndpoint('https://api.einstein.ai/v2/language/sentiment');
		        req.setMethod('POST');
		        // req.setHeader('Authorization', 'Bearer '+eApi.Token__c);
                // req.setHeader('Authorization', 'Bearer '+'INEEWTJVKU2UOSBTKE3FISCCJFFUCWCCKNFDMUKKINNEGU2UGJIFUQ2UIM2EWV2CINIEONKGKRFDGVKVJ5AVUNCIKVIVSVKGKFEEIRCIIMZUUUZVG5KFMSSVKRMUMRJVGRKVINZVLFGDMQ2XG5JDOSSTJBCFQRSIIU3VC7COIE');
		        
		        req.setHeader('Authorization', 'Bearer '+'JRLEMQJSLFJVCRBSGVGVMVSMLBITMUBUINFUETKRKRFUYVKNIZIUUSKKGIZFCWKJGZCDIUCZIJJTGNJVGJBEIUCXK4ZUOS2RKJJEWTSYG5KFOV2YIFAVETKCIVGUYWSDJZGFEV2MKFBUWRSJKNBFUT2CINFEWR2RIJBUS7COIE');
                req.setHeader('Content-Type','application/json');
		        req.setHeader('Cache-Control','no-cache');
		        req.setBody(body);
		        Http http = new Http();
		        HTTPResponse res = http.send(req);
		        
		        if (res.getStatusCode() != 200) {
		            System.debug('The status code returned was not expected: ' +
		                         res.getStatusCode() + ' ' + res.getStatus());
		        } else {
		            System.debug(JSON.deserialize(res.getBody().replace('"object":', '"object_x":'), EinsteinCalloutWrapper.EinsteinCalloutResponseWrapper.class));
		            EinsteinCalloutWrapper.EinsteinCalloutResponseWrapper eioo = (EinsteinCalloutWrapper.EinsteinCalloutResponseWrapper)JSON.deserialize(res.getBody().replace('"object":', '"object_x":'), EinsteinCalloutWrapper.EinsteinCalloutResponseWrapper.class);
		            Decimal probablityHighest = 0; 
		            String labelForHighestProbablity = null;
		            
		            if(eioo.probabilities.size() > 0){
		                for(Integer i=0; i < eioo.probabilities.size();i++){
		                    if(eioo.probabilities[i].probability > probablityHighest){
		                        probablityHighest = eioo.probabilities[i].probability;
		                        labelForHighestProbablity = eioo.probabilities[i].label;
		                    }
		                }
		            }
		            System.debug('Highest Probablity '+ probablityHighest);
		            System.debug('Highest Probablity Label ' + labelForHighestProbablity);
		            EinsteinCalloutService.generateThumbsUpDown(caseRec, labelForHighestProbablity);
		            EinsteinCalloutService.createTask(caseRec,labelForHighestProbablity, twitterHandle);
		        } 
	        }
	        
    	}
    	catch(Exception ex){
    		system.debug('***' + ex.getMessage());
    	}
    	               
    }
    
    public static void generateThumbsUpDown(Case caseRec, String sentiment){
    	if(sentiment == 'positive'){
    		caseRec.Good_Bad_Sentiment__c = 'Good';
            update caseRec;	
    	}
    	else if(sentiment == 'negative'){
    		caseRec.Good_Bad_Sentiment__c = 'Bad';
            update caseRec;
    	}	
        /*
if(sentiment == 'Good'){
    		caseRec.Good_Bad_Sentiment__c = 'Good';
            update caseRec;	
    	}
    	else if(sentiment == 'Bad'){
    		caseRec.Good_Bad_Sentiment__c = 'Bad';
            update caseRec;
    	}	
*/
    }
    
    public static void createTask(Case caseRec, String label, String twitterHandle){
        if(caseRec != null){
        	List<Contact> conList = new List<Contact>();
        	if(String.isNotBlank(twitterHandle)){
		        conList = [Select id, Email, Account.OwnerId from Contact where FinServ__Twitter__c =: twitterHandle];
        	}else{
        		conList = [Select id, Account.OwnerId from Contact where Email =: caseRec.SuppliedEmail];
        	}
	        if(conList.size() > 0){
                User userRec = [select id, Negative_Feedback__c, Positive_Feedback__c, Email from User where id =: conList[0].Account.OwnerId];
        	 	if(label.equalsIgnoreCase('negative')){
	        	 	Task taskRec = new task();
	                taskRec.OwnerId = conList[0].Account.OwnerId;
	                taskRec.Subject = 'Connect with Customer';
	                taskRec.Status = 'Open';
	                taskRec.Priority = 'High';
	                taskRec.WhatId = conList[0].Account.Id;
	                insert taskRec;
	                
	                if(userRec.Negative_Feedback__c == null){
	                    userRec.Negative_Feedback__c = 0;
	                }
	                userRec.Negative_Feedback__c++;
	                update userRec;
	                
	                sendEMailToCustomer(conList[0], caseRec, userRec, 'Bad');
        	 	}
        	 	else if(label.equalsIgnoreCase('positive')){
        	 		if(userRec.Positive_Feedback__c == null){
	                    userRec.Positive_Feedback__c = 0;
	                }
        	 		userRec.Positive_Feedback__c++;
	                update userRec;
	                
	                sendEMailToCustomer(conList[0], caseRec, userRec, 'Good');
        	 	}
	        }        	
        }
    }
    
    public static void sendEMailToCustomer(Contact conRec, Case caseRec, User userRec, String sentiment){
    	
    	EmailTemplate templateId;
    	if(sentiment == 'Bad'){
    		templateId = [Select id from EmailTemplate where DeveloperName = 'Sentiment_Bad'];
    	}
    	else if(sentiment == 'Good'){
    		templateId = [Select id from EmailTemplate where DeveloperName = 'Sentiment_Good'];
    	}
    	
    	List<Messaging.SingleEmailMessage> lstMsgs = new List<Messaging.SingleEmailMessage>();
    	
    	Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
    	email.setTemplateId(templateId.id);
        email.setTargetObjectId(conRec.id);
        if(String.isBlank(caseRec.SuppliedEmail)){
        	email.setToAddresses(new List<String>{conRec.Email});
        }else{
	        email.setToAddresses(new List<String>{caseRec.SuppliedEmail});
        }
        email.setCcAddresses(new List<String>{userRec.Email});
        email.setWhatId(caseRec.id);
        lstMsgs.add(email);
        Messaging.sendEmail(lstMsgs);
        
    }
    
}