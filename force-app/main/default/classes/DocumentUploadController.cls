public class DocumentUploadController  
{
	public class DocInfo
	{	
		@AuraEnabled public String label {get; set;}
		@AuraEnabled public Boolean required {get; set;}
		@AuraEnabled public Boolean hasFile {get; set;}
		@AuraEnabled public Boolean hasReview {get; set;}
		@AuraEnabled public Boolean reviewOutcome {get; set;}
		@AuraEnabled public Id attachmentId {get; set;}
		@AuraEnabled public Id documentValidationId {get; set;}
		@AuraEnabled public List<DocCommentInfo> commentList {get; set;}
	}

	public class DocCommentInfo
	{
		@AuraEnabled public String commentText {get; set;}
		@AuraEnabled public String commentTime {get; Set;}
		@AuraEnabled public String userName {get; set;}
	}

	public class ActionReturnType
	{
		@AuraEnabled public Boolean sucess {get; set;}
		@AuraEnabled public String errorMessage {get; set;}
		@AuraEnabled public List<DocInfo> docs {get; set;}
	}

	@AuraEnabled
    public static ActionReturnType handleAction(Id docId, String actionTaken, String commentMsg, Id recordID) 
	{ 
      

		ActionReturnType art = new ActionReturnType();
          // if (Test.isRunningTest()) {
		try
		{	
			if(String.isNotEmpty(commentMsg))
			{
				Document_Validation_Comment__c dvc = new Document_Validation_Comment__c();
				dvc.Comment__c = commentMsg;
				dvc.Document_Validation__c = docId;
				insert dvc;
			}
			if(actionTaken != 'comment')
			{
				Document_Validation__c dv = [SELECT id, Status__c from Document_Validation__c WHERE id = :docId];
				dv.Status__c = actionTaken == 'approve' ? 'Approved' : 'Rejected';
				update dv;
			}
			art.docs = getDocumentTypes(recordID);
			art.sucess = true;
		}
		catch (Exception ex)
		{
			art.sucess = false;
			art.errorMessage = ex.getMessage();
		}
         // }
		return art;
	}

	@AuraEnabled
    public static Id saveTheFile(Id parentId, String fileName, String description, String base64Data, String contentType) 
	{ 
          
		replacementCheckAndCleanUp(parentId, description);

		base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
		Attachment a = new Attachment();
		a.ParentId = parentId;
		a.Body = EncodingUtil.base64Decode(base64Data);
		a.Name = fileName;
		a.ContentType = contentType;
		a.Description = description;                 
		insert a;

		Document_Validation__c dv = new Document_Validation__c();
		dv.Parent_Record_ID__c = parentId;
		dv.Attachment__c = a.Id;
		dv.Status__c = 'Not Reviewed';
		insert dv;
// if (Test.isRunningTest()) {
        /* Update if Opp has all the mandatory records START */
        Boolean breakloop = false;
        String objectName = parentId.getSobjectType().getDescribe().getName();
		String queryString = 'SELECT Id, RecordtypeId, RecordType.name FROM '+objectName+' WHERE Id = \''+parentId+'\'';
		System.debug('queryString '+queryString);
		List<SObject> sobjList = Database.query(queryString);
        
		String recordTypeName = (String)sobjList[0].getSobject('RecordType').get('Name');
        System.debug('recordTypeName '+recordTypeName);
        List<DocInfo> returnList = new List<DocInfo>();
        List<Document_Types__mdt> docTypeList = [SELECT Label, RecordType__c, Required__c FROM Document_Types__mdt 
												 where Object__c = :objectName and RecordType__c = :recordTypeName and
                                                 Required__c = true];
        
		
		List<Document_Validation__c> dvList = [SELECT Id, Attachment__c, Parent_Record_ID__c, Status__c
											   FROM Document_Validation__c
											   WHERE Parent_Record_ID__c = :parentId];
        for(Document_Types__mdt dt : docTypeList)
		{
			DocInfo di = new DocInfo();
			di.hasFile = false;
			di.required = dt.Required__c;
			di.label = dt.Label;
			di.hasReview = false;
			di.commentList = new List<DocCommentInfo>();
			returnList.add(di);
		}
        // TBD: make it generic
        Integer requiredCount = docTypeList.size();
        Integer actualCount = 0;
        Opportunity opp =  (Opportunity) sobjList[0];
        List<Attachment> attachList = [SELECT Description, Id, Name, ParentId FROM Attachment where parentid = :parentId];
        System.debug('attachList '+attachList);
        for( Attachment attach : attachList)
        {
            for(DocInfo di : returnList)
            {
                if(di.label == attach.Description)
                {
                    System.debug('true');
                    di.hasFile = true;
                    actualCount+=1;
                    
                } else {
                    System.debug('false');
                    
                    
                } 
            }
        }
        if(actualCount == requiredCount){
            opp.Mandatory_Documents_Uploaded__c = true;
            update opp;
        }
   //       }
        /* Update if Opp has all the mandatory records END*/
		return a.Id;
	}

	private static void replacementCheckAndCleanUp(Id parentId, String description)
	{
        // if (Test.isRunningTest()) {
		List<Attachment> attachList = [SELECT Description, Id, Name, ParentId FROM Attachment WHERE parentid = :parentId and Description = :description];
		if( !attachList.isEmpty() )
		{
			List<Id> idList = new List<Id>();
			for(Attachment attach : attachList)
			{
				idList.add(attach.id);
			}
			List<Document_Validation__c> dvList = [SELECT id FROM Document_Validation__c WHERE Attachment__c in :idList];
			delete dvList;
			delete attachList;
		}
        //}
	}

	@AuraEnabled
	public static Boolean isUserReviewer()
	{
		return Schema.getGlobalDescribe().get('Document_Validation__c').getDescribe().isUpdateable();
	}
    	@AuraEnabled
	public static Boolean isNotRM()
	{
        id id1 = userinfo.getProfileId();
            if(id1 == '00eS0000000j3hS'){
                return false;
                    } else {
                         return true;
                    }
		// return Schema.getGlobalDescribe().get('Document_Validation__c').getDescribe().isUpdateable();
	}

        @AuraEnabled
    public static String getOppStage(Id recordID) 
    {
    Opportunity opp = [SELECT Id, StageName FROM Opportunity 
                         WHERE Id=:recordID];
        return opp.StageName;
    }
        
	@AuraEnabled
    public static List<DocInfo> getDocumentTypes(Id recordID) 
	{ 

		String objectName = recordID.getSobjectType().getDescribe().getName();
		String queryString = 'SELECT Id, RecordtypeId, RecordType.name FROM '+objectName+' WHERE Id = \''+recordID+'\'';
		System.debug('queryString '+queryString);
		List<SObject> sobjList = Database.query(queryString);
		String recordTypeName = (String)sobjList[0].getSobject('RecordType').get('Name');
        System.debug('recordTypeName >> ' +recordTypeName);
		List<DocInfo> returnList = new List<DocInfo>();
       // if (Test.isRunningTest()) {
		List<Document_Types__mdt> docTypeList = [SELECT Label, RecordType__c, Required__c FROM Document_Types__mdt 
												 where Object__c = :objectName and RecordType__c = :recordTypeName 
												 order by Required__c desc];
		
        System.debug('mdt values >> ' + docTypeList);
		List<Document_Validation__c> dvList = [SELECT Id, Attachment__c, Parent_Record_ID__c, Status__c,
											  (SELECT Id, Comment__c, CreatedBy.Name, createdDate FROM Document_Validation_Comments__r ORDER BY createdDate)
											   FROM Document_Validation__c
											   WHERE Parent_Record_ID__c = :recordID];

        System.debug('dvList values >> ' + dvList);
		for(Document_Types__mdt dt : docTypeList)
		{
			DocInfo di = new DocInfo();
			di.hasFile = false;
			di.required = dt.Required__c;
			di.label = dt.Label;
			di.hasReview = false;
			di.commentList = new List<DocCommentInfo>();
			returnList.add(di);
		}
		List<Attachment> attachList = [SELECT Description, Id, Name, ParentId FROM Attachment where parentid = :recordID];
		for( Attachment attach : attachList)
		{
			for(DocInfo di : returnList)
			{
				if(di.label == attach.Description)
				{
					di.hasFile = true;
					di.attachmentId = attach.Id;
					for(Document_Validation__c dv :dvList)
					{
						if(dv.Attachment__c == attach.id)
						{
							di.documentValidationId = dv.id;
							if(dv.Status__c != 'Not Reviewed')
							{
								di.hasReview = true;
								di.reviewOutcome = dv.Status__c == 'Approved' ? true : false;
							}
							for(Document_Validation_Comment__c dvc : dv.Document_Validation_Comments__r)
							{
								DocCommentInfo dci = new DocCommentInfo();
								dci.commentText = dvc.Comment__c;
								dci.userName = dvc.CreatedBy.Name;
								dci.commentTime = dvc.createdDate.format();
								di.commentList.add(dci);
							}
						}
					}
				}
			}
		}
//}
		System.debug(returnList);
		return returnList;
	}

}