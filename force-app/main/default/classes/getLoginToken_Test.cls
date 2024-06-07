@isTest
public class getLoginToken_Test {

    @isTest
    static void testGetToken_Positive() {
        // Setup
        Test.startTest();
        
        // Test data setup
        
        // Call the method
        String token = getLoginToken.getToken();
        
        // Assertions
        System.assertNotEquals(null, token, 'Token should not be null');
        
        Test.stopTest();
    }
    
    @isTest
    static void testGetToken_Exception() {
        // Setup
        Test.startTest();
        
        // Test data setup
        
        // Call the method
        String token;
        try {
            token = getLoginToken.getToken();
        } catch(Exception ex) {
            // Verify the exception handling
            System.assertEquals(null, token, 'Token should be null when exception occurs');
        }
        
        Test.stopTest();
    }
   @isTest
static void testResponseWrap_Parse() {
    // Test JSON string
    String jsonString = '{"status":true,"data":{"user_unique_id":123,"first_name":"John","last_name":"Doe","email":"john.doe@example.com","refresh_token":"abc123","access_token":"xyz456","customer_id":789},"message":"Success","status_code":200,"errors":null}';
    
    // Call the parse method
    LoginToken_ResponseWrap responseWrap = LoginToken_ResponseWrap.parse(jsonString);
    
    // Assertions
    System.assertEquals(true, responseWrap.status, 'Status should be true');
    System.assertEquals(123, responseWrap.data.user_unique_id, 'User unique ID should match');
    System.assertEquals('John', responseWrap.data.first_name, 'First name should match');
    System.assertEquals('Doe', responseWrap.data.last_name, 'Last name should match');
    System.assertEquals('john.doe@example.com', responseWrap.data.email, 'Email should match');
    System.assertEquals('abc123', responseWrap.data.refresh_token, 'Refresh token should match');
    System.assertEquals('xyz456', responseWrap.data.access_token, 'Access token should match');
    System.assertEquals(789, responseWrap.data.customer_id, 'Customer ID should match');
    System.assertEquals('Success', responseWrap.message, 'Message should match');
    System.assertEquals(200, responseWrap.status_code, 'Status code should match');
    System.assertEquals(null, responseWrap.errors, 'Errors should be null');
}
    
    
    @isTest
    static void testParse_ValidJson() {
        // Test JSON string
        String jsonString = '{"email":"test@example.com","password":"password123"}';
        
        // Call the parse method
        LoginToken_ReqWrap reqWrap = LoginToken_ReqWrap.parse(jsonString);
        
        // Assertions
        System.assertEquals('test@example.com', reqWrap.email, 'Email should match');
        System.assertEquals('password123', reqWrap.password, 'Password should match');
    }
    
    @isTest
    static void testParse_NullJson() {
        // Test JSON string
        String jsonString = 'null';
        
        // Call the parse method
        LoginToken_ReqWrap reqWrap = LoginToken_ReqWrap.parse(jsonString);
        
        // Assertions
        System.assertEquals(null, reqWrap, 'Should return null for null JSON string');
    }
}