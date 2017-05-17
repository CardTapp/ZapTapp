public with sharing class CardtappAttachTapperHelper {

	public static List<SObject> FindExistingSObject (Cardtapp_Tapper__c t, string object_type) {
		
		Boolean isContact = (object_type == 'Contact') ? true : false;
		Boolean isLead = (object_type == 'Lead') ? true : false;
		Map<string,string> filterMap;
				
		List<SObject> return_list = new List<SObject>();

		// Only works for Contacts and Leads
		if (!isContact && !isLead) {
			return return_list;
		}

        // See if a relevant ObjectId is provided with the Tapper record
        if (isContact && !IsNullOrEmptyString(t.Salesforce_Contact__c)) {

			filterMap = new Map<string,string> { 'Id' => t.Salesforce_Contact__c};			
        	return_list = Database.query( CardtappQueryHelper.BuildLeadContactSearchQuery(object_type, filterMap,false));		
			if (return_list.size() >= 1) { return return_list;}
        }

        if (isLead && !IsNullOrEmptyString(t.Salesforce_Lead__c)) {

			filterMap = new Map<string,string> { 'Id' => t.Salesforce_Lead__c};			
        	return_list = Database.query( CardtappQueryHelper.BuildLeadContactSearchQuery(object_type, filterMap,false));		
			if (return_list.size() >= 1) { return return_list;}
        }

        // If that didn't work, try looking up based on email address
        if (!IsNullOrEmptyString(t.Tapper_email__c )) {

			filterMap = new Map<string,string> { 'Email' => t.Tapper_email__c};
        	return_list = Database.query( CardtappQueryHelper.BuildLeadContactSearchQuery(object_type, filterMap,false));				
			if (return_list.size() >= 1) { return return_list;}
        }

        // If that didn't work, try looking up based on mobile#
        if (!IsNullOrEmptyString(t.Tapper_phone_number__c)) {

			String formatted_phone = CardtappPhoneNumberHelper.getFormatted10digitPhoneNumber(t.Tapper_phone_number__c);
			filterMap = new Map<string,string> { 'MobilePhone' => formatted_phone, 'Phone' => formatted_phone};			
        	return_list = Database.query( CardtappQueryHelper.BuildLeadContactSearchQuery(object_type, filterMap,false));				
			if (return_list.size() >= 1) { return return_list;}
        }
       	
       	// If that didn't work, try looking up based on first name, last name, and Owner ID
       	if (	!IsNullOrEmptyString(t.Salesforce_User__c) && 
       			!IsNullOrEmptyString(t.Tapper_firstname__c) && 
       			!IsNullOrEmptyString(t.Tapper_lastname__c)
       	) {
			filterMap = new Map<string,string> { 'OwnerId' => t.Salesforce_User__c, 'Firstname' => t.Tapper_Firstname__c, 'Lastname' => t.Tapper_Lastname__c};
        	return_list = Database.query( CardtappQueryHelper.BuildLeadContactSearchQuery(object_type, filterMap,true));				
			if (return_list.size() >= 1) { return return_list;}
		}
		
		return return_list; 
	}

    public static void UpdateSObjectFromTapperData (Cardtapp_Tapper__c t,SObject so) {
		// Only works for Leads and Contacts
		
		Boolean doUpdate;
		String oldValue;
		String so_email = (String)so.get('Email');
		String so_mobilephone = (String)so.get('MobilePhone');
		
		// Write phone# from Tapper record into Contact or Lead
		if (!IsNullOrEmptyString(t.Tapper_phone_number__c) && IsNullOrEmptyString(so_mobilephone)) {
			
			oldValue = (String)so.put('MobilePhone',t.Tapper_phone_number__c);
			doUpdate = true;
		}

		// Write Email from Tapper record into Contact or Lead
		if (!IsNullOrEmptyString(t.Tapper_Email__c) && IsNullOrEmptyString(so_email)) {
			
			oldValue = (String)so.put('Email',t.Tapper_Email__c);
			doUpdate = true;
		}
		
		if (doUpdate) {
			update so;			
		}		
		
	}
	
	public static Id CreateNewContactFromTapperRecord (Cardtapp_Tapper__c t, Account a, String leadSource) {
		
		Contact c = new Contact (
									AccountId = a.Id,
									FirstName = t.Tapper_firstname__c,
									// If no last name is provided, duplicate first name
									LastName = (!IsNullOrEmptyString(t.Tapper_lastname__c)) ? t.Tapper_lastname__c : t.Tapper_firstname__c,
									MobilePhone = t.Tapper_phone_number__c,
									Email = t.Tapper_email__c,
									LeadSource = leadSource,
									Description = 'Cardtapp referrer: ' + t.Referrer_name__c
		);
		
		if (!IsNullOrEmptyString(t.Salesforce_User__c)) {
			
			c.OwnerId = t.Salesforce_User__c;
		}
		
		insert c;

		return c.Id;
	}

	public static Id CreateNewLeadFromTapperRecord (Cardtapp_Tapper__c t, String company, String leadSource) {
		
		Lead l = new Lead (
									FirstName = t.Tapper_firstname__c,
									// If no last name is provided, duplicate first name
									LastName = (!IsNullOrEmptyString(t.Tapper_lastname__c)) ? t.Tapper_lastname__c : t.Tapper_firstname__c,
									Company = company,
									MobilePhone = t.Tapper_phone_number__c,
									Email = t.Tapper_email__c,
									LeadSource = leadSource,
									Description = 'Cardtapp referrer: ' + t.Referrer_name__c
		);
		
		if (!IsNullOrEmptyString(t.Salesforce_User__c)) {
			
			l.OwnerId = t.Salesforce_User__c;
		}
		
		insert l;

		return l.Id;
	}
	
	public static Boolean IsNullOrEmptyString(Object o){
		
		if (o == null || o == '') {
			return true;
		} else {
			return false;
		}
	}
	
	public static Account GetOrCreateDefaultAccount(String accountName) {
		
		List<Account> alist = [SELECT Id FROM Account WHERE Name = :accountName];
		Account a;
		
		if (alist.size() == 0) {
			
			a = new Account(Name = accountName);
        	insert a;
        	
		} else {
			
			a = alist[0];
		}
		
		return a;
	}
	
}