public with sharing class ContactSelectorController {
    
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts() {
        System.debug('Fetching contacts...');
        List<Contact> contacts = [SELECT Id, Name, Email, CreatedDate, AccountId, Account.OwnerId
FROM Contact where account.owner.name='Anand Kulkarni'];
        for (Contact c : contacts) {
            System.debug('Contact: ' + c);
        }
        return contacts;
    }
}