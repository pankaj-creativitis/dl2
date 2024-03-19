import { api, LightningElement, track } from 'lwc';

const columns = [
    { label: 'Facility Type', fieldName: 'facilityType', type: 'text' },
    { label: 'Facility Name', fieldName: 'facilityName', type: 'text' },
    { label: 'Amount (in Lacs)', fieldName: 'amount', type: 'currency', cellAttributes: { alignment: 'left' } },
    { label: 'Existing ROI', fieldName: 'roi', type: 'percent', editable: 'true', cellAttributes: { alignment: 'left' }, typeAttributes:{ maximumFractionDigits: '4' } },
    { label: 'Existing PF', fieldName: 'existingPf', type: 'percent', editable: 'true', cellAttributes: { alignment: 'left' }, typeAttributes:{ maximumFractionDigits: '4' } },
    { label: 'Applied Repo Rate', fieldName: 'appliedRepo', type: 'percent', cellAttributes: { alignment: 'left' }, typeAttributes:{ maximumFractionDigits: '4' } },
    { label: 'Applied Spread Commission', fieldName: 'appliedSpread', type: 'percent', cellAttributes: { alignment: 'left' }, typeAttributes:{ maximumFractionDigits: '4' } },
    { label: 'Applied ROI Commission', fieldName: 'appliedRoi', type: 'percent', cellAttributes: { alignment: 'left' }, typeAttributes:{ maximumFractionDigits: '4' } },
    { label: 'Latest Repo Rate', fieldName: 'latestRepo', type: 'percent', cellAttributes: { alignment: 'left' }, typeAttributes:{ maximumFractionDigits: '4' } },
    { label: 'Requested Spread Commission', fieldName: 'requestedSpread', editable: 'true', type: 'percent', cellAttributes: { alignment: 'left' }, typeAttributes:{ maximumFractionDigits: '4' } },
    { label: 'Requested ROI Commission', fieldName: 'requestedRoi', editable: 'true', type: 'percent', cellAttributes: { alignment: 'left' }, typeAttributes:{ maximumFractionDigits: '4' } },
];

export default class PricingApproval extends LightningElement {
    @track icnName = 'utility:chevronup';
    @track showbody = true;

    data = [{"facilityType":"OD","facilityName":"Overdraft","amount":"150","roi":"0.11","existingPf":"0.11","appliedRepo":"0.0735","appliedSpread":"0.0525","appliedRoi":"","latestRepo":"0.0735","requestedSpread":"0.11","requestedRoi":"0.1835"},
    {"facilityType":"CC","facilityName":"Cash Credit","amount":"150","roi":"0.11","existingPf":"0.11","appliedRepo":"0.0735","appliedSpread":"0.02","appliedRoi":"","latestRepo":"0.0735","requestedSpread":"0.11","requestedRoi":"0.11"},
    {"facilityType":"LC","facilityName":"Letter of Credit","amount":"150","roi":"0.10","existingPf":"0.10","appliedRepo":"0.07","appliedSpread":"0.042","appliedRoi":"","latestRepo":"0.07","requestedSpread":"0.11","requestedRoi":"0.11"},
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

}