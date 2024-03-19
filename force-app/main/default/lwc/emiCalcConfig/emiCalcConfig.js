import { api, LightningElement, track } from 'lwc';

export default class EmiCalcConfig extends LightningElement {
    @api eligibleLoanAmt;
    loanAmt;
    formattedLoanAmt;
    maxLoanAmount;
    maxTenure;
    @api tenure = 15;
    @api annualROI = 11;
    roiFraction;
    @api thumbColor;
    @api lineColor;

    emiValue;

    connectedCallback(){
        this.loanAmt = this.eligibleLoanAmt;
        this.maxLoanAmount = this.eligibleLoanAmt + 1000000;
        this.maxTenure = this.tenure;
        this.roiFraction = Number(this.annualROI);
        this.calculateEMI();
    }

    renderedCallback() {

        this.formattedLoanAmt = this.loanAmt.toLocaleString('en-IN');

        // const btn = this.template.querySelector('.button');
        // btn.style.setProperty('--thColor', this.thumbColor);

        const amtSlider = this.template.querySelector('.slider-Amt-width');
        var highlightValueA = (this.loanAmt-amtSlider.min)/(amtSlider.max-amtSlider.min)*100;
        amtSlider.style.background = 'linear-gradient(to right, ' + this.lineColor + ' 0%, ' + this.lineColor + ' ' + highlightValueA + '%, #D3D3D3 ' + highlightValueA + '%, #D3D3D3 100%)';
        amtSlider.style.setProperty('--lnColor', this.lineColor);
        amtSlider.style.setProperty('--thColor', this.thumbColor);

        const tenureSlider = this.template.querySelector('.slider-Tenure-width');
        var highlightValueT = (this.tenure-tenureSlider.min)/(tenureSlider.max-tenureSlider.min)*100;
        tenureSlider.style.background = 'linear-gradient(to right, ' + this.lineColor + ' 0%, ' + this.lineColor + ' ' + highlightValueT + '%, #D3D3D3 ' + highlightValueT + '%, #D3D3D3 100%)';
        tenureSlider.style.setProperty('--lnColor', this.lineColor);
        tenureSlider.style.setProperty('--thColor', this.thumbColor);
    }

    setAmount(event){
        // console.log(event.target.value);
        this.loanAmt =  parseInt(event.target.value);

        const amtSlider = this.template.querySelector('.slider-Amt-width');
        var highlightValue = (this.loanAmt-amtSlider.min)/(amtSlider.max-amtSlider.min)*100;
        amtSlider.style.background = 'linear-gradient(to right, ' + this.lineColor + ' 0%, ' + this.lineColor + ' ' + highlightValue + '%, #D3D3D3 ' + highlightValue + '%, #D3D3D3 100%)';
        this.calculateEMI();
        this.formattedLoanAmt =  this.loanAmt.toLocaleString('en-IN');
        console.log(this.formattedLoanAmt);
        // console.log(event.currentTarget.value);
    }

    setTenure(event){
        // console.log(event.target.value);
        this.tenure = event.target.value;
        const tenureSlider = this.template.querySelector('.slider-Tenure-width');
        var highlightValue = (this.tenure-tenureSlider.min)/(tenureSlider.max-tenureSlider.min)*100;
        tenureSlider.style.background = 'linear-gradient(to right, ' + this.lineColor + ' 0%, ' + this.lineColor + ' ' + highlightValue + '%, #D3D3D3 ' + highlightValue + '%, #D3D3D3 100%)';
        this.calculateEMI();
    }

    handleAmtChange(event) {
        console.log(event.target.value);
        this.loanAmt =  event.target.value;
        this.calculateEMI();
    }

    handleTenureChange(event) {
        console.log(event.target.value);
        this.tenure = event.target.value;
        this.calculateEMI();
    }

    calculateEMI(event) {
        console.log('in EMI calc');

        let interest = this.roiFraction / 1200;
        let term = this.tenure * 12;
        let top = Math.pow((1 + interest), term);
        let bottom = top - 1;
        let ratio = top / bottom;
        this.emiValue = Math.round(this.loanAmt * interest * ratio).toLocaleString('en-IN');
        
    }
}