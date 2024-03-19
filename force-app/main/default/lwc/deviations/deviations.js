import { LightningElement } from 'lwc';

const columns = [
    { label: 'Deviation Type', fieldName: 'deviationType', type: 'text' },
    { label: 'Description', fieldName: 'description', type: 'text' },
    { label: 'Rationale', fieldName: 'rationale', editable: 'true', type: 'text' },
    { label: 'Mandate', fieldName: 'mandate', type: 'text' },
];

export default class Deviations extends LightningElement {
    data1 = [{"deviationType":"CC","description":"Projected DSCR less than standard norms","rationale":"","mandate":"L4"},
    {"deviationType":"LC","description":"Limit as % of turnover greater by 10%","rationale":"","mandate":"L4"}
    ];

    data2 = [{"deviationType":"Collateral","description":"LTV greater by 5% on Residential - Vacant / Rented","rationale":"","mandate":"L4"},
    {"deviationType":"OD","description":"Tenure greater than standard norms","rationale":"","mandate":"L4"}
    ];

    columns = columns;
}