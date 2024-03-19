({
  displayData: function(component, headers, inputs) {
    var data = [];
    for (var i = 0; i < headers.length; i++) {
      data.push({ label: headers[i], values: inputs[i], color: "gray" });
    }
    if (data.length > 0) {
      data[0].color = "light-green";
    }
    if (data.length > 1) {
      data[1].color = "light-blue";
    }

    /*var data = [
            {'label':headers[0], 'values':outputs[0],'color':'light-green'},
            {'label':headers[1], 'values':outputs[1],'color':'light-blue'},
            {'label':headers[2], 'values':outputs[2],'color':'gray'}
			];*/
    component.set("v.outputData", data);
  },
  showToast: function(title, message) {
    var toastEvent = $A.get("e.force:showToast");
    if (toastEvent != null) {
      toastEvent.setParams({
        title: title,
        message: message
      });
      toastEvent.fire();
    }
  }
});