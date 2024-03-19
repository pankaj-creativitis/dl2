public with sharing class ChatGPTController {
    //private static String CHAT_GPT_KEY = OpenAiKey__c.getValues('Key1').API_Key__c; //Custom Setting
    //private static final String ENDPOINT ='https://api.openai.com/v1/completions';
    private static String CHAT_GPT_KEY = '228d1ca392e14934812677f1c21fa2e7';
    private static final String ENDPOINT ='https://dattaraj-openai-demo.openai.azure.com/openai/deployments/davinci/completions?api-version=2022-12-01&api-key='+CHAT_GPT_KEY;

    private static final String resText ='';
    
    public static String getAnswerFromChatGPT(String question){
        
        try{
            String seachQueryEscaped = (question).trim();
            Http http = new Http();
            String reqBody = '{"model": "text-davinci-003","prompt":"' +seachQueryEscaped+ '","max_tokens": 2000,"temperature": 0,' +'"stream": false,"top_p": 0.5}';

            System.debug('Query '+seachQueryEscaped+' '+reqBody);
            HttpRequest request = new HttpRequest();
            request.setEndpoint(ENDPOINT);
            request.setMethod('POST');
            request.setHeader('Authorization', 'Bearer '+String.escapeSingleQuotes(CHAT_GPT_KEY).trim());
            //Setting timeout to max 120 second to get whole response from Chat GPT Open API
            request.setTimeout(120000);
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            // Set the body as a JSON object
            request.setBody(reqBody);
            HttpResponse response = http.send(request);
            // Parse the JSON response
            if(response.getStatusCode() != 200) {
                System.debug('The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getBody());
                return response.getBody();
            }
            return response.getBody();
        }catch(Exception ex){
            System.debug('Exception in Catch of Server-Side Controller '+ex);
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
    @AuraEnabled
    public static String getQueryData(Id recordId){

       Case cs = CaseSelectorGPT.getCase(recordId);
       
        String taskSubsAndDescs = '';
        if (cs.Tasks.size() > 0) {
            for(Task t : cs.Tasks) {
               
                if (t.Description != null) {
                    taskSubsAndDescs = taskSubsAndDescs + String.valueOf(t.Description).trim() + '.';
                }

            }
            System.debug('taskSubsAndDescs ==> ' + taskSubsAndDescs);
            // System.debug('\n\n\n');
        }
        

        try{
            // task is list get only call log
            Http http = new Http();
            
            String seachQueryEscaped = 'Create a stepwise single knowledge article with definition and conclusion for the following case. ' + 'Subject: ' + cs.Subject + '. Case Description:' + cs.Description + ' Steps Followed to resolve the case:' + taskSubsAndDescs +'.' + 'Closure Remarks: ' + cs.Closing_Comments__c + ' Case Closed.';
            seachQueryEscaped = seachQueryEscaped.replace('\n', '<new line>');

            String reqBody = '{"model": "text-davinci-003","prompt":"'
            +seachQueryEscaped+
            '","max_tokens": 1000,"temperature": 0,'
            +'"stream": false,"top_p": 0.5}';
         
            HttpRequest request = new HttpRequest();
            request.setEndpoint(ENDPOINT);
            request.setMethod('POST');
            request.setHeader('Authorization', 'Bearer '+String.escapeSingleQuotes(CHAT_GPT_KEY).trim());
            //Setting timeout to max 120 second to get whole response from Chat GPT Open API
            request.setTimeout(120000);
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            // Set the body as a JSON object
            request.setBody(reqBody);
            System.debug('reqBody ==> ' + reqBody);
            /*System.debug('case.tasks.0 ==> ' + cs.Tasks[0].Description);
            System.debug('case.tasks.id ==> ' + cs.Tasks[0].Id);
            System.debug('case.tasks.subject ==> ' + cs.Tasks[0].Subject);*/


            List <Knowledge__kav> knowledgeArticleList = [SELECT Id, Title FROM Knowledge__kav WHERE Title = :cs.Subject];

            if (knowledgeArticleList.size() == 0){
                HttpResponse response = http.send(request);
                
                system.debug('Status Code: '+response.getStatusCode());
                // Parse the JSON response
                if(response.getStatusCode() == 200) {
                    
                    System.debug('response.getBody() ==> ' + response.getBody());
                    Map<String,object> results = (Map<String,object>)JSON.deserializeUntyped(response.getBody());
                    System.debug('Response Data: '+results);
                    List<Object> recommendations = (List<Object>)results.get('choices');
                    
                    String resText = '';
                    
                    for(Object res: recommendations){
                        system.debug('Response'+res);
                        Map<String,Object> map1 = (Map<String,Object>)res;
                        resText= (String)map1.get('text');
                        System.debug('\n\n\nresText: '+resText);
                                            
                    }
                    return resText;
                }
                System.debug('The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getBody());
                return null;
            }

            return 'NA';
        }catch(Exception ex){
            System.debug('Exception in Catch of Server-Side Controller '+ex);
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled
    public static List<String> generateArticleWithRelatedCases(Id recordId, List<Id> caseIds){

      
        List<Case> caseList = new List<Case>();

        caseList = CaseSelectorGPT.getCasesByIdsAura(caseIds);
        Case cs = CaseSelectorGPT.getCase(recordId);
        caseList.add(cs);


        //List<Case> allCases = CaseSelectorGPT.getCasesByIds(caseIds);
        
        String taskSubsAndDescs = '';
        String seachQueryEscaped = 'Create a stepwise single knowledge article with definition and conclusion for the following cases. ';
        List<String> resultGPT = new List<String>();


        // Create a stepwise single knowledge article for the following cases. CASE 1: Subject: Early Repayment Issue. Case Description:It is Early Repayment Issue in case of banks. Steps Followed to resolve the case:Connected with customer over call, Authenticated the customer using memorable word, Negotiated with customer, Agreed to pay $2000 as ERC Fee. Closure Remarks:Negotiated with customer and he agreed on $2000 as early repayment charges.. Closing the case. 
        // CASE 2: Subject: Overpayment. Case Description:It is Early Repayment Issue. Overpayment issue in case of banks. Steps Followed to resolve the case:Connected with customer over email, Authenticated the customer using OTP over mail. Negotiated with customer. Agreed to pay $1000 as ERC Fee. Closure Remarks:Negotiated with customer and he agreed on $1000 as early repayment charges. Closing the case.
        Integer i = 0;
        for(Case caseRel : caseList) {
            String tempGPT = '';
            System.debug('caseRel ==> ' + caseRel);

            if (caseRel.Tasks.size() > 0) {
                for(Task t : caseRel.Tasks) {
                    System.debug('Tasks caseRel ==> ' + t);
                    // taskSubsAndDescs = taskSubsAndDescs + String.valueOf(t.Subject).trim() + ':' + String.valueOf(t.Description).trim() + ',';
                    if (t.Description != null) {
                        taskSubsAndDescs = taskSubsAndDescs + String.valueOf(t.Description).trim() + ',';
                    }
                    

                    
                }
            }

            seachQueryEscaped += 'CASE ' + String.valueOf(++i) + ': ';

            seachQueryEscaped += 'Subject: ' + caseRel.Subject + '. Case Description:' + caseRel.Description + ' Steps Followed to resolve the case:' + taskSubsAndDescs +'.' + caseRel.Closing_Comments__c + ' Case Closed.';

            // seachQueryEscaped += 'Subject: ' + caseRel.Subject + '. Case Description:' + caseRel.Description + ' Steps Followed to resolve the case:' + taskSubsAndDescs +'.' + ' Closure Remarks:' + caseRel.Closing_Comments__c + ' Case Closed.';
            
            
            System.debug('collective result => ' + resultGPT);
            System.debug('seachQueryEscaped ==> ' + seachQueryEscaped);
            
        }

        String tempResult = callGPTWithCase(recordId, seachQueryEscaped);
        if (tempResult != null)  {
            // tempGPT = tempResult;
            resultGPT.add(tempResult);
        }
        
        System.debug('resultGpt size ==> ' + resultGPT.size());

        System.debug('seachQueryEscaped ==> ' + seachQueryEscaped);
        System.debug('seachQueryEscaped.length() ==> ' + seachQueryEscaped.length());
        return resultGPT;

        
    }


    public static String callGPTWithCase(Id recordId, String seachQueryEscaped){
        Case cs = CaseSelectorGPT.getCase(recordId);
        try{
            Http http = new Http();
            
            seachQueryEscaped = seachQueryEscaped.replace('\n', '<new line>');

            String reqBody = '{"model": "text-davinci-003","prompt":"'
            +seachQueryEscaped+
            '","max_tokens": 700,"temperature": 0,'
            +'"stream": false,"top_p": 0.5}';
         
            HttpRequest request = new HttpRequest();
            request.setEndpoint(ENDPOINT);
            request.setMethod('POST');
            request.setHeader('Authorization', 'Bearer '+String.escapeSingleQuotes(CHAT_GPT_KEY).trim());
            request.setTimeout(120000);
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            request.setBody(reqBody);


            List <Knowledge__kav> knowledgeArticleList = [SELECT Id, Title FROM Knowledge__kav WHERE Title = :cs.Subject];

            if (knowledgeArticleList.size() == 0){
                HttpResponse response = http.send(request);
                if(response.getStatusCode() == 200) {
                    
                    Map<String,object> results = (Map<String,object>)JSON.deserializeUntyped(response.getBody());
                    List<Object> recommendations = (List<Object>)results.get('choices');
                    
                    String resText = '';
                    
                    for(Object res: recommendations){
                        Map<String,Object> map1 = (Map<String,Object>)res;
                        resText= (String)map1.get('text');                                            
                    }
                    return resText;
                }
                return null;
            }

            return 'NA';
        }catch(Exception ex){
            System.debug('Exception in Catch of Server-Side Controller '+ex);
            throw new AuraHandledException(ex.getMessage());
        }
    }











    @AuraEnabled
    public static Id saveResposeData(Id recordId, List<Id> caseIds, String gptResult){

        System.debug('caseIds CaseSelectorGPT ==> ' + caseIds);
        System.debug('recordId CaseSelectorGPT ==> ' + recordId);

        Case cs = CaseSelectorGPT.getCase(recordId);
         system.debug('Selector case '+ cs);
        //  //String jsonResponse = (String)JSON.deserializeUntyped(gptResult);
        //  jsonResponse = gptResult;
         system.debug('gpt: '+ gptResult);


        
        
        Case currCase = [Select Id, Article_Number__c from Case Where Id =:recordId LIMIT 1];

        Knowledge__kav k1 = new Knowledge__kav();
        k1.Title = '' + cs.Subject;
        if (currCase.Article_Number__c == null) {
            currCase.Article_Number__c = 1;
        }
        
        String urlName = String.valueOf(cs.Subject).trim().replace(' ', '-');
        String gptResult1 = '<html>' + gptResult.replaceAll('\n', '<br>') + '</html>';
        
        k1.UrlName = urlName;
        System.debug('article number ==> '  + String.valueOf(Integer.valueOf(currCase.Article_Number__c) + 1));
        k1.RecordTypeId = '012S0000000nJizIAE';
        k1.Question__c = '';
        k1.Answer__c = gptResult1;
        insert k1;

        List<Case> updatedCases = new List<Case>();

        if (caseIds != null) {
            List<Case> caseList = CaseSelectorGPT.getCasesByIdsAura(caseIds);
            System.debug('caseList CaseSelectorGPT ==> ' + caseList);
            

            for (Case c : caseList) {
                c.Knowledge__c = k1.Id;
                updatedCases.add(c);
            }
            update updatedCases;
            System.debug('updatedCases ==> ' + updatedCases);
        }
        // else {
        Case cs1 = [Select Id, Knowledge__c From Case Where Id =: recordId];
        cs1.Knowledge__c = k1.Id;
        update cs1;
        System.debug('cs1 ==> ' + cs1);
        // }


        
        system.debug('print K1--: '+ k1);
        
        currCase.Article_Number__c = Integer.valueOf(currCase.Article_Number__c) + 1;
        update currCase;
        //system.debug('K1==> '+k1);
        Knowledge__kav kav= [SELECT Id, Answer__c, Title FROM Knowledge__kav WHERE Title = :k1.Title];
            
        system.debug('ka Id==>' +kav.Id);
        system.debug('ka Id==>' +kav.Answer__c);
        return kav.Id;
    }





    // method to get the related cases
    @AuraEnabled
    public static List<Case> getRelatedCases(Id recordId){
        try {
            Case cs = CaseSelectorGPT.getCase(recordId);
            List<String> caseIdListRelatedSubject = EinsteinCases.getEinsteinCases(cs.Subject);
            System.debug('caseIdListRelatedSubject ==> ' + caseIdListRelatedSubject);

            List<Case> caseListRelated = [SELECT Id, CaseNumber, Subject, Description FROM Case WHERE Id IN :caseIdListRelatedSubject AND Status = 'Closed' with security_enforced];

            System.debug('caseListRelated.size() ==> ' + caseListRelated.size());

            return caseListRelated;

            
        } catch (Exception e) {
            throw new AuraHandledException('From getRelated Cases ==> ' + e.getMessage());
        }
    }






    @AuraEnabled
    public static List<Knowledge__kav> getArticles(Id recordId){
        try {
            Case cs = CaseSelectorGPT.getCase(recordId);
            List<String> articleIdList = EinsteinCases.getEinsteinKnowledgeArticle(cs.Subject);
            System.debug('articleIdList ==> ' + articleIdList);

            List<Knowledge__kav> articleList = [SELECT Id, Title, Answer__c FROM Knowledge__kav WHERE Id IN :articleIdList with security_enforced];

            System.debug('articleList.size() ==> ' + articleList.size());

            return articleList;

            
        } catch (Exception e) {
            throw new AuraHandledException('From getRelated Cases ==> ' + e.getMessage());
        }
    }


    @auraEnabled
    public static List<String> updateArticleWithExistingCases(Id articleId, Id recordId, List<Id> selectedCaseIds){
      
        List<String> updatedGptText = new List<String>();
        List<Case> finalCases = new List<Case>();
      
        //Get the cases for exsiting knowledge article based on the comparision on base case subject
        List<Case> articleCaseList = CaseSelectorGPT.getCasesByArticleId(articleId);
        finalCases.addAll(articleCaseList);


        // Ids => unselected cases <= single base case
        List<Id> Ids = new List<Id>();
        for(Case c : finalCases){
            Ids.add(c.Id);
        }

       //call the generate knowledge article method with related cases
      
       if(selectedCaseIds == null){
        //call the getQueryData() for sigle case -- identify the older cases with same knowledge article
        updatedGptText = generateArticleWithRelatedCases(recordId, Ids);
        
      }else{

        // List<Id> selectedCaseIdsUpdate = new List<Id>();
        // for(Case cs : selectedCaseIds){
        //     selectedCaseIdsUpdate.add(cs.Id);
        // }

       //ignore the related cases which has knowlege article present
         List<Case> selectedCaseList = CaseSelectorGPT.getCasesByIdsAura(selectedCaseIds);
       
       //if cases does not have the user selected articleId will take only thoses cases
        for(case scs: selectedCaseList){
            
            if(scs.Knowledge__c != articleId){
                finalCases.add(scs);
            }
        }

        List<Id> finalIds = new List<Id>();
        for(Case c : finalCases){
            finalIds.add(c.Id);
        }
       updatedGptText = generateArticleWithRelatedCases(recordId, finalIds);
    }

      return updatedGptText;
    }

   
}