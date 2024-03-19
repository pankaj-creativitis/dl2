import { LightningElement, track } from 'lwc';


let columns = [
    { label: 'Customer', fieldName: 'Customer', type: 'text' },
    { label: 'Address', fieldName: 'Address', type: 'text' },
    { label: 'Application_Code', fieldName: 'Application_Code', type: 'text' },
    { label: 'Started', fieldName: 'Started', type: 'text' },
    { label: 'Status', fieldName: 'Status', type: 'text' },
    { label: 'Action', fieldName: 'Blockages', type: 'button',  typeAttributes: {
            label: 'View Blockages',
            name: 'VB',
            title: 'View Blockages',
            disabled: false,
            value: 'viewBlock',
            iconPosition: 'left'
        }
    },
    { label: 'Requested', fieldName: 'Requested', type: 'text' },
    { label: 'Action', fieldName: 'Action', type: 'text' },
];


let data = [
    {   
        id: 'a002',
        Customer: 'John Michael',
        Address: 'GA 38 Georgia, USA',
        Application_Code: 'fas4235gsfdgs5634hsdgsd',
        Started: 'Feb 16, 2023',
        Status: 'Offers Present\nOffers Calculated',
        Blockages: 'View Blockages',
        Requested: '$10000000',
        Action: 'No Action',
    },

    {   
        id: 'a001',
        Customer: 'Shawn Michael',
        Address: 'GA 38 Atlanta, USA',
        Application_Code: 'qtaetsfdgs5634hsdfd',
        Started: 'Feb 19, 2023',
        Status: 'Offers Present\nOffers Calculated',
        Blockages: 'No Blockages',
        Requested: '$8000000',
        Action: 'No Action',
    },


    {   
        id: 'a003',
        Customer: 'Tod Lincon',
        Address: 'GA 38 Georgia, USA',
        Application_Code: 'hsdshsfdgs5634hsdgsd',
        Started: 'Feb 18, 2023',
        Status: 'Offers Present\nOffers Calculated',
        Blockages: 'No Blockages',
        Requested: '$9000000',
        Action: 'No Action',
    },

    {   
        id: 'a004',
        Customer: 'Mark Rufallo',
        Address: 'New Town 21, USA',
        Application_Code: 'gafasfdgs5634hsdgsfd',
        Started: 'Feb 18, 2023',
        Status: 'Offers Present\nOffers Calculated',
        Blockages: 'No Blockages',
        Requested: '$7000000',
        Action: 'No Action',
    },
];




// ########################################### CASE DATA ##############################################

let CaseColumns = [
    { label: 'Case_No', fieldName: 'Case_No', type: 'text' },
    { label: 'Description', fieldName: 'Description', type: 'text' },
    { label: 'Status', fieldName: 'Status', type: 'text' },
    { label: 'Assigned_To', fieldName: 'Assigned_To', type: 'text' },
    
];


let caseData = [
    {   
        id: 'a001',
        Case_No: 'CASE 001',
        Description: 'Home Address incorrect',
        Status: 'Pending',
        Assigned_To: 'Mrs. Shaloni Shah',
    },

    {   
        id: 'a002',
        Case_No: 'CASE 002',
        Description: 'SSN Invalid',
        Status: 'Rejected',
        Assigned_To: 'Mr. Akash Mehta',
    },

    {   
        id: 'a003',
        Case_No: 'CASE 003',
        Description: 'Mobile No. Invalid',
        Status: 'Approved',
        Assigned_To: 'Mr. William James',
    },

    {   
        id: 'a004',
        Case_No: 'CASE 004',
        Description: 'Document Incorrect',
        Status: 'Approved',
        Assigned_To: 'Mr. Chris Matt',
    },

    {   
        id: 'a005',
        Case_No: 'CASE 005',
        Description: 'Bank Statement Needed',
        Status: 'Rejected',
        Assigned_To: 'Mrs. Amily Watson',
    },

    {   
        id: 'a006',
        Case_No: 'CASE 006',
        Description: 'Invalid Address',
        Status: 'Pending',
        Assigned_To: 'Mrs. Scarlett Jones',
    },

    {   
        id: 'a007',
        Case_No: 'CASE 007',
        Description: 'Email Not Valid',
        Status: 'Approved',
        Assigned_To: 'Mrs. Nina Willam',
    },

    
];



export default class NewHomeImprovementApplication extends LightningElement {

    showModal1 = false;

    closeModal1(){
        this.showModal1 = false;
    }

    openModal1(){
        this.showModal1 = true;

    }






    @track showModal = false;
    @track showCases = false;

    @track data = data;
    @track columns = columns;
    @track newCaseData;
    @track randomCasesData = [];

    openApplicationDashboard() {
        this.showModal = true;
        
    }


    getSelectedName(event) {
        // const selectedRows = event.detail.selectedRows;
        // console.log('selectedRows ==> ', selectedRows);
        // Display that fieldName of the selected rows
        // for (let i = 0; i < selectedRows.length; i++) {
        //     alert('You selected: ' + selectedRows[i].Customer);
        // }
    }

    

    openModal(event) {
        // console.log('event ==> ', event);
        // const selectedRows = event.detail.selectedRows;
        // console.log('selectedRows Case ==> ', selectedRows);

        this.showCases = true;

        this.data = this.loopCases();
        this.columns = CaseColumns;
    }
    closeModal() {
        this.showCases = false;
        this.showModal = true;

        this.data = data;
        this.columns = columns;
    }

    closeAll() {
        this.showCases = false;
        this.showModal = false;
    }

    closeCases() {
        this.showCases = false;
        this.data = data;
        this.columns = columns;
    }



    


    // Generating random to static cases for buttons ???

    getRandomArbitrary(min, max) {
        let num = Math.random() * (max - min) + min;
        num = Number(num.toFixed(0));
        return num;
    }

    loopCases(){
        this.randomCasesData = [];
        let randomNumber = this.getRandomArbitrary(1,7);
        for(let i = 0; i <= randomNumber; i++) {
            this.randomCasesData.push(caseData[i]);
        }
        return this.randomCasesData;
    }
}