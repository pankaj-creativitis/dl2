@isTest
public class TwilioTest  
{
	static testmethod void getAuthorizationHeaderTest()
	{
		Twilio.getAuthorizationHeader();
	}

	static testmethod void buildRequestBodyTest()
	{
		Twilio.buildRequestBody('15555555555','15555555555','test');
	}

	static testmethod void sendMessageWithAuthheaderTest()
	{
		Test.setMock(HttpCalloutMock.class, new HttpMockTest());
		Twilio.sendMessageWithAuthheader('15555555555','15555555555','test');
	}

	static testmethod void handleRequest()
	{
		List<Twilio.TwilioRequest> trList = new List<Twilio.TwilioRequest>();
		Twilio.TwilioRequest tr = new Twilio.TwilioRequest();
		tr.fromId = '15555555555';
		tr.toId = '15555555555';
		tr.text = '15555555555';
		trList.add(tr);
		Test.setMock(HttpCalloutMock.class, new HttpMockTest());
		Twilio.sendMessages(trList);
		Account acct = new Account();
		acct.Name = 'test';
		insert acct;
		Contact con = new Contact();
		con.Phone = '15555555555';
		con.AccountId = acct.Id;
		con.LastName = 'test';
		insert con;
		Twilio.sendMessages(trList);
	}
}