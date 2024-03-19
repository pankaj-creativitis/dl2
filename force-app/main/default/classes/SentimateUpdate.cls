public class SentimateUpdate {
    
    @auraEnabled
    Public static Boolean updateSentimentValues(List<sentimentWrapper> sentWrap){
        ContentDocument conDoc = [select id from ContentDocument where Title='basic_intents'];
        ContentVersion conVer = [select versionData from ContentVersion where ContentDocumentId =: conDoc.id 
                                 and isLatest = true];
        String data = conVer.versionData.toString();
        
        ContentVersion newVersion = new ContentVersion();
        newVersion.ContentDocumentId = conDoc.id;
        for(sentimentWrapper sentimentObj : sentWrap){
        	if(!data.contains(',')){
	            data = null;
	            data = sentimentObj.sentimentText+ ','+sentimentObj.sentimentType+'\n';
        	}else{
        		data = data + sentimentObj.sentimentText+ ','+sentimentObj.sentimentType+'\n';
        	}
        }
        newVersion.versionData = Blob.valueOf(data);
        newVersion.PathonClient = 'basic_intents.csv';
        insert newVersion;
        return true;
        
    }
    
    @AuraEnabled
    public static String startTraining(){
    	system.debug('*****startTraining');
    	List<ContentDocument> conDocList = [Select id from ContentDocument where title = 'basic_intents'];
    	if(conDocList != null && conDocList.size()>0){
    		List<ContentDistribution> conDistributeList = [SELECT ContentDownloadUrl,Name 
    														FROM ContentDistribution 
    														where ContentDocumentId =: conDocList[0].id];
    														
    		if(conDistributeList != null && conDistributeList.size() > 0){
	    		EinsteinHelper eh =  new EinsteinHelper();
	            system.debug('*****uploading dataset');
	            return eh.uploadDataset(conDistributeList[0].ContentDownloadUrl);
    		}
    	}
    	
    	return null;    	
    	
    }
    
    @AuraEnabled
    public static String trainDataset(){
    	Einstein_APIs__c apiData = [select DataSet_Id__c from Einstein_APIs__c limit 1]; 
       	EinsteinHelper eh =  new EinsteinHelper();
       	return eh.TrainDataset(apiData.DataSet_Id__c);	
    }
    
    @auraEnabled
    public static String trainingStatusMethod(String modelID){
       	EinsteinHelper eh =  new EinsteinHelper();
       	String trainingStatus = eh.GetDatasetTrainingStatus(modelID);
       	return trainingStatus;
    }
    
    
    Public class sentimentWrapper{
        
        @auraEnabled public String sentimentText {get;set;}
        @auraEnabled public String sentimentType {get;set;}
        public sentimentWrapper()
        {
            
        }
        public sentimentWrapper(String sentimentText ,String sentimentType){
            this.sentimentText =sentimentText;
            this.sentimentType =sentimentType;
        }
        
    }
    
    
}