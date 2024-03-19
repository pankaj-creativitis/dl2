import { LightningElement, api, track } from 'lwc';
export default class GptCaseTable extends LightningElement {

    @api relatedCase;
    @api recordId;
    @track isDisabled = false;

    connectedCallback() {
        
        if (this.recordId == this.relatedCase.Id){
            this.isDisabled = true;
            console.log('disabled ==> ', this.isDisabled);
            console.log('recordId ==> ', this.recordId);
        }
    }

    handleClick(event){
        var isChecked;
        var customBody;
        if(event.target.checked == true){
            isChecked = true
            customBody = {checked: isChecked, selectedId: this.relatedCase.Id};
            // console.log('customBody in if ==> ', customBody);
        }else{
            isChecked= false;
            customBody = {checked: isChecked, selectedId: this.relatedCase.Id};
            // console.log('customBody in else ==> ', customBody);

        }

        const caseClickedEvent = new CustomEvent('clickrelatedcase',{ detail: customBody });
        this.dispatchEvent(caseClickedEvent);
    }

}