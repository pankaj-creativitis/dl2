import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class GenericLDS extends LightningElement {
    @api recordId;
    @api objectApiName;
    @api fldStr;
    @api parentField;
    @api parentId;
    @api renderType;
  
    // @api fldSet = ['FirstName', 'LastName', 'Email'];
    fldSet;
    actionLabel;
    isList = false;
    isSingle = false;
    saveUpdateTag;
  
    get loaded() {
      return this.isList || this.isSingle;
    }
  
    connectedCallback() {
      this.setFldSet();
      this.isSingle = true;
      if (this.parentId) {
        this.saveUpdateTag = "Save";
      } else {
        this.saveUpdateTag = "Update";
      }
    }
    setFldSet() {
      // this.fldStr;
      if (this.fldStr) {
        this.fldSet = this.fldStr.split(",");
      }
    }
  
    updateSuccess(event) {
      console.log("success> " + event.detail.id);
        const eventToast = new ShowToastEvent({
          title: "Success",
          message: "Record updated",
          variant: "success"
        });
        this.dispatchEvent(eventToast);
        const updateRecEvent = new CustomEvent("updatedrecord", {
          detail: false
        });
        this.dispatchEvent(updateRecEvent);
      
    }
}