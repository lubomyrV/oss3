import { LightningElement } from 'lwc';

export default class SecondLwc extends LightningElement {
    url;

    connectedCallback() {
        let url = document.location.href;
        this.url = url;
    }

    sendCustomeEvent(event) {
        console.log("Sending an url from  secondLwc.sendCustomeEvent");
        const e = new CustomEvent('newdataevent', {
            detail: {
                url: this.url
            },
        });
        this.dispatchEvent(e);
    }
}