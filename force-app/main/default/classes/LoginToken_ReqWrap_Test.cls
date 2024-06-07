@isTest
public class LoginToken_ReqWrap_Test {

    @isTest
    static void testParse() {
        // Test JSON string
        String jsonStr = '{"email": "test@example.com", "password": "testpassword"}';

        // Call the parse method
        LoginToken_ReqWrap wrapObj = LoginToken_ReqWrap.parse(jsonStr);

        // Verify the result
        System.assertNotEquals(null, wrapObj);
        System.assertEquals('test@example.com', wrapObj.email);
        System.assertEquals('testpassword', wrapObj.password);
    }
}