@isTest
private class TestFscBot_PermissionUtils {
      
	static testMethod void testParseJson() {
		String json = '{'+
		'   \"fieldPermissions\": ['+
		'      {'+
		'         \"editable\": \"true\",'+
		'         \"field\": \"Case.Account\",'+
		'         \"readable\": \"true\"'+
		'      }'+
		'   ],'+
		'   \"objectPermissions\": ['+
		'      {'+
		'         \"allowCreate\": \"true\",'+
		'         \"allowDelete\": \"true\",'+
		'         \"allowEdit\": \"true\",'+
		'         \"allowRead\": \"true\",'+
		'         \"modifyAllRecords\": \"true\",'+
		'         \"object\": \"LiveChatTranscript\",'+
		'         \"viewAllRecords\": \"true\"'+
		'      }'+
		'   ]'+
		'}';

		FscBot_PermissionUtils.parseJson(json);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		FscBot_PermissionUtils.ObjectLevelPermissions objObjectPermissions = new FscBot_PermissionUtils.ObjectLevelPermissions(System.JSON.createParser(json));
		System.assert(objObjectPermissions != null);
		System.assert(objObjectPermissions.allowCreate == null);
		System.assert(objObjectPermissions.allowDelete == null);
		System.assert(objObjectPermissions.allowEdit == null);
		System.assert(objObjectPermissions.allowRead == null);
		System.assert(objObjectPermissions.modifyAllRecords == null);
		System.assert(objObjectPermissions.objectName == null);
		System.assert(objObjectPermissions.viewAllRecords == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		FscBot_PermissionUtils.FieldLevelPermissions objFieldPermissions = new FscBot_PermissionUtils.FieldLevelPermissions(System.JSON.createParser(json));
		System.assert(objFieldPermissions != null);
		System.assert(objFieldPermissions.editable == null);
		System.assert(objFieldPermissions.field == null);
		System.assert(objFieldPermissions.readable == null);
       
        
	}
  		static testMethod void testassignObjectAndFieldPermissions(){
                StaticResource sr =new StaticResource();  
                sr.Name ='WordDocumentStencil';          
            	PermissionSet ps = new PermissionSet();
            	ps.Id='0PS2E000001GG2pWAG';
            	System.assert(true);    
                                   
              
         /*   
                FieldPermissions fp = new FieldPermissions();
                fp.ParentId = ps.Id;
                fp.PermissionsRead =true;
                fp.PermissionsEdit =true;       
                fp.SobjectType = 'LiveChatTranscript';
                fp.Field = 'Case.Account' ;
            	insert fp;
                System.assert(true);  
     
             
            	ObjectPermissions op = new ObjectPermissions();
            		op.ParentId = ps.Id;
                  op.PermissionsCreate= true;
                  op.PermissionsDelete=true;
                  op.PermissionsEdit =true;
                  op.PermissionsModifyAllRecords=true;
                  op.PermissionsRead =true;
                  op.PermissionsViewAllRecords= true;
                  op.SobjectType = 'LiveChatTranscript';
            	insert op;
       			System.assert(true);  
          */    
          // FscBot_PermissionUtils.assignObjectAndFieldPermissions(sr.Name,ps.Id);
  
    }
  
}