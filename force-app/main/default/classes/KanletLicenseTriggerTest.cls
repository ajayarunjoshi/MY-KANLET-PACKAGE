@isTest
public class KanletLicenseTriggerTest {
    @isTest
    static void testKanletLicenseTrigger() {
        // Test before insert
        Kanlet_License__c newLicense = new Kanlet_License__c();
        insert newLicense;

        Kanlet_License__c insertedLicense = [SELECT Is_Updated__c FROM Kanlet_License__c WHERE Id = :newLicense.Id];
        System.assertEquals(false, insertedLicense.Is_Updated__c, 'Is_Updated__c should be false on insert.');

  
        insertedLicense.Is_Updated__c = true;
        update insertedLicense;

        // Fetch the updated license to check if Is_Updated__c is set to true
        Kanlet_License__c updatedLicense = [SELECT Id, name,frequency__c,Is_Updated__c FROM Kanlet_License__c WHERE Id = :insertedLicense.Id];
        System.assertEquals(true, updatedLicense.Is_Updated__c, 'Is_Updated__c should be true after the first update.');

        
        try {
            updatedLicense.frequency__c = 'Weekly'; 
            update updatedLicense;
            System.assert(false, 'Expected an exception when updating a record with Is_Updated__c already true.');
        } catch (DmlException e) {
         
            System.assert(e.getMessage().contains('You do not have access to edit this record after it has been updated.'), 
                'Expected error message not found.');
        }
    }
}