import { LightningElement, api, wire } from 'lwc';
import { FlowAttributeChangeEvent, FlowNavigationNextEvent } from 'lightning/flowSupport';
import getQuestion from "@salesforce/apex/QuestionnaireController.renderQuestion";
import captureResponse from "@salesforce/apex/QuestionnaireController.updateOtherResponses";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class Question extends LightningElement {
    @api recId;
    @api readOnly;
    @api matrixColumns;
    // @wire(getQuestion, { recId: '$recordId' })
    @api
    availableActions = [];
    questionRecord;
    queryText;
    questionType;
    options = [];
    value = '';
    values = [];
    answer;
    selectedOptions;
    differentiator;

    isText = false;
    isDropdown = false;
    isMulti = false;
    isMatrix = false;

    async connectedCallback() {
        this.questionRecord = await getQuestion({recId: this.recId});
        console.log('q rec >> ' + JSON.stringify(this.questionRecord));
        // this.queryText = this.questionRecord.Question_Text__c;
        this.queryText = this.questionRecord.Question_Long_Text__c;
        
        this.questionType = this.questionRecord.Question_Type__c;
        if(this.questionType == 'Dropdown' || this.questionType == 'Multi-select'){
            if(this.questionType == 'Dropdown'){
                this.isDropdown = true;
                this.selectedOptions = this.questionRecord.Selected_Option_s__c;
            } else {
                this.isMulti = true;
                this.values = this.questionRecord.Selected_Option_s__c.split(',');
            }
            
            let optionStr = this.questionRecord.Options__c.split(",");
            console.log('text >> ' + optionStr);
    
            for(var i in optionStr) {    
    
                var item = optionStr[i];   
            
                this.options.push({ 
                    'label' : item,
                    'value'  : item
                });
            }
        } else{
            this.isText = true;
            this.answer = this.questionRecord.Answer__c;
        }
        console.log('readOnly >>>> ' + this.readOnly);
        
    }

    // handle Text Answer values
    handle_answer_Change(e) {
        this.answer = e.detail.value;
    }

    // handle Single-Select values
    changedValue(e) {
        this.selectedOptions = e.detail.value;
    }

    // handle Multi-Select values
    get selectedValues() {
        return this.values.join(',');
    }

    handleChange(e) {
        this.values = e.detail.value;
    }

    handle_Submit(event){

        if(this.questionType == 'Dropdown'){
            this.differentiator = this.selectedOptions;
        } else {
            this.differentiator = this.selectedValues;
        }

    captureResponse({ 
        recId: this.recId, 
        selectedOptions: this.differentiator, 
        answer: this.answer,
        qType: this.questionType
    })
    .then(result => {
        const event = new ShowToastEvent({
            title: 'Response captured',
            message: 'Response captured.',
            variant: 'success'
        });
        this.dispatchEvent(event);

        // check if NEXT is allowed on this screen
        if (this.availableActions.find(action => action === 'NEXT')) {
            // navigate to the next screen
            const navigateNextEvent = new FlowNavigationNextEvent();
            this.dispatchEvent(navigateNextEvent);
        }
    })
    .catch(error => {
        const event = new ShowToastEvent({
            title : 'Error',
            message : 'Error creating contact. Please Contact System Admin',
            variant : 'error'
        });
        this.dispatchEvent(event);
    });
}

}