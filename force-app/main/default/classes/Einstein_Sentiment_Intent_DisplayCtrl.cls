public without sharing class Einstein_Sentiment_Intent_DisplayCtrl {
	
	@AuraEnabled
	public static List<EinsteinCalloutWrapper.EinsteinCalloutProbablityWrapper> fetchIntentDetails(String recId){
		
		try{
			List<EinsteinCalloutWrapper.EinsteinCalloutProbablityWrapper> firstThreeProbList = 
				new List<EinsteinCalloutWrapper.EinsteinCalloutProbablityWrapper>();  
			
			List<Case> caseRecList = [Select Einstein_Intent_Response__c from Case where id =: recId];
			if(caseRecList != null && caseRecList.size() > 0){

                EinsteinCalloutWrapper.EinsteinCalloutResponseWrapper eioo = (EinsteinCalloutWrapper.EinsteinCalloutResponseWrapper)
                    JSON.deserialize(caseRecList[0].Einstein_Intent_Response__c, 
                        EinsteinCalloutWrapper.EinsteinCalloutResponseWrapper.class);
                
                for(Integer i=0; i<=2; i++ ){
                	firstThreeProbList.add(eioo.probabilities[i]);			    
                }
                
                system.debug('***' + firstThreeProbList);
                
				return firstThreeProbList;
			}
		}
		catch(Exception ex){
			system.debug('****' + ex.getMessage());
		}
        
        return null;	
		
	}
    
}