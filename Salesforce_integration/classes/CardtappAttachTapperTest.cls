@isTest
private class CardtappAttachTapperTest {

    static final string NEW_CONTACT_CREATED_WORKFLOW_ACTION_NAME = 'New Contact created';
    static final string NEW_LEAD_CREATED_WORKFLOW_ACTION_NAME = 'New Lead created';
    static final string EXISTING_CONTACT_FOUND_WORKFLOW_ACTION_NAME = 'Existing Contact found';
    static final string EXISTING_LEAD_FOUND_WORKFLOW_ACTION_NAME = 'Existing Lead found';
    static final string AMBIGUOUS_LEAD_CONTACT_FOUND_WORKFLOW_ACTION_NAME = 'Ambiguous Lead/Contact found';

    static testMethod void AssociateUserToTapperTest() {
       
    	List<User> ulist = new List<User>();   
        User u = CardtappDataFactoryUser.insertStandardUser();
        u.Cardtapp_External_Ids__c = 'abcd,0123456789-0123456789-01234567890-56,qrst';
		ulist.Add(u);

        User u2 = CardtappDataFactoryUser.insertStandardUser();
        u2.Cardtapp_External_Ids__c = 'abcd,0123456789-0123456789-01234567890-99';        
        u2.Cardtapp_notifications__c = 'New Contact Created;New Lead Created;Existing Contact Found;Existing Lead Found;Ambiguous Lead/Contact Found';
		ulist.Add(u2);

        update ulist;
        System.debug(ulist);
        
		Cardtapp_Tapper__c t1 = new Cardtapp_Tapper__c(
				Member_External_ID__c = '0123456789-0123456789-01234567890-56',
				Tapper_Name__c = 'tapper t1'
		);

		System.debug(t1);
		
		Cardtapp_Tapper__c t2 = new Cardtapp_Tapper__c(
				Member_External_ID__c = '',
				Tapper_Name__c = 'tapper t2'
		);

		Cardtapp_Tapper__c t3 = new Cardtapp_Tapper__c(
				Member_External_ID__c = 'should_not_be_found',
				Tapper_Name__c = 'tapper t3'		
		);

		Cardtapp_Tapper__c t4 = new Cardtapp_Tapper__c(
				Member_External_ID__c = '0123456789-0123456789-01234567890-99',
				Tapper_Name__c = 'tapper t4'		
		);
		
		t1 = CardtappAttachTapper.AssociateUserToTapper(t1);
		t2 = CardtappAttachTapper.AssociateUserToTapper(t2);
		t3 = CardtappAttachTapper.AssociateUserToTapper(t3);
		t4 = CardtappAttachTapper.AssociateUserToTapper(t4);
		
		System.AssertEquals(u.Id,t1.Salesforce_User__c);
		System.AssertEquals(false,t1.Notify_new_contact_created__c);
		System.AssertEquals(false,t1.Notify_new_lead_created__c);
		System.AssertEquals(false,t1.Notify_existing_contact_found__c);
		System.AssertEquals(false,t1.Notify_existing_lead_found__c);
		System.AssertEquals(false,t1.Notify_Ambiguous_lead_contact_found__c);

		System.AssertEquals(null,t2.Salesforce_User__c);
		System.AssertEquals(null,t3.Salesforce_User__c);

		System.AssertEquals(u2.Id,t4.Salesforce_User__c);
		System.AssertEquals(true,t4.Notify_new_contact_created__c);
		System.AssertEquals(true,t4.Notify_new_lead_created__c);
		System.AssertEquals(true,t4.Notify_existing_contact_found__c);
		System.AssertEquals(true,t4.Notify_existing_lead_found__c);
		System.AssertEquals(true,t4.Notify_Ambiguous_lead_contact_found__c);

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

        Cardtapp_Tapper__c t1_processed = CardtappAttachTapper.LookupCreateSObject(t1,'My test account',LEAD_SOURCE,'Contact',false);
        Cardtapp_Tapper__c t2_processed = CardtappAttachTapper.LookupCreateSObject(t2,'My test account',LEAD_SOURCE,'Contact',false);
		
		Contact t1_contact = [SELECT Id, Name, MobilePhone, Email FROM Contact WHERE Id = :t1_processed.Salesforce_Contact__c];
		Contact t2_contact = [SELECT Id, Name, MobilePhone, Email FROM Contact WHERE Id = :t2_processed.Salesforce_Contact__c];

		System.AssertEquals(c1.Id,t1_processed.Salesforce_Contact__c);
		System.AssertEquals(EXISTING_CONTACT_FOUND_WORKFLOW_ACTION_NAME,t1_processed.Workflow_Action__c);
		
		List<Contact> return_list = [SELECT Id, Name, MobilePhone, Email FROM Contact WHERE MobilePhone = '(201) 888-9999'];		

		System.AssertEquals(1,return_list.size());
		System.AssertEquals(return_list[0].Id,t2_processed.Salesforce_Contact__c);
		System.AssertEquals(NEW_CONTACT_CREATED_WORKFLOW_ACTION_NAME,t2_processed.Workflow_Action__c);
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

        Cardtapp_Tapper__c t1_processed = CardtappAttachTapper.LookupCreateSObject(t1,'My test account',LEAD_SOURCE,'Lead',false);
        Cardtapp_Tapper__c t2_processed = CardtappAttachTapper.LookupCreateSObject(t2,'My test account',LEAD_SOURCE,'Lead',false);
		
		System.AssertEquals(c1.Id,t1_processed.Salesforce_Contact__c);
		
		List<Lead> llist = [SELECT Id, Name, MobilePhone, Email FROM Lead WHERE MobilePhone = '(201) 888-9999'];		

		System.AssertEquals(1,llist.size());
		System.AssertEquals(llist[0].Id,t2_processed.Salesforce_Lead__c);
    }
 
 
     static testMethod void LookupContactLookupLeadCreateLead() {

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

    	Cardtapp_Tapper__c t3 = new Cardtapp_Tapper__c(
				Tapper_External_ID__c = '0123456789-0123456789-01234567890-56.mnopqr',
				Tapper_Firstname__c = 'Shirley',
				Tapper_Lastname__c = 'Jackson',
				Tapper_Name__c = 'Shirley Jackson',
				Tapper_Email__c = 'shirley@jackson.com',
				Tapper_Phone_Number__c = '(201) 888-1111',
				Suppress_Triggers__c = true
		);
		tlist.Add(t3);
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

        // has first, last and phone
        Lead l1 = new Lead(
        						Company = 'SuperGood Company',
        						FirstName = 'Shirley',
        						LastName = 'Jackson',
        						MobilePhone = '(201) 888-1111'
        						);
        insert l1;

        Cardtapp_Tapper__c t1_processed = CardtappAttachTapper.LookupCreateSObject(t1,'My test account',LEAD_SOURCE,'Lead',true);
        Cardtapp_Tapper__c t2_processed = CardtappAttachTapper.LookupCreateSObject(t2,'My test account',LEAD_SOURCE,'Lead',true);
        Cardtapp_Tapper__c t3_processed = CardtappAttachTapper.LookupCreateSObject(t3,'My test account',LEAD_SOURCE,'Lead',true);
		
		System.AssertEquals(c1.Id,t1_processed.Salesforce_Contact__c);
		System.AssertEquals(l1.Id,t3_processed.Salesforce_Lead__c);
		
		List<Lead> llist = [SELECT Id, Name, MobilePhone, Email FROM Lead WHERE MobilePhone = '(201) 888-9999'];		

		System.AssertEquals(1,llist.size());
		System.AssertEquals(llist[0].Id,t2_processed.Salesforce_Lead__c);
		
		System.AssertEquals(EXISTING_CONTACT_FOUND_WORKFLOW_ACTION_NAME,t1_processed.Workflow_Action__c);
		System.AssertEquals(NEW_LEAD_CREATED_WORKFLOW_ACTION_NAME,t2_processed.Workflow_Action__c);
		System.AssertEquals(EXISTING_LEAD_FOUND_WORKFLOW_ACTION_NAME,t3_processed.Workflow_Action__c);
		
		
    }
    
}