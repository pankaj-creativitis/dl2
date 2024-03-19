@isTest
private class RuleEngineHelperTest {
    @isTest static void test_getObjects_getTierFieldMap(){
        List<RuleEngineHelper.objectClass> standardObjList = RuleEngineHelper.getObjects();
        System.assert(standardObjList !=null );
        System.assert( RuleEngineHelper.getTierFieldMap('Account') != null );
        
        /*
        List<List<RuleEngineHelper.FieldLabel>> fl = new List<List<RuleEngineHelper.FieldLabel>>();
        Test.startTest();
        for(RuleEngineHelper.objectClass obj : standardObjList){
            fl.add(RuleEngineHelper.getTierFieldMap(obj.apiName));
        }
        System.assert(fl !=null );
        Test.stopTest();
        */
    }
    @isTest static void test_saveRules_getConditions(){
        List<Condition__c> c = new List<Condition__c>();
        c.add(new Condition__c(Object__c = 'FinServ__AssetsAndLiabilities__c', Name = '', Field__c = '', Not__c = true, Operator__c = 'Greater than', Values__c = '5000'));
        c.add(new Condition__c(Object__c = 'FinServ__AssetsAndLiabilities__c', Name = '', Field__c = '', Not__c = false, Operator__c = 'Greater than', Values__c = '5000'));
        c.add(new Condition__c(Object__c = 'FinServ__AssetsAndLiabilities__c', Name = '', Field__c = '', Not__c = true, Operator__c = 'Equals any', Values__c = 'Asset, Liability'));
        c.add(new Condition__c(Object__c = 'FinServ__AssetsAndLiabilities__c', Name = '', Field__c = '', Not__c = false, Operator__c = 'Equals any', Values__c = 'Asset, Liability'));
        Test.startTest();
        RuleEngineHelper.saveRules(c);
        System.assert(RuleEngineHelper.getConditions('FinServ__AssetsAndLiabilities__c')!=null);
        Test.stopTest();
    }
}