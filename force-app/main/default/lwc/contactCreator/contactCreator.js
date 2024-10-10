import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import SOBJECT from '@salesforce/schema/Contact';
import FIRST from '@salesforce/schema/Contact.FirstName';
import LAST from '@salesforce/schema/Contact.LastName';
import EMAIL from '@salesforce/schema/Contact.Email';

export default class ContactCreator extends LightningElement {

    objectApiName = SOBJECT;
    fields = [FIRST, LAST, EMAIL];

    handleSuccess(event) {
        const toastEvent = new ShowToastEvent({
            title: "Contact created",
            message: "Record ID: " + event.detail.id,
            variant: "success"
        });
        this.dispatchEvent(toastEvent);
    }
}