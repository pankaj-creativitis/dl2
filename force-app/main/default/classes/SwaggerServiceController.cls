public class SwaggerServiceController {

    @auraEnabled
        public static Map<String,object> makePostRequest(String query, String docs) {
            String answer = '';
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://hrbot.demopersistent.com/query');
            request.setMethod('POST');
            request.setHeader('accept', 'application/json');
            request.setHeader('Content-Type', 'application/json');
            
            //prepare the request body
             Map<String, Object> requestBody = new Map<String, Object>{
            'query' => query,
            'docs' => new List<String>{'(3) percent of the unpaid amount of the payment then due, provided that the late charge will not exceed $50. Prepayment: You may prepay all or any portion of the Loan at any time without penalty. Terms: You should read the remainder of this Agreement for additional information about security interests, nonpayment, defaults, prepayment refunds and our right to require repayment in full before the scheduled maturity date. (e): Denotes an estimate. Principal Amount of Loan. The total amount of money that is being borrowed from Lender (the "Principal") is provided in the Amount Financed box above.'}, //docs
            'metadata' => new List<String>()
        };
            
             String body = JSON.serialize(requestBody);
            
            // Construct the request payload
           /* String payload = '{"query": "'+query+'", "docs": ["'+docs+'"], "metadata": []}';*/
            request.setBody(body);
            
            HttpResponse response = new HttpResponse();
            Http http = new Http();
            Map<String,object> results = new Map<String, object>();
            
            try {
                response = http.send(request);
                
                // Get the response status code
                System.debug('response.getBody() ==> ' + response.getBody());
               
                String responseBody = response.getBody();
                System.debug('response.getBody() ==> ' + response.getBody());
                Integer statusCode = response.getStatusCode();

                if(statusCode == 200){
                    //answer = responseBody;
                    results = (Map<String,object>)JSON.deserializeUntyped(responseBody);
                    System.debug('results ==>'+ results);
                    return results;
                }else{
                    results.put('Callout' , responseBody);
                }

                // Print the response
                System.debug('Response Code: ' + statusCode);
                System.debug('Response Body: ' + responseBody);
                
            } catch (Exception e) {
                System.debug('Error: ' + e.getMessage());
            }
           return results;
          
        }
}