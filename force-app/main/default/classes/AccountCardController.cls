public class AccountCardController {
 
    @AuraEnabled(cacheable=true)
    public static List <K_Processed_Contact__c> kProcessedContact(string accountId){
        
        return [SELECT Id,K_Contact__r.Contact__r.AccountId FROM K_Processed_Contact__c];
    }
}