public with sharing class AttachCardtappTapper {
    
    public static Cardtapp_Tapper__c AssociateUserToTapper(Cardtapp_Tapper__c t) {
    	
    	if (t.Member_external_id__c == null || t.Member_external_id__c == '') {
    		return t;
    	}
    	
    	string search_token = '%' + t.Member_external_id__c + '%';
    	List<User> users = [SELECT Id FROM User WHERE Cardtapp_External_Ids__c LIKE :search_token LIMIT 1];
    	
    	if (users.size() != 0) {
    		
    		User u = users[0];
    		t.Salesforce_User__c = u.Id;
    	}
    	
    	 return t;
    }

    public static Cardtapp_Tapper__c LookupContactCreateContact(Cardtapp_Tapper__c t, String companyName, String leadSource) {
    	
		Account a = AttachCardtappTapperHelper.GetOrCreateDefaultAccount(companyName);
    	
    	List<Contact> searchResult = AttachCardtappTapperHelper.FindExistingContact(t);
    	
    	if (searchResult.size() == 0) {
    		// Create new contact
    		Id newContactId = AttachCardtappTapperHelper.CreateNewContactFromTapperRecord(t,a,leadSource);
    		
    		// Associate Tapper to Contact
    		t.Salesforce_Contact__c = newContactId;
    		
    	} else if (searchResult.size() == 1) {
    		// Associate Tapper to Contact
    		
    		t.Salesforce_Contact__c = searchResult[0].Id;
    		
    	} else {
    		// Do nothing because search result is ambiguous
    	}
    	
    	return t;
    }    

    public static Cardtapp_Tapper__c LookupContactCreateLead(Cardtapp_Tapper__c t, String companyName, String leadSource) {
    	
    	List<Contact> searchResult = AttachCardtappTapperHelper.FindExistingContact(t);
    	
    	System.debug('Returned Contact list in LookupContactCreateLead contained ' + searchResult.size() + ' contacts.');
    	
    	if (searchResult.size() == 0) {
    		// Create new lead
    		Id newLeadId = AttachCardtappTapperHelper.CreateNewLeadFromTapperRecord(t,companyName,leadSource);
    		
    		// Associate Tapper to Lead
    		t.Salesforce_Lead__c = newLeadId;
    		
    	} else if (searchResult.size() == 1) {
    		// Associate Tapper to Contact
    		
    		t.Salesforce_Contact__c = searchResult[0].Id;
    		System.debug ('Associating Tapper to Contact with ID ' + t.Salesforce_Contact__c);
    		
    	} else {
    		// Do nothing because search result is ambiguous
    	}
    	
    	return t;    	
    }    
    
}