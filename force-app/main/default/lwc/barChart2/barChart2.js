import { LightningElement,wire,track, api} from 'lwc';
//importing the Chart library from Static resources
import chartjs from '@salesforce/resourceUrl/ChartJs'; 
import { loadScript } from 'lightning/platformResourceLoader';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class BarChart2 extends LightningElement {
    @api chartType;
    @track isChartJsInitialized;
    chart;

    config = {
        type: 'bar',
        data: {
            labels: ["Multi-Party", "Large Txn", "Kiting", "Rounded", "Director"],
            datasets: [{
                label: 'Non Trade Transactions (%)',
                backgroundColor: ['rgb(0,250,154)','rgb(0,250,154)','rgb(0,250,154)','rgb(0,250,154)',
                'rgb(0,250,154)'],
                data: [12.7, 67.4, 0, 0, 19.9]
            }
        ]
        },
        options: {
            responsive : true,
            maintainAspectRatio: false,
        animation:{
           animateScale: true,
           animateRotate : true,
           duration: 2000
        }
        }
    };

    renderedCallback() {
        if (this.isChartJsInitialized) {
            return;
        }
        this.isChartJsInitialized = true;

        Promise.all([
            loadScript(this, chartjs)
        ]).then(() => {
            const ctx = this.template.querySelector('canvas.linechart').getContext('2d');
            this.chart = new window.Chart(ctx, this.config);
            this.chart.canvas.parentNode.style.height = '150px';
            this.chart.canvas.parentNode.style.width = '100%';
        }).catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error loading ChartJS',
                    message: error.message,
                    variant: 'error',
                }),
            );
        });
    }
}