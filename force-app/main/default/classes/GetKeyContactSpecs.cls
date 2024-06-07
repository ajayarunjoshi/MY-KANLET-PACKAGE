public without sharing class GetKeyContactSpecs {

    @AuraEnabled
    public static String GetKeyContactSpec(String kanletLicenseId) {
        System.debug('GetKeyContactSpec method started');

        GetKeyContact_ResWrap auth = new GetKeyContact_ResWrap();

        try {
            // Retrieve the Kanlet License record
            Kanlet_License__c kanletLicense = [
                SELECT Id, Customer_id__c, User_Unique_Id__c
                FROM Kanlet_License__c
                WHERE Id = :kanletLicenseId
                LIMIT 1
            ];

            if (kanletLicense == null) {
                throw new AuraHandledException('No Kanlet License found with the provided Id.');
            }

            Integer urlParam = Integer.valueOf(kanletLicense.User_Unique_Id__c);
            System.debug('urlParam: ' + urlParam);

            Map<String, String> hTTPHeaderParams = new Map<String, String>();
            HttpRequest httpRequest = new HttpRequest();
            String Token = getLoginToken.getToken();
            System.debug('Token: ' + Token);

            String authHeader = 'Bearer ' + Token;
            String responseBody = '';

            Integration_Metadata__mdt apiConfig = Integration_Metadata__mdt.getInstance('GetKeyContactSpecs');
            System.debug('apiConfig: ' + apiConfig);

            if (apiConfig == null || !apiConfig.Active__c) {
                System.debug('Service is inactive or API config is null');
                throw new AuraHandledException('Service is inactive or API config is null.');
            }

            hTTPHeaderParams.put('Authorization', authHeader);
            hTTPHeaderParams.put('Content-Type', apiConfig.Content_Type__c);
            System.debug('hTTPHeaderParams: ' + hTTPHeaderParams);

            Integer setTimeout = Integer.valueOf(apiConfig.Timeout__c);
            System.debug('setTimeout: ' + setTimeout);

            String methodType = apiConfig.Method_Type__c.trim();
            System.debug('methodType: ' + methodType);

            for (String header : hTTPHeaderParams.keySet()) {
                httpRequest.setHeader(header, hTTPHeaderParams.get(header));
            }
            httpRequest.setMethod(methodType);
            String endpoint = apiConfig.End_Point_URL__c + kanletLicense.Customer_id__c + '/' + kanletLicense.User_Unique_Id__c + '/';
            System.debug('endpoint: ' + endpoint);
            httpRequest.setEndpoint(endpoint);

            httpRequest.setTimeout(setTimeout != null ? setTimeout : 120000);

            Http http = new Http();
            HttpResponse response = http.send(httpRequest);
            responseBody = response.getBody();

            System.debug('getResponse responseBody: ' + responseBody);
            System.debug('Status Code: ' + response.getStatusCode());
            System.debug('Response from Response Method: ' + response.getBody());

            auth = GetKeyContact_ResWrap.parse(responseBody);
            System.debug('Deserialized Response: ' + auth);

            if (auth != null && auth.status) {
                System.debug('Inside If');
                // Check if ICP__c record already exists
                ICP__c existingIcp = getICPDetail(kanletLicense.Id);
                ICP__c icp;
                if (existingIcp != null) {
                    // Update the existing ICP__c record
                    icp = existingIcp;
                } else {
                    // Create a new ICP__c record
                    icp = new ICP__c();
                    icp.Kanlet_License__c = kanletLicense.Id;
                    icp.Insert_date__c = Date.today();
                }

                icp.Customer_Id__c = auth.data.customer_id;
                icp.User_Unique_Id__c = auth.data.user_unique_id;
                icp.Employee_Count__c = auth.data.employee_count != null ? String.join(auth.data.employee_count, ',') : null;
                icp.Industry__c = auth.data.industry != null ? String.join(auth.data.industry, ',') : null;
                icp.Job_Title__c = auth.data.job_title != null ? String.join(auth.data.job_title, ',') : null;
                icp.Job_Title_Function__c = auth.data.job_title_function != null ? String.join(auth.data.job_title_function, ',') : null;
                icp.Job_Title_Seniority__c = auth.data.job_title_seniority != null ? String.join(auth.data.job_title_seniority, ',') : null;
                icp.Last_Funding_Status__c = auth.data.last_funding_status != null ? String.join(auth.data.last_funding_status, ',') : null;
                icp.Location_City__c = auth.data.location_city != null ? String.join(auth.data.location_city, ',') : null;
                icp.Location_Country__c = auth.data.location_country != null ? String.join(auth.data.location_country, ',') : null;
                icp.Location_State__c = auth.data.location_state != null ? String.join(auth.data.location_state, ',') : null;
                icp.Revenue__c = auth.data.revenue != null ? String.join(auth.data.revenue, ',') : null;
                icp.Tech_Stack__c = auth.data.tech_stack != null ? String.join(auth.data.tech_stack, ',') : null;
                icp.Customer_Name__c = auth.data.customer_name;

                // Upsert the ICP__c record
                upsert icp;
            } else {
                System.debug('API response status is false or response data is null');
            }
        } catch (Exception ex) {
            System.debug('Exception: ' + ex);
            System.debug('Message: ' + ex.getMessage());
            System.debug('Line Number: ' + ex.getLineNumber());

            // Optionally throw a custom exception to be handled on the client side
            String response= 'An error occurred while retrieving key contact specifications. Please try again later.';
            return response;
        }

        System.debug('GetKeyContactSpec method ended');

        return 'Success';
    }

    @AuraEnabled
    public static ICP__c getICPDetail(String configId) {
        ICP__c existingIcp = null;
        try {
            List<ICP__c> icpList = [
                SELECT Id
                FROM ICP__c
                WHERE Kanlet_License__c = :configId
                LIMIT 1
            ];

            if (!icpList.isEmpty()) {
                existingIcp = icpList[0];
            }
        } catch (Exception e) {
            System.debug('Error in getICPDetail: ' + e.getMessage());
            throw new AuraHandledException('An error occurred while retrieving the ICP record.');
        }

        return existingIcp;
    }
}