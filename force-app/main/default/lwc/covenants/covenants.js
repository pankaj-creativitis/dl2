import { api, LightningElement, track } from 'lwc';

const columns = [
    { label: 'Covenant Id', fieldName: 'covenantId', type: 'text' },
    { label: 'Covenant Type', fieldName: 'covenantType', type: 'text' },
    { label: 'Covenant Subtype', fieldName: 'covenantSubtype',type: 'text' },
    { label: 'Frequency', fieldName: 'frequency', type: 'text'},
    { label: 'Creation Date', fieldName: 'creationDate', type: 'text' },
    { label: 'Status', fieldName: 'status', type: 'text' },
];

export default class Covenants extends LightningElement {
    @track icnName = 'utility:chevronup';
    @track showbody = true;

    data = [{"covenantId":"COV-00233","covenantType":"Regulatory Covenants","covenantSubtype":"UFCE declaration","frequency":"Quarterly","creationDate":"30/12/20","status":"Active"},
    {"covenantId":"COV-00234","covenantType":"Security","covenantSubtype":"CHG1","frequency":"One-time","creationDate":"30/12/20","status":"Active"}
    ];

    columns = columns;
    

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