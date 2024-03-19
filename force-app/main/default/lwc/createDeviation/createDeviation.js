import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CreateDeviation extends LightningElement {
    handleSuccess() {
        const event = new ShowToastEvent({
            title: 'Deviation Added',
            message: 'Deviation Added',
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }
}