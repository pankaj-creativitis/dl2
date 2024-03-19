public class SentimentCheckCtrl{
    @AuraEnabled
    public static ResponseReturnClass setAttribute(String doc) {
    	
    	Einstein_APIs__c eApi = [select Token__c, Model_Id__c
				                    from Einstein_APIs__c limit 1];
    	
        doc = '"' + doc + '"';
        // String body = '{"modelId":"UDB4MCAXRJMK77DPZTO5M6ZYDI", "document":'+doc+'}';
         String body = '{"modelId":"CommunitySentiment", "document":'+doc+'}';
       
        HttpRequest req = new HttpRequest();
        // req.setEndpoint('https://api.einstein.ai/v2/language/intent');
         req.setEndpoint('https://api.einstein.ai/v2/language/sentiment');
        req.setMethod('POST');
        // req.setHeader('Authorization', 'Bearer ' + eApi.Token__c);
        // req.setHeader('Authorization', 'Bearer ' + 'JZKEWNBUKFDDERZVK5KDMV2TJVIEITCGI5FEIRSZIRGUQMSOKVME4WSIKRMUMNBWJFKUEWCJJJHDIV2UGNLTMTKDINKUYRKZKVDE4U2RJRIDKUSBGVJFMSRVIVFEGS2CKBLFQWSZI5IEOVCQLJLESSCFKRBUWQKBKVHVC7COIE');
        req.setHeader('Authorization', 'Bearer ' + 'JRLEMQJSLFJVCRBSGVGVMVSMLBITMUBUINFUETKRKRFUYVKNIZIUUSKKGIZFCWKJGZCDIUCZIJJTGNJVGJBEIUCXK4ZUOS2RKJJEWTSYG5KFOV2YIFAVETKCIVGUYWSDJZGFEV2MKFBUWRSJKNBFUT2CINFEWR2RIJBUS7COIE');
        req.setHeader('Content-Type','application/json');
        // req.setHeader('Content-Type','multipart/form-data');
        req.setHeader('Cache-Control','no-cache');
        req.setBody(body);
        Http http = new Http();
        HTTPResponse res = http.send(req);
        system.debug('***' + res.getBody());
        
        EinsteinCalloutWrapper.EinsteinCalloutResponseWrapper eioo = (EinsteinCalloutWrapper.EinsteinCalloutResponseWrapper)
                    JSON.deserialize(res.getBody().replace('"object":', '"object_x":'), 
                        EinsteinCalloutWrapper.EinsteinCalloutResponseWrapper.class);
        
        String finalComputation = '';
        if(eioo != null && eioo.probabilities.size() > 0){
            finalComputation = eioo.probabilities[0].label;
        }
        
        ResponseReturnClass rrClass = new ResponseReturnClass();
        rrClass.finalComputation = finalComputation;
        rrClass.rawResponse = res.getBody();
      
        return rrClass;
    }
    
	
	public class ResponseReturnClass{
		@AuraEnabled
		public String finalComputation;
		@AuraEnabled
		public String rawResponse;
	}
}