import { LightningElement, api, track } from 'lwc';
import { FlowAttributeChangeEvent, FlowNavigationNextEvent } from 'lightning/flowSupport';

export default class OtpVerify extends LightningElement {
    
    @api otpVal = '';
    @api
    availableActions = [];

    @api resend = false;
    @api timer;
    @track timerText;
    @track timerStep;
    @api otpLength;
    @track tick;
    @track disabled = true;
    expired = false;
    optJSON;
    skipKeyUp = false;

    connectedCallback(){
      this.setOptJSON();

      var step = (this.timer/100);
      var parentThis = this;
      console.log('in it');
      var timeleft = parentThis.timer;
      var downloadTimer = setInterval(function () {
        if (timeleft <= 0) {
          console.log('finished');
          clearInterval(downloadTimer);
          parentThis.timerText = "OTP Expired.";
          parentThis.expired = true;
        } else {
          parentThis.timerStep = (timeleft/step).toFixed(0); 
          
          parentThis.timerText = timeleft + " seconds remaining";
          // console.log(parentThis.timerStep);
        }
        timeleft -= 1;
      }, 1000);
    
    }

    setOptJSON(){
      if(this.otpLength){
        var elements = new Array();
        for (var i = 0; i < this.otpLength; i++) {
          elements.push(i);
        }
        this.optJSON = elements;
      }
   
    }
    /*
    handleFocus(event){
      event.currentTarget.value = event.currentTarget.value;
    }
    */

  handleKeyDown(event) {
    console.log(event.currentTarget.value);
    const inputs = this.template.querySelectorAll('.m-2');
    let i = event.currentTarget.dataset.id;
    console.log('i >> ' + i);

    let preVal = false;
    if (event.currentTarget.value !== '') {
      preVal = true;
      console.log(event.currentTarget.value);
      console.log(preVal);
    }
    if (event.key === "Backspace") {
      console.log('Backspace territory');
      this.skipKeyUp = true;

      if (parseInt(i) !== 0 && event.currentTarget.value !== '') {

        console.log('no back');
      } else if (parseInt(i) !== 0) {
        console.log('back -1 ');
        // inputs[parseInt(i) - 1].addEventListener("focus", handleFocus, false);;
        inputs[parseInt(i) - 1].focus();
        event.preventDefault();
      } else {
        preVal = false;
        console.log('back unhandled');
      }


    }
    // enable component
    var otpLenNow = '';
    for (var j = 0; j < inputs.length; j++) {
      otpLenNow += inputs[j].value;

    }
    console.log('otpLenNow >> ' + otpLenNow);
    if (otpLenNow.length == this.otpLength) {
      this.disabled = false;
    } else {
      this.disabled = true;
    }

  }

  handleKeyUp(event) {
    const inputs = this.template.querySelectorAll('.m-2');
    if (!this.skipKeyUp) {

      let i = event.currentTarget.dataset.id;
      if (event.keyCode > 47 && event.keyCode < 58) {
        // currentElem.value = event.key;
        if (parseInt(i) !== inputs.length - 1) {
          // event.currentTarget.value = String.fromCharCode(event.keyCode);
          inputs[parseInt(i) + 1].focus();
          event.preventDefault();
          console.log('+1 forward');
        } else {
          console.log('unhandled up 1');
        }
      } else {

        console.log('unhandled up 2');
      }
      /*
    }
    */
    }
    this.skipKeyUp = false;

    // enable component
    var otpLenNow = '';
    for (var j = 0; j < inputs.length; j++) {
      otpLenNow += inputs[j].value;

    }
    console.log('otpLenNow >> ' + otpLenNow);
    if (otpLenNow.length == this.otpLength) {
      this.disabled = false;
    } else {
      this.disabled = true;
    }
  }

    handleSubmit(){
      this.otpVal = '';
      const inputs = this.template.querySelectorAll('.m-2');
      for (var i = 0; i < inputs.length; i++) {
        this.otpVal += inputs[i].value;
    }
    console.log(this.otpVal);
    }

    handleGoNext() {
      this.otpVal = '';
      const inputs = this.template.querySelectorAll('.m-2');
      for (var i = 0; i < inputs.length; i++) {
        this.otpVal += inputs[i].value;
    }
      // check if NEXT is allowed on this screen
      if (this.availableActions.find(action => action === 'NEXT')) {
          // navigate to the next screen
          const navigateNextEvent = new FlowNavigationNextEvent();
          this.dispatchEvent(navigateNextEvent);
      }
  }

  handleResend(){
    this.resend = true;
    // check if NEXT is allowed on this screen
    if (this.availableActions.find(action => action === 'NEXT')) {
      // navigate to the next screen
      const navigateNextEvent = new FlowNavigationNextEvent();
      this.dispatchEvent(navigateNextEvent);
  }
  }

}