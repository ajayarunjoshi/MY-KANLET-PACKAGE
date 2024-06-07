@isTest
public class ICPUpdateController_Test {

    @isTest
    static void testUpdateICP_Success() {
        // Create a test user
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User testUser = new User(Alias = 'standt', Email='megha.bhoyar@kriosispl.in',
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                                 LocaleSidKey='en_US', ProfileId = p.Id,
                                 TimeZoneSidKey='America/Los_Angeles', UserName='crm@.com');

        insert testUser;

        // Create a test Kanlet License record
        Kanlet_License__c kanletLicense = new Kanlet_License__c(
            Customer_Id__c = 123,
            User_Unique_Id__c = 456
        );
        insert kanletLicense;

        // Mock the request JSON
        String requestBody = '{"data":{"customer_id":123,"user_unique_id":456,"customer_name":"Test Customer","industry":["IT","Healthcare"],"update_date":"2024-06-05"}}';

        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/api/updateICPDetails/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(requestBody);
        RestContext.request = req;

        // Set the mock HTTP response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Call the REST endpoint
        Test.startTest();
        RestResponse res = RestContext.response;
        ICPUpdateController.updateICP();
        Test.stopTest();

        // Verify response and logic
        System.assertEquals(200, res.statusCode);
        System.assertEquals('ICP updated successfully.', res.responseBody.toString());
    }

    @isTest
    static void testUpdateICP_EmptyRequestBody() {
        // Mock the request with empty JSON body
        String requestBody = '';

        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/api/updateICPDetails/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(requestBody);
        RestContext.request = req;

        // Call the REST endpoint
        Test.startTest();
        RestResponse res = RestContext.response;
        ICPUpdateController.updateICP();
        Test.stopTest();

        // Verify response and logic
        System.assertEquals(400, res.statusCode);
        System.assertEquals('No data to process.', res.responseBody.toString());
    }

    @isTest
    static void testUpdateICP_NoKanletLicenseRecordFound() {
        // Mock the request with JSON body
        String requestBody = '{"data":{"customer_id":123,"user_unique_id":456,"customer_name":"Test Customer","industry":["IT","Healthcare"],"update_date":"2024-06-05"}}';

        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/api/updateICPDetails/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(requestBody);
        RestContext.request = req;

        // Set the mock HTTP response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorNoKanletLicense());

        // Call the REST endpoint
        Test.startTest();
        RestResponse res = RestContext.response;
        ICPUpdateController.updateICP();
        Test.stopTest();

        // Verify response and logic
        System.assertEquals(404, res.statusCode);
        System.assertEquals('No matching Kanlet_License__c record found.', res.responseBody.toString());
    }

    @isTest
    static void testUpdateICP_NoICPRecordFound() {
        // Mock the request with JSON body
        String requestBody = '{"data":{"customer_id":123,"user_unique_id":456,"customer_name":"Test Customer","industry":["IT","Healthcare"],"update_date":"2024-06-05"}}';

        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/api/updateICPDetails/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(requestBody);
        RestContext.request = req;

        // Set the mock HTTP response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorNoICPRecord());

        // Call the REST endpoint
        Test.startTest();
        RestResponse res = RestContext.response;
        ICPUpdateController.updateICP();
        Test.stopTest();

        // Verify response and logic
        System.assertEquals(404, res.statusCode);
        System.assertEquals('No matching ICP__c record found.', res.responseBody.toString());
    }

    @isTest
    static void testUpdateICP_Exception() {
        // Mock the request with JSON body
        String requestBody = '{"data":{"customer_id":123,"user_unique_id":456,"customer_name":"Test Customer","industry":["IT","Healthcare"],"update_date":"2024-06-05"}}';

        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/api/updateICPDetails/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(requestBody);
        RestContext.request = req;

        // Set the mock HTTP response to cause an exception
        //Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorException());

        // Call the REST endpoint
        Test.startTest();
        RestResponse res = RestContext.response;
        ICPUpdateController.updateICP();
        Test.stopTest();

        // Verify response and logic
        System.assertEquals(500, res.statusCode);
        System.assertEquals('Failed to update ICP.', res.responseBody.toString());
    }

    // Mock HTTP response class for successful scenarios
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Create a mock response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"Result":"ICP updated successfully.","RecordIds":"001000000000000AAA"}');
            res.setStatusCode(200);
            return res;
        }
    }

    // Mock HTTP response class for no Kanlet License record found
    private class MockHttpResponseGeneratorNoKanletLicense implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Create a mock response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"Result":"No matching Kanlet_License__c record found.","ErrorMsg":"No Kanlet_License__c record found for the given userUniqueId and customerId."}');
            res.setStatusCode(404);
            return res;
        }
    }

    // Mock HTTP response class for no ICP record found
    private class MockHttpResponseGeneratorNoICPRecord implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Create a mock response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"Result":"No matching ICP__c record found.","ErrorMsg":"No ICP__c record found for the given Kanlet_License__c Id."}');
            res.setStatusCode(404);
            return res;
        }
    }

    // Mock HTTP response class to cause an exception
   /* private class MockHttpResponseGeneratorException implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Create a mock response that throws an exception
            HttpResponse res = new HttpResponse();
            res.setStatusCode(500);
            res.setStatus('Internal Server Error');
            res.setBody('{"Result":"Failed to update ICP.","ErrorMsg":"Exception in callout"}');
            return res;
        }*/
    }