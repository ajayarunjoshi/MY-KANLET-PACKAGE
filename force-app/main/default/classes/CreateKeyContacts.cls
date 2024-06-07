public without sharing class CreateKeyContacts {
    @AuraEnabled 
    public static CreateKeyContacts_ResWrap CreateKeyContactSpecs(CreateKeyContacts_ReqWrap inputwrapper)
    {
        String requestBody1 = '';
        CreateKeyContacts_ResWrap auth1 = new CreateKeyContacts_ResWrap();
        Integration_Metadata__mdt apiConfig = Integration_Metadata__mdt.getInstance('CreateKeyContactsSpecs');
        //getLoginToken tokenProvider = new getLoginToken();
        String Token = getLoginToken.getToken();
        String authHeader = 'Bearer ' +token;
          
        system.debug('Accesstoken='+token);
        
      /*  if(apiConfig.Active__c == false)
        {
            auth1.error = 'Your service is Inactive. Please contact System Administrator';
            return auth1; 
        }
        else
        {*/
            
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setHeader('Content-Type','application/json');  
            req.setHeader('Authorization', authHeader); 
         //   req.setHeader(System.Label.Authorization_Token,'Bearer '+Token);
            req.setTimeout(120000);
            String endpoint ='callout:CreateKeyContactsSpecs';
            req.setEndpoint(endpoint);
            requestBody1 = JSON.serialize(inputwrapper);
            
            req.setBody(requestBody1);
            System.debug('requestBody1= '+requestBody1);
            Http http = new Http();
            
            HTTPResponse response = http.send(req);
            system.debug('response=== '+response);
            string responsebody = response.getBody();
            auth1 = (CreateKeyContacts_ResWrap) System.JSON.deserialize(responsebody, CreateKeyContacts_ResWrap.class);
            system.debug('auth== '+auth1);
            
            System.debug('Body ' + response.getBody());
            System.debug('Status ' + response.getStatus());
            System.debug('Status code ' + response.getStatusCode());
            
        
            
        //}
        
        return auth1;
        
    }
    
    
}