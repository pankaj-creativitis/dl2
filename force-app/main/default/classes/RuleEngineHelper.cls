public class RuleEngineHelper {
    
    @AuraEnabled
   public static boolean isDisplay {get;set;}
    @AuraEnabled
    public static List<optionsWrapper> getConditions(String objName) {
        List<Condition__c> conditions = [SELECT Name, Id FROM Condition__c WHERE Object__c=:objName];
        List<optionsWrapper> ops = new List<optionsWrapper>();
        for(Condition__c cond : conditions){
            optionsWrapper op = new optionsWrapper();
            op.label = cond.Name;
            op.value = cond.Id;
            ops.add(op);
        }
        return ops;
    }
    
    public class optionsWrapper{
        @AuraEnabled public String label {set;get;}
        @AuraEnabled public String value {set;get;}
    }
    
    public class objectClass{
        @AuraEnabled public string label{get;set;}
        @AuraEnabled  public string apiName{get;set;}
        public objectClass()
        {
            
        }
        public objectClass( string lab, string api)
        {
            this.label = lab;
            this.apiName = api;
        }
    }
    
    public class FieldLabel{
        @AuraEnabled public String fName {set;get;}
        @AuraEnabled public String fLabel {set;get;}
        @AuraEnabled public String fRelAPI {set;get;}
    }
    
    @AuraEnabled
    public static List<objectClass> getObjects() {
        List<objectClass> standardObjList
            = new list<objectClass> ();
        
        for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().Values()){
            objectClass obj=new objectClass();
            obj.label=objTyp.getDescribe().getLabel();
            obj.apiName=objTyp.getDescribe().getName();
            standardObjList.add(obj);
        }
        return standardObjList; 
    }
    
    @AuraEnabled
    public static List<FieldLabel> getTierFieldMap(string obj) {
        List<FieldLabel> flds = new List<FieldLabel>();
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(obj);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        for (String fieldName: fieldMap.keySet()) {
            Schema.DisplayType fielddataType = fieldMap.get(fieldName).getDescribe().getType();
            System.debug('fielddataType >>>> ' + fielddataType);
            
            if(fielddataType == Schema.DisplayType.Currency || fielddataType == Schema.DisplayType.Integer
               || fielddataType == Schema.DisplayType.Double || fielddataType == Schema.DisplayType.Percent
               || fielddataType == Schema.DisplayType.Date || fieldName.contains('recordtype')) {
                   
                   FieldLabel fld = new FieldLabel();
                   String fldLbl = fieldMap.get(fieldName).getDescribe().getLabel();
                   if(fieldName.endsWith('id') || fieldName.endsWith('Id') || fieldName.endsWith('ID') ){
                       fieldName = fieldName.substring(0,fieldName.length()-2).trim();
                       fieldName += '.Name';
                   }
                   if(fldLbl.endsWith('id') || fldLbl.endsWith('Id') || fldLbl.endsWith('ID')){
                       fldLbl = fldLbl.substring(0,fldLbl.length()-2).trim();
                   }
                   fld.fName = fieldName;
                   fld.fLabel = fldLbl;
                   flds.add(fld);
                   
               }
        }
        return flds;
    }
    
    // Row Component methods
    @AuraEnabled
    public static void saveRules(List<Condition__c> lstCondition){
        
        String qry;
        String[] vals;
        String inVals = '';
        for(Condition__c cd: lstCondition){
            qry=cd.Field__c;
            system.debug('qry '+qry);
            if(cd.Operator__c == 'Greater than'){
                System.debug('in Greater');
                if(cd.Not__c){
                    System.debug('less val' + cd.Values__c);
                    qry += ' < ' + cd.Values__c;
                } else {
                    System.debug('greater val' + cd.Values__c);
                    qry += ' > ' + cd.Values__c;
                }
            } else if(cd.Operator__c == 'Equals any'){
                vals = cd.Values__c.split('\\,');
                for(String val:vals){
                    inVals +='\'' + val + '\',';
                }
                inVals = inVals.substring(0,inVals.length()-1);
                if(cd.Not__c){
                    qry += ' NOT IN (' + inVals + ')';
                } else {
                    qry += ' IN (' + inVals + ')';
                }
            }
            cd.Condition_Query__c = qry;
        }
        Insert lstCondition;
    }
    @AuraEnabled
    public static boolean conditionMaker() {
        String id='003S00000185pT2IAI';
        System.debug('method called with obj name '+id);
        isDisplay=false;
        Condition__c con1 = [SELECT id,Object__c,Condition_Query__c FROM Condition__c where id='a12S00000025vSNIAY'];
        Condition__c con2 = [SELECT id,Object__c,Condition_Query__c FROM Condition__c where id='a12S00000025pVvIAI'];
        //String c=[select id,Condition_Query__c from Condition__c where Object__c =:obj].Condition_Query__c; 
        String qry='Select id ';
		qry+=' from ' +con1.Object__c;  
       	qry+=' where '+ con1.Condition_Query__c +' AND '+con2.Condition_Query__c + ' AND id =  \'' + String.escapeSingleQuotes(id)+'\'';
        system.debug('qryyy****** '+qry);
        List<Sobject> results=Database.query(qry);
		system.debug('results &&& '+results);    
        if(results.size() > 0){
            isDisplay=true;
           return true;
        }
        return false;
    }

 @AuraEnabled
    public static map<Integer,Condition__c> conditionsList( String obj) {
        map<Integer,Condition__c> cmap=new Map<Integer,Condition__c>();
        system.debug('inside map method');
       // obj='contact';
	List<Condition__c> lc=new List<Condition__c>();
        Integer keyValue=1;
        for(Condition__c cd:[SELECT id,name,Object__c,Condition_Query__c FROM Condition__c where Object__c =:obj])
        {   
            cmap.put(keyValue++,cd);
        }
       
        system.debug('list of conditions ' +cmap);
        return cmap;
    }

	@AuraEnabled
    public  static void exprMethod(string exp,String obj){
        //List<String> exp1 = (List<String>)System.JSON.deserializeStrict(exp, List<String>.Class);
       
        List<Expression__c> lString=new List<Expression__c>();
        Expression__c es= new Expression__c();
        es.ConditionExprName__c=exp;
        es.Object__c=obj;
        lString.add(es);
        system.debug('lString'+lString);
       upsert lString;
    }
    
    @AuraEnabled
    public  static boolean exprMethod2(String id){
         id='003S000001G7nRmIAJ';
        system.debug('inside expr2 method '+id);
        Expression__c expr=[SELECT id,name,Object__c,ConditionExprName__c FROM Expression__c where id ='a13S0000001sLgLIAU'];       
        String qry='Select id ';
		qry+=' from ' +expr.Object__c;  
       	qry+=' where ('+ expr.ConditionExprName__c +' ) AND  id =  \'' + String.escapeSingleQuotes(id)+'\'';
        system.debug('query is  &&& '+qry);    
        List<Sobject> results=Database.query(qry);
		system.debug('results &&& '+results);    
        if(results.size() > 0){
            
            isDisplay=true;
           return true;
        }
        return false;
    }
    
}