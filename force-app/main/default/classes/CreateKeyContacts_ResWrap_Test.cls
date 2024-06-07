@IsTest
public class CreateKeyContacts_ResWrap_Test {

    @IsTest
    static void testParseValidJson() {
        // Step 1: Create a valid JSON string
        String jsonString = '{' +
            '"status": true,' +
            '"data": {},' +
            '"message": "Success",' +
            '"status_code": 200,' +
            '"errors": {}' +
        '}';

        // Step 2: Parse the JSON string into a CreateKeyContacts_ResWrap object
        CreateKeyContacts_ResWrap resWrap = CreateKeyContacts_ResWrap.parse(jsonString);

        // Step 3: Assert that the parsed object has the expected values
        System.assertEquals(true, resWrap.status);
        System.assertNotEquals(null, resWrap.data);
        System.assertEquals('Success', resWrap.message);
        System.assertEquals(200, resWrap.status_code);
        System.assertNotEquals(null, resWrap.errors);
    }

    @IsTest
    static void testParseEmptyJson() {
        // Step 1: Create an empty JSON string
        String jsonString = '{}';

        // Step 2: Parse the JSON string into a CreateKeyContacts_ResWrap object
        CreateKeyContacts_ResWrap resWrap = CreateKeyContacts_ResWrap.parse(jsonString);

        // Step 3: Assert that the parsed object has null values for the properties
        System.assertEquals(null, resWrap.status);
        System.assertEquals(null, resWrap.data);
        System.assertEquals(null, resWrap.message);
        System.assertEquals(null, resWrap.status_code);
        System.assertEquals(null, resWrap.errors);
    }

    @IsTest
    static void testParseMalformedJson() {
        // Step 1: Create a malformed JSON string
        String jsonString = '{ "status": true, "data": {}, "message": "Success", "status_code": 200, "errors": ';

        // Step 2: Attempt to parse the JSON string and handle the expected exception
        try {
            CreateKeyContacts_ResWrap resWrap = CreateKeyContacts_ResWrap.parse(jsonString);
            System.assert(false, 'Expected exception due to malformed JSON');
        } catch (System.JSONException e) {
            System.assert(true, 'Caught expected JSON exception: ' + e.getMessage());
        }
    }
}