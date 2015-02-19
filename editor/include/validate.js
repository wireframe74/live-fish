//------------------------------------------------------------------------------
// Possible Validators
//------------------------------------------------------------------------------
var cEMAIL = "[a-zA-Z0-9_.-]{1,}\\@[a-zA-Z0-9_.-]{1,}\\.\\w{2,}";
var cDATE = "\\d{2}\\.\\d{2}\\.\\d{4}";
var cZIP = "\\d{5}";
var cSTREET = "[a-zA-Z0-9- )(ßÄÖÜäöü.]+";
var cNAME = "[^§'€]+";
var cPHONE = "[0-9 )(-/+]+";
var cNUMBER = "\\d{1,}";
var cFLOAT = "[0-9]{1,}\\,[0-9]{0,}";
//var cTEXT = "[a-zA-Z0-9-ßÄÖÜäöü #+!§()/&*?.-]+";
var cTEXT = "[a-zA-Z0-9_.-]+";

var cDATE_E = "\\d{4}\\-\\d{2}\\-\\d{2}";
var cFLOAT_E = "[0-9]{1,}\\.[0-9]{0,}";
var cNUMBER_E = "[0-9]{1,}\\.[0-9]{1,2}";

var _lastSelected;
var _bcHighlight = "#FFCC66";
var _bcStandard = "white";

function checkFloat(field,validator,message,language)
{
  if(!check(field,cNUMBER,message,language,false)) {
          // if last char is "," then add 0
          var value = field.value;
          var last = value.substring(value.length-1,value.length)
          // if we have a german or a english format
          if(validator == cFLOAT || validator == cFLOAT_E) {
                  return check(field,validator,message,language,true);
          } else {
                  // use default
                  return check(field,cFLOAT,message,language,true);
          }
  } else {
          return true;
  }
}

// Standard validate function
function check(field, validator, message, language, isHighlight)
{
	var regEx  = new RegExp(validator);
	var match  = regEx.exec(field.value);
	var temp   = "";
	var isHigh = false;

	// if isHighlight is not set, make sure that it is true
	if(isHighlight == null) {
		isHigh = true;
	} else {
		isHigh = isHighlight;
	}

	if(_lastSelected != null)
		setBackground(_lastSelected,_bcStandard);

	if (match == null) {
		if(isHigh)
			highlight(field,message);
		return false;
	}

	temp += match;

	if(match.index == 0 && temp.length == field.value.length) {
		return true;
	} else {
		if(isHigh)
			highlight(field,message);
		return false;
	}
}

function highlight(field,message)
{
	setBackground(field,_bcHighlight);
	_lastSelected = field;
	alert(message);
	field.focus();
	field.select();
}

function checkDate(field,validator,message)
{
	var value = field.value;

	//if(value.length == 0)
	//	return false;

	if(check(field,validator,message)) {
		var day		= value.substr(0,2);
		var month	= value.substr(3,2);
		var year	= value.substr(6,4);

		if (day < 1 || day > 31) {
			highlight(field,message);
			return false;
		}

		if (month < 1 || month > 12) {
			highlight(field,message);
			return false;
		}

		if ((month==4 || month==6 || month==9 || month==11) && day==31)	{
			highlight(field,message);
			return false;
		}

		if (month == 2)	{
			var isLeap = (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0));
			if (day > 29 || (day==29 && !isLeap))	{
				highlight(field,message);
				return false;
			}
		}
	} else {
		return false;
	}
	return true;
}

function setBackground(field, value)
{
  if(browser.dom)
    field.style.background = value;
}
