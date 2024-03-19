import { LightningElement, track,api, wire } from 'lwc';
import getData from '@salesforce/apex/GetDateTime.getData'
export default class Timer extends LightningElement {
    @track showStartBtn = true;
    @track timeVal = '0:0:0:0';
    @track id1;
    @api recordId;
    timeIntervalInstance;
    totalMilliseconds;   
  @wire(getData,{recordId:'$recordId'})
  demo(result)
  {
            var tmdt=result.data;
            var parentThis = this;
            var today = new Date();
            var date = today.getFullYear()+'-'+(today.getMonth()+1)+'-'+today.getDate();
            var time = today.getHours() + ":" + today.getMinutes() + ":" + today.getSeconds();
            var currentTimedate = date+' '+time;
           // console.log('check time current'+dateTime);
            /*====================================================================== */
            var today1 = new Date(tmdt);
            var date1 = today1.getFullYear()+'-'+(today1.getMonth()+1)+'-'+today1.getDate();
            var time1 = today1.getHours() + ":" + today1.getMinutes() + ":" + today1.getSeconds();
            var newTimeDate = date1+' '+time1;
            /**====================================================================== */
            console.log('New Time ->'+newTimeDate+ ' Current time ->'+currentTimedate);
            if(newTimeDate>=currentTimedate){    
                var ml=new Date(newTimeDate).getTime();
                var ml1=new Date(currentTimedate).getTime();

                if (ml!=='NaN')
                {
                    var sub=ml-ml1;
                    console.log('time convert in ml '+sub);
                    var timetoCountdon=sub;
                    
                }
               
            /************************************************** */
        // var timetoCountdon='2.592e+8';
       
        // Run timer code in every 100 milliseconds
        this.timeIntervalInstance = setInterval(function() {
        // Time calculations for hours, minutes, seconds and milliseconds
        var days = Math.floor(timetoCountdon / (1000 * 60 * 60 * 24));
        var hours = Math.floor((timetoCountdon % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
        var minutes = Math.floor((timetoCountdon % (1000 * 60 * 60)) / (1000 * 60));
        var seconds = Math.floor((timetoCountdon % (1000 * 60)) / 1000);
        // Output the result in the timeVal variable
        parentThis.timeVal = days + ":" +hours + ":" + minutes + ":" + seconds;   
        timetoCountdon -= 100;
        }, 100);
    }
  }
}