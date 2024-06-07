// selectContacts.js
import { LightningElement, track, wire } from 'lwc';
import getContacts from '@salesforce/apex/ContactSelectorController.getContacts';

export default class SelectContacts extends LightningElement {
    @track contacts;
    columns = [
        { label: 'Name', fieldName: 'Name', type: 'text' },
        { label: 'Email', fieldName: 'Email', type: 'email' },
        // Add more columns as needed
    ];

    fetchContacts() {
        getContacts()
            .then(result => {
                this.contacts = result;
            })
            .catch(error => {
                console.error('Error fetching contacts', error);
            });
    }
}