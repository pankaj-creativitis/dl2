import { LightningElement, track, wire, api } from 'lwc'; 
import getQueryData from '@salesforce/apex/SwaggerServiceController.makePostRequest';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import SUBJECT_FIELD from '@salesforce/schema/Case.Subject';
import STATUS_FIELD from '@salesforce/schema/Case.Status';
// const FIELDS = ['Contact.Name', 'Contact.Phone'];


export default class ChatGPTSearchResult extends LightningElement {

    @api recordId
    @track isAnswer = false;
    @track answer = '';
    @track query = '';
    @track error = '';
    @track caseDetail; 
    @track subject = '';

    @wire(getRecord, { 
        recordId: '$recordId', 
        fields: [SUBJECT_FIELD, STATUS_FIELD] 
    })
    wiredRecord({ error, data }) {
        if (error) {
            this.error = error.body.message;
            console.log('Error ==>', this.error);
        } else if (data) {
         
            this.caseDetail = data;   
            this.subject = this.caseDetail.fields.Subject.value;
            console.log('Data ==>', this.caseDetail);
            console.log('Subject ==>', this.subject);
        }
    }

    // @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    // wiredRecord({ error, data }) {
    //     if (error) {
    //         message = error.body.message;
    //     } else if (data) {
    //         this.contact = data;   
    //     }
    // }


    handleQueryResult(){
        getQueryData({query: this.subject, docs: this.subject})
        .then((result)=>{
            this.answer = result.answer;
            this.isAnswer = true;
            console.log('this.answer ==>', JSON.stringify(result));
            console.log('Answer ==>', JSON.stringify(result.answer));

        })
        .catch((error)=>{
           this.error = error;
           console.log('this.answer ==>', JSON.stringify(this.error));

        })
    }
    
}