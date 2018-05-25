(Code) Pardot v1 cancellation form completion -> ZD/SF - Main

function getEmail(subject) {
                    var result = subject.replace("Pardot Form: v1 confirm cancellation - ","");
                    return result.replace(" ","").toLowerCase();
            }

                function getContactId(emailBody) {
                    var parts = emailBody.split("View in CRM: https://na63.salesforce.com/");
                    var result = '';
                    console.log('parts size is ' + parts.length);
                    if (parts.length > 1) {
                        result = parts[1].substring(0, 18);
                    } 
                return result;
            }

            function getBody(emailBody) {
                var result = emailBody.replace("UTM_content","");
                result = result.replace("Field Value","");
                result = result.replace("UTM_Age","CANCELLATION REASON");
                result = result.replace("Form Submission: v1 confirm cancellation","\nCONFIRMED CANCELLATION");
                result = result.replace("*Full Prospect Details*","\n");
                result = result.replace("[image: Pardot] <http://www.pardot.com/>","");
                return result;
            }

            output = [{memberEmail: getEmail(inputData.emailSubject),editedEmailBody:getBody(inputData.emailBody), contactId:getContactId(inputData.emailBody)}];