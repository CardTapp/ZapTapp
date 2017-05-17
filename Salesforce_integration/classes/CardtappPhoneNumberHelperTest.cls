@isTest
private class CardtappPhoneNumberHelperTest {

    static testMethod void myUnitTest() {
        
         System.AssertEquals('(201) 555-9988',CardtappPhoneNumberHelper.getFormatted10digitPhoneNumber('2015559988'));
         System.AssertEquals('(201) 555-9988',CardtappPhoneNumberHelper.getFormatted10digitPhoneNumber('201-555-9988'));
         System.AssertEquals('(201) 555-9988',CardtappPhoneNumberHelper.getFormatted10digitPhoneNumber('(201)-555-9988'));
         System.AssertEquals('0039-55-599-88445',CardtappPhoneNumberHelper.getFormatted10digitPhoneNumber('0039-55-599-88445'));
        
    }
}