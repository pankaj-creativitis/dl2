import { LightningElement} from 'lwc';
import biogasImg from '@salesforce/resourceUrl/ruralBiogas';
import cleanEnergyImg from '@salesforce/resourceUrl/cleanEnergy';
import carbonReadyImg from '@salesforce/resourceUrl/carbonReadiness';
import esgValueImg from '@salesforce/resourceUrl/esgValue';
import esgRoiImg from '@salesforce/resourceUrl/esgRoi';
import { FlowNavigationNextEvent } from 'lightning/flowSupport';

export default class CarausalTestimonials extends LightningElement {
    carbonReadyIcon = carbonReadyImg;
    biogasIcon = biogasImg;
    cleanEnergyIcon = cleanEnergyImg;

    esgValueIcon = esgValueImg;
    esgRoiIcon = esgRoiImg;

    handleNext() {
        // check if NEXT is allowed on this screen
        if (this.availableActions.find(action => action === 'NEXT')) {
            // navigate to the next screen
            const navigateNextEvent = new FlowNavigationNextEvent();
            this.dispatchEvent(navigateNextEvent);
        }
}
 
}