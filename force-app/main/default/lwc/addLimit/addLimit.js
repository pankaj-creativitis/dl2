import { LightningElement, api, track, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class AddLimit extends LightningElement {
  @api objectName;
  @api fieldString;
  @api oppId;
  @api parentId;
  showHeader = false;
  fldSet;

  limitName;
  roi;

  connectedCallback() {
    this.setFldSet();
  }
  setFldSet() {
    // this.fldStr;
    if (this.fieldString) {
      this.fldSet = this.fieldString.split(",");
    }
  }

  handleFtChange(event) {
    console.log("You selected value: " + event.detail.value);
    const expr = event.detail.value;
    switch (expr) {
      case "CC":
        this.limitName = "Cash Credit";
        this.roi = "15.00";
        break;
      case "LC":
        this.limitName = "Letter of Credit";
        this.roi = "14.00";
        break;
      case "OD":
        this.limitName = "Overdraft";
        this.roi = "13.00";
        break;
      case "BG":
        this.limitName = "Bank Guarantee";
        this.roi = "20.00";
        break;
      default:
        console.log(`Sorry, we are out of ${expr}.`);
    }
  }

  handleSuccess(event) {
    console.log("success> " + event.detail.id);

    const eventToast = new ShowToastEvent({
      title: "Success",
      message: "Limit Added",
      variant: "success"
    });
    this.dispatchEvent(eventToast);
    const updateRecEvent = new CustomEvent("updatedrecord", {
      detail: false
    });
    this.dispatchEvent(updateRecEvent);
  }
}