public with sharing class ContactJourneyController {		
    
    @AuraEnabled
    public static K_Processed_Contact__c getCareerEventsByContactId(string contactId) {
       // Contact con= [SELECT Id,Name,FirstName,LastName,Job_Title__c,AccountId FROM Contact WHERE Id=:contactId];
     //   K_Contact__c kContacts = [SELECT Id FROM K_Contact__c WHERE Contact__c = :contactId LIMIT 1];
          List<K_Processed_Contact__c> careerEvents =new List<K_Processed_Contact__c>();
      //  system.debug('kContacts --> '+kContacts);
           // String kContactId = kContacts.Id;
           careerEvents = [SELECT Id, Company__c,First_Name__c,ContactId__c,Last_Name__C, Job_Title__c, Contact_Status__c, New_Company__c, New_Designation__c ,
                           K_Contact__c,K_Contact__r.Contact__c,Action_Taken__c FROM K_Processed_Contact__c 
                           WHERE ContactId__c=:contactId OR K_Contact__r.Contact__c=:contactId limit 1];
        system.debug('ContactId__c--> '+careerEvents[0].ContactId__c);
        system.debug('contactId--> '+contactId);
        system.debug('K_Contact__r.Contact__c--> '+careerEvents[0].K_Contact__r.Contact__c);
      //  system.debug('ContactId__c--> '+ContactId__c);
            system.debug('careerEvents--> '+careerEvents);
       
        
         return careerEvents[0];
    }
}