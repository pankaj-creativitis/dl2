import { LightningElement, api, wire, track } from 'lwc';
import fetchRecords from '@salesforce/apex/RelatedListController.fetchRecords';
import { deleteRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

export default class DynaLwcLdsList extends LightningElement {
    @api objectName;
    @api parentObjectName;
    @api fieldName;
    @api fieldValue;
    @api parentFieldAPIName;
    @api recordId;
    @api strTitle;
    @api filterType;
    @api operator;
    @api fieldsList;
    @api relationshipApiName;
    @track field1;
    @track field2;
    @track field3;
    @track field4;
    @track listRecords;
    @track titleWithCount;
    @track countBool = false;

    @track loopRecs;
    @track showRecs;
    @track reserveRecs;
    @track indexVal;
    @track loadMoreFlag;
    @track updateRecId;
    @track deleteRecId;
    @track error;
    //Boolean tracked variable to indicate if modal is open or not default value is false as modal is closed when page is loaded 
    @track isModalOpen = false;
    @track addNew = true;

    createdId;
    delId;
    editId;

    connectedCallback() {

        var listFields = this.fieldsList.split(',');
        this.indexVal = 0;
        console.log('Fields are ' + listFields);

    }

    get vals() {

        /*
        return this.recordId + '-' + this.objectName + '-' +
            this.parentFieldAPIName + '-' + this.fieldName + '-' +
            this.fieldValue + '-' + this.filterType + '-' + this.operator + '-' + this.fieldsList;
            */

        return this.recordId + '-' + this.objectName + '-' +
            this.parentFieldAPIName + '-' + this.fieldsList;

    }

    @wire(fetchRecords, { listValues: '$vals' })
    accountData({ error, data }) {

        if (data) {

            this.listRecords = data.listRecords;

            this.loopRecs = this.listRecords.map(element => ({ ...element }));
            // alert(this.loopRecs.length);

            // if (data.recordCount) {

            // if (data.recordCount > 0) {
                if (this.indexVal + 3 < this.loopRecs.length) {
                    this.showRecs = this.loopRecs.slice(0, this.indexVal + 3);
                    this.reserveRecs = this.loopRecs.slice(this.indexVal + 3);
                    this.loadMoreFlag = true;
                } else {
                    this.loadMoreFlag = false;
                    this.showRecs = this.loopRecs;
                    this.reserveRecs = this.loopRecs;
                }


                this.countBool = false;
                this.titleWithCount = this.strTitle + '(' + data.recordCount + ')';
                this.strTitle = this.strTitle + ' (' + this.loopRecs.length + ')';

            // } 
            // }

        }

    }

    loadMore() {
        this.indexVal += 3;
        this.showRecs = this.loopRecs.slice(0, this.indexVal + 3);
        alert(JSON.stringify(this.showRecs));
        this.reserveRecs = this.loopRecs.slice(this.indexVal + 3);
        if (this.indexVal + 3 > this.loopRecs.length) {
            this.loadMoreFlag = false;
        }
    }

    handleCreatedRecord(event) {
        this.createdId = event.detail;
        console.log('success from child> ' + event.detail);
        var newRec = { Id: this.createdId };
        console.log(JSON.stringify(newRec));
        
        // this.showRecs.unshift(newRec);
        this.loopRecs.unshift(newRec);
        this.strTitle = this.strTitle.substring(0, this.strTitle.indexOf('(')) + ' (' + this.loopRecs.length + ')';

    }
    handleUpdatedRecord(event){
        this.isModalOpen = event.detail;
        console.log('success from child> ' + event.modalFlag);
    }
    handleSuccess(event) {
        this.createdId = event.detail.id;
        var newRec = { Id: this.createdId };
        console.log(JSON.stringify(newRec));

        this.loopRecs.unshift(newRec);
        this.strTitle = this.strTitle.substring(0, this.strTitle.indexOf('(')) + ' (' + this.loopRecs.length + ')';
        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
        if (inputFields) {
            inputFields.forEach(field => {
                field.reset();
            });
        }
    }
    createNew() {

        alert(this.objectName);
        alert(JSON.stringify(this.objectName));
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: this.objectName,
                actionName: 'new'
            }
        });

    }

    navigateToRelatedList() {

        this[NavigationMixin.Navigate]({
            type: 'standard__recordRelationshipPage',
            attributes: {
                recordId: this.recordId,
                objectApiName: this.parentObjectName,
                relationshipApiName: this.relationshipApiName,
                actionName: 'view'
            }
        });

    }


    deleteRec(event) {
        console.log('delId > ' + event.target.name);
        this.delId = event.target.name;
        console.log('delId2 > ' + this.delId);
        deleteRecord(event.target.name)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Record deleted',
                        variant: 'success'
                    })
                );
                // Navigate to a record home page after
                // the record is deleted, such as to the
                // contact home page
                // let tempDelArray = this.listRecords.map(element => ({ ...element }));
                for (var i = 0; i < this.loopRecs.length; i++) {
                    console.log('deleted here> ' + this.loopRecs[i].Id)
                    console.log('deleted here2> ' + this.delId)
                    if (this.loopRecs[i].Id == this.delId) {

                        this.loopRecs.splice(i, 1);
                        // this.showRecs.splice(i, 1);
                        this.strTitle = this.strTitle.substring(0, this.strTitle.indexOf('(')) + ' (' + this.loopRecs.length + ')';
                    }
                }
                // this.loopRecs = tempDelArray;

            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error deleting record',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });

    }
    openModal(event) {
        // to open modal set isModalOpen tarck value as true
        this.editId = event.target.name;
        console.log('obj > ' + this.objectName + '<> id > ' + this.editId + '<> flelds > ' + this.fieldsList);
        this.isModalOpen = true;
    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
    }
    submitDetails() {
        // to close modal set isModalOpen tarck value as false
        //Add your code to call apex method or do some processing

        this.isModalOpen = false;
    }
}