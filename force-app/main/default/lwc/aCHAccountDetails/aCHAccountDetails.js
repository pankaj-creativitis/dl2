import { LightningElement, api , track} from 'lwc';
import { FlowAttributeChangeEvent, FlowNavigationNextEvent } from 'lightning/flowSupport';

export default class ACHAccountDetails extends LightningElement {

    @api accountHolderType = 'Individual';
    @api bankName = "My Bank Name" ;
    @api routingNumber = "1100000";
    @api dateACH = "2023-06-03";
    @api accountNumber = "000123456789";
    @api aCHAmount = "5000";
    @api accountName;

    myDate = new Date("2023-06-03");

    get options() {
        return [
            { label: 'Individual', value: 'Individual' },
            { label: 'Joint', value: 'Joint' }]

        }        

        handleGoNext() {
            
            //if (this.availableActions.find(action => action === 'NEXT')) {
                // navigate to the next screen
                const navigateNextEvent = new FlowNavigationNextEvent();
                this.dispatchEvent(navigateNextEvent);
            //}
        }

        updateAccountHolderType(eve){
            this.accountHolderType = eve.detail.value;
        }

        updateBankName(eve){
            this.bankName = eve.detail.value;
        }

        updateRoutingNumber(eve){
            
            this.routingNumber = eve.detail.value;
        }

        updatedateACH(eve){
            this.dateACH = eve.detail.value;
        }

        updateAccountNumber(eve){
            this.accountNumber = eve.detail.value;
        }

        updateACHAmount(eve){
            this.aCHAmount = eve.detail.value;
        }
        
}