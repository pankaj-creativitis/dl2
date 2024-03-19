import { LightningElement,api } from 'lwc';

export default class UploadPrequalificationDocs extends LightningElement {
    @api myRecordId;

    get acceptedFormats() {
        return ['.pdf', '.png', '.jpg'];
    }

    handleUploadFinished(event) {
        // Get the list of uploaded files
        const uploadedFiles = event.detail.files;
        alert("myRecordId: " + JSON.stringify(event.detail.files));
        document.getElementById("output_image").src = event.detail.files[0];

        // alert("No. of files uploaded : " + uploadedFiles.length);
        
    }

    readURL(event) {
        alert("myRecordId: " + JSON.stringify(event.detail.files));
        document.getElementById("blah").src = event.detail.files[0];
        if (input.files && input.files[0]) {
            var reader = new FileReader();

            reader.onload = function (e) {
                $('#blah')
                    .attr('src', e.target.result);
            };

            reader.readAsDataURL(input.files[0]);
        }
    }
}