public class ClientController 
//implements Queueable,Database.AllowsCallouts
{
    /*private String onlineId;
    private Id accountId;
    
    public ClientController(String onlineId, Id accountId)
    {
        this.onlineId = onlineId;
        this.accountId = accountId;
    }
    public void execute(QueueableContext  qc)
    {
        String clientKey = getClientKey(onlineId);
        FinServ__FinancialAccount__c checkInAccount =  getCheckInAccount(accountId);
        CheckinAccountController checkIn = new CheckinAccountController(clientKey,accountId, checkInAccount.Id);
        System.enqueueJob(checkIn);
    }*/
    
    private static FinServ__FinancialAccount__c getCheckInAccount(Id accountId)
    {
       FinServ__FinancialAccount__c checkInAccount= [select Id, FinServ__FinancialAccountType__c,FinServ__PrimaryOwner__c from 
                                                 FinServ__FinancialAccount__c  where FinServ__PrimaryOwner__c = :accountId and
                                                 FinServ__RecordTypeName__c = 'Checking Account' order by createddate desc limit 1];
        return checkInAccount;
    }
    
  
    public static String getClientKey(String onlineId, Id finAccId, String accountNumber)
    {
         HttpRequest request = new HttpRequest();
         String url = 'https://stg-tenant1.persistentdigitalbank.tk/mambuclientservice/api/getClientId/'+onlineId;
         request.setEndpoint(url);
         request.setMethod('GET');
         request.setHeader('Content-Type', 'application/json;charset=UTF-8');
         Http http = new Http();
         HTTPResponse response = http.send(request);
        system.debug('Client Key API Response'+response.getBody()+'online Id'+onlineId);
       String clientKey = '';
        if (response.getStatusCode() == 200 || response.getStatusCode() == 201)
        {
            
            clientKey = getKey(response);
            //updateSavingAccNumber(finAccId,accountNumber);
            
        }
        
        return clientKey;
    } 
    
    
    private static void updateSavingAccNumber(Id finAccId, String accountNumber)
    {
         List<FinServ__FinancialAccount__c> finaAccts = new List<FinServ__FinancialAccount__c>();
        FinServ__FinancialAccount__c finAcc = [Select FinServ__FinancialAccountNumber__c ,Id  from FinServ__FinancialAccount__c 
                                                where Id = :finAccId];
        system.debug('finAcc---->'+finAcc);
        finAcc.FinServ__FinancialAccountNumber__c = accountNumber;
        update finAcc;
    }
        
    private static String getKey(HttpResponse response)
    {
        String clientKey ='';
        JSONParser parser = JSON.createParser(response.getBody());
		
		while (parser.nextToken() != null) {
			if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
					(parser.getText() == 'client_Key')) {
					parser.nextToken();
					clientKey  = parser.getText();
                    }
        }
       return clientKey;
    }
}