public class CustomerChatGPTSearchArticle {
    public class CaseWrapper{
   		@auraEnabled
        public string caseNumber; 
        @auraEnabled
        public string caseSubject; 
        @auraEnabled        
        public string caseStatus; 
        @auraEnabled        
        public string answer; 
        @auraEnabled        
        public string statusCode;

        public CaseWrapper(String caseNumber, String caseSubject,String caseStatus){
        this.caseNumber = caseNumber;
        this.caseSubject = caseSubject;
        this.caseStatus = caseStatus;
	} 
        public CaseWrapper(){
            
        }
        
    }
    

    @AuraEnabled(cacheable = true)
    public static List<Knowledge__kav> getEinsteinArticles(String strQuestion) {
        HttpRequest httpRequest = new HttpRequest();       
        
        List<String> strArr = strQuestion.split(' ');
        String question = String.join(strArr, '+');
        system.debug('question---'+question);
        
        
        httpRequest.setEndpoint('callout:Einstein_Search/services/data/v56.0/parameterizedSearch/?q=' +question+'+'+ '&sobject=Knowledge__kav&Knowledge__kav.fields=Question__c,Answer__c&Knowledge__kav.limit=5');

        httpRequest.setMethod('GET');
        String autho = 'Bearer {!$Einstein_Search.OAuthtoken}';
        httpRequest.setHeader('Authorization', autho);
        //httpRequest.setHeader('Content-type', 'application/json');
        
        Http http = new Http();  
        HttpResponse httpResponse;
        httpResponse = http.send(httpRequest);
        System.debug(httpResponse.getBody());

        List<Knowledge__kav> articleList = new List<Knowledge__kav>();
        List<Knowledge__kav> customerArticleList = new List<Knowledge__kav>();
        List<String> articleIdsRelated = new List<String>();
        //List<Knowledge__kav> knowledgeList;
       
        if (httpResponse.getStatusCode() == 200 ) { 
            //System.debug('response '+httpResponse.getBody());
            Map<String,Object> articles = (Map<String,Object>)JSON.deserializeUntyped(httpResponse.getBody());
            System.debug('cases available '+articles);
            List<Object> searchRecord = (List<Object>)articles.get('searchRecords');

            
            
            for(Object article: searchRecord){
                Knowledge__kav c1 = new Knowledge__kav();
                System.debug('records-----'+article);
                Map<String,Object> record = (Map<String,Object>)article;
                String articleId = (String)record.get('Id');
                articleIdsRelated.add(articleId);
               // String answer = (String)record.get('Answer__c');
                //articleList.add((knowledge__kav)article);
                 
            }
             articleList = [SELECT Id,Question__c, Answer__c, RecordTypeId FROM Knowledge__kav where Id IN:articleIdsRelated];
             System.debug('articleList : '+articleList);
             System.debug(' Size of articleList : '+articleList.size());

             for(Knowledge__kav kav: articleList){
                if(kav.RecordTypeId!='012S0000003rMyLIAU'){
                    customerArticleList.add(kav);
                }
             }
            System.debug('search records: '+customerArticleList);
            System.debug(' Size of customerArticleList : '+customerArticleList.size());
            //Map<String,object> results = (Map<String,object>)JSON.deserializeUntyped(httpResponse.getBody());
            
            //System.debug('Response Data: '+results);
        }else{
             System.debug(' httpResponse ' + httpResponse.getBody()+'Status: '+httpResponse.getStatus() ); 
             throw new CalloutException( httpResponse.getBody()+httpResponse.getStatusCode() );
        }
        return customerArticleList;
    }

    
    @AuraEnabled(cacheable = true)
    public static List<CaseWrapper> getCases(String strQuestion) {
           HttpRequest httpRequest = new HttpRequest();
        
            List<String> strArr = strQuestion.split(' ');
            String question = String.join(strArr, '+');
        
        
        httpRequest.setEndpoint('callout:Einstein_Search/services/data/v56.0/parameterizedSearch/?q=' +question+'+'+ '&sobject=Case&Case.fields=Subject,Status,CaseNumber&Case.limit=15');

        httpRequest.setMethod('GET');
        String autho = 'Bearer {!$Einstein_Search.OAuthtoken}';
        httpRequest.setHeader('Authorization', autho);
        //httpRequest.setHeader('Content-type', 'application/json');
        
        Http http = new Http();  
        HttpResponse httpResponse;
        httpResponse = http.send(httpRequest);
        System.debug(httpResponse.getBody());

        List<CaseWrapper> caseList = new List<CaseWrapper>();
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
                //caseIdsRelated.add(caseId);
                String caseSubject = (String)record.get('Subject');
                String status = (String)record.get('Status');
                String subject = (String)record.get('Subject');
                String cNumber = (String)record.get('CaseNumber');
                System.debug('status '+status);
                
                CaseWrapper wrapper = new CaseWrapper(cNumber,subject,status); 
                caseList.add(wrapper);
                
               
            }
            System.debug('search records: '+searchRecord);
            
        }else{
             System.debug(' httpResponse ' + httpResponse.getBody()+'Status: '+httpResponse.getStatus() ); 
             throw new CalloutException( httpResponse.getBody()+httpResponse.getStatusCode() );
        }
        return caseList;
    }


}