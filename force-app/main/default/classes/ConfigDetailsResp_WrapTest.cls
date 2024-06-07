@isTest
public class ConfigDetailsResp_WrapTest {

    @isTest
    static void testParse() {
        // Sample JSON string to be deserialized
        String jsonString = '{"status": true, "data": {"customer_id": 123, "user_unique_id": 456, "user_first_name": "John", "user_last_name": "Doe", "user_title": "Mr.", "tracking_start_date": "2024-01-01", "tracking_end_date": "2024-12-31", "duration": "1 year", "frequency": "Monthly", "contact_limit": 100}, "message": "Success", "status_code": 200, "errors": {}}';

        // Parse the JSON string
        ConfigDetailsResp_Wrap response = ConfigDetailsResp_Wrap.parse(jsonString);

        // Assertions to validate the deserialization
        System.assertNotEquals(null, response, 'Response should not be null');
        System.assertEquals(true, response.status, 'Status should be true');
        System.assertEquals('Success', response.message, 'Message should be "Success"');
        System.assertEquals(200, response.status_code, 'Status code should be 200');

        // Assertions to validate the nested Data object
        System.assertNotEquals(null, response.data, 'Data should not be null');
        System.assertEquals(123, response.data.customer_id, 'Customer ID should be 123');
        System.assertEquals(456, response.data.user_unique_id, 'User unique ID should be 456');
        System.assertEquals('John', response.data.user_first_name, 'User first name should be "John"');
        System.assertEquals('Doe', response.data.user_last_name, 'User last name should be "Doe"');
        System.assertEquals('Mr.', response.data.user_title, 'User title should be "Mr."');
        System.assertEquals('2024-01-01', response.data.tracking_start_date, 'Tracking start date should be "2024-01-01"');
        System.assertEquals('2024-12-31', response.data.tracking_end_date, 'Tracking end date should be "2024-12-31"');
        System.assertEquals('1 year', response.data.duration, 'Duration should be "1 year"');
        System.assertEquals('Monthly', response.data.frequency, 'Frequency should be "Monthly"');
        System.assertEquals(100, response.data.contact_limit, 'Contact limit should be 100');
        
        // Assertions for the Errors object
        System.assertNotEquals(null, response.errors, 'Errors should not be null');
    }
}