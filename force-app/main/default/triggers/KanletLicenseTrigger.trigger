trigger KanletLicenseTrigger on Kanlet_License__c (before insert, before update) {
    for (Kanlet_License__c license : Trigger.new) {
        if (Trigger.isInsert) {
            license.Is_Updated__c = false; // Ensure the field is false on insert
        } else if (Trigger.isUpdate) {
            Kanlet_License__c oldLicense = Trigger.oldMap.get(license.Id);
            if (!oldLicense.Is_Updated__c && !license.Is_Updated__c) {
                license.Is_Updated__c = true;
            } else if (oldLicense.Is_Updated__c) {
                if (license.ICP_Count__c != oldLicense.ICP_Count__c) {
                    continue;
                }
                license.addError('You do not have access to edit this record after it has been updated.');
            }
        }
    }
}