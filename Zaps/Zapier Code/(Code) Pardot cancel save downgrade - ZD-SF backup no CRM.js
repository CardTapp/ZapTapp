(Code) Pardot cancel save downgrade -> ZD/SF backup no CRM

function getContactId(emailBody) {
var parts = emailBody.split("View in CRM: https://na63.salesforce.com/");
var result = parts[1].substring(0,18);
return result;
}

function getEmail(subject) {
var result = subject.replace("Pardot Page View Alert: CardTapp - Confirm New $4.99 month Thank You Page Action - ","");
return result.replace(" ","").toLowerCase();
}

function getBody(emailBody) {
var result = emailBody.replace('Page Action Notification: <a href="http://grow.cardtapp.com/keep-app-active-thank-you">CardTapp - Confirm New $4.99 month Thank You Page Action</a>',"MEMBER CANCEL SAVE PARDOT FORM COMPLETED - $19/month\n\nPlease switch this user to a $19/month plan in Stripe\n");
result = result.replace("Full Prospect Details","\n");
return result;
}

output = [{memberEmail: getEmail(inputData.emailSubject),editedEmailBody:getBody(inputData.emailBody)}];