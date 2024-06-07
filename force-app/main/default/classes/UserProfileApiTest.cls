@isTest
private class UserProfileApiTest {
    
    @isTest static void testUserProfile_ActiveConfig() {
        // Create test data for Integration_Metadata__mdt (Custom Metadata Type)
        Integration_Metadata__mdt activeConfig = new Integration_Metadata__mdt();
        activeConfig.Active__c = true;
        // Populate other required fields as needed
        //insert activeConfig;
        
        // Set up test data
        String testEmail = 'test@example.com';
        
        // Mocking HTTP callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(200));
        
        // Call the method to test
        Test.startTest();
        UserProfileAPI_RespWrapper result = UserProfileApi.UserProfile(testEmail);
        Test.stopTest();
        
        // Assert the results
        System.assertNotEquals(null, result, 'Result should not be null');
        // Add more assertions based on your expected behavior
    }
    
    // Other test methods...
    
    // Inner class to mock HTTP callout
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        private Integer statusCode;
        
        public MockHttpResponseGenerator(Integer statusCode) {
            this.statusCode = statusCode;
        }
        
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"example":"response"}');
            res.setStatusCode(statusCode);
            return res;
        }
    }
    
    
    //test method for UserProfileAPI_RespWrapper   
    @isTest
    static void testParse() {
        // Test JSON string
        String jsonString = '{"error":null,"status":true,"data":{"customer_id":123,"user_unique_id":456,"first_name":"John","last_name":"Doe","email":"john.doe@example.com","role":"Admin","organization_name":"Example Inc.","phone_number":"1234567890","phone_country_code":"+1","department":"IT","user_photo_url":null},"message":"Success","status_code":200,"errors":null}';
        
        // Call the parse method
        UserProfileAPI_RespWrapper result = UserProfileAPI_RespWrapper.parse(jsonString);
        
        // Assertions
        System.assertEquals(null, result.error, 'Error should be null');
        System.assertEquals(true, result.status, 'Status should be true');
        System.assertEquals('John', result.data.first_name, 'First name should match');
        System.assertEquals('Doe', result.data.last_name, 'Last name should match');
        System.assertEquals('john.doe@example.com', result.data.email, 'Email should match');
        System.assertEquals('Admin', result.data.role, 'Role should match');
        System.assertEquals('Example Inc.', result.data.organization_name, 'Organization name should match');
        System.assertEquals('1234567890', result.data.phone_number, 'Phone number should match');
        System.assertEquals('+1', result.data.phone_country_code, 'Phone country code should match');
        System.assertEquals('IT', result.data.department, 'Department should match');
        System.assertEquals(null, result.data.user_photo_url, 'User photo URL should be null');
        System.assertEquals('Success', result.message, 'Message should match');
        System.assertEquals(200, result.status_code, 'Status code should match');
        System.assertEquals(null, result.errors, 'Errors should be null');
    }
}