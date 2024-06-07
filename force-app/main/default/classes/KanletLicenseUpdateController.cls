@RestResource(urlMapping='/api/UpdateKanletLicense/*')
global class KanletLicenseUpdateController {   
    @HttpPost
    global static ResultResponse UpdateKLicense() {
        //         public static string customerId;
        // public static string userUniqueId;
        Integer customerId;
        Integer userUniqueId;
        ResultResponse res = new ResultResponse();
        Track_Log__c trackLog = new Track_Log__c();
        User sfcrmAdminUser = [SELECT Id, Email, FirstName, LastName FROM User WHERE Name = 'CRM Admin' LIMIT 1];
        
        try {
            String requestBody = RestContext.request.requestBody.toString();
            System.debug('requestBody --> ' + requestBody);
            
            // Initialize track log with request body
            trackLog.API_Type__c = 'Config_Update';
            trackLog.Request__c = requestBody;
            trackLog.Request_Date1__c = System.now();
            trackLog.Error__c = '';
            trackLog.Response__c = '';
            
            // Check if the request body is empty
            if (String.isBlank(requestBody)) {
                res.Result = 'No data to process.';
                res.ErrorMsg = 'Request body is empty.';
                trackLog.Error__c = res.ErrorMsg;
                trackLog.Response__c = JSON.serialize(res);
                insert trackLog;
                RestContext.response.statusCode = 400;
                sendFailureEmail(sfcrmAdminUser);
                return res;
            }
            
            KLicenseReq_Wrap obj = KLicenseReq_Wrap.parse(requestBody);
            System.debug('obj --> ' + obj);
            
            // Check if obj or obj.data is null or empty
            if (obj == null || obj.data == null ) {
                res.Result = 'No data to process.';
                res.ErrorMsg = 'Request body does not contain valid data.';
                trackLog.Error__c = res.ErrorMsg;
                trackLog.Response__c = JSON.serialize(res);
                insert trackLog;
                RestContext.response.statusCode = 400;
                sendFailureEmail(sfcrmAdminUser);
                return res;
            }
            
            KLicenseReq_Wrap.Data kReq= obj.data;
            customerId=kReq.customer_id;
            userUniqueId=kReq.user_unique_id;                
            
            // Check if customerId or userUniqueId is null
            if (customerId == null || userUniqueId == null) {
                res.Result = 'Invalid data.';
                res.ErrorMsg = 'customer_id and user_unique_id should not be null.';
                trackLog.Error__c = res.ErrorMsg;
                trackLog.Response__c = JSON.serialize(res);
                insert trackLog;
                RestContext.response.statusCode = 400;
                sendFailureEmail(sfcrmAdminUser);
                 // Set status to Success in track log
        trackLog.Status__c = 'Fail';
            
                return res;
            }
            
            // Query Kanlet_License__c record to ensure it exists
            Kanlet_License__c kanletLicenses = [SELECT Id, Name, Contact_Limit__c, Frequency__c, Duration__c, IsActive__c, 
                                                User_Unique_Id__c, Customer_id__c, Customer_Name__c, Tracking_Start_Date__c, 
                                                Tracking_End_Date__c, Job_Title__c, First_Name__c, Last_Name__c
                                                FROM Kanlet_License__c
                                                WHERE User_Unique_Id__c =: userUniqueId
                                                AND Customer_id__c =: customerId
                                                LIMIT 1];
            kanletLicenses.Contact_Limit__c=kReq.contact_limit;
            kanletLicenses.First_Name__c=kReq.user_first_name;
            kanletLicenses.Last_Name__c=kReq.user_last_name;
            kanletLicenses.Job_Title__c=kReq.user_title;
            kanletLicenses.Frequency__c=kReq.frequency;
            kanletLicenses.Duration__c=kReq.duration;
            kanletLicenses.Tracking_Start_Date__c=date.valueof(kReq.tracking_start_date);
            kanletLicenses.Tracking_End_Date__c=date.valueof(kReq.tracking_end_date);
            
            update kanletLicenses;
            res.Result = 'Kanlet configuration updated successfully.';
            res.RecordIds = kanletLicenses.Id;
            RestContext.response.statusCode = 200;
            // Send success email
            sendSuccessEmail(sfcrmAdminUser, kanletLicenses.Id);
             trackLog.Response__c = JSON.serialize(res);
             // Set status to Success in track log
        trackLog.Status__c = 'Success';
            system.debug('Before Success Insertion');
            insert trackLog;
              system.debug('After Success Insertion--> '+trackLog.Id);
            
        }
        catch(Exception e){
            system.debug('An Error Occured '+e.getMessage());
        }
        return res;
    }
    
    private static void sendSuccessEmail(User sfcrmAdminUser, Id kanletLicenseId) {
        System.debug('Sending success email...');
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        String KanletConfigurationLink = URL.getOrgDomainUrl().toExternalForm() + '/lightning/r/Kanlet_License__c/' + kanletLicenseId + '/view'; 
        String emailBody = '<!DOCTYPE html>' +
            '<html lang="en">' +
            '<head>' +
            '<meta charset="UTF-8">' +
            '<title>Agreement Confirmation</title>' +
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
            '<div class="title"><strong>Success Notification</strong></div>' +
            '<img src="https://kanlet.ai/assets/img/logo_purple.svg" alt="Kanlet Logo">' +
            '</div>' +
            '<div class="content">' +
            '<p>Hello ' + sfcrmAdminUser.FirstName + ',</p>' +
            '<p>Kanlet Configuration has been updated successfully.</p>' +
            '<p>Please find the <a href="' + KanletConfigurationLink + '">Kanlet Configuration</a> for further details.</p>' +
            '</div>' +
            '<div class="footer">' +
            '<p>Regards,<br>Kanlet Admin</p>' +
            '</div>' +
            '</div>' +
            '</body>' +
            '</html>';
        email.setHtmlBody(emailBody);
        email.setSubject('Kanlet Configuration Success');
        email.setToAddresses(new List<String>{sfcrmAdminUser.Email});
        email.setSaveAsActivity(false);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
    }
    
    
    private static void sendFailureEmail(User sfcrmAdminUser) {
        System.debug('Sending failure email...');
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        String emailBody = '<!DOCTYPE html>' +
            '<html lang="en">' +
            '<head>' +
            '<meta charset="UTF-8">' +
            '<title>Processed Contacts Failed Notification</title>' +
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
            '<div class="title"><strong>Failed Notification</strong></div>' +
            '<img src="https://kanlet.ai/assets/img/logo_purple.svg" alt="Kanlet Logo">' +
            '</div>' +
            '<div class="content">' +
            '<p>Hello ' + sfcrmAdminUser.FirstName + ',</p>' +
            '<p>The request for update license agreement was not processed properly. Please check the agreement details.</p>' +
            '<p>If you have any questions or need further assistance, feel free to contact us.</p>' +
            '</div>' +
            '<div class="footer">' +
            '<p>Regards,<br>Kanlet Admin</p>' +
            '</div>' +
            '</div>' +
            '</body>' +
            '</html>';
        email.setHtmlBody(emailBody);
        email.setSubject('Update Agreement Failure');
        email.setToAddresses(new List<String>{sfcrmAdminUser.Email});
        email.setSaveAsActivity(false);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
    }    
    global class ResultResponse {
        String ErrorMsg;
        String Result;
        Id RecordIds;
        public ResultResponse() {
            ErrorMsg = '{}';
            Result = '';
            RecordIds = null;
        }
    }
    
    
}