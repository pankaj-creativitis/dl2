public class QuestionnaireController {
    
    //Select DeveloperName, DataType From FieldDefinition where EntityDefinition.DeveloperName='Account'
    
    @AuraEnabled(cacheable=true)
    public static List<WrapColumn> getColumns(String catId, String columns, String arrayList) {
        // String key = '%' + searchKey + '%';
        system.debug('columns >>> ' + columns);
        String strClmStr = columns.replace('__c', '');
        List<String> lstColumns = strClmStr.split(',');
        System.debug(lstColumns);
        List<String> lstArr = arrayList.split(',');
        System.debug(lstArr);
        
        List<FieldDefinition> fldDefs = [Select DeveloperName, DataType From FieldDefinition where EntityDefinition.DeveloperName='Question']; 
        // System.debug('fDef all > '+fldDefs);
        List<WrapColumn> wrClms = new List<WrapColumn>();
        for(String clm: lstColumns){
            for(FieldDefinition fDef:fldDefs){
                // System.debug('fDef row > '+fDef);
                // System.debug('clm row > '+clm);
                if(fDef.DeveloperName == clm){
                    // System.debug('fDef row > '+fDef);
                    System.debug('clm row > '+clm);
                    String formattedType;
                    formattedType = formatDataType(fDef.DataType);
                    WrapColumn wrClm = new WrapColumn(clm,clm + '__c',formattedType, true);
                    wrClms.add(wrClm);
                }
                
            }
        }
        system.debug('columns: > ' + wrClms);
        String jsonClms = JSON.serialize(wrClms);
        system.debug('jsonClms > ' + jsonClms);
        return wrClms;
    }
    
    public static String formatDataType(String dType){
        switch on dType {
            when 'Text(255)' {		// when block 1
                return 'text';
            }
            when 'Text Area(255)' {		// when block 2
                return 'text';
            }
            when 'Formula (Percent)' {
                return 'percent';
            }
            when 'Currency(10, 0)' {
                return 'currency';
            }
            when else {		  // when else block, optional
                return 'text';
            }
        }
    }
    
    //@AuraEnabled(cacheable=true)
    @AuraEnabled
    public static List<sObject> getData(String catId, String columns, String arrayList) {
        // String key = '%' + searchKey + '%';
        List<String> lstArr = arrayList.split(',');
        System.debug(lstArr);
        String qryString = 'SELECT ' + columns + ' FROM Question__c WHERE Matrix__c = true';
        List<sObject> recs = Database.query(qryString);
        /*
for(String baseText: lstArr){
Question__c qst = new Question__c();
qst.Base_Check__c = true;
recs.add(qst);
}
*/
        return recs;
    }
    
    // Update responses for surveys other than Matrix
    @AuraEnabled
    public static void updateOtherResponses( String recId, String selectedOptions, String answer, String qType ) {
        
        Question__c qn = [SELECT Id, Selected_Option_s__c, Answer__c FROM Question__c WHERE Id = :recId];
        
        if(qType=='Dropdown' || qType=='Multi-select'){
            qn.Selected_Option_s__c = selectedOptions;
            
        } else {
            qn.Answer__c = answer;
        }
        
        update qn;
    }
    
    // Update responses for Matrix surveys
    @AuraEnabled
    public static string updateResponses( Object data ) {
        
        List <Question__c> accsForUpdate = ( List <Question__c> ) JSON.deserialize(
            JSON.serialize( data ),
            List <Question__c>.class
        );
        try {
            update accsForUpdate;
            return 'Success: Account(s) updated successfully';
        }
        catch (Exception e) {
            return 'The following exception has occurred: ' + e.getMessage();
        }
        
    }
    
    //Method to render the question
    @AuraEnabled
    public static Question__c renderQuestion( String recId ) {
        List<Question__c> qns = [SELECT Id, Question_Type__c, Question_Long_Text__c, Question_Text__c, Options__c, Answer__c, Selected_Option_s__c FROM Question__c WHERE Id = :recId];
        return qns[0];
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Limit__c> getLimits(String oppId) {
        // String key = '%' + searchKey + '%';
        return [
            SELECT Type__c, Name, Amount_Lacs__c, ROI_Commission__c, 
            Margin__c, Tenure_Months__c, Repayment__c, Purpose__c, Level__c, Parent_Application__c, Limit__c
            FROM Limit__c
            WHERE Parent_Application__c = :oppId
            ORDER BY Level__c
        ];
    }
    
    // Fetch fields of selected data type
    @AuraEnabled
    public static List<FieldDefinition> getQuestions(String qType)
    {
        List<FieldDefinition> fDefinitionList = [SELECT Id, Label, QualifiedApiName, DataType, Length FROM FieldDefinition WHERE EntityDefinition.QualifiedApiName = 'Question__c' AND DataType =: qType];
        
        return fDefinitionList;
    }
    
    public class WrapColumnAndData {
        public List<WrapColumn> columns {get; set;}
        public List<Question__c> queries {get; set;}
        
        //This is the contructor method. When we create a new wrapAccount object we pass a Account that is set to the acc property. We also set the selected value to false
        
    }
    
    public class WrapColumn {
        @AuraEnabled
        public String label {get; set;}
        @AuraEnabled
        public String fieldName {get; set;}
        @AuraEnabled
        public String type {get; set;}
        @AuraEnabled
        public Boolean editable {get; set;}
        
        //This is the contructor method. When we create a new wrapAccount object we pass a Account that is set to the acc property. We also set the selected value to false
        public WrapColumn() {
            
        }
        public WrapColumn(String lbl,String fldName,String typ, Boolean edt) {
            label = lbl;
            fieldName = fldName;
            type = typ;
            editable = edt;
        }
    }
}