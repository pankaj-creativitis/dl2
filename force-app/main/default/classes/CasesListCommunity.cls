public class CasesListCommunity {
@AuraEnabled
       public static List<Case> getCases(Id usrId) {
           Id userId;
           if(usrId == null){
               userId = Userinfo.getUserid();
           } else {
               userId = usrId;
           }
           
    //    [Select u.Id,u.ContactId from User u where u.Id = '2F005S000000JCSnS'];
        User uid=    [Select u.Id,u.ContactId from User u where u.Id =:userId];
           System.debug('ContactId=============='+uid.ContactId);
        return [Select CaseNumber,Status,Priority,Type,Subject,Account.Name,CreatedDate,Contact.Id from Case 
                where Contact.Id =:uid.ContactId];
           
}

}