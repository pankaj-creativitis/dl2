public with sharing class EinsteinHelper {
    
    //**** Private variables*******
    private string upload_dataset_Endpoint ='';
    private string get_dataset_Status_Endpoint ='';
    private string training_dataset_Endpoint ='';
    private string get_training_status_Endpoint ='';
    private string auth_token = '';
    private Einstein_APIs__c apiData = null;
    
    //**** Constructor to initialize Private variables*******
    public EinsteinHelper()
    {
        
        apiData =  [select id, Upload_Dataset_Endpoint__c,
                    Dataset_Details_Endpoint__c,
                    Training_Dataset_Endpoint__c,
                    Training_Status_EndPoint__c,
                    Token__c,
                    DataSet_Id__c,
                    Model_Id__c
                    from Einstein_APIs__c  limit 1]; 
        
        this.upload_dataset_Endpoint = apiData.Upload_Dataset_Endpoint__c;
        this.get_dataset_Status_Endpoint = apiData.Dataset_Details_Endpoint__c;
        this.training_dataset_Endpoint = apiData.Training_Dataset_Endpoint__c;
        this.get_training_status_Endpoint = apiData.Training_Status_EndPoint__c;
        this.auth_token = apiData.Token__c;       
    } 
    
    //**** Upload dataset *******
    public String uploadDataset(string filePath) { 
        DataSetReponseDetails response = null;
        map<string,string> params = new map<string,string>();
        try
        {             
            HttpRequest httpReq = buildRequest( 'POST', this.upload_dataset_Endpoint ); 
            params.put('path', filePath );
            params.put('type', 'text-intent' );  
            
            Blob formBlob = EncodingUtil.base64Decode(CreateFormData(params)); 
            httpReq.setBodyAsBlob(formBlob);
            Http http = new Http(); 
            HTTPResponse httpRes = http.send(httpReq);  
            if(httpRes.getBody() !=null || httpRes.getBody() !='')
            {  
                response  = (DataSetReponseDetails)JSON.deserialize( httpRes.getBody(), DataSetReponseDetails.class );  
                System.debug(response);
                if(response !=null && response.statusMsg == 'SUCCEEDED')
                {
                    UpdateEinsteinCustomSetting(response.id,'DATASET_ID');
                    return response.id;
                }
            } 
        }
        catch(Exception ex)
        {
            System.debug(ex.getStackTraceString());
        }
        return null;        
    }
    
    //*** train DataSet. ****
    public String TrainDataset(String datasetId) 
    {  
        system.debug('*** into traindataset');
        TrainDataSetResponse res = null;
        map<string,string> params = new map<string,string>();
        try
        { 
            HttpRequest httpReq = buildRequest( 'POST', 'https://api.einstein.ai/v2/language/train/');  
            params.put('name', 'Data Model - ' + DateTime.now().getTime());
            params.put('datasetId', String.valueOf(datasetId));
            
            Blob formBlob = EncodingUtil.base64Decode(CreateFormData(params)); 
            httpReq.setBodyAsBlob( formBlob ); 
            Http http = new Http(); 
            HTTPResponse httpRes = http.send( httpReq ); 
            if(httpRes.getBody() !=null || httpRes.getBody() !='')
            {
                res = ( TrainDatasetResponse ) JSON.deserialize( httpRes.getBody(), TrainDatasetResponse.class );
                System.debug(res);  
                if(res !=null && res.status == 'QUEUED')
                {
                    system.debug('*** model id' + res.modelId);
                    UpdateEinsteinCustomSetting(res.modelId,'MODEL_ID');
                }
            }
            return res.modelId;
        }
        catch(Exception ex)
        {
            System.debug(ex.getStackTraceString());
        }
        return null; 
    }
    
    public string GetDatasetTrainingStatus( String modelId ) { 
        TrainDataSetResponse response = new TrainDataSetResponse();
        HTTPResponse httpRes = null;
        try { 
            HttpRequest httpReq = buildRequest( 'GET', (this.get_training_status_Endpoint + modelId)); 
            Http http = new Http();  
            httpRes= http.send( httpReq );    
            response = (TrainDataSetResponse) JSON.deserialize(httpRes.getBody(), TrainDataSetResponse.class );
            system.debug('****' + response);    
        }
        catch( Exception ex ) { 
        }
        return response.status;
    }
    
    //*** Update DataSet Id to metadata.
    private void UpdateEinsteinCustomSetting (string id, string key)
    {         
        if(id != null || id != '')
        {
            if(key.toUpperCase() == 'MODEL_ID')
                apiData.Model_Id__c= id; 
            if(key.toUpperCase() == 'DATASET_ID')
                apiData.DataSet_Id__c= id;  
            
            upsert apiData;
            
        }
    }
    
    //**** Create Multipart form Data.
    private string CreateFormData(map<string,string> objs)
    {
        string mutipartFormData ='';
        for(String key:objs.keySet())
        {  
            mutipartFormData += EinsteinFormBuilder.WriteBoundary();
            mutipartFormData += EinsteinFormBuilder.WriteBodyParameter( key, objs.get(key) );  
        }    
        mutipartFormData += EinsteinFormBuilder.WriteBoundary( NULL );  
        return mutipartFormData;
    }
    
    //** Build request for upload dataSet.
    private HttpRequest buildRequest( String method, String endpoint ) { 
        HttpRequest httpReq = new HttpRequest(); 
        httpReq.setMethod( method );
        httpReq.setEndpoint( endpoint );  
        httpReq.setHeader( 'Authorization', 'Bearer '+ this.auth_token); 
        httpReq.setHeader( 'Cache-Control', 'no-cache' ); 
        httpReq.setHeader( 'Content-Type',  EinsteinFormBuilder.GetContentType() ); 
        return httpReq;
    }
}