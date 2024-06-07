@isTest
private class CreateKeyContacts_Test {

    @isTest
    static void testCreateKeyContactSpecs_Success() {
        // Test data setup
        CreateKeyContacts_ReqWrap request = new CreateKeyContacts_ReqWrap();
        // Set up your request data here
        
        // Mock HTTP callout
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(false));
        
        // Call the method
        CreateKeyContacts_ResWrap response = CreateKeyContacts.CreateKeyContactSpecs(request);
        
        // Assertions for success scenario
        // Verify response data and behavior
        
        Test.stopTest();
    }

    @isTest
    static void testCreateKeyContactSpecs_Error() {
        // Test data setup
        CreateKeyContacts_ReqWrap request = new CreateKeyContacts_ReqWrap();
        // Set up your request data here
        
        // Mock HTTP callout to simulate an error response
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(true)); // Pass true to indicate error response
        
        // Call the method
        CreateKeyContacts_ResWrap response = CreateKeyContacts.CreateKeyContactSpecs(request);
        
        // Assertions for error scenario
        // Verify error handling behavior
        
        Test.stopTest();
    }

    // Mock HTTP response generator class
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        private Boolean simulateError;

        public MockHttpResponseGenerator(Boolean simulateError) {
            this.simulateError = simulateError;
        }

        public HTTPResponse respond(HTTPRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            if (simulateError) {
                res.setStatusCode(500); // Simulate an error response
                res.setBody('{"error": "Internal Server Error"}');
            } else {
                res.setStatusCode(200); // Simulate a success response
                res.setBody('{"status": true, "message": "Success"}');
            }
            return res;
        }
    }
    
    
      @isTest
    static void testParse7() {
        // Test JSON string
        String jsonString = '{"customer_id": 123, "customer_name": "Test Company", "user_unique_id": 456, "industry": ["Technology", "Finance"], "employee_count": ["100-500", "500-1000"], "location_country": ["USA", "Canada"], "location_state": ["CA", "NY"], "location_city": ["San Francisco", "New York City"], "revenue": ["$1M-$10M", "$10M-$100M"], "job_title_function": ["Engineering", "Sales"], "job_title_seniority": ["Senior", "Executive"], "job_title": ["Software Engineer", "Sales Manager"], "last_funding_status": ["Seed", "Series A"], "tech_stack": ["Java", "Salesforce"]}';

        // Call the parse method
        CreateKeyContacts_ReqWrap reqWrap = CreateKeyContacts_ReqWrap.parse(jsonString);

        // Assertions
        System.assertEquals(123, reqWrap.customer_id, 'Customer ID should match');
        System.assertEquals('Test Company', reqWrap.customer_name, 'Customer name should match');
        System.assertEquals(456, reqWrap.user_unique_id, 'User unique ID should match');
        System.assertEquals(2, reqWrap.industry.size(), 'Industry list size should be 2');
        System.assertEquals('Technology', reqWrap.industry[0], 'First industry should match');
        System.assertEquals('Finance', reqWrap.industry[1], 'Second industry should match');
        // Add more assertions for other fields and lists
    }
    
    
    @isTest
    static void testParse8() {
        // Test JSON string
        String jsonString = '{"status": true, "data": {}, "message": "Success", "status_code": 200, "errors": {}}';

        // Call the parse method
        CreateKeyContacts_ResWrap resWrap = CreateKeyContacts_ResWrap.parse(jsonString);

        // Assertions
        System.assertEquals(true, resWrap.status, 'Status should be true');
        System.assertEquals('Success', resWrap.message, 'Message should match');
        System.assertEquals(200, resWrap.status_code, 'Status code should match');
        // Add more assertions as needed
    }
    
    
}