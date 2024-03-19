@RestResource(urlMapping='/account/v1/balance/*')
global with sharing class API_Account {
    @HttpGet
    global static void getBalance(){
         RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String accountId = req.requestURI.substring( req.requestURI.lastIndexOf('/')+1);
        system.debug('Account id is '+accountId);
        if( String.isNotBlank(accountId))
        {
            res = generateResponse(res, accountId);
        }
        system.debug('Response is '+res.responseBody);
    }
    public static RestResponse generateResponse(RestResponse res , String accountId){
        try
        {
           if(accountId.length() == 0)
           {
                res.statusCode = 200;
                //alertResponse = new AlertsRestWrapper();
                //res.responseBody = Blob.valueOf(JSON.serialize(alertResponse));
                return res;
            }
            else
            {
                List<FinServ__FinancialAccount__c> finAccounts = [SELECT FinServ__FinancialAccountNumber__c,FinServ__PrimaryOwner__c,FinServ__Balance__c,FinServ__FinancialAccountType__c,Sub_type__c FROM FinServ__FinancialAccount__c where
                  FinServ__PrimaryOwner__c = :accountId];
                AccountResponseWrapper alertResponse = AccountResponseWrapper.generateAccountWrapperRecord(finAccounts);
                System.debug('alertResponse is....'+alertResponse);
                res.responseBody  = Blob.valueOf(JSON.serializePretty(alertResponse));
                return res;
            }
         }
         catch(Exception e)
         {
            res.statusCode = 500; 
            res.responseBody = Blob.valueOf(JSON.serializePretty(e));
         }
        return res;
    
}
    
}