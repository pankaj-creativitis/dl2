import { LightningElement, api, track } from 'lwc';

export default class DisplayCheckArticle extends LightningElement {
    @api articleContent;
    @track isModalOpen = false;
    

    connectedCallback() {
        if (this.articleContent != '') {
            this.isModalOpen = true;
            console.log('articleContent from displaycheck ==> ', this.articleContent);
        }

        console.log('articleContent from displaycheck ==> ', this.articleContent);
    }

    closeModal() {
        this.isModalOpen = false;
        this.articleContent = '';
        const contentClickedEvent = new CustomEvent('articleclose', { detail: false });
        this.dispatchEvent(contentClickedEvent);
    }
}