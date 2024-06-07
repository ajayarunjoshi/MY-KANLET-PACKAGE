import { LightningElement, api, wire } from 'lwc';
import configurationDetails from '@salesforce/apex/GetKeyContactSpecs.GetKeyContactSpec';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import { CurrentPageReference } from 'lightning/navigation';



export default class GetConfigButton extends LightningElement {
    @api recordId;
    currentPageReference = null;
    kanletLicenseId;

    // Wire to get the record data
   
    kanletConfig;

    @wire(CurrentPageReference)
    getPageReferenceParameters(currentPageReference) {
        if (currentPageReference) {
            console.log("currentPageReference ==>", currentPageReference);
            this.recordId = currentPageReference.state.recordId;
            console.log("this.recordId ==>", this.recordId);
        }
    }

    connectedCallback() {
        this.handleTrack();
    }

    handleTrack() {
        // Get the field values as integers
        
        configurationDetails({ 
            kanletLicenseId: this.recordId,
        })
        .then(result => {
            console.log('Configuration Details==> ', JSON.stringify(result));

            if (result === 'Success') {
                this.showToast('Success', 'ICP Record Created Successfully', 'success');
            } else {
                this.showToast('Error', JSON.stringify(result), 'error');
            }
            this.closeQuickAction();
        })
        .catch(error => {
            console.log("Result Configuration Error==>", JSON.stringify(error));
            this.showToast('Error', 'Error Occurred', 'error');
            this.closeQuickAction();
        });
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(event);
    }

    closeQuickAction() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}