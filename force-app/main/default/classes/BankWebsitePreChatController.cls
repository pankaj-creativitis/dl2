public class BankWebsitePreChatController {
  //--------------------------------------------------------------------
  // Properties
  public Lead theLead { get; private set; }
  public String endpoint { get; private set; }
  public String jsSubmitForm { get; set; }
  
  //--------------------------------------------------------------------
  // Methods
  public BankWebsitePreChatController() {
    jsSubmitForm = '';             
    theLead = new Lead();
    
    // get the querystring data passed in by the button.  This is the liveagent form action
    // EX: ?endpoint=https%3A%2F%2F1.la1a1.salesforceliveagent.com... etc..
    endpoint = '';
    PageReference pageRef = ApexPages.currentPage();
    if (pageRef.getParameters() != null) {
      if (pageRef.getParameters().containsKey('endpoint')) {
        if (pageRef.getParameters().get('endpoint') != null) {
          endpoint = pageRef.getParameters().get('endpoint');
        }
      }           
    }       
  }

  public void clickChat() {            
    theLead.LeadSource = 'Live Chat';
    insert theLead;    
    
    jsSubmitForm = 'jQuery(\'#prechatForm\').submit();'; 
  }
}