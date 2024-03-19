public class EinstenHelper {
    public String DataSet_endpoint = 'https://api.einstein.ai/v2/language/datasets/upload/sync';
    private final static string Boundary = '1ff13444ed8140c7a32fc4e6451aa76d';
    
    public void uploadDataset() { 
        //Document doc =  [SELECT Id, Body,name FROM Document where name='EinstenDataSet']; 
        HttpRequest httpReq = buildRequest( 'POST', DataSet_endpoint ); 
        String mutipartFormData = ''; 
        mutipartFormData += WriteBoundary(); 
        mutipartFormData += WriteBodyParameter( 'path', 'https://lexpsl--dev2--c.documentforce.com/sfc/dist/version/download/?oid=00DS0000003OU24&ids=068S0000000arX6&d=%2Fa%2FS0000000CpTr%2FTb8MP_SYbizUxvHfTFXc8EuHHtn8kdyZjjW9MTzGKa8&asPdf=false');    
        mutipartFormData += WriteBoundary();
        mutipartFormData += WriteBodyParameter( 'type', 'text-intent' ); 
        mutipartFormData += WriteBoundary();
        mutipartFormData += WriteBodyParameter( 'name', 'testing' );
        mutipartFormData += WriteBoundary( NULL );  
        Blob formBlob = EncodingUtil.base64Decode( mutipartFormData ); 
        httpReq.setBodyAsBlob( formBlob );
        Http http = new Http(); 
        HTTPResponse httpRes = http.send( httpReq );
        System.debug(httpRes.getBody());
    }
    
   
    public HttpRequest buildRequest( String method, String endpoint ) {
        HttpRequest httpReq = new HttpRequest(); 
        httpReq.setMethod( method );
        httpReq.setEndpoint( endpoint );  
        httpReq.setHeader( 'Authorization', 'Bearer Y6SEJZQHYU6FUS5O7QGHEYP6V3ZV64TJ5UOIBARKPANKELE776T4A54HIGCMAVIIG6TBUWNU4RFKEPHTFNXWTXFQPIB3H3FMMJASQ4Q'); 
        httpReq.setHeader( 'Cache-Control', 'no-cache' ); 
        httpReq.setHeader( 'Content-Type',  'multipart/form-data; charset="UTF-8"; boundary="1ff13444ed8140c7a32fc4e6451aa76d"'); 
        return httpReq;
    }
    
    public static string WriteBodyParameter(string key, string value) {
        string contentDisposition = 'Content-Disposition: form-data; name="' + key + '"';
        System.debug(contentDisposition);
        string contentDispositionCrLf = contentDisposition + '\r\n\r\n';
        blob contentDispositionCrLfBlob = blob.valueOf(contentDispositionCrLf);
        string contentDispositionCrLf64 = EncodingUtil.base64Encode(contentDispositionCrLfBlob);
        string content = SafelyPad(contentDisposition, contentDispositionCrLf64, '\r\n\r\n');
        string valueCrLf = value + '\r\n';
        blob valueCrLfBlob = blob.valueOf(valueCrLf);
        string valueCrLf64 = EncodingUtil.base64Encode(valueCrLfBlob);
        
        content += SafelyPad(value, valueCrLf64, '\r\n');
        
        return content;
    }
    
    private static string SafelyPad(  string value, string valueCrLf64, string lineBreaks) {
        string valueCrLf = '';
        blob valueCrLfBlob = null;
        
        while (valueCrLf64.endsWith('=')) {
            value += ' ';
            valueCrLf = value + lineBreaks;
            valueCrLfBlob = blob.valueOf(valueCrLf);
            valueCrLf64 = EncodingUtil.base64Encode(valueCrLfBlob);
        }
        
        return valueCrLf64;
    }    
    
    public static string WriteBoundary() {
        string value = '--' + Boundary + '\r\n';
        blob valueBlob = blob.valueOf(value);        
        return EncodingUtil.base64Encode(valueBlob);
    } 
    public static string WriteBoundary(
        EndingType ending) {
            string value = '';
            
            if (ending == EndingType.Cr) { 
                value += '\n';
            } else if (ending == EndingType.None) { 
                value += '\r\n';
            } 
            value += '--' + Boundary + '--';            
            blob valueBlob = blob.valueOf(value);            
            return EncodingUtil.base64Encode(valueBlob);
        }
    
    public enum EndingType {
        Cr,
            CrLf,
            None
            }
}