import { api, LightningElement } from 'lwc';
import IMG_ZIP from '@salesforce/resourceUrl/callflow';
import { FlowAttributeChangeEvent, FlowNavigationNextEvent, FlowNavigationBackEvent } from 'lightning/flowSupport';

export default class Header extends LightningElement {
    icnUrl;
    gotImg = false;
    @api imgName;
    @api headerText;
    @api headerTextFront;
    @api keyValue;
    formattedKeyValue;
    @api subText;
    @api subText2;
    @api variable1;
    @api variable2;
    @api variable3;
    @api middleMessage;
    @api showNextPrevious;
    @api
    availableActions = [];

    connectedCallback() {
        if(this.imgName){
            this.gotImg = true;
            // need to get rid of the PSLtheme folder in between
            // this.icnUrl = IMG_ZIP + '/PSLtheme/' + this.imgName;
            this.icnUrl = IMG_ZIP + '/' + this.imgName;
            console.log('this.icnUrl >> ' + this.icnUrl);
        }
        if(this.keyValue){
            this.formattedKeyValue = this.keyValue.toLocaleString('en-IN');
        }
    }

    handlePrevious(){
        // check if NEXT is allowed on this screen
        if (this.availableActions.find(action => action === 'BACK')) {
            // navigate to the next screen
            const navigateBackEvent = new FlowNavigationBackEvent();
            this.dispatchEvent(navigateBackEvent);
        }
    }

    handleNext() {
            // check if NEXT is allowed on this screen
            if (this.availableActions.find(action => action === 'NEXT')) {
                // navigate to the next screen
                const navigateNextEvent = new FlowNavigationNextEvent();
                this.dispatchEvent(navigateNextEvent);
            }
    }
}