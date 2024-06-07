public with sharing class KanletDataController {
    
    @AuraEnabled(cacheable=true)  
    public static K_Processed_Contact__c getKanletData(string contactId) {
        
        //   K_Contact__c kcontact= [SELECT Id FROM K_Contact__c WHERE Contact__c =:contactId];
        // Query career events based on the email ID
        List<K_Processed_Contact__c> careerEvents = [SELECT Id, Company__c, Job_Title__c, Contact_Status__c, New_Company__c, New_Designation__c ,
                                                     K_Contact__c,K_Contact__r.Contact__c FROM K_Processed_Contact__c 
                                                     WHERE K_Contact__r.Contact__c = :contactId limit 1];
        
        System.debug('Number of career events found: ' + careerEvents.size());
        system.debug('careerEvents--> '+careerEvents);
        
        return careerEvents[0];
    }
}