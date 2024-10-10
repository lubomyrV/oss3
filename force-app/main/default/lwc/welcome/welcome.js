import { LightningElement, track } from 'lwc';
import getInfo from '@salesforce/apex/WelcomeController.getInfo';

export default class Welcome extends LightningElement {
    @track userData;

    connectedCallback() {
        // init method
        // console.log('init welcome');
        this.getInfoApex();
    }

    getInfoApex() {
        getInfo({ data: new Date() })
        .then(result => {           
            console.log('getInfo result>>> ', result);
            this.userData = result.data;
        }).catch(error => {
            console.error(error);
        });
    }
}