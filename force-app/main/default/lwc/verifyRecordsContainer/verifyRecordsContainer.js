import { LightningElement } from 'lwc';

export default class VerifyRecordsContainer extends LightningElement {
    isModalOpen;

    openModal() {
        // to open modal set isModalOpen tarck value as true
        this.isModalOpen = true;
    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
    }
}