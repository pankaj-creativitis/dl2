// apexWireMethodWithParams.js
import { LightningElement, wire, api, track } from "lwc";
import getLimits from "@salesforce/apex/LimitsController.getLimits";

// row actions
const actions = [
  { label: "Add Sub-limit", name: "sublimit" },
  { label: "Edit", name: "edit" },
  { label: "Delete", name: "delete" }
];

const columns = [
  { label: "Facility Type", fieldName: "Type__c", type: "text" },
  { label: "Facility Name", fieldName: "Name", type: "text" },
  {
    label: "Amount (in Lacs)",
    fieldName: "Amount_Lacs__c",
    type: "currency",
    cellAttributes: { alignment: "left" },
    typeAttributes: { maximumFractionDigits: "4" }
  },
  {
    label: "ROI/Commission (%)",
    fieldName: "ROI_Commission__c",
    type: "Decimal Column",
    cellAttributes: {
      alignment: "left"
    },
    typeAttributes: { maximumFractionDigits: "4" }
  },
  {
    label: "Margin (%)",
    fieldName: "Margin__c",
    type: "Decimal Column",
    cellAttributes: { alignment: "left" },
    typeAttributes: { maximumFractionDigits: "2" }
  },
  {
    label: "Tenure",
    fieldName: "Tenure_Months__c",
    type: "number",
    cellAttributes: { alignment: "left" }
  },
  { label: "Repayment", fieldName: "Repayment__c", type: "text" },
  { label: "Purpose", fieldName: "Purpose__c", type: "text" },
  {
    type: "button-icon",
    fixedWidth: 20,
    typeAttributes: {
      iconName: "utility:level_down",
      name: "add_sublimit",
      title: "Add Sub-limit",
      onclick: "handleOpenModal",
      variant: "bare",
      alternativeText: "add sub-limit",
      disabled: false
    },
    cellAttributes: {
      style: "transform: scale(0.5)"
    }
  },
  {
    type: "button-icon",
    fixedWidth: 20,
    typeAttributes: {
      iconName: "utility:edit",
      name: "edit_record",
      title: "Edit",
      variant: "bare",
      alternativeText: "edit",
      disabled: false
    },
    cellAttributes: {
      style: "transform: scale(0.5)"
    }
  },
  {
    type: "button-icon",
    fixedWidth: 20,
    typeAttributes: {
      iconName: "utility:delete",
      name: "delete_record",
      title: "Delete",
      variant: "bare",
      alternativeText: "delete",
      disabled: false
    },
    cellAttributes: {
      style: "transform: scale(0.5)"
    }
  }
];

export default class LimitTree extends LightningElement {
  @track icnName = "utility:chevronup";
  @api recordId;
  @wire(getLimits, { oppId: "$recordId" })
  limits;
  isOpenModal = false;
  opportunityId;
  parentLimitId;
  @track showbody = true;
  @api rmView;
  @api opsView;
  columns = columns;
  data;

  connectedCallback() {
    try {
      if (this.limits) {
        let parsedValue = [...this.limits.data];
        let newData = [];
        // let parsedValue = parsedData.data;

        // parsedValue = Object.assign([], parsedValue);

        parsedValue.forEach(function (item, i) {
          if (i == 0) {
            item = Object.assign({}, item, { Limit__c: null });
          } else {
            item = Object.assign({}, item);
          }

          newData.push(item);
        });

        console.log("edited > " + JSON.stringify(newData));

        const nest = (items, Id = null, link = "Limit__c") =>
          items
            .filter((item) => item[link] === Id)
            .map((item) => ({ ...item, _children: nest(items, item.Id) }));

        // console.log(nest(newData));
        this.data = nest(newData);
      }
    } catch (err) {
      console.log("error > " + err.message);
    }
  }

  bodyMgmt(event) {
    console.log("fn called");
    const label = event.target.iconName;
    console.log(label);
    if (label == "utility:chevronup") {
      this.icnName = "utility:chevrondown";
      this.showbody = false;
    } else if (label == "utility:chevrondown") {
      this.handleClick();
      this.icnName = "utility:chevronup";
      this.showbody = true;
    }
  }

  handleRowActions(event) {
    let actionName = event.detail.action.name;

    window.console.log("actionName ====> " + actionName);

    let row = event.detail.row;

    window.console.log("row ====> " + JSON.stringify(row));
    // eslint-disable-next-line default-case
    switch (actionName) {
      case "add_sublimit":
        this.opportunityId = row.Parent_Application__c;
        this.parentLimitId = row.Id;
        this.handleOpenModal();
        break;
      case "edit_record":
        this.editCurrentRecord(row);
        break;
      case "delete_record":
        this.deleteCons(row);
        break;
    }
  }

  handleOpenModal() {
    this.isOpenModal = true;
  }

  handleOpenModalNewLimit() {
    this.opportunityId = this.recordId;
    this.parentLimitId = null;
    this.isOpenModal = true;
  }

  handleCloseModal() {
    this.isOpenModal = false;
  }

  handleClick() {
    try {
      let parsedValue = [...this.limits.data];
      let newData = [];
      // let parsedValue = parsedData.data;

      // parsedValue = Object.assign([], parsedValue);

      parsedValue.forEach(function (item, i) {
        if (!("Limit__c" in item)) {
          console.log("has");
          item = Object.assign({}, item, { Limit__c: null });
        } else {
          item = Object.assign({}, item);
        }

        /*
        if (i == 0) {
          item = Object.assign({}, item, { Limit__c: null });
        } else {
          item = Object.assign({}, item);
        }
        */
        newData.push(item);
      });

      console.log("edited > " + JSON.stringify(newData));

      const nest = (items, Id = null, link = "Limit__c") =>
        items
          .filter((item) => item[link] === Id)
          .map((item) => ({ ...item, _children: nest(items, item.Id) }));

      // console.log(nest(newData));

      this.data = nest(newData);
      console.log(this.data);
      eval("$A.get('e.force:refreshView').fire();");
    } catch (err) {
      console.log("error > " + err.message);
    }
  }
}