({
	afterChartLibLoaded : function(component, event, helper) {

        var labelsToShow = [];
        var probabilities = [];
        var dynamicColors = [];
        
        var action = component.get("c.fetchIntentDetails");
        action.setParams({
            "recId":component.get("v.recordId")   
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var responseWrapper = response.getReturnValue();
                component.set("v.sentiment_intent_Response", responseWrapper);                
                component.set("v.probability_percentage", responseWrapper[0].probability.toFixed(2) * 100 + '%');
                component.set("v.sentiment_intent_Response_label", responseWrapper[0].label);                   
                var i;
                for(i = 0; i<responseWrapper.length; i++){                    	
                    labelsToShow.push(responseWrapper[i].label);
                    probabilities.push(responseWrapper[i].probability.toFixed(2));
                    dynamicColors.push(helper.dynamicColors());
                }
                
                var data = {
				    datasets: [{
				    	fill: true,
				    	backgroundColor: dynamicColors,
				        data: probabilities
				    }],
				
				    // These labels appear in the legend and in the tooltips when hovering different arcs
				    labels: labelsToShow
				};

                var ctx = document.getElementById('myChart');				
			
				var myPieChart = new Chart(ctx, {
				    type	: 'doughnut',
				    data	: data
				});
            }
                        
        });
        $A.enqueueAction(action);
        
	}
	
})