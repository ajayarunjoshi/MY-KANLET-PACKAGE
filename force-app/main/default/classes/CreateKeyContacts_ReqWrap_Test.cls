@IsTest
public class CreateKeyContacts_ReqWrap_Test {

    @IsTest
    static void testParseValidJson() {
        // Step 1: Create a valid JSON string
        String jsonString = '{' +
            '"customer_id": "2",' +
            '"customer_name": "Krios Info Solution",' +
            '"user_unique_id": "2",' +
            '"industry": [{}],' +
            '"employee_count": [{}],' +
            '"location_country": [{}],' +
            '"location_state": [{}],' +
            '"location_city": [{}],' +
            '"revenue": [{}],' +
            '"job_title_function": [{}],' +
            '"job_title_seniority": [{}],' +
            '"job_title": [{}],' +
            '"last_funding_status": [{}],' +
            '"tech_stack": [{}]' +
        '}';

        // Step 2: Parse the JSON string into a CreateKeyContacts_ReqWrap object
        CreateKeyContacts_ReqWrap reqWrap = CreateKeyContacts_ReqWrap.parse(jsonString);

        // Step 3: Assert that the parsed object has the expected values
        System.assertEquals('2', reqWrap.customer_id);
        System.assertEquals('Krios Info Solution', reqWrap.customer_name);
        System.assertEquals('2', reqWrap.user_unique_id);
        System.assertEquals(1, reqWrap.industry.size());
        System.assertEquals(1, reqWrap.employee_count.size());
        System.assertEquals(1, reqWrap.location_country.size());
        System.assertEquals(1, reqWrap.location_state.size());
        System.assertEquals(1, reqWrap.location_city.size());
        System.assertEquals(1, reqWrap.revenue.size());
        System.assertEquals(1, reqWrap.job_title_function.size());
        System.assertEquals(1, reqWrap.job_title_seniority.size());
        System.assertEquals(1, reqWrap.job_title.size());
        System.assertEquals(1, reqWrap.last_funding_status.size());
        System.assertEquals(1, reqWrap.tech_stack.size());
    }

    @IsTest
    static void testParseEmptyJson() {
        // Step 1: Create an empty JSON string
        String jsonString = '{}';

        // Step 2: Parse the JSON string into a CreateKeyContacts_ReqWrap object
        CreateKeyContacts_ReqWrap reqWrap = CreateKeyContacts_ReqWrap.parse(jsonString);

        // Step 3: Assert that the parsed object has null values for the properties
        System.assertEquals(null, reqWrap.customer_id);
        System.assertEquals(null, reqWrap.customer_name);
        System.assertEquals(null, reqWrap.user_unique_id);
        System.assertEquals(null, reqWrap.industry);
        System.assertEquals(null, reqWrap.employee_count);
        System.assertEquals(null, reqWrap.location_country);
        System.assertEquals(null, reqWrap.location_state);
        System.assertEquals(null, reqWrap.location_city);
        System.assertEquals(null, reqWrap.revenue);
        System.assertEquals(null, reqWrap.job_title_function);
        System.assertEquals(null, reqWrap.job_title_seniority);
        System.assertEquals(null, reqWrap.job_title);
        System.assertEquals(null, reqWrap.last_funding_status);
        System.assertEquals(null, reqWrap.tech_stack);
    }

    @IsTest
    static void testParseMalformedJson() {
        // Step 1: Create a malformed JSON string
        String jsonString = '{ "customer_id": "2", "customer_name": "Krios Info Solution", "user_unique_id": "2", "industry": [ ';

        // Step 2: Attempt to parse the JSON string and handle the expected exception
        try {
            CreateKeyContacts_ReqWrap reqWrap = CreateKeyContacts_ReqWrap.parse(jsonString);
            System.assert(false, 'Expected exception due to malformed JSON');
        } catch (System.JSONException e) {
            System.assert(true, 'Caught expected JSON exception: ' + e.getMessage());
        }
    }
}