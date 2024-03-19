global class EinsteinTrainingStatusBatch  implements Database.Batchable<sobject>,Database.AllowsCallouts {
    
    /*
* @Author               :
* @Description          : Batch class is used to Create DataSet and train for Einstein Intent.    
* @Created Date         : 07/09/2019 
*/
    
    //Start Method  
    global Database.QueryLocator start (Database.BatchableContext batchContext) { 
        string query = 'select id, Model_Id__c,IsDataSetTrained__c from Einstein_APIs__c  limit 1 '; 
        return Database.getQueryLocator(query);
    }
    
    //Execute Method
    global void execute (Database.BatchableContext batchContext, List<Einstein_APIs__c> scope) { 
        System.debug('status running batch');
        EinsteinHelper ei  = new EinsteinHelper();
        string status = ei.GetDatasetTrainingStatus(scope[0].Model_Id__c);
        
        CronTrigger cr = [SELECT Id, CronJobDetail.Id, CronJobDetail.Name, CronJobDetail.JobType
                          FROM CronTrigger where CronJobDetail.Name = 'EinstienJob' ];
        System.abortJob(cr.Id);
        if(status == 'RUNNING')
        {      
            String nextFireTime = Datetime.now().second() + ' ' + (Datetime.now().minute()+1) + ' ' + Datetime.now().hour() + ' * * ?';        
            EinstienCheckTrainingStatusScheduler obq = new EinstienCheckTrainingStatusScheduler();
            System.schedule('EinstienJob', nextFireTime, obq);             
        }
        else if(status == 'SUCCEEDED')
        {
            Einstein_APIs__c ec =  [select id, Model_Id__c,IsDataSetTrained__c from Einstein_APIs__c  limit 1];
            ec.IsDataSetTrained__c = true;
            System.debug(ec.IsDataSetTrained__c);
            upsert ec;
        }
        
        System.debug(status);
    }
    
    //Finish Method
    global void finish(Database.BatchableContext batchContext){ 
    }
    
}