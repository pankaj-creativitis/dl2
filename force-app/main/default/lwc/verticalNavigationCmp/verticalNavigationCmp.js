import { api, LightningElement } from 'lwc';

export default class VerticalNavigationCmp extends LightningElement {
    @api selectedStage;

    renderedCallback() {
        const collection = this.template.querySelectorAll('lightning-vertical-navigation-item-icon');
        console.log(JSON.stringify(collection));
    }
}