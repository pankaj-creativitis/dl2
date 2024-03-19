import { LightningElement, track , api} from 'lwc';
import getAnswerFromChatGPT from '@salesforce/apex/ChatGPTIntegration.getAnswerFromChatGPT';
//import apexcharts from '@salesforce/resourceUrl/ChartJs';
import summerizeCase from '@salesforce/apex/ChatGPTIntegration.summerizeCase';
import accountDetails from '@salesforce/apex/ChatGPTIntegration.accountDetails';
import CHATBOT_SPINNER from "@salesforce/resourceUrl/ChatBotSpinner";
import LOGO_URL from '@salesforce/resourceUrl/ChatBotLogo';

export default class UserInterface1 extends LightningElement {
   

  
  @api comment;
  
  @track question = '';
  @track answer = '';
  @track typedMessage = [];
  @track childHide = true;
  @track selectedQuestion = {};
  @track showAnswer = false;
  @track tableview =false;
  @track childHide1= false;
  
  @track questions
//   @track summaryWrap = '';
//   @track caseManipulation = false;
//   @track caseSummary = false;
//   @track accountDetail = false;
  @track spinner = CHATBOT_SPINNER;
  isSpinner = false;
  logoUrl = LOGO_URL;
 

  get messageTime() {
    const dt = new Date();
    const min = dt.getMinutes() >= 10 ? dt.getMinutes() : "0" + dt.getMinutes();
    return `${dt.getHours()}:${min}`;
  }
  
    handleKeyDown(event) {
        if (event.key === 'Enter') {
            this.handleSend();
            const inboundMessages = this.template.querySelectorAll('.slds-chat-message__text_inbound');
                if (inboundMessages && inboundMessages.length > 0) {
                    const lastInboundMessage = inboundMessages[inboundMessages.length - 1];
                    lastInboundMessage.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
    }
    }

    handleInputChange(e) {
        this.question = e.target.value;
         
    }
    handleSend() {
        this.isSpinner = true;
        this.question = this.question.trim();
        const containsNumber = /\d/.test(this.question);
        const containsEmail = /\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,7}\b/.test(this.question);
        console.log('this is typed message '+ JSON.stringify(this.question));
        const inboundMessages = this.template.querySelectorAll('.slds-chat-message__text_inbound');
            const lastInboundMessage = inboundMessages[inboundMessages.length - 1];
        if (lastInboundMessage) {
             lastInboundMessage.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
  
        if (this.question != "" ) {
            let struct = {
                messageType: true,
                message: this.question
            }
          
            this.typedMessage.push(struct);
            console.log('this is struct1 '+ struct);
            this.tableview=false;
            // call apex method
            // this.re

            if (containsNumber) {
                summerizeCase({ question: this.question })
                .then(result => {
                    this.isSpinner = false;
                   // this.caseManipulation = true;
                    console.log('this is result from chatgpt '+ JSON.stringify(result));
                        this.answer = result;
                        if (this.answer != "") {
                            let struct = {
                                messageType: false,
                                message: this.answer
                            }
               
                 this.typedMessage.push(struct);
                  const inboundMessages = this.template.querySelectorAll('.slds-chat-message__text_inbound');
                       if (inboundMessages && inboundMessages.length > 0) {
                       const lastInboundMessage = inboundMessages[inboundMessages.length - 1];
                      lastInboundMessage.scrollIntoView({ behavior: 'smooth', block: 'start' });
                     }
                 console.log('this is struct2 '+ struct);
                 
                }
               
                
            })
                    .catch(error => {
                        // Handle error from generateSummary method
                        console.error(error);
                    });
                }else if(containsEmail){
                    accountDetails({ question: this.question })
                    .then(result => {
                        this.isSpinner = false;
                      //  this.accountDetail = true;
                        console.log('this is result from chatgpt '+ JSON.stringify(result));
                            this.answer = result;

                            if (this.answer != "") {
                                let struct = {
                                    messageType: false,
                                    message: this.removeStartAndEnd(this.answer)
                                }
                   
                     this.typedMessage.push(struct);
                  const inboundMessages = this.template.querySelectorAll('.slds-chat-message__text_inbound');
                       if (inboundMessages && inboundMessages.length > 0) {
                       const lastInboundMessage = inboundMessages[inboundMessages.length - 1];
                      lastInboundMessage.scrollIntoView({ behavior: 'smooth', block: 'start' });
                     }
                     console.log('this is struct2 '+ struct);
                     
                    } 
                    
                })
                        .catch(error => {
                            // Handle error from generateSummary method
                            console.error(error);
                        });
                }else {
                    getAnswerFromChatGPT({ question: this.question})
                    .then(result => {
                        this.isSpinner = false;
                       // this.caseSummary = true;
                    console.log('this is result from chatgpt '+ JSON.stringify(result));
                    console.log('this is result from chatgpt---'+ result.answer);
                    console.log('this is result from chatgpt-- '+ JSON.stringify(result.answer) +JSON.stringify(result.caseNumber));
                        this.answer = result;
                        if (this.answer != "") {
                            let struct = {
                                messageType: false,
                                message: this.removeStartAndEnd(this.answer)
                                // message: this.answer
                            }
                            // this.question = '';
                            // this.summaryWrap = '';
               
                 this.typedMessage.push(struct);
                  const inboundMessages = this.template.querySelectorAll('.slds-chat-message__text_inbound');
                       if (inboundMessages && inboundMessages.length > 0) {
                       const lastInboundMessage = inboundMessages[inboundMessages.length - 1];
                      lastInboundMessage.scrollIntoView({ behavior: 'smooth', block: 'start' });
                     }
                     
                 console.log('this is struct2 '+ this.typedMessage);
                 
                }
                const chartData = this.processResponseData(result);

               // Render the chart
               this.renderChart(chartData);
                // this.answer = '';
            })
            .catch(error => {
                console.error('An error occurred:',JSON.stringify( error));
                this.addBotMessage = JSON.stringify( error);
            });
        }
    }
        this.question = '';
    
   }

   
    handleReceiveChange(e) {
        this.answer = e.target.value;
    }

    handleQuestion(event){
        console.log('question from child:', event.detail.question);
        this.question = event.detail.question;
        if(this.question != undefined){
            this.handleSend();
            this.tableview = true;
            //this.childHide = false;
            this.childHide1 = false;
        }
    }

    //remove the start and end with "" 
    removeStartAndEnd(gptAnswer){

        let filterInitial = gptAnswer.substring(
            gptAnswer.indexOf('"') + 1, 
            gptAnswer.lastIndexOf('"'))
        return filterInitial;
    }
   
    homeScreen(){
        
        this.childHide = false;
        this.tableview =false;
        this.childHide1 = true;
        
        console.log('this is childhide'+ this.childHide)
    }

    


 handleQuestionClick(event){
   // this.tableview= false;
    const questionId = event.currentTarget.dataset.id;
   
  
   //const questionId = this.template.querySelector('[data-id = "text"]').value;
    console.log('thsi is question id : '+questionId );
    
   // const texts = questions.map(({ text }) => text);
   // console.log('thsi is question length: '+this.texts.text);
    const values=[''];
    var j=0;
    for(var i=0; i <= this.questions.length; i++){
     if(questionId == this.questions[i].id){
        this.question = this.questions[i].question;
        this.handleSend();
        
       // this.childHide1 = false;
        console.log('this is test  text'+  this.questions[i].question)
     }
    }   
}

// fetchAnswerFromApex(questionId) {
//     // Make an API call to Apex using questionId
//     // Replace the below code with your actual API call implementation
//     // For simplicity, using a setTimeout to simulate the API call
//     setTimeout(() => {
//         // Assuming the answer is received from Apex
//         this.answer = 'Answer fetched from Apex';
//         this.showAnswer = true;
//     }, 1000);
// }
processResponseData(responseData) {
    // Process the response data to extract the necessary information for the chart
    // and return the chart data
    return [];
}
renderChart(chartData) {
    Promise.all([
        loadScript(this, apexcharts + '/chartJs.min.js')
    ])
    .then(() => {
        // ApexCharts script loaded successfully
        const options = {
            // Set options for the chart
            labels: ['Female','Male'],
            type: 'bar',
            datasets: [
                {
                    label: 'Sales',
                    data: [70,30]
                }
            ]
        };

        const chartElement = this.template.querySelector('.chartContainer');
        new window.ApexCharts(chartElement, options).render();
    })
    .catch(error => {
        // Error loading ApexCharts script
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error',
                message: 'Error loading ApexCharts',
                variant: 'error'
            })
        );
    });
}
}