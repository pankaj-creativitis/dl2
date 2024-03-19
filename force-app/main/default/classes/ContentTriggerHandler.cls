public  class ContentTriggerHandler {

   
    public static void invokeEndpoint(ContentVersion idVersion,ContentVersion selfieVersion )
    {       
        HttpRequest http = new HttpRequest();
        /*for (ContentVersion contvers : contentVersionData)
    	{*/
             //data = EncodingUtil.base64Decode(contvers.VersionData.toString()).toString();
            //data = EncodingUtil.base64Encode(contvers.VersionData);
            String idVersionData = EncodingUtil.base64Encode(idVersion.VersionData);
            String selfieVersionData = EncodingUtil.base64Encode(selfieVersion.VersionData);
            sendRequest(idVersionData, selfieVersionData);
    	//}
    }
     @future (callout=true)
    private static void sendRequest(String idImage, String selfieImage)
    {
         HttpRequest request = new HttpRequest();
         String jsonStr ='';
             request.setEndpoint('https://stg-tenant1.persistentdigitalbank.tk/authservice/identitymindkyc');
             request.setMethod('POST');
             request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            List<ContentWrapper> conWrapList = new List<ContentWrapper>();
            ContentWrapper contWrapper = new ContentWrapper();
            contWrapper.onlineId = '23456';
            contWrapper.accountName = 'persistent';
            contWrapper.docCountry='US';
            contWrapper.docType='DL';
            contWrapper.docImage=idImage;
            contWrapper.selfieimage=selfieImage;
            conWrapList.add(contWrapper);
            jsonStr = JSON.serialize(conWrapList);
            request.setBody(jsonStr);
           List<StubResponse> stubResponses = new List<StubResponse>();
            StubResponse stub = createStubResponse();
            stubResponses.add(stub);
            String response = JSON.serialize(stubResponses); 
           System.debug('Response################'+response);      
           /* Http httpReq = new Http();
           HTTPResponse response;
            HTTPResponse response = httpReq.send(request);
            
        	System.debug('\nrequest'+request);*/
            List<APILogResponse__c> apiRespList = new List<APILogResponse__c>();
            APILogResponse__c apiResponse = new APILogResponse__c();
            //apiResponse.request__c = jsonStr;
            apiResponse.response__c = response;
            //apiResponse.response__c = response.getBody();
            apiRespList.add(apiResponse);
            insert apiRespList;
           /* System.debug('Response'+response.getBody() +'\n******');
            System.debug('\n******'+jsonStr +'\n******');*/
    }
    
    private static StubResponse createStubResponse()
    {
         String status ='success';
         String responseCode ='200';
         String message = 'Document Verification successful';
         String firstName = 'Christopher';
         String surName = 'Sample';
         String fullName = 'Christopher Sample';
         String address = 'Lake View,New Rd, Prime Colony ,NYC,USA';
         String documentNumber = '902383';
         String dob = '05-10-1986';
         String issueDate = '05-10-2011';
         String expirationDate = '05-10-2012';
         String name='NASBA';
         String value ='NASBA';
         String type='NASBA';
         String country ='United States';
        String state ='NYC';
        DocumentData documentData = new DocumentData(firstName, surName, fullName, address, documentNumber, dob, 
                        issueDate, expirationDate);
        Decision decision = new Decision(name, value);
        DocumentType documentType = new DocumentType(type, country, state);
        Data data = new Data(documentType, decision, documentData);
        StubResponse stub = new StubResponse(status, data, responsecode, message);
        return stub;
    }
    public class contentWrapper{
        public String onlineId {get;set;}
        public String accountName {get;set;}
        public String docCountry {get;set;}
        public String docType {get;set;}
        public String docImage {get;set;}
        public String selfieimage {get;set;}	
    }
    
    public class StubResponse
    {
        private String status;
        private Data data;
        private String responseCode;
        private String message;
        public StubResponse(String status, Data data, String responsecode, String message)
            {
                this.status = status;
                this.data = data;
                this.responseCode = responseCode;
                this.message = message;
            }
    }
    
        public class Data
        {
            private DocumentType documentType;
            private Decision decision;
            private DocumentData documentData;
            
            public Data(DocumentType documentType, Decision decision, DocumentData documentData)
            {
                this.documentType = documentType;
                this.decision = decision;
                this.documentData = documentData;
            }
        }
    
        public class DocumentType
        {
            
            private String type;
            private String country;
            private String state;
            
            public DocumentType(String type, String country, String state)
            {
                this.type = type;
                this.country= country;
                this.state=state;
            }
        }
        
        public class Decision
        {
            private String name;
            private String value;
            
            public Decision(String name, String value)
            {
                this.name = name;
                this.value= value;
            }
        }
     
        public class DocumentData
        {
           private String firstName;
           private String surName;
           private String fullName; 
           private String address;
           private String documentNumber;
           private String dob;
           private String issueDate;
           private String expirationDate;
            
            DocumentData(String firstName, String surName, String fullName, String address, String documentNumber, String dob, 
                        String issueDate, String expirationDate)
            {
                this.firstName = firstName;
                this.surName = surName;
                this.fullName = fullName;
                this.address = address;
                this.documentNumber = documentNumber;
                this.dob = dob;
                this.issueDate = issueDate;
                this.expirationDate = expirationDate;
            }
        }
    
    }