public class RestClientHandler{
    
    public static void invokeRestAPI(){
        String sfdcURL = URL.getSalesforceBaseUrl().toExternalForm();
        //String restAPIURL = sfdcURL + '/services/data/v29.0/sobjects/Account'; 
        String restAPIURL = sfdcURL + '/services/oauth2/token?grant_type=password&client_id=3MVG98dostKihXN6gpEYChyPXd_I4hqKWgBUBYeatbDOArQ7chm57sj01uK2sTN6abg6SENGzCP3QV3S6OPFm&client_secret=7B8308A98C49294750F0B1F9CDD8566EC5B402950BCC4534E2EB124510538B1B&username=sfdemos@lexpsl.com.dev2&password=Castles1!@uebgWrvi3rVMbaeyYAQNQIPQi';
        
        system.debug('RestApi Url is '+restAPIURL);
        HttpRequest httpRequest = new HttpRequest(); 
        httpRequest.setMethod('POST');  
        httpRequest.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());       
        httpRequest.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
        //system.debug('session Id'+ UserInfo.getSessionId());
        httpRequest.setHeader('Content-Type', 'application/json;charset=UTF-8');
        httpRequest.setHeader('Content-Length', '0');
        httpRequest.setEndpoint(restAPIURL); 
        String response = '';
        
        try { 
            
            Http http = new Http();  
            HttpResponse httpResponse = http.send(httpRequest); 
            if (httpResponse.getStatusCode() == 200 ) { 
                response = JSON.serializePretty( JSON.deserializeUntyped(httpResponse.getBody()) );
                Response res = new Response();
                res = (Response)JSON.deserialize(httpResponse.getBody(), Response.class);
                //res =Json.deserializeUntyped(httpResponse.getBody());
                //system.debug('Access Token is '+res.getAccessToken());
                /*APIResponseTracker__c responseTracker = new APIResponseTracker__c();
                responseTracker.ResponseDate__c = Date.today();
                responseTracker.Request__c =restAPIURL;
                responseTracker.Response__c = httpResponse.getBody();
                insert responseTracker;*/
                RestUtility.invokeStandardAPI(restAPIURL, httpResponse.getBody(), res.getAccessToken());
                
                
            } else { 
                System.debug(' Response for not successfull response ' + httpResponse.getBody() );
                
            }  
            
        } catch( System.Exception e) { 
            System.debug('ERROR: '+ e); 
            throw e; 
        } 
        // System.debug(' ** response ** : ' + response ); 
    }
    
    public class Response
    {
        String signature;
        String issued_at;
        String token_type;
        String id;
        String instance_url;
        String access_token;
        
        public String getAccessToken()
        {
            return this.access_token;
        }
        
    }
    
    
    
}