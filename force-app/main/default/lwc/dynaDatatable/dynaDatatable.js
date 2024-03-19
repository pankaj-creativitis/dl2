import { LightningElement, wire, api, track } from "lwc";
import getClmns from "@salesforce/apex/QuestionnaireController.getColumns";
import getRecs from "@salesforce/apex/QuestionnaireController.getData";
import updateResponses from "@salesforce/apex/QuestionnaireController.updateResponses";
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import fetchDataHelper from "./fetchDataHelper";

/*
const columns = [
  { label: "Label", fieldName: "name", editable: true },
  { label: "Website", fieldName: "website", type: "url", editable: true },
  { label: "Phone", fieldName: "phone", type: "phone", editable: true },
  { label: "CloseAt", fieldName: "closeAt", type: "date", editable: true },
  { label: "Balance", fieldName: "amount", type: "currency", editable: true }
];

const columns = [
  {fieldName:"Row_Text",label:"Row_Text",type:"text"},
{fieldName:"Estimate_1920",label:"Estimate_1920",type:"currency"},
{fieldName:"Estimated_Actual_1920",label:"Estimated_Actual_1920",type:"currency"},
{fieldName:"Variance",label:"Variance",type:"percent"}
];

const columns = [
  {fieldName:"Row_Text__c",label:"Row Text"}
];
*/

export default class DynaDatatable extends LightningElement {
  formattedClStr;
  // @wire(getClmns, { catId: "", columns: "c1,c2,c3", arrayList: "" }) sfColumns;
  // columns = columns;
 columns = [];
  rowOffset = 0;
  records = [];
  draftValues = [];
  wiredRecords;
  @api inputColumns;

  // eslint-disable-next-line @lwc/lwc/no-async-await
  
    async connectedCallback() {
      
      this.columns = await getClmns({ catId: "", columns: this.inputColumns, arrayList: "" });
      console.log(JSON.stringify(this.columns));
      // this.formattedClStr = JSON.parse(this.columns);
      
      // console.log(JSON.stringify(this.formattedClStr));
      
      if(this.columns && this.columns.length){
        this.records = await getRecs({ catId: "", columns: this.inputColumns, arrayList: "" });
        this.wiredRecords = this.records; 
        console.log('wired recs >> ' + JSON.stringify(this.wiredRecords));
      }
      
        // this.data = await fetchDataHelper({ amountOfRecords: 100 });
        // console.log(JSON.stringify(this.data));
    }

    async handleSave( event ) {

      const updatedFields = event.detail.draftValues;
      console.log('updatedFields >> ' + JSON.stringify(updatedFields));

      await updateResponses( { data: updatedFields } )
      .then( result => {
          console.log( JSON.stringify( "Apex update result: " + result ) );
          this.dispatchEvent(
              new ShowToastEvent({
                  title: 'Success',
                  message: 'Account(s) updated',
                  variant: 'success'
              })
          );
          refreshApex(this.wiredRecords);     
      }).catch( error => {
          console.log( 'Error is ' + JSON.stringify( error ) );
          this.dispatchEvent(
              new ShowToastEvent({
                  title: 'Error updating or refreshing records',
                  message: error.body.message,
                  variant: 'error'
              })
          );
      });
  }
    
}