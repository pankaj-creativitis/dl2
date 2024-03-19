import { LightningElement, api } from 'lwc';
import doSummary from '@salesforce/apex/CaseSummary.doSummary'

export default class CaseSummaryButton extends LightningElement {
    @api recordId;
    connectedCallback(){
        console.log('Record Id for CS :: ' + this.recordId);
    }

    isSpinner=false;
    doSummary(){
        this.isSpinner = true;
        doSummary({caseId : this.recordId})
        .then(result=>{
            this.isSpinner = false;
        })
        .catch(error=>{
            this.isSpinner = false;
            console.log('Error :: ' + JSON.stringify(error));
        })
    }
}