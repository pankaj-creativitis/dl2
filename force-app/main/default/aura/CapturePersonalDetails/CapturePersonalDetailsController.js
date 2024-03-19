({
	aadhaarUploadFinished: function (cmp, event) {
        // Get the list of uploaded files
        var uploadedFiles = event.getParam("files");
        alert("Files uploaded : " + JSON.stringify(uploadedFiles));
        cmp.set("v.aadhaar", true);
        // documentId
        cmp.set("v.aadhaarId", uploadedFiles[0].documentId);
        // Get the file name
        // uploadedFiles.forEach(file => console.log(file.name));
    },
    panUploadFinished: function (cmp, event) {
        // Get the list of uploaded files
        var uploadedFiles = event.getParam("files");
        alert("Files uploaded : " + JSON.stringify(uploadedFiles));
        cmp.set("v.pan", true);
        // documentId
        cmp.set("v.panId", uploadedFiles[0].documentId);
        // Get the file name
        // uploadedFiles.forEach(file => console.log(file.name));
    }
})