import { LightningElement, api, track, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getSeals from '@salesforce/apex/FileManagerController.getSeals';
import sealDocuments from '@salesforce/apex/FileManagerController.sealDocuments';
import checkDocuments from '@salesforce/apex/FileManagerController.checkDocuments';

const columnsData = [
    { label: 'Document Name', fieldName: 'contentDocumentName', sortable: true },
    { label: 'Seal', fieldName: 'hasSeal', type: 'boolean', sortable: true },
    { label: 'Original', fieldName: 'isValid', type: 'boolean', sortable: true },
    { label: 'Link', fieldName: 'urlLink', type: 'url', typeAttributes: { label: "link", target: "_blank" } },
];

const SORT_DIRECTION = "asc";
const TITLE_SUCCESS = "Success";
const TITLE_ERROR = "Something went wrong";


export default class FileManager extends LightningElement {

    @api recordId;
    @track data;
    @track columns = columnsData;
    @track sortBy;
    @track sortDirection;
    wiredResults;
    iButtonDisabled = true;
    isLoading = false;

    connectedCallback() {
        console.log("connectedCallback");

    }

    @wire(getSeals, { recordId: "$recordId" })
    wiredRecords(value) {
        this.isLoading = true;
        console.log("wiredRecords");
        this.wiredResults = value;
        const { data, error } = value;
        if (data) {
            let newData = [];
            for (let i = 0; i < data.length; i++) {
                const element = data[i];
                let link = window.location.origin + "/lightning/r/ContentDocument/" + element.Content_Document_Id__c + "/view";
                newData.push(
                    {
                        id: element.Id,
                        contentDocumentName: element.Content_Document_Name__c,
                        hasSeal: element.Hash__c != null,
                        isValid: element.Is_Valid__c,
                        urlLink:  link,
                    }
                );
            }
            this.data = newData;
            this.isLoading = false;
        } else if (error) {
            this.showToastError(error);
        }
    }

    handleSort(event) {
        const { fieldName: sortedBy, sortDirection } = event.detail;
        const cloneData = [...this.data];

        cloneData.sort((a, b) => {
            let aVal = a[sortedBy].toString() ? a[sortedBy].toString().toLowerCase() : '';
            let bVal = b[sortedBy].toString() ? b[sortedBy].toString().toLowerCase() : '';
            return sortDirection === SORT_DIRECTION ? aVal.localeCompare(bVal) : bVal.localeCompare(aVal);
        });

        this.data = cloneData;
        this.sortBy = sortedBy;
        this.sortDirection = sortDirection;

    }

    getSelected(event) {
        const selectedRows = event.detail.selectedRows;
        console.log('selectedRows: ' + JSON.stringify(selectedRows));

        for (let i = 0; i < selectedRows.length; i++) {
            console.log('selected: ' + JSON.stringify(selectedRows[i]));
        }
        this.iButtonDisabled = !selectedRows.length > 0;
    }

    getSelectedIDs() {
        let datatable = this.template.querySelector('lightning-datatable');
        let selectedRows = datatable.getSelectedRows();
        let selectedIds = [];
        console.log("selected rows ", JSON.stringify(selectedRows));
        for (let i = 0; i < selectedRows.length; i++) {
            const element = selectedRows[i];
            selectedIds.push(element.id);
            
        }
        return selectedIds;
    }

    handleCheckSelected(event) {
        this.isLoading = true;
        let selectedIds = this.getSelectedIDs();
        this.iButtonDisabled = selectedIds.length > 0;
        checkDocuments({ documentIds: selectedIds })
        .then((result) => {
            this.showToastSuccess(result.length + " records were checked");
            return refreshApex(this.wiredResults);
        })
        .catch((error) => {
            this.showToastError(error);
        })
        .finally(() => {
            this.iButtonDisabled = true;
            this.isLoading =  false;
        });
    }

    handleSealSelected(event) {
        this.isLoading = true;
        let selectedIds = this.getSelectedIDs();
        this.iButtonDisabled = selectedIds.length > 0;
        sealDocuments({ documentIds: selectedIds })
        .then((result) => {
            this.showToastSuccess(result.length + " records were sealed");
            return refreshApex(this.wiredResults);
        })
        .catch((error) => {
            this.showToastError(error);
        })
        .finally(() => {
            this.iButtonDisabled = true;
            this.isLoading = false;
        });
    }

    get acceptedFormatsHelptext() {
        return "File formats that are supported " + this.acceptedFormats;
    }

    get acceptedFormats() {
        return ['.pdf', '.doc', '.docx', '.odt', '.xlsx', '.csv', '.txt', '.png', '.jpg', '.jpeg'];
    }

    handleUploadFinished(event) { 
        const uploadedFiles = event.detail.files; 
        let uploadedFileNames = ''; 
        for(let i = 0; i < uploadedFiles.length; i++) { 
            uploadedFileNames += uploadedFiles[i].name + ', '; 
        } 
        this.showToastSuccess(uploadedFiles.length + " files uploaded successfully: " + uploadedFileNames);
        
        getSeals({ recordId: this.recordId })
        .then((result) => {
            this.showToastSuccess(result.length + " records were saved");
            return refreshApex(this.wiredResults);
        })
        .catch((error) => {
            this.showToastError(error);
        });
    }

    showToastSuccess(msg) {
        this.dispatchEvent( 
            new ShowToastEvent({ 
                title: TITLE_SUCCESS, 
                message: msg, 
                variant: "success", 
            }), 
        );
    }

    showToastError(error) {
        console.error(error);
        this.dispatchEvent(
            new ShowToastEvent({
                title: TITLE_ERROR,
                message: error.body.message,
                variant: 'error'
            })
        );
    }

}