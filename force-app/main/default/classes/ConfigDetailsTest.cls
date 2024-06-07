@isTest
public class ConfigDetailsTest {

    @isTest
    static void testConfigDetail() {
        // Setup test data
        Kanlet_License__c licenseRecord = new Kanlet_License__c(Customer_id__c = 123, User_Unique_Id__c = 456);
        insert licenseRecord;

        // Call the method and verify results
        Kanlet_License__c result = ConfigDetails.configDetail(licenseRecord.Id);
        System.assertNotEquals(null, result, 'License record should not be null');
        System.assertEquals(licenseRecord.Id, result.Id, 'License record Id should match');
    }

    @isTest
    static void testGetConfigDetails() {
        // Mock HTTP callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Call the method
        Test.startTest();
        ConfigDetails.getConfigDetails();
        Test.stopTest();

        // Verify the results
        List<Kanlet_License__c> licenses = [SELECT Id, First_Name__c, Last_Name__c, User_Unique_ID__c, Customer_ID__c FROM Kanlet_License__c];
        System.debug('License records after getConfigDetails: ' + licenses);
        System.assertEquals(1, licenses.size(), 'There should be one license record');
        Kanlet_License__c license = licenses[0];
        System.assertEquals('Shripad', license.First_Name__c, 'First name should be "John"');
        System.assertEquals('Kulkarni', license.Last_Name__c, 'Last name should be "Doe"');
        System.assertEquals(2, license.User_Unique_ID__c, 'User unique ID should be 2');
        System.assertEquals(2, license.Customer_ID__c, 'Customer ID should be 2');
    }

    @isTest
    static void testConfigurationDetails() {
        // Setup test data
        Kanlet_License__c licenseRecord = new Kanlet_License__c(Customer_id__c = 123, User_Unique_Id__c = 456);
        insert licenseRecord;

        // Mock HTTP callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Call the method
        Test.startTest();
        ConfigDetails.ConfigurationDetails(licenseRecord.Id, 'dummy_access_token');
        Test.stopTest();

        // Verify the results
        Kanlet_License__c updatedLicense = [SELECT Id, First_Name__c, Last_Name__c, Job_Title__c, Frequency__c, Tracking_Start_Date__c, Tracking_End_Date__c, Duration__c, Contact_Limit__c FROM Kanlet_License__c WHERE Id = :licenseRecord.Id];
        System.debug('Updated License record after ConfigurationDetails: ' + updatedLicense);
        updatedLicense.First_Name__c= 'Shripad';
        System.assertEquals('Kulkarni', updatedLicense.Last_Name__c, 'Last name should be "Kulkarni"');
        System.assertEquals('Developer', updatedLicense.Job_Title__c, 'Job title should be "Developer"');
        System.assertEquals('Monthly', updatedLicense.Frequency__c, 'Frequency should be "Monthly"');
        System.assertEquals(Date.valueOf('2024-01-01'), updatedLicense.Tracking_Start_Date__c, 'Tracking start date should be "2024-01-01"');
        System.assertEquals(Date.valueOf('2024-12-31'), updatedLicense.Tracking_End_Date__c, 'Tracking end date should be "2024-12-31"');
        System.assertEquals('1 year', updatedLicense.Duration__c, 'Duration should be "1 year"');
        System.assertEquals(100, updatedLicense.Contact_Limit__c, 'Contact limit should be 100');
    }

    @isTest
    static void testConfigurationDetailsFuture() {
        // Setup test data
        Kanlet_License__c licenseRecord = new Kanlet_License__c(Customer_id__c = 123, User_Unique_Id__c = 456);
        insert licenseRecord;

        // Mock HTTP callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Call the future method
        Test.startTest();
        ConfigDetails.ConfigurationDetailsFuture(licenseRecord.Id, 'dummy_access_token');
        Test.stopTest();

        // Verify the results
        Kanlet_License__c updatedLicense = [SELECT Id, First_Name__c, Last_Name__c, Job_Title__c, Frequency__c, Tracking_Start_Date__c, Tracking_End_Date__c, Duration__c, Contact_Limit__c FROM Kanlet_License__c WHERE Id = :licenseRecord.Id];
        System.debug('Updated License record after ConfigurationDetailsFuture: ' + updatedLicense);
        System.assertEquals('Shripad', updatedLicense.First_Name__c, 'First name should be "John"');
        System.assertEquals('Kulkarni', updatedLicense.Last_Name__c, 'Last name should be "Doe"');
        System.assertEquals('Developer', updatedLicense.Job_Title__c, 'Job title should be "Developer"');
        System.assertEquals('Monthly', updatedLicense.Frequency__c, 'Frequency should be "Monthly"');
        System.assertEquals(Date.valueOf('2024-01-01'), updatedLicense.Tracking_Start_Date__c, 'Tracking start date should be "2024-01-01"');
        System.assertEquals(Date.valueOf('2024-12-31'), updatedLicense.Tracking_End_Date__c, 'Tracking end date should be "2024-12-31"');
        System.assertEquals('1 year', updatedLicense.Duration__c, 'Duration should be "1 year"');
        System.assertEquals(100, updatedLicense.Contact_Limit__c, 'Contact limit should be 100');
    }

    // Mock HTTP response generator
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Create a mock response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody('{"status": true, "data": {"user_unique_id": 2, "first_name": "Shripad", "last_name": "Kulkarni", "user_title": "Developer", "frequency": "Monthly", "tracking_start_date": "2024-01-01", "tracking_end_date": "2024-12-31", "duration": "1 year", "contact_limit": 100}, "message": "Success", "status_code": 200, "errors": {}}');
            return res;
        }
    }
}