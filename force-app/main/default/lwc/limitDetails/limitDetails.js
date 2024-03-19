import { api, LightningElement, track } from 'lwc';
import fetchDataHelper from './fetchDataHelper';



const columns = [
    { label: 'Facility Type', fieldName: 'facilityType', type: 'text' },
    { label: 'Facility Name', fieldName: 'facilityName', type: 'text' },
    { label: 'Amount (in Lacs)', fieldName: 'amount', type: 'currency', cellAttributes: { alignment: 'left' }, typeAttributes:{ maximumFractionDigits: '4' } },
    { label: 'ROI/Commission', fieldName: 'roi', type: 'percent', cellAttributes: { alignment: 'left', typeAttributes:{ maximumFractionDigits: '4' } } },
    { label: 'Margin', fieldName: 'margin', type: 'percent', cellAttributes: { alignment: 'left' }, typeAttributes:{ maximumFractionDigits: '4' } },
    { label: 'Tenure', fieldName: 'tenure', type: 'number', cellAttributes: { alignment: 'left' } },
    { label: 'Repayment', fieldName: 'repayment', type: 'text' },
    { label: 'Purpose', fieldName: 'purpose', type: 'text' },
];

export default class LimitDetails extends LightningElement {
    @track icnName = 'utility:chevronup';
    @track showbody = true;
    @api rmView;
    @api opsView;
    isOpenModal = false;
    showCompleteData = false;

    data1 = [{"facilityType":"OD","facilityName":"Overdraft","amount":"150","roi":"0.02","margin":"0.10","tenure":"6","repayment":"Quarterly","purpose":""},
    {"facilityType":"CC","facilityName":"Cash Credit","amount":"150","roi":"0.125","margin":"0.25","tenure":"9","repayment":"","purpose":""},
    {"facilityType":"LC","facilityName":"Letter of Credit","amount":"150","roi":"0.14","margin":"0.30","tenure":"12","repayment":"Quarterly","purpose":""}
    ];

    data = [{"facilityType":"OD","facilityName":"Overdraft","amount":"150","roi":"0.02","margin":"0.10","tenure":"6","repayment":"Quarterly","purpose":""},
    {"facilityType":"CC","facilityName":"Cash Credit","amount":"150","roi":"0.125","margin":"0.25","tenure":"9","repayment":"","purpose":""}
    ];

    columns = columns;

    connectedCallback() {
        if(this.opsView || !this.rmView){
            this.data = this.data1;
        }
    }
    

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
        this.data = this.data1;
    }
   
    handleCloseModal() {
        this.isOpenModal = false;
    }
}