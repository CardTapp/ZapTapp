@isTest
private class DataFactoryUserTest {

    static testMethod void myUnitTest() {
        
      User u = DataFactoryUser.insertStandardUser();
      System.debug(u);
      System.AssertEquals('standarduser@testorg.com',u.email);
      
      User a = DataFactoryUser.insertAdminUser();
      System.debug(a);
      System.AssertEquals('adminuser@testorg.com',a.email);
  
    }
}