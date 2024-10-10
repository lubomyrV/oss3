import { LightningElement } from 'lwc';

export default class ChildComponent extends LightningElement {
    constructor() {
        super();
        console.log("constructor into ChildComponent");
    }

    connectedCallback() {
        throw new Error("Error from ChildComponent!");
    }
}