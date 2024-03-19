import { LightningElement ,api} from 'lwc';
import { FlowAttributeChangeEvent, FlowNavigationNextEvent } from 'lightning/flowSupport';

export default class ACHReviewPage extends LightningElement {

    @api accountHolderType;
    @api bankName  ;
    @api routingNumber ;
    @api dateACH ;
    @api accountNumber ;
    @api aCHAmount ;
    @api accountName;


    handleGoNext() {
            
        //if (this.availableActions.find(action => action === 'NEXT')) {
            // navigate to the next screen
            const navigateNextEvent = new FlowNavigationNextEvent();
            this.dispatchEvent(navigateNextEvent);
        //}
    }
}