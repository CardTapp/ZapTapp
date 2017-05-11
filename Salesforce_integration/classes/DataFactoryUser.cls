public class DataFactoryUser {
	
    // This method dynamically creates a username prefix that will make ensure username uniqueness.
    public static String getUserNamePrefix(){
        return UserInfo.getOrganizationId() + System.now().millisecond();
    }
    
    public static Id getUserProfileId(String profileName) {
    	
    	Profile p = [SELECT Id from Profile where Name = :profileName];
    	return p.Id;
    }
    
    // Other create and insert methods here...
    public static User insertStandardUser(){
        // assert standardProfileId valid
        User standardUser = new User(
          Username = getUserNamePrefix() + 'standarduser@testorg.com',
          Alias = 'standt',
          email = 'standarduser@testorg.com',
          emailencodingkey = 'UTF-8',
          LastName = 'Testing',
          LocaleSidKey = 'en_US',
          ProfileId = getUserProfileId('Standard User'),
          LanguageLocaleKey = 'en_US',
          TimeZoneSidKey = 'America/Los_Angeles'
        );
        insert standardUser;
        return standardUser;
    }
    
    public static User insertAdminUser(){
        // assert standardProfileId valid
        User adminUser = new User(
          Username = getUserNamePrefix() + 'adminuser@testorg.com',
          Alias = 'adminu',
          email = 'adminuser@testorg.com',
          emailencodingkey = 'UTF-8',
          LastName = 'Testing',
          LocaleSidKey = 'en_US',
          ProfileId = getUserProfileId('System Administrator'),
          LanguageLocaleKey = 'en_US',
          TimeZoneSidKey = 'America/Los_Angeles'
        );
        insert adminUser;
        return adminUser;
    }
}