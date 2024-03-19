public with sharing class ChatGptHandler {
    //private static String CHAT_GPT_KEY = OpenAiKey__c.getValues('Key1').API_Key__c; //Custom Setting
    //private static final String ENDPOINT ='https://api.openai.com/v1/chat/completions';
    //private static final String ENDPOINT ='https://api.openai.com/v1/completions';
    //
    private static String CHAT_GPT_KEY = '228d1ca392e14934812677f1c21fa2e7';
    private static final String ENDPOINT ='https://dattaraj-openai-demo.openai.azure.com/openai/deployments/davinci/completions?api-version=2022-12-01&api-key='+CHAT_GPT_KEY;
    //private static final String resText ='';
    
    @AuraEnabled
    public static String getQueryData(Id recordId){

        //Id case1 = caseList[0].Id;
        Case cs = [SELECT Id, CaseNumber, Subject, Description, Closure_Remarks__c, Closing_Comments__c, (SELECT Id, Subject, ActivityDate, Owner.Name, Who.Name, What.Name, Description FROM Tasks) 
        FROM Case WHERE Id =:recordId Order by CreatedDate];
        system.debug('cs.Tasks.size() ==> '+cs.Tasks.size());
        // comments - task
        // Status - case
		System.debug('\n\n\n');
        System.debug('cs ==> ' + cs);
        System.debug('cs.Subject ==> ' + cs.Subject);
        System.debug('cs.Description ==> ' + cs.Description);
        System.debug('cs.Closure_Remarks__c ==> ' + cs.Closure_Remarks__c);
        System.debug('cs.Closing_Comments__c ==> ' + cs.Closing_Comments__c);
        
        String taskSubsAndDescs = '';
        if (cs.Tasks.size() > 0) {
            for(Task t : cs.Tasks) {
                // if (t.Subject != 'Email') {
                //     taskSubsAndDescs = taskSubsAndDescs + String.valueOf(t.Subject).trim() + ':' + String.valueOf(t.Description).trim() + '.';
                // }
                taskSubsAndDescs = taskSubsAndDescs + String.valueOf(t.Subject).trim() + ':' + String.valueOf(t.Description).trim() + '.';
                System.debug('t.Subject ==> ' + t.Subject);
                System.debug('t.Description ==> ' + t.Description);
            }
            System.debug('taskSubsAndDescs ==> ' + taskSubsAndDescs);
            System.debug('\n\n\n');
        }
        
        

        try{
            // task is list get only call log
            Http http = new Http();
            // List<String> taskDesc = (cs.Tasks[0].Description).split(',');
            String seachQueryEscaped = 'Convert it into good Step wise knowledge article with given information. Subject of the Case is ' + cs.Subject + '. Case Description:' + cs.Description + '. Steps Followed to resolve the case:' + taskSubsAndDescs +'.' + ' Closure Remarks:' + cs.Closing_Comments__c + '. Closing the case.';
            
            seachQueryEscaped = seachQueryEscaped.replace('\n', '<new line>');
            // seachQueryEscaped = seachQueryEscaped.replace('.', '<new line>');


            String reqBody = '{"model": "text-davinci-003","prompt":"'
            +seachQueryEscaped+
            '","max_tokens": 1000,"temperature": 0,'
            +'"stream": false,"top_p": 0.5}';
            


            // String reqBody = '{"model": "gpt-3.5-turbo-0301",'+
            //     '"messages": [{"role": "user", "content": "Hello!"}]}';
                

            // System.debug('Query '+seachQueryEscaped+' '+reqBody);
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
                        System.debug('resText: '+resText);
                                            
                    }
                    Case currCase = [Select Id, Article_Number__c from Case Where Id =:recordId LIMIT 1];
                    

                    Knowledge__kav k1 = new Knowledge__kav();
                    k1.Title = '' + cs.Subject;
                    if (currCase.Article_Number__c == null) {
                        currCase.Article_Number__c = 1;
                    }
                    
                    String urlName = String.valueOf(cs.Subject).trim().replace(' ', '-');
                    
                    k1.UrlName = urlName;
                    System.debug('article number ==> '  + String.valueOf(Integer.valueOf(currCase.Article_Number__c) + 1));
                    k1.RecordTypeId = '012S0000000nJizIAE';
                    k1.Question__c = '';
                    k1.Answer__c = resText;
                    insert k1;
                    
                    currCase.Article_Number__c = Integer.valueOf(currCase.Article_Number__c) + 1;
                    update currCase;
                    system.debug('K1==> '+k1);
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
}