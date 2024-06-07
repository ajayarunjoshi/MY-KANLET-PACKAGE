@IsTest
private class ProcessedContactsControllerTest {
    
    @IsTest
    static void testCreateProcessedContactsEmptyBody() {
        // Set up the test with an empty request body
        RestContext.request = new RestRequest();
        RestContext.response = new RestResponse();
        RestContext.request.requestBody = Blob.valueOf('');

        Test.startTest();
        ProcessedContactsController.ResultResponse res = ProcessedContactsController.createProcessedContacts();
        Test.stopTest();

        // Assert the response
        
        System.assertEquals(200, RestContext.response.statusCode);
        System.assertEquals(500, RestContext.response.statusCode);
        System.assertEquals(400, RestContext.response.statusCode);
      //  System.assertEquals('Request body is empty.', res.ErrorMsg);
       // System.assertEquals('No data to process.', res.Result);
    }

    @IsTest
    static void testCreateProcessedContactsNoData() {
        // Create test user
        User crmAdmin = createTestUser('CRM Admin');

        // Create a request body with no data
        String requestBody = '{ "data": [] }';
        RestContext.request = new RestRequest();
        RestContext.response = new RestResponse();
        RestContext.request.requestBody = Blob.valueOf(requestBody);

        Test.startTest();
        ProcessedContactsController.ResultResponse res = ProcessedContactsController.createProcessedContacts();
        Test.stopTest();

        // Assert the response
        System.assertEquals(400, RestContext.response.statusCode);
        //System.assertEquals('Request body does not contain valid data.', res.ErrorMsg);
//        System.assertEquals('No data to process.', res.Result);

        // Verify that a track log record is created
       /* List<Track_Log__c> trackLogs = [SELECT Error__c, Response__c FROM Track_Log__c WHERE Request__c = :requestBody];/**
        System.assertEquals(1, trackLogs.size());
        System.assertEquals('Request body does not contain valid data.', trackLogs[0].Error__c);
        System.assert(trackLogs[0].Response__c.contains(res.ErrorMsg), 'Response should contain the error message');*/
    }

    @IsTest
    static void testCreateProcessedContactsValidData() {
        // Create test user
        User crmAdmin = createTestUser('CRM Admin');

        // Create a valid request body
        String requestBody = '{ "data": [ { "contact_first_name": "John", "contact_last_name": "Doe", "new_company_name": "Acme Corp", "new_company_website_url": "http://acme.com", "new_designation": "Manager", "new_email_id": "john.doe@acme.com", "previos_company_name": "Old Corp", "previos_website": "http://oldcorp.com", "previos_designation": "Associate", "previos_email_Id": "john.doe@oldcorp.com", "unique_id": "001", "start_date": "2023-01-01" } ] }';
        RestContext.request = new RestRequest();
        RestContext.response = new RestResponse();
        RestContext.request.requestBody = Blob.valueOf(requestBody);

        Test.startTest();
        ProcessedContactsController.ResultResponse res = ProcessedContactsController.createProcessedContacts();
        Test.stopTest();

        // Assert the response
        System.assertEquals(200, RestContext.response.statusCode);
  //      System.assertEquals('Key contacts uploaded successfully.', res.Result);
       // System.assertEquals(1, res.RecordIds.size());

        // Verify record in the database
/*        List<K_Processed_Contact__c> contacts = [SELECT Id, First_Name__c, Last_Name__c, New_Company__c FROM K_Processed_Contact__c WHERE Id IN :res.RecordIds];
        System.assertEquals(1, contacts.size());
        System.assertEquals('John', contacts[0].First_Name__c);
        System.assertEquals('Doe', contacts[0].Last_Name__c);
        System.assertEquals('Acme Corp', contacts[0].New_Company__c);*/
    }

    @IsTest
    static void testCreateProcessedContactsInvalidDate() {
        // Create test user
        User crmAdmin = createTestUser('CRM Admin');

        // Create a request body with an invalid date
        String requestBody = '{ "data": [ { "contact_first_name": "John", "contact_last_name": "Doe", "new_company_name": "Acme Corp", "new_company_website_url": "http://acme.com", "new_designation": "Manager", "new_email_id": "john.doe@acme.com", "previos_company_name": "Old Corp", "previos_website": "http://oldcorp.com", "previos_designation": "Associate", "previos_email_Id": "john.doe@oldcorp.com", "unique_id": "001", "start_date": "invalid-date" } ] }';
        RestContext.request = new RestRequest();
        RestContext.response = new RestResponse();
        RestContext.request.requestBody = Blob.valueOf(requestBody);

        Test.startTest();
        ProcessedContactsController.ResultResponse res;
        try {
            res = ProcessedContactsController.createProcessedContacts();
        } catch (Exception e) {
            res = null;
        }
        Test.stopTest();

        // Assert the response
        System.assertEquals(400, RestContext.response.statusCode);
        System.assertNotEquals(null, res);
        //System.assert(res.ErrorMsg.contains('Invalid date format'), 'Error message should indicate invalid date format');
    }

    // Utility method to create a test user
    private static User createTestUser(String userName) {
        Profile p = [SELECT Id FROM Profile WHERE Name='CRM Admin' LIMIT 1];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles',
            UserName='crmadmin@kanlet.in.dev' + DateTime.now().getTime() + '@testorg.com');
        insert u;
        return u;
    }
    
    
    
}