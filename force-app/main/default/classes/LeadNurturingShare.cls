public class LeadNurturingShare {
    
    public Static String USER_CONSTANT = 'User';
    public Static String LEAD_CONSTANT = 'Lead';
    public Static String OPPORTUNITY_CONSTANT = 'Opportunity';
    
    @InvocableMethod(label='Share Records while Nurturing' Description='Shares lead records with Public group')
    public static FlowOutput[] LeadShareWithCallCenter(List<FlowInput> inputIds)
    {
        Integer ModNumber = 0;
        FlowOutput[] results = new List<FlowOutput>();
        
        List<User> groupMemberUserList = getGroupMemberUserList();
        
        if(inputIds[0] != null){
            
            String sObjName = inputIds[0].recordId.getSObjectType().getDescribe().getName();
            
            if(sObjName == LEAD_CONSTANT){
                
                List<LeadShare> LeadShareList= new List<LeadShare>();
        
                if(inputIds.size() > 0 && groupMemberUserList.size() > 0)
                {
                    List<Lead> leadList = [Select id, Name, Lead_Count__c from Lead where Id =: inputIds[0].recordId];
                    
                    if(leadList[0] != null){
                        
                        String callCenterUserToTagrId = '';                            
                        List<Pincode_AllocationMod_Map__c> allocationModMap = [SELECT Id, Map_For__c, Last_Mod__c FROM Pincode_AllocationMod_Map__c WHERE Map_For__c = 'Call Center User' ];
                        System.debug('allocationModMap :: '+allocationModMap);
                        if(!allocationModMap.isEmpty()){
                            if((Integer)allocationModMap[0].Last_Mod__c >= groupMemberUserList.size()){
                                allocationModMap[0].Last_Mod__c = 0;
                            }
                            callCenterUserToTagrId = String.valueOf(groupMemberUserList[(Integer)allocationModMap[0].Last_Mod__c].Id);
                            System.debug('callCenterUserToTagrId :: --> '+callCenterUserToTagrId);
                            allocationModMap[0].Last_Mod__c = allocationModMap[0].Last_Mod__c + 1;
                            try{
                                UPDATE allocationModMap;
                                System.debug('allocationModMap Update Success :: '+allocationModMap);
                            }catch(exception e){
                                System.debug('Error in updating allocationModMap : '+e.getMessage());
                            }
                        }else{
                            callCenterUserToTagrId = String.valueOf(groupMemberUserList[0].Id);
                            System.debug('callCenterUserToTagrId :: --> '+callCenterUserToTagrId);
                            Pincode_AllocationMod_Map__c newallocationModMap = new Pincode_AllocationMod_Map__c();
                            newallocationModMap.Map_For__c = 'Call Center User';
                            newallocationModMap.Last_Mod__c = 1;
                            try{
                                INSERT newallocationModMap;
                                System.debug('newallocationModMap Insert Success :: '+newallocationModMap);
                            }catch(exception e){
                                System.debug('Error in updating pincodeModMap : '+e.getMessage());
                            }
                        }
                        
                        //ModNumber = math.mod(Integer.valueOf(leadList[0].Lead_Count__c), groupMemberUserList.size());
                        
                        LeadShare leadShareObj = new LeadShare();
                        leadShareObj.LeadId = leadList[0].Id;
                        //leadShareObj.UserOrGroupId = groupMemberUserList[ModNumber].id;   //before
                        leadShareObj.UserOrGroupId = (ID)callCenterUserToTagrId; // changed by Dilip
                        leadShareObj.LeadAccessLevel = 'Edit';
                        
                        LeadShareList.add(leadShareObj);
                        
                        results.add(new FlowOutput((ID)callCenterUserToTagrId));
                        
                        if(LeadShareList!=null)
                        {
                            Database.insert(LeadShareList,false);
                        }
                    }
                }
                
            }
            /*else if(sObjName == OPPORTUNITY_CONSTANT){
                
                List<OpportunityShare> OppShareList= new List<OpportunityShare>();
                
                if(inputIds.size() > 0 && groupMemberUserList.size() > 0)
                {
                    List<Opportunity> oppList = [Select id, Name, Opportunity_Count__c from Opportunity where Id =: inputIds[0].recordId];
                    
                    if(oppList[0]!= null){
                        
                        String callCenterUserToTagrId = '';                            
                        List<Pincode_AllocationMod_Map__c> allocationModMap = [SELECT Id, Map_For__c, Last_Mod__c FROM Pincode_AllocationMod_Map__c WHERE Map_For__c = 'Call Center User' ];
                        System.debug('allocationModMap :: '+allocationModMap);
                        if(!allocationModMap.isEmpty()){
                            if((Integer)allocationModMap[0].Last_Mod__c >= groupMemberUserList.size()){
                                allocationModMap[0].Last_Mod__c = 0;
                            }
                            callCenterUserToTagrId = String.valueOf(groupMemberUserList[(Integer)allocationModMap[0].Last_Mod__c].Id);
                            System.debug('callCenterUserToTagrId :: --> '+callCenterUserToTagrId);
                            allocationModMap[0].Last_Mod__c = allocationModMap[0].Last_Mod__c + 1;
                            try{
                                UPDATE allocationModMap;
                                System.debug('allocationModMap Update Success :: '+allocationModMap);
                            }catch(exception e){
                                System.debug('Error in updating allocationModMap : '+e.getMessage());
                            }
                        }else{
                            callCenterUserToTagrId = String.valueOf(groupMemberUserList[0].Id);
                            System.debug('callCenterUserToTagrId :: --> '+callCenterUserToTagrId);
                            Pincode_AllocationMod_Map__c newallocationModMap = new Pincode_AllocationMod_Map__c();
                            newallocationModMap.Map_For__c = 'Call Center User';
                            newallocationModMap.Last_Mod__c = 1;
                            try{
                                INSERT newallocationModMap;
                                System.debug('newallocationModMap Insert Success :: '+newallocationModMap);
                            }catch(exception e){
                                System.debug('Error in updating pincodeModMap : '+e.getMessage());
                            }
                        }
                        
                        //ModNumber = math.mod(Integer.valueOf(oppList[0].Opportunity_Count__c), groupMemberUserList.size());
                        
                        OpportunityShare oppShareObj = new OpportunityShare();
                        oppShareObj.OpportunityId=oppList[0].id;
                        //oppShareObj.UserOrGroupId=groupMemberUserList[ModNumber].id;  //before
                        oppShareObj.UserOrGroupId=(ID)callCenterUserToTagrId; // changed by Dilip
                        oppShareObj.OpportunityAccessLevel ='Edit';
                        
                        OppShareList.add(oppShareObj);
                        
                        results.add(new FlowOutput((ID)callCenterUserToTagrId));

                      
                    }
                }
            }*/
        }
        
        return results;
    }
        
    
    public static List<User> getGroupMemberUserList(){
        
        List<User> groupMemberUserList = new List<user>();
        
        Id groupId = [SELECT id FROM Group where Name  =: system.label.PublicGroupNameForCC].get(0).Id;
        if(groupId != null){
            List<GroupMember> groupMemberList= [select Id, GroupId, UserOrGroupId, SystemModstamp from GroupMember where groupId =: groupId];
            List<Id> groupMemberUserIdList = new List<Id>();
            if(groupMemberList.size()>0){
                for(GroupMember gm : groupMemberList){
                    String gmObjName = gm.UserOrGroupId.getSObjectType().getDescribe().getName();
                    if(gmObjName == USER_CONSTANT){
                        groupMemberUserIdList.add(gm.UserOrGroupId);
                    }
                }
                
                if(groupMemberUserIdList.size()>0){
                    groupMemberUserList = [select id, Name, isActive from user where Id =:groupMemberUserIdList And isActive = true];                
                }                
            }            
        }
        return groupMemberUserList;   
    }
    
    public class FlowInput{
        @InvocableVariable
        public Id recordId;
    }
    
    public class FlowOutput{
        
        @InvocableVariable public id shareUserId;
        
        public FlowOutput(id userId){
            this.shareUserId = userId;
        }
    }
    
}