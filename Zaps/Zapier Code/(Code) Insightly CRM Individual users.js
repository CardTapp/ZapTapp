(Code) Insightly CRM Individual users

 var encoded = Buffer.from(inputData.crm_user_api_key).toString("base64");
    ​
                var email_block;
                ​
                if (
                inputData.tapper_email === null ||
                inputData.tapper_email === "" ||
                typeof inputData.tapper_email === "undefined" ||
                inputData.tapper_email.length === 0
                ) {
                email_block = "";
                } else {
                email_block =
                    ',{"TYPE": "EMAIL","SUBTYPE": null,"LABEL": "WORK","DETAIL": "' +
                    inputData.tapper_email +
                    '"}';
                }
                ​
                console.log("email_block type of = " + typeof email_block);
                ​
                output = [{ auth_string: "Basic " + encoded, email_block: email_block }];