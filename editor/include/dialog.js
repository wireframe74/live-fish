
var promptArray = new Array();

// browser detection
function Browser()
{
  var agent  = navigator.userAgent.toLowerCase();
  this.ns    = ((agent.indexOf('mozilla')   !=   -1) &&
                ((agent.indexOf('spoofer')   ==   -1) &&
                (agent.indexOf('compatible') ==   -1)));
  this.ie    = (agent.indexOf("msie")       !=   -1);
}
var browser = new Browser();

// add ESC function
if(browser.ie)
  document.onkeypress = onEsc;
else
  document.addEventListener("keypress", onEsc, false);

function onEsc(e)
{
  var evt = null;
  
  if(browser.ie)
    evt = window.event;
  else
    evt = e;
    
  if(evt.keyCode == 27) 
    window.close();
}

// only for compatibility to older version
function getLanguageString(lng,id)
{
  var aLanguage = params[14];
  return aLanguage[id];
}
function getString(id)
{
  if(id == "")
    return "";
    
  var aLanguage = params[14];
  return aLanguage[id];
}

// combo functions
function comboAdd(combo,text,value)
{
  var item = document.createElement("option");
  item.text = text;
  item.value = value;
  if(browser.ie) {
    combo.add(item);
  } else {
    combo.add(item,null);
  }
}

function comboSet(combo,value)
{
  var len = combo.length;
  for(var i=0;i<len;i++) {
    if(combo.options[i].value == value) {
      combo.selectedIndex = i;
      return;
    }
  }
}

function comboClear(combo)
{
  while(combo.options.length >0) {
    combo.remove(0);
  }
}


function setCombo(combo,value)
{
  comboSet(combo,value);
}

// localize span and div
function setStrings()
{
  try {
    // set span
    var aSpan = document.getElementsByTagName("span");
    for(var i=0;i<aSpan.length;i++) {
      if(!isNaN(aSpan[i].id))
        aSpan[i].innerHTML = getString(aSpan[i].id);
    }
    // set div
    var aDiv = document.getElementsByTagName("div");
    for(var i=0;i<aDiv.length;i++) {
      if(!isNaN(aDiv[i].id))
        aDiv[i].innerHTML = getString(aDiv[i].id);
    }
  } catch(Error) {}
}

/*
var __moz_save_id = "";
function selectColor(id)
{
  if(browser.ns) {
    var left = screen.width/2 - 440/2;
    var top = screen.height/2 - 320/2;
    __moz_save_id = id;
    window.open("../../../dialogs/color.html","color","modal=1,left=" + left + ",top=" + top + ",height=320,width=440,resizable=0,status=0,scrollbars=0");
	} else {
		var color = window.showModalDialog("../../../dialogs/color.html",params,"dialogHeight:355px;dialogWidth:440px;resizable:0;status:0;scroll:0");
		if(color != null) {
			document.getElementById(id).value = color;
			document.getElementById(id).style.backgroundColor = color;
		}
	}
}
*/

var __temp_after_id = "";
function afterSelectColor(color)
{
  document.getElementById(__temp_after_id).value = color;
  document.getElementById(__temp_after_id).style.backgroundColor = color;
}

function selectColor(id)
{
  __temp_after_id = id;
  
  try {
    var color = new ColorDialog("1");
    color.onAfterSelect = "afterSelectColor";
    color.colors = params[11].editGetUsedColors();
    color.color = document.getElementById(id).value;
    color.language = language;
    color.open();
    
  } catch(Error) {
  }
}


function selectColorWp(id)
{
  var oldColor = "";
  
  try {
    oldColor = document.getElementById(id).style.backgroundColor;
  } catch(Error) {}
  
  if (oldColor != "")
    params[22] = oldColor;
  else
    params[22] = "rgb(255, 255, 255)";
    
  __temp_after_id = id;
  
  try {
    var color = new ColorDialog("1");
    color.onAfterSelect = "afterSelectColor";
    color.colors = params[11].editGetUsedColors();
    color.color = document.getElementById(id).value;
    color.language = language;
    color.open();
  } catch(Error) {
  }
}

function removeAttribute(obj, attribute) 
{
  if(browser.ie) {
    obj.removeAttribute(attribute);
  } else {
    eval ("obj."+attribute+" = null");
  }
}


function MozillaGetParams()
{
  return params;
}

function MozillaCallbackSetColor(color)
{
	if(color != null) {
    //Only set color code in HTML Mode
    try {
	    if (userMode == "0") {
		    document.getElementById(__moz_save_id).value = color;
		  }
    } catch(Error) {}
		document.getElementById(__moz_save_id).style.backgroundColor = color;
		try {
		  updateColor();
		}catch(Error) {}
	}
}

function rgbToHex(rgbColor)
{
  var RGB = new Array(256);
  var k = 0;
  var hex = new Array("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F");
  var temp2 = "";
  
  try {
    for (var i = 0; i < 16; i++) {	
	    for (var j = 0; j < 16; j++) {		
		    RGB[k] = hex[i] + hex[j];
		    k++;
	    }
    }
    rgbColor = rgbColor.replace(/\(/,"<");
    rgbColor = rgbColor.replace(/\)/,">");

    var reg = new RegExp("<[^>]+>","gi");
    var result = rgbColor.match(reg);

    rgbColor = result[0];
    rgbColor = rgbColor.substring(1, rgbColor.length - 1);
    rgbColor = rgbColor.replace(/ /gi,"");  
    var temp = rgbColor.split(",");
    temp2 = "#" + RGB[temp[0]] + RGB[temp[1]] + RGB[temp[2]];
  } catch(Error) {};

  return temp2;
}

function showPrompt(title, description, height, width, input, callback, validate)
{
	promptArray[0] = params;
	promptArray[1] = title;
	promptArray[2] = description;
	promptArray[3] = input;
	promptArray[4] = callback;
	promptArray[5] = validate;

	if(browser.ns) {
    var left = screen.width/2 - 440/2;
    var top = screen.height/2 - 335/2;
    window.open("../dialogs/prompt.html","prompt","modal=1,left=" + left + ",top=" + top + ",height="+height+",width="+width+",resizable=0,status=0,scrollbars=0");
	} else {
		var ret = window.showModalDialog("../../dialogs/prompt.html",promptArray,"dialogHeight:"+height+"px;dialogWidth:"+width+"px;resizable:1;status:0;scroll:0");
		eval(callback + "(\"" + ret + "\");");
	}	
}

function readPromptArray()
{
	return promptArray;
}

function writePromptArray()
{
}

var params = null;



// JavaScript Document
var __colorDialog_params = new Array();

function ColorDialog(id)
{
  this.id         = "__color" + id;
  this.onAfterSelect    = null;
  this.path       = null;
  this.colors     = null;
  this.color      = null;
  this.style      = "";
  this.language   = null;
  this.selectedColor = null;

  this.open = __colorDialog_open;
}

function __colorDialog_open()
{
	__colorDialog_params[0] = this.language;

  if (this.color != "")
    __colorDialog_params[1] = this.color;
  else
    __colorDialog_params[1] = "rgb(255, 255, 255)";

  __colorDialog_params[2] = this.onAfterSelect;
  __colorDialog_params[3] = this.colors;

  if(browser.ns) {
    var left = screen.width/2 - 480/2;
    var top = screen.height/2 - 390/2;
    __colorDialog_params[1] = rgbToHex(__colorDialog_params[1]);
    //__moz_save_id = id;
    window.open("../../../dialogs/colorFrame.html","color","modal=1,left=" + left + ",top=" + top + ",height=385,width=480,resizable=0,status=0,scrollbars=0");
	} else {
		this.selectedColor = window.showModalDialog("../../../dialogs/colorFrame.html",__colorDialog_params,"dialogHeight:380px;dialogWidth:480px;resizable:0;status:0;scroll:0");
		eval(this.onAfterSelect + "('" + this.selectedColor + "')");
	}

}

function __colorDialog_getParams()
{
  return __colorDialog_params;
}
