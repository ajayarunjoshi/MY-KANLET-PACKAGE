@RestResource(urlMapping='/api/updateICPDetails/*')
global class ICPUpdateController {
    
    @HttpPost
    global static ResultResponse updateICP() {
        ResultResponse res = new ResultResponse();
        Track_Log__c trackLog = new Track_Log__c();
        User sfcrmAdminUser = [SELECT Id, Email, FirstName, LastName FROM User WHERE Name = 'CRM Admin' LIMIT 1];
        Integer customerId;
        Integer userUniqueId;
        try {
            String requestBody = RestContext.request.requestBody.toString();
            System.debug('requestBody --> ' + requestBody);
            
            // Initialize track log with request body
            trackLog.API_Type__c = 'ICP Update';
            trackLog.Request__c = requestBody;
            trackLog.Request_Date1__c = System.now();
            
            // Check if the request body is empty
            if (String.isBlank(requestBody)) {
                handleEmptyRequestBody(res, trackLog, sfcrmAdminUser);
                return res;
            }
            
            ICPReq_Wrap obj = ICPReq_Wrap.parse(requestBody);
            System.debug('obj --> ' + obj);
            
            // Check if obj or obj.data is null or empty
            if (obj == null || obj.data == null) {
                handleInvalidData(res, trackLog,sfcrmAdminUser);
                return res;
            }
            ICPReq_Wrap.Data kReq = obj.data;
            customerId = kReq.customer_id;
            userUniqueId = kReq.user_unique_id;
            Kanlet_License__c kanletLicenses = [SELECT Id, Name 
                                                FROM Kanlet_License__c 
                                                WHERE User_Unique_Id__c = :userUniqueId 
                                                AND Customer_Id__c = :customerId 
                                                LIMIT 1];
            
            if (kanletLicenses == null) {
                handleNoKanletLicenseRecord(res, trackLog,sfcrmAdminUser);
                return res; // Return res here to ensure a ResultResponse object is returned
            }
            // Rest of your code logic here...
            ICP__c icp = [SELECT Id, Name, Kanlet_License__c, Customer_Id__c, User_Unique_Id__c, Customer_Name__c, Industry__c,
                          Employee_Count__c, Revenue__c, Location_City__c, Location_State__c, Location_Country__c, Last_Funding_Status__c,
                          Tech_Stack__c, Job_Title__c, Job_Title_Function__c, Job_Title_Seniority__c, Boolean_indicating_if_the_record_is_arch__c,
                          Insert_Date__c, Update_Date__c
                          FROM ICP__c WHERE Kanlet_License__c = :kanletLicenses.Id LIMIT 1];            
            if (icp == null) {
                handleNoICPRecord(res, trackLog, sfcrmAdminUser);
                return res;
            }
            icp.Customer_Name__c = obj.data.customer_name;
            icp.Industry__c = String.join(obj.data.industry, ', ');
            icp.Update_Date__c = Date.today();
            icp.Employee_Count__c=String.join(obj.data.employee_count, ', ');
            icp.Location_City__c=String.join(obj.data.location_city, ', ');
            icp.Location_State__c=String.join(obj.data.location_state, ', ');
            icp.Location_Country__c=String.join(obj.data.location_country, ', ');
            icp.Revenue__c=String.join(obj.data.revenue, ', ');
            icp.Job_Title_Function__c=String.join(obj.data.job_title_function, ', ');
            icp.Job_Title_Seniority__c=String.join(obj.data.job_title_seniority, ', ');
            icp.Job_Title__c=String.join(obj.data.job_title, ', ');
            icp.Last_Funding_Status__c=String.join(obj.data.last_funding_status, ', ');
            icp.Tech_Stack__c=String.join(obj.data.tech_stack, ', ');
            
            // Update the ICP__c record
            update icp;
            // If everything went well, set success response
            res.Result = 'ICP updated successfully.';
            res.RecordIds = icp.Id;
            RestContext.response.statusCode = 200;
            
            // Set status to Success in track log
            trackLog.Status__c = 'Success';
            trackLog.Response__c = JSON.serialize(res);
            
            
            // Send success email
            sendSuccessEmail(sfcrmAdminUser, icp.Id);
            
        } catch (Exception e) {
            // If an exception occurs, handle it
            handleException(e, res, trackLog, sfcrmAdminUser);
        } finally {
               insert trackLog;
        }
        
        return res;
    }
    // Handle empty request body scenario
    private static void handleEmptyRequestBody(ResultResponse res, Track_Log__c trackLog, User sfcrmAdminUser) {
        res.Result = 'No data to process.';
        res.ErrorMsg = 'Request body is empty.';
        trackLog.Error__c = res.ErrorMsg;
        trackLog.Response__c = JSON.serialize(res);
        trackLog.Status__c ='Fail';
        insert trackLog;
        RestContext.response.statusCode = 400;
        sendFailureEmail(sfcrmAdminUser);
    }
    
    // Handle invalid data scenario
    private static void handleInvalidData(ResultResponse res, Track_Log__c trackLog, User sfcrmAdminUser) {
        res.Result = 'No data to process.';
        res.ErrorMsg = 'Request body does not contain valid data.';
        trackLog.Error__c = res.ErrorMsg;
        trackLog.Response__c = JSON.serialize(res);
        trackLog.Status__c ='Fail';
        insert trackLog;
        RestContext.response.statusCode = 400;
        sendFailureEmail(sfcrmAdminUser);
        
        
    }
    
    // Handle no Kanlet_License__c record found scenario
    private static void handleNoKanletLicenseRecord(ResultResponse res, Track_Log__c trackLog, User sfcrmAdminUser) {
        res.Result = 'No matching Kanlet_License__c record found.';
        res.ErrorMsg = 'No Kanlet_License__c record found for the given userUniqueId and customerId.';
        trackLog.Error__c = res.ErrorMsg;
        trackLog.Response__c = JSON.serialize(res);
        insert trackLog;
        RestContext.response.statusCode = 404;
        trackLog.Status__c ='Fail';
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(res));
    }
    
    
    
    // Handle generic exception scenario
    private static void handleException(Exception e, ResultResponse res, Track_Log__c trackLog, User sfcrmAdminUser) {
        System.debug('An Error Occurred: ' + e.getMessage());
        res.Result = 'Failed to update ICP.';
        res.ErrorMsg = e.getMessage();
        trackLog.Error__c = res.ErrorMsg;
        trackLog.Response__c = JSON.serialize(res);
        RestContext.response.statusCode = 500;
        trackLog.Status__c ='Fail';
        insert trackLog;
        sendFailureEmail(sfcrmAdminUser);
    }
    
    
    
    
    // Handle no ICP__c record found scenario
    private static void handleNoICPRecord(ResultResponse res, Track_Log__c trackLog,User sfcrmAdminUser) {
        res.Result = 'No matching ICP__c record found.';
        res.ErrorMsg = 'No ICP__c record found for the given Kanlet_License__c Id.';
        trackLog.Error__c = res.ErrorMsg;
        trackLog.Response__c = JSON.serialize(res);
        insert trackLog;
        RestContext.response.statusCode = 404;
        trackLog.Status__c ='Fail';
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(res));
        sendFailureEmail(sfcrmAdminUser);
    }
    
    
    
    // Class to hold the response structure
    global class ResultResponse {
        public String Result;
        public String ErrorMsg;
        public Id RecordIds;
        
        public ResultResponse() {
            ErrorMsg = '{}';
            Result = '';
            RecordIds = null;
        }
    }
    
    
    private static void sendSuccessEmail(User sfcrmAdminUser, Id icpId) {
        System.debug('Sending success email...');
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        String icpDetailLink = URL.getOrgDomainUrl().toExternalForm() + '/lightning/r/ICP__c/' + icpId + '/view';
        
        String emailBody = '<!DOCTYPE html>' +
            '<html lang="en">' +
            '<head>' +
            '<meta charset="UTF-8">' +
            '<title>ICP Confirmation</title>' +
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
            '<p>ICP Details have been updated successfully.</p>' +
            '<p>Please find the <a href="' + icpDetailLink + '">ICP Details</a> for further details.</p>' +
            '</div>' +
            '<div class="footer">' +
            '<p>Regards,<br>Kanlet Admin</p>' +
            '</div>' +
            '</div>' +
            '</body>' +
            '</html>';
        
        email.setHtmlBody(emailBody);
        email.setSubject('ICP Update Success');
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
            '<title>Kanlet Configuration Failed Notification</title>' +
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
            '<p>The request for update ICP details was not processed properly.</p>' +
            '<p>If you have any questions or need further assistance, feel free to contact us.</p>' +
            '</div>' +
            '<div class="footer">' +
            '<p>Regards,<br>Kanlet Admin</p>' +
            '</div>' +
            '</div>' +
            '</body>' +
            '</html>';
        email.setHtmlBody(emailBody);
        email.setSubject('Update ICP Failure');
        email.setToAddresses(new List<String>{sfcrmAdminUser.Email});
        email.setSaveAsActivity(false);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
    }    
}