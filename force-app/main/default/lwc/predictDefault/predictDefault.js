import { LightningElement } from 'lwc';

const columns = [
    { label: 'Factor', fieldName: 'decidingFactor' },
    { label: 'Impact', fieldName: 'value', type: 'percentage' },
];

export default class PredictDefault extends LightningElement {
    fetch = false;
    showSpinner = false;

    data = [];
    columns = columns;

    connectedCallback() {
        const data = [{decidingFactor: 'Finance accounts - Checking balance on account', value : '-11.82%'},
        {decidingFactor: 'Credit duration', value : '3.80%'},
        {decidingFactor: 'Employment duration', value : '3.30%'},
        {decidingFactor: 'Credit purpose - Used car', value : '-2.00%'},
        {decidingFactor: 'Finance accounts - Savings balance on account', value : '1.23%'},
        {decidingFactor: 'Credit amount', value : '1.22%'},
        {decidingFactor: 'Finance credits - Other banks', value : '-1.14%'},
        {decidingFactor: 'Finance repayment history - very poor', value : '1.09%'},
        {decidingFactor: 'Finance accounts - Checking balance negative', value : '-0.91%'},
        {decidingFactor: 'Finance accounts - Savings accounts low', value : '0.71%'},
        {decidingFactor: 'Other features', value : '1.02%'},
    ];
        this.data = data;
    }

    handleClick() {
        this.fetch = true;
        this.showSpinner = true;
        // eslint-disable-next-line @lwc/lwc/no-async-operation
        setTimeout(()=>{this.showSpinner = false;},3000);
        
    }
}