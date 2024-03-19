global class Twilio  
{

    global static final String API_KEY;
    global static final String API_SECRET;
	global static final String ACCOUNT_SID;
    global static final String API_ENDPOINT = 'https://api.twilio.com/2010-04-01/Accounts/';
    global static final String MESSAGES_API = '/Messages.json';
	static
	{
		Twilio_Config__mdt tc = [Select Account_SID__c, Api_Key__c, Api_Secret__c from Twilio_Config__mdt where Active__c = true Limit 1];
		API_KEY = tc.Api_Key__c;
		API_SECRET = tc.Api_Secret__c;
		ACCOUNT_SID = tc.Account_SID__c;
	}

	global class TwilioRequest
	{
		@InvocableVariable(required=true) global String fromId;
		@InvocableVariable(required=true) global String toId;
		@InvocableVariable(required=true) global String text;
	}

	global class TwilioMessageRequest
	{
		@InvocableVariable(required=true) global String fromId;
		@InvocableVariable(required=true) global String toId;
		@InvocableVariable(required=true) global String text;
	}



	@InvocableMethod(label='Handle Message')
	global static void sendMessages(List<TwilioRequest> requests)
	{
		for(TwilioRequest tr : requests)
		{
			createLeadorOpp(tr);
		}
	}
	
	@TestVisible
	private static HttpRequest buildRequest(String body, String authHeader) 
	{
		HttpRequest req = new HttpRequest();
        req.setEndpoint(API_ENDPOINT + ACCOUNT_SID + MESSAGES_API);
        req.setMethod('POST');
        req.setHeader('Authorization', authHeader);
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
		req.setBody(body);
        return req;
	}

	@TestVisible
    private static String getAuthorizationHeader() 
	{
        Blob headerValue = Blob.valueOf(API_KEY + ':' + API_SECRET);
        return 'BASIC ' + EncodingUtil.base64Encode(headerValue);
    }

	@TestVisible
	private static String buildRequestBody(String toId, String fromId, String text) 
	{
		String body = 'To='+EncodingUtil.urlEncode(toId,'UTF-8')+'&From='+EncodingUtil.urlEncode(fromId,'UTF-8')+'&Body='+EncodingUtil.urlEncode(text,'UTF-8');
		return body;
	}


	@Future(callout=true)
	public static void sendMessageWithAuthheader(String toId, String fromId, String text) 
	{
		String body = buildRequestBody(toId, fromId, text);
		System.debug(body);
        HttpRequest request = buildRequest(body, getAuthorizationHeader());
		System.debug(request);
        Http http = new Http();
        HTTPResponse res = http.send(request);
		System.debug(res);
	}

	@TestVisible
	private static void createLeadorOpp(TwilioRequest tr)
	{
		string description = 'SMS Message Request more infromation "'+tr.text+'"';
		List<Contact> contactList = [SELECT id, Account.id, Name, HomePhone, MobilePhone, Phone FROM Contact
									WHERE HomePhone = :tr.fromId
									or MobilePhone = :tr.fromId
									or Phone = :tr.fromId];
		if(!contactList.isEmpty())
		{
			sendMessageWithAuthheader(tr.fromId, tr.toId, 'Thanks for the request '+contactList[0].Name+' for more information! One of our advisors will reach out to you shortly!');
		}
		else
		{
			sendMessageWithAuthheader(tr.fromId, tr.toId, 'Thanks for the request for more information! One of our advisors will reach out to you shortly!');
		}
		Lead newLead = new Lead();
		newLead.LastName = tr.fromId;
		newLead.MobilePhone = tr.fromId;
		newLead.Description = description;
		newLead.RecordTypeId = Schema.getGlobalDescribe().get('Lead').getDescribe().getRecordTypeInfosByName().get('Home Loan Record Type').getRecordTypeId();
		insert newLead;
	}
}