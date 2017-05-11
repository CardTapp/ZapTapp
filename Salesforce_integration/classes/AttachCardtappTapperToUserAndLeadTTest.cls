@isTest
private class AttachCardtappTapperToUserAndLeadTTest {

    static testMethod void myUnitTest() {
        
        User u = DataFactoryUser.insertStandardUser();
        u.Cardtapp_External_Ids__c = 'abcd,0123456789-0123456789-01234567890-56,qrst';
        update u;
        System.debug(u);
        
        Cardtapp_Tapper__c t = new Cardtapp_Tapper__c(
				Member_External_ID__c = '0123456789-0123456789-01234567890-56',
				Tapper_External_ID__c = '0123456789-0123456789-01234567890-56.abcdef',
				Tapper_Firstname__c = 'Bob',
				Tapper_Lastname__c = 'Smith',
				Tapper_Phone_Number__c = '(201) 345-6789'
		);
		insert t;
		
		Cardtapp_Tapper__c updated_t = [SELECT Id, Salesforce_User__c FROM Cardtapp_Tapper__c WHERE Id = :t.Id];
		System.debug(updated_t);
		
		System.AssertEquals(u.Id,updated_t.Salesforce_User__c);
		
	    List<Lead> llist = [SELECT Id, Name, MobilePhone, Email FROM Lead WHERE MobilePhone = '(201) 345-6789'];		

		System.AssertEquals(1,llist.size());
		System.AssertEquals('Bob Smith',llist[0].Name);
		System.AssertEquals('(201) 345-6789',llist[0].MobilePhone);
		
		Account testAccount = new Account(Name = 'My test account');
        insert testAccount;
        
        // has phone
        Contact c = new Contact(
                                AccountId = testAccount.Id,
        						FirstName = 'firstname3',
        						MobilePhone = '(203) 888-4444',
        						LastName = 'lastname3'
        						);
        insert c;
        
        Cardtapp_Tapper__c t2 = new Cardtapp_Tapper__c(
				Member_External_ID__c = '0123456789-0123456789-01234567890-56',
				Tapper_External_ID__c = '0123456789-0123456789-01234567890-56.ghijkl',
				Tapper_Firstname__c = 'Firstname3',
				Tapper_Lastname__c = 'Lastname3',
				Tapper_Phone_Number__c = '203-888-4444'
		);
		insert t2;
 
        Cardtapp_Tapper__c  return_t = [SELECT Id, Salesforce_Contact__c FROM Cardtapp_Tapper__c Where Id = :t2.Id];

		
		System.AssertEquals(c.Id,return_t.Salesforce_Contact__c);
    }
}