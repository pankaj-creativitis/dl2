import { LightningElement, track } from 'lwc';

export default class LimitAssessmentCM extends LightningElement {
    @track icnName = 'utility:chevrondown';
    @track showbody = false;

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