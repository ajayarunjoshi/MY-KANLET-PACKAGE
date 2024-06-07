@isTest
public class LoginTokenConfigController1Test {
    
    @isTest
    static void testGetToken() {
        // Create a mock HTTP response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Call the method to test
        LoginTokenConfigController1.LoginToken_ResponseWrap response = LoginTokenConfigController1.getToken();

        // Validate the response
        System.assertNotEquals(null, response, 'Response should not be null');
        System.assertEquals(true, response.status, 'Status should be true');
        System.assertEquals('Success', response.message, 'Message should be "Success"');
        System.assertEquals(200, response.status_code, 'Status code should be 200');
        System.assertNotEquals(null, response.data, 'Data should not be null');
        System.assertEquals(123, response.data.user_unique_id, 'User unique ID should be 123');
        System.assertEquals('John', response.data.first_name, 'First name should be "John"');
        System.assertEquals('Doe', response.data.last_name, 'Last name should be "Doe"');
        System.assertEquals('john.doe@example.com', response.data.email, 'Email should be "john.doe@example.com"');
        System.assertEquals('dummy_refresh_token', response.data.refresh_token, 'Refresh token should be "dummy_refresh_token"');
        System.assertEquals('dummy_access_token', response.data.access_token, 'Access token should be "dummy_access_token"');
        System.assertEquals(456, response.data.customer_id, 'Customer ID should be 456');
    }

    // Mock HTTP response generator
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Create a mock response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody('{"status": true, "data": {"user_unique_id": 123, "first_name": "John", "last_name": "Doe", "email": "john.doe@example.com", "refresh_token": "dummy_refresh_token", "access_token": "dummy_access_token", "customer_id": 456}, "message": "Success", "status_code": 200, "errors": {}}');
            return res;
        }
    }
}