public with sharing class AttachCardtappTapperHelper {
	
	public static List<Contact> FindExistingContact (Cardtapp_Tapper__c t) {
		
		List<Contact> return_list = new List<Contact>();
		
        // See if a contactId is provided with the Tapper record
        if (!IsNullOrEmptyString(t.Salesforce_Contact__c)) {

			return_list = GetContactListFromTapperRecordParts(t,'A');	
        }
        
        // If that didn't work, try looking up based on email address
        if (return_list.size() == 0 && !IsNullOrEmptyString(t.Tapper_email__c )) {

			return_list = GetContactListFromTapperRecordParts(t,'B');
        }

        // If that didn't work, try looking up based on mobile#
        if (return_list.size() == 0 && !IsNullOrEmptyString(t.Tapper_phone_number__c)) {

			return_list = GetContactListFromTapperRecordParts(t,'C');
        }
       	
       	// If that didn't work, try looking up based on first name, last name, and OwnerId ID
       	if (	return_list.size() == 0 && 
       			!IsNullOrEmptyString(t.Salesforce_User__c) && 
       			!IsNullOrEmptyString(t.Tapper_firstname__c) && 
       			!IsNullOrEmptyString(t.Tapper_lastname__c)
       	) {
       			 	
       		return_list = GetContactListFromTapperRecordParts(t,'D');	 	      			 	
		}
        
        return return_list;
	}
	
	
	private static List<Contact> GetContactListFromTapperRecordParts (Cardtapp_Tapper__c t, String search_code) {
		
		System.debug('GetContactListFromTapperRecordParts _ parameters: ' + t + ', ' + search_code);
		
		List<Contact> results_set;
		
		if (search_code == 'A') {    // Search by Contact id
			
        	results_set = 			[SELECT Id,
   		 								FirstName,
   		 								LastName,
   										Email,
   										MobilePhone,
   										Phone,
   										OwnerId
   								 	FROM Contact 
   								  	WHERE Id = :t.Salesforce_Contact__c ];			
			
		} else if (search_code == 'B') {   // Search by tapper email 
			
			results_set = 		[SELECT Id,
   		 								FirstName,
   		 								LastName,
   										Email,
   										MobilePhone,
   										Phone,
   										OwnerId
   								 FROM Contact 
   								 WHERE Email = :t.Tapper_email__c ];			
			
		} else if (search_code == 'C') {   // Search by tapper phone
			
			String formatted_phone = PhoneNumberHelper.getFormatted10digitPhoneNumber(t.Tapper_phone_number__c);
			results_set = 		[SELECT Id,
   		 								FirstName,
   		 								LastName,
   										Email,
   										MobilePhone,
   										Phone,
   										OwnerId
   								 FROM Contact 
   								 WHERE MobilePhone = :formatted_phone OR Phone = :formatted_phone];			

		} else if (search_code == 'D') {  // Search by First Name, Last name and OwnerId
			
   		 	results_set = 		[SELECT Id,
   		 								FirstName,
   		 								LastName,
   										Email,
   										MobilePhone,
   										Phone,
   										OwnerId
   								 FROM Contact 
   								 WHERE OwnerId = :t.Salesforce_User__c
   								   AND Firstname = :t.Tapper_firstname__c
   								   AND Lastname = :t.Tapper_lastname__c ];
		}

		System.debug('GetContactListFromTapperRecordParts with search code ' + search_code + ' returns ' + results_set.size() + ' records');
		
		return results_set;
			
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
									LastName = t.Tapper_lastname__c,
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
									LastName = t.Tapper_lastname__c,
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