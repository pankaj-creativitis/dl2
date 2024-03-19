@isTest
public class checkCIBILScoreTest {
    @isTest static void checkCIBILScore_Test(){
        PageReference pageRef = Page.Check_CIBIL_Score;
        Test.setCurrentPage(pageRef);
      
        checkCIBILScore cIBILScore = new checkCIBILScore();
      	Opportunity o = new Opportunity(Name='Opportunity Test', StageName='Personal Information', CloseDate=Date.today() + 5);
        insert o;

        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('ObjectId', o.Id);    
        ApexPages.currentPage().getParameters().put('ResponseCode', o.StageName);
        
        // Instantiate a new controller with all parameters in the page
        cIBILScore = new checkCIBILScore(); 
        cIBILScore.ObjectId = o.Id;
        cIBILScore.ResponseCode = o.StageName;
	    cIBILScore.InitPage();    
    }
}