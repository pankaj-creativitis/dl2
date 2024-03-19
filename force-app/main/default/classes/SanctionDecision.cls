public without sharing class SanctionDecision {
    @InvocableMethod(label='Create Corresponding Opportunity' description='Create Corresponding Account, Contact, Opportunity.' category='Flow Session')
    public static void createCorrespondingAccounts(List<ID> ids) {
        List<String> accountNames = new List<String>();
        List<qsydApps_AO__Flow_Session__c> fsessions = [SELECT qsydApps_AO__First_Name__c,qsydApps_AO__Middle_Name__c,qsydApps_AO__Last_Name__c,
                                                        qsydApps_AO__Date_of_Birth__c,qsydApps_AO__Gender__c,
                                                        qsydApps_AO__Email__c,qsydApps_AO__MobilePhone__c,qsydApps_AO__MailingCity__c,
                                                        qsydApps_AO__MailingCountry__c,qsydApps_AO__MailingPostalCode__c,qsydApps_AO__MailingState__c,
                                                        qsydApps_AO__MailingStreet__c,Monthly_Net_Salary__c,Employer_Name__c,
                                                        Total_Monthly_Expenses__c,Name,Products__c,LoanRequestedAmount__c,
                                                        RateofInterest__c,TenureYears__c,Sanction_Decision__c FROM qsydApps_AO__Flow_Session__c 
                                                        WHERE Id in :ids];
        List<Contact> cns = new List<Contact>();
        List<Account> ans = new List<Account>();
        List<Opportunity> opps = new List<Opportunity>();
        for (qsydApps_AO__Flow_Session__c fs : fsessions) {
            
            /*new test code*/
            lead ld = new Lead(lastname='fs1');
            insert ld;
            Database.LeadConvert lc = new Database.LeadConvert();
            lc.setLeadId(ld.id);
            
            LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
            lc.setConvertedStatus(convertStatus.MasterLabel);
            
            Database.LeadConvertResult lcr = Database.convertLead(lc);
            System.assert(lcr.isSuccess());
            Contact cn = new Contact(Id=lcr.getContactId());
            // insert cont;
            // cns.add(cn);
            
            Account acc = new Account(Id=lcr.getAccountId(), Credit_Score__c=715, FinServ__CreditScore__c=715, 
                                       Debt__c=200000);
            // acc.FinServ__PrimaryContact__c = cont.Id;
            ans.add(acc);
            // Contact convertedContact = [SELECT Id, FirstName, LastName, FinServ__LastFourDigitSSN__c FROM Contact WHERE Id = :lcr.getContactId()];
            
            
            Opportunity opp = new Opportunity(Id = lcr.getOpportunityId());
            
            /* new test code end */
            // accountNames.add(account.Name);
            // Contact cn = new Contact();
            cn.FirstName = fs.qsydApps_AO__First_Name__c;
            cn.LastName = fs.qsydApps_AO__Last_Name__c;
            cn.Birthdate = fs.qsydApps_AO__Date_of_Birth__c;
            cn.FinServ__Gender__c = fs.qsydApps_AO__Gender__c;
            cn.Email = fs.qsydApps_AO__Email__c;
            cn.MobilePhone = fs.qsydApps_AO__MobilePhone__c;
            cn.MailingCity = fs.qsydApps_AO__MailingCity__c;
            cn.MailingCountry = fs.qsydApps_AO__MailingCountry__c;
            cn.MailingPostalCode = fs.qsydApps_AO__MailingPostalCode__c;
            cn.MailingState = fs.qsydApps_AO__MailingState__c;
            cn.MailingStreet = fs.qsydApps_AO__MailingStreet__c;
            cn.Net_Monthly_Salary__c = fs.Monthly_Net_Salary__c;
            cn.Employer_Name__c = fs.Employer_Name__c;
            cn.Total_Monthly_Expenses__c = fs.Total_Monthly_Expenses__c;
            // insert cn;
            cns.add(cn);
            System.debug('contact id >> ' + cn.id);
            // Account acc = new Account(FinServ__PrimaryContact__c = cn.Id);
            // upsert 
            // List<Account> accs = [SELECT Id FROM Account WHERE FinServ__PrimaryContact__c = :cn.Id];
            // System.debug('Account id >> ' + accs[0].id);
            // Opportunity opp = new Opportunity();
            opp.Name = '**' + fs.qsydApps_AO__First_Name__c + ' '+ fs.qsydApps_AO__Last_Name__c +' - ' + fs.Products__c;
            opp.Expected_Loan_Amount__c = fs.LoanRequestedAmount__c;
            opp.Amount = fs.LoanRequestedAmount__c;
            opp.Approved_ROI__c = fs.RateofInterest__c;
            opp.Approved_Tenure__c = fs.TenureYears__c;
            opp.RecordTypeId = '012S0000000f7LQIAY';
            opp.Credit_Score__c = 734;
            opp.Net_Income__c = 1200000;
            opp.Debt__c = 20000;
            /*
            if(accs.size()>0){
                opp.AccountId = accs[0].id;
            }
            */
            opp.CloseDate=date.today().addMonths(1);
            
            if(fs.Sanction_Decision__c=='Approved'){
                opp.StageName = 'Funding & Closing';
            } else {
                opp.StageName = 'Underwriting';
            }
            opp.AccountId=acc.Id;
            // opp.ContactId=cn.Id;
            // insert opp;
            opps.add(opp);
            
            // supporting objects for Opportunity
            Case c1 = new Case();
            c1.Opportunity_Id__c = opp.Id;
            c1.Loan_Application__c = opp.Id;
            c1.Related_Application__c = opp.Id;
            c1.Subject = 'Address Verification';
            c1.OwnerId = '005S000000HJap6';
            insert c1;
            Case c2 = new Case();
            c2.Opportunity_Id__c = opp.Id;
            c2.Loan_Application__c = opp.Id;
            c2.Related_Application__c = opp.Id;
            c2.Subject = 'Legal Verification';
            c2.OwnerId = '005S000000HJamS';
            insert c2;
            
            Loan_Account__c la = new Loan_Account__c();
            la.Disbursement__c =  fs.LoanRequestedAmount__c;
            la.Status__c = 'Active';
            la.Interest_Rate__c = 11;
            la.Name = 'LA-102';
            la.Parent_Application__c = opp.Id;
            insert la;
            
            Deviations__c dc1 = new Deviations__c();
            dc1.Opportunity__c = opp.Id;
            dc1.Name = 'Age Stability';
            insert dc1;
            // supporting objects end
            
            // Attachment cloning
            Attachment[] attList = [select id, name, body from Attachment where ParentId = '006S000000HN2C4IAL'];
            Attachment[] insertAttList = new Attachment[]{};
     System.debug('attList >> ' + attList);
                for(Attachment a: attList){
                    System.debug('name >> ' + a.name);
                    if(a.name == 'pan1.jpg'){
                        Attachment att = new Attachment(name = a.name, body = a.body, parentid = opp.Id, Description = 'PAN Document');
                        insertAttList.add(att);
                    } else if(a.name == 'Aadhaar.png'){
                        Attachment att = new Attachment(name = a.name, body = a.body, parentid = opp.Id, Description = 'Aadhaar Document');
                        insertAttList.add(att);
                    } else if(a.name == 'Bank statement.jpg'){
                        Attachment att = new Attachment(name = a.name, body = a.body, parentid = opp.Id, Description = 'Bank Documents');
                        insertAttList.add(att);
                    }
                
            }
            if(insertAttList.size() > 0)
            {
                insert insertAttList;
            }
            for(Attachment a: insertAttList){
                Document_Validation__c dv = new Document_Validation__c();
                dv.Parent_Record_ID__c = opp.Id;
                dv.Attachment__c = a.Id;
                dv.Status__c = 'Not Reviewed';
                insert dv;
            }
            // cloning ends
        }
        update(cns);
        // update(ans);
        update(opps);
    }
}