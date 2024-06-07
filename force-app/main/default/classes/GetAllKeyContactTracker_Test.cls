@isTest
public class GetAllKeyContactTracker_Test {

    @isTest
    static void testGetContactTracker() {
        // Test data setup
        GetAllKeyContactTracker_ReqWarp request = new GetAllKeyContactTracker_ReqWarp();
        request.customer_id = 123;
        request.user_unique_id = 456;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
       
        GetAllKeyContactTracker_RespWrap response = GetAllKeyContactTracker.GetContactTracker(request);
        
        
        Test.stopTest();
    }
    
    // Mock HTTP response generator class
    public class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"status": true, "data": [], "message": "Success", "status_code": 200, "errors": {}}');
            res.setStatusCode(200);
            return res;
        }
    }
 @isTest
    static void testParse5() {
        // Test JSON string
        String jsonString = '{"customer_id":123,"user_unique_id":456}';
        
        // Call the parse method
        GetAllKeyContactTracker_ReqWarp reqWarp = GetAllKeyContactTracker_ReqWarp.parse(jsonString);
        
        // Assertions
        System.assertEquals(123, reqWarp.customer_id, 'Customer ID should match');
        System.assertEquals(456, reqWarp.user_unique_id, 'User unique ID should match');
    }   
    
    
    @isTest
    static void testParse6() {
        // Test JSON string
        String jsonString = '{"status":true,"data":{},"message":"Success","status_code":200,"errors":{}}';
        
        // Call the parse method
        GetAllKeyContactTracker_RespWrap respWrap = GetAllKeyContactTracker_RespWrap.parse(jsonString);
        
        // Assertions
        System.assertEquals(true, respWrap.status, 'Status should be true');
        System.assertNotEquals(null, respWrap.data, 'Data should not be null');
        System.assertEquals('Success', respWrap.message, 'Message should match');
        System.assertEquals(200, respWrap.status_code, 'Status code should match');
        System.assertNotEquals(null, respWrap.errors, 'Errors should not be null');
    }
    
}