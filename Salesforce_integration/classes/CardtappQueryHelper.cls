public with sharing class CardtappQueryHelper {
    
    public static string BuildQueryWithFilter(string[] selectFields, string objectName, Map<string,string> filterMap, boolean isAnd) {
    	
        if (objectName != 'Contact' && objectName != 'Lead') {
        	// only works with Leads and Contacts
        	return null;
   	    }

    	string result = 'SELECT ';
    	
    	for (integer i = 0; i < selectFields.size(); i++) {
    		
    		result += MakeSafer(selectFields[i]) + ',';
    	}
    	
    	result = result.left(result.length() - 1) + ' FROM ' + MakeSafer(objectName) + ' WHERE ' + BuildWhereClause(filterMap, isAnd);
    	
    	return result;
    }
    
    public static string BuildWhereClause(Map<string,string> filterMap, boolean isAndClause) {
    	
    	string result = '';
    	string operatorString = (isAndClause) ? ' AND ' : ' OR ';
    	
    	for (string key : filterMap.keySet()) {

    		string value = filterMap.get(key);
    		
    		if (key == 'Phone' || key == 'MobilePhone') {
    			
    			result += MakeSafer(key) + ' = \'' + MakePhoneNumberSafer(value) + '\'' + operatorString;
    		} else {
    			
    			result += MakeSafer(key) + ' = \'' + MakeSafer(value) + '\'' + operatorString;
    		}
    	}

	    result = result.left(result.length() - operatorString.length());	
	    return result;
    }
    
    
    public static string MakeSafer(string input) {
    	
    	string result = String.escapeSingleQuotes(input);
    	result = result.replace(' ','');
    	result = result.replace('%','');
    	result = result.replace(',','');
    	
    	return result;
    }
    
    
    public static string MakePhoneNumberSafer(string input) {
    
		string result = MakeSafer(input);
		return CardtappPhoneNumberHelper.getFormatted10digitPhoneNumber(result);
    }
    
    
    public static string BuildLeadContactSearchQuery(string objectName,Map<string,string> filterMap,boolean isAnd) {
    	
    	    string[] selectFields = new string[] {'Id','FirstName','LastName','Email','MobilePhone','Phone','OwnerId'};
    	    
    	    return BuildQueryWithFilter(selectFields, objectName, filterMap, isAnd);
    }
    
    
}