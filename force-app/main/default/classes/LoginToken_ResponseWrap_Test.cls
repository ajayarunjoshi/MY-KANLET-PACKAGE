@isTest
public class LoginToken_ResponseWrap_Test {

    @isTest
    static void LoginToken_Response1() {
       
        String jsonStr = '{"status": true, "data": {"user_unique_id": 123, "first_name": "John", "last_name": "Doe", "email": "john.doe@example.com", "refresh_token": "refresh_token_value", "access_token": "access_token_value", "customer_id": 456}, "message": "Success", "status_code": 200, "errors": {}}';


        LoginToken_ResponseWrap wrapObj = LoginToken_ResponseWrap.parse(jsonStr);

        System.assertNotEquals(null, wrapObj);
        System.assertEquals(true, wrapObj.status);
        System.assertEquals('Success', wrapObj.message);
        System.assertEquals(200, wrapObj.status_code);

        System.assertNotEquals(null, wrapObj.data);
        System.assertEquals(123, wrapObj.data.user_unique_id);
        System.assertEquals('John', wrapObj.data.first_name);
        System.assertEquals('Doe', wrapObj.data.last_name);
        System.assertEquals('john.doe@example.com', wrapObj.data.email);
        System.assertEquals('refresh_token_value', wrapObj.data.refresh_token);
        System.assertEquals('access_token_value', wrapObj.data.access_token);
        System.assertEquals(456, wrapObj.data.customer_id);
    }
}