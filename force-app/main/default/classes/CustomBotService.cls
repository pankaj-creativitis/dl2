global without sharing class CustomBotService {
    
    // AccountNumber
    // FinServ__PrimaryContact__c.Email
    global class ValidateAccountRequest{
        @InvocableVariable(required=true)
        global String accountId;
    }
    
    global class ValidateAccountResponse{
        @InvocableVariable
		global String otpMessage;        
    }
    
 
    
     /**
    * @description this invocable method is wired with a bot dialogue to validate the card selected
    * @param List<ValidateCardRequest> validateCardRequests
    * @return List<boolean>
    **/
    @InvocableMethod(label='Validate Account' description='Checks if the email & Account provided by customer is valid')
    public static List<CustomBotService.ValidateAccountResponse> validateAccount(List<CustomBotService.ValidateAccountRequest> validateCardRequests) {
       List<CustomBotService.ValidateAccountResponse> validateResponses = new List<CustomBotService.ValidateAccountResponse>();
                
        if(validateCardRequests.size() == 0){
            return validateResponses;
        }

        for(CustomBotService.ValidateAccountRequest request : validateCardRequests){
            CustomBotService.ValidateAccountResponse cbVa = new CustomBotService.ValidateAccountResponse();
            Account acc = [SELECT Id,  FinServ__PrimaryContact__c, AccountNumber from Account
                          where AccountNumber = :request.accountId];
            system.debug('acc >> '+ acc);
            
            String conId = String.valueOf(acc.FinServ__PrimaryContact__c);
            system.debug('conId >> '+ conId);
            Contact con = [SELECT Id, Email from Contact
                          where Id = :conId];
            String otp = String.valueOf(CustomBotUtil.generateRandomCode());
            acc.OTP__c = otp;
            update acc;
            
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new String[] { con.Email };
                message.optOutPolicy = 'FILTER';
            message.subject = 'OTP for UDB Verification';
            message.plainTextBody = otp + ' is your one time password for UDB Verification';
            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            
            if (results[0].success) 
            {
                System.debug('The email was sent successfully.');
                cbVa.otpMessage = 'Please input the 6 digit otp';
                validateResponses.add(cbVa);	
            } else 
            {
                System.debug('The email failed to send: ' + results[0].errors[0].message);
                 System.debug('The email was sent successfully.');
                cbVa.otpMessage = 'Something went wrong, Please try again later';
                    validateResponses.add(cbVa);
            }
        //   IBot_OOBEmailService ibM = new IBot_OOBEmailService();
        // ibM.sendEmail(CustomBotUtil.generateRandomCode(), con.Email) ;
        
            
        }
        

        return validateResponses;

    }
    
   


}