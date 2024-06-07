@IsTest
public class UploadKContact_ResWrap_Test {

    @IsTest
    static void testParse() {
        // Step 1: Prepare a sample JSON string that matches the structure of UploadKContact_ResWrap
        String jsonResponse = '{' +
            '"status": true,' +
            '"data": [' +
                '{' +
                    '"customer_id": 1,' +
                    '"user_unique_id": 12345,' +
                    '"unique_id": "uid123",' +
                    '"salesforce_contact_id": "0031t00000XYZ123",' +
                    '"contact_first_name": "John",' +
                    '"contact_last_name": "Doe",' +
                    '"contact_title": "Manager",' +
                    '"salesforce_account_id": "0011t00000ABC123",' +
                    '"contact_company_name": "Test Company",' +
                    '"contact_company_website_url": "https://testcompany.com",' +
                    '"contact_email": "john.doe@testcompany.com",' +
                    '"contact_company_status": "Active"' +
                '}' +
            '],' +
            '"message": "Success",' +
            '"status_code": 200,' +
            '"errors": null' +
        '}';

        // Step 2: Parse the JSON string into an UploadKContact_ResWrap instance
        UploadKContact_ResWrap response = UploadKContact_ResWrap.parse(jsonResponse);

        // Step 3: Verify the deserialized values
        System.assertEquals(true, response.status);
        System.assertEquals('Success', response.message);
        System.assertEquals(200, response.status_code);
        System.assertEquals(1, response.data.size());
        UploadKContact_ResWrap.Data dataItem = response.data[0];
        System.assertEquals(1, dataItem.customer_id);
        System.assertEquals(12345, dataItem.user_unique_id);
        System.assertEquals('uid123', dataItem.unique_id);
        System.assertEquals('0031t00000XYZ123', dataItem.salesforce_contact_id);
        System.assertEquals('John', dataItem.contact_first_name);
        System.assertEquals('Doe', dataItem.contact_last_name);
        System.assertEquals('Manager', dataItem.contact_title);
        System.assertEquals('0011t00000ABC123', dataItem.salesforce_account_id);
        System.assertEquals('Test Company', dataItem.contact_company_name);
        System.assertEquals('https://testcompany.com', dataItem.contact_company_website_url);
        System.assertEquals('john.doe@testcompany.com', dataItem.contact_email);
        System.assertEquals('Active', dataItem.contact_company_status);
    }
}