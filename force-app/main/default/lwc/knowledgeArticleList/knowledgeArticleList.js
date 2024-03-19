import { LightningElement, api, track } from 'lwc';

export default class KnowledgeArticleList extends LightningElement {
    
    @api articleRecord;
    @track isChecked=false;
    @track isArticle = false;
   
    connectedCallback(){
        console.log('articleRecord ==> ', JSON.stringify(this.articleRecord));
    }

    handleArticle(){
        console.log('Article ==>', this.articleRecord.Answer__c )
        var customBody = {content: this.articleRecord.Answer__c };
        const contentClickedEvent = new CustomEvent('clickcontent', { detail: customBody });
        this.dispatchEvent(contentClickedEvent);

        if (this.articleRecord.Answer__c != '') {
            this.isArticle = true;
        }
    }

    handleClose() {
        this.isArticle = false;
    }

    


    handleClick(event){
        var isChecked;
        var customBody;
        if(event.target.checked == true){
            isChecked = true
            customBody = {checked: isChecked, articleId: this.articleRecord.Id};
            // console.log('customBody in if ==> ', customBody);
        }else{
            isChecked= false;
            customBody = {checked: isChecked, articleId: this.articleRecord.Id};
            // console.log('customBody in else ==> ', customBody);

        }
        const articleClickedEvent = new CustomEvent('clickrelatedarticle',{ detail: customBody });
        this.dispatchEvent(articleClickedEvent);
    }

}