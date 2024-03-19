public with sharing class GenericHelper {
    
    /* Filter Listview */
    public class FilterWrapper {
        
        @AuraEnabled
        public String filterKey { get;set; }
        @AuraEnabled
        public String filterValue { get;set; }
        
        public FilterWrapper(String filterKey, String filterValue) {
            this.filterKey = filterKey;
            this.filterValue = filterValue;
        }
    }
    
    /* method for fetching the data for the lightning datatable */
    public class LstInputWrapper {
        
        @AuraEnabled
        public string sectionName;
        @AuraEnabled
        public string objectName;
        @AuraEnabled
        public string parentObjectName;
        @AuraEnabled
        public string parentFldName;
        @AuraEnabled
        public string recId;
        @AuraEnabled
        public string fldSet;
        @AuraEnabled
        public Integer recsPerPage;
        @AuraEnabled
        public string sectionHeader;
        @AuraEnabled
        public string sectionIcon;
        
    }
    
    @AuraEnabled
    public static List<LstInputWrapper> getRelatedLists( String objectName, String recId)
    {
        List<LstInputWrapper> lstWraps = new List<LstInputWrapper>();
        
        Opportunity opp = [SELECT Id,Name,StageName,recordTypeID,RecordType.Name
                              FROM Opportunity
                                WHERE Id = :recId];
        system.debug('opp >>> ' + opp);
        List_Metadata_Configuration__mdt[] lstMappings = [SELECT MasterLabel,FieldSet_Name__c,Object_Name__c,Parent_Field__c, Records_per_page__c,
                                                          Page_Object__c,Page_Parent_Field__c, Parent_Object__c,Section_Header__c,Section_Icon__c 
                                                           FROM List_Metadata_Configuration__mdt
                                                        WHERE Page_Object__c= :objectName AND Record_Type__c=:opp.RecordType.Name
                                                        AND Stage__c=:opp.StageName];
        system.debug('opp.RecordType.Name >>> ' + opp.RecordType.Name);
        system.debug('lstMappings >>> ' + lstMappings);
        for(List_Metadata_Configuration__mdt lstMeta: lstMappings){
            LstInputWrapper inpWrap = new LstInputWrapper();
            inpWrap.sectionName = lstMeta.MasterLabel;
            inpWrap.objectName = lstMeta.Object_Name__c;
            inpWrap.parentFldName = lstMeta.Parent_Field__c;
            inpWrap.fldSet = lstMeta.FieldSet_Name__c;
            inpWrap.parentObjectName = lstMeta.Parent_Object__c;
            inpWrap.sectionHeader = lstMeta.Section_Header__c;
            inpWrap.sectionIcon = lstMeta.Section_Icon__c;
            // inpWrap.recsPerPage = lstMeta.Records_per_page__c;
            inpWrap.recsPerPage = 5;
            if(lstMeta.Page_Object__c == lstMeta.Parent_Object__c){
                inpWrap.recId = recId;
                //Temporary hardcode
                 
            } else {
                String queryString = 'Select  id, ';
                // queryString += ' FROM ' + strSObjectName+' WHERE '+filter;
                queryString += lstMeta.Page_Parent_Field__c;
                queryString += ' FROM ' + lstMeta.Page_Object__c + ' WHERE id = \'' + recId + '\'';
                System.debug('queryString::'+queryString);
                list<SObject> lstSObject = Database.query(queryString);
                if(lstSObject.size()>0){
                    inpWrap.recId = (String)lstSObject[0].get(lstMeta.Page_Parent_Field__c);
                    System.debug('inpWrap.recId ::'+inpWrap.recId );
                }
            }
            lstWraps.add(inpWrap);
        }
        
        return lstWraps;
    }
    
    public class ResultWrapper {
        
        @AuraEnabled
        public list<SObject> lstSObject;
        @AuraEnabled
        public list<FieldsWrapper> lstFields;
        
        public ResultWrapper(list<SObject> lstSObject, list<FieldsWrapper> lstFields) {
            
            this.lstSObject = lstSObject;
            this.lstFields  = lstFields;
        }
    }
    
    public class FieldsWrapper {
        
        @AuraEnabled
        public String fieldPath { get;set; }
        @AuraEnabled
        public String label     { get;set; }
        @AuraEnabled
        public String type      { get; set; }
        
        public FieldsWrapper(String fieldPath, String strLabel, String strType) {
            this.fieldPath = fieldPath;
            this.label = strLabel;
            this.type = strType;
        }
    }
    
    
    @AuraEnabled
    public static ResultWrapper  fetchContact( String strSObjectName, String strFieldsetName, 
                                              String filter, String parentFld, String parentId)
    {
        
        Set<String> setFieldsToQuery = new set<String>();
        List<FieldsWrapper> lstFieldsetWrapper = new List<FieldsWrapper>();
        Map<String, String> mapfiledpathlael = new Map<String, String>();
        
        for(Schema.FieldSetMember fieldSetMemberObj : readFieldSet(strFieldsetName, strSObjectName)) {            
            setFieldsToQuery.add(fieldSetMemberObj.getFieldPath().toLowerCase());
            mapfiledpathlael.put(String.valueOf(fieldSetMemberObj.getType()), fieldSetMemberObj.getFieldPath());
            lstFieldsetWrapper.add(new FieldsWrapper(fieldSetMemberObj.getFieldPath(), fieldSetMemberObj.getLabel(),String.valueOf(fieldSetMemberObj.getType())));
        }
        String queryString = 'Select  id, ';
        setFieldsToQuery.remove('id');
        queryString += String.join( new List<String>(setFieldsToQuery), ',');
        queryString.removeEnd(',');
        // queryString += ' FROM ' + strSObjectName+' WHERE '+filter;
        queryString += ' FROM ' + strSObjectName + ' WHERE ' + parentFld + ' = \'' + parentId + '\'';
        System.debug('queryString::'+queryString);
        list<SObject> lstSObject = Database.query(queryString);
        System.debug('lstSObject::'+lstSObject);
        if(lstSObject.size()!=0){
            return new ResultWrapper(lstSObject,lstFieldsetWrapper);    
        } else {
            return null;
        }
        
    }
    
    private static List<Schema.FieldSetMember> readFieldSet(String fieldSetName, String ObjectName) {
        Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(ObjectName);
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
        return fieldSetObj.getFields(); 
    }
    
    @AuraEnabled
    public static boolean deleteRecord(ID recId) {
        Database.delete(recId);
        return true;
    }
    
    /* ===== Record Information Methods start ===== */
    
    // Please modify below method to accept generic object
    @AuraEnabled
    public static List<RecordMetadata> getRecordMetadata(String recId) {
        //  Opportunity opp = [SELECT Id, Account.FinServ__PrimaryContact__c,Account.Name,Account.Id, Name,StageName,recordTypeID,RecordType.Name
        //                      FROM Opportunity
        //                      WHERE Id = :recId];
        Opportunity opp = [SELECT Id,Name,StageName,recordTypeID,RecordType.Name
                           FROM Opportunity
                           WHERE Id = :recId];
        List<Detail_View_Configuration__mdt> viewMappings = [SELECT Tab_and_FieldSet__c,Sections__c, Parent_Field__c,Section_Header__c, Order__c, Section_Icon__c 
                                                             FROM Detail_View_Configuration__mdt
                                                             WHERE Object_Name__c='Opportunity' AND Record_Type__c=:opp.RecordType.Name
                                                             AND Stage__c=:opp.StageName order by Order__c ASC];
        
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
                // TBD: remove hardcoding below
                objType = 'Opportunity';
            }
            
            RecordMetadata rmd = new RecordMetadata();
            rmd.objName = objType;
            rmd.objId = parentId;
            rmd.sectionHeader = viewMap.Section_Header__c;
            rmd.sectionIcon = viewMap.Section_Icon__c;
            rmd.order = viewMap.Order__c;
            
            // Section Maker here
            // String[] tabArray = viewMap.Tab_and_FieldSet__c.split('\\,');
            List<Tab> tabs = (List<Tab>)JSON.deserialize(viewMap.Sections__c, List<Tab>.class);

            List<Section> sections = new List<Section>();
            for(Tab t: tabs){
                Section sect = new Section();
                system.debug(t);
                
                sect.sectionName = t.tabName;
                String strFieldsetName = t.fldSet;
                String[] tabFlds = new String[]{};
                    system.debug('strFieldsetName >>> ' + strFieldsetName);
                system.debug('objType >>> ' + objType);
                for(Schema.FieldSetMember fieldSetMemberObj : readFieldSet(strFieldsetName, objType)) {            
                    tabFlds.add(fieldSetMemberObj.getFieldPath());
                }
                sect.flds = tabFlds;
                sections.add(sect);
            }
            /*
            for(String t: tabArray){
                Section sect = new Section();
                system.debug(t);
                String[] tabFldSet = t.split('\\&');
                String tabName = tabFldSet[0].trim();
                sect.sectionName = tabName;
                String strFieldsetName = tabFldSet[1].trim();
                String[] tabFlds = new String[]{};
                    system.debug('strFieldsetName >>> ' + strFieldsetName);
                system.debug('objType >>> ' + objType);
                for(Schema.FieldSetMember fieldSetMemberObj : readFieldSet(strFieldsetName, objType)) {            
                    tabFlds.add(fieldSetMemberObj.getFieldPath());
                }
                sect.flds = tabFlds;
                sections.add(sect);
            }
            */

            // section maker ends
            // List<Section> sections = (List<Section>)JSON.deserialize(viewMap.Sections__c, List<Section>.class);
            rmd.sections = sections;
            rmdList.add(rmd);
            // rmd.sections = viewMappings[0].Sections__c;
        }
        system.debug('rmdList >>> '+ rmdList);
        return rmdList;
    }
    
    public class RecordMetadata{            
        @AuraEnabled public String objName { get;set;}
        @AuraEnabled public String objId { get;set;}
        @AuraEnabled public String sectionHeader { get;set;}
        @AuraEnabled public String sectionIcon { get;set;}
        @AuraEnabled public Decimal order { get;set;}
        @AuraEnabled public List<Section> sections { get;set;}
    }
    
    public class Section{            
        @AuraEnabled public String sectionName { get;set;}
        @AuraEnabled public String[] flds { get;set;}
    }
    public class Tab{            
        @AuraEnabled public String tabName { get;set;}
        @AuraEnabled public String fldSet { get;set;}
    }
    
    /* ==== Record Information Methods end ==== */
 
}