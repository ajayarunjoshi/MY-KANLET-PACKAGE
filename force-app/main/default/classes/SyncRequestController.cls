public class SyncRequestController {

    // Method to send Sync_Request_Contact__c records to Kanlet through API
    public static void sendRecordsToKanlet(Id trackRequestId) {
        Track_Request__c trackRequest = [SELECT Id, Name FROM Track_Request__c WHERE Id = :trackRequestId];

        List<Track_Request_Contact__c> trackReqContacts = [SELECT Id, Name, Track_Request__c FROM Track_Request_Contact__c WHERE Track_Request__c  = :trackRequestId];

        // Construct JSON payload to send to Kanlet
        List<Map<String, Object>> recordsToSend = new List<Map<String, Object>>();
        for (Track_Request_Contact__c trackReqContact : trackReqContacts) {
            Map<String, Object> record = new Map<String, Object>();
            record.put('contactId', trackReqContact.K_Contact__c); // Assuming K_Contact__c is the field holding contact Id
            // Add more fields as needed
            recordsToSend.add(record);
        }

        String jsonPayload = JSON.serialize(recordsToSend);

        // Make HTTP request to Kanlet API endpoint
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://kanlet-api.com'); // Replace with actual Kanlet API endpoint
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(jsonPayload);

        // Make the callout
        Http http = new Http();
        HttpResponse res = http.send(req);

        // Check the response
        if (res.getStatusCode() != 200) {
            // Handle error
            System.debug('Error while sending records to Kanlet: ' + res.getBody());
        } else {
            // Handle success
            System.debug('Records successfully sent to Kanlet');
        }
    } 
}