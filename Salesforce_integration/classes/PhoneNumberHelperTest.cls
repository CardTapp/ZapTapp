@isTest
private class PhoneNumberHelperTest {

    static testMethod void myUnitTest() {
        
         System.AssertEquals('(201) 555-9988',PhoneNumberHelper.getFormatted10digitPhoneNumber('2015559988'));
         System.AssertEquals('(201) 555-9988',PhoneNumberHelper.getFormatted10digitPhoneNumber('201-555-9988'));
         System.AssertEquals('(201) 555-9988',PhoneNumberHelper.getFormatted10digitPhoneNumber('(201)-555-9988'));
         System.AssertEquals('(201) 555-9988',PhoneNumberHelper.getFormatted10digitPhoneNumber('(201)-555-9988'));
         System.AssertEquals('0039-55-599-88445',PhoneNumberHelper.getFormatted10digitPhoneNumber('0039-55-599-88445'));
        
    }
}