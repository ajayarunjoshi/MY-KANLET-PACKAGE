@IsTest
public class UploadKContact_RequestWrap_Test {

    @IsTest
    static void testParseValidJson() {
        // Step 1: Create a valid JSON string
        String jsonString = '[{' +
            '"customer_id": 1,' +
            '"user_unique_id": 123,' +
            '"unique_id": "unique123",' +
            '"salesforce_contact_id": "0036F00002Hkf8OQAR",' +
            '"contact_first_name": "John",' +
            '"contact_last_name": "Doe",' +
            '"contact_title": "CEO",' +
            '"salesforce_account_id": "0016F00002Hkf8OQAR",' +
            '"contact_company_name": "Doe Inc.",' +
            '"contact_company_website_url": "https://doe.com",' +
            '"contact_email": "john.doe@doe.com",' +
            '"contact_company_status": "Active"' +
        '}]';

        // Step 2: Parse the JSON string into a list of UploadKContact_RequestWrap objects
        List<UploadKContact_RequestWrap> reqWrapList = UploadKContact_RequestWrap.parse(jsonString);

        // Step 3: Assert that the parsed list has one object with the expected values
        System.assertEquals(1, reqWrapList.size());
        UploadKContact_RequestWrap reqWrap = reqWrapList[0];
        System.assertEquals(1, reqWrap.customer_id);
        System.assertEquals(123, reqWrap.user_unique_id);
        System.assertEquals('unique123', reqWrap.unique_id);
        System.assertEquals('0036F00002Hkf8OQAR', reqWrap.salesforce_contact_id);
        System.assertEquals('John', reqWrap.contact_first_name);
        System.assertEquals('Doe', reqWrap.contact_last_name);
        System.assertEquals('CEO', reqWrap.contact_title);
        System.assertEquals('0016F00002Hkf8OQAR', reqWrap.salesforce_account_id);
        System.assertEquals('Doe Inc.', reqWrap.contact_company_name);
        System.assertEquals('https://doe.com', reqWrap.contact_company_website_url);
        System.assertEquals('john.doe@doe.com', reqWrap.contact_email);
        System.assertEquals('Active', reqWrap.contact_company_status);
    }

    @IsTest
    static void testParseEmptyJson() {
        // Step 1: Create an empty JSON string
        String jsonString = '[]';

        // Step 2: Parse the JSON string into a list of UploadKContact_RequestWrap objects
        List<UploadKContact_RequestWrap> reqWrapList = UploadKContact_RequestWrap.parse(jsonString);

        // Step 3: Assert that the parsed list is empty
        System.assertEquals(0, reqWrapList.size());
    }

    @IsTest
    static void testParseMalformedJson() {
        // Step 1: Create a malformed JSON string
        String jsonString = '[{' +
            '"customer_id": 1,' +
            '"user_unique_id": 123,' +
            '"unique_id": "unique123",' +
            '"salesforce_contact_id": "0036F00002Hkf8OQAR",' +
            '"contact_first_name": "John",' +
            '"contact_last_name": "Doe",' +
            '"contact_title": "CEO",' +
            '"salesforce_account_id": "0016F00002Hkf8OQAR",' +
            '"contact_company_name": "Doe Inc.",' +
            '"contact_company_website_url": "https://doe.com",' +
            '"contact_email": "john.doe@doe.com",' +
            '"contact_company_status": "Active"' +
        // Missing closing brace for the object and closing bracket for the array
        '';

        // Step 2: Attempt to parse the JSON string and handle the expected exception
        try {
            List<UploadKContact_RequestWrap> reqWrapList = UploadKContact_RequestWrap.parse(jsonString);
            System.assert(false, 'Expected exception due to malformed JSON');
        } catch (System.JSONException e) {
            System.assert(true, 'Caught expected JSON exception: ' + e.getMessage());
        }
    }
}