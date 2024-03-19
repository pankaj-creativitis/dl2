import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class DynaLdsLwc extends LightningElement {
    @api recordId;
    @api objectApiName;
    @api fldStr;
    @api parentField;
    @api parentId;
    @api renderType;

    // @api fldSet = ['FirstName', 'LastName', 'Email'];
    fldSet;
    actionLabel;
    isList;
    isSingle;
    saveUpdateTag;

    connectedCallback() {
        this.setFldSet();

        
    }
    setFldSet() {
        // this.fldStr;
        if (this.fldStr) {
            this.fldSet = this.fldStr.split(',');
        }

    }

    updateSuccess(event) {
        console.log('success> ' + event.detail.id);
        if (this.parentId) {

            console.log('parentId > ' + this.parentId);
            const inputFields = this.template.querySelectorAll(
                'lightning-input-field'
            );
            if (inputFields) {
                inputFields.forEach(field => {
                    
                    console.log('field.name > ' + field.fieldName);
                    console.log('parentField > ' + this.parentField);
                    if(field.fieldName != this.parentField) {
                        field.reset();
                    }
                });
            }
            const newRecEvent = new CustomEvent("createdrecord", {
                detail: event.detail.id
            });
            this.dispatchEvent(newRecEvent);
            const eventToast = new ShowToastEvent({
                title: 'Success',
                message: 'Record Created',
                variant: 'success'
            });
            this.dispatchEvent(eventToast);
        } else {
            const eventToast = new ShowToastEvent({
                title: 'Success',
                message: 'Record updated',
                variant: 'success'
            });
            this.dispatchEvent(eventToast);
            const updateRecEvent = new CustomEvent("updatedrecord", {
                detail: false
            });
            this.dispatchEvent(updateRecEvent);
        }


    }
}