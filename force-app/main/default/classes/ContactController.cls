public with sharing class ContactController {
    @AuraEnabled(cacheable=true)
    public static K_Processed_Contact__c getCareerEventsByEmail(string contactId) {
        
     K_Contact__c kContacts = [SELECT Id FROM K_Contact__c WHERE Contact__c = :contactId LIMIT 1];
          List<K_Processed_Contact__c> careerEvents =new List<K_Processed_Contact__c>();
        system.debug('kContacts --> '+kContacts);
        
       
           // String kContactId = kContacts.Id;
            
            // Query K_Processed_Contact__c records based on K_Contact__c ID
           careerEvents = [SELECT Id, Company__c, Job_Title__c, Contact_Status__c, New_Company__c, New_Designation__c ,
                           K_Contact__c,K_Contact__r.Contact__c
                                                          FROM K_Processed_Contact__c 
                                                          WHERE K_Contact__r.Contact__c = :contactId limit 1];
            system.debug('careerEvents--> '+careerEvents);
       
        
         return careerEvents[0];
    }
}