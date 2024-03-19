public with sharing class ChatGPTIntegration {
    private static final String CHATGPT_API_KEY='';
    private static final String CHATGPT_API_ENDPOINT= '';



    static List<Knowledge__kav> loanList = new List<Knowledge__kav>(); 
    @AuraEnabled
    public static String getAnswerFromChatGPT(String question){

        try{
            String seachQueryEscaped = (question).trim();
            //List<Knowledge__kav> loans = [SELECT Question__c, Answer__c FROM Knowledge__kav order by CreatedDate desc Limit 10];
            List<Knowledge__kav> loans = ChatGPTSearchArticle.getEinsteinArticles(question);
            //List<ChatGPTSearchArticle.CaseWrapper> dataToPass = new List<ChatGPTSearchArticle.CaseWrapper>();
            System.debug('loans -----'+loans);
                        
            List<Map<String, Object>> objectData = new List<Map<String, Object>>();
            String jsonData = 'Consider Article- ';
            String question1 = 'Please respond to the following statement based on these classifications: pleasantries, questions/issues/concerns, or irrelevant. Strictly do not show the classification result; show only the response. If it is questions/issues/concerns, search in the below knowledge article data provided. Summarize the knowledge article response step-wise and in a user-friendly manner. For pleasantries, respond pleasantly and conversationally; do not send the classification. For irrelevant and unclear statements, respond with didn\'t understand, please ask a relevant question. If the statement contains the keyword code then generate code in response. Statement: '+ question;
        for (Knowledge__kav loan : loans) {
            Map<String, Object> data = new Map<String, Object>();
            jsonData = jsonData + 'Question :'+loan.Question__c+',Answer :'+loan.Answer__c+',';
            data.put('Question', loan.Question__c);
            //String que = loan.Question__c;
           data.put('Answer', loan.Answer__c);
            
           /* if(question.contains(loan.Question__c)){
                question1 += loan.Question__c;
             system.debug('true');
    		}else{
       		 system.debug('false');
    		}*/
            //objectData.add(data);
        }

        jsonData = jsonData + '';
        String jsonWithoutHtml = jsonData.stripHtmlTags();
        //String finalData = jsonWithoutHtml;
        String finalData = jsonWithoutHtml.remove('null');
        String jsoDnata1  = finalData.replaceAll('[" ( ) “ ” \' \n ’]' ,' ');
        //String question1 =  ' And Summerize step wise and with user friendly way and give response as per question, simple down and rephrase the data ' +question;  
        System.debug('question1==>'+question1);
		//String s2 = s1.stripHtmlTags();
        System.debug('final Data==>'+jsoDnata1);
		 
        Http http = new Http();

        //String reqBody = '{"model": "text-davinci-003","prompt": "'+jsoDnata1+ ' '+question1+'","max_tokens": 700,"temperature": 0,"stream": false,"top_p": 0.5 }';
         String reqBody = '{"model": "text-davinci-003","prompt": "'+jsoDnata1+'.'+question1+ '","max_tokens": 700,"temperature": 0,' +'"stream": false,"top_p": 0.5}';
       /* String reqBody = '{"model": "gpt-3.5-turbo",'+
          '"messages": [{"role": "system", "content": '+'"consider data:'+jsonRes+'"}, {"role": "user", "content": "'+quest+'"}]'+
            '}';*/ 
            System.debug('Query '+reqBody);
            HttpRequest request = new HttpRequest();
            request.setEndpoint(CHATGPT_API_ENDPOINT);
            request.setMethod('POST');
            request.setHeader('Authorization', 'Bearer '+String.escapeSingleQuotes(CHATGPT_API_KEY).trim());
            //Setting timeout to max 120 second to get whole response from Chat GPT Open API
            request.setTimeout(120000);
            request.setHeader('Content-Type', 'application/json');
            // Set the body as a JSON object
            request.setBody(reqBody);
            HttpResponse response = http.send(request);
            // Parse the JSON response
            if(response.getStatusCode() != 200) {
                System.debug('The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getBody());
                // ChatGPTSearchArticle.CaseWrapper cw = new ChatGPTSearchArticle.CaseWrapper();
                // cw.statusCode = response.getBody();
                // dataToPass.add(cw);
                return response.getBody();
            }
            Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
            System.debug('response'+response.getBody());
            List< Object> choice  = (List< Object>)JSON.deserializeUntyped(JSON.serialize(responseMap.get('choices')));
            Map<String, Object> topchoice  = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(choice[0]));
            //System.debug('choice'+ topchoice.get('text'));
            String answer = JSON.serialize(topchoice.get('text')).trim().replaceAll('\\\\n', '');
                
            // if(answer.trim().equalsIgnoreCase('Data is not relevant')){
            //     dataToPass = ChatGPTSearchArticle.getCases(question);
            //     return dataToPass;
            // }
            
                String answer1 = answer.replaceAll('\\d\\.', '\n$0');
                // ChatGPTSearchArticle.CaseWrapper cw = new ChatGPTSearchArticle.CaseWrapper();
                // cw.answer = answer1;
                // dataToPass.add(cw);
               // system.debug('data to pass----'+dataToPass);
                return answer1;   
            
             
            
          }catch(Exception ex){
            System.debug('Exception in Catch of Server-Side Controller '+ex);
            throw new AuraHandledException(ex.getMessage());
        }

    }
       public static String extractCaseNumber(String question) {
           String caseNumber = null;
           Pattern pattern = Pattern.compile('\\b\\d{4,}\\b'); // Regular expression to match 4 or more digits (case number pattern)
           Matcher matcher = pattern.matcher(question);
        
           if (matcher.find()) {
               caseNumber = matcher.group(); // Extract the matched case number
           }
      
           return caseNumber;
        }
    
    @AuraEnabled
    public static String summerizeCase(String question){
        try{
            String seachQueryEscaped = (question).trim();
            // String caseNo = extractCaseNumber(seachQueryEscaped);
            // system.debug('extraxtcase --'+caseNo);
            // List<Case> cases = [SELECT Id,CaseNumber,OwnerId,AccountId,Status,Subject,Description,Closing_Comments__c FROM Case where CaseNumber =:caseNo];       

            List<Case> cases = [SELECT Id,CaseNumber,OwnerId,AccountId,Status,Subject,Description,Closing_Comments__c FROM Case order by LastModifiedDate desc LIMIT 10];       

            // Prepare the data to send to ChatGPT
            List<Map<String, Object>> objectData = new List<Map<String, Object>>();
            String jsonData = 'Case Details: ';
            String que = 'Please respond to the following question based on the below case details. If it is an answer/summary that you can provide from the below data, please provide only the response. Or if it’s an action to close a case respond with ‘closecase’, to change the case status to open respond with ‘reopencase’, to change the case status to new respond with ‘newcase’ and to change the status to on hold respond with ‘onholdcase’ in plain text format. Question: ' +question;
            String caseNumber = extractCaseNumber(que);
            system.debug('extraxtcase number--'+caseNumber);
           // String jsonData = '{';

        for (Case cs : cases) {
            Map<String, Object> data = new Map<String, Object>();
            jsonData = jsonData + 'Id:' + cs.Id + ',Case Number :'+cs.CaseNumber+',OwnerId :'+cs.OwnerId+',AccountId :'+cs.AccountId+', Status :'+cs.Status+', Subject:'+cs.Subject+',Description:'+cs.Description+',Closing_Comments__c:'+cs.Closing_Comments__c+',';
            data.put('Id', cs.Id);
            data.put('Case Number', cs.CaseNumber);
            data.put('AccountId', cs.AccountId);
            data.put('OwnerId', cs.OwnerId);
            data.put('Status',cs.Status);
            data.put('Subject', cs.Subject);
            data.put('Description', cs.Description);
            data.put('Closing_Comments__c', cs.Closing_Comments__c);   
            objectData.add(data);
        }

        jsonData = jsonData + '';
        String jsonWithoutHtml = jsonData.stripHtmlTags();
        //String finalData = jsonWithoutHtml;
        String finalData = jsonWithoutHtml.remove('null');
        String jsoDnata1  = finalData.replaceAll('[" ( ) “ ” \' \n ’]' ,' ');
        System.debug('question1==>'+que);

            System.debug('json---'+jsoDnata1);
            Http http = new Http();

           //  String reqBody = '{"model": "gpt-3.5-turbo",'+
           // '"messages": [{"role": "system", "content": "'+jsoDnata1+'"}, {"role": "user", "content": "'+que+'"}]'+
          //  '}';
            String reqBody = '{"model": "text-davinci-003","prompt":"'+jsoDnata1+'.'+que+ '","max_tokens": 700,"temperature": 0,' +'"stream": false,"top_p": 0.5}';
            System.debug('Query '+que+' '+reqBody);
            HttpRequest request = new HttpRequest();
            request.setEndpoint(CHATGPT_API_ENDPOINT);
            request.setMethod('POST');
            request.setHeader('Authorization', 'Bearer '+String.escapeSingleQuotes(CHATGPT_API_KEY).trim());
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
            Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
            System.debug('response'+response.getBody());
            List< Object> choice  = (List< Object>)JSON.deserializeUntyped(JSON.serialize(responseMap.get('choices')));
            Map<String, Object> topchoice  = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(choice[0]));
            //System.debug('choice'+ topchoice.get('text'));
            String answer = JSON.serialize(topchoice.get('text')).replaceAll('\\\\n', '');
            
               if (answer.toLowerCase().contains('closecase')) {
                   updateCaseStatus(caseNumber, 'Closed');
                   return 'Case '+caseNumber+ ' has been closed';
               } else if (answer.toLowerCase().contains('reopencase')) {
                   updateCaseStatus(caseNumber, 'Open');
                   return 'Case '+caseNumber+ ' has been reopened';
               } else if (answer.toLowerCase().contains('newcase')) {
                   updateCaseStatus(caseNumber, 'New');
                   return 'Case '+caseNumber+ ' status has been changed to new';
               } else if (answer.toLowerCase().contains('onholdcase')) {
                   updateCaseStatus(caseNumber, 'On Hold');
                   return 'Case '+caseNumber+ ' has been put on hold';
               }
           
              
            return answer;
        }catch(Exception ex){
            System.debug('Exception in Catch of Server-Side Controller '+ex);
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
    // Method to update case status based on case number
    @AuraEnabled
	public static void updateCaseStatus(String caseNumber, String newStatus) {
   	Case cs = [SELECT Id, Status FROM Case WHERE CaseNumber = :caseNumber LIMIT 1];
  	cs.Status = newStatus;
    system.debug('case status--'+cs.Status);
   	update cs;
	}
    
    @AuraEnabled
    public static String accountDetails(String question){
        try{
            String seachQueryEscaped = (question).trim();
            
           List<Account> acc = [SELECT Id,Name,AccountNumber,Email__c,PersonEmail,Description,Type,OwnerId,FinServ__Status__c FROM Account order by CreatedDate desc LIMIT 10];       
            // Prepare the data to send to ChatGPT
            List<Map<String, Object>> objectData = new List<Map<String, Object>>();
            String jsonData = 'Consider Article- ';
          //  String que = 'Summerize the cas +question;
           // String jsonData = '{';

        for (Account ac : acc) {
            Map<String, Object> data = new Map<String, Object>();
            jsonData = jsonData + 'Id:' + ac.Id + ',Name :'+ac.Name+',OwnerId :'+ac.OwnerId+',Account Number:'+ac.AccountNumber+',Description:'+ac.Description+', Status:'+ac.FinServ__Status__c+',PersonEmail:'+ac.PersonEmail+',Email__c:'+ac.Email__c+',';
            data.put('Id', ac.Id);
            data.put('Name', ac.Name);
            data.put('OwnerId', ac.OwnerId);
            data.put('PersonEmail', ac.PersonEmail);
            data.put('Account Number', ac.AccountNumber);
            data.put('Description', ac.Description);
            data.put('Email__c', ac.Email__c);  
            data.put('Status', ac.FinServ__Status__c);
            objectData.add(data);
        }

        jsonData = jsonData + '';
        String jsonWithoutHtml = jsonData.stripHtmlTags();
        //String finalData = jsonWithoutHtml;
        String finalData = jsonWithoutHtml.remove('null');
        String jsoDnata1  = finalData.replaceAll('[" ( ) “ ” \' \n ’]' ,' ');
        System.debug('question1==>'+question);

            System.debug('json---'+jsoDnata1);
            Http http = new Http();

            //String payload = '{ model": "text-davinci-003", "prompt": "' + seachQueryEscaped + ' ' + jsonData + '" }';
            String reqBody = '{"model": "text-davinci-003","prompt":"'+jsoDnata1+'.'+question+ '","max_tokens": 700,"temperature": 0,' +'"stream": false,"top_p": 0.5}';
            System.debug('Query '+question+' '+reqBody);
            HttpRequest request = new HttpRequest();
            request.setEndpoint(CHATGPT_API_ENDPOINT);
            request.setMethod('POST');
            request.setHeader('Authorization', 'Bearer '+String.escapeSingleQuotes(CHATGPT_API_KEY).trim());
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
            Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
            System.debug('response'+response.getBody());
            List< Object> choice  = (List< Object>)JSON.deserializeUntyped(JSON.serialize(responseMap.get('choices')));
            Map<String, Object> topchoice  = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(choice[0]));
            //System.debug('choice'+ topchoice.get('text'));
            String answer = JSON.serialize(topchoice.get('text')).replaceAll('\\\\n', '');
            String answer1 = answer.replaceAll('\\d\\:', '\n$0');
            return answer1;
        }catch(Exception ex){
            System.debug('Exception in Catch of Server-Side Controller '+ex);
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
  
             
}