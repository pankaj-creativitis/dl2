public class uniteddigitalbank {
   public List<Account> accounts {get; private set;}
    
   public uniteddigitalbank(){
        this.accounts = [Select Id, Name, (Select Id, FirstName, LastName, MailingCity, MailingState from Contacts) From Account LIMIT 10];
   
   
  }

}