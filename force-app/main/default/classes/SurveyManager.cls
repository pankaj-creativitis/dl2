public class SurveyManager {
    @InvocableMethod(label='Resend survey contacts' description='Get Contacts for resending survey' category='Contact')
    public static List<List<Contact>> getResendContacts() {
        /*
        List<Id> ids = new List<Id>();
        for(Contact ct : passContacts){
            ids.add(ct.Id);
        }
        */
        List<Contact> cnts = [SELECT Id, Name, (SELECT Id, Name, email__c FROM Lead_emails__r 
                                                WHERE Survey_sent__c != true ORDER BY Confidence_score__c DESC LIMIT 1) FROM Contact WHERE
                              Time_since_record_entered_mailing_list__c > 60];
        
        List<Contact> contactsToUpdate = new List<Contact>();
        for (Contact cnt : cnts) {
            if (cnt.Lead_emails__r.size() > 0) {
                cnt.Email = cnt.Lead_emails__r[0].email__c;
                contactsToUpdate.add(cnt);
            }
        }
        update contactsToUpdate;
        List<List<Contact>> listofContacts = new List<List<Contact>>();
        listofContacts.add(contactsToUpdate);
        return listofContacts;
    }
}