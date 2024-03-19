public without sharing class  checkCIBILScore {
    public String ObjectId {get;set;}
    public String ResponseCode {get;set;}
    public checkCIBILScore () {
        ObjectId = ApexPages.currentPage().getParameters().get('ObjectId');
        ResponseCode = ApexPages.currentPage().getParameters().get('ResponseCode');
    }
    
    public PageReference InitPage() {        
        List<Opportunity> opp = [SELECT Id,StageName FROM Opportunity WHERE id=:ObjectId LIMIT 1];
        if(!opp.IsEmpty()){
            opp[0].StageName = ResponseCode;
            UPDATE opp;
        }
        return null;
    }
}