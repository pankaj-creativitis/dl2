public with sharing class EinsteinCases {

    @AuraEnabled(cacheable = true)
    public static List<String> getEinsteinCases(String strSubject) {
        HttpRequest httpRequest = new HttpRequest();
        
        // httpRequest.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionID());       
        // httpRequest.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
       
        
        List<String> strArr = strSubject.split(' ');
        String subject = String.join(strArr, '+');
        
        // List<String> subCatArr = subCat.split(' ');
        // String subCate = String.join(subCatArr,'+');
        
        httpRequest.setEndpoint('callout:Einstein_Search/services/data/v56.0/parameterizedSearch/?q=' +subject+'+'+ '&sobject=Case&Case.fields=Subject,CaseNumber,Description&Case.limit=15');

        httpRequest.setMethod('GET');
        String autho = 'Bearer {!$Einstein_Search.OAuthtoken}';
        httpRequest.setHeader('Authorization', autho);
        //httpRequest.setHeader('Content-type', 'application/json');
        
        Http http = new Http();  
        HttpResponse httpResponse;
        httpResponse = http.send(httpRequest);
        System.debug(httpResponse.getBody());

        List<Case> caseList = new List<Case>();
        List<String> caseIdsRelated = new List<String>();
       
        if (httpResponse.getStatusCode() == 200 ) { 
            //System.debug('response '+httpResponse.getBody());
            Map<String,Object> cases = (Map<String,Object>)JSON.deserializeUntyped(httpResponse.getBody());
            System.debug('cases available '+cases);
            List<Object> searchRecord = (List<Object>)cases.get('searchRecords');

            
            
            for(Object c: searchRecord){
                Case c1 = new Case();
                System.debug(c);
                Map<String,Object> record = (Map<String,Object>)c;
                String caseId = (String)record.get('Id');
                caseIdsRelated.add(caseId);
                String caseSubject = (String)record.get('Subject');
                // String name = (String)record.get('Name');
                // String resolution = (String)record.get('Resolution__c');
                // String subCategory = (String)record.get('Sub_Category__c');
                // String status = (String)record.get('Status__c');

                // System.debug('caseNumber '+casenumber);
                // System.debug('subject '+name);
                // System.debug('resolution '+resolution);
                // System.debug('sub category '+subCategory);
                // System.debug('status '+status);

                //c1.CaseNumber__c = casenumber;
                // c1.Id = caseId;
                // c1.Name = name;
                // c1.Resolution__c = resolution;
                // c1.Sub_Category__c = subCategory;
                // if(status == 'Closed'){
                //     c1.Status__c = status;
                caseList.add(c1);
                // }
            }
            System.debug('search records: '+searchRecord);
            //Map<String,object> results = (Map<String,object>)JSON.deserializeUntyped(httpResponse.getBody());
            
            //System.debug('Response Data: '+results);
        }else{
             System.debug(' httpResponse ' + httpResponse.getBody()+'Status: '+httpResponse.getStatus() ); 
             throw new CalloutException( httpResponse.getBody()+httpResponse.getStatusCode() );
        }
        return caseIdsRelated;
    }








    // /services/data/v57.0/parameterizedSearch/?q='+'+'++'&sobject=Knowledge__kav&Knowledge__kav.fields=Title&Knowledge__kav.limit=15



    // Getting the knowledge article
    @AuraEnabled(cacheable = true)
    public static List<String> getEinsteinKnowledgeArticle(String strSubject) {
        HttpRequest httpRequest = new HttpRequest();
    
        List<String> strArr = strSubject.split(' ');
        String subject = String.join(strArr, '+');
        
        httpRequest.setEndpoint('callout:Einstein_Search/services/data/v56.0/parameterizedSearch/?q=' +subject+'+'+ '&sobject=Knowledge__kav&Knowledge__kav.fields=Title&Knowledge__kav.limit=15');

        httpRequest.setMethod('GET');
        String autho = 'Bearer {!$Einstein_Search.OAuthtoken}';
        httpRequest.setHeader('Authorization', autho);
        
        Http http = new Http();  
        HttpResponse httpResponse;
        httpResponse = http.send(httpRequest);
        System.debug(httpResponse.getBody());

        List<Knowledge__kav> articleList = new List<Knowledge__kav>();
        List<String> articleIds = new List<String>();
       
        if (httpResponse.getStatusCode() == 200 ) { 
            Map<String,Object> articles = (Map<String,Object>)JSON.deserializeUntyped(httpResponse.getBody());
            System.debug('articles available '+articles);
            List<Object> searchRecord = (List<Object>)articles.get('searchRecords');

            
            
            for(Object c: searchRecord){
                // Case c1 = new Case();
                // System.debug(c);
                Map<String,Object> record = (Map<String,Object>)c;
                String articleId = (String)record.get('Id');
                articleIds.add(articleId);
                // String caseSubject = (String)record.get('Subject');
                
                // articleList.add(c1);
                // }
            }
            System.debug('search records: '+searchRecord);
        }else{
             System.debug(' httpResponse ' + httpResponse.getBody()+'Status: '+httpResponse.getStatus() ); 
             throw new CalloutException( httpResponse.getBody()+httpResponse.getStatusCode() );
        }
        return articleIds;
    }
}