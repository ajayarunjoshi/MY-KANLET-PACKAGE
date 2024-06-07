@isTest
private class FileredDataTableControllerTest {

    @isTest
    static void testGetAccount() {
        Test.startTest();
        List<Account> accounts = FileredDataTableController.getAccount();
        Test.stopTest();
        System.assertNotEquals(null, accounts, 'List of accounts should not be null');
    }

    @isTest
    static void testGetKcontact() {
        Test.startTest();
        List<K_Contact__c> kcontacts = FileredDataTableController.getKcontact();
        Test.stopTest();
        System.assertNotEquals(null, kcontacts, 'List of K_Contact__c records should not be null');
    }

    @isTest
    static void testGetContact() {
        Test.startTest();
        List<Account> accounts = new List<Account>{
            new Account(Name = 'Test Account')
        };
        insert accounts;
        List<Id> selectedAccounts = new List<Id>{accounts[0].Id};
        List<Contact> contacts = FileredDataTableController.getContact(selectedAccounts);
        Test.stopTest();
        System.assertNotEquals(null, contacts, 'List of contacts should not be null');
    }

    @isTest
    static void testGetAcountIndustryPicklist() {
        Test.startTest();
        List<Map<String, String>> industryPicklist = FileredDataTableController.getAcountIndustryPicklist();
        Test.stopTest();
        System.assertNotEquals(null, industryPicklist, 'Industry picklist should not be null');
    }

    @isTest
    static void testGetAcountRegion() {
        Test.startTest();
        List<Map<String, String>> regionPicklist = FileredDataTableController.getAcountRegion();
        Test.stopTest();
        System.assertNotEquals(null, regionPicklist, 'Region picklist should not be null');
    }

    @isTest
    static void testGetFilteredAccounts() {
        Test.startTest();
        
        List<Account> filteredAccounts = FileredDataTableController.getFilteredAccounts('Industry', 'Region', 'OwnerName');
        
        System.assertNotEquals(null, filteredAccounts, 'Filtered accounts should not be null');
        
        System.assertEquals(0, filteredAccounts.size(), 'No accounts should be returned');
        
        filteredAccounts = FileredDataTableController.getFilteredAccounts(null, 'Region', 'OwnerName');
        
        System.assertNotEquals(null, filteredAccounts, 'Filtered accounts should not be null');
        
        System.assertEquals(0, filteredAccounts.size(), 'No accounts should be returned');
        
        filteredAccounts = FileredDataTableController.getFilteredAccounts('Industry', null, 'OwnerName');
        
        System.assertNotEquals(null, filteredAccounts, 'Filtered accounts should not be null');
        
        System.assertEquals(0, filteredAccounts.size(), 'No accounts should be returned');
        
        filteredAccounts = FileredDataTableController.getFilteredAccounts('Industry', 'Region', null);
        
        System.assertNotEquals(null, filteredAccounts, 'Filtered accounts should not be null');
        
        System.assertEquals(0, filteredAccounts.size(), 'No accounts should be returned');
        Test.stopTest();
    }

    @isTest
    static void testCreateContacts() {
        Test.startTest();
        List<Map<String,Object>> kcontacts = new List<Map<String,Object>>{
            new Map<String,Object>{
                'contactId' => 'TestContactId',
                'First_Name' => 'Ryan',
                'Last_Name' => 'White',
                'JobTitle' => 'Project Manager',
                'EmailId' => 'ryan.white@quantuminnovations.com',
                'Company' => 'Quantum Innovations',
                'website' => 'www.quantumsolutionsinc.com'
            }
        };
        String contactId = 'ContactId';
        String recordId = 'RecordId';
       

        List<K_Contact__c> newKContacts = FileredDataTableController.createContacts(kcontacts, contactId, recordId);
        Test.stopTest();
        System.assertNotEquals(null, newKContacts, 'List of new K_Contact__c records should not be null');
    }
}