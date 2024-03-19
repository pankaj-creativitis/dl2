import { LightningElement, api, track, wire } from 'lwc';
import getQueryData from '@salesforce/apex/ChatGPTController.getQueryData';
import generateArticleWithRelatedCases from '@salesforce/apex/ChatGPTController.generateArticleWithRelatedCases';
import saveResponseData from '@salesforce/apex/ChatGPTController.saveResposeData';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import getRelatedCases from '@salesforce/apex/ChatGPTController.getRelatedCases';
import getArticles from '@salesforce/apex/ChatGPTController.getArticles';
import getSelectedCases from '@salesforce/apex/CaseSelectorGPT.getCasesByIdsAura';
import updateArticleWithExistingCases from '@salesforce/apex/ChatGPTController.updateArticleWithExistingCases';


// const columns = [
//     { label: 'Id', fieldName: 'Id' },
//     { label: 'Subject', fieldName: 'Subject', type: 'text' },
//     { label: 'Description', fieldName: 'Description', type: 'text' },
// ];




export default class MakeKnowledgeArticle extends NavigationMixin(LightningElement) {

    error;
    @track ifCasesFound = false;
    // columns = columns;
    @track cases = false;
    @track casesFinal;
    @track isNoteMessageCases = true;
    @track casesLength = 0;
    @track cardTitleMessage = '';
    @track articles;
    @track isArticle = false;
    

    @api recordId;

    @track isModalOpen = false;
    @track gptResult = '';
    @track isSpinner = false;
    articleId = '';
    existingArticleId = '';
    isExisitingArticle ;

    openModal() {
        // to open modal set isModalOpen tarck value as true
        this.isModalOpen = true;
        this.isSpinner = false;
    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.caseIds = [];
        this.existingArticleId = ''
        this.casesLength = 0;
        this.isModalOpen = false;
        this.isNoteMessageCases = true;

       
        const toastEvent = new ShowToastEvent({
            title :'Closing Before Save !' ,
            message :' Article is not saved in an Object.',  
            variant :'error'  
          })

          this.dispatchEvent(toastEvent);

    }
    

    closeCases(){
        this.cases = false;
        this.caseIds = [];
        this.existingArticleId = ''
        this.casesLength = 0;
        this.isNoteMessageCases = true;

    }

    // connectedCallback(){
    //     console.log('recordId ==>', this.recordId);
    // }
    
    caseId = '';
    caseIds = [];
    
    handleChange(event){
    
      this.caseId = event.detail.selectedId;
      console.log('case Id ==>:', this.caseId);

       var isChecked = event.detail.checked;
      console.log('is Checked ==>:', isChecked);
    
      if(isChecked == true){
        this.caseIds.push(this.caseId);
        this.casesLength = this.caseIds.length;
        this.isNoteMessageCases = false;
      }else if(isChecked == false){

        for( var i = 0; i < this.caseIds.length; i++){ 
            if ( this.caseIds[i] === this.caseId ) { 
                this.caseIds.splice(i, 1); // to remove the case id from the array (deselect case id checkbox)
                this.casesLength = this.caseIds.length;
            }

            if (this.caseIds.length == 0) {
                this.isNoteMessageCases = true;
            }
        }
        
         //this.caseIds.remove(this.caseId);
      }
      
      
       console.log('case aray ==>:', this.caseIds);
    //     if(this.caseIds != []){
    //    getSelectedCases({caseIds: this.caseIds }).then((result)=>{
    //           //console.log('query result==> ', JSON.stringify(result));
    //           this.casesFinal = result;
    //           console.log('query result==> ', JSON.stringify(this.casesFinal));
    //    })
    //    .catch((error)=>{
    //     console.log('query result==> ', JSON.stringify(eror));
    //    })
      //console.log('case set ==>:', caseSet);
    // }

    }

    renderedCallback() {
        // this.caseIds = [];
    }

    initiateKnowledgeArticle(){

        getArticles({recordId: this.recordId})
        .then(result => {
            if (result.length == 0){
                this.articles = false;
                console.log('articles length ', result.length);
                // this.cardTitleMessage = 'Related Not Cases Found';
                //this.createKnowledgeArticle();
            }
            else if (result.length == '1'){
                console.log('articles length ', result.length);
                this.articles = result;
                // this.cardTitleMessage = 'Related Cases Not Found';
                //this.createKnowledgeArticle();
            }
            else {
                this.articles = result;
                // this.cardTitleMessage = 'Related Cases Found'
                // this.casesFinal = result;
            }
        })
        .catch(error => {
            console.log('error of getArticles ==> ', JSON.stringify(error));
            // this.isSpinner = false;
            const toastEvent = new ShowToastEvent({
                title :'Articles Fetch Error !' ,
                message : error.message.body,  
                variant :'error'  
              })
              this.dispatchEvent(toastEvent);
        })


        // Logic to get the related cases based on the case subject
        getRelatedCases({recordId: this.recordId})
        .then(result => {
            console.log('result of getRelatedCases ==> ', result);
            // this.ifCasesFound = true;
            // this.isModalOpen = true;
            if (result.length == 0){
                this.cases = false;
                console.log('cases length ', result.length);
                this.cardTitleMessage = 'Related Not Cases Found';
                //this.createKnowledgeArticle();
            }else
            if (result.length == '1'){
                console.log('cases length ==>', result.length);
                this.cases= result;
                this.cardTitleMessage = 'Related Cases Not Found';
                //this.createKnowledgeArticle();
            }
            else {
                this.cases = result;
                this.cardTitleMessage = 'Related Cases Found'
                // this.casesFinal = result;
            }
            

            // this.cases.forEach((cs, idx) =>{
            //     cs.Index = idx + 1; // Now each contact object will have a property called "number"
            // });
        })
        .catch(error=>{
            console.log('error of getRelatedCases ==> ', JSON.stringify(error));
            // this.isSpinner = false;
            const toastEvent = new ShowToastEvent({
                title :'Something went Wrong!!!' ,
                message : error.message.body,  
                variant :'error'  
              })
              this.dispatchEvent(toastEvent);
        })
    }


    createKnowledgeArticleProceed() {
        // console.log('caseIds ==> ', this.caseIds);

        if (this.caseIds.length == 0 && this.isExisitingArticle === false) {
            // console.log('for single ', this.caseIds.length);
            this.createKnowledgeArticle();
        }
        // else if(this.isExisitingArticle === true){
        //      this.updateArticleWithNewCase();
        //     console.log('aricleExisting ==> ', this.isExisitingArticle);

        //     console.log('Create with proceeding: article');
        // }
        else {
            // console.log('for multiple ', this.caseIds.length);
            this.createKnowledgeArticleWithRelatedCases();
        }
    }

    createKnowledgeArticleWithRelatedCases() {
        
        this.isSpinner = true;
        this.cases = false;
        generateArticleWithRelatedCases({
            recordId : this.recordId,
            caseIds : this.caseIds
        })
        .then(result => {
            console.log('result ==> ', result);
            var str = '';
            for(var i = 0; i < result.length; i++) {
                console.log(`result${[i]} ==> ` + result[i]);
                if (!result[i].includes('NA')) {
                    str = str + result[i];
                }
                
            }
            console.log('str ==> ' + str);
            str = str.trim();

            str = str.split('Definition');
            str = 'Definition' + str[1];

            console.log('str ==> ' + str);
            this.isSpinner = false;
            
            if (str == ''){
                this.isSpinner = false;
                const toastEvent = new ShowToastEvent({
                    title :'Error! Article cannot be generated.' ,
                    message :'Please provide proper content.',  
                    variant :'error'  
                })

                this.dispatchEvent(toastEvent);
            }else{

            // this.isSpinner = false;  //getting false in openModal
            // modified
            this.isSpinner = false;
            this.gptResult = str;
            //console.log('GPT Result ==>', this.gptResult)
            this.openModal();
            }
        })
        .catch(error=>{
            console.log('error ==> ', JSON.stringify(error));
            this.isSpinner = false;
            const toastEvent = new ShowToastEvent({
                title :'Something went Wrong!' ,
                message : error.message.body,  
                variant :'error'  
            })
            this.dispatchEvent(toastEvent);
        })
    }

    createKnowledgeArticle() {
        this.isSpinner = true;
        this.cases = false;
        getQueryData({
            recordId : this.recordId
        })
        .then(result => {
            //console.log('result ==> ', result);
            this.isSpinner = false;
        
            if (result == 'NA'){
                this.isSpinner = false;
                const toastEvent = new ShowToastEvent({
                    title :'Error!' ,
                    message :'Knowledge Article already exists !',  
                    variant :'error'  
                })

                this.dispatchEvent(toastEvent);
            }
            else if (result == null) {
                const toastEvent = new ShowToastEvent({
                    title :'Error! Article cannot be generated.' ,
                    message :'Please provide proper content.',  
                    variant :'error'  
                })

                this.dispatchEvent(toastEvent);
            }
            else{

            console.log('result without trim ==>', result);
            result = result.trim();
            result = result.split('Definition');
            result = 'Definition' + result[1];
            this.gptResult = result;
            //console.log('GPT Result ==>', this.gptResult)
            this.openModal();
            }
        })
        .catch(error=>{
            console.log('error ==> ', JSON.stringify(error));
            this.isSpinner = false;
            const toastEvent = new ShowToastEvent({
                title :'Something went Wrong!' ,
                message : error.message.body,  
                variant :'error'  
            })
            this.dispatchEvent(toastEvent);
        })
    }

    updateArticleHandler(event){
        console.log('Modified gpt result=> '+event.target.value);
        this.gptResult = event.target.value;
    }

    submitDetails() {
        this.isSpinner = true;
        this.isModalOpen = false;
        saveResponseData({
            recordId : this.recordId,
            caseIds : this.caseIds,
            gptResult : this.gptResult
        })
        .then(result =>{
            this.caseIds = [];
            console.log('result ==> ', result);
            this.articleId = result;
            this.isSpinner = false;
            // this.isModalOpen = false;

            const toastEvent = new ShowToastEvent({
                title :'Article Saved Successfully !' ,
                message :'Redirecting to Knowledge article',  
                variant :'success'  
              })
              this.dispatchEvent(toastEvent);
              this.navigateToViewArticlePage();
             

        })
        .catch(error =>{
            this.isSpinner = false;
            this.isModalOpen = false;
            console.log('error ==> ', error);
            this.caseIds = [];
            const toastEvent = new ShowToastEvent({
                title :'Something went wrong !' ,
                message :'Article is unable to Save',  
                variant :'error'  
              })
              this.dispatchEvent(toastEvent);
        })
       
    }

    //handleContent Article content should be displays from child
    handleContent(event){
        var content = event.detail.content
        console.log('Content from article:', content);
        this.isArticle = true;
      }

      //handleSelect -- Article is selected from the child
      handleSelect(event){
        // console.log('ABC:');
        //var isChecked = event.article.checked;
        console.log('is Checked ==>:', event.detail.checked);

        if(event.detail.checked === false){
            this.existingArticleId = '';
            this.isExisitingArticle = false;
            console.log('Existing know null:',this.existingArticleId);
        }else{
            this.existingArticleId = event.detail.articleId;
            this.isExisitingArticle = true;
        }
        
        
      }

    updateArticleWithNewCase(){
        this.isSpinner = true;
        this.cases = false;
        console.log('Exsisting Id presnet:',this.existingArticleId);
        updateArticleWithExistingCases({
            articleId: this.existingArticleId, 
            recordId: this.recordId,
            selectedCaseIds: this.caseIds
        })
        .then(result => {
            console.log('article from handleContent 1==> ', result);
            console.log('result ==> ', result);
            var str = '';
            for(var i = 0; i < result.length; i++) {
                console.log(`result${[i]} ==> ` + result[i]);
                if (!result[i].includes('NA')) {
                    str = str + result[i];
                }
                
            }
            console.log('str ==> ' + str);
            str = str.trim();

            str = str.split('Definition');
            str = 'Definition' + str[1];

            console.log('str ==> ' + str);
            this.isSpinner = false;
            
            if (str == ''){
                this.isSpinner = false;
                const toastEvent = new ShowToastEvent({
                    title :'Error! Article cannot be generated.' ,
                    message :'Please provide proper content.',  
                    variant :'error'  
                })

                this.dispatchEvent(toastEvent);
            }else{

            // this.isSpinner = false;  //getting false in openModal
            // modified
            this.isSpinner = false;
            this.gptResult = str;
            //console.log('GPT Result ==>', this.gptResult)
            this.openModal();
            }
        })
        .catch(error=>{
            console.log('error ==> ', JSON.stringify(error));
            this.isSpinner = false;
            const toastEvent = new ShowToastEvent({
                title :'Something went Wrong!' ,
                message : error.message.body,  
                variant :'error'  
            })
            this.dispatchEvent(toastEvent);
        })
    }

    navigateToViewArticlePage(){
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.articleId,
                objectApiName: 'Knowledge__kav',
                actionName: 'view'
            },
        });
    }
}