public class LoginTokenConfigController1 {
    public class LoginToken_ResponseWrap {
        public Boolean status;
        public LoginToken_Data data;
        public String message;
        public Integer status_code;
        public Map<String, Object> errors;
    }

    public class LoginToken_Data {
        public Integer user_unique_id;
        public String first_name;
        public String last_name;
        public String email;
        public String refresh_token;
        public String access_token;
        public Integer customer_id;
    }

    @AuraEnabled 
    public static LoginToken_ResponseWrap getToken() {
        LoginToken_ResponseWrap auth = new LoginToken_ResponseWrap();
        Integration_Metadata__mdt apiConfig = Integration_Metadata__mdt.getInstance('GenerateToken');
        
        HttpRequest httpRequest;
        String endpoint = 'callout:GenerateToken';
        try {
            HttpRequest req = new HttpRequest();
            req.setMethod(apiConfig.Method_Type__c);
            req.setHeader('Content-Type', apiConfig.Content_Type__c);
            req.setEndpoint(endpoint);
            
            LoginToken_ReqWrap reqInt = new LoginToken_ReqWrap();
            reqInt.email = apiConfig.Email__c;
            reqInt.Password = apiConfig.Password__c;
            String requestBody = JSON.serialize(reqInt);
            
            req.setBody(requestBody);
            
            Http http = new Http();
            HTTPResponse response = http.send(req);
            System.debug('Body ' + response.getBody());
            
            auth = (LoginToken_ResponseWrap) JSON.deserialize(response.getBody(), LoginToken_ResponseWrap.class);
            System.debug('access_token=' + auth.data.access_token);
            
        } catch(Exception ex) {
            System.debug('Exception : ' + ex);
            // Handle exception logging if necessary
        }
        return auth;
    }
}