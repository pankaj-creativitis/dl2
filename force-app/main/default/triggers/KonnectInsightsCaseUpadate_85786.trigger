trigger KonnectInsightsCaseUpadate_85786 on Case (after update) {
   
    for(Case caseOld: Trigger.old){
        
        // if(caseOld.Origin.contains('Web')){
            for(Case caseNew: Trigger.new)
            {
                if(caseOld.CaseNumber==CaseNew.CaseNumber && caseOld.Status!=CaseNew.Status)
                {
                    String url = 'https://whintegrations.konnectinsights.com/Salesforce/u1bHLRYPvf8Ai8N57CKMiZJVwsgVr1bTTetzjZGmgaJiJjXY6%2FZ9Lr2QZpNto81dwpM0goBehgE7lWoHNfVQaiznGt4HrDlhDBftbbcovdM%3D';

                    String content = KonnectInsightsTicketEventUpdates.JsonContentFromObject(caseNew);
                
                    KonnectInsightsTicketEventUpdates.callout(url, content);
                }
            }
        //}
    }
}