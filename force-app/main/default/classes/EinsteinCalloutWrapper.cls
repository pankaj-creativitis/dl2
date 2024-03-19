public class EinsteinCalloutWrapper {
    public String modelId;
    public string document;
    
    public EinsteinCalloutWrapper(String modelId, String desp){
        this.modelId = modelId;
        this.document = desp;
    }
    
    public class EinsteinCalloutResponseWrapper{
        @AuraEnabled
        public List<EinsteinCalloutProbablityWrapper> probabilities;
        public String object_x;
    }
    
    
    public class EinsteinCalloutProbablityWrapper{
        @AuraEnabled
        public String label;
        @AuraEnabled
        public Decimal probability;
    }
}