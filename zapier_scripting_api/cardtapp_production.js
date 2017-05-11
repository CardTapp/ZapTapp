'use strict';

function get_firstname_parsed_descriptive(fullname) {
  var tokens = fullname.split(' ');
  if (tokens.length <= 1) {
    return fullname;
  } else if (fullname === 'Not Provided') {
    return 'NameNotProvided';
  } else {
    return tokens[0];
  }
}

function get_lastname_parsed_descriptive(fullname) {
    var tokens = fullname.split(' ');
  if (tokens.length <= 1) {
    return "";
  } else if (fullname === 'Not Provided') {
    return 'CreatedViaEasyText';
  } else {
    var firstname_length = tokens[0].length;
    return fullname.substring(firstname_length+1);
  }
}

function get_tapper_name_descriptive(fullname) {
    if (fullname === 'Not Provided') {
        return 'NameNotProvided CreatedViaEasyText'
    } else {
        return fullname;
    }
}

function get_referrer_name_descriptive(referrer_name,tapper_name) {
    if (isEmpty(referrer_name) && tapper_name === 'Not Provided') {
        return 'EasyText SMS'
    } else {
        return referrer_name;
    }
}

function get_tapper_email_clean(email_string) {
  if (!email_string.includes('@') || email_string.includes(' ')) {
    return '';
  } else {
    return email_string;
  }
}

function get_tapper_email_required_unique(email_string,external_id) {
  if (!email_string.includes('@') || email_string.includes(' ') || email_string === '') {
    return external_id + '@cardtapp.com';
  } else {
    return email_string;
  }
}

function get_mobile_phone_formatted(phone) {
  if (!isEmpty(phone) && phone.length === 10 && phone.substring(0,1) != '1') {
    return phone.substring(0,3) + '-' + phone.substring(3,6) + '-' + phone.substring(6,10);
  } else {
     return phone;
  }
}

function isEmpty(obj) {
  if (obj === null) return true;
  if (_.isArray(obj) || _.isString(obj)) return obj.length === 0;
  for (var key in obj) if (_.has(obj, key)) return false;
  return true;
}

function augement_tapper_payload(json_input) {
    json_input.tapper_firstname_descriptive = get_firstname_parsed_descriptive(json_input.tapper_name);
    json_input.tapper_lastname_descriptive = get_lastname_parsed_descriptive(json_input.tapper_name);
    json_input.tapper_name_descriptive = get_tapper_name_descriptive(json_input.tapper_name);
    json_input.referrer_name_descriptive = get_referrer_name_descriptive(json_input.referrer_name,json_input.tapper_name);
    json_input.tapper_email_clean = get_tapper_email_clean(json_input.tapper_email);
    json_input.tapper_email_required_unique = get_tapper_email_required_unique(json_input.tapper_email,json_input.tapper_external_id);
    json_input.tapper_mobile_phone_formatted = get_mobile_phone_formatted(json_input.tapper_phone_number);
    return json_input;
}

var Zap = {

  tapp_created_catch_hook: function(bundle) {
    var payload = augement_tapper_payload(bundle.cleaned_request);
    payload.tapp_action_data_string = JSON.stringify(payload.tapp_action_data);
    return payload;
  },
  
  tapp_created_post_poll: function(bundle) {
    var payload = augement_tapper_payload(JSON.parse(bundle.response.content)[0]);
    if (isEmpty(payload.tapp_action_data)) {
        payload.tapp_action_data = [
          {
            "field": "Sample Purchase Price", 
            "value": "300000"
          },
          {
            "field": "Sample Down Payment", 
            "value": "20"
          }];
    }
    payload.tapp_action_data_string = JSON.stringify(payload.tapp_action_data);
    return [payload];
  },

  tapper_created_catch_hook: function(bundle) {
    var payload = augement_tapper_payload(bundle.cleaned_request);
    payload.tapp_action_data_string = JSON.stringify(payload.tapp_action_data);
    return payload;
  },
  
  tapper_created_post_poll: function(bundle) {
    var payload = augement_tapper_payload(JSON.parse(bundle.response.content)[0]);
    return [payload];
  }

};