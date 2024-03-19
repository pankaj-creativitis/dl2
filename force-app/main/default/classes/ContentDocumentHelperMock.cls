@isTest
public class ContentDocumentHelperMock implements HttpCalloutMock
{
	public HTTPResponse respond( HTTPRequest req ) 
	{
    	String jsonResponse = '{Test}';     
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(jsonResponse);
        res.setStatusCode(200);
        return res;
    }
}