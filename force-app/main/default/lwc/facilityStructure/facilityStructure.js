import { api, LightningElement, track } from 'lwc';

const columns = [
    { label: 'Facility Id', fieldName: 'facilityId', type: 'text' },
    { label: 'Product', fieldName: 'product', type: 'text' },
    { label: 'Sanction Limit', fieldName: 'sanctionLimit', type: 'currency', cellAttributes: { alignment: 'left' } },
    { label: 'Loading Limit', fieldName: 'loadingLimit', type: 'currency', cellAttributes: { alignment: 'left' } },
    { label: 'Limit Expiry', fieldName: 'limitExpiry', type: 'date' },
    { label: 'Final ROI', fieldName: 'finalROI', type: 'text' },
    { label: 'Penal Interest', fieldName: 'penalInterest', type: 'text' },
];

export default class FacilityStructure extends LightningElement {
    @track icnName = 'utility:chevronup';
    @track showbody = true;
    @api rmView;
    @api opsView;
    data = [{"facilityId":"002471","product":"Group","sanctionLimit":"15000000","loadingLimit":"15000000","limitExpiry":"1/4/2021","finalROI":"-","penalInterest":"-"},
    {"facilityId":"002472","product":"Customer","sanctionLimit":"15000000","loadingLimit":"15000000","limitExpiry":"1/4/2021","finalROI":"-","penalInterest":"-"},
    {"facilityId":"002473","product":"Fund","sanctionLimit":"15000000","loadingLimit":"15000000","limitExpiry":"1/4/2021","finalROI":"12.5","penalInterest":"-"},
	{"facilityId":"002474","product":"INR","sanctionLimit":"15000000","loadingLimit":"15000000","limitExpiry":"1/4/2021","finalROI":"12.5","penalInterest":"-"},
    {"facilityId":"002475","product":"OVERDRAFT","sanctionLimit":"15000000","loadingLimit":"15000000","limitExpiry":"1/4/2021","finalROI":"12.5","penalInterest":"-"}
    ];

    data1 = [{"facilityId":"002571","product":"Group","sanctionLimit":"15000000","loadingLimit":"15000000","limitExpiry":"1/4/2021","finalROI":"-","penalInterest":"-"},
    {"facilityId":"002572","product":"Customer","sanctionLimit":"15000000","loadingLimit":"15000000","limitExpiry":"1/4/2021","finalROI":"-","penalInterest":"-"},
    {"facilityId":"002573","product":"Fund","sanctionLimit":"15000000","loadingLimit":"15000000","limitExpiry":"1/4/2021","finalROI":"12.5","penalInterest":"-"},
	{"facilityId":"002574","product":"INR","sanctionLimit":"15000000","loadingLimit":"15000000","limitExpiry":"1/4/2021","finalROI":"12.5","penalInterest":"-"},
    {"facilityId":"002575","product":"OVERDRAFT","sanctionLimit":"15000000","loadingLimit":"15000000","limitExpiry":"1/4/2021","finalROI":"12.5","penalInterest":"-"}
    ];

    data2 = [{"facilityId":"002471","product":"Group","sanctionLimit":"15000000","loadingLimit":"15000000","limitExpiry":"1/4/2021","finalROI":"-","penalInterest":"-"},
    {"facilityId":"002772","product":"Customer","sanctionLimit":"15000000","loadingLimit":"15000000","limitExpiry":"1/4/2021","finalROI":"-","penalInterest":"-"},
    {"facilityId":"002773","product":"Fund","sanctionLimit":"15000000","loadingLimit":"15000000","limitExpiry":"1/4/2021","finalROI":"12.5","penalInterest":"-"},
	{"facilityId":"002774","product":"INR","sanctionLimit":"15000000","loadingLimit":"15000000","limitExpiry":"1/4/2021","finalROI":"12.5","penalInterest":"-"},
    {"facilityId":"002775","product":"OVERDRAFT","sanctionLimit":"15000000","loadingLimit":"15000000","limitExpiry":"1/4/2021","finalROI":"12.5","penalInterest":"-"}
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