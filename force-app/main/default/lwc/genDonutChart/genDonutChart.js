import { LightningElement,wire,track, api} from 'lwc';
//importing the Chart library from Static resources
import chartjs from '@salesforce/resourceUrl/ChartJs'; 
import { loadScript } from 'lightning/platformResourceLoader';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class GenDonutChart extends LightningElement {

    @api chartType;
    @track isChartJsInitialized;
    chart;

    config = {
        type: 'doughnut',
        data: {
            datasets: [{
                data: [42, 58],
                backgroundColor :[
                    'rgb(0,191,255)',
                    'rgb(0,250,154)',
                    'rgb(255,205,86)',
                    'rgb(75,192,192)',
                ]
            }],
        
            // These labels appear in the legend and in the tooltips when hovering different arcs
            labels: [
                'Trade Transactions',
                'Non Trade Transactions'
            ]
        },
        options: {
            responsive : true,
        legend : {
            position :'bottom'
        },
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
            this.chart.canvas.parentNode.style.height = '100%';
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