public class SavingAccountController 
//implements Queueable,Database.AllowsCallouts
{
    /*private List<Id> accountIdList;
    private Id finAccId;
    
    public SavingAccountCOntroller(List<Id> accountIds, Id financeAccountId)
    {
        accountIdList = accountIds;
        finAccId = financeAccountId;
    }
    
    public void execute(QueueableContext  qc)
    {
        
        updateContactForAWS(accountIdList, finAccId);
    }*/
    
//@InvocableMethod(label='Save Accounts' description='Save the account via Mambu API' category= 'Contact')
    @future (callout=true)
   public static void updateContactForAWS(List<Id> accountIdList, Id finAccId) {
       
       FinServ__FinancialAccount__c finAccount = [select FinServ__Balance__c from FinServ__FinancialAccount__c where id= :finAccId];
       List<Account> accounts = [SELECT Id,lastname,firstname,PersonEmail,PersonMobilePhone, Primary_Account_Balance__c,RecordTypeId,isPersonAccount 
                                 FROM Account where id in: accountIdList];
         String token = '';
        String acctId = '';
        String clientId = '';
       //String randomNumber = String.valueof((Math.random() * 10));
       //system.debug('randomNumber is'+randomNumber);
       Map<Id,String> accountIdOnlineIds = new  Map<Id,String>();
       String firstName = '';
       String lastName = '';
       String email = '';
       String mobilePhone = '';
       Decimal balance = 0.0;
       
        for(Account acc : accounts)
        {
           firstName = acc.FirstName;
           lastName = acc.LastName;
           email = acc.personEmail;
           mobilePhone = acc.PersonMobilePhone;
           balance = finAccount.FinServ__Balance__c;
           String hashString = '1000' + String.valueOf(Datetime.now().formatGMT('yyyy-MM-dd HH:mm:ss.SSS'));
		   Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(hashString));
           String onlineId = EncodingUtil.convertToHex(hash);
           onlineId = onlineId.substring(22,onlineId.length());
           //String onlineId = randomNumber.substring(2,6);
           accountIdOnlineIds.put(acc.Id, onlineId);
           system.debug('Mobile'+mobilePhone);
           String requestBody = '{"client":{"firstName":"' + firstName + '","lastName":"' + lastName + '","middleName":"","emailAddress":"' + email + '","mobilePhone1":"' + mobilePhone + '","gender":"Male","birthDate":"1988-01-01","password":"persistent123@"},"addresses":[{"line1":"abc","line2":"xyz","city":"Pune","region":"Pune","postcode":"411057","country":"India"}],"customInformation":[{"value":"1123", "customFieldID":"SSN-ID"},{"value":"IT","customFieldID":"Occupation"},{"value":"Married","customFieldID":"Marital_Status"},{"value":"' + onlineId + '", "customFieldID":"Online_Id" }], "fundtype":"Credit Card", "fundamount":"' + balance+ '", "fundno":"10001"}';
          //String requestBody = '{"client":{"firstName":"Bhakti","lastName":"Lawande","middleName":"Jaikrishna","emailAddress":"lawandebhakti@gmail.com","mobilePhone1":"9689938674","gender":"Male","birthDate":"1988-01-01","password":"persistent123@"},"addresses":[{"line1":"abc","line2":"xyz","city":"Pune","region":"Pune","postcode":"411057","country":"India"}],"customInformation":[{"value":"001123", "customFieldID":"SSN-ID"},{"value":"IT","customFieldID":"Occupation"},{"value":"Married","customFieldID":"Marital_Status"},{"value":"001123", "customFieldID":"Online_Id" }], "fundtype":"Credit Card", "fundamount":"100", "fundno":"10001"}';
       
        System.debug('requestBody: ' + requestBody);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://stg-tenant1.persistentdigitalbank.tk/pslbankaccountservice/createSavingAcc');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(requestBody);
        request.setTimeout(40000);
        HttpResponse response = http.send(request);	
        System.debug('response is: ' + response);
        System.debug('response: ' + response.getBody());
        System.debug('response status code ' + response.getStatusCode());
        updateLogResponse(response, requestBody);
         if (response.getStatusCode() == 200 || response.getStatusCode() == 201)
         	{
                 String accountNumber = getAccountNumber(response);
                 //Set <Id> accountIds = accountIdOnlineIds.keySet();
                 //Map<Id, String> accountNumFinancialAccts = new Map<Id,String>();
                 //accountNumFinancialAccts.put(finAccId,accountNumber);
                system.debug('SavingAcc Id --->'+finAccId);
                
                
                /*ClientController clientController = new ClientController(onlineId,acc.Id);
                System.enqueueJob(clientController);*/
                //String clientKey = ClientController.getClientKey(onlineId,finAccId,accountNumber);
                updateSavingAccNumber(finAccId,accountNumber);
                //FinServ__FinancialAccount__c checkInAccount =  getCheckInAccount(acc.Id);
        		/*CheckinAccountController checkIn = new CheckinAccountController(clientKey,acc.Id, checkInAccount.Id);
       		    System.enqueueJob(checkIn);*/
                //FinServ__FinancialAccount__c checkInAccount =  getCheckInAccount(acc.Id);
                 // updateOnlineId(accountIdOnlineIds, accountNumber);
                //system.debug('CheckInAccount Id --->'+checkInAccount.Id);
                //CheckinAccountController.createCheckInAccount(clientKey,acc.Id, checkInAccount.Id);
                 //CheckinAccountController.createCheckInAccount(onlineId,acc.Id, checkInAccount.Id, finAccId, accountNumber,accountIdOnlineIds, acc.Id);
                
                   updateOnlineId(accountIdOnlineIds, accountNumber);
                   updateSuccessStatus(acc.Id);
                 
         	}
        }
      }
    private static FinServ__FinancialAccount__c getCheckInAccount(Id accountId)
    {
       FinServ__FinancialAccount__c checkInAccount= [select Id, FinServ__FinancialAccountType__c,FinServ__PrimaryOwner__c from 
                                                 FinServ__FinancialAccount__c  where FinServ__PrimaryOwner__c = :accountId and
                                                 FinServ__RecordTypeName__c = 'Checking Account' order by createddate desc limit 1];
        return checkInAccount;
    }
    public static void updateAccountStatus(Id accountId,String typeOfAccount)
    {
        Account acc = [Select SavingAccountStatus__c,CheckingStatus__c from Account where Id = :accountId];
        if(typeOfAccount.equalsIgnoreCase('Saving'))
        {
            acc.SavingAccountStatus__c = true;
        }
        else
        {
            acc.CheckingStatus__c = true;
        }
        update acc;
    }
    private static void updateSuccessStatus(Id accountId)
    {
         Account accnt = [Select SavingAccountStatus__c ,Id  from Account 
                                                where Id = :accountId];
        accnt.SavingAccountStatus__c = true;
        update accnt;
    }
    
    private static String getAccountNumber(HttpResponse response)
    {
        JSONParser parser = JSON.createParser(response.getBody());
		String accountNumber = '';
		while (parser.nextToken() != null) {
            system.debug(' vals >>> ' + parser.getText());
			if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
					(parser.getText() == 'accountid')) {
					parser.nextToken();
					accountNumber  = parser.getText();
                        system.debug(' accountNumber >>> ' + accountNumber);
                    }
        }
         return accountNumber;
        
    }
    
    private static void updateLogResponse(HttpResponse response, String requestBody)
    {
        List<APILogResponse__c> apiRespList = new List<APILogResponse__c>();
        APILogResponse__c apiResponse = new APILogResponse__c();
        apiResponse.request__c = requestBody;
        apiResponse.response__c = response.getBody();
        apiResponse.AccountType__c ='Saving';
        apiRespList.add(apiResponse);
        insert apiRespList;
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
}