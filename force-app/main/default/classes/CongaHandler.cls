public class CongaHandler {

    public static void loadCongaDocument(String accountId)
    {
        String sessId = UserInfo.getSessionId();
        String servUrl = Url.getSalesforceBaseUrl().toExternalForm()+'/services/Soap/u/37.0/'+UserInfo.getOrganizationId();
    
        /*String url2 = 'https://composer.congamerge.com/composer8/index.html'+
                              '?sessionId='+sessId+
                              '&serverUrl='+EncodingUtil.urlEncode(servUrl, 'UTF-8')+
                              '&id=00128000007hiuE'+
                              '&TemplateId=a0L0K00 000FL8hN'+
                              '&SC0=1'+
                              '&SC1=Attachments'+
                              '&FP0=1'+
                              '&DS7=1'+
                              '&DefaultPDF=1&APIMode=1';*/
        
       String url2 = 'https://composer.congamerge.com/composer8/index.html'+
                        '?sessionId='+sessId+
                       '?serverUrl='+servUrl+
                       '&id='+accountId+
                       '&TemplateId=a1LS0000002MHoG'+
                           '&SC0=1'+
                          '&SC1=Attachments'+
                          '&FP0=1'+
                          '&DefaultPDF=1&APIMode=1';
        
 /*String url2 = 'https://composer.congamerge.com/composer8/index.html?SolMgr=1'+
 '&sessionId='+sessId+
'&serverUrl='+servUrl+
'&Id='+accountId+
'&TemplateId=a1LS0000002MHoG'+
//'&CongaEmailTemplateId=a1LS0000002MHoG'+
'&DefaultPDF=1'+
'&SC0=1'+
 '&FP0=1'+
'&DS7=1'+
'&SC1=Attachments'+
'&APIMode=1';*/
                          
    
        System.debug('Url is '+url2);
    
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url2);
        req.setMethod('GET');
        req.setTimeout(60000);
    
    // Send the request, and return a response
        HttpResponse res = http.send(req);
        System.debug(res);
        system.debug('Response status'+ res.getStatus() + ' => ' + res.getBody());
    
    }
}