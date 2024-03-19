public class OCRRequestBody {
    	public cls_requests[] requests;
	class cls_requests {
		public cls_image image;
		public cls_features[] features;
	}
	class cls_image {
		public String content;	///9j/7QBEUGhvdG9zaG9...base64-encoded-image-content...fXNWzvDEeYxxxzj/Coa6Bax//Z
	}
	class cls_features {
		public String type;	//DOCUMENT_TEXT_DETECTION
	}
	public static OCRRequestBody parse(String json){
		return (OCRRequestBody) System.JSON.deserialize(json, OCRRequestBody.class);
	}
}