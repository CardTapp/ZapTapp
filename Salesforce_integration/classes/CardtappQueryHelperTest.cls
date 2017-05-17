@isTest
private class CardtappQueryHelperTest {

    static testMethod void makeSafer() {
      
		string s1 = '\'Test with spaces, commas, quotes and % signs\'';
		System.AssertEquals('\\\'Testwithspacescommasquotesandsigns\\\'',CardtappQueryHelper.MakeSafer(s1));    	  
        
    }
    
    static testMethod void makePhoneNumberSafer() {
      
		string s1 = '(201) 567-2384';
		System.AssertEquals('(201) 567-2384',CardtappQueryHelper.MakePhoneNumberSafer(s1));

		string s2 = '\'(201) 567-2384\'';
		System.AssertEquals('\\\'(201)567-2384\\\'',CardtappQueryHelper.MakePhoneNumberSafer(s2));
    }
    
    static testmethod void BuildQueryWithFilter() {
    	
		string[] selectFields = new string[] {'Id','FirstName','LastName','Email','MobilePhone','Phone','OwnerId'};
   	    Map<string,string> filterMap = new Map<string,string> { 'MobilePhone' => '(201) 567-2384', 'LastName' => 'Bob'};
   	    string goodObjectName = 'Contact';
   	    string badObjectName = 'Case';
   	    
   	    string s1 = CardtappQueryHelper.BuildQueryWithFilter(selectFields, badObjectName, filterMap, false);
   	    string s2 = CardtappQueryHelper.BuildQueryWithFilter(selectFields, goodObjectName, filterMap, false);
   	    
   	    string s2_expectedResult = 'SELECT Id,FirstName,LastName,Email,MobilePhone,Phone,OwnerId FROM Contact WHERE MobilePhone = \'(201) 567-2384\' OR LastName = \'Bob\'';
    	System.AssertEquals(null, s1);
    	System.AssertEquals(s2_expectedResult,s2);
    }
    
    static testmethod void BuildLeadContactSearchQuery() {
    
       	Map<string,string> filterMap = new Map<string,string> { 'MobilePhone' => '(201) 567-2384', 'Email' => 'bob@bob.com'};
   	    string goodObjectName = 'Contact';
   	    string badObjectName = 'Case';
   	    
   	    string s1 = CardtappQueryHelper.BuildLeadContactSearchQuery(badObjectName, filterMap, false);
   	    string s2 = CardtappQueryHelper.BuildLeadContactSearchQuery(goodObjectName, filterMap, false);
   	    
   	    string s2_expectedResult = 'SELECT Id,FirstName,LastName,Email,MobilePhone,Phone,OwnerId FROM Contact WHERE MobilePhone = \'(201) 567-2384\' OR Email = \'bob@bob.com\'';
    	System.AssertEquals(null, s1);
    	System.AssertEquals(s2_expectedResult,s2);
    
    }
    
    static testmethod void BuildWhereClause() {
    	
	    Map<string,string> filterMap = new Map<string,string> { 'MobilePhone' => '(201) 567-2384', 'Email' => 'bob@bob.com'};
   	    string s1 = CardtappQueryHelper.BuildWhereClause(filterMap,false);
   	    string s1_expectedResult = 'WHERE MobilePhone = \'(201) 567-2384\' OR Email = \'bob@bob.com\'';

   	    string s2 = CardtappQueryHelper.BuildWhereClause(filterMap,true);
   	    string s2_expectedResult = 'WHERE MobilePhone = \'(201) 567-2384\' AND Email = \'bob@bob.com\'';
	    	
    }
}