import { LightningElement, api, track } from 'lwc';
import getCareerEventsByContactId from '@salesforce/apex/ContactJourneyController.getCareerEventsByContactId';

export default class KanletDataDisplay extends LightningElement {
    @api recordId;
    kanletData;
    @track Left = false;
    @track Joined = false;

    connectedCallback() {
        this.retrieveKanletData();
    }

    // Declaring variables without @track as they are not used in the template
    Company;
    Job_Title;
    Contact_Status;
    New_Company;
    New_Designation;
    Action_Taken;

    retrieveKanletData() {
        console.log('retrieveKanletData function call');
        console.log('this.recordId ==>', this.recordId);

        getCareerEventsByContactId({ contactId: this.recordId })
            .then(result => {
                console.log('Kanlet data retrieved:', result);
                console.log('Kanlet data retrieved:JSON  ', JSON.stringify(result));
                this.kanletData = result;
                this.Company = result.Company__c;
                this.Job_Title = result.Job_Title__c;
                this.Contact_Status = result.Contact_Status__c;
                this.New_Company = result.New_Company__c;
                this.New_Designation = result.New_Designation__c;
                this.Action_Taken = result.Action_Taken__c;
                const newContactId = result.ContactId__c;
                const oldContactId = result.K_Contact__r.Contact__c;

                console.log('New Contact', newContactId);
                console.log('Old Contact Status==>', oldContactId);

                
            })
            .catch(error => {
                console.error('Error fetching Kanlet data:', error);
                console.log('Error fetching Kanlet data without JSON', error);
                console.log('Error fetching Kanlet data with JSON', JSON.stringify(error));
            });
    }
}