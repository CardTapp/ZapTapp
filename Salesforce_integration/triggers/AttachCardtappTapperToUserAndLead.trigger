trigger AttachCardtappTapperToUserAndLead on Cardtapp_Tapper__c (before insert) {
    
       	String DEFAULT_ACCOUNT_COMPANY_NAME = 'N/A - Shared from App';
       	String LEAD_SOURCE = 'Cardtapp App Share';
        	
        for(Cardtapp_Tapper__c t : Trigger.new ) {
        	
        	if (t.Suppress_triggers__c == false) {
        		
	        	t = AttachCardtappTapper.AssociateUserToTapper(t);
	        	t = AttachCardtappTapper.LookupContactCreateLead(t,DEFAULT_ACCOUNT_COMPANY_NAME,LEAD_SOURCE); 
	        			// alternatively, method LookupContactCreateContact(Cardtapp_Tapper__c t, String companyName, String leadSource) can be used
        	}

			System.debug('Tapper record before insert: ' + t);
        	t.Suppress_triggers__c = false;
        }
        
}