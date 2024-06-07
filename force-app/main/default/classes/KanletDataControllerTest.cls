@isTest
public class KanletDataControllerTest {

    @isTest
    static void testGetKanletData() {

        Contact testContact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'john.doe@example.com'
        );
        insert testContact;
        
        
        K_Contact__c testKContact = new K_Contact__c(
            Contact__c = testContact.Id,
            Job_Title__c = 'Product Manager',
            Last_Name__c = 'Doe',
            First_Name__c = 'John',
            Company_Name__c = 'Summit Industries'
        );
        insert testKContact;
        
        
        K_Processed_Contact__c testKProcessedContact = new K_Processed_Contact__c(
            K_Contact__c = testKContact.Id,
            Company__c = 'Summit Industries',
            Job_Title__c = 'Product Manager',
            Contact_Status__c = 'Left',
            Last_Name__c = 'Doe', 
            First_Name__c = 'John'
        );
        insert testKProcessedContact;
        
        Test.startTest();
        
        K_Processed_Contact__c result = KanletDataController.getKanletData(testContact.Id);
        Test.stopTest();
        
        
        System.assertEquals('Summit Industries', result.Company__c);
        System.assertEquals('Product Manager', result.Job_Title__c);
        System.assertEquals('Left', result.Contact_Status__c);
        
        
        System.assertNotEquals(null, result.K_Contact__c);
    }
}