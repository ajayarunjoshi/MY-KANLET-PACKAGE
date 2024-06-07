@isTest
private class ContactJsonControllerTest {
    
    @isTest
    static void testGetContactsJson() {
        
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        
        Kanlet_License__c kanletLicense = new Kanlet_License__c();
        insert kanletLicense;
        
        
        Track_Request__c trackRequest = new Track_Request__c(
            Kanlet_Configuration__c = kanletLicense.Id
        );
        insert trackRequest;
        
        
        Contact testContact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'john.doe@example.com',
            Phone = '1234567890',
            AccountId = testAccount.Id 
        );
        insert testContact;
        
        
        K_Contact__c testKContact = new K_Contact__c(
            Contact__c = testContact.Id,
            Job_Title__c = 'Manager', 
            Last_Name__c = 'Doe',  
            First_Name__c = 'John', 
            Company_Name__c = 'Test Company' 
        );
        insert testKContact;
        
        
        Track_Request_Contact__c testTrackRequestContact = new Track_Request_Contact__c(
            Track_Request__c = trackRequest.Id,
            K_Contact__c = testKContact.Id
        );
        insert testTrackRequestContact;
        
        Test.startTest();
        String resultJson = ContactJsonController.getContactsJson(trackRequest.Id);
        Test.stopTest();
        
        
        System.assertNotEquals(null, resultJson, 'Result JSON string should not be null');
        
        
    }
}