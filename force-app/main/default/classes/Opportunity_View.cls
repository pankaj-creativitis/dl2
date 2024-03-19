public class Opportunity_View {
    
    public List<Opportunity> opp {get;set;}
    
    public void Opportunity_View(){
        opp= [SELECT Id FROM Opportunity WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
        
    }

}