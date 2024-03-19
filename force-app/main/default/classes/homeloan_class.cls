public class homeloan_class {
 /*   public string accid {get;set;}
    public string usrid {get;set;}
    public  Contact con {get;set;}
    public Decimal abc {get;set;}
    public  User usr {get;set;}
    public  Opportunity opp {get;set;}
    public string formattedDate {get;set;}
    public homeloan_class(Opportunity opp)
    {
        list<opportunity> acc=[select accountid,ownerid, Loan_Sanction_Date__c, Approved_Loan_Amount__c, Approved_ROI__c, Approved_Tenure__c,recordtype.name from opportunity where id=:opp.Id limit 1];
        if(acc.size()>0){
            system.debug('accid'+acc[0].accountid);
            opp=acc[0];
            abc=opp.Approved_Loan_Amount__c/opp.Approved_Tenure__c;
            accid=opp.accountid;
            usrid=opp.ownerid;
            Date d =  Date.valueof(opp.Loan_Sanction_Date__c);
            formattedDate = DateTime.newInstance(d.year(),d.month(),d.day()).format('d-MM-YYYY');
            con=[select name,MobilePhone,email,MailingCity,MailingCountry,MailingState,MailingPostalcode  from contact where accountid=:accid limit 1][0];
            usr=[select name from user where id=:usrid limit 1][0];
        }
    }
  */  
}