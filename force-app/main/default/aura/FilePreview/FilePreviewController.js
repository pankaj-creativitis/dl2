({
	handlePANFinished: function (cmp, event) {
        // Get the list of uploaded files
        var uploadedFiles = event.getParam("files");
        // alert("Files uploaded : " + uploadedFiles.length);

        // Get the file name
        uploadedFiles.forEach(file => console.log(file.name));
        //documentId
        // alert(uploadedFiles[0].documentId);
        var docId = uploadedFiles[0].documentId;
        cmp.set('v.nfileId',docId);
        cmp.set('v.showDetails',true);
        
    }
})