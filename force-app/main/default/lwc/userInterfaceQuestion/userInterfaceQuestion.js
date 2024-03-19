import { LightningElement, api, track } from 'lwc';

export default class UserInterfaceQuestion extends LightningElement {

    @api questionRecord;

    connectedCallback(){
        console.log('questionRecord ==> ', JSON.stringify(this.questionRecord));
    }

    handleQuestion(){
        console.log('question text ==>', this.questionRecord.question )
        var customBody = {question: this.questionRecord.question };
        const questionClickedEvent = new CustomEvent('clickquestion', { detail: customBody });
        this.dispatchEvent(questionClickedEvent);


    }
}