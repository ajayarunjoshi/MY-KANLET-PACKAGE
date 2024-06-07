public with sharing class ContactJsonController {
    
    @AuraEnabled(cacheable=true)
    public static String getContactsJson(String trackRequestId) {
        // Query Track_Request_Contact__c records based on the Track_Request Id
        List<Track_Request_Contact__c> trackRequestContacts = [SELECT Id, K_Contact__c
                                                               FROM Track_Request_Contact__c 
                                                               WHERE Track_Request__c = :trackRequestId];
        
        List<Id> kContactIds = new List<Id>();
        Map<Id, Id> kContactToTrackRequestContactMap = new Map<Id, Id>();
        
        // Collect K_Contact__c Ids and map K_Contact__c Ids to Track_Request_Contact__c Ids
        for (Track_Request_Contact__c trackRequestContact : trackRequestContacts) {
            kContactIds.add(trackRequestContact.K_Contact__c);
            kContactToTrackRequestContactMap.put(trackRequestContact.K_Contact__c, trackRequestContact.Id);
        }
        
        // Query K_Contact__c records based on the collected Ids
        List<K_Contact__c> kContacts = [SELECT Id, Name, Contact__c /* Add more fields as needed */ 
                                         FROM K_Contact__c 
                                         WHERE Id IN :kContactIds];
        
        // Query Contact records associated with K_Contact__c records via the K_Contact__c.Contact__c lookup
        List<Contact> contacts = [SELECT Id, Name, Email, Phone,Firstname,LastName,Account.Website /* Add more fields as needed */ 
                                  FROM Contact 
                                  WHERE Id IN (SELECT Contact__c FROM K_Contact__c WHERE Id IN :kContactIds)];
        UploadKContact_RequestWrap resWrap= new UploadKContact_RequestWrap();
        for(Contact con: contacts){           
            resWrap.contact_first_name=con.Firstname;
            resWrap.contact_last_name=con.LastName;
            resWrap.contact_email=con.Email;
            resWrap.contact_company_website_url=con.Account.Website;
        }
        
        List<UploadKContact_RequestWrap> reqLst=new List<UploadKContact_RequestWrap>();
     	reqLst.add(resWrap);
        UploadKeyContact.uploadK(reqLst);
        // Build JSON object
        List<Map<String, Object>> jsonResult = new List<Map<String, Object>>();
        for (K_Contact__c kContact : kContacts) {
            Map<String, Object> contactMap = new Map<String, Object>();
            contactMap.put('K_Contact_Id', kContact.Id);
            contactMap.put('K_Contact_Name', kContact.Name);
            
            // Find associated Contact record
            Id trackRequestContactId = kContactToTrackRequestContactMap.get(kContact.Id);
            Contact associatedContact = null;
            for (Contact contact : contacts) {
                if (contact.Id == kContact.Contact__c) {
                    associatedContact = contact;
                    break;
                }
            }
            
            // Add Contact fields to JSON if found
            if (associatedContact != null) {
                contactMap.put('Contact_Id', associatedContact.Id);
                contactMap.put('Contact_Name', associatedContact.Name);
                contactMap.put('Contact_Email', associatedContact.Email);
                contactMap.put('Contact_Phone', associatedContact.Phone);
               
            }
            
            jsonResult.add(contactMap);
        }
        system.debug('jsonResult--> '+jsonResult);
        system.debug('JSON.serialize(jsonResult)--> '+JSON.serialize(jsonResult));
        // Convert JSON result to string
        return JSON.serialize(jsonResult);
    }
}