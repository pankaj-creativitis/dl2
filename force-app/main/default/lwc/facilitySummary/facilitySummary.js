import { api, LightningElement, track } from 'lwc';

const columns = [
    { label: 'Product', fieldName: 'product', type: 'text' },
    { label: 'Product Name', fieldName: 'productName', type: 'text' },
    { label: 'Loaded Limit', fieldName: 'loadedLimit', type: 'currency', cellAttributes: { alignment: 'left' } },
    { label: 'Status', fieldName: 'status', type: 'text' },
];

export default class FacilitySummary extends LightningElement {
    @track icnName = 'utility:chevronup';
    @track showbody = true;
    @api rmView;
    @api opsView;
    isOpenModal = false;
    data = [{"product":"OD","productName":"Overdraft","loadedLimit":"15000000","status":"Success"},
    {"product":"CC","productName":"Cash Credit","loadedLimit":"15000000","status":"Success"},
    {"product":"LC","productName":"Letter of Credit","loadedLimit":"15000000","status":"Success"}
    ];
    columns = columns;

    // eslint-disable-next-line @lwc/lwc/no-async-await
    /*
    async connectedCallback() {
        const data = await fetchDataHelper({ amountOfRecords: 10 });
        this.data = data;
        console.log(JSON.stringify(data));
    }
    */

    bodyMgmt(event){
        console.log('fn called');
        const label = event.target.iconName;  
        console.log(label);
        if ( label == 'utility:chevronup' ) {  
  
            this.icnName = 'utility:chevrondown';  
            this.showbody = false;  
  
        } else if  ( label == 'utility:chevrondown' ) {  
              
            this.icnName = 'utility:chevronup';  
            this.showbody = true;  
  
        }  
    }

    handleOpenModal() {
        this.isOpenModal = true;
    }
   
    handleCloseModal() {
        this.isOpenModal = false;
    }
}