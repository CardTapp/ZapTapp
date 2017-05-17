@isTest
private class CardtappDataFactoryUserTest {

    static testMethod void myUnitTest() {
        
      User u = CardtappDataFactoryUser.insertStandardUser();
      System.debug(u);
      System.AssertEquals('standarduser@testorg.com',u.email);
      
      User a = CardtappDataFactoryUser.insertAdminUser();
      System.debug(a);
      System.AssertEquals('adminuser@testorg.com',a.email);
  
    }
}