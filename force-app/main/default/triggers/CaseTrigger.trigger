trigger CaseTrigger on Case (before insert, before update, after insert, after update) {
	
	if(trigger.isBefore && trigger.isInsert){
		List<Case> cases = (List<Case>)Trigger.new;
		CaseTriggerHandler.setOwner(Trigger.new);	
        for(Case cs: cases){
            if(cs.Type == 'Statement Request'){
                System.debug('type is:'+cs.Type);
                cs.subject = 'Account Statement';
                cs.Status = 'Closed';
                
            }
        }	
	}
    
    if(trigger.isAfter && trigger.isUpdate){
		
        
        
		// CaseTriggerHandler.updateStage(Trigger.new);	
		List<Case> cases = (List<Case>)Trigger.new;
        List<Case> updateCase = new List<Case>();
        for(Case cs: cases){
            if(cs.Type == 'Statement Request'){
                System.debug('type is:'+cs.Type);
                SendServiceMails.sendEmail(cs.Id);
                
            }
            if(cs.Status == 'Closed'){
                CaseTriggerHandler.sendClosureMail(cs);
            }
        }	
        
        	
	}

    if(trigger.isAfter && trigger.isInsert){
		
		// CaseTriggerHandler.callEinsteinSentimentService(Trigger.new);
		 for(Case c : Trigger.new) {
            if(c.Origin == 'Email'){
                System.debug('got Called');
                // CaseCategorization.fetchCaseInfo(c.Id);
                break;
             
        }
         }
        
	
	}
    
}