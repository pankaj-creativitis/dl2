import { LightningElement, api, track } from "lwc";

export default class GenCardEditable extends LightningElement {
  @api header;
  hasActionButton;
  hasActionIcon;
  @api iconName;
  @api cardType;

  @api
  get itr() {
    if (this.cardType == "itr") return true;
    return false;
  }
  @api
  get gst() {
    if (this.cardType == "gst") return true;
    return false;
  }
}