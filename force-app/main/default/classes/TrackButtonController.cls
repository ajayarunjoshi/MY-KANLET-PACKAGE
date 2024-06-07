public class TrackButtonController {
    
    // @AuraEnabled  
    //  public static List<Track_Request_Contact__c> getContacts(String trackRequestId) {
    
    @AuraEnabled  
    public static String getContacts(String trackRequestId) {     
      //  try{
        //Query Track Request
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
        Set<String> errorMessages = new Set<String>();
        
        
        // Query K_Contact__c records based on the collected Ids
        List<K_Contact__c> kContacts = [SELECT Id, Name, Contact__c,First_Name__c,Last_Name__c,Email_Id__c,Company_Website__c,
                                        Company_Name__c,Job_Title__c,Company_Status__c,Contact__r.AccountId
                                        FROM K_Contact__c 
                                        WHERE Id IN :kContactIds];
        
        // Query Contact records associated with K_Contact__c records via the K_Contact__c.Contact__c lookup
        List<Contact> contacts = [SELECT Id, Name, Email, Phone, FirstName, LastName,AccountId, Account.Website,Account_Name__c,Title /* Add more fields as needed */ 
                                 FROM Contact 
                                  WHERE Id IN (SELECT Contact__c FROM K_Contact__c WHERE Id IN :kContactIds)];
        Track_Request__c trackReq =[SELECT Id ,Name,Kanlet_Configuration__c FROM Track_Request__c WHERE Id =:trackRequestId];
        string Kconfig = trackReq.Kanlet_Configuration__c;
        Kanlet_License__c KnletConfig = [Select Id,Customer_id__c,User_Unique_Id__c FROM Kanlet_License__c WHERE Id =:Kconfig];
        if (knletConfig == null) {
                errorMessages.add('Kanlet Configuration not found.');
            }
        List<UploadKContact_RequestWrap> reqLst = new List<UploadKContact_RequestWrap>();
        for(K_Contact__c kContact: kContacts) {           
            UploadKContact_RequestWrap reqWrap = new UploadKContact_RequestWrap();
            if(String.isNotBlank(kContact.First_Name__c)){
                reqWrap.contact_first_name =kContact.First_Name__c;  
            }
            else{
                errorMessages.add('Contact First Name is mandatory.');
            }
            if(String.isNotBlank(kContact.Last_Name__c)){
                reqWrap.contact_last_name = kContact.Last_Name__c; 
            }
            else{
                errorMessages.add('Contact Last Name is mandatory.');
            }
            if(String.isNotBlank(kContact.Email_Id__c)){
                reqWrap.contact_email = kContact.Email_Id__c;  
            }
            else{
                errorMessages.add('Contact Email is mandatory.');
            }
            reqWrap.contact_company_website_url = String.isNotBlank(kContact.Company_Website__c) ? kContact.Company_Website__c : 'null';
          /*  if(String.isNotBlank(kContact.Company_Website__c)){
                reqWrap.contact_company_website_url = kContact.Company_Website__c;  
            }
            else{
               reqWrap.contact_company_website_url = 'null';
            } */
          
             if(String.isNotBlank(kContact.Company_Name__c)){
                   reqWrap.contact_company_name=kContact.Company_Name__c;
            }
            else{
                errorMessages.add('Contact Company Name is mandatory.');
            }
            
            if(String.isNotBlank(kContact.Job_Title__c)){
                reqWrap.contact_title = kContact.Job_Title__c;  
            }
            else{
                errorMessages.add('Contact title is mandatory.');
            }
            
            reqWrap.contact_company_status='Null';
             system.debug('reqWrap.unique_id --> '+reqWrap.unique_id+' kContact.Id --> '+ kContact.Id);
            if(String.isNotBlank(kContact.Id)){
                reqWrap.unique_id= kContact.Id;
                system.debug('reqWrap.unique_id --> '+reqWrap.unique_id+' kContact.Id --> '+ kContact.Id);
           }
           else{
                errorMessages.add('Unique Id(Inscope Contact Id) is mandatory.');
           }
            
            if(knletConfig.User_Unique_Id__c!=Null){
                reqWrap.user_unique_id= Integer.valueOf(knletConfig.User_Unique_Id__c); 
            }
            else{
                errorMessages.add('User Unique Id is mandatory.');
            }
            if(knletConfig.Customer_id__c!=Null  ){
                reqWrap.customer_id= Integer.valueOf(knletConfig.Customer_id__c); 
            }
            else{
                errorMessages.add('Customer Id is mandatory.');
            }
           if (String.isNotBlank(kContact.Contact__c)) {
                reqWrap.salesforce_contact_id = kContact.Contact__c;
           }
            else{
                errorMessages.add('Contact Id is mandatory.');
           }
            if(kContact.Contact__r != null && String.isNotBlank(kContact.Contact__r.AccountId) ){
                reqWrap.salesforce_account_id=kContact.Contact__r.AccountId;
            }
            else{
                errorMessages.add('Account Id is mandatory.');
            }
            
            reqLst.add(reqWrap);
        }     
        
        system.debug('trackRequestContacts.size()>0--> '+trackRequestContacts.size());
        system.debug('trackRequestContacts.isEmpty()--> '+trackRequestContacts.isEmpty());
        if(trackRequestContacts.size()>0 && !trackRequestContacts.isEmpty()){
            String res=uploadK(reqLst,trackRequestId,contacts.size(),new List<String>(errorMessages));
            system.debug('res--> '+res);
            if (!errorMessages.isEmpty()) {
                 return String.join(new List<String>(errorMessages), ', ');
            }
            return res;
        }
        else
        {
            return 'You havent selected any contacts. Add the contact before you hit the track button.';
        }           
    }
    
    @AuraEnabled 
    public static String uploadK(List<UploadKContact_RequestWrap> inputwrapper, String trackRequestId, Integer totalContacts,List<String> errorMessages) {
        String requestBody1 = '';
        UploadKContact_ResWrap auth1 = new UploadKContact_ResWrap();
        Integration_Metadata__mdt apiConfig = Integration_Metadata__mdt.getInstance('Upload_Key_Contacts');
        String token = getLoginToken.getToken();
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
        System.debug('requestBody1=' + requestBody1);
        Http http = new Http();
        
        HTTPResponse response = http.send(req);
        system.debug('response===' + response);
        string responsebody = response.getBody();
        
        Track_Log__c trackLog = new Track_Log__c();
        trackLog.Request_Date1__c = system.now();
        trackLog.Track_Request__c = trackRequestId;
        trackLog.API_Type__c = 'Track';
        trackLog.Request__c = JSON.serializePretty(inputwrapper); 
        
        User sfcrmAdminUser = [SELECT Id, Email, FirstName, LastName FROM User WHERE Name = 'CRM Admin' LIMIT 1];
        system.debug('sfcrmAdminUser--> ' + sfcrmAdminUser);
        
        if (response.getStatusCode() == 200) {
            auth1 = (UploadKContact_ResWrap) System.JSON.deserialize(responsebody, UploadKContact_ResWrap.class);
            system.debug('auth==' + auth1);
            
            trackLog.Status__c = 'Success';
            Integer maxLength = 32000;
            if (responsebody.length() > maxLength) {
                trackLog.Response__c = 'Please refer to notes and attachments for the full response.';
                insert trackLog;
                system.debug('trackLog id--> ' + trackLog.Id);
                saveResponseAsContentDocument(trackLog.Id, responsebody);
            } else {
                trackLog.Response__c = responsebody;
                insert trackLog;
            }
            
            Task tsk = new Task();
            tsk.Subject = 'API Request Sent Successfully';
            tsk.WhatId = trackRequestId;
            insert tsk;
            
            Track_Request__c trackReq = [SELECT Id, Request_Status__c FROM Track_Request__c WHERE Id = :trackRequestId];
            trackReq.Request_Status__c = 'In Progress';
            trackReq.Request_Date__c=Date.Today();
            update trackReq;
            
            system.debug('trackReq 150--> ' + trackReq.Request_Status__c);
            
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();  
            String emailBody = '<!DOCTYPE html>' +
                '<html lang="en">' +
                '<head>' +
                '<meta charset="UTF-8">' +
                '<title>Tracking Request Confirmation</title>' +
                '<style>' +
                'body { font-family: Arial, sans-serif; margin: 0; padding: 0; background-color: #f4f4f4; }' +
                '.container { max-width: 600px; margin: 20px auto; background: white; padding: 20px; border: 1px solid #e0e0e0; box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); }' +
                '.header { display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #e0e0e0; padding-bottom: 10px; margin-bottom: 20px; }' +
                '.header img { height: 15px; width: auto; }' +
                '.content { line-height: 1.6; }' +
                '.footer { border-top: 1px solid #e0e0e0; padding-top: 10px; text-align: left; }' +
                '</style>' +
                '</head>' +
                '<body>' +
                '<div class="container">' +
                '<div class="header">' +
                '<div class="title"><strong>Tracking Request Confirmation</strong></div>' +
                '<img src="https://kanlet.ai/assets/img/logo_purple.svg" alt="Kanlet Logo">' +
                '</div>' +
                '<div class="content">' +
                '<p>Hello ' + sfcrmAdminUser.FirstName + ',</p>' +
                '<p>Your API request to track <strong>' + totalContacts + ' contacts</strong> has been successfully sent to Kanlet.</p>' +                
                '</div>' +
                '<div class="footer">' +
                '<p>Regards,<br>System Admin</p>' +
                '</div>' +
                '</div>' +
                '</body>' +
                '</html>';
            email.setHtmlBody(emailBody);
            email.setSubject('API Request Successfully Sent to Kanlet');
            email.setToAddresses(new List<String>{sfcrmAdminUser.Email});            
            email.setSaveAsActivity(false);            
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
        } else {
            system.debug('Inside else');
            Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(response.getBody().toString());
            system.debug('responseMap ' + responseMap);
            
            String errorMsg = String.valueOf(responseMap.get('errors'));
            system.debug('Error ' + errorMsg);
            
            trackLog.Status__c = 'Fail';
            trackLog.Error__c = errorMsg;
            
            Integer maxLength = 32000;
            if (responsebody.length() > maxLength) {
                trackLog.Response__c = 'Please refer to notes and attachments for the full response.';
                insert trackLog;
                saveResponseAsContentDocument(trackLog.Id, responsebody);
            } else {
                trackLog.Response__c = responsebody;
                insert trackLog;
            }       
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();  
            String emailBody = '<!DOCTYPE html>' +
                '<html lang="en">' +
                '<head>' +
                '<meta charset="UTF-8">' +
                '<title>Tracking Request Failure</title>' +
                '<style>' +
                'body { font-family: Arial, sans-serif; margin: 0; padding: 0; background-color: #f4f4f4; }' +
                '.container { max-width: 600px; margin: 20px auto; background: white; padding: 20px; border: 1px solid #e0e0e0; box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); }' +
                '.header { display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #e0e0e0; padding-bottom: 10px; margin-bottom: 20px; }' +
                '.header img { height: 15px; width: auto; }' +
                '.content { line-height: 1.6; }' +
                '.footer { border-top: 1px solid #e0e0e0; padding-top: 10px; text-align: left; }' +
                '</style>' +
                '</head>' +
                '<body>' +
                '<div class="container">' +
                '<div class="header">' +
                '<div class="title"><strong>Tracking Request Failure</strong></div>' +
                '<img src="https://kanlet.ai/assets/img/logo_purple.svg" alt="Kanlet Logo">' +
                '</div>' +
                '<div class="content">' +
                '<p>Hello ' + sfcrmAdminUser.FirstName + ',</p>' +
                '<p>Your API request to track contacts has failed with the following error: <strong>' + String.join(new List<String>(errorMessages), ', ') + '</strong></p>' +                
                '</div>' +
                '<div class="footer">' +
                '<p>Regards,<br>System Admin</p>' +
                '</div>' +
                '</div>' +
                '</body>' +
                '</html>';
            email.setHtmlBody(emailBody);
            email.setSubject('API Request Failed to Kanlet');
            email.setToAddresses(new List<String>{sfcrmAdminUser.Email});            
            email.setSaveAsActivity(false);            
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
            
            system.debug('Failed to upload key contacts: HTTP status code ' + response.getStatusCode());
            return errorMsg;
        }
        return 'Success';
    }    
    
    private static void saveResponseAsContentDocument(Id trackLogId, String responsebody) {
        // Create a new ContentVersion
        ContentVersion contentVersion = new ContentVersion();
        contentVersion.VersionData = Blob.valueOf(responsebody);
        contentVersion.Title = 'API_Response.txt';
        contentVersion.PathOnClient = 'API_Response.txt';
        insert contentVersion;
        
        // Retrieve the ContentDocumentId
        contentVersion = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id];
        
        // Link the ContentDocument to the parent record (Track_Log__c)
        ContentDocumentLink contentDocLink = new ContentDocumentLink();
        contentDocLink.ContentDocumentId = contentVersion.ContentDocumentId;
        contentDocLink.LinkedEntityId = trackLogId; // Using the Track_Log__c Id
        contentDocLink.ShareType = 'V'; // Viewer permission
        contentDocLink.Visibility = 'AllUsers';
        insert contentDocLink;
    }
    
    
    
}