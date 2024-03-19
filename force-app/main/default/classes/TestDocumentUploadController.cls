@isTest
public class TestDocumentUploadController {
@isTest 
public static void myTest() {
       Test.startTest();
    //DocumentUploadController duc=new DocumentUploadController();
    DocumentUploadController.getDocumentTypes('12345678');
    DocumentUploadController.getOppStage('12345678');
    DocumentUploadController.handleAction('123456', 'actionTaken', 'commentMsg', '12345678');
    
      Test.stopTest();
    }
}