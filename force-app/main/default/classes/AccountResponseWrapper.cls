public class AccountResponseWrapper {

    public List<Content> Content;
    public String statusCode;
    public AccountResponseWrapper() {
        Content = new List<Content>();
    }
    
     public class Content{
        public String type;
        public String sub_type;
        public Decimal balance;
        public String FinAccountNumber;
        
  
        public Content(String FinAccountNumber,String type, String sub_type, Decimal balance){
            this.type = type;
            this.sub_type = sub_type;
            this.balance = balance;
            this.FinAccountNumber=FinAccountNumber;
        }
    }
    
    public static AccountResponseWrapper generateAccountWrapperRecord(List<FinServ__FinancialAccount__c> finAccounts)
    {
         AccountResponseWrapper alertResponse = new AccountResponseWrapper();
        for (FinServ__FinancialAccount__c finAccount : finAccounts)
        {      alertResponse.statusCode ='200';
               alertResponse.Content.add(new Content(finAccount.FinServ__FinancialAccountNumber__c,finAccount.FinServ__FinancialAccountType__c, finAccount.Sub_type__c, finAccount.FinServ__Balance__c));
        		
        }
        return alertResponse;
    }
}