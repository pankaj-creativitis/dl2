@isTest
public class VerifyOTPForAccountTest {
    @isTest static void verifyOTPMethod_Test(){
        Account a = new Account(Name='Test',Primary_Account_Balance__c = 10000, AccountNumber = '689696', OTP__c='345356'); 
        insert a;
        List<VerifyOTPForAccount.VerifyOTP> verifyOTPRequestsEmpty = new List<VerifyOTPForAccount.VerifyOTP>();
        List<VerifyOTPForAccount.VerifyOTP> verifyOTPRequests = new List<VerifyOTPForAccount.VerifyOTP>();
        VerifyOTPForAccount.VerifyOTP v1 = new VerifyOTPForAccount.VerifyOTP();
        v1.accountId = a.AccountNumber;
        v1.otp = a.OTP__c;
        VerifyOTPForAccount.VerifyOTP v2 = new VerifyOTPForAccount.VerifyOTP();
        v2.accountId = null;
        v2.otp = null;
        verifyOTPRequests.add(v1);
        verifyOTPRequests.add(v2);
        System.assert(VerifyOTPForAccount.verifyOTPMethod(verifyOTPRequestsEmpty).size()<1);
        System.assert(VerifyOTPForAccount.verifyOTPMethod(verifyOTPRequests).size()>0);
        
    }
}