import { LightningElement, api } from 'lwc';
import getPageAttachment from '@salesforce/apex/OneNoteController.getPageAttachment';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class GetContentFromOneNote extends LightningElement {

    @api recordId;

    connectedCallback(){
        console.log('recordId of Contact ==> ' + this.recordId);
    }



    handleGetContentFromOneNote(){
        console.log('handleGetContentFromOneNote Called.')
        getPageAttachment({
            recordId : this.recordId
        })
        .then(result => {
            // console.log('result (Status Code) ==> ', result);
            // var toastMsg = '';
            // if (result == 200){
            //     toastMsg = 'success';
            // }
            // else if (result == 400) {
            //     toastMsg = 'error';
            // }
            const toastEvent = new ShowToastEvent({
                title : 'Success' ,
                message :'',  
                variant :'success'  
                })

            this.dispatchEvent(toastEvent);
            
        })
        .catch(error=>{
            console.log('Error from One Note call ==> ', JSON.stringify(error));
            const toastEvent = new ShowToastEvent({
                title : 'Error' ,
                message :'',  
                variant :'error'  
                })

            this.dispatchEvent(toastEvent);
        })
    }
}