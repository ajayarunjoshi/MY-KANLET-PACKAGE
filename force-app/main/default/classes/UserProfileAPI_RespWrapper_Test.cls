@IsTest
public class UserProfileAPI_RespWrapper_Test {

    @IsTest
    static void testParseValidJson() {
        // Step 1: Create a valid JSON string
        String jsonString = '{' +
            '"status": true,' +
            '"data": {' +
                '"customer_id": 1,' +
                '"user_unique_id": 123,' +
                '"first_name": "John",' +
                '"last_name": "Doe",' +
                '"email": "john.doe@example.com",' +
                '"role": "Admin",' +
                '"organization_name": "Example Org",' +
                '"phone_number": "1234567890",' +
                '"phone_country_code": "+1",' +
                '"department": "IT",' +
                '"user_photo_url": "https://example.com/photo.jpg"' +
            '},' +
            '"message": "Success",' +
            '"status_code": 200,' +
            '"errors": null' +
        '}';

        // Step 2: Parse the JSON string into a UserProfileAPI_RespWrapper object
        UserProfileAPI_RespWrapper respWrapper = UserProfileAPI_RespWrapper.parse(jsonString);

        // Step 3: Assert that the parsed object has the expected values
        System.assertEquals(true, respWrapper.status);
        System.assertEquals(1, respWrapper.data.customer_id);
        System.assertEquals(123, respWrapper.data.user_unique_id);
        System.assertEquals('John', respWrapper.data.first_name);
        System.assertEquals('Doe', respWrapper.data.last_name);
        System.assertEquals('john.doe@example.com', respWrapper.data.email);
        System.assertEquals('Admin', respWrapper.data.role);
        System.assertEquals('Example Org', respWrapper.data.organization_name);
        System.assertEquals('1234567890', respWrapper.data.phone_number);
        System.assertEquals('+1', respWrapper.data.phone_country_code);
        System.assertEquals('IT', respWrapper.data.department);
        System.assertEquals('https://example.com/photo.jpg', String.valueOf(respWrapper.data.user_photo_url));
        System.assertEquals('Success', respWrapper.message);
        System.assertEquals(200, respWrapper.status_code);
        System.assertEquals(null, respWrapper.errors);
    }

    @IsTest
    static void testParseEmptyJson() {
        // Step 1: Create an empty JSON string
        String jsonString = '{}';

        // Step 2: Parse the JSON string into a UserProfileAPI_RespWrapper object
        UserProfileAPI_RespWrapper respWrapper = UserProfileAPI_RespWrapper.parse(jsonString);

        // Step 3: Assert that the parsed object has default values
        System.assertEquals(null, respWrapper.status);
        System.assertEquals(null, respWrapper.data);
        System.assertEquals(null, respWrapper.message);
        System.assertEquals(null, respWrapper.status_code);
        System.assertEquals(null, respWrapper.errors);
    }

    @IsTest
    static void testParseMalformedJson() {
        // Step 1: Create a malformed JSON string
        String jsonString = '{' +
            '"status": true,' +
            '"data": {' +
                '"customer_id": 1,' +
                '"user_unique_id": 123,' +
                '"first_name": "John",' +
                '"last_name": "Doe",' +
                '"email": "john.doe@example.com",' +
                '"role": "Admin",' +
                '"organization_name": "Example Org",' +
                '"phone_number": "1234567890",' +
                '"phone_country_code": "+1",' +
                '"department": "IT",' +
                '"user_photo_url": "https://example.com/photo.jpg"' +
            // Missing closing brace for the object and for the main JSON
        '';

        // Step 2: Attempt to parse the JSON string and handle the expected exception
        try {
            UserProfileAPI_RespWrapper respWrapper = UserProfileAPI_RespWrapper.parse(jsonString);
            System.assert(false, 'Expected exception due to malformed JSON');
        } catch (System.JSONException e) {
            System.assert(true, 'Caught expected JSON exception: ' + e.getMessage());
        }
    }
}