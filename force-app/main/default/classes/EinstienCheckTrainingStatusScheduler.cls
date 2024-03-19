global class EinstienCheckTrainingStatusScheduler implements Schedulable {
    
    global void execute(SchedulableContext SC)
    {
        System.debug('scheduler');
        EinsteinTrainingStatusBatch ob = new EinsteinTrainingStatusBatch();
        database.executeBatch(ob);
    } 
}