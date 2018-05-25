(Code) Big Purple Dot individual users

 function escapeRegExp(str) {
                    return str.replace(/([.*+?^=!:${}()|\[\]\/\\])/g, "\\$1");
                }

                function replaceAll(str, find, replace) {
                    if (
                        typeof(str) !== 'undefined' && 
                        str !== null && 
                        typeof(replace) !== 'undefined'
                    ) {
                    return str.replace(new RegExp(escapeRegExp(find), 'g'), replace);
                    }
                    return "";
                }

                function replaceAllMultiFields(str) {
                    str = replaceAll(str,"{referrer_name}",inputData.referrer_name);
                    str = replaceAll(str,"{referrer_name_descriptive}",inputData.referrer_name_descriptive);
                    // add more here as needed
                    return str;
                }

                var bpd_notes = replaceAllMultiFields(inputData.bpd_notes);
                var bpd_additional_source_info = replaceAllMultiFields(inputData.bpd_additional_source_info);

                output = [{bpd_notes: bpd_notes, bpd_additional_source_info: bpd_additional_source_info}];