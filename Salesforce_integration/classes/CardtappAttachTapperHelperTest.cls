@isTest
private class CardtappAttachTapperHelperTest {

    static testMethod void IsNullOrEmptyString() {
    	
    	Boolean b1 = CardtappAttachTapperHelper.IsNullOrEmptyString(null);
    	Boolean b2 = CardtappAttachTapperHelper.IsNullOrEmptyString('');
    	Boolean b3 = CardtappAttachTapperHelper.IsNullOrEmptyString('Hi there');
    	Boolean b4 = CardtappAttachTapperHelper.IsNullOrEmptyString(852);
    	System.AssertEquals(true,b1);
    	System.AssertEquals(true,b2);
    	System.AssertEquals(false,b3);
    	System.AssertEquals(false,b4);
    }
    
    static testMethod void CreateNewContactFromTapperRecord() {
    	
       	String LEAD_SOURCE = 'Cardtapp App Share';
    	
    	// create an account
        Account testAccount = new Account(Name = 'My test account');
        insert testAccount;

        User u = CardtappDataFactoryUser.insertStandardUser();
        
        Cardtapp_Tapper__c t = new Cardtapp_Tapper__c(
				Member_External_ID__c = '0123456789-0123456789-01234567890-56',
				Tapper_External_ID__c = '0123456789-0123456789-01234567890-56.abcdef',
				Tapper_Firstname__c = 'Bob',
				Tapper_Lastname__c = '',
				Tapper_Name__c = 'Bob',
				Tapper_Email__c = 'bob@bob.com',
				Tapper_Phone_Number__c = '(201) 345-6789',
				Salesforce_User__c = u.Id
		);
		insert t;

        Id contactId = CardtappAttachTapperHelper.CreateNewContactFromTapperRecord(t,testAccount,LEAD_SOURCE);
        
        Contact c = [SELECT Id, MobilePhone, Email, Name, OwnerId, AccountId, LeadSource from Contact where Id = :contactId];
        
        System.AssertEquals(testAccount.Id,c.AccountId);
        System.AssertEquals('(201) 345-6789',c.MobilePhone);
        System.AssertEquals('bob@bob.com',c.Email);
        System.AssertEquals('Bob Bob',c.Name);
        System.AssertEquals(u.Id,c.OwnerId);
        System.AssertEquals(LEAD_SOURCE,c.LeadSource);
        
    }

    static testMethod void CreateNewLeadFromTapperRecord() {

       	String LEAD_SOURCE = 'Cardtapp App Share';
       	
        User u = [SELECT Id, Name, Email FROM User WHERE IsActive = True LIMIT 1];
        
        Cardtapp_Tapper__c t = new Cardtapp_Tapper__c(
				Member_External_ID__c = '0123456789-0123456789-01234567890-56',
				Tapper_External_ID__c = '0123456789-0123456789-01234567890-56.abcdef',
				Tapper_Firstname__c = 'Bob',
				Tapper_Lastname__c = '',
				Tapper_Name__c = 'Bob',
				Tapper_Email__c = 'bob@bob.com',
				Tapper_Phone_Number__c = '(201) 345-6789',
				Salesforce_User__c = u.Id
		);
		insert t;

        Id leadId = CardtappAttachTapperHelper.CreateNewLeadFromTapperRecord(t,'Acme Co.',LEAD_SOURCE);
        
        Lead l = [SELECT Id, MobilePhone, Email, Name, OwnerId, Company, LeadSource from Lead where Id = :leadId];
        
        System.AssertEquals('(201) 345-6789',l.MobilePhone);
        System.AssertEquals('bob@bob.com',l.Email);
        System.AssertEquals('Bob Bob',l.Name);
        System.AssertEquals(u.Id,l.OwnerId);
        System.AssertEquals('Acme Co.',l.Company);
        System.AssertEquals(LEAD_SOURCE,l.LeadSource);
        
    }
    
    static testMethod void UpdateSObjectFromTapperData () {
		
		List<Contact> clist = new List<Contact>();
		
        // create an account
        Account testAccount = new Account(Name = 'My test account');
        insert testAccount;

        Contact c1 = new Contact(
        						AccountId = testAccount.Id,
        						FirstName = 'firstname1',
        						LastName = 'lastname1'
        						);
        clist.Add(c1);

        Contact c2 = new Contact(
                                AccountId = testAccount.Id,
        						FirstName = 'firstname2',
        						LastName = 'lastname2'
        						);
        clist.Add(c2);
        						        
        Contact c3 = new Contact(
                                AccountId = testAccount.Id,
        						FirstName = 'firstname3',
        						LastName = 'lastname3'
        						);
        clist.Add(c3);
    	insert clist;

		// just email
        Cardtapp_Tapper__c t1 = new Cardtapp_Tapper__c(
        		Tapper_External_ID__c = '0123456789-0123456789-01234567890-56.abcdef',
				Tapper_Email__c = 'bob@bob.com',
				Suppress_Triggers__c = true
		);
	
		// just phone    
        Cardtapp_Tapper__c t2 = new Cardtapp_Tapper__c(
        		Tapper_External_ID__c = '0123456789-0123456789-01234567890-56.ghijkl',
				Tapper_Phone_Number__c = '(201) 345-6789',
				Suppress_Triggers__c = true
		);
		
		// email and phone
		Cardtapp_Tapper__c t3 = new Cardtapp_Tapper__c(
        		Tapper_External_ID__c = '0123456789-0123456789-01234567890-56.mnopqr',
				Tapper_Email__c = 'bob@bob.com',
				Tapper_Phone_Number__c = '(201) 345-6789',
				Suppress_Triggers__c = true
		);
		
		CardtappAttachTapperHelper.UpdateSObjectFromTapperData(t1,c1);
		CardtappAttachTapperHelper.UpdateSObjectFromTapperData(t2,c2);
		CardtappAttachTapperHelper.UpdateSObjectFromTapperData(t3,c3);

		Contact updated_c1 = [SELECT Id, Email, MobilePhone FROM Contact WHERE Id = :c1.Id];		
		Contact updated_c2 = [SELECT Id, Email, MobilePhone FROM Contact WHERE Id = :c2.Id];		
		Contact updated_c3 = [SELECT Id, Email, MobilePhone FROM Contact WHERE Id = :c3.Id];		

		System.AssertEquals('bob@bob.com',c1.Email);
		System.AssertEquals('(201) 345-6789',c2.MobilePhone);
		System.AssertEquals('bob@bob.com',c3.Email);
		System.AssertEquals('(201) 345-6789',c3.MobilePhone);
	}
	
	static testMethod void GetOrCreateDefaultAccount() {
		
		Account testAccount = new Account(Name = 'My test account');
        insert testAccount;
        
        Account return_acct1 = CardtappAttachTapperHelper.GetOrCreateDefaultAccount('My test account');
        System.AssertEquals(testAccount.Id,return_acct1.Id);
        
        Account return_acct2 = CardtappAttachTapperHelper.GetOrCreateDefaultAccount('Cant Find This One');
        System.AssertEquals('Cant Find This One',return_acct2.Name);
        System.Assert(return_acct2.Id != null);
        
        
	}
	
	    static testMethod void FindExistingSObject() {

		List<Contact> cList = new List<Contact>();
		List<Cardtapp_Tapper__c> tList = new List<Cardtapp_Tapper__c>();
		List<Lead> llist = new List<Lead>();
		
        User u = [SELECT Id, Name, Email FROM User WHERE IsActive = True LIMIT 1];

        // create an account
        Account testAccount = new Account(Name = 'My test account');
        insert testAccount;

        // has first, last and owner
        Contact c1 = new Contact(
        						AccountId = testAccount.Id,
        						FirstName = 'firstname1',
        						LastName = 'lastname1',
        						OwnerId = u.Id
        						);
        clist.Add(c1);

		// has email
        Contact c2 = new Contact(
                                AccountId = testAccount.Id,
        						FirstName = 'firstname2',
        						Email = 'bob@bob.com',
        						LastName = 'lastname2'
        						);
        clist.Add(c2);
        						        
        // has phone
        Contact c3 = new Contact(
                                AccountId = testAccount.Id,
        						FirstName = 'firstname3',
        						MobilePhone = '(201) 345-6789',
        						LastName = 'lastname3'
        						);
        clist.Add(c3);
    	insert clist;
    		
        // has first, last and owner
        Lead l1 = new Lead(
        						Company = 'My test account',
        						FirstName = 'firstname1',
        						LastName = 'lastname1',
        						OwnerId = u.Id
        						);
        llist.Add(l1);

		// has email
        Lead l2 = new Lead(
        						Company = 'My test account',
        						FirstName = 'firstname2',
        						Email = 'bob@bob.com',
        						LastName = 'lastname2'
        						);
        llist.Add(l2);
        						        
        // has phone
        Lead l3 = new Lead(
        						Company = 'My test account',
        						FirstName = 'firstname3',
        						MobilePhone = '(201) 345-6789',
        						LastName = 'lastname3'
        						);
        llist.Add(l3);
    	insert llist;
    
        Cardtapp_Tapper__c t1 = new Cardtapp_Tapper__c(
        		Tapper_External_ID__c = '0123456789-0123456789-01234567890-56.abcdef',
				Tapper_Firstname__c = 'firstname1',
				Tapper_Lastname__c = 'lastname1',
				Salesforce_User__c = u.Id,
				Suppress_Triggers__c = true
		);
		tlist.Add(t1);

        Cardtapp_Tapper__c t2 = new Cardtapp_Tapper__c(
        		Tapper_External_ID__c = '0123456789-0123456789-01234567890-56.ghijkl',
				Tapper_Email__c = 'bob@bob.com',
				Suppress_Triggers__c = true
		);
		tlist.Add(t2);
        
        Cardtapp_Tapper__c t3 = new Cardtapp_Tapper__c(
        		Tapper_External_ID__c = '0123456789-0123456789-01234567890-56.mnopqr',
				Tapper_Phone_Number__c = '(201) 345-6789',
				Suppress_Triggers__c = true
		);
		tlist.Add(t3);

        Cardtapp_Tapper__c t4 = new Cardtapp_Tapper__c(
        		Tapper_External_ID__c = '0123456789-0123456789-01234567890-56.stuvwx',
				Salesforce_Contact__c = c1.Id,
				Salesforce_Lead__c = l1.Id,
				Suppress_Triggers__c = true
		);
		tlist.Add(t4);
		insert tlist;

		System.debug(llist);
		System.debug(clist);
		System.debug(tlist);
		
		List<Contact> return_c1 = CardtappAttachTapperHelper.FindExistingSObject(t1,'Contact');
		List<Contact> return_c2 = CardtappAttachTapperHelper.FindExistingSObject(t2,'Contact');
		List<Contact> return_c3 = CardtappAttachTapperHelper.FindExistingSObject(t3,'Contact');
		List<Contact> return_c4 = CardtappAttachTapperHelper.FindExistingSObject(t4,'Contact');
		List<Lead> return_l1 = CardtappAttachTapperHelper.FindExistingSObject(t1,'Lead');
		List<Lead> return_l2 = CardtappAttachTapperHelper.FindExistingSObject(t2,'Lead');
		List<Lead> return_l3 = CardtappAttachTapperHelper.FindExistingSObject(t3,'Lead');
		List<Lead> return_l4 = CardtappAttachTapperHelper.FindExistingSObject(t4,'Lead');

		System.debug('return_c1 ' + return_c1);
		System.debug('return_c2 ' + return_c2);
		System.debug('return_c3 ' + return_c3);
		System.debug('return_c4 ' + return_c4);
		System.debug('return_l1 ' + return_l1);
		System.debug('return_l2 ' + return_l2);
		System.debug('return_l3 ' + return_l3);
		System.debug('return_l4 ' + return_l4);
		
		
		System.AssertEquals(1,return_c1.size());
		System.AssertEquals(1,return_c2.size());
		System.AssertEquals(1,return_c3.size());
		System.AssertEquals(1,return_c4.size());

		System.AssertEquals(c1.Id,return_c1[0].Id);
		System.AssertEquals(c2.Id,return_c2[0].Id);
		System.AssertEquals(c3.Id,return_c3[0].Id);
		System.AssertEquals(c1.Id,return_c4[0].Id);
				
		System.AssertEquals(1,return_l1.size());
		System.AssertEquals(1,return_l2.size());
		System.AssertEquals(1,return_l3.size());
		System.AssertEquals(1,return_l4.size());

		System.AssertEquals(l1.Id,return_l1[0].Id);
		System.AssertEquals(l2.Id,return_l2[0].Id);
		System.AssertEquals(l3.Id,return_l3[0].Id);
		System.AssertEquals(l1.Id,return_l4[0].Id);

		List<SObject> return_xx = CardtappAttachTapperHelper.FindExistingSObject(t1,'Case');
		System.AssertEquals(0,return_xx.size());
		


    }
	
	
}