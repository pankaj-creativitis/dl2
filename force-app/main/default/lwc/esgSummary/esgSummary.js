import { LightningElement } from 'lwc';

export default class EsgSummary extends LightningElement {

    eColor = 'background-color:#90C8AC;';
    eHeaderColor = 'background-color:#73A9AD; color:white;  width: 60%';

    sColor = 'background-color:#79DAE8;';
    sHeaderColor = 'background-color:#0AA1DD; color:white;  width: 60%';

    gColor = 'background-color:#F6AE99;';
    gHeaderColor = 'background-color:#B97A95; color:white;  width: 60%';

    value = 'inProgress';

    get options() {
        return [
            { label: 'Reviewed', value: 'reviewed' },
            { label: 'In Progress', value: 'inProgress' },
            { label: 'Policy not available', value: 'na' },
        ];
    }

    handleChange(event) {
        this.value = event.detail.value;
    }

}