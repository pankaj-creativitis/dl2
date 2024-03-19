public class DeviationEmailTemplate {

    public String emailBody{get;set;}

    public static String getEmailTemplate(){

        List<EmailTemplate> email = [SELECT Id, Name, DeveloperName, FolderId, TemplateType, Description, Subject,  Markup, UiType, RelatedEntityType, IsBuilderContent 
        FROM EmailTemplate WHERE developerName='Deal_Amount_Deviation_Approval' ];
        return email[0].Markup;
    }

    public DeviationEmailTemplate(){
        this.emailBody = getEmailTemplate();
    }

    // public static void getEmailVf();
       
    // }

   
}