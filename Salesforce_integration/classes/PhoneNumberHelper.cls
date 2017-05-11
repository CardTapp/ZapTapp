public with sharing class PhoneNumberHelper {
    
    public static String getFormatted10digitPhoneNumber(String input) {
    	
    	String result = input.replace('(','');
    	result = result.replace(')','');
    	result = result.replace('-','');
    	result = result.replace(' ','');
    	
    	if (result.length() == 10) {
    		
    		return '(' + result.left(3) + ') ' + result.mid(3,3) + '-' + result.right(4);
    		  
    	} else {
    		
    		return input;
    	}
    }
}