public class CheckinAccountController 
//implements Queueable,Database.AllowsCallouts 
{

    /*private String clientKey;
    private Id accountId;
    private Id finAccountId;
    
    public CheckinAccountController(String clientKey,Id accountId,Id financeAccountId)
    {
        clientKey = clientKey;
        accountId = accountId;
        finAccountId = financeAccountId;
    }
    
    public void execute(QueueableContext  qc)
    {
        
        createCheckInAccount(clientKey,accountId,finAccountId);
    }*/
    
     //@future (callout=true)
    public static void createCheckInAccount(String clientKey,Id accountId,Id financeAccountId)
    {
       
            List<CheckInAccountWrapper> checkinAccList = new List<CheckInAccountWrapper>();
            Currency1 currency1 = new Currency1('USD');
            //String clientKey ='8a8e874470cd04bc0170cd18d26202e9';
            String firstName = 'David Cors';
            String productTypeKey ='8a8e86796651309d016676c258600b06';
            List<CustomInformation>custInfoList = new List<CustomInformation>();
            CustomInformation customInfo = new CustomInformation('string', 'string');
            custInfoList.add(customInfo);
            //String clientKey = getClientKey(onlineId);
            Account account = [SELECT firstname FROM 
                               Account where id =: accountId];

            system.debug('client Key is'+clientKey);
             if(account.FirstName != null)
             {
                 firstName = account.FirstName;
             }
            CheckInAccountWrapper checkInAccWrapper = new CheckInAccountWrapper(firstName, '2000','CURRENT_ACCOUNT', clientKey,
                                                                               productTypeKey, currency1, custInfoList,'Note');
            checkinAccList.add(checkInAccWrapper);
        
            String jsonStr ='';
            jsonStr = JSON.serialize(checkinAccList);
            jsonStr = jsonStr.replace('currency1', 'currency');
            jsonStr = jsonStr.replace('[{"productTypeKey"', '{"productTypeKey"');
        
            system.debug('JsonString is '+jsonStr);
            HttpRequest request = new HttpRequest();
             request.setEndpoint('http://stg-tenant1.persistentdigitalbank.tk/pdbscheckingaccountservice/api/pdbscheckingaccservice');
             request.setMethod('POST');
             request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            request.setBody(jsonStr);
            system.debug('Request body is[--'+request.getBody());
              
            Http http = new Http();
            HTTPResponse response = http.send(request);
            system.debug('Checkin API Response Details are '+response.getStatusCode()+'---->Response Body'+response.getBody());
        	
            String accountNumber = getAccountNumber(response);
            system.debug('Checkin account num'+accountNumber);
            //Map<Id, String> accountNumFinancialAccts = new Map<Id,String>();
            //accountNumFinancialAccts.put(acc.Id,accountNumber);
            updateCheckAccNumber(financeAccountId,accountNumber);
        
            List<APILogResponse__c> apiRespList = new List<APILogResponse__c>();
            APILogResponse__c apiResponse = new APILogResponse__c();
            apiResponse.request__c = jsonStr;
            apiResponse.response__c = response.getBody();
            apiResponse.AccountType__c = 'Checkin';
            apiRespList.add(apiResponse);
            insert apiRespList;
      }
    
     /*public static void createCheckInAccount(String onlineId,Id accountId,Id financeAccountId, Id finAccId1, String accountNumber1,
                                                              Map<Id,String> accountIdOnlineIds, Id accountId1)
    {
      
            List<CheckInAccountWrapper> checkinAccList = new List<CheckInAccountWrapper>();
            Currency1 currency1 = new Currency1('USD');
            //String clientKey ='8a8e874470cd04bc0170cd18d26202e9';
            String firstName = 'David Cors';
            String productTypeKey ='8a8e86796651309d016676c258600b06';
            List<CustomInformation>custInfoList = new List<CustomInformation>();
            CustomInformation customInfo = new CustomInformation('string', 'string');
            custInfoList.add(customInfo);

            String clientKey = getClientKey(onlineId,accountId,financeAccountId, finAccId1, accountNumber1,
                                                              accountIdOnlineIds, accountId1);
           
      }*/
    
    private static String getAccountNumber(HttpResponse response)
    {
        JSONParser parser = JSON.createParser(response.getBody());
		String accountNumber = '';
		while (parser.nextToken() != null) {
			if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
					(parser.getText() == 'accountno')) {
					parser.nextToken();
					accountNumber  = parser.getText();
                    }
        }
         return accountNumber;
        
    }
    
    private static void updateCheckAccNumber(Id finAccId, String accountNumber)
    {
         List<FinServ__FinancialAccount__c> finaAccts = new List<FinServ__FinancialAccount__c>();
        FinServ__FinancialAccount__c finAccount = [Select FinServ__FinancialAccountNumber__c ,FinServ__PrimaryOwner__c  from FinServ__FinancialAccount__c 
                                                where Id = :finAccId ];
        finAccount.FinServ__FinancialAccountNumber__c = accountNumber;
        //system.debug('finAccounts---->'+finAccounts);
            /*if(finAccounts.size()>0)
            {
                for(FinServ__FinancialAccount__c finAcc : finAccounts)
                {
                    finAcc.FinServ__FinancialAccountNumber__c = accountNumber;
                    finaAccts.add(finAcc);
                }
            }*/
            update finAccount;
    }
    
    public static String getClientKey(String onlineId)
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
        if (response.getStatusCode() == 200 || response.getStatusCode() == 201){
             JSONParser parser = JSON.createParser(response.getBody());
		
		while (parser.nextToken() != null) {
			if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
					(parser.getText() == 'client_Key')) {
					parser.nextToken();
					clientKey  = parser.getText();
                    }
        }
            
        }
       
         return clientKey;
    }
    
     /*public static String getClientKey(String onlineId,Id accountId,Id financeAccountId, Id finAccId1, String accountNumber1,
                                                              Map<Id,String> accountIdOnlineIds, Id accountId1)
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
        if (response.getStatusCode() == 200 || response.getStatusCode() == 201){
             JSONParser parser = JSON.createParser(response.getBody());
		
		while (parser.nextToken() != null) {
			if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
					(parser.getText() == 'client_Key')) {
					parser.nextToken();
					clientKey  = parser.getText();
                    }
        }
            
             List<CheckInAccountWrapper> checkinAccList = new List<CheckInAccountWrapper>();
            Currency1 currency1 = new Currency1('USD');
            //String clientKey ='8a8e874470cd04bc0170cd18d26202e9';
            String firstName = 'David Cors';
            String productTypeKey ='8a8e86796651309d016676c258600b06';
            List<CustomInformation>custInfoList = new List<CustomInformation>();
            CustomInformation customInfo = new CustomInformation('string', 'string');
            custInfoList.add(customInfo);
            
             Account account = [SELECT firstname FROM 
                               Account where id =: accountId];

            system.debug('client Key is'+clientKey);
             if(account.FirstName != null)
             {
                 firstName = account.FirstName;
             }
            CheckInAccountWrapper checkInAccWrapper = new CheckInAccountWrapper(firstName, '2000','CURRENT_ACCOUNT', clientKey,
                                                                               productTypeKey, currency1, custInfoList,'Note');
            checkinAccList.add(checkInAccWrapper);
        
            String jsonStr ='';
            jsonStr = JSON.serialize(checkinAccList);
            jsonStr = jsonStr.replace('currency1', 'currency');
            jsonStr = jsonStr.replace('[{"productTypeKey"', '{"productTypeKey"');
        
            system.debug('JsonString is '+jsonStr);
            HttpRequest request1 = new HttpRequest();
             request1.setEndpoint('http://stg-tenant1.persistentdigitalbank.tk/pdbscheckingaccountservice/api/pdbscheckingaccservice');
             request1.setMethod('POST');
             request1.setHeader('Content-Type', 'application/json;charset=UTF-8');
            request1.setBody(jsonStr);
            system.debug('Request body is[--'+request1.getBody());
              
            Http http1 = new Http();
            HTTPResponse response1 = http1.send(request1);
            system.debug('Checkin API Response Details are '+response.getStatusCode()+'---->Response Body'+response.getBody());
        	
        if (response1.getStatusCode() == 200 || response1.getStatusCode() == 201){
            String accountNumber = getAccountNumber(response1);
            system.debug('Checkin account num'+accountNumber);
            //Map<Id, String> accountNumFinancialAccts = new Map<Id,String>();
            //accountNumFinancialAccts.put(acc.Id,accountNumber);
            updateCheckAccNumber(financeAccountId,accountNumber);
        
        
        updateSavingAccNumber(finAccId1,accountNumber1);
               updateOnlineId(accountIdOnlineIds, accountNumber1);
               updateSuccessStatus(accountId1);
        
        
            List<APILogResponse__c> apiRespList = new List<APILogResponse__c>();
            APILogResponse__c apiResponse = new APILogResponse__c();
            apiResponse.request__c = jsonStr;
            apiResponse.response__c = response.getBody();
            apiResponse.AccountType__c = 'Checkin';
            apiRespList.add(apiResponse);
            insert apiRespList;
        }
            
        }
       
         return clientKey;
    }*/
    public class CheckInAccountWrapper
    {
        public String accountName;
        public String amount;
        public String accountType;
        public String clientKey;
        public String productTypeKey;
        public Currency1 currency1;
        public List<CustomInformation> customInformation;
        public String notes;
        
        CheckInAccountWrapper(String accountName, String amount, String accountType, String clientKey,
                              String productTypeKey, Currency1 currency1, List<CustomInformation> customInformation, String notes )
        {
            this.accountName = accountName;
            this.amount = amount ;
            this.accountType = accountType;
            this.clientKey = clientKey;
            this.productTypeKey = productTypeKey;
            this.currency1 = currency1;
            this.customInformation = customInformation;
            this.notes = notes;
        }
 
    }

    public class Currency1
    {
        public String currancy;
        Currency1(String currancy)
        {
            this.currancy = currancy;
        }
    }
    public class CustomInformation
    {
        public String customField;
        public String value;
        
        CustomInformation(String customField, String value)
        {
            this.customField = customField;
            this.value = value;
        }
    }
    
    /************ Updates for Checking account success START ***********/
    
     private static void updateSavingAccNumber(Id finAccId, String accountNumber)
    {
         List<FinServ__FinancialAccount__c> finaAccts = new List<FinServ__FinancialAccount__c>();
        FinServ__FinancialAccount__c finAcc = [Select FinServ__FinancialAccountNumber__c ,Id  from FinServ__FinancialAccount__c 
                                                where Id = :finAccId];
        system.debug('finAcc---->'+finAcc);
        finAcc.FinServ__FinancialAccountNumber__c = accountNumber;
        update finAcc;
    }
    
        private static void updateOnlineId( Map<Id,String> accountIdOnlineIds, String accountNumber)
    {
        Set <Id> accountIds= accountIdOnlineIds.keySet();
       
        
        for(Id accId : accountIds)
            {
                List <Account> acctList = new List<Account>();
                Account accnt = [Select Id,AccountNumber, onlineId__c from Account where Id = : accId];
                String onlineId = accountIdOnlineIds.get(accId);
                system.debug('Online Id for SavingAccoutnControlelr'+onlineId);
                accnt.onlineId__c = onlineId;
                accnt.AccountNumber = accountNumber;
                acctList.add(accnt);
                update acctList;
            }
         }
    
    private static void updateSuccessStatus(Id accountId)
    {
         Account accnt = [Select SavingAccountStatus__c ,Id  from Account 
                                                where Id = :accountId];
        accnt.SavingAccountStatus__c = true;
        update accnt;
    }
    /************ Updates for Checking account success END ***********/
}