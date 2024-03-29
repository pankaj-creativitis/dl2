public class KonnectInsightsTicketEventUpdates implements HttpCalloutMock {

    public static HttpRequest request;
    public static HttpResponse response;

    public HTTPResponse respond(HTTPRequest req) {
        request = req;
        response = new HttpResponse();
        response.setStatusCode(200);
        return response;
    }

    public static String jsonContent(List<Object> triggerNew, List<Object> triggerOld) {
        String newObjects = '[]';
        if (triggerNew != null) {
            newObjects = JSON.serialize(triggerNew);
        }

        String oldObjects = '[]';
        if (triggerOld != null) {
            oldObjects = JSON.serialize(triggerOld);
        }

        String userId = JSON.serialize(UserInfo.getUserId());

        String content = '{"new": ' + newObjects + ', "old": ' + oldObjects + ', "userId": ' + userId + '}';
        return content;
    }

    public static String JsonContentFromObject(Object obj){
        String newObjects = '[]';
        if (obj != null) {
            newObjects = JSON.serialize(obj);
        }
        String userId = JSON.serialize(UserInfo.getUserId());
        String content = '{"new": ' + newObjects + ', "userId": ' + userId + '}';
        return content;
    }

    @future(callout=true)
    public static void callout(String url, String content) {

        if (Test.isRunningTest()) {
            Test.setMock(HttpCalloutMock.class, new KonnectInsightsTicketEventUpdates());
        }

        Http h = new Http();

        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(content);

        h.send(req);
    }

}