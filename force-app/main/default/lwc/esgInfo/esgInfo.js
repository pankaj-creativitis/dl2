import { LightningElement, api, track } from 'lwc';
//importing the Chart library from Static resources
import chartjs from '@salesforce/resourceUrl/ChartJs'; 
import { loadScript } from 'lightning/platformResourceLoader';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class EsgInfo extends LightningElement {
    @api chartType;
    @track isChartJsInitialized;
    chart;

    // labels: ["May", "Jun", "Jul"],

    config = {
  type: 'bar',
  data: {
    labels: ["May", "Jun", "Jul"],
    datasets: [{
      label: 'Carbon Emmissions (tonnes/£m)',
      data: [13, 13, 15],
      backgroundColor: [
        'rgba(255, 159, 64, 0.2)',
        'rgba(255, 205, 86, 0.2)',
        'rgba(255, 99, 132, 0.2)'
      ],
      borderColor: [
        'rgb(255, 159, 64)',
        'rgb(255, 205, 86)',
        'rgb(255, 99, 132)'
      ],
      borderWidth: 1
    }]
  },
  options: {
    scales: {
        yAxes: [{
            display: true,
            ticks: {
                beginAtZero: true
            }
        }]
    }
  },
};

    renderedCallback() {
        if (this.isChartJsInitialized) {
            return;
        }
        this.isChartJsInitialized = true;

        Promise.all([
            loadScript(this, chartjs)
        ]).then(() => {
            const ctx = this.template.querySelector('canvas.barchart').getContext('2d');
            this.chart = new window.Chart(ctx, this.config);
            this.chart.canvas.parentNode.style.height = 'auto';
            this.chart.canvas.parentNode.style.width = 'auto';
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