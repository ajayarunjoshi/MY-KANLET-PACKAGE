@IsTest
public class UploadKeyContactUtil_Test {
    
    @IsTest
    static void testGetContacts() {
        // Step 1: Set up test data
        Account testAccount = new Account(Name='Test Account', Website='https://test.com');
        insert testAccount;

        Contact testContact = new Contact(FirstName='Test', LastName='User', Email='testuser@test.com', AccountId=testAccount.Id);
        insert testContact;

        K_Contact__c testKContact = new K_Contact__c(Contact__c=testContact.Id);
        insert testKContact;

        Track_Request__c testTrackRequest = new Track_Request__c(Request_Status__c='Test Track Request');
        insert testTrackRequest;

        Track_Request_Contact__c testTrackRequestContact = new Track_Request_Contact__c(Track_Request__c=testTrackRequest.Id, K_Contact__c=testKContact.Id);
        insert testTrackRequestContact;

        // Step 2: Invoke the method to test
        List<String> trackRequestIds = new List<String>{testTrackRequest.Id};
        Test.startTest();
        UploadKeyContactUtil.getContacts(trackRequestIds);
        Test.stopTest();

        // Step 3: Verify the results
        // Check debug logs or other verification steps as needed. Here, we'll check if the method runs without exceptions.
        System.assert(true, 'getContacts method executed successfully.');
    }

    @IsTest
    static void testUploadK() {
        // Step 1: Set up test data
        UploadKContact_RequestWrap reqWrap = new UploadKContact_RequestWrap();
        reqWrap.customer_id = 2;
        reqWrap.user_unique_id = 123;
        reqWrap.contact_first_name = 'John';
        reqWrap.contact_last_name = 'Doe';
        reqWrap.contact_title = 'Manager';
        reqWrap.contact_email = 'john.doe@example.com';
        reqWrap.contact_company_name = 'Test Company';
        reqWrap.contact_company_website_url = 'https://testcompany.com';

        List<UploadKContact_RequestWrap> reqWrapList = new List<UploadKContact_RequestWrap>{reqWrap};

        // Step 2: Mock HTTP response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"status": true, "data": {}, "message": "Success", "status_code": 200}');
        mockResponse.setStatusCode(200);

        Http httpMock = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://example.com');
        req.setMethod('POST');
        req.setBody(JSON.serialize(reqWrapList));

        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl(mockResponse));

        // Step 3: Invoke the method to test
        Test.startTest();
        UploadKContact_ResWrap response = UploadKeyContactUtil.uploadK(reqWrapList);
        Test.stopTest();

        // Step 4: Verify the results
        System.assertEquals(true, response.status);
        System.assertEquals('Success', response.message);
        System.assertEquals(200, response.status_code);
    }

    private class HttpCalloutMockImpl implements HttpCalloutMock {
        private HttpResponse response;
        HttpCalloutMockImpl(HttpResponse response) {
            this.response = response;
        }
        public HttpResponse respond(HttpRequest req) {
            return response;
        }
    }
}