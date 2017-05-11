@isTest
private class AttachCardtappTapperTest {

    static testMethod void AssociateUserToTapperTest() {
       
       
        User u = DataFactoryUser.insertStandardUser();
        u.Cardtapp_External_Ids__c = 'abcd,0123456789-0123456789-01234567890-56,qrst';
        update u;
        
        System.debug(u);
        
		Cardtapp_Tapper__c t1 = new Cardtapp_Tapper__c(
				Member_External_ID__c = '0123456789-0123456789-01234567890-56'		
		);

		System.debug(t1);
		
		Cardtapp_Tapper__c t2 = new Cardtapp_Tapper__c(
				Member_External_ID__c = ''		
		);

		Cardtapp_Tapper__c t3 = new Cardtapp_Tapper__c(
				Member_External_ID__c = 'should_not_be_found'		
		);
		
		t1 = AttachCardtappTapper.AssociateUserToTapper(t1);
		t2 = AttachCardtappTapper.AssociateUserToTapper(t2);
		t3 = AttachCardtappTapper.AssociateUserToTapper(t3);
		
		System.AssertEquals(u.Id,t1.Salesforce_User__c);
		System.AssertEquals(null,t2.Salesforce_User__c);
		System.AssertEquals(null,t3.Salesforce_User__c);

    }
    
    static testMethod void LookupContactCreateContact() {
    	
       	String LEAD_SOURCE = 'Cardtapp App Share';

		List<Cardtapp_Tapper__c> tlist = new List<Cardtapp_Tapper__c>();
		
    	Cardtapp_Tapper__c t1 = new Cardtapp_Tapper__c(
				Tapper_External_ID__c = '0123456789-0123456789-01234567890-56.abcdef',
				Tapper_Firstname__c = 'Bob',
				Tapper_Lastname__c = 'Smith',
				Tapper_Name__c = 'Bob Smith',
				Tapper_Email__c = 'bob@bob.com',
				Tapper_Phone_Number__c = '(201) 345-6789',
				Suppress_Triggers__c = true
		);
		tlist.Add(t1);

    	Cardtapp_Tapper__c t2 = new Cardtapp_Tapper__c(
				Tapper_External_ID__c = '0123456789-0123456789-01234567890-56.ghijkl',
				Tapper_Firstname__c = 'Stan',
				Tapper_Lastname__c = 'Jones',
				Tapper_Name__c = 'Stan Jones',
				Tapper_Email__c = 'stan@stan.com',
				Tapper_Phone_Number__c = '(201) 888-9999',
				Suppress_Triggers__c = true
		);
		tlist.Add(t2);
		insert tlist;
				
		// create an account
        Account testAccount = new Account(Name = 'My test account');
        insert testAccount;

        // has first, last and phone
        Contact c1 = new Contact(
        						AccountId = testAccount.Id,
        						FirstName = 'Bob',
        						LastName = 'Smith',
        						MobilePhone = '(201) 345-6789'
        						);
        insert c1;

        Cardtapp_Tapper__c t1_processed = AttachCardtappTapper.LookupContactCreateContact(t1,'My test account',LEAD_SOURCE);
        Cardtapp_Tapper__c t2_processed = AttachCardtappTapper.LookupContactCreateContact(t2,'My test account',LEAD_SOURCE);
		
		System.AssertEquals(c1.Id,t1_processed.Salesforce_Contact__c);
		
		List<Contact> return_list = [SELECT Id, Name, MobilePhone, Email FROM Contact WHERE MobilePhone = '(201) 888-9999'];		

		System.AssertEquals(1,return_list.size());
		System.AssertEquals(return_list[0].Id,t2_processed.Salesforce_Contact__c);
    }
    
    
    static testMethod void LookupContactCreateLead() {

       	String LEAD_SOURCE = 'Cardtapp App Share';
       	
		List<Cardtapp_Tapper__c> tlist = new List<Cardtapp_Tapper__c>();
		
    	Cardtapp_Tapper__c t1 = new Cardtapp_Tapper__c(
				Tapper_External_ID__c = '0123456789-0123456789-01234567890-56.abcdef',
				Tapper_Firstname__c = 'Bob',
				Tapper_Lastname__c = 'Smith',
				Tapper_Name__c = 'Bob Smith',
				Tapper_Email__c = 'bob@bob.com',
				Tapper_Phone_Number__c = '(201) 345-6789',
				Suppress_Triggers__c = true
		);
		tlist.Add(t1);

    	Cardtapp_Tapper__c t2 = new Cardtapp_Tapper__c(
				Tapper_External_ID__c = '0123456789-0123456789-01234567890-56.ghijkl',
				Tapper_Firstname__c = 'Stan',
				Tapper_Lastname__c = 'Jones',
				Tapper_Name__c = 'Stan Jones',
				Tapper_Email__c = 'stan@stan.com',
				Tapper_Phone_Number__c = '(201) 888-9999',
				Suppress_Triggers__c = true
		);
		tlist.Add(t2);
		insert tlist;
				
		// create an account
        Account testAccount = new Account(Name = 'My test account');
        insert testAccount;

        // has first, last and phone
        Contact c1 = new Contact(
        						AccountId = testAccount.Id,
        						FirstName = 'Bob',
        						LastName = 'Smith',
        						MobilePhone = '(201) 345-6789'
        						);
        insert c1;

        Cardtapp_Tapper__c t1_processed = AttachCardtappTapper.LookupContactCreateLead(t1,'My test account',LEAD_SOURCE);
        Cardtapp_Tapper__c t2_processed = AttachCardtappTapper.LookupContactCreateLead(t2,'My test account',LEAD_SOURCE);
		
		System.AssertEquals(c1.Id,t1_processed.Salesforce_Contact__c);
		
		List<Lead> llist = [SELECT Id, Name, MobilePhone, Email FROM Lead WHERE MobilePhone = '(201) 888-9999'];		

		System.AssertEquals(1,llist.size());
		System.AssertEquals(llist[0].Id,t2_processed.Salesforce_Lead__c);
    }
    
}