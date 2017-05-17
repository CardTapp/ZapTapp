public with sharing class CardtappAttachTapper {
    
    static final string NEW_CONTACT_CREATED_WORKFLOW_ACTION_NAME = 'New Contact created';
    static final string NEW_LEAD_CREATED_WORKFLOW_ACTION_NAME = 'New Lead created';
    static final string EXISTING_CONTACT_FOUND_WORKFLOW_ACTION_NAME = 'Existing Contact found';
    static final string EXISTING_LEAD_FOUND_WORKFLOW_ACTION_NAME = 'Existing Lead found';
    static final string AMBIGUOUS_LEAD_CONTACT_FOUND_WORKFLOW_ACTION_NAME = 'Ambiguous Lead/Contact found';
    
    public static Cardtapp_Tapper__c AssociateUserToTapper(Cardtapp_Tapper__c t) {
    	
    	if (t.Member_external_id__c == null || t.Member_external_id__c == '') {
    		return t;
    	}
    	
    	string search_token = '%' + CardtappQueryHelper.MakeSafer(t.Member_external_id__c) + '%';
    	List<User> users = [SELECT Id, Cardtapp_notifications__c FROM User WHERE Cardtapp_External_Ids__c LIKE :search_token LIMIT 1];
    	    	
    	if (users.size() != 0) {
    		
    		User u = users[0];
    		t.Salesforce_User__c = u.Id;
    		
    		if (u.Cardtapp_notifications__c != null && u.Cardtapp_notifications__c != '') {
    			
	    		t.Notify_new_contact_created__c =  (u.Cardtapp_notifications__c.toLowerCase().contains('new contact created'));
	    		t.Notify_new_lead_created__c = (u.Cardtapp_notifications__c.toLowerCase().contains('new lead created'));
	    		t.Notify_existing_contact_found__c = (u.Cardtapp_notifications__c.toLowerCase().contains('existing contact found'));
	    		t.Notify_existing_lead_found__c = (u.Cardtapp_notifications__c.toLowerCase().contains('existing lead found'));
	    		t.Notify_Ambiguous_lead_contact_found__c = (u.Cardtapp_notifications__c.toLowerCase().contains('ambiguous lead/contact found'));
    		}	
    	}
    	 return t;
    }

    
     public static Cardtapp_Tapper__c LookupCreateSObject(  Cardtapp_Tapper__c t, 
     														String companyName, 
     														String leadSource, 
     														string createObjectType, 
     														boolean doLookupLead) {
     															
		Boolean createObjectTypeIsContact = (createObjectType == 'Contact') ? true : false;
		Boolean createObjectTypeIsLead = (createObjectType == 'Lead') ? true : false;

		// Only works for creating Contacts and Leads
		if (!createObjectTypeIsContact && !createObjectTypeIsLead) {
			return t;
		}
     
     	List<Contact> contactSearchResult = CardtappAttachTapperHelper.FindExistingSobject(t,'Contact');   	
    	
    	if (contactSearchResult.size() >= 2) {
    		
    		t.Workflow_action__c = AMBIGUOUS_LEAD_CONTACT_FOUND_WORKFLOW_ACTION_NAME;
    		// Do nothing because search result is ambiguous    

    		return t;		
    	} else if (contactSearchResult.size() == 1) {
    		// Associate Tapper to Contact
    		t.Salesforce_Contact__c = contactSearchResult[0].Id;
			t.Workflow_action__c = EXISTING_CONTACT_FOUND_WORKFLOW_ACTION_NAME;
			
    		return t;
    	}
		
		if (doLookupLead) {
			// Lookup in Lead object
	    	List<Lead> leadSearchResult = CardtappAttachTapperHelper.FindExistingSobject(t,'Lead');	
	
	    	if (leadSearchResult.size() >= 2) {

	    		t.Workflow_action__c = AMBIGUOUS_LEAD_CONTACT_FOUND_WORKFLOW_ACTION_NAME;
    			// Do nothing because search result is ambiguous    

	    		return t;		
	    	} else if (leadSearchResult.size() == 1) {
	    		// Associate Tapper to Lead	    		
	    		t.Salesforce_Lead__c = leadSearchResult[0].Id;
				t.Workflow_action__c = EXISTING_LEAD_FOUND_WORKFLOW_ACTION_NAME;
			
	    		return t;
	    	} 	    		
		}
		
		if (createObjectTypeIsContact) {
			
			// Retrieve AccountID
			Account a = CardtappAttachTapperHelper.GetOrCreateDefaultAccount(companyName);
					
    		// Create new contact
    		Id newContactId = CardtappAttachTapperHelper.CreateNewContactFromTapperRecord(t,a,leadSource);
    		
    		// Associate Tapper to Contact
    		t.Salesforce_Contact__c = newContactId;

			// Record workflow action type
			t.Workflow_action__c = NEW_CONTACT_CREATED_WORKFLOW_ACTION_NAME;
			
		} else {
    		
    		// Create new lead
    		Id newLeadId = CardtappAttachTapperHelper.CreateNewLeadFromTapperRecord(t,companyName,leadSource);
    		
    		// Associate Tapper to Lead
    		t.Salesforce_Lead__c = newLeadId;

			// Record workflow action type
			t.Workflow_action__c = NEW_LEAD_CREATED_WORKFLOW_ACTION_NAME;

    	}    	
     
     	return t;
     }
    
}