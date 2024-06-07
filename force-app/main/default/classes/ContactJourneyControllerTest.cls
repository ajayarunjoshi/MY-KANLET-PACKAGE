@isTest
private class ContactJourneyControllerTest {

    @isTest
    static void testGetCareerEventsByContactId() {
        // Create test data
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact'
            // Add any other required fields
        );
        insert testContact;

        K_Processed_Contact__c testCareerEvent = new K_Processed_Contact__c(
            First_Name__c = 'TestFirstName',
            Last_Name__c = 'TestLastName',
            ContactId__c = testContact.Id
            // Add any other required fields
        );
        insert testCareerEvent;

        // Call the method being tested
        Test.startTest();
        K_Processed_Contact__c result = ContactJourneyController.getCareerEventsByContactId(testContact.Id);
        Test.stopTest();

        // Assert the results
        System.assertEquals(testCareerEvent.Id, result.Id);
        // Add more assertions as needed
    }
}