import { LightningElement, api, wire, track  } from 'lwc';
import getFileIds from "@salesforce/apex/FilesController.getFileIds";
import getFileIdsImp from '@salesforce/apex/FilesController.getFileIds';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

export default class UploadMultipleFiles extends LightningElement {
    @api recordId;
    @track cntDocIds;
    @wire(getFileIds, { objId: '$recordId' })
    async wiredFileIds({ error,
        data }) {
        if (error) {
            this.error = error;
        } else if (data) {
            console.log('data here >>>>>> ' + JSON.stringify(data));

            let parsedValue = [...data];
            let newData = [];

            parsedValue.forEach(function (item, i) {
                console.log('item here >>>>>> ' + JSON.stringify(item));
                item = Object.assign({}, item, { src: '/sfc/servlet.shepherd/document/download/' + item.ContentDocumentId });
                newData.push(item);
            });


            this.cntDocIds = newData;
            console.log('new data here >>>>>> ' + JSON.stringify(this.cntDocIds));
        }


    }

    
    handleUpdate() {
        getFileIdsImp()
            .then(data => {
                this.contacts = data;

                let parsedValue = [...data];
                let newData = [];
    
                parsedValue.forEach(function (item, i) {
                    console.log('item here >>>>>> ' + JSON.stringify(item));
                    item = Object.assign({}, item, { src: '/sfc/servlet.shepherd/document/download/' + item.ContentDocumentId });
                    newData.push(item);
                });
    
    
                this.cntDocIds = newData;
                console.log('new data here >>>>>> ' + JSON.stringify(this.cntDocIds));

            })
            .catch(error => {
                this.error = error;
            });
    }

    

    get acceptedFormats() {
        return ['.pdf', '.png','.jpg','.jpeg'];
    }
    handleUploadFinished(event) {
        // Get the list of uploaded files
        const uploadedFiles = event.detail.files;
        let uploadedFileNames = '';
        for(let i = 0; i < uploadedFiles.length; i++) {
            uploadedFileNames += uploadedFiles[i].name + ', ';
        }
        
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: uploadedFiles.length + ' Files uploaded Successfully: ' + uploadedFileNames,
                variant: 'success',
            }),
        );
    }
}