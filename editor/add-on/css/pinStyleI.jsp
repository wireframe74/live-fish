<%@ page import = "com.pintexx.components.web.pinStyle.*" %>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
  <title>pinStyle</title>

  <LINK href="menu/design/style/pinMenu.css" type="text/css" rel="stylesheet">
  <LINK href="dialogs/dialog.css" type="text/css" rel="stylesheet">
  <script language="javascript" src="include/dialog.js"></script>
  <script language="javascript" src="include/ajax.js"></script>
  <script language="javascript" src="include/styleSheet.js"></script>
  <script language="javascript" src="include/menu.js"></script>
  <script language="javascript" src="include/gl.js"></script>
  <script language="javascript" src="menu/pinMenu.js"></script>
  <script language="javascript">

var globalLanguage = getURLParam("language");
var globalDesign   = getURLParam("design");
var globalMenuDesign = "";
if(globalDesign == "1")
  globalMenuDesign = "Office2000";
if(globalDesign == "2")
  globalMenuDesign = "OfficeXP";
if(globalDesign == "3")
  globalMenuDesign = "Office2003";
if(globalDesign == "4")
  globalMenuDesign = "Office2003S";

document.write('<SCRIP');
document.write('T');
document.write(' SRC=config/localization/' + globalLanguage.toLowerCase() + '.js');
document.write('>' );
document.write('</SCRIP');
document.write('t>');


function Browser()
{
  var agent  = navigator.userAgent.toLowerCase();
  this.ns    = ((agent.indexOf('mozilla')   !=   -1) &&
                ((agent.indexOf('spoofer')   ==   -1) &&
                (agent.indexOf('compatible') ==   -1)));
  this.ie    = (agent.indexOf("msie")       !=   -1);
}
String.prototype.trim = function() { return this.replace(/^\s+|\s+$/, ''); };


var globalCssUrl = null;
var globalCssPath = null;
var globalCssFile = null;
var globalTechnology = null;

var debug = false;
var browser = new Browser();
var undo = new Array(10);
var pointer = 9;
var design = "";
var mode = "";
var objElement;
var aStyles = null;
var params = null;
var tab = null;
var objPreview = null;
var parentObjPreview = null;
var cssLoad = false;
var tree = null;
var styleSheet = new StyleSheet();
var tree = null;
var tabDesign = null;
var tabCode = null;
var tabValidator = null;
var toolbars = null;
var btnBold = null;
var btnItalic = null;
var btnUnderline = null;
var btnLeft = null;
var btnCenter = null;
var btnRight = null;
var btnFull = null;
var cmbFont = null;
var cmbFontSize = null;
var btnColor = null;
var btnBackColor = null;
var objStatus = null;
var dialogparams = new Array();



// process parameters
var param = "";
try {
	param = window.location.search;
} catch(Error) {}

function getLocalizationResource()
{
	return __editLanguage;
}

function getRules()
{
	return styleSheet.getRules();
}

function getColors()
{
  return styleSheet.getColors();
}

function onContextMenuCreate(node,objContextMenu)
{
 	var imagePath = "../toolbar/design/image/style" + globalDesign + "/";

  objContextMenu.width = 120;

  if(node.key == "elements") {
    objContextMenu.add(objContextMenu.createItem("New element",imagePath + "newelement.gif","New element","ELEMENT"));
  } else if(node.key == "class") {
    objContextMenu.add(objContextMenu.createItem("New class",imagePath + "newclass.gif","New class","CLASS"));
  } else if(node.key == "ids") {
    objContextMenu.add(objContextMenu.createItem("New ID",imagePath + "newid.gif","New ID","ID"));
  } else {
    objContextMenu.add(objContextMenu.createItem("Remove",imagePath + "remove.gif","Remove","REMOVE"));
  }
}

function onContextMenuClick(key)
{
  if(key == "ELEMENT") createNewElement();
  if(key == "CLASS") createNewClass();
  if(key == "ID") createNewId();
  if(key == "REMOVE") {
    onAfterNodeRemove(tree.getSelectedNode());
    tree.getSelectedNode().remove();
  }
}

function tabCreate(objTab,id)
{

  var dlgPath = "../dialogs/";

  tab = objTab;
  objTab.design      = "1";
	objTab.orientation = "1";
	objTab.tabarea     = true;
	objTab.designmode  = "IMAGE";

	var item = objTab.createItem();
	item.tag = "DESIGN";
	item.active = true;
	item.url = dlgPath + "css_design.html";
  item.text = getLanguageString(126);
	item.title = getLanguageString(126);
	objTab.add(item);
	tabDesign = item;

	var item = objTab.createItem();
	item.tag = "CODE";
	item.url = dlgPath + "css_code.html";
  item.text = getLanguageString(127);
	item.title = getLanguageString(127);
  item.cached = true;
	objTab.add(item);
	tabCode = item;

	var item = objTab.createItem();
	item.tag = "VALIDATOR";
	//item.url = dlgPath + "dummy.html";
  item.text = "Validator";
	item.title = getLanguageString(127);
  item.cached = false;
	objTab.add(item);
	tabValidator = item;

  objTab.create();

}


function setCodeWindowEditable()
{
  var doc = tabCode.getDocument();
  if(browser.ns) {
    doc.getElementById("code").contentWindow.document.designMode = "on";
  } else {
    doc.getElementById('code').contentWindow.document.body.contentEditable = true;
  }
}

function tabEventTabClick(objTab)
{
  document.getElementById("tab").focus();

	if (objTab.tag == "CODE") {
    tabValidator.setUrl("");
    window.setTimeout("updateCode()", 50);
	}
	if (objTab.tag == "DESIGN") {
    tabValidator.setUrl("");
		var doc = tabCode.getDocument();
    var cssText = doc.getElementById('code').contentWindow.document.body.innerHTML;
  	parseCss(cssText);
  	updateTree();
  	updatePreview();
  	updateSinglePreview();
  	updateDesign();
	}
/*
      Warnungen:
      <select name="warning">
	<option value="2">Alle</option>
	<option selected="selected" value="1">Normaler Bericht</option>
	<option value="0">Die wichtigsten</option>
	<option value="no">Keine</option>
      </select><br />
      <!-- <input type="checkbox" name="error" value="no">Zeige keine Fehlermeldungen an -->

      Profil:
      <select name="profile">
	<option value="none">keins</option>
	<option value="css1">CSS Version 1</option>
	<option selected="selected" value="css2">CSS Version 2</option>
	<option value="css21">CSS Version 2.1</option>
 	<option value="css3">CSS Version 3</option>
	<option value="svg">SVG</option>
	<option value="svgbasic">SVG basic</option>
	<option value="svgtiny">SVG tiny</option>
	<option value="mobile">mobil</option>
	<option value="atsc-tv">ATSC-TV-Profil</option>
	<option value="tv">TV-Profil</option>
      </select>

      Medium:
      <select name="usermedium">
	<option selected="selected" value="all">alle</option>
	<option value="aural">aural</option>
	<option value="braille">braille</option>
	<option value="embossed">embossed</option>
	<option value="handheld">handheld</option>
	<option value="print">print</option>
	<option value= "projection">projection</option>
	<option value="screen">screen</option>
	<option value="tty">tty</option>
	<option value="tv">tv</option>
	<option value="presentation">presentation</option>
      </select><br />
*/
	if (objTab.tag == "VALIDATOR") {
    tabValidator.setUrl("");
		var doc = tabCode.getDocument();
    var cssText = doc.getElementById('code').contentWindow.document.body.innerHTML;
  	parseCss(cssText);
  	updateTree();
  	updatePreview();
  	updateSinglePreview();
    var temp = "<form style='visibility:hidden' method=get id='form' action='http://jigsaw.w3.org/css-validator/validator'>";
    temp+="<textarea id=text NAME='text'></textarea>";
    temp+="<input type=hidden value='css2' name='profile'>";
    temp+="<input type=hidden value='all' name='usermedium'>";
    temp+="<input type=hidden value='no' name='warning'></form>";
    tabValidator.getDocument().body.innerHTML = temp;
    tabValidator.getDocument().getElementById("text").value = styleSheet.cssText("structured");
    tabValidator.getDocument().getElementById("form").submit();
  }
}

function menuReset()
{
  toolbars.reset();
  try {
    var objItem = objMenuBar.getActiveBarItem();
    if(objItem)
      objItem.reset();
  } catch(Error) {}
}

function tabEventPageLoaded(item,id)
{
  item.getWindow().initDialog("");
  var doc = item.getDocument();
  doc.onclick = function(){ menuReset(); };
}

function tabEventLoaded()
{
  return;
}

function toolbarCreate(objToolbars, id)
{

  toolbars = objToolbars;
	var imagePath = "design/image/style" + globalDesign + "/";

	//*******************************************************************************************************************************************
	//Toolbar 1
	//*******************************************************************************************************************************************
	var objToolbar1 = objToolbars.createToolbar();
	objToolbar1.action = "onToolbarButtonClick";
	objToolbar1.design = globalDesign;
	if(globalDesign < 3)
	  objToolbar1.border = true;
	else
	  objToolbar1.border = false;
	objToolbar1.height = 27;
  objToolbar1.add(objToolbars.createSeparator(imagePath + "tbbegin.gif"));
  objToolbar1.add(objToolbars.createButton("",imagePath + "new.gif","",getLanguageString(134),"NEW"));
	objToolbar1.add(objToolbars.createButton("",imagePath + "open.gif","",getLanguageString(104),"OPEN"));
	objToolbar1.add(objToolbars.createButton("",imagePath + "save.gif","",getLanguageString(105),"SAVE"));
	objToolbar1.add(objToolbars.createButton("",imagePath + "saveas.gif","",getLanguageString(106),"SAVEAS"));
	objToolbar1.add(objToolbars.createSeparator(imagePath + "tbend.gif"));
  objToolbar1.add(objToolbars.createDistance(3,true));
  objToolbar1.add(objToolbars.createSeparator(imagePath + "tbbegin.gif"));
	objToolbar1.add(objToolbars.createButton("",imagePath + "undo.gif","",getLanguageString(107),"UNDO"));
	objToolbar1.add(objToolbars.createButton("",imagePath + "redo.gif","",getLanguageString(108),"REDO"));
  objToolbar1.add(objToolbars.createSeparator(imagePath + "tbend.gif"));
	objToolbars.add(objToolbar1);

	//*******************************************************************************************************************************************
	//Toolbar 2
	//*******************************************************************************************************************************************
/*
  var objToolbar2 = objToolbars.createToolbar();
	objToolbar2.action = "onToolbarButtonClick";
	objToolbar2.design = globalDesign;
	objToolbar2.border = false;
	objToolbar2.height = 27;
*/

  objToolbar1.add(objToolbars.createDistance(3,true));
  objToolbar1.add(objToolbars.createSeparator(imagePath + "tbbegin.gif"));
  objToolbar1.add(objToolbars.createButton("",imagePath + "newelement.gif","",getLanguageString(110),"INSERTELEMENT"));
	objToolbar1.add(objToolbars.createButton("",imagePath + "newclass.gif","",getLanguageString(109),"INSERTCLASS"));
	objToolbar1.add(objToolbars.createButton("",imagePath + "newid.gif","",getLanguageString(111),"INSERTID"));
	objToolbar1.add(objToolbars.createSeparator(imagePath + "tbend.gif"));
	objToolbar1.add(objToolbars.createDistance(3,true));

  objToolbar1.add(objToolbars.createSeparator(imagePath + "tbbegin.gif"));
  btnBold = objToolbars.createButton("",imagePath + "bold.gif","",getLanguageString(112),"BOLD");
	objToolbar1.add(btnBold);
	btnItalic = objToolbars.createButton("",imagePath + "italic.gif","",getLanguageString(113),"ITALIC");
	objToolbar1.add(btnItalic);
	btnUnderline = objToolbars.createButton("",imagePath + "underline.gif","",getLanguageString(114),"UNDERLINE");
	objToolbar1.add(btnUnderline);

  objToolbar1.add(objToolbars.createSeparator(imagePath + "separator.gif"));
	objToolbar1.add(objToolbars.createDistance(5,false));

	cmbFont = objToolbars.createStyleCombo("onFontComboChanged",getLanguageString(115),"");
	cmbFont.width = "114";
	cmbFont.popupwidth = "130";
	cmbFont.popupheight = "";
	cmbFont.displayValue = "value";
	cmbFont.add(objToolbars.createStyleComboItem("<FONT unselectable='ON' face='Arial'>-</font>","","","-"));
	cmbFont.add(objToolbars.createStyleComboItem("<FONT unselectable='ON' face='Arial'>Arial</font>","","","Arial"));
	cmbFont.add(objToolbars.createStyleComboItem("<FONT unselectable='ON' face='Arial Black'>Arial Black</font>","","","Arial Black"));
	cmbFont.add(objToolbars.createStyleComboItem("<FONT unselectable='ON' face='Courier'>Courier</font>","","","Courier"));
	cmbFont.add(objToolbars.createStyleComboItem("<FONT unselectable='ON' face='Courier New'>Courier New</font>","","","Courier New"));
	cmbFont.add(objToolbars.createStyleComboItem("<FONT unselectable='ON' face='Georgia'>Georgia</font>","","","Georgia"));
	cmbFont.add(objToolbars.createStyleComboItem("<FONT unselectable='ON' face='Impact'>Impact</font>","","","Impact"));
	cmbFont.add(objToolbars.createStyleComboItem("<FONT unselectable='ON' face='Lucida Console'>Lucida&nbsp;Console</font>","","","Lucida Console"));
	cmbFont.add(objToolbars.createStyleComboItem("<FONT unselectable='ON' face='Tahoma'>Tahoma</font>","","","Tahoma"));
	cmbFont.add(objToolbars.createStyleComboItem("<FONT unselectable='ON' face='Times New Roman'>Times New Roman</font>","","","Times New Roman"));
	cmbFont.add(objToolbars.createStyleComboItem("<FONT unselectable='ON' face='Verdana'>Verdana</font>","","","Verdana"));
	objToolbar1.add(cmbFont);

  objToolbar1.add(objToolbars.createDistance(5,false));

	globalFontSizeType = "px";
	cmbFontSize = objToolbars.createStyleCombo("onFontSizeComboChanged",getLanguageString(116) + " (" + globalFontSizeType + ")","");
	cmbFontSize.width = "35";
	cmbFontSize.popupwidth = "90";
	cmbFontSize.popupheight = "180";
	cmbFontSize.displayValue = "tag1";
	cmbFontSize.add(objToolbars.createStyleComboItem("<span unselectable='ON' style='font-family:Arial;font-size: 10" + globalFontSizeType + "'>-</span>","","","-","-"));
	cmbFontSize.add(objToolbars.createStyleComboItem("<span unselectable='ON' style='font-family:Arial;font-size: 8" + globalFontSizeType + "'>8</span>","","","8","8"));
	cmbFontSize.add(objToolbars.createStyleComboItem("<span unselectable='ON' style='font-family:Arial;font-size: 9" + globalFontSizeType + "'>9</span>","","","9","9"));
	cmbFontSize.add(objToolbars.createStyleComboItem("<span unselectable='ON' style='font-family:Arial;font-size: 10" + globalFontSizeType + "'>10</span>","","","10","10"));
	cmbFontSize.add(objToolbars.createStyleComboItem("<span unselectable='ON' style='font-family:Arial;font-size: 11" + globalFontSizeType + "'>11</span>","","","11","11"));
	cmbFontSize.add(objToolbars.createStyleComboItem("<span unselectable='ON' style='font-family:Arial;font-size: 12" + globalFontSizeType + "'>12</span>","","","12","12"));
	cmbFontSize.add(objToolbars.createStyleComboItem("<span unselectable='ON' style='font-family:Arial;font-size: 13" + globalFontSizeType + "'>13</span>","","","13","13"));
	cmbFontSize.add(objToolbars.createStyleComboItem("<span unselectable='ON' style='font-family:Arial;font-size: 14" + globalFontSizeType + "'>14</span>","","","14","14"));
	cmbFontSize.add(objToolbars.createStyleComboItem("<span unselectable='ON' style='font-family:Arial;font-size: 15" + globalFontSizeType + "'>15</span>","","","15","15"));
	cmbFontSize.add(objToolbars.createStyleComboItem("<span unselectable='ON' style='font-family:Arial;font-size: 16" + globalFontSizeType + "'>16</span>","","","16","16"));
	cmbFontSize.add(objToolbars.createStyleComboItem("<span unselectable='ON' style='font-family:Arial;font-size: 18" + globalFontSizeType + "'>18</span>","","","18","18"));
	cmbFontSize.add(objToolbars.createStyleComboItem("<span unselectable='ON' style='font-family:Arial;font-size: 20" + globalFontSizeType + "'>20</span>","","","20","20"));
	cmbFontSize.add(objToolbars.createStyleComboItem("<span unselectable='ON' style='font-family:Arial;font-size: 20" + globalFontSizeType + "'>22</span>","","","22","22"));
	cmbFontSize.add(objToolbars.createStyleComboItem("<span unselectable='ON' style='font-family:Arial;font-size: 24" + globalFontSizeType + "'>24</span>","","","24","24"));
	cmbFontSize.add(objToolbars.createStyleComboItem("<span unselectable='ON' style='font-family:Arial;font-size: 36" + globalFontSizeType + "'>36</span>","","","36","36"));
	cmbFontSize.add(objToolbars.createStyleComboItem("<span unselectable='ON' style='font-family:Arial;font-size: 48" + globalFontSizeType + "'>48</span>","","","48","48"));
	cmbFontSize.add(objToolbars.createStyleComboItem("<span unselectable='ON' style='font-family:Arial;font-size: 72" + globalFontSizeType + "'>72</span>","","","72","72"));
	objToolbar1.add(cmbFontSize);

  objToolbar1.add(objToolbars.createDistance(5,false));
	objToolbar1.add(objToolbars.createSeparator(imagePath + "separator.gif"));

	btnLeft = objToolbars.createButton("",imagePath + "left.gif","",getLanguageString(117),"JUSTIFYLEFT");
	objToolbar1.add(btnLeft);
	btnCenter = objToolbars.createButton("",imagePath + "center.gif","",getLanguageString(118),"JUSTIFYCENTER");
	objToolbar1.add(btnCenter);
	btnRight = objToolbars.createButton("",imagePath + "right.gif","",getLanguageString(119),"JUSTIFYRIGHT");
	objToolbar1.add(btnRight);
	btnFull = objToolbars.createButton("",imagePath + "block.gif","",getLanguageString(120),"JUSTIFYFULL");
	objToolbar1.add(btnFull);

	objToolbar1.add(objToolbars.createSeparator(imagePath + "separator.gif"));
	btnColor = objToolbars.createColorButton(imagePath + "color.gif",imagePath + "colorselect.gif","onChangeTextColor",getLanguageString(121),getLanguageString(122),"");
	objToolbar1.add(btnColor);
	btnBackColor = objToolbars.createColorButton(imagePath + "backcolor.gif",imagePath + "colorselect.gif","onChangeBackgroundColor",getLanguageString(123),getLanguageString(124),"");
	objToolbar1.add(btnBackColor);

  objToolbar1.add(objToolbars.createSeparator(imagePath + "/tbend.gif"));
//	objToolbars.add(objToolbar2);

	objToolbars.create();

}



function onToolbarButtonClick(id)
{
  var button = toolbars.getElementById(id);
	if (button.tag == "BOLD") (button.pressed == false) ? updateRule("font-weight", "bold"):updateRule("font-weight", "");
	if (button.tag == "ITALIC") (button.pressed == false) ? updateRule("font-style", "italic"):updateRule("font-style", "");
	if (button.tag == "UNDERLINE") (button.pressed == false) ? updateRule("text-decoration", "underline"):updateRule("text-decoration", "");

	if (button.tag == "JUSTIFYLEFT") (button.pressed == false) ? updateRule("text-align", "left"):updateRule("text-align", "");
	if (button.tag == "JUSTIFYCENTER") (button.pressed == false) ? updateRule("text-align", "center"):updateRule("text-align", "");
	if (button.tag == "JUSTIFYRIGHT") (button.pressed == false) ? updateRule("text-align", "right"):updateRule("text-align", "");
	if (button.tag == "JUSTIFYFULL") (button.pressed == false) ? updateRule("text-align", "justify"):updateRule("text-align", "");

  if(button.tag == "INSERTCLASS") createNewClass();
  if(button.tag == "INSERTELEMENT") createNewElement();
  if(button.tag == "INSERTID") createNewId();

	if(button.tag == "OPEN") openFile();

  if(button.tag == "NEW") createNewStyleSheet();

  if(button.tag == "UNDO") __undo();
  if(button.tag == "REDO") __redo();

	updateDesign();
	if (button.tag == "SAVE") 	saveCss();
	if (button.tag == "SAVEAS") saveCss("SAVEAS");
}

function openFile()
{
	dialogparams[0] = globalLanguage;
	dialogparams[1] = "1";
	dialogparams[2] = "OPEN";
	dialogparams[3] = "";
	dialogparams[4] = "";
	dialogparams[5] = "";
	dialogparams[6] = "";
	dialogparams[7] = "";
	dialogparams[8] = globalTechnology;
	dialogparams[9] = "css;";
	dialogparams[10] = "";
	dialogparams[11] = window;
	dialogparams[12] = "";
	dialogparams[13] = "";
	dialogparams[14] = __editLanguage;
	dialogparams[15] = "";
	dialogparams[16] = globalCssUrl;
	dialogparams[17] = globalCssPath;
	dialogparams[18] = "";
	dialogparams[19] = "";
	dialogparams[20] = "";
  try {
    if(browser.ns) {
      var left = screen.width/2 - 600/2;
      var top = screen.height/2 - 600/2;
      window.open("../dialogs/dialog.html","Open","modal=1,left=" + left + ",top=" + top + ",height=600,width=600,resizable=0,status=0,scrollbars=0");
    } else {
  	  var path = window.showModalDialog("dialogs/dialog.html",dialogparams,"dialogHeight:600px;dialogWidth:600px;resizable:1;status:0;scroll:0");
      eval("__callback_open('" + path + "')");
    }
  } catch(Error) { if (debug == true) alert(Error); }
}

function __editGetParam()
{
  	return dialogparams;
}

function __callback_open(path)
{
  try {
    var i = path.length-1;
    while(i>0) {
      if(path.substring(i,i+1) == "/")
        break;
      i--;
    }
    if(path != 0) {
      globalCssPath = path.substring(0,i+1);
      globalCssFile = path.substring(i+1);;
   if(browser.ns)
     setTimeout("readCss()","500");
else
readCss();

    }
  } catch(Error) {}
}

function callbackMozilla(type, ret)
{
  if (type == "OPENDOC")
    __callback_open(ret);
  if (type == "SAVEDOC")
    __callback_save(ret);
}

function onFontComboChanged(id)
{
  var menu = toolbars.getElementById(id);
	updateRule("font-family", menu.selectedItem.value);
	updateDesign();
}

function onFontSizeComboChanged(id)
{
  var menu = toolbars.getElementById(id);
	updateRule("font-size", menu.selectedItem.value+"px");
	updateDesign();
}

function onChangeTextColor(id)
{
  try {
    var button = toolbars.getElementById(id);
  	updateRule("color", button.color);
  	updateDesign();
  } catch(Error) { if (debug == true) alert(Error); }
}

function onChangeBackgroundColor(id)
{
  try {
    var button = toolbars.getElementById(id);
  	updateRule("background-color", button.color);
  	updateDesign();
  } catch(Error) { if (debug == true) alert(Error); }
}

function createNewClass()
{
  try {
   	var imagePath = "../toolbar/design/image/style" + globalDesign + "/newclass.gif";
  	var node = tree.getNodeByKey("class");
  	var newNode = tree.createNode(getLanguageString(128),getLanguageString(129),imagePath,"",false);

  	node.addNew(newNode);
  } catch(Error) { if (debug == true) alert(Error); }
}

function createNewElement()
{
  try {
   	var imagePath = "../toolbar/design/image/style" + globalDesign + "/newelement.gif";
  	var node = tree.getNodeByKey("elements");
  	var newNode = tree.createNode(getLanguageString(130),getLanguageString(131),imagePath,"",false);

  	node.addNew(newNode);
  } catch(Error) { if (debug == true) alert(Error); }
}

function createNewId()
{
  try {
   	var imagePath = "../toolbar/design/image/style" + globalDesign + "/newid.gif";
  	var node = tree.getNodeByKey("ids");
  	var newNode = tree.createNode(getLanguageString(132),getLanguageString(133),imagePath,"",false);

  	node.addNew(newNode);
  } catch(Error) { if (debug == true) alert(Error); }
}

function createNewStyleSheet()
{
  try {
    globalCssFile = "";
    styleSheet = null;
    styleSheet = new StyleSheet();
    tree.clear();

    // create first node and expand
    var node0 = tree.createNode(getLanguageString(101),"elements","","",true);
    node0.enabled = false;
    tree.add(node0);

    var node1 = tree.createNode(getLanguageString(102),"class","","",true);
    node1.enabled = false;
    tree.add(node1);

    var node2 = tree.createNode(getLanguageString(103),"ids","","",true);
    node2.enabled = false;
    tree.add(node2);

    tree.create();
    deleteSinglePreview();
  	setToolbarStatus();
    updateDesign();
    updatePreview();
    window.setTimeout("updateCode()", 50);

  } catch(Error) { if (debug == true) alert(Error); }


}

function updateRule(style, value)
{
  try {
  	var node = tree.getSelectedNode();
  	var rule = styleSheet.getRuleByName(node.key);

  	if (style.length > 0 && value.length > 0) {
  	  rule.updateStyle(style, value);
    } else if (value.length == 0) {
      rule.deleteStyle(style);
    }

    var cssFrame = document.getElementById("preview");

    //update element of preview
    if (rule.type == "class")
      name = "class_" + node.key.substr(1)
    else
      name = node.key.substr(1)
    //end

    updateSinglePreview();
  	setToolbarStatus();
  	setPointer();

  	cssFrame.contentWindow.document.getElementById(name).style.cssText = rule.cssText();

  } catch(Error) { if (debug == true) alert(Error); }
}

function setToolbarStatus()
{
  try{
  	var node = tree.getSelectedNode();
  	var rule = styleSheet.getRuleByName(node.key);
  	var name = node.key;
  	var cssText = rule.cssText();
  	var actStyles = rule.getStyles();

  	btnBold.setStatus(false);
  	btnItalic.setStatus(false);
  	btnUnderline.setStatus(false);
  	btnLeft.setStatus(false);
  	btnCenter.setStatus(false);
  	btnRight.setStatus(false);
  	btnFull.setStatus(false);
  	cmbFontSize.setSelectedText("-");
  	cmbFont.setSelectedText("-");
  	btnColor.setColor("");
  	btnBackColor.setColor("");

  	for(var i=0;i<actStyles.length;i++) {
  		if(actStyles[i].name.toLowerCase() == "font-weight") {
  			(actStyles[i].value.toLowerCase() == "bold") ? btnBold.setStatus(true):btnBold.setStatus(false);
  		}
  		if(actStyles[i].name.toLowerCase() == "font-style") {
  			(actStyles[i].value.toLowerCase() == "italic") ? btnItalic.setStatus(true):btnItalic.setStatus(false);
  		}
  		if(actStyles[i].name.toLowerCase() == "text-decoration") {
  			(actStyles[i].value.toLowerCase().indexOf("underline") > -1)?btnUnderline.setStatus(true):btnUnderline.setStatus(false);
  		}
  		if(actStyles[i].name.toLowerCase() == "text-align") {
  			(actStyles[i].value.toLowerCase() == "left") ? btnLeft.setStatus(true):btnLeft.setStatus(false);
  			(actStyles[i].value.toLowerCase() == "center") ? btnCenter.setStatus(true):btnCenter.setStatus(false);
  			(actStyles[i].value.toLowerCase() == "right") ? btnRight.setStatus(true):btnRight.setStatus(false);
  			(actStyles[i].value.toLowerCase() == "justify") ? btnFull.setStatus(true):btnFull.setStatus(false);
  		}
  		if(actStyles[i].name.toLowerCase() == "font-size") {
  			(actStyles[i].value.length > 0)?cmbFontSize.setSelectedText(parseInt(actStyles[i].value)):cmbFontSize.setSelectedText("-");
  		}
  		if(actStyles[i].name.toLowerCase() == "font-family") {
  			(actStyles[i].value.length > 0)?cmbFont.setSelectedText(actStyles[i].value):cmbFont.setSelectedText("-");
  		}
  		if(actStyles[i].name.toLowerCase() == "color") {
  			(actStyles[i].value.length > 0)?btnColor.setColor(actStyles[i].value):btnColor.setColor("");
  		}
  		if(actStyles[i].name.toLowerCase() == "background-color") {
  			(actStyles[i].value.length > 0)?btnBackColor.setColor(actStyles[i].value):btnBackColor.setColor("");
  		}
  	}

  } catch(Error) { if (debug == true) alert(Error); }
}

function onNodeClick(node)
{
  try {
    if(node.tag == "SPECIAL")
      return;

    updateSinglePreview();
  	setToolbarStatus();
    updateDesign();
  } catch(Error) { if (debug == true) alert(Error); }
}

function onAfterNodeEdit(oldText, newText)
{
  try {
  	var node = tree.getSelectedNode();
  	var type = node.parentNode;

  	if(type.key == "class") {
      if(newText.substr(0,1) != ".") {
    		newText = "." + newText;
      }
  	} else if (type.key == "ids") {
      if(newText.substr(0,1) != "#") {
    		newText = "#" + newText;
      }
  	}

  	node.key = newText.toLowerCase();
  	node.setText(newText);

  	styleSheet.renameRule(oldText, newText);
    updatePreview();
    window.setTimeout("updateCode()", 50);
  } catch(Error) { if (debug == true) alert(Error); }
}

function onAfterNodeAdd(newNode)
{
  try {
    var newRule = null;
    var ruleType = "";
    var ruleName = "";
    var newName = "";
    ruleName = newNode.text;

    if(newNode.parentNode.key == "elements") {
      ruleType = "element";
    } else if(newNode.parentNode.key == "class") {
      ruleType = "class";
      ruleName.substr(0,1) != "." ? ruleName = "." + ruleName : null;
    } else if(newNode.parentNode.key == "ids") {
      ruleType = "id";
      ruleName.substr(0,1) != "#" ? ruleName = "#" + ruleName : null;
    }

    while (newName == "") {
      if (styleSheet.ruleExist(ruleName) == true) {
        ruleName = ruleName + getLanguageString(135);
      } else {
        newName = ruleName;
      }
    }

    newRule = new Rule(ruleName, ruleType);
    newNode.setText(ruleName);
    newNode.key = ruleName.toLowerCase();
  	styleSheet.addRule(newRule);

    deleteSinglePreview();
  	setToolbarStatus();
    updateDesign();
    updatePreview();
    window.setTimeout("updateCode()", 50);
  } catch(Error) { if (debug == true) alert(Error); }
}

function onAfterNodeRemove(node)
{
  try {
    styleSheet.deleteRule(node.key);
    updateDesign();
    updatePreview();
  } catch(Error) { if (debug == true) alert(Error); }

}

function onBeforeNodeRemove(node)
{
  return;
}

function saveCss(type)
{
  try {
    if (type == "SAVEAS" || globalCssFile.length == 0) {
    	dialogparams[0] = globalLanguage;
    	dialogparams[1] = "1";
    	dialogparams[2] = "SAVE";
    	dialogparams[3] = "";
    	dialogparams[4] = "";
    	dialogparams[5] = "";
    	dialogparams[6] = "";
    	dialogparams[7] = "";
    	dialogparams[8] = globalTechnology;
    	dialogparams[9] = "css;";
    	dialogparams[10] = "";
    	dialogparams[11] = window;
    	dialogparams[12] = "";
    	dialogparams[13] = "";
    	dialogparams[14] = __editLanguage;
    	dialogparams[15] = "";
    	dialogparams[16] = globalCssUrl;
    	dialogparams[17] = globalCssPath;
    	dialogparams[18] = "";
    	dialogparams[19] = "";
    	dialogparams[20] = "";
    	
      try {
        if(browser.ns) {
          var left = screen.width/2 - 600/2;
          var top = screen.height/2 - 600/2;
          window.open("../dialogs/dialog.html","Open","modal=1,left=" + left + ",top=" + top + ",height=600,width=600,resizable=0,status=0,scrollbars=0");
        } else {
      	  var path = window.showModalDialog("dialogs/dialog.html",dialogparams,"dialogHeight:600px;dialogWidth:600px;resizable:1;status:0;scroll:0");
          eval("__callback_save('" + path + "')");
        }
      } catch(Error) { if (debug == true) alert(Error); }


    } else {
      if(browser.ns)
      	setTimeout("__save_ajax()","500");
      else
        __save_ajax();
      Ajax.method = "POST";
    }
  } catch(Error) { if (debug == true) alert(Error); }
}

function __callback_save(path)
{
  try {
    var i = path.length-1;
    while(i>0) {
      if(path.substring(i,i+1) == "/")
        break;
      i--;
    }
    globalCssPath = path.substring(0,i+1);
    globalCssFile = path.substring(i+1);
    
    if(browser.ns)
    	setTimeout("__save_ajax()","500");
    else
      __save_ajax();

  } catch(Error) {}
}

function __save_ajax()
{
  Ajax.method = "POST";
	var aParams = new Array();
	aParams[0] = new Pair("path",globalCssPath + globalCssFile);
	aParams[1] = new Pair("key","write");
	aParams[2] = new Pair("css",styleSheet.cssText("structured"));
  Ajax.request("adapter/adapter." + globalTechnology,aParams);
}

function treeCreate(objTree,id)
{
  try {
  	var red = "rgb(176,8,95)";
    var imagePath = "design/image/style" + design + "/";

  	tree                 = objTree;
  	//tree.backcolor       = "#ECE9D8"

  	tree.font            = "Arial"
  	tree.fontSize        = "8pt";
  	tree.marginLeft      = 3;
  	tree.marginTop       = 3;

  	tree.onNodeClick         = "onNodeClick";
  	tree.onBeforeNodeRemove  = "onBeforeNodeRemove";
  	tree.onAfterNodeRemove   = "onAfterNodeRemove";
  	tree.onAfterNodeEdit     = "onAfterNodeEdit";
    tree.onAfterNodeCopy     = "onAfterNodeCopy";
    tree.onAfterNodePaste    = "onAfterNodePaste";
    tree.onAfterNodeAdd      = "onAfterNodeAdd";
  	tree.onContextMenuCreate = "onContextMenuCreate";
  	tree.onContextMenuClick  = "onContextMenuClick";

  	tree.showTreeLines   = false;
  	tree.enableInlineEditing   = true;
  	tree.enableCopy      = true;
  	tree.enableDrag      = false;
  	tree.showLines       = false;
  	tree.enableContext   = true;

  	tree.setDesign(2);
  	tree.setMenuDesign(globalMenuDesign);

    // create first node and expand
    var node0 = tree.createNode(getLanguageString(101),"elements",imagePath+"element.gif","SPECIAL",true);
    //node0.enabled   = false;
    node0.canRemove = false;
    node0.canEdit = false;
    tree.add(node0);

    var node1 = tree.createNode(getLanguageString(102),"class",imagePath+"class.gif","SPECIAL",true);
    //node1.enabled = false;
    node1.canRemove = false;
    node1.canEdit = false;
    tree.add(node1);

    var node2 = tree.createNode(getLanguageString(103),"ids",imagePath+"id.gif","SPECIAL",true);
    //node2.enabled = false;
    node2.canRemove = false;
    node2.canEdit = false;
    tree.add(node2);

    tree.create();
  } catch(Error) { if (debug == true) alert(Error); }
}



function init()
{
  try {
    setStrings();
    globalCssUrl     = getURLParam("url");
    globalCssPath    = getURLParam("path");
    globalCssFile    = getURLParam("file");
    globalTechnology = getURLParam("tech");

    createMenu();
    objPreview = document.getElementById("singlePreview");
    parentObjPreview = document.getElementById("parentSinglePreview");
    if(globalCssPath != "" && globalCssFile != "") {
  	  readCss();
    }
    document.getElementById("preview").contentWindow.document.onclick = function(){ menuReset(); };
  } catch(Error) { if (debug == true) alert(Error); }
}


function readCss()
{
  try {
    setStatus(getLanguageString(2000), "black");
    Ajax.method = "POST";
    Ajax.callback = __callback;
  	var aParams = new Array();
  	aParams[0] = new Pair("path",globalCssPath + globalCssFile);
  	aParams[1] = new Pair("key","read");
    Ajax.request("adapter/adapter." + globalTechnology,aParams);
  } catch(Error) { if (debug == true) alert(Error); }
}

function __callback()
{
  try {
    if (Ajax.text.length > 0) {
    	parseCss(Ajax.text);
    	updateTree();
    	updatePreview();
    	setPointer();
    	window.setTimeout("updateCode()", 500);
    	setStatus(1,getLanguageString(2001) + globalCssFile);
    }
  } catch(Error) { if (debug == true) alert(Error); }
}

function updateCode()
{
  try {
	  var doc = tabCode.getDocument().getElementById('code').contentWindow.document;
	  doc.body.innerHTML = styleSheet.cssText("formatted");
    window.setTimeout("setCodeWindowEditable()", 200);
  } catch(Error) {}
}

function setStatus(which, text, color)
{
  var objStatus = document.getElementById("status");
  var objStatus2 = document.getElementById("status2");

  if(which == 1) {
    objStatus.innerHTML = text;
    objStatus.style.color = color;
  }
  if(which == 2) {
    objStatus2.innerHTML = text;
    objStatus2.style.color = color;
  }
}


function parseCss(text)
{
  try {
  	text = text.replace(/\r/gi,"");
  	text = text.replace(/\n/gi,"");
  	text = text.replace(/\t/gi,"");

    //Kommentare löschen
    text = text.replace(/\/\*[^\/]+\//gi,"");

    //Eventuelle Tags löschen
    text = text.replace(/<[^>]+>/gi,"");

    //&nbsp; durch normale Leerzeichen ersetzen
    text = text.replace(/&nbsp;/gi," ");

  	var split1 = new Array();
  	var split2 = new Array();
  	var split3 = new Array();
  	var split4 = new Array();
  	var newRule = null;
  	var newStyle = null;
  	var ruleType = "";
  	var ruleName = "";

    //StyleSheet löschen, wenn bereits eines vorhanden ist.
    if (styleSheet != null) styleSheet = new StyleSheet();

  	split1 = text.split("}");
  	for (var i=0;i<split1.length;i++) {
  		if (split1[i].length > 0) {
  			split2 = split1[i].split("{");
        ruleName = split2[0].trim();

        //Ermitteln des Typs
  			if(ruleName.substr(0,1) == ".") {
          ruleType = "class";
  			} else if(ruleName.substr(0,1) == "#") {
          ruleType = "id";
        } else {
          ruleType = "element";
        }

  			newRule = new Rule(ruleName, ruleType);

        if (split2[1].indexOf(";") > -1) {
  			  split3 = split2[1].split(";");
        } else {
          split3[0] = split2[1];
        }

  			for (var y=0;y<split3.length;y++) {
  				if (split3[y].trim().length > 0) {
  					split4 = split3[y].split(":");
  					newStyle = new Style(split4[0].trim(), split4[1].trim());
  					newRule.addStyle(newStyle);
  				}
  			}
  			styleSheet.addRule(newRule);
  		}
  	}

  } catch(Error) { if (debug == true) alert(Error); }
}

function updatePreview()
{
  try {
  	var style = composeCss();
  	var content = composePreviewContent();

  	var cssFrame = document.getElementById("preview");
  	cssFrame.contentWindow.document.open();
  	cssFrame.contentWindow.document.write('<html><head><style>'+style+'</style></head><body>'+content+'</body></html>');
  	cssFrame.contentWindow.document.close();
  	cssFrame.contentWindow.document.onclick = function(){ menuReset(); };
  } catch(Error) { if (debug == true) alert(Error); }
}

function composeCss()
{
  try {
  	var css = styleSheet.getClasses();
  	var ids = styleSheet.getIds();
  	var text = "";
  	var cssText = "";

  	for (var i=0; i<css.length;i++) {
  		rule = css[i].name;
  		cssText = css[i].cssText(true);
  		text = text + rule + "\n\t{" + cssText + "}\n";
  	}
  	for (var i=0; i<ids.length;i++) {
  		rule = ids[i].name;
  		cssText = ids[i].cssText(true);
  		text = text + rule + "\n\t{" + cssText + "}\n";
  	}
  	return text;
  } catch(Error) { if (debug == true) alert(Error); }
}

function updateDesign()
{
	try {
		//update the design item

		var items = tabDesign.getWindow().getItems();
    var node = tree.getSelectedNode();
		var rule = styleSheet.getRuleByName(node.key);

    for (var i=0;i<items.length;i++)
		{

      items[i].getWindow().updateDesign(rule);

    }
	} catch(Error) { if (debug == true) alert(Error); }
}

function update()
{
  //function is called from character, shade, ... items
  updateSinglePreview();
}

function updateSinglePreview()
{
  try {
  	var node = tree.getSelectedNode();
  	var rule = styleSheet.getRuleByName(node.key);
  	var name = node.key;
  	var cssText = rule.cssText(true);

  	objPreview.style.cssText = "";

    name = name.toLowerCase();
    if (name.indexOf(",") > 0) {
      temp = name.split(",");
      obj = temp[0].trim();
    } else {
      if (name.indexOf(" ") > 0) {
        temp = name.split(" ");
        obj = temp[0].trim();
      } else {
        obj = name.trim();
      }
    }

    if (obj.indexOf("input") > -1 ) {
      parentObjPreview.innerHTML = '<input type="text" id="singlePreview" value="Textfield" style="'+cssText+'">';
    } else if(obj.indexOf("button") > -1 ) {
      parentObjPreview.innerHTML = '<input type="button" id="singlePreview" value="Button" style="'+cssText+'">';
    } else {
      parentObjPreview.innerHTML = '<div id="singlePreview" style="width:100%; height:100%; '+cssText+'">'+getLanguageString(136)+'</div>';
    }

    objPreview = document.getElementById("singlePreview");
  } catch(Error) { if (debug == true) alert(Error); }
}

function deleteSinglePreview()
{
  parentObjPreview.innerHTML = '<div id="singlePreview" style="width:100%; height:100%;">'+getLanguageString(136)+'</div>';
  objPreview = document.getElementById("singlePreview");
}

function composePreviewContent()
{
  try {
  	var classes = styleSheet.getClasses();
  	var ids = styleSheet.getIds();
  	var text = "<table border='0' width='100%'>";


  	for (var i=0; i<classes.length;i++) {
  		rule = classes[i].name;
  		text = text + '<tr><td><div id="class_'+rule.substr(1)+'" class="'+rule.substr(1)+'">' + rule.substr(1) + '</div></td></tr>';
  	}
  	for (var i=0; i<ids.length;i++) {
  		rule = ids[i].name;
    	text = text + '<tr><td><div id="'+rule.substr(1)+'">' + rule.substr(1) + '</div></td></tr>';
  	}

  	return text + "</table>";
  } catch(Error) { if (debug == true) alert(Error); }
}

var __comm;
var __data;

function Comm(url)
{
  this.url = url;
}

function Pair(key, value)
{
  this.key = key;
  this.value = value;
}

function updateTree()
{
  try {
    tree.clear();

   	var imagePath = "../toolbar/design/image/style" + globalDesign + "/";

    // create first node and expand
    var node0 = tree.createNode(getLanguageString(101),"elements","","",true);
    node0.canRemove = false;
    node0.canEdit = false;
    tree.add(node0);

    var node1 = tree.createNode(getLanguageString(102),"class","","",true);
    node1.canRemove = false;
    node1.canEdit = false;
    tree.add(node1);

    var node2 = tree.createNode(getLanguageString(103),"ids","","",true);
    node2.canRemove = false;
    node2.canEdit = false;
    tree.add(node2);

  	var classes = tree.getNodeByKey("class");
  	var elements = tree.getNodeByKey("elements");
  	var ids = tree.getNodeByKey("ids");
  	var rule = "";
  	var text = "";
  	var newNode = null;
  	var css = styleSheet.getRules();

  	for (var i=0;i<css.length;i++) {
  		rule = css[i].name;
  		text = css[i].cssText;

  		if(rule.substring(0,1) == ".") {
  			newNode = tree.createNode(rule,rule.toLowerCase(),imagePath + "newclass.gif","",false);
  			classes.add(newNode);
  		} else if(rule.substring(0,1) == "#") {
  			newNode = tree.createNode(rule,rule.toLowerCase(),imagePath + "newid.gif","",false);
  			ids.add(newNode);
  		}	else {
  			newNode = tree.createNode(rule,rule.toLowerCase(),imagePath + "newelement.gif","",false);
  			elements.add(newNode);
  		}

  	}
  	classes.expanded = true;
  	elements.expanded = true;
  	ids.expanded = true;
  	tree.create();
  } catch(Error) { if (debug == true) alert(Error); }
}

function __undo()
{
  if(pointer > 0) {
    if (undo[pointer].length > 0) {
      pointer--;
      parseCss(undo[pointer]);
    	updateTree();
    	updatePreview();
    }
  }
}

function __redo()
{
  if (pointer < 9) {
    pointer++;
    parseCss(undo[pointer]);
  	updateTree();
  	updatePreview();
  }
}

function setPointer()
{
  if(pointer == 9) {
    var temp = styleSheet.cssText("structured");
    undo.shift();
    undo[9] = temp;
  }
  if (pointer > -1 && pointer < 9) {
    pointer++;
    var temp = styleSheet.cssText("structured");
    undo[pointer] = temp;
  }
}

<% 
  out.flush(); 
  pinStyle ps = new pinStyle();
  ps.create(response,request.getParameter("t")); 
%>

</html>
