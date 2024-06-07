public class UploadKeyContactUtil {
    
    @InvocableMethod(label='Fetch Track Request')
    public static void getContacts(List<String> trackRequestId) {
        //  if(inputs != null && inputs.size() > 0) {
        //      TrackReqInput input = inputs[0]; // Accessing the first element
        
        // Query Track_Request_Contact__c records based on the Track_Request Id
        List<Track_Request_Contact__c> trackRequestContacts = [SELECT Id, K_Contact__c
                                                               FROM Track_Request_Contact__c 
                                                               WHERE Track_Request__c = :trackRequestId];
        
        List<Id> kContactIds = new List<Id>();
        Map<Id, Id> kContactToTrackRequestContactMap = new Map<Id, Id>();
        
        // Collect K_Contact__c Ids and map K_Contact__c Ids to Track_Request_Contact__c Ids
        for (Track_Request_Contact__c trackRequestContact : trackRequestContacts) {
            kContactIds.add(trackRequestContact.K_Contact__c);
            kContactToTrackRequestContactMap.put(trackRequestContact.K_Contact__c, trackRequestContact.Id);
        }
        
        // Query K_Contact__c records based on the collected Ids
        List<K_Contact__c> kContacts = [SELECT Id, Name, Contact__c 
                                        FROM K_Contact__c 
                                        WHERE Id IN :kContactIds];
        
        // Query Contact records associated with K_Contact__c records via the K_Contact__c.Contact__c lookup
        List<Contact> contacts = [SELECT Id, Name, Email, Phone, FirstName, LastName, Account.Website
                                  FROM Contact 
                                  WHERE Id IN (SELECT Contact__c FROM K_Contact__c WHERE Id IN :kContactIds)];
        
        List<UploadKContact_RequestWrap> reqLst = new List<UploadKContact_RequestWrap>();
        for(Contact con: contacts) {           
            UploadKContact_RequestWrap reqWrap = new UploadKContact_RequestWrap();
            reqWrap.contact_first_name = con.FirstName;
            reqWrap.contact_last_name = con.LastName;
            reqWrap.contact_email = con.Email;
            reqWrap.contact_company_website_url = con.Account.Website;
            reqWrap.customer_id=2;
            reqWrap.contact_company_name=con.Account.Name;
            //reqWrap.contact_company_status='Test';
            reqWrap.contact_title=con.Title;
            reqLst.add(reqWrap);
        }            
        uploadK(reqLst);
    }
     
   
 @AuraEnabled 
    public static UploadKContact_ResWrap uploadK(List<UploadKContact_RequestWrap> inputwrapper) {
        String requestBody1 = '';
        UploadKContact_ResWrap auth1 = new UploadKContact_ResWrap();
        Integration_Metadata__mdt apiConfig = Integration_Metadata__mdt.getInstance('Upload_Key_Contacts');
        //getLoginToken tokenProvider = new getLoginToken();
        String Token = getLoginToken.getToken();
        String authHeader = 'Bearer ' + token;
        
        system.debug('Accesstoken=' + token);
        
        
        
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json');  
        req.setHeader('Authorization', authHeader); 
        req.setTimeout(120000);
        String endpoint = 'callout:UploadKeyContact';
        req.setEndpoint(endpoint);
        requestBody1 = JSON.serialize(inputwrapper);
        
        req.setBody(requestBody1);
        System.debug('requestBody111=' + requestBody1);
        Http http = new Http();
        
        HTTPResponse response = http.send(req);
        system.debug('response111===' + response);
        string responsebody = response.getBody();
        if(response.getStatusCode()==200){
            auth1 = (UploadKContact_ResWrap) System.JSON.deserialize(responsebody, UploadKContact_ResWrap.class);
            system.debug('auth==' + auth1);
            
            System.debug('Body111 ' + response.getBody());
            System.debug('Status111 ' + response.getStatus());
            System.debug('Status code111 ' + response.getStatusCode());
        }
        else{
            system.debug('Failed to upload key contacts: HTTP status code ' + response.getStatusCode());          
        }
        //}
        
        return auth1;
    }
}