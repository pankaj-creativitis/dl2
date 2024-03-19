import { LightningElement, api } from 'lwc';

export default class NovaUtility extends LightningElement {
    @api url;
    @api label;
    connectedCallback(){
        this.callAnchor(this.url);
    }

    callAnchor(url){
        let downloadElement = document.createElement('a');
        downloadElement.href = url;
        downloadElement.target = '_blank';
        document.body.appendChild(downloadElement);
        downloadElement.click(); 
    }
}