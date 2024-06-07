@RestResource(urlMapping='/api/uploadprocessedcontacts/*')
global class ProcessedContactsController {
    @HttpPost
    global static ResultResponse createProcessedContacts() {
        ResultResponse res = new ResultResponse();
        Track_Log__c trackLog = new Track_Log__c();
        User sfcrmAdminUser = [SELECT Id, Email, FirstName, LastName FROM User WHERE Name = 'CRM Admin' LIMIT 1];
        Set<Id> kContactId = new Set<Id>();
        Set<Id> trackReqId = new Set<Id>();

        try {
            String requestBody = RestContext.request.requestBody.toString();
            System.debug('requestBody --> ' + requestBody);

            // Initialize track log with request body
            trackLog.API_Type__c = 'Contact_Update';
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
                RestContext.response.statusCode = 400;
                sendFailureEmail(sfcrmAdminUser);
                return res;
            }

            ProcessedContactReqWrap obj = ProcessedContactReqWrap.parse(requestBody);
            System.debug('obj --> ' + obj);

            // Check if obj or obj.data is null or empty
            if (obj == null || obj.data == null || obj.data.isEmpty()) {
                res.Result = 'No data to process.';
                res.ErrorMsg = 'Request body does not contain valid data.';
                trackLog.Error__c = res.ErrorMsg;
                trackLog.Response__c = JSON.serialize(res);
                RestContext.response.statusCode = 400;
                sendFailureEmail(sfcrmAdminUser);
                return res;
            }

            List<Id> recordIds = new List<Id>();
            List<K_Processed_Contact__c> proConsList = new List<K_Processed_Contact__c>();

            for (ProcessedContactReqWrap.Data contactData : obj.data) {
                K_Processed_Contact__c proCons = new K_Processed_Contact__c();
                 proCons.First_Name__c = String.isBlank(contactData.contact_first_name) ? null : contactData.contact_first_name;
                proCons.Last_Name__c = String.isBlank(contactData.contact_last_name) ? null : contactData.contact_last_name;
                proCons.New_Company__c = String.isBlank(contactData.new_company_name) ? null : contactData.new_company_name;
                proCons.New_Company_Website__c = String.isBlank(contactData.new_company_website_url) ? null : contactData.new_company_website_url;
                proCons.New_Designation__c = String.isBlank(contactData.new_designation) ? null : contactData.new_designation;
                proCons.New_Email_Id__c = String.isBlank(contactData.new_email_id) ? null : contactData.new_email_id;
                proCons.Company__c = String.isBlank(contactData.previos_company_name) ? null : contactData.previos_company_name;
                proCons.Company_Website__c = String.isBlank(contactData.previos_website) ? null : contactData.previos_website;
                proCons.Job_Title__c = String.isBlank(contactData.previos_designation) ? null : contactData.previos_designation;
                proCons.Email_Id__c = String.isBlank(contactData.previos_email_Id) ? null : contactData.previos_email_Id;
                proCons.K_Contact__c = String.isBlank(contactData.unique_id) ? null : contactData.unique_id;
                kContactId.add(contactData.unique_id);

                if (!String.isBlank(contactData.start_date)) {
                    try {
                        proCons.Start_Date__c = Date.valueOf(contactData.start_date);
                    } catch (Exception e) {
                        System.debug('Invalid date format: ' + contactData.start_date);
                        throw new IllegalArgumentException('Invalid date format for start_date: ' + contactData.start_date);
                    }
                }

                proConsList.add(proCons);
                System.debug('proConsList --> ' + proConsList);
            }

            List<Track_Request_Contact__c> trackReqConList = [SELECT Id, Name, Track_Request__c, K_Contact__c FROM Track_Request_Contact__c WHERE K_Contact__c IN :kContactId];
            for (Track_Request_Contact__c trackReqCon : trackReqConList) {
                trackReqId.add(trackReqCon.Track_Request__c);
            }
            System.debug('trackReqId--> '+trackReqId);

            if (!proConsList.isEmpty()) {
                // Ensure no ID is set in K_Processed_Contact__c objects
                for (K_Processed_Contact__c record : proConsList) {
                    record.Id = null;
                }
                insert proConsList;
                for (K_Processed_Contact__c record : proConsList) {
                    recordIds.add(record.Id);
                }
                res.Result = 'Key contacts uploaded successfully.';
                res.RecordIds = recordIds;
                RestContext.response.statusCode = 200; // OK
                trackLog.Status__c='Success';
                if (!trackReqId.isEmpty()) {                
                    trackLog.Track_Request__c = String.valueOf(trackReqId.iterator().next()); // Assign a single Id from the Set
                }
                sendSuccessEmail(sfcrmAdminUser); // Fire success email
            } else {
                res.Result = 'No key contacts to upload.';
                res.ErrorMsg = 'The provided data is empty or invalid.';
                RestContext.response.statusCode = 400; // Bad Request
                trackLog.Error__c = res.ErrorMsg;
                trackLog.Status__c = 'Fail';
                sendFailureEmail(sfcrmAdminUser); // Fire failure email
            }
        } catch (IllegalArgumentException e) {
            res.ErrorMsg = 'Client Error: ' + e.getMessage();
            System.debug('Client Error ---> ' + e.getMessage());
            RestContext.response.statusCode = 400; // Bad Request
            trackLog.Error__c = res.ErrorMsg;
            trackLog.Status__c = 'Fail';
            if (!trackReqId.isEmpty()) {                
                trackLog.Track_Request__c = String.valueOf(trackReqId.iterator().next()); // Assign a single Id from the Set
            }
            sendFailureEmail(sfcrmAdminUser); // Fire failure email
        } catch (Exception e) {
            res.ErrorMsg = 'Server Error: ' + e.getMessage();
            System.debug('Server Error ---> ' + e.getMessage());
            RestContext.response.statusCode = 500; // Internal Server Error
            trackLog.Error__c = res.ErrorMsg;
            trackLog.Status__c = 'Fail';
            if (!trackReqId.isEmpty()) {                
                trackLog.Track_Request__c = String.valueOf(trackReqId.iterator().next()); // Assign a single Id from the Set
            }
            sendFailureEmail(sfcrmAdminUser); // Fire failure email
        } finally {
            trackLog.Response__c = JSON.serialize(res);
            if (!trackReqId.isEmpty()) {   
                System.debug('String.valueOf(trackReqId.iterator().next())--> ' + String.valueOf(trackReqId.iterator().next()));
                trackLog.Track_Request__c = String.valueOf(trackReqId.iterator().next()); // Assign a single Id from the Set
                system.debug('Before Insertion 135');
            }
            system.debug('Before Insertion 137');
            insert trackLog;
            system.debug('After Insertion 139');
        }
        return res;
    }

    private static void sendSuccessEmail(User sfcrmAdminUser) {
        System.debug('Sending success email...');
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        String emailBody = '<!DOCTYPE html>' +
            '<html lang="en">' +
            '<head>' +
            '<meta charset="UTF-8">' +
            '<title>Processed Contacts Confirmation</title>' +
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
            '<div class="title"><strong>Processed Contacts Success Notification</strong></div>' +
            '<img src="https://kanlet.ai/assets/img/logo_purple.svg" alt="Kanlet Logo">' +
            '</div>' +
            '<div class="content">' +
            '<p>Hello ' + sfcrmAdminUser.FirstName + ',</p>' +
            '<p>  Processed contacts has been created successfully.</p>' +
            '<p>Please find the processed contacts for further details.</p>' +
            '</div>' +
            '<div class="footer">' +
            '<p>Regards,<br>Kanlet Admin</p>' +
            '</div>' +
            '</div>' +
            '</body>' +
            '</html>';
        email.setHtmlBody(emailBody);
        email.setSubject('Processed Contacts Success');
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
            '<div class="title"><strong>Processed Contacts Failed Notification</strong></div>' +
            '<img src="https://kanlet.ai/assets/img/logo_purple.svg" alt="Kanlet Logo">' +
            '</div>' +
            '<div class="content">' +
            '<p>Hello ' + sfcrmAdminUser.FirstName + ',</p>' +
            '<p>The request for processed contacts was not processed properly. Please check the contacts again..</p>' +
            '<p>If you have any questions or need further assistance, feel free to contact us.</p>' +
            '</div>' +
            '<div class="footer">' +
            '<p>Regards,<br>Kanlet Admin</p>' +
            '</div>' +
            '</div>' +
            '</body>' +
            '</html>';
        email.setHtmlBody(emailBody);
        email.setSubject('Processed Contacts Failure');
        email.setToAddresses(new List<String>{sfcrmAdminUser.Email});
        email.setSaveAsActivity(false);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
    }

    global class ResultResponse {
        String ErrorMsg;
        String Result;
        List<Id> RecordIds;
        public ResultResponse() {
            ErrorMsg = '{}';
            Result = '';
            RecordIds = new List<Id>();
        }
    }
}