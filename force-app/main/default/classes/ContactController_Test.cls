@IsTest
public class ContactController_Test {
    
    @IsTest
    static void testGetCareerEventsByEmail() {
        // Step 1: Create test data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Contact testContact = new Contact(LastName = 'Test', Email = 'test@example.com', AccountId = testAccount.Id);
        insert testContact;
        
        K_Contact__c kContact = new K_Contact__c(Contact__c = testContact.Id);
        insert kContact;
        
        K_Processed_Contact__c kProcessedContact = new K_Processed_Contact__c(
            K_Contact__c = kContact.Id,
            Company__c = 'Old Company',
            Job_Title__c = 'Old Title',
            Contact_Status__c = 'Old Status',
            New_Company__c = 'New Company',
            New_Designation__c = 'New Title'
        );
        insert kProcessedContact;
        
        // Step 2: Call the method under test
        Test.startTest();
        K_Processed_Contact__c result = ContactController.getCareerEventsByEmail(testContact.Id);
        Test.stopTest();
        
        // Step 3: Verify the results
        System.assertNotEquals(null, result, 'Result should not be null');
        System.assertEquals(kProcessedContact.Id, result.Id, 'Result Id should match the inserted K_Processed_Contact__c record');
        System.assertEquals('Old Company', result.Company__c, 'Company should match');
        System.assertEquals('Old Title', result.Job_Title__c, 'Job Title should match');
        System.assertEquals('Old Status', result.Contact_Status__c, 'Contact Status should match');
        System.assertEquals('New Company', result.New_Company__c, 'New Company should match');
        System.assertEquals('New Title', result.New_Designation__c, 'New Designation should match');
    }

    @IsTest
    static void testGetCareerEventsByEmail_NoKContact() {
        // Step 1: Create a test Contact without a K_Contact__c record
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Contact testContact = new Contact(LastName = 'Test', Email = 'test@example.com', AccountId = testAccount.Id);
        insert testContact;
        
        // Step 2: Call the method under test and handle the exception
        Test.startTest();
        K_Processed_Contact__c result;
        try {
            result = ContactController.getCareerEventsByEmail(testContact.Id);
            System.assert(false, 'Method should have thrown an exception');
        } catch (Exception e) {
            System.assert(true, 'Method correctly threw an exception');
        }
        Test.stopTest();
    }

    @IsTest
    static void testGetCareerEventsByEmail_NoProcessedContact() {
        // Step 1: Create a test Contact with a K_Contact__c record but no K_Processed_Contact__c record
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Contact testContact = new Contact(LastName = 'Test', Email = 'test@example.com', AccountId = testAccount.Id);
        insert testContact;
        
        K_Contact__c kContact = new K_Contact__c(Contact__c = testContact.Id);
        insert kContact;
        
        // Step 2: Call the method under test and handle the exception
        Test.startTest();
        K_Processed_Contact__c result;
        try {
            result = ContactController.getCareerEventsByEmail(testContact.Id);
            System.assert(false, 'Method should have thrown an exception');
        } catch (Exception e) {
            System.assert(true, 'Method correctly threw an exception');
        }
        Test.stopTest();
    }
}