public class RestUtility {
    
    
    public static void invokeStandardAPI(String request, String httpResp, String accessToken)
    {
        String access_Token = accessToken;
        String sfdcURL = URL.getSalesforceBaseUrl().toExternalForm();
       String restAPIURL = sfdcURL + '/services/data/v29.0/sobjects/Account';
 
    system.debug('AccessToken is'+access_Token);
     HttpRequest httpRequest = new HttpRequest(); 
    httpRequest.setMethod('GET');  
    httpRequest.setHeader('Authorization', 'OAuth ' + accessToken);       
    //httpRequest.setHeader('Authorization', 'Bearer ' + accessToken);
    //system.debug('session Id'+ UserInfo.getSessionId());
    httpRequest.setHeader('Content-Type', 'application/json;charset=UTF-8');
    httpRequest.setHeader('Content-Length', '0');
    httpRequest.setEndpoint(restAPIURL); 
    String response = '';
    Http http = new Http();  
    HttpResponse httpResponse = http.send(httpRequest); 
    system.debug('status code is '+httpResponse.getStatusCode() );
    if (httpResponse.getStatusCode() == 200 ) { 
    	response = JSON.serializePretty( JSON.deserializeUntyped(httpResponse.getBody()));
        List<APIResponseTracker__c> responseTrackerList = new List<APIResponseTracker__c>();
        APIResponseTracker__c responseTracker = new APIResponseTracker__c();
        responseTracker.ResponseDate__c = Date.today();
        responseTracker.Request__c =request;
        responseTracker.Response__c = httpResp;
        responseTrackerList.add(responseTracker);
        APIResponseTracker__c responseTracker1 = new APIResponseTracker__c();
        responseTracker1.ResponseDate__c = Date.today();
        responseTracker1.Request__c =restAPIURL;
        responseTracker1.Response__c = httpResponse.getBody();
        //responseTracker1.AccessToken__c = accessToken;
        responseTrackerList.add(responseTracker1);
        insert responseTrackerList;
                 //Response res = new Response();
                // res = (Response)JSON.deserialize(httpResponse.getBody(), Response.class);
                 //res =Json.deserializeUntyped(httpResponse.getBody());
         system.debug('succesfull Response is '+response);
       }
         system.debug(' Response is '+httpResponse.getBody());
    }
}