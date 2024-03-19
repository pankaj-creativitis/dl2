({
  doInit: function(component, event, helper) {
    var headers = component.get("v.headers");
    var inputs = component.get("v.inputData");

    if (headers.length == inputs.length) {
      helper.displayData(component, headers, inputs);
    } else {
      console.error(
        "Number of headers does not equal the number data inputted."
      );
      helper.showToast(
        "Error",
        "Number of headers does not equal the number data inputted."
      );
    }
  }
});