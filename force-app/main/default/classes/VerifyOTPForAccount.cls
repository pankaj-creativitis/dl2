global without sharing class VerifyOTPForAccount {
    global class VerifyOTP{
        @InvocableVariable(required=true)
        global String otp;
        @InvocableVariable(required=true)
        global String accountId;
    }
    global class VerifyOTPResponse{
        @InvocableVariable
        global String branchTimings;
        @InvocableVariable
        global String faccountNumber;
        @InvocableVariable
        global Integer noOfRetries;
        @InvocableVariable
        global Boolean transferToAgent;
        @InvocableVariable
        global Boolean success;
        @InvocableVariable
        global String toCustomerMessage;
        @InvocableVariable
        global String transferToAgentMessage;
    }
    
     @InvocableMethod(label='Verify OTP' description='Checks if otp provided by customer is valid')
    public static List<VerifyOTPForAccount.VerifyOTPResponse> verifyOTPMethod(List<VerifyOTPForAccount.VerifyOTP> verifyOTPRequests) {
        List<VerifyOTPForAccount.VerifyOTPResponse> validateResponses = new List<VerifyOTPForAccount.VerifyOTPResponse>();
                
        if(verifyOTPRequests.size() == 0){
            return validateResponses;
        }

        for(VerifyOTPForAccount.VerifyOTP request :verifyOTPRequests){
            VerifyOTPForAccount.VerifyOTPResponse vOtp = new VerifyOTPForAccount.VerifyOTPResponse();
            List<Account> accts = [SELECT Id,  FinServ__PrimaryContact__c,Primary_Account_Balance__c, AccountNumber 
                                   from Account
                                   where AccountNumber = :request.accountId and OTP__c = :request.otp];
            // system.debug('acc >> '+ accts);
            if(accts.size()==0){
                vOtp.success = false;
                vOtp.toCustomerMessage = 'Wrong OTP entered, please try again after sometime.';
            } else{
                vOtp.success = true;
                vOtp.toCustomerMessage = 'Your Balance Amount is Rs.' + String.valueOf(accts[0].Primary_Account_Balance__c);
            }
            validateResponses.add(vOtp);
        }
        return validateResponses;
    }
}