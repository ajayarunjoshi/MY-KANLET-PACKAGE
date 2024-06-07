public class getLoginToken {
      @AuraEnabled 
    public static string getToken()
    {
        String result; 
        String processedRes;
        String requestBody = '';
        String bearertoken = '';
        LoginToken_ResponseWrap auth = new LoginToken_ResponseWrap();
        Integration_Metadata__mdt apiConfig = Integration_Metadata__mdt.getInstance('GenerateToken');
        
            HttpRequest httpRequest;
            String endpoint =  'callout:GenerateToken';
            try
            {
                HttpRequest req = new HttpRequest();
                req.setMethod(apiConfig.Method_Type__c);
                req.getHeader(apiConfig.Content_Type__c);
                
                req.setEndpoint(endpoint);
                
                string email = apiConfig.Email__c;
                string Password=apiConfig.Password__c;
                
                LoginToken_ReqWrap reqInt = new LoginToken_ReqWrap();
                reqInt.email = apiConfig.Email__c;
                reqInt.Password = apiConfig.Password__c;
                requestBody = JSON.serialize(reqInt);
                
               req.setBody(requestBody);
                
                
                Http http = new Http();
                HTTPResponse response = http.send(req);
                System.debug('Body ' + response.getBody());
                
                LoginToken_ResponseWrap resp1 = (LoginToken_ResponseWrap)JSON.deserialize(response.getbody(),LoginToken_ResponseWrap.class);
                bearertoken = resp1.data.access_token;
                system.debug('access_token='+bearertoken);
                
            }
            catch(Exception ex)
            {
                System.debug('Exception : '+ex);
          //      SC_MessageLogUtil.MessageLog excLog=new SC_MessageLogUtil.MessageLog(ex,'Apex','Error in CIBIL Token Generation API, please contact Administartor.', 'CIBIL_Consumer_Core.getToken',ex.getMessage(),ex.getMessage(),'',ex.getLineNumber()+'',SC_Constants.Message_Type_Exception,'','CIBIL_Consumer_Core','getToken');
           //     SC_MessageLogUtil.createExceptionMessageLog(excLog);
            }
            return bearertoken;
             
    }


}