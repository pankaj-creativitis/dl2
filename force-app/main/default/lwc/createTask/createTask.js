import { LightningElement, api } from "lwc";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CreateTask extends LightningElement {
  @api
  parentId;

  @api
  prtcId;

  handleSuccess(event) {
    const newRecEvent = new CustomEvent("createdrecord", {
        detail: event.detail.id
      });
      this.dispatchEvent(newRecEvent);
      const eventToast = new ShowToastEvent({
        title: "Success",
        message: "Record Created",
        variant: "success"
      });
      this.dispatchEvent(eventToast);
  }
}