(Code) Failed Yext provisioning attempts

var token_array = inputData.bodyText.split(/\r?\n/);
                var arrayLength = token_array.length;
                var tokens = [];
                var j = 0;
                for (var i = 0; i < arrayLength; i++) {

                    if (token_array[i].length >= 3 && token_array[i].substr(0,3) === '  *') {
                        tokens[j] = token_array[i].replace('  * ','');
                        j++;
                    }
                }

                output = [{
                    subdomain: tokens[0], 
                    vertical_code: tokens[1],
                    user_id: tokens[2],
                    app_link: tokens[3].replace('http://',''),
                    status: tokens[5].replace(' Status: ',''),
                    error: tokens[6]
                }] 