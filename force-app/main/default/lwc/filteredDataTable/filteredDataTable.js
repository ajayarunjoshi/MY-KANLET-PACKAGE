import { LightningElement, wire, track, api } from 'lwc';
import getAccount from '@salesforce/apex/FileredDataTableController.getAccount';
import getAcountIndustry from '@salesforce/apex/FileredDataTableController.getAcountIndustryPicklist';
import getAcountRegionValues from '@salesforce/apex/FileredDataTableController.getAcountRegion';
import getFilteredAccount from '@salesforce/apex/FileredDataTableController.getFilteredAccounts';
import getContacts from '@salesforce/apex/FileredDataTableController.getContact';
import contactLimit from '@salesforce/apex/FileredDataTableController.getTrackRquest';
import createKContacts from '@salesforce/apex/FileredDataTableController.createContacts';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class FilteredDataTable extends LightningElement {
    @api recordId;
    @track accounts;
    @track accountOwner;
    @track contactLimit;
    @track IndustryValue = 'All';
    @track RegionValue = 'All';
    @track contacts = [];
    ownerNameValue;
    @track showAccountTable = true;
    @track showContactTable = false;
    IndustryOptions = [];
    RegionOptions = [];
    @api childObjectApiName = 'Account'; //Contact is the default value
    @api targetFieldApiName = 'OwnerId'; //AccountId is the default value
    @api fieldLabel = 'Owner Name';
    @api disabled = false;
    @api value;
    selectedOwnerId;
    AccountNameValue;

    accountColumns = [
        { label: 'Account Name', fieldName: 'Name', sortable: true },
        { label: 'Industry', fieldName: 'Industry', sortable: true },
        { label: 'Region', fieldName: 'Region__c', sortable: true },
        { label: 'Website', fieldName: 'Website', sortable: true },
        { label: 'Owner', fieldName: 'AccountOwner', sortable: true },
        
    ];

    contactsColumns = [
        { label: 'First Name', fieldName: 'FirstName' },
        { label: 'Last Name', fieldName: 'LastName' },
        { label: 'Account', fieldName: 'CompanyName' },
        { label: 'Job Title', fieldName: 'Title' },
        { label: 'Email Id', fieldName: 'Email' },
        
    ];
    accList;

    @wire(getAccount)
    wiredData({ data, error }) {
        if (data) {
            this.accounts = data.map(account => ({
                ...account,
                AccountOwner: account.Owner ? account.Owner.Name : ''
            }));
        }
        if (error) {
            this.handleApexError(error, 'Error fetching accounts.');
        }
    }
    @wire(contactLimit, { recordId: '$recordId' })
    wiredContactLimit({ error, data }) {
        if (data) {
            console.log('Contact Limit Data:', data); // Add logging here
            this.contactLimit = data.contactLimit;
            this.trackRequestContactCount = data.trackRequestContactCount;
            console.log('Contact Limit:', this.contactLimit);
            console.log('Track Request Contact Count:', this.trackRequestContactCount);
        } else if (error) {
            this.handleApexError(error, 'Error fetching contact limit.');
        }
    }


    
    


    @wire(getAcountIndustry)
    wiredgetAcountIndustry({ error, data }) {
        if (data) {
            this.IndustryOptions = data.map(option => ({
                label: option.label,
                value: option.value
            }));
            this.IndustryOptions.unshift({ label: 'All', value: 'All' });
        } else if (error) {
            this.handleApexError(error, 'Error fetching industry options.');
        }
    }

    @wire(getAcountRegionValues)
    wiredgetAcountRegionValues({ error, data }) {
        if (data) {
            this.RegionOptions = data.map(option => ({
                label: option.label,
                value: option.value
            }));
            this.RegionOptions.unshift({ label: 'All', value: 'All' });
        } else if (error) {
            this.handleApexError(error, 'Error fetching region options.');
        }
    }

    handleIndustryChange(event) {
        this.IndustryValue = event.detail.value;
        this.loadFilteredAccounts();
    }

    handleRegionChange(event) {
        this.RegionValue = event.detail.value;
        this.loadFilteredAccounts();
    }

    handleOwnerNameChange(event) {
        this.ownerNameValue = event.detail.value;
        this.loadFilteredAccounts();
    }

    handleChange(event) {
        const selectedEvent = new CustomEvent('valueselected', {
            detail: event.detail.value
        });
        this.dispatchEvent(selectedEvent);
    }

    handleOwnerChange(event) {
        this.selectedOwnerId = event.detail.value;
        this.loadFilteredAccounts();
    }
    handleAccountNameChange(event) {
        this.AccountNameValue = event.detail.value;
        this.loadFilteredAccounts();
    }

    async loadFilteredAccounts() {
        try {
            let industryFilter = this.IndustryValue !== 'All' ? this.IndustryValue : null;
            let regionFilter = this.RegionValue !== 'All' ? this.RegionValue : null;
            let ownerNameFilter = this.ownerNameValue ? '%' + this.ownerNameValue + '%' : null;
            let accountNameFilter = this.AccountNameValue ? '%' + this.AccountNameValue + '%' : null;


            const result = await getFilteredAccount({ industry: industryFilter, region: regionFilter, ownerName: ownerNameFilter,accountName:accountNameFilter });
            this.accounts = result.map(account => ({
                ...account,
                AccountOwner: account.Owner ? account.Owner.Name : ''
            }));
        } catch (error) {
            this.handleApexError(error, 'Error fetching filtered accounts.');
        }
    }

    SelectedRecords;

    handleRowSelection(event) {
        this.SelectedRecords = event.detail.selectedRows;
    }

    selectedAccountIds = [];

    handleNext() {
        this.showAccountTable = false;
        this.showContactTable = true;

        this.selectedAccountIds = this.SelectedRecords.map(row => row.Id);
        this.getContactDetails(this.selectedAccountIds);
        this.contacts = true;
    }

    handleback() {
        this.showAccountTable = true;
        this.showContactTable = false;
    }

    async getContactDetails(selectedAccountIds) {
        try {
            const result = await getContacts({ selectedAccounts: selectedAccountIds, recordId: this.recordId });
            this.contacts = result.map(contact => ({
                ...contact,
                CompanyName: contact.Account ? contact.Account.Name : '',
                Accwebsite: contact.Account ? contact.Account.Website : ''
                
            }));
           
        } catch (error) {
            this.handleApexError(error, 'Error fetching contacts.');
        }
    }

    handleContactRowSelection(event) {
        const selectedRows = event.detail.selectedRows;

        // Merge selected rows with the original contact data to include Accwebsite
        this.SelectedContactRecords = selectedRows.map(row => {
            const originalContact = this.contacts.find(contact => contact.Id === row.Id);
            return {
                ...row,
                Accwebsite: originalContact ? originalContact.Accwebsite : ''
            };
        });
    
        // Verify that Accwebsite is included
        console.log('Selected Contacts:', this.SelectedContactRecords);
        
    }

    SelectedContactRecords = [];

    async handleSave() {
        const selectedContactCount = this.SelectedContactRecords.length;
        const totalCount = this.trackRequestContactCount + selectedContactCount;

        if(this.contactLimit < totalCount){
            this.showToast('Error', 'Conatct Limit Reached.', 'error'); 
        }

        else if (selectedContactCount === 0) {
            this.showToast('Error', 'Please select at least one record to save.', 'error');
        } else {
            let modifiedContacts = this.SelectedContactRecords.map(contact => ({
                First_Name: contact.FirstName,
                Last_Name: contact.LastName,
                contactId: contact.Id,
                JobTitle: contact.Title,
                EmailId: contact.Email,
                Company: contact.CompanyName,
                website: contact.Accwebsite,
            }));
            this.saveContactsRecords(modifiedContacts, selectedContactCount);
        }
    }

    async saveContactsRecords(modifiedContacts, selectedContactCount) {
        try {
         //   const result = await createKContacts({ Kcontacts: modifiedContacts, recordId: this.recordId });
            createKContacts({Kcontacts: modifiedContacts, recordId: this.recordId })
              .then(result => {
                console.log("Result trackRequest Method ", JSON.stringify(result));
                console.log("Result--> ", result);
                if (result === 'Success') {
                    this.showToast('Success', `${selectedContactCount} Record(s) Saved Successfully.`, 'success');
                } else {
                    this.showToast('Error', JSON.stringify(result), 'error');
                }
                 this.closeAction();
               // this.closeQuickAction();
            })
            .catch(error => {
                console.log("Result trackRequest Error ", JSON.stringify(error));
                this.showToast('Error', 'An error occurred while processing your request.', 'error');
               // this.closeQuickAction();
            });
            this.closeAction();
           
        } catch (error) {
            this.handleApexError(error, 'Error occurred while saving records.');
        }
    }

    closeModal() {
        const closeModalEvent = new CustomEvent('closemodal');
        this.dispatchEvent(closeModalEvent);
        this.showAccountTable = false;
        this.showContactTable = false;
    }

    closeAction() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    handleApexError(error, customMessage) {
        console.error(customMessage, error);
        this.showToast('Error', customMessage, 'error');
    }

    showToast(title, message, variant) {
        const toastEvent = new ShowToastEvent({
            title,
            message,
            variant
        });
        this.dispatchEvent(toastEvent);
    }
}