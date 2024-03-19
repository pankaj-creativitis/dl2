public without sharing class RelatedListController {
      @AuraEnabled( cacheable=true ) 
    public static RelatedListWrapper fetchRecords( String listValues )  { 

        system.debug( 'values are ' + listValues ); 
        List < String > strList = listValues.split( '-' ); 
        system.debug( 'values are ' + strList ); 
        RelatedListWrapper objWrap = new RelatedListWrapper();
         
        if ( strList.size() == 4 ) { 
         
            String recordId = strList.get( 0 ); 
            system.debug( 'recordId ' + recordId );
            String objectName = strList.get( 1 ); 
            system.debug( 'objectName ' + objectName );
            String parentFieldAPIName = strList.get( 2 ); 
            system.debug( 'parentFieldAPIName ' + parentFieldAPIName );
            // String fieldName = strList.get( 3 ); 
            // String fieldValue = strList.get( 4 ); 
            // String filterType = strList.get( 5 ); 
            // String operator = strList.get( 6 ); 
            String fieldsList = strList.get( 3 ); 
            system.debug( 'fieldsList ' + fieldsList );
          
            String strSOQL = 'SELECT Id, CreatedDate';
            // strSOQL += ', ' + fieldsList;
            // String filter = ' FROM ' + objectName + ' WHERE ' + parentFieldAPIName + ' = \'' + recordId + '\' AND '; 
            String filter = ' FROM ' + objectName + ' WHERE ' + parentFieldAPIName + ' = \'' + recordId + '\'';
            /*
            if ( filterType == 'String' )     
                filter += fieldName + ' = \'' + fieldValue + '\''; 
            else if ( filterType == 'Boolean' )     
                filter += fieldName + ' = ' + fieldValue; 
            else 
                filter += fieldName + ' ' + operator + ' ' + fieldValue; 
*/
            String strCountSOQL = ' SELECT COUNT() ' + filter;
            system.debug('strCountSOQL >> ' + strCountSOQL);
            
            objWrap.recordCount = Database.countQuery( strCountSOQL );
            system.debug('strCountSOQL Count >> ' + objWrap.recordCount);
            strSOQL += filter + ' order by CreatedDate desc';     
            objWrap.listRecords = Database.query( strSOQL ); 
             
        }   
        return objWrap; 
         
    } 

    public class RelatedListWrapper {

        @AuraEnabled
        public List < SObject > listRecords;
        @AuraEnabled
        public Integer recordCount;

    }

}