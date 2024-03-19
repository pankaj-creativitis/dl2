public class WebmergeBulkRecordProcessed 
{

    public static void goRecordsToProcess(Id accountId)
    {
        try{
            List <id> recordsIds = new List <id>();
            system.debug('accountId is'+accountId);
            for(Account acc : [Select Id,personbirthdate,personemail from Account where Id =:accountId]){
            recordsIds.add(acc.id);
        }
    
            if(!recordsIds.isEmpty()){
                system.debug('recordsIds.id'+recordsIds);
                webm.WebmergeGenerator.generateDocumentBatchJS('a2IS0000000U12hMAC',recordsIds,'Account');
                
    					}
    		} 
        catch(Exception e)
        {
    		System.debug('Exception type caught: ' + e.getTypeName()); 
            System.debug('Message: ' + e.getMessage()); 
            System.debug('Line number: ' + e.getLineNumber());
        }
    }

    
}