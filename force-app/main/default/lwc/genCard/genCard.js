import { LightningElement, api, track } from "lwc";

export default class GenCard extends LightningElement {
  @api header;
  hasActionButton;
  hasActionIcon;
  @api iconName;
  @api hasBody;
  @api description;
  @api footerDescription;
  @api content1Class;
  @api content1;
  @api content2;
  @api content2Class;
  @api content3;
  @api content3Class;
  @api gaugeType;
  @api footerContent;
  @api footerContentClass;
  // gauge1;
  // gauge2;
  hasBodyChart;
  hasFooter;
  hasFooterChart;
  @api
  get gauge1() {
    if (this.gaugeType == "1") return true;
    return false;
  }
  @api
  get gauge2() {
    if (this.gaugeType == "2") return true;
    return false;
  }
  @api
  get content1ClassVal() {
    if (this.content1Class == "g") {
      return "good";
    } else if (this.content1Class == "b") {
      return "bad";
    }
  }
  @api
  get content2ClassVal() {
    if (this.content2Class == "g") {
      return "good";
    } else if (this.content2Class == "b") {
      return "bad";
    }
  }
  @api
  get content3ClassVal() {
    if (this.content3Class == "g") {
      return "good";
    } else if (this.content3Class == "b") {
      return "bad";
    }
  }
  @api
  get footerClassVal() {
    if (this.footerContentClass == "g") {
      return "good";
    } else if (this.footerContentClass == "b") {
      return "bad";
    }
  }
}