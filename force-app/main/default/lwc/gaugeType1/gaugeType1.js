import { LightningElement,wire,track, api} from 'lwc';
//importing the Chart library from Static resources
import chartjs from '@salesforce/resourceUrl/ChartJs'; 
import { loadScript } from 'lightning/platformResourceLoader';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class GaugeType1 extends LightningElement {
    @api chartType;
    @track isChartJsInitialized;
    chart;

    config = {
        type: 'doughnut',
        data: {
            datasets: [{
                data: [8,2],
                backgroundColor :[
                    'rgb(255,69,0)'
                ],
                borderColor: ["rgba(255,99,132,1)"],
                borderWidth: 1
            }],
        
            // These labels appear in the legend and in the tooltips when hovering different arcs
            labels: [
                '# of EMI Payments Missed',
                '# of EMI Payments Made'
            ]
        },
        options: {
            responsive : true,
        legend : {
            position :'top'
        },
        maintainAspectRatio: false,
        circumference: Math.PI + 1,
        rotation: -Math.PI - 0.5,
        cutoutPercentage: 90
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