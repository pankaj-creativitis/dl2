public with sharing class ContactAuthController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactList(string recId) {
        return [
            SELECT Id, Name, MobilePhone, Title, Email, Employer_Name__c, AccountId, Account.Name
            FROM Contact
            WHERE Id = :recId
        ];
    }
}