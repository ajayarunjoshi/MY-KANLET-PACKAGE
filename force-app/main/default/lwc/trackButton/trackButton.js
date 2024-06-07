import { LightningElement, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import trackRequest from '@salesforce/apex/TrackButtonController.getContacts';
import { CurrentPageReference } from 'lightning/navigation';
import { CloseActionScreenEvent } from 'lightning/actions';

export default class TrackButton extends LightningElement {
    @api recordId;
    currentPageReference = null;

    handleClick() {
        this.handleTrack();
    }

    handleTrack() {
        trackRequest({ trackRequestId: this.recordId })
            .then(result => {
                console.log("Result trackRequest Method ", JSON.stringify(result));
                console.log("Result--> ", result);
                if (result === 'Success') {
                    this.showToast('Success', 'Contacts Successfully sent to Kanlet.', 'success');
                } else {
                    this.showToast('Error', JSON.stringify(result), 'error');
                }
                this.closeQuickAction();
            })
            .catch(error => {
                console.log("Result trackRequest Error ", JSON.stringify(error));
                this.showToast('Error', 'An error occurred while processing your request.', 'error');
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

    @wire(CurrentPageReference)
    getPageReferenceParameters(currentPageReference) {
        if (currentPageReference) {
            console.log("currentPageReference ==>", currentPageReference);
            this.recordId = currentPageReference.state.recordId;
            console.log("this.recordId ==>", this.recordId);
        }
    }
}