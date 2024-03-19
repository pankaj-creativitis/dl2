@isTest
private without sharing class OptionsControllerTest {
    
    @testSetup
    private static void testDataSetup() {
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Description = 'Test Description';
        insert acc;
        
        Contact con = new Contact();
        con.FirstName = 'Marco';
        con.LastName = 'Polo';
        con.Email = 'abc@xyz.com';
        con.Phone = '1234567890';
        con.AccountId = acc.Id;
        con.Description = 'Test Contact';
        insert con;
        
        ContentVersion content=new ContentVersion(); 
        content.Title='display@Header_Picture'; 
        content.PathOnClient='/' + content.Title + '.jpg'; 
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
        content.VersionData=bodyBlob; 
        content.origin = 'H';
        insert content;
        
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=acc.id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: content.id].contentdocumentid;
        contentlink.ShareType = 'I';
        contentlink.Visibility = 'AllUsers'; 
        insert contentlink;
    }
    
    private static testMethod void getOptionsTestWithImage(){
        List<OptionsController.optionData> options = new List<OptionsController.optionData>();
        Test.startTest();
        options = OptionsController.getOptions('Name', 'Description', 'Account', 'Test Account', 'Name', true);
        Test.stopTest();
        
        System.assert(options.size()>0);
    }
    
    private static testMethod void getOptionsTestWithoutImage(){
        List<OptionsController.optionData> options = new List<OptionsController.optionData>();
        Test.startTest();
        options = OptionsController.getOptions('Name', 'Description', 'Contact', 'Marco Polo', 'Name', false);
        Test.stopTest();
        
        System.assert(options.size()>0);
    }
    
    private static testMethod void getOptionsFromMetaTest(){
        List<OptionsController.optionData> options = new List<OptionsController.optionData>();
        Test.startTest();
        options = OptionsController.getOptionsFromMeta('City', false);
        Test.stopTest();
        
        System.assert(options.size()>0);
    }
}