public without sharing class GetAllKeyContacts
{
    @AuraEnabled 
    public static GetallKeyContacts_RespWrap GetAllKeyCont (integer user_unique_id)
    {
        integer urlParam = user_unique_id;
        Map<String, String> hTTPHeaderParams = new Map<String, String>();
        HttpRequest httpRequest = new HttpRequest();
        String Token = getLoginToken.getToken();
        String authHeader = 'Bearer '+token;
        string responseBody='';
        GetallKeyContacts_RespWrap auth = new GetallKeyContacts_RespWrap();
        Integration_Metadata__mdt apiConfig = Integration_Metadata__mdt.getInstance('GetAllKeyContacts');
        if(apiConfig.Active__c == false)
        {
           // auth.error = 'Your service Inactive. Please contact System Administrator';
            return auth; 
        }
        try
        {
            if(apiConfig != null)
            {
                hTTPHeaderParams.put('Authorization','Bearer '+ Token);
                HTTPHeaderParams.put('Content-Type', apiConfig.Content_Type__c);
                system.debug('hTTPHeaderParams=> '+hTTPHeaderParams);
                Integer setTimeout = Integer.valueOf(apiConfig.Timeout__c);
                String methodType =apiConfig.Method_Type__c.trim();
                Map<String,String> requestHeaderMap = new Map<String,String>();
                
                for(String header: HTTPHeaderParams.keyset())
                {
                    httpRequest.setHeader(header, HTTPHeaderParams.get(header));
                }
                httpRequest.setMethod(methodType); 
                
                string endpoint = apiConfig.End_Point_URL__c+''+urlParam+ '/';
                system.debug('endpoint== '+endpoint);
                httpRequest.setEndpoint(endpoint);
                if(setTimeout == null)
                {
                    httpRequest.setTimeout(120000);
                }
                else
                {
                    httpRequest.setTimeout(setTimeout);
                }
                String requestBody = httpRequest.getBody();
                Http http = new Http();
                List<Track_Log__c> infolist = new List<Track_Log__c>();
                String objName = apiConfig.Object_Name__c;				
                sObject sObj = Schema.getGlobalDescribe().get(objName).newSObject();
                 
                
                    HttpResponse response = http.send(httpRequest); 
                    responseBody = response.getBody();
                    system.debug('getResponse responseBody--> '+responseBody);
                    system.debug('Status Code : '+response.getStatusCode());
                    system.debug('Response from Response Method : '+response.getBody());
                    auth = (GetallKeyContacts_RespWrap) System.JSON.deserialize(responseBody, GetallKeyContacts_RespWrap.class);
                    System.debug('Response='+auth);
                
            }
        }
        catch(Exception ex)
        {
                system.debug('Exception' +ex);
                system.debug('Message '+ex.getMessage());
                system.debug('Message '+ex.getLinenumber());
        }
        return auth;
    }
}