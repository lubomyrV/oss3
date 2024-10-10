import { LightningElement, api, track } from 'lwc';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import getContactList from '@salesforce/apex/DemoLwcController.getContactList';
import getContactInfo from '@salesforce/apex/DemoLwcController.getContactInfo';
import getError from '@salesforce/apex/DemoLwcController.getError';

const columns = [
    { label: 'Id', fieldName: 'Id', editable: false },
    { label: 'Name', fieldName: 'Name', type: 'text', editable: true },
    { label: 'Email', fieldName: 'Email', type: 'email', editable: true },
    { label: 'Phone', fieldName: 'Phone', type: 'phone', editable: true },
    { label: 'Birthdate', fieldName: 'Birthdate', type: 'date', editable: true }
];

export default class DemoLwc extends LightningElement {
    @api accountId;
    @track contacts = [];
    
    columns = columns;
    draftValues = [];
    
    hasRendered = false;
    receivedMessage;
    
    isLoading = false;

    connectedCallback() {
        // init method
        console.log('init lwc');
    }

    renderedCallback() {
        // after a component has finished the rendering phase
        if(this.hasRendered == false) {
            this.getJoke();
            this.hasRendered = true;
        }
    }

    queryTerm;
    
    handleKeyUp(evt) {
        this.queryTerm = evt.target.value;
    }

    getJoke() {
        // requires whitelisting of url (Setup -> CSP Trusted Sites)
        let url = 'https://icanhazdadjoke.com';
        fetch(url, {
            method: "GET",
            headers: {
                "Accept": "application/json"
            }
        }).then(
            (response) => {
                if (response.ok) {
                    return response.json();
                } 
            }
        ).then(responseJSON => {
            this.receivedMessage = responseJSON.joke;
        }).catch(error => {
            console.error(error);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Something went wrong.',
                    message: error.body.message,
                    variant: 'error'
                })
            );
        });
    }

    getErrorTest(event) {
        this.isLoading = true;
        let methodName = event.target.label;
        console.log(methodName);
        getError()
        .then(result => {
            console.log('getErrorTest result: ', JSON.stringify(result));
            return result;
        })
        .catch(error => {
            console.error(JSON.stringify(error));
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Something went wrong.',
                    message: error.body.message,
                    variant: 'error'
                })
            );
        })
        .finally(() => {
            this.isLoading = false;
        });
    }

    getContacts(event) {
        this.contacts = [];
        this.isLoading = true;

        let methodName = event.target.label;
        console.log(methodName);

        getContactList({ accountId: this.accountId })
        .then(result => {
            console.log('getContactList result: ',JSON.stringify(result));
            this.contacts = result;
            return result;
        })
        .then(result => this.doSomethingElse(result))
        .then(result => {
            console.log('new apex call: ',JSON.stringify(result));
            return getContactInfo({ contactId: result });
        })
        .then(result => {
            console.log('getContactInfo result: ',JSON.stringify(result));
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success!',
                    message: 'Contacts retrieved',
                    variant: 'success'
                })
            );
        })
        .catch(error => {
            console.error(JSON.stringify(error));
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Something went wrong.',
                    message: error.body.message,
                    variant: 'error'
                })
            );
        })
        .finally(() => {
            this.isLoading = false;
        });
    }

    handleShowLoading(){
        this.isLoading = !this.isLoading;
        setTimeout(() => {
            this.isLoading = false;
            }, 3000);
    }
    doSomethingElse(result){
        let resJson = JSON.stringify(result);
        let list = [];
        list = JSON.parse(resJson);
        let cont = {"Id": "00309000008tEcYATT", "Name": "Test Contact"};
        list.push(cont);
        return list[0].Id;
    }

    handleSave(event) {
        const updatedValues = event.detail.draftValues;
        console.log(JSON.stringify(updatedValues));
        this.draftValues = [];
    }

    handleSaveCustom(){
        let target = this.template.querySelector('[data-id="table-1"]');
        let currentContacts = target.querySelector('lightning-datatable').draftValues;
        console.log(JSON.stringify(currentContacts));
        this.draftValues = [];
    }

}