public class CreateCaseController {
@AuraEnabled
    public static void createRecordForCase (sObject caseObj, Id usrId){
        
        try{
            System.debug('caseObj===>>'+caseObj);
            
            if(caseObj != null){
                Case cs = new Case();
                cs.Subject = (String)caseObj.get('Subject');
                cs.Description = (String)caseObj.get('Description');
                // cs.ContactId = (String)caseObj.get('ContactId');
                insert cs;
                 // insert (Case)caseObj;
            }
            
        } catch (Exception ex){
            
        }
        
    }    
}