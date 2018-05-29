(Code) Support App events - #1 - Form requests

var action_data_prettyprint = "";

if (inputData.tapp_type === "request") {
    var action_data_array = JSON.parse(inputData.tapp_action_data_string);
    for (var i = 0; i < action_data_array.length; i++) {
         console.log(action_data_array[i]);
         action_data_prettyprint += action_data_array[i]["field"] + ": '" + action_data_array[i].value + "'\n";
      }
    }

return {
   action_data_prettyprint: action_data_prettyprint
};