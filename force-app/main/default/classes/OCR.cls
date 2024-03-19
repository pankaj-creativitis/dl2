public class OCR {
    @Future(callout=true)
     public static void getDocumentData(Id attId, Id assetId){
        Attachment vd = [SELECT Id, body FROM Attachment WHERE Id = :attId];
                
                String base64Str = EncodingUtil.base64Encode(vd.body);
            system.debug('base64Str >> ' + base64Str);
        
        // construct JSON body
        /*
{
  "requests": [
    {
      "image": {
        "content": "/9j/7QBEUGhvdG9zaG9...base64-encoded-image-content...fXNWzvDEeYxxxzj/Coa6Bax//Z"
      },
      "features": [
        {
          "type": "DOCUMENT_TEXT_DETECTION"
        }
      ]
    }
  ]
}
*/
        String requestBody = '{"requests": [{"image": {"content": "' + base64Str + '"},"features": [{"type": "TEXT_DETECTION"}]}]}';

       // System.debug( JSON.serialize( new OCRRequestBody('requests', 10, new List<Integer>{10, 12, 15}, new Cl2('myObj'))));
        
        // String b64String = EncodingUtil.base64Encode(file);		
            Http http = new Http();	 
            HttpRequest  request = new HttpRequest();
            request.setMethod('POST');	     
            request.setHeader('Content-Length', '2000');
            request.setHeader('Content-Type', 'application/json');             
            request.setEndpoint('https://vision.googleapis.com/v1/images:annotate?key=AIzaSyBvtDGgRST5lIXvASl-106i5sBzqh82l2o');	        
                 
            request.setBody(requestBody);	        
            HttpResponse response = http.send(request);	        
            String imagetext= response.getBody();
         // System.debug('imagetext <<<>>> ' +imagetext);
        JSONParser parser = JSON.createParser(response.getBody());
         String serialNumber;
         String productCode;
        String descr;
        while (parser.nextToken() != null) {
           
            
            
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                (parser.getText() == 'description')) {
                    
                    parser.nextToken();
                    System.debug(parser.getText());
                    descr = parser.getText();
                    break;
            }
 
        }
         
        String[] arrDesc = descr.split('\\n');
        for(Integer i=0;i<arrDesc.size();i++){
            system.debug(i + '****' + arrDesc[i]);
            if(i==1){
                serialNumber = arrDesc[i];
            } else if (i==3){
                productCode = arrDesc[i];
            }
        }
         if(serialNumber==null){
             serialNumber='163004260USC';
             
         }
         if(productCode==null){
             productCode='BES870';
             
         }
         Product2 pr = [Select Id, ProductCode from Product2 where ProductCode = :productCode];
            Asset ast = [Select Id, Name, SerialNumber, Product2Id from Asset where Id = :assetId];
         serialNumber = serialNumber.replace('O', '0');
         serialNumber = serialNumber.replace('o', '0');
         ast.Product2Id = pr.Id;
         
         ast.SerialNumber = serialNumber;
         // ast.ProductCode = pr.ProductCode;
         update ast;
            /*
            //Fetching the assignment rules on Lead
            AssignmentRule AR = new AssignmentRule();
			AR = [select id from AssignmentRule where SobjectType = 'Lead' and Active = true limit 1];
            
            //Creating the DMLOptions for "Assign using active assignment rules" checkbox
            Database.DMLOptions dmlOpts = new Database.DMLOptions();
			dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;


            Lead ld = [Select Id,OwnerId, Name, Aadhar_Number__c,city,LastName,Year_Of_Birth__c from Lead where Id = : assetId];
            ld.OwnerId = UserInfo.getUserId();         
            ld.FirstName = '';
            ld.LastName =arrDesc[3];
            String YOB = arrDesc[4];
            ld.Year_Of_Birth__c = YOB.right(4);
            ld.Aadhar_Number__c = arrDesc[6];
  			System.debug('Update lead');
            String address = arrDesc[20]+arrDesc[21]+arrDesc[22]+arrDesc[23]+arrDesc[24];
            System.debug('Address***'+address);
            Set<String> addr = new Set<string>{'Meerut','Pune','Bhopal'};
            
            List<String> addrSplit = address.split(',');
            System.debug('addrSplit'+addrSplit);
            for(String s : addrSplit){
                if(addr.contains(s)){
                    System.debug('Inside if'+s);
                    ld.City = s;
                    break;
                }
            }
            ld.setOptions(dmlOpts);  
            update ld;
*/
        
         
    }

}