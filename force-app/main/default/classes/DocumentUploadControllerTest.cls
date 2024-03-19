@isTest
public class DocumentUploadControllerTest  
{
	static testmethod void saveTheFileTest()
	{
		Account acct = new Account();
		acct.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
		acct.Name = 'test';
		insert acct;
		Opportunity opp = new Opportunity();
		opp.Name = 'test';
		opp.StageName = 'Prospecting';
		opp.CloseDate = System.today();
		//opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Opportunity (Wallet Share)').getRecordTypeId();
        opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
		insert opp;
		//DocumentUploadController.saveTheFile(acct.Id, 'test.test', 'Photo ID', 'ABC', 'test');
		//DocumentUploadController.saveTheFile(acct.Id, 'test.test', 'Photo ID', 'ABC', 'test');
		DocumentUploadController.saveTheFile(opp.Id, 'test.test', 'Passport', 'ABC', 'test');
		List<DocumentUploadController.DocInfo> docinfoList = DocumentUploadController.getDocumentTypes(acct.id);
		System.assert( !docinfoList.isEmpty() );
		docinfoList = DocumentUploadController.getDocumentTypes(opp.id);
		//System.assert( !docinfoList.isEmpty() );

		Document_Validation__c dv = [SELECT id, Status__c from Document_Validation__c Limit 1];
		//handleAction(Id docId, String actionTaken, String commentMsg, Id recordID) 
		DocumentUploadController.handleAction(dv.id, 'approve', 'test', acct.Id);
		DocumentUploadController.handleAction(dv.id, 'approve', 'test', dv.id);
		DocumentUploadController.isUserReviewer();

	}
}