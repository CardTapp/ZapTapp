(Code) Mailchimp LIVE individual users

var crypto = require("crypto");
var str = inputData.email.toLowerCase().trim();
var hash = crypto.createHash("md5");
hash.update(str);

output = [{email_hash: hash.digest("hex")}];