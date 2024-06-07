@isTest
public class ContactSelectorControllerTest {
    
    @testSetup
    static void setup() {
        // Create test Account and User
        User testUser = new User(
            FirstName = 'Anand',
            LastName = 'Kulkarni',
            Email = 'anand.kulkarni@test.com',
            Username = 'anand.kulkarni@test.com',
            Alias = 'akarni',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = [SELECT Id FROM Profile WHERE Name='Standard User'].Id,
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;
        
        Account testAccount = new Account(
            Name = 'Test Account',
            OwnerId = testUser.Id
        );
        insert testAccount;
        
        // Create test Contacts
        List<Contact> testContacts = new List<Contact>();
        for (Integer i = 0; i < 5; i++) {
            testContacts.add(new Contact(
                FirstName = 'Test',
                LastName = 'Contact' + i,
                Email = 'test.contact' + i + '@test.com',
                AccountId = testAccount.Id
            ));
        }
        insert testContacts;
    }
    
    @isTest
    static void testGetContacts() {
        // Set the current user context to the user with the name 'Anand Kulkarni'
        User testUser = [SELECT Id FROM User WHERE Username = 'anand.kulkarni@test.com' LIMIT 1];
        System.runAs(testUser) {
            // Call the method
            List<Contact> contacts = ContactSelectorController.getContacts();
            
            // Verify the results
            System.assertNotEquals(null, contacts, 'The contact list should not be null');
            System.assertEquals(5, contacts.size(), 'The contact list should have 5 contacts');
            
            for (Contact c : contacts) {
                System.assertEquals(testUser.Id, c.Account.OwnerId, 'The contact owner should be Anand Kulkarni');
            }
        }
    }
}