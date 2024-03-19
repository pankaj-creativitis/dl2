public without sharing class OpportunityHelper {
    
    //to be deleted
    @AuraEnabled
    public static List<RecordMetadata> getRecordMetadata(String recId) {
        //  Opportunity opp = [SELECT Id, Account.FinServ__PrimaryContact__c,Account.Name,Account.Id, Name,StageName,recordTypeID,RecordType.Name
        //                      FROM Opportunity
        //                      WHERE Id = :recId];
        Opportunity opp = [SELECT Id,Name,StageName,recordTypeID,RecordType.Name, AccountId
                           FROM Opportunity
                           WHERE Id = :recId];
       
        Detail_View_Configuration__mdt[] viewMappings = [SELECT Sections__c, Parent_Field__c FROM Detail_View_Configuration__mdt
                                                         WHERE Object_Name__c='Opportunity' AND Record_Type__c=:opp.RecordType.Name
                                                         AND Stage__c=:opp.StageName];
        
        String recordId = recId;
        // For loop here for each Detail_View_Configuration__mdt on that stage
        List<RecordMetadata> rmdList = new List<RecordMetadata>();    
        for(Detail_View_Configuration__mdt viewMap:viewMappings){
            String pField = viewMap.Parent_Field__c;
            String objType;
            Id parentId;
            
            if(pField != null && pField !=''){
                
                system.debug('pField >> ' + pField);
                List<Opportunity> oppList = (List<Opportunity>) Database.query('SELECT Id,' + pField +' FROM Opportunity WHERE Id = :recordId');
                
                if(pField.contains('.')){
                    String[] fldArray = pField.split('\\.');
                    parentId = (Id)oppList[0].getSObject(fldArray[0]).get(fldArray[1]);
                } else {
                    parentId = (Id)oppList[0].get(pField);
                }
                
                system.debug('parentId >> ' + parentId);
                objType = String.valueOf(parentId.getsobjecttype());
                system.debug('objType >> ' + objType);
            } else {
                parentId = recId;
                objType = 'Opportunity';
            }
            
            RecordMetadata rmd = new RecordMetadata();
            rmd.objName = objType;
            rmd.objId = parentId;
            List<Section> sections = (List<Section>)JSON.deserialize(viewMap.Sections__c, List<Section>.class);
            rmd.sections = sections;
            rmdList.add(rmd);
            // rmd.sections = viewMappings[0].Sections__c;
        }
        system.debug('rmdList >>> ' + rmdList);
        return rmdList;
    }
    
    public class RecordMetadata{            
        @AuraEnabled public String objName { get;set;}
        @AuraEnabled public String objId { get;set;}
        @AuraEnabled public List<Section> sections { get;set;}
    }
    
    public class Section{            
        @AuraEnabled public String sectionName { get;set;}
        @AuraEnabled public String[] flds { get;set;}
    }
    
    @AuraEnabled
    public static List<Verification_Detail__c> getVerificationRecordMetadata(Opportunity opp){   
        
        System.debug('opportunity=====>'+opp);			
        Opportunity oppty = [SELECT Id, Name, AccountId,Account.FinServ__PrimaryContact__c, StageName, recordTypeID, RecordType.Name FROM Opportunity where Id=:opp.Id 
                             and RecordType.Name IN ('Home Loan', 'Business Loan')];         	
        
        List<Case> cs = [SELECT Id, AccountId FROM Case 
                         WHERE AccountId=:oppty.AccountId AND Opportunity_Id__c=:oppty.Id];
        System.debug('oppty=====>'+oppty);         	
        System.debug('RecordType.Name=====>'+oppty.RecordType.Name);
        if(cs.size()==0){
            Verification_Tasks__mdt[] viewTaskMappings = [SELECT Verification_Task_Description__c, Label, Mandatory__c,
                                                          Verification_Object__r.Verification_Object__c
                                                          FROM Verification_Tasks__mdt 
                                                          WHERE Verification_Object__r.Verification_Object__c='Opportunity'
                                                          AND Verification_Object__r.Rec_Type__c=:oppty.RecordType.Name];
            
            System.debug('viewTaskMappings======>'+viewTaskMappings);
            
            List<Task> tskList = new List<Task>(); 
            // List<Case> cList = new List<Case>();
            for(Verification_Tasks__mdt viewTaskMap : viewTaskMappings){ 
                Case c = new Case();
                c.Subject = viewTaskMap.Label;
                c.Description = viewTaskMap.Verification_Task_Description__c;
                c.AccountId = oppty.AccountId;
                c.Opportunity_Id__c = oppty.Id;
                c.EntitlementId = '550S0000000UfSyIAK';
                c.RecordTypeId ='012S0000001cvyBIAQ';
                c.Origin = 'Application';
                // c.OwnerId = '005S000000Gv04d';
                c.OwnerId = '005S000000HJap6';
                
                c.EntitlementId = '550S0000000RK8bIAG';
                if(oppty.Account.FinServ__PrimaryContact__c != null){
                    c.ContactId = oppty.Account.FinServ__PrimaryContact__c;
                }
                
                insert c;
                
				/*
                Task t = new Task();
                t.Subject = viewTaskMap.Label;
                t.Description = viewTaskMap.Verification_Task_Description__c;
                t.WhatId = c.Id;
                insert t;
                */
            }
        }
        
        
        return null;        
        /* to be mplemented later
List<Verification_Detail__c> vdcList = new List<Verification_Detail__c>(); 

for(Verification_Tasks__mdt viewTaskMap : viewTaskMappings){           

Verification_Detail__c vdc = new Verification_Detail__c();
vdc.Mandatory__c= viewTaskMap.Mandatory__c;
vdc.Task_Description__c = viewTaskMap.Verification_Task_Description__c;
vdc.Task_Name__c = viewTaskMap.Label;     
vdc.Opportunity__c = oppty.Id;
vdcList.add(vdc);
}      
insert vdcList;
return vdcList;
*/
    }    
    
    @InvocableMethod
    public static void checkParentCases(List<String> oppIds) {
        System.debug('invocable method >> ' + oppIds);
        for(String oppId: oppIds){
            Boolean changeStage = false;
            List<Case> cases = [SELECT id, Status, Opportunity_Id__c FROM Case WHERE Opportunity_Id__c = :oppId];
            System.debug('cases >> ' + cases);
            changeStage = true;
            for(Case c: cases){                
                if(c.Status != 'Closed'){
                    changeStage = false;
                }
            }
            
            if(changeStage){
                Opportunity opp = [SELECT id, StageName FROM Opportunity WHERE Id = :oppId];
                opp.StageName = 'Document Review';
                update opp;
            }
            
            
        }
        
    }
    
    @AuraEnabled 
    public static EMI_Bounce__c checkEMIBounce(String recId){   
        
        Opportunity opp = [SELECT Id,AccountId,StageName,recordTypeID,RecordType.Name
                           FROM Opportunity
                           WHERE Id = :recId];
        List<EMI_Bounce__c> emiBounceList = [SELECT Id, Name, EMI_Bounced__c
                                             FROM EMI_Bounce__c
                                             WHERE Opportunity__r.Id = :recId] ;
        EMI_Bounce__c emiB;
        if(emiBounceList.size()!=0){
            emiB = emiBounceList[0];
            if(emiB.EMI_Bounced__c){
                Case c = new Case(Subject='EMI Bounced');
                c.AccountId = opp.AccountId;
                c.OwnerId = '005S000000Gv0rR';
                insert c;
            }
        }   
        return emiB;
    }
    
    public static String processUnderwriting(String recId){
        
        String scoreCard = '';
        /*
        Opportunity opp = [SELECT Id,AccountId
                           FROM Opportunity
                           WHERE Id = :recId];
        Account acc = [SELECT Id, DTI_Ratio__c, FinServ__CreditScore__c FROM Account
                       WHERE Id = :opp.AccountId];
        system.debug('in Before >>> ' + acc.DTI_Ratio__c);
        if(acc.FinServ__CreditScore__c >= 700 && acc.DTI_Ratio__c < 25){
            opp.Scorecard_Decision__c = 'Approved';
            opp.StageName = 'Disbursement & Closure';
            system.debug('in Success! >>> ' + acc.DTI_Ratio__c);
        }else if((acc.FinServ__CreditScore__c >= 640 && acc.FinServ__CreditScore__c < 700 && acc.DTI_Ratio__c < 25) || 
                 (acc.FinServ__CreditScore__c >= 700 && acc.DTI_Ratio__c > 25)){
                     opp.Scorecard_Decision__c = 'Refer to Credit';
                 }else{
                     opp.Scorecard_Decision__c = 'Rejected';
                     opp.StageName = 'Declined';
                 }
        update opp;
*/
        return scoreCard;
    }
    
    public static void createLoanApplication(String oppId){
        Opportunity opp = [Select id, FinServ__FinancialAccount__c, AccountId, Account.Name from Opportunity where id=:oppId];
        /*creating record of Financial Account*/
        FinServ__FinancialAccount__c loanApp = new FinServ__FinancialAccount__c();
        loanApp.RecordtypeId = Schema.SObjectType.FinServ__FinancialAccount__c.getRecordTypeInfosByName().get('Loan Account').getRecordTypeId();
        loanApp.FinServ__PrimaryOwner__c = opp.AccountId;
        loanApp.Name = opp.Account.Name + '- Home Loan Account';
        insert loanApp;
        
        /*Associate created record of Financial Account to opportunity*/
        if(loanApp.id != null){
            opp.FinServ__FinancialAccount__c = loanApp.id;
            update opp;   	
        }
        
    }
    
    public static void creditScoreandincomeUpdate(String recId){  
        Opportunity opp = [Select id,Credit_Score__c, AccountId  from Opportunity where id=:recId];
        Account acct = [Select id,FinServ__CreditScore__c from Account where id=:opp.AccountId];
        acct.FinServ__CreditScore__c = 715;
        opp.Credit_Score__c=715;
        
        Income_Details__c[] ics=[select id,Annual_Income__c from Income_Details__c where Opportunity__c=:recId];
        System.debug('ics');
        if(ics.size()==0){
            System.debug('in loop');
            Income_Details__c icNew = new Income_Details__c();
            icNew.Name = 'Salary';
            icNew.Fid_Name__c = opp.AccountId;
            icNew.Opportunity__c = opp.Id;
            icNew.Annual_Income__c=900000; 
            insert icNew; 
        }
        update acct;
        update opp;
        system.debug('opp'+opp);
      
        
    }
    
    /*
    @AuraEnabled 
    public static void moveStage(String recId){   
        
        Opportunity opp = [SELECT Id,AccountId,StageName,recordTypeID,RecordType.Name
                           FROM Opportunity
                           WHERE Id = :recId];

    }
    */
    
    /* Update stage to next */
     @AuraEnabled
    public static void moveNextStage(String recId, String nxtStage){
        Opportunity opp = new Opportunity(Id=recId);
        opp.StageName = nxtStage;
        update opp;
    }
       
    
    /* Get stages by Index */
    
    @AuraEnabled
    public static String getCurrentStage(String recId){
        Opportunity opp = [SELECT Id,AccountId,StageName,recordTypeID,RecordType.Name
                           FROM Opportunity
                           WHERE Id = :recId];
        
        return opp.StageName;
    }
    
    @AuraEnabled
    public static String getPicklistValueBasedonRecordType(String objectAPIName, String fieldAPIName, String recordTypeDeveloperName){
       
       list<PicklistValue> picklistValues = new list<PicklistValue>();
       
       //get record type Id
       list<RecordType> recordTypes = [Select Id, Name From RecordType  Where SobjectType = :objectAPIName and DeveloperName = :recordTypeDeveloperName limit 1];
       Id recordTypeId = (!recordTypes.isEmpty()) ? recordTypes.get(0).Id : null;
       
       if(recordTypeId != null){
           
           String method = 'GET';
           String endpoint = String.format('/services/data/v43.0/ui-api/object-info/{0}/picklist-values/{1}/{2}', new String[]{ objectAPIName, recordTypeId, fieldAPIName });
           
           HttpRequest request = new HttpRequest();
           request.setEndpoint('callout:UI_API_Named_Credentials'+endPoint);
           request.setMethod(method);
           
           HTTPResponse response = (new Http()).send(request);
           
           if(response.getStatusCode() == 200){
               System.debug(response.getStatusCode());
               Map<String,Object> root = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
               if(root.containsKey('values')){ 
                   List<Object> picklistVals = (List<Object>)root.get('values');
                   Integer i = 0;
                   for(Object picklistVal : picklistVals){
                       Map<String,Object> picklistValMap = (Map<String,Object>) picklistVal;
                       picklistValue pickVal = new picklistValue();
                       i+=1;
                       pickVal.index = i;
                       pickVal.value = (String) picklistValMap.get('value');
                       pickVal.label = (String) picklistValMap.get('label');
                       picklistValues.add(pickVal);
                   }
               }
               
           }
           
       }
       System.debug(picklistValues);
       return JSON.serialize(picklistValues);
   }
   
   
   public class PicklistValue{
       @AuraEnabled
       public Integer index {get;set;}
       
       @AuraEnabled
       public String value {get;set;}
       
       @AuraEnabled
       public String label {get;set;}
   }
    
    @AuraEnabled
    public static Opportunity getUnderwritingChecks(String oppId){
        Opportunity opp = [SELECT DTI_Ratio__c,Credit_Score__c
                           FROM Opportunity
                           WHERE Id = :oppId];
        return opp;
    }

}