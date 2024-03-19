import { LightningElement,wire,track, api} from 'lwc';
//importing the Chart library from Static resources
import chartjs from '@salesforce/resourceUrl/ChartJs'; 
import { loadScript } from 'lightning/platformResourceLoader';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class GenBarChart2 extends LightningElement {
    @api chartType;
    @track isChartJsInitialized;
    chart;

    config = {
        type: 'bar',
        data: {
            labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
            datasets: [{
                label: 'Credit',
                backgroundColor: ['#2E8B57','#2E8B57','#2E8B57','#2E8B57',
                '#2E8B57','#2E8B57','#2E8B57','#2E8B57',
                '#2E8B57','#2E8B57','#2E8B57','#2E8B57'],
                data: [34, 36, 46, 23, 14, 17, 12, 42, 53, 58, 88, 81]
            },
            {label: 'Debit',
            backgroundColor: ['#FFD700','#FFD700','#FFD700','#FFD700',
            '#FFD700','#FFD700','#FFD700','#FFD700',
            '#FFD700','#FFD700','#FFD700','#FFD700'],
            data: [23, 25, 23, 45, 94, 87, 85, 95, 109, 125, 83, 74]
        }
        ]
        },
        options: {
            responsive : true,
            maintainAspectRatio: false,
        legend : {
            position :'bottom'
        },
        animation:{
           animateScale: true,
           animateRotate : true,
           duration: 2000
        },
        title: {
            display: false,
            text: 'Monthly Deep Dive (₹ Lacs)'
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
            this.chart.canvas.parentNode.style.height = '400px';
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