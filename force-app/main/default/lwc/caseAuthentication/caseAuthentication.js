import { LightningElement, track, wire, api } from 'lwc';
// import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import CHECK_ICON from '@salesforce/resourceUrl/otpverified';
import { FlowAttributeChangeEvent, FlowNavigationNextEvent } from 'lightning/flowSupport';
import getContactRecord from '@salesforce/apex/ContactAuthController.getContactList';

// import PHONE_FIELD from '@salesforce/schema/Contact.MobilePhone';
// const fields = [PHONE_FIELD];

export default class CaseAuthentication extends LightningElement {

    @api conId;
    @api caseId;
    @track show = false;
    @track error;
    contact = {};
    @api wireAmt;
    @api withdrawAmt;
    @api showSave;
    @api showOTP;
    @api showOTPButton;
    @api verified;
    @track disabled;
    icnCheck = CHECK_ICON;
    @api
    availableActions = [];
    

    @wire(getContactRecord, { recId: '$conId' })
    contacts({error, data}) {
        if (error) {
            this.error = 'Unknown error';
            if (Array.isArray(error.body)) {
                this.error = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                this.error = error.body.message;
            }
            console.log(this.error);
            this.record = undefined;
        } else if (data) {
            console.log(JSON.stringify(data[0]));
            this.show = true;
            this.contact = data[0];
            if(!this.verified){
                this.showOTPButton = true;

            }
            console.log('this.show >> ' + this.show);
            
        }
    }

    handleChange(event) {
        this.conId = (event.detail.value)[0];
       // alert(event.detail.value);
    }

    handleNumberChange(event) {
        // alert('here');
        // this.wireAmt = event.target.value;
        this.withdrawAmt = event.target.value;
    }

    handleGoNext() {
        //Hard coded
        /*
        this.showOTP = false;
        this.showOTPButton = false;
        this.verified = true;
        this.disabled = true;
        */
        // check if NEXT is allowed on this screen
        if (this.availableActions.find(action => action === 'NEXT')) {
            // navigate to the next screen
            const navigateNextEvent = new FlowNavigationNextEvent();
            this.dispatchEvent(navigateNextEvent);
        }
    }

    handleAccountCreated(event){
        this.caseId = event.detail.id;
        if (this.availableActions.find(action => action === 'NEXT')) {
            // navigate to the next screen
            const navigateNextEvent = new FlowNavigationNextEvent();
            this.dispatchEvent(navigateNextEvent);
        }

    }
}