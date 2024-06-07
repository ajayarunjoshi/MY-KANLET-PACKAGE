@IsTest
public class TrackButtonControllerTest {
@testSetup
static void setup() {
    // Create test user
    User crmAdmin = new User(
        FirstName = 'CRM',
        LastName = 'Admin',
        Email = 'crmadmin@example.com',
        Username = 'crmadmin@example.com',
        Alias = 'crmadmin',
        TimeZoneSidKey = 'America/Los_Angeles',
        LocaleSidKey = 'en_US',
        EmailEncodingKey = 'UTF-8',
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id,
        LanguageLocaleKey = 'en_US'
    );
    insert crmAdmin;

    // Insert other necessary test data here, like Track_Request__c, Kanlet_License__c, K_Contact__c, etc.
}

    @IsTest
    static void testGetContacts_Success() {
        // Create test data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Contact testContact = new Contact(FirstName = 'John', LastName = 'Doe', Email = 'john.doe@test.com', AccountId = testAccount.Id);
        insert testContact;

        K_Contact__c testKContact = new K_Contact__c(First_Name__c = 'John', Last_Name__c = 'Doe', Email_Id__c = 'john.doe@test.com', 
                                                     Company_Website__c = 'https://testcompany.com', Company_Name__c = 'Test Company',
                                                     Job_Title__c = 'Manager', Contact__c = testContact.Id);
        insert testKContact;

        Kanlet_License__c testKanletLicense = new Kanlet_License__c(Customer_id__c = 2, User_Unique_Id__c = 2);
        insert testKanletLicense;

        Track_Request__c testTrackRequest = new Track_Request__c(Kanlet_Configuration__c = testKanletLicense.Id, Request_Status__c = 'In Preparation');
        insert testTrackRequest;

        Track_Request_Contact__c testTrackRequestContact = new Track_Request_Contact__c(Track_Request__c = testTrackRequest.Id, K_Contact__c = testKContact.Id);
        insert testTrackRequestContact;

        // Mocking the HTTP callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        Test.startTest();
        // Call the getContacts method
        String result = TrackButtonController.getContacts(testTrackRequest.Id);
        Test.stopTest();

        // Verify results
        System.assert(result.contains('Success'), 'The response should indicate success');
    }

    @IsTest
    static void testGetContacts_NoContacts() {
        // Create test data
        Kanlet_License__c testKanletLicense = new Kanlet_License__c(Customer_id__c = 2, User_Unique_Id__c = 2);
        insert testKanletLicense;

        Track_Request__c testTrackRequest = new Track_Request__c(Kanlet_Configuration__c = testKanletLicense.Id, Request_Status__c = 'In Preparation');
        insert testTrackRequest;

        Test.startTest();
        // Call the getContacts method
        String result = TrackButtonController.getContacts(testTrackRequest.Id);
        Test.stopTest();

        // Verify results
        System.assertEquals('You havent selected any contacts. Add the contact before you hit the track button.', result, 'The response should indicate no contacts selected');
    }

    @IsTest
    static void testUploadK_Success() {
        // Create test data
        List<UploadKContact_RequestWrap> inputwrapper = new List<UploadKContact_RequestWrap>();
        UploadKContact_RequestWrap reqWrap = new UploadKContact_RequestWrap();
        reqWrap.contact_first_name = 'John';
        reqWrap.contact_last_name = 'Doe';
        reqWrap.contact_email = 'john.doe@test.com';
        reqWrap.contact_company_website_url = 'https://testcompany.com';
        reqWrap.contact_company_name = 'Test Company';
        reqWrap.contact_title = 'Manager';
        reqWrap.contact_company_status = 'Target Account';
        reqWrap.user_unique_id = 2;
        reqWrap.customer_id = 2;
        inputwrapper.add(reqWrap);

        // Mocking the HTTP callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        Test.startTest();
        // Call the uploadK method
        String result = TrackButtonController.uploadK(inputwrapper, 'a04bn000000bGNZAA2', 1, new List<String>());
        Test.stopTest();

        // Verify results
        System.assertEquals('Success', result, 'The response should indicate success');
    }

    @IsTest
    static void testUploadK_Failure() {
        // Create test data
        List<UploadKContact_RequestWrap> inputwrapper = new List<UploadKContact_RequestWrap>();
        UploadKContact_RequestWrap reqWrap = new UploadKContact_RequestWrap();
        reqWrap.contact_first_name = 'John';
        reqWrap.contact_last_name = 'Doe';
        reqWrap.contact_email = 'john.doe@test.com';
        reqWrap.contact_company_website_url = 'https://testcompany.com';
        reqWrap.contact_company_name = 'Test Company';
        reqWrap.contact_title = 'Manager';
        reqWrap.contact_company_status = 'Active';
        reqWrap.unique_id = '123';
        reqWrap.user_unique_id = 2;
        reqWrap.customer_id = 2;
        reqWrap.salesforce_contact_id = '0031t00000XYZ123';
        reqWrap.salesforce_account_id = '0011t00000ABC123';
        inputwrapper.add(reqWrap);

        // Mocking the HTTP callout
        Test.setMock(HttpCalloutMock.class, new MockHttpErrorResponseGenerator());

        Test.startTest();
        // Call the uploadK method
        String result = TrackButtonController.uploadK(inputwrapper, 'a04bn000000bGNZAA2', 1, new List<String>());
        Test.stopTest();

        // Verify results
        System.assert(result.contains('error'), 'The response should indicate an error');
    }

    // Mock class for HTTP response generator
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"status": true, "data": [], "message": "Success", "status_code": 200, "errors": null}');
            res.setStatusCode(200);
            return res;
        }
    }

    // Mock class for HTTP error response generator
    private class MockHttpErrorResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"status": false, "data": [], "message": "error", "status_code": 400, "errors": ["Invalid request"]}');
            res.setStatusCode(400);
            return res;
        }
    }
}