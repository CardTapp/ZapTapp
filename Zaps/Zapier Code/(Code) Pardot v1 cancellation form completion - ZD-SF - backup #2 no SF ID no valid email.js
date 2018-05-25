(Code) Pardot v1 cancellation form completion -> ZD/SF - backup #2 no SF ID no valid email


function getEmail(subject) {
	var result = subject.replace("Pardot Form: v1 confirm cancellation - ","");
	return result.replace(" ","").toLowerCase();
}

function get_Contact(body) {
	var parts = body.split("Full Prospect Details");
	var rows = parts[1].split("\n");
	var contact = {};
	var index;
	for (index = 0; index < rows.length; ++index) {
		if (rows[index].includes(":") ) {
		var rowparts = rows[index].split(":");
		var key = rowparts[0].replace(/\s+/g, '_');
		if (key.substring(0,1) === "_") {
		key = key.replace("_","");
	}
	var value = rowparts[1].replace("\r","");
	if (value.substring(0,1) === " ") {
		value = value.replace(" ","");
	}
	contact[key] = value;
	}
}
console.log(contact);
return contact;
}

var contact = get_Contact(inputData.emailBody);
output = [{memberEmail: getEmail(inputData.emailSubject), memberFirstname: contact.First_name, memberLastName: contact.Last_name}];