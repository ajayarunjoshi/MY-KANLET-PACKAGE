public with sharing class FileredDataTableController {    
    
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccount() {
        try {
            return [SELECT Id, Name, Owner.Name, OwnerId, Industry, Website, Region__c FROM Account];
        } catch (Exception e) {
            throw new AuraHandledException('Error fetching accounts: ' + e.getMessage());
        }
    }
    
   
    
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContact(List<Id> selectedAccounts, String recordId) {
        
        try {
            // Fetching Track_Request_Contact__c records associated with the current track request
            List<Track_Request_Contact__c> trackRequestContacts = [
                SELECT k_Contact__c 
                FROM Track_Request_Contact__c 
                WHERE Track_Request__c = :recordId
            ];
            
            List<Track_Request__c>trackRequest =[SELECT Id,Kanlet_Configuration__c FROM Track_Request__c WHERE Id =:recordId ];
            String configId = trackRequest[0].Kanlet_Configuration__c;
            List<Kanlet_License__c> kanletConfig = [SELECT Id,Contact_Limit__c FROM Kanlet_License__c WHERE Id=:configId ];
            
            System.debug('Contact Limit ==>'+kanletConfig[0].Contact_Limit__c );
            
            Integer trackRequestContactCount= trackRequestContacts.size();
            String trackRequestContactCounts = string.valueOf(trackRequestContactCount);
            
            System.debug('Track Request Contact==>'+trackRequestContactCounts);
            
            // Extract the list of k_Contact__c IDs associated with the current track request
            Set<Id> associatedKContactIds = new Set<Id>();
            for (Track_Request_Contact__c trc : trackRequestContacts) {
                associatedKContactIds.add(trc.k_Contact__c);
            }
            
            
            List<k_Contact__c> kContacts = [
                SELECT Id, Contact__c, Contact__r.AccountId 
                FROM k_Contact__c 
                WHERE Id = :associatedKContactIds
            ];
            
            // Extract the list of Contact IDs from the k_Contact__c records
            Set<Id> kContactIds = new Set<Id>();
            for (k_Contact__c kc : kContacts) {
                kContactIds.add(kc.Contact__c);
            }
            
            // Fetch Contacts from the selected accounts
            List<Contact> contacts = [
                SELECT Id, FirstName, LastName, Title, Account.Website, AccountId, Account.Name, Email 
                FROM Contact 
                WHERE AccountId IN :selectedAccounts
                AND Id NOT IN :kContactIds
            ];
            
            return contacts;
        } catch (Exception e) {
            throw new AuraHandledException('Error fetching contacts: ' + e.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> getAcountIndustryPicklist() {
        try {
            List<Schema.PicklistEntry> entries = Account.Industry.getDescribe().getPicklistValues();
            return convertPicklistEntriesToMap(entries);
        } catch (Exception e) {
            throw new AuraHandledException('Error fetching account industry picklist values: ' + e.getMessage());
        }
    }
    
    
    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> getAcountRegion() {
        try {
            List<Schema.PicklistEntry> entries = Account.Region__c.getDescribe().getPicklistValues();
            return convertPicklistEntriesToMap(entries);
        } catch (Exception e) {
            throw new AuraHandledException('Error fetching account region picklist values: ' + e.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Account> getFilteredAccounts(String industry, String region, String ownerName,String accountName) {
        try {
            String query = 'SELECT Id, Name, OwnerId, Owner.FirstName, Owner.LastName, Owner.Name, Region__c, Industry, Website FROM Account ';
            
            // Construct the WHERE clause based on provided filter parameters
            List<String> conditions = new List<String>();
            if (industry != null) {
                conditions.add('Industry = :industry');
            }
            if (region != null) {
                conditions.add('Region__c = :region');
            }
            if (ownerName != null) {
                conditions.add('Owner.Name LIKE :ownerName');
            }if (accountName != null) {
                conditions.add('Name LIKE :accountName');
            }
            
            // Construct the WHERE clause by joining the conditions with 'AND'
            if (!conditions.isEmpty()) {
                query += ' WHERE ' + String.join(conditions, ' AND ');
            }
            
            // Log the constructed query for debugging purposes
            system.debug('Query---' + query);
            
            // Execute the query and return the result
            return Database.query(query);
        } catch (Exception e) {
            throw new AuraHandledException('Error fetching filtered accounts: ' + e.getMessage());
        }
    }
    
    @AuraEnabled
    public static String createContacts(List<Map<String, Object>> Kcontacts, String contactId, String recordId) {
        //  public static List<K_Contact__c> createContacts(List<Map<String, Object>> Kcontacts, String contactId, String recordId) {
        System.debug('Contacts==>' + contactId);
        List<K_Contact__c> newKContacts = new List<K_Contact__c>();
        Set<String> errorMessages = new Set<String>();
        //   try {
        for (Map<String, Object> kcontactsMap : Kcontacts) {
            K_Contact__c newKContact = new K_Contact__c();
            newKContact.Contact__c = (String) kcontactsMap.get('contactId');
            
            if(String.isNotBlank((String) kcontactsMap.get('First_Name'))){
                newKContact.First_Name__c = (String) kcontactsMap.get('First_Name');
            }
            else{
                errorMessages.add('Contact First Name is mandatory.');
            }
            if(String.isNotBlank((String) kcontactsMap.get('Last_Name'))){
              newKContact.Last_Name__c = (String) kcontactsMap.get('Last_Name');
            }
            else{
                errorMessages.add('Contact Last Name is mandatory.');
            }
            if(String.isNotBlank((String) kcontactsMap.get('JobTitle'))){
              newKContact.Job_Title__c = (String) kcontactsMap.get('JobTitle');
            }
            else{
                errorMessages.add('Contact Job title is mandatory.');
            }
            if(String.isNotBlank((String) kcontactsMap.get('EmailId'))){
             newKContact.Email_Id__c = (String) kcontactsMap.get('EmailId');
            }
            else{
                errorMessages.add('Contact Email is mandatory.');
            }
            if(String.isNotBlank((String) kcontactsMap.get('Company'))){
             newKContact.Company_Name__c = (String) kcontactsMap.get('Company');
            }
            else{
                errorMessages.add('Contact Email is mandatory.');
            }
             if(String.isNotBlank((String) kcontactsMap.get('website'))){
              String websiteValue = (String) kcontactsMap.get('website');
                  System.debug('Website Value: ' + websiteValue); // Check the retrieved value
            newKContact.Company_Website__c = websiteValue != null ? websiteValue : '';
            System.debug('Assigned Website: ' + newKContact.Company_Website__c); 
            }
            else{
                errorMessages.add('Contact Website is mandatory.');
            }
           
           // Check the assigned value	
            newKContacts.add(newKContact);
        }
          if (!errorMessages.isEmpty()) {
                 return String.join(new List<String>(errorMessages), ', ');
            }
        if (!newKContacts.isEmpty()) {
            insert newKContacts;
            
            
            List<Track_Request_Contact__c> trackRequestContacts = new List<Track_Request_Contact__c>();
            
            for (K_Contact__c kContact : newKContacts) {
                Track_Request_Contact__c trackRequestContact = new Track_Request_Contact__c();
                
                // Set fields on Track_Request_Contact__c related to K_Contact__c
                trackRequestContact.K_Contact__c = kContact.Id;
                trackRequestContact.Track_Request__c = recordId; // Set the Track Request record ID
                
                trackRequestContacts.add(trackRequestContact);
            }
            // Insert Track_Request_Contact__c records
            if (!trackRequestContacts.isEmpty()) {
                insert trackRequestContacts;
                System.debug('Track_Request_Contact__c inserted successfully. IDs: ' + trackRequestContacts);
            } else {
                System.debug('No Track_Request_Contact__c records to insert.');
            }
        } else {
            System.debug('No K_Contacts to insert.');
        }
       
        
        /*} catch (DmlException dmlEx) {
throw new AuraHandledException('Error inserting K_Contacts or Track_Request_Contacts: ' + dmlEx.getDmlMessage(0));
} catch (Exception e) {
throw new AuraHandledException('An unexpected error occurred while inserting K_Contacts: ' + e.getMessage());
} */
        return 'Success';
        //   return newKContacts;
    }
    
    private static List<Map<String, String>> convertPicklistEntriesToMap(List<Schema.PicklistEntry> entries) {
        List<Map<String, String>> values = new List<Map<String, String>>();
        for (Schema.PicklistEntry entry : entries) {
            Map<String, String> valueMap = new Map<String, String>();
            valueMap.put('label', entry.getLabel());
            valueMap.put('value', entry.getValue());
            values.add(valueMap);
        }
        return values;
    }
}