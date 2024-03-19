@isTest
public class ContentDocumentHelperTest {
   
    
    @isTest static void getDocumentDataContent_Test(){
       
        List<ContentVersion> conver = new List<ContentVersion>();
         for(Integer i=0; i<10; i++){
        ContentVersion cv=new Contentversion(title='ABC', 
                                             PathOnClient = 'test.jpg', 
                                             versiondata = EncodingUtil.base64Decode('Unit Test Attachment Body'));
         conver.add(cv);
         }
        insert conver;    
        
   		List<id> contIds = new List<id>();
        for(ContentVersion conv:conver){
            contIds.add(conv.Id);
        }
    
   
        List<Lead> leads = new List<Lead>();
         for(Integer i=0; i<10; i++){
        Lead lead = new Lead(Aadhar_Number__c='12345678924',city='TestCity',LastName='TestLead',Year_Of_Birth__c=String.ValueOf(Date.today()-10585));
        leads.add(lead);
         }
          insert leads;	
        List<id> leadIds = new List<id>();
        for(Lead ld:leads){
            leadIds.add(ld.Id);
        }
        
        Test.startTest();
		Test.setMock(HttpCalloutMock.class, new ContentDocumentHelperMock()); // Takes two arguments
		// ContentDocumentHelper.getDocumentData(conver.Id,leads.Id);
		Test.stopTest();
    }
    
}