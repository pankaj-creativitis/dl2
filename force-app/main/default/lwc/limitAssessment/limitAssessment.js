import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class LimitAssessment extends LightningElement {
    @api headerStr;
    @api objectName;
    @api recId;
    @api fieldString;
    fldSet;
    baseContent = true;
    showResult = false;
    showSpinner = false;
    isOpenModal = false;

    connectedCallback() {
        this.setFldSet();
    }
    setFldSet() {
        // this.fldStr;
        if (this.fieldString) {
            this.fldSet = this.fieldString.split(',');
        }

    }

    showResultDiv(){
        this.showSpinner=true;
        setTimeout(() => { 
            this.showSpinner=false;
            this.showResult = true;
        }, 2000);
        
    }

    updateSuccess(event) {
        console.log('success> ' + event.detail.id);
        
            const eventToast = new ShowToastEvent({
                title: 'Success',
                message: 'Assessment Saved',
                variant: 'success'
            });
            this.dispatchEvent(eventToast);
            const updateRecEvent = new CustomEvent("updatedrecord", {
                detail: false
            });
            this.dispatchEvent(updateRecEvent);
    }

    handleOpenModal() {
        this.isOpenModal = true;
        this.data = this.data1;
    }
   
    handleCloseModal() {
        this.isOpenModal = false;
    }

}