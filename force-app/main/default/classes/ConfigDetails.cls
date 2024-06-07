public without sharing class ConfigDetails {
    // TO Create and update kanletLicense
    @AuraEnabled
    public static Kanlet_License__c configDetail(String configId) {
        try {
            Kanlet_License__c licenseRecord = [SELECT Id, Customer_id__c, User_Unique_Id__c FROM Kanlet_License__c WHERE Id = :configId LIMIT 1];
            return licenseRecord;
        } catch (Exception e) {
            System.debug('Error in configDetail: ' + e.getMessage());
            throw new AuraHandledException('An error occurred while retrieving the license record.');
        }
    }

   // @AuraEnabled
   @InvocableMethod
    public static void getConfigDetails() {
        try {
         //   getLoginToken.LoginToken_ResponseWrap authResponse= getLoginToken.getAuthResponse();
            LoginTokenConfigController1.LoginToken_ResponseWrap authResponse = LoginTokenConfigController1.getToken();
            if (authResponse != null && authResponse.status) {
                // Check if the record already exists
                Kanlet_License__c existingLicense = getExistingLicense(authResponse.data.customer_id, authResponse.data.user_unique_id);
                Kanlet_License__c license = new Kanlet_License__c();
                if (existingLicense == null) {
                    // Create Kanlet_License__c record               
                    license.First_Name__c = authResponse.data.first_name;
                    license.Last_Name__c = authResponse.data.last_name;
                    license.User_Unique_ID__c = authResponse.data.user_unique_id;
                    license.Customer_ID__c = authResponse.data.customer_id;
                    insert license;
                    existingLicense = license;
                }
                // Call future method to handle the HTTP callout
                ConfigurationDetailsFuture(existingLicense.Id, authResponse.data.access_token);
            } else {
                System.debug('Failed to get login token or invalid response.');
                throw new AuraHandledException('Failed to get login token or invalid response.');
            }
        } catch (Exception e) {
            System.debug('Error in getConfigDetails: ' + e.getMessage());
            throw new AuraHandledException('An error occurred while processing the configuration details.');
        }
    }

    private static Kanlet_License__c getExistingLicense(Integer customer_id, Integer user_unique_id) {
        try {
            List<Kanlet_License__c> licenses = [SELECT Id, Customer_id__c, User_Unique_Id__c 
                                                FROM Kanlet_License__c 
                                                WHERE Customer_id__c = :customer_id 
                                                AND User_Unique_Id__c = :user_unique_id 
                                                LIMIT 1];
            return (licenses.isEmpty()) ? null : licenses[0];
        } catch (Exception e) {
            System.debug('Error in getExistingLicense: ' + e.getMessage());
            throw new AuraHandledException('An error occurred while retrieving existing licenses.');
        }
    }

    @future(callout=true)
    public static void ConfigurationDetailsFuture(Id kanletLicenseId, String token) {
        try {
            ConfigurationDetails(kanletLicenseId, token);
        } catch (Exception e) {
            System.debug('Error in ConfigurationDetailsFuture: ' + e.getMessage());
            // Log the exception or handle it appropriately
        }
    }

    public static void ConfigurationDetails(Id kanletLicenseId, String token) {
        System.debug('ConfigurationDetails method started');
        try {
            // Retrieve Kanlet_License__c record
            Kanlet_License__c kanletLicense = [SELECT Id, Customer_id__c, User_Unique_Id__c 
                                               FROM Kanlet_License__c 
                                               WHERE Id = :kanletLicenseId 
                                               LIMIT 1];
            if (kanletLicense != null) {
                // Prepare API request with Customer_id__c and User_Unique_Id__c
                if (String.isNotBlank(token)) {
                    String authHeader = 'Bearer ' + token;
                    Integration_Metadata__mdt apiConfig = Integration_Metadata__mdt.getInstance('ConfigDetails');
                    if (apiConfig != null && apiConfig.Active__c) {
                        HttpRequest httpRequest = new HttpRequest();
                        httpRequest.setHeader('Authorization', authHeader);
                        httpRequest.setHeader('Content-Type', apiConfig.Content_Type__c);
                        httpRequest.setMethod(apiConfig.Method_Type__c.trim());
                        httpRequest.setEndpoint('https://track-crm.kanlet.app/track/config/details/' + kanletLicense.User_Unique_Id__c + '/' + kanletLicense.Customer_ID__c + '/');
                        httpRequest.setTimeout(apiConfig.Timeout__c != null ? Integer.valueOf(apiConfig.Timeout__c) : 120000);

                        Http http = new Http();
                        HttpResponse response = http.send(httpRequest);

                        if (response.getStatusCode() == 200) {
                            String responseBody = response.getBody();
                            System.debug('Response Body: ' + responseBody);

                            // Deserialize response to ConfigDetailsResp_Wrap
                            ConfigDetailsResp_Wrap apiResponse = ConfigDetailsResp_Wrap.parse(responseBody);

                            if (apiResponse != null && apiResponse.data != null) {
                                // Update Kanlet_License__c record with API response
                                kanletLicense.First_Name__c = apiResponse.data.user_first_name;
                                kanletLicense.Last_Name__c = apiResponse.data.user_last_name;
                                kanletLicense.Job_Title__c = apiResponse.data.user_title;
                                kanletLicense.Frequency__c = apiResponse.data.frequency;
                                // Example assuming tracking_start_date format is "YYYY-MM-DD"
                                if (apiResponse.data.tracking_start_date != null && apiResponse.data.tracking_start_date.length() == 10) {
                                    kanletLicense.Tracking_Start_Date__c = Date.valueOf(apiResponse.data.tracking_start_date);
                                } else {
                                    System.debug('Invalid date format for tracking_start_date: ' + apiResponse.data.tracking_start_date);
                                    // Handle the error or set a default value for Tracking_Start_Date__c
                                }
                                // Example assuming tracking_end_date format is "YYYY-MM-DD"
                                if (apiResponse.data.tracking_end_date != null && apiResponse.data.tracking_end_date.length() == 10) {
                                    kanletLicense.Tracking_End_Date__c = Date.valueOf(apiResponse.data.tracking_end_date);
                                } else {
                                    System.debug('Invalid date format for tracking_end_date: ' + apiResponse.data.tracking_end_date);
                                    // Handle the error or set a default value for Tracking_End_Date__c
                                }

                                kanletLicense.Duration__c = apiResponse.data.duration;
                                kanletLicense.Contact_Limit__c = apiResponse.data.contact_limit;
								kanletLicense.Is_Updated__c= True;
                                // Update the record
                                update kanletLicense;

                                // Call GetKeyContactSpec to insert or update ICP records
                                // GetKeyContactSpec(apiResponse.data.customer_id, apiResponse.data.user_unique_id);
                            } else {
                                System.debug('Failed to deserialize JSON response or API response is null.');
                            }
                        } else {
                            System.debug('Error: ' + response.getStatusCode() + ' ' + response.getStatus());
                        }
                    } else {
                        System.debug('Service is inactive');
                    }
                } else {
                    System.debug('Token is null or empty');
                }
            } else {
                System.debug('Kanlet License record not found');
            }
        } catch (Exception e) {
            System.debug('Error in ConfigurationDetails: ' + e.getMessage());
            // Log the exception or handle it appropriately
        }
        System.debug('ConfigurationDetails method ended');
    }
}