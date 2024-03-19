public with sharing class GetDateTime {
    @AuraEnabled(cacheable=true)
   public static  DateTime getData(Id recordId)
   {
        List<Lead> ls=new List<Lead>([select Id,CreatedDate from Lead where Id=:recordId]);
        System.debug('Apex class test ' +ls);
        DateTime id1;
        for(Lead l:ls){
            id1=l.CreatedDate;
        }
        DateTime check=id1.addDays(3);
        Long gettime = id1.getTime();
        System.debug('Miliseconds time '+gettime);
        System.debug('nishi '+check);
        return check;    
    }
}