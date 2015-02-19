
// those variables are needed in toolbar button click events
var toolbarsTop    = null;
var toolbarsBottom = null;
var toolbarsLeft   = null;
var editStatusBar  = null;

// the toolbar design (3 == default)
var tbdesign = "3";
var border = false;
  
// image path
var imagePath = "";

// these buttons are needed to update state quickly after mouse click or key press in editor
var btnBold = null;
var btnItalic = null;
var btnUnderline = null;
var btnSuperscript = null;
var btnSubscript = null;
var btnJustifyLeft = null;
var btnJustifyCenter = null;
var btnJustifyRight = null;
var btnJustifyFull = null;
var btnInsertOrderedList = null;
var btnInsertUnorderedList = null;
var btnColor = null;
var btnBackColor = null;
var btnStrike = null;

// those combos are needed to update content after mouse click or key press in editor
var cmbStyle = null;
var cmbFormat = null;
var cmbFont = null;
var cmbFontSize = null;

// table buttons
var btnRowB = null;
var btnRowA = null;
var btnRowDelete = null;
var btnColB = null;
var btnColA = null;
var btnColDelete = null;
var btnCellDelete = null;
var btnCellAdd = null;
var btnColSpan = null;
var btnCellDivide = null;
var btnRowSpan = null;
var btnCellConvert = null;
var btnCellProp = null;
var btnTableProp = null;

//---------------------------------------------------------------------------------------------
// Toolbar events
//---------------------------------------------------------------------------------------------
// objToolbars: root object of toolbar
// id:          id of IFRAME where the toolbar runs ( needed of there a re multiple objects)
//---------------------------------------------------------------------------------------------
function toolbarCreate(objToolbars, id)
{
  var xmlDoc = null;
  var aXMLToolbar = new Array();

  if(browser.ie) {
    xmlDoc = document.createElement("xml");
    document.appendChild(xmlDoc);
    xmlDoc.loadXML(__editToolbarXMLString);
  } else {
    //create a DOMParser
    var objDOMParser = new DOMParser();
    //create new document from string
    xmlDoc = objDOMParser.parseFromString(__editToolbarXMLString, "text/xml");
  }
  
  tbdesign = design;  
  if(design == "1") {
    border = true;
  }
  if(design == "2") {
    border = true;
  }
  
  imagePath   = globalEditorImagesFolder;
  var toolbarPath = __editGetEditorUrl() + "toolbar/design/style" + design + "/";

  var hasTop    = false;
  var hasBottom = false;
  var hasLeft   = false;
  var hasTM     = false;
  var hasEdit   = false;
  var config    = "";

  objToolbars.backcolor = globalToolbarColor;
  objToolbars.language = language;

	// which toolbar do we have
	if(id == "toolbar_top") {
    toolbarsTop = objToolbars;

    var toolbars = xmlDoc.getElementsByTagName("toolbar");
    var found = false;
    for(var i=0;i<toolbars.length;i++) {
      var toolbar = toolbars[i];
      if(toolbar.getAttribute("position") == "top") {
        aXMLToolbar[aXMLToolbar.length] = toolbar;
        found = true;
      }
    }
    if(!found) {
      document.getElementById(id).style.height = 0;
    }
  }

	// which toolbar do we have
	if(id == "toolbar_bottom") {
    toolbarsBottom = objToolbars;
    var toolbars = xmlDoc.getElementsByTagName("toolbar");
    var found = false;
    for(var i=0;i<toolbars.length;i++) {
      var toolbar = toolbars[i];
      if(toolbar.getAttribute("position") == "bottom") {
        aXMLToolbar[aXMLToolbar.length] = toolbar;
        found = true;
      }
    }
    if(!found) {
      document.getElementById(id).style.height = 0;
    }
  }

	// which toolbar do we have
  if(globalSideBarVisible) {
	  if(id == "windowLeft") {
      toolbarsLeft = objToolbars;
      toolbarsLeft.orientation = "V";
      toolbarsLeft = objToolbars;
      var toolbars = xmlDoc.getElementsByTagName("toolbar");
      var found = false;
      for(var i=0;i<toolbars.length;i++) {
        var toolbar = toolbars[i];
        if(toolbar.getAttribute("position") == "left") {
          aXMLToolbar[aXMLToolbar.length] = toolbar;
        }
      }
    }
  }

	if(id != "windowLeft") {
	  var faktor = 1;
	  if(design == "5")
	    faktor = 30;
	  else
	    faktor = 29;
    // set height of toolbars  
    document.getElementById(id).style.height = aXMLToolbar.length * faktor - 1;
  }

  try {
    for(var i=0;i<aXMLToolbar.length;i++) {
      var objToolbar = objToolbars.createToolbar();
      objToolbar.design = tbdesign;
      objToolbar.border = border;
      //objToolbar.height = 24;
      objToolbar.action = "onToolbarButtonClick";
      
		  // now get items
      for(var j=0;j<aXMLToolbar[i].childNodes.length;j++) {
        var curNode = aXMLToolbar[i].childNodes[j];
        if(curNode.tagName == "regionstart") {
          if(objToolbars.orientation == "V")
     		    objToolbar.add(objToolbars.createSeparator(toolbarPath + "tbbeginv.gif"));
     		  else
     		    objToolbar.add(objToolbars.createSeparator(toolbarPath + "tbbegin.gif"));
        }
        if(curNode.tagName == "regionend") {
     		  objToolbar.add(objToolbars.createSeparator(toolbarPath + "tbend.gif"));
        }
        if(curNode.tagName == "separator") {
     		  objToolbar.add(objToolbars.createSeparator(toolbarPath + "separator.gif",true));
        }
        if(curNode.tagName == "distance") {
          var width = curNode.getAttribute("width");
          width = width ? width:3;
          var background = curNode.getAttribute("background");
          background = background ? true:false;
  			  objToolbar.add(objToolbars.createDistance(width,background));
        }
        // add button
        if(curNode.tagName == "button") {
          var image = curNode.getAttribute("image");
          if(image)
            image = imagePath + image;
          var imageDisabled = curNode.getAttribute("imagedisabled");
          var textid = curNode.getAttribute("textid");
          var text   = curNode.getAttribute("text");
          text = text ? text : (textid ? getLanguageString(language,textid): "");
          var tooltipid = curNode.getAttribute("tooltipid");
          var tooltip   = curNode.getAttribute("tooltip");
          var callback = curNode.getAttribute("callback");
          var enabled = curNode.getAttribute("enabled");
          enabled = enabled ? false:true;
          var tag         = curNode.getAttribute("tag");
          tag = tag ? tag : "";
          var objButton = objToolbars.createButton(text,image,"",tooltip ? tooltip : getLanguageString(language,tooltipid),tag);    
          if(callback)
            objButton.callback = callback;
          if(imageDisabled)
            objButton.imageDisabled = imagePath + imageDisabled;
          if(!enabled)
            objButton.enabled = false;
          if(tag == "BOLD")              btnBold = objButton;
          if(tag == "ITALIC")            btnItalic = objButton;
          if(tag == "UNDERLINE")         btnUnderline = objButton;
          if(tag == "STRIKE")            btnStrike = objButton;
          if(tag == "SUPERSCRIPT")       btnSuperscript = objButton;
          if(tag == "SUBSCRIPT")         btnSubscript = objButton;
          if(tag == "JUSTIFYLEFT")       btnJustifyLeft = objButton;
          if(tag == "JUSTIFYCENTER")     btnJustifyCenter = objButton;
          if(tag == "JUSTIFYRIGHT")      btnJustifyRight = objButton;
          if(tag == "JUSTIFYFULL")       btnJustifyFull = objButton;
          if(tag == "INSERTORDEREDLIST") btnInsertOrderedList = objButton;
          if(tag == "INSERTUNORDEREDLIST") btnInsertUnorderedList = objButton;

          if(tag == "INSERTROWB") { 
            btnRowB = objButton;
          }
          if(tag == "INSERTROWA") btnRowA = objButton;
          if(tag == "DELETEROW")  btnRowDelete = objButton;
          if(tag == "INSERTCOLB") btnColB = objButton;
          if(tag == "INSERTCOLA") btnColA = objButton;
          if(tag == "DELETECOL")  btnColDelete = objButton;
          if(tag == "DELETECELL") btnCellAdd = objButton;
          if(tag == "COLSPAN")    btnColSpan = objButton;
          if(tag == "DIVIDECELL") btnCellDivide = objButton;
          if(tag == "ROWSPAN")    btnRowSpan = objButton;
          if(tag == "CONVERTROW") btnCellConvert = objButton;
          if(tag == "TD")         btnCellProp = objButton;
          if(tag == "TDTABLE")    btnTableProp = objButton;

     		  objToolbar.add(objButton);
        }
        // add check button
        if(curNode.tagName == "checkbutton") {
          var image = curNode.getAttribute("image");
          var imageDisabled = curNode.getAttribute("imagedisabled");
          var textid = curNode.getAttribute("textid");
          var text   = curNode.getAttribute("text");
          text = text ? text : (textid ? getLanguageString(language,textid): "");
          var tooltipid = curNode.getAttribute("tooltipid");
          var tooltip   = curNode.getAttribute("tooltip");
          var enabled = curNode.getAttribute("enabled");
          enabled = enabled ? false:true;
          var action = curNode.getAttribute("action");
          var group = curNode.getAttribute("group");
          group = group ? group : "";
          var tag = curNode.getAttribute("tag");
          tag = tag ? tag : "";
          var selected = curNode.getAttribute("selected");
          var callback = curNode.getAttribute("callback");
		      var objButton = objToolbars.createCheckButton(text,imagePath + image,"",tooltip ? tooltip : getLanguageString(language,tooltipid),tag,selected ? true:false,group);
          if(callback)
            objButton.callback = callback;
          if(imageDisabled)
            objButton.imageDisabled = imagePath + imageDisabled;
          if(!enabled)
            objButton.enabled = false;
     		  objToolbar.add(objButton);
        }

        // add menubutton
        if(curNode.tagName == "menubutton") {
          var image = curNode.getAttribute("image");
          var tooltipid = curNode.getAttribute("tooltipid");
          var tooltip   = curNode.getAttribute("tooltip");
          var update = curNode.getAttribute("update");
          update = update ? false:true;
          
          var popupwidth = curNode.getAttribute("popupwidth") != null ? curNode.getAttribute("popupwidth") : "";
   		    var objMenuButton = objToolbars.createMenuButton("",imagePath + image,imagePath + "selector.gif","__onMenuButtonClick",tooltip ? tooltip : getLanguageString(language,tooltipid),tooltip ? tooltip : getLanguageString(language,tooltipid));
  		    objMenuButton.popupwidth = popupwidth;
  		    if(!update)
  		      objMenuButton.update = false;
          var aItems = curNode.getElementsByTagName("*");
          for(var k=0;k<aItems.length;k++) {
  		      var curListItem = aItems[k];
            if(curListItem.nodeName.toLowerCase() == "listitem") {
              var image = curListItem.getAttribute("image");
              var textid = curListItem.getAttribute("textid");
              var text   = curListItem.getAttribute("text");
              var value  = curListItem.getAttribute("value");
              value = value ? value : "";
              var callback = curListItem.getAttribute("callback");
              callback = callback ? callback : "";
  		        var objMenuButtonItem = objToolbars.createMenuItem(text ? text : getLanguageString(language,textid),imagePath + image,"",value,"");
  		        objMenuButtonItem.tag2 = callback;
  		        objMenuButton.add(objMenuButtonItem);
            }
            if(curListItem.nodeName.toLowerCase() == "listseparator") {
  		        var objMenuButtonItem = objToolbars.createMenuSeparator();
  		        objMenuButton.add(objMenuButtonItem);
            }
  		    }
  		    objToolbar.add(objMenuButton);
        }
        // add popupbutton
        if(curNode.tagName == "popupbutton") {
          var image = curNode.getAttribute("image");
          if(image.indexOf("/")<0)
            image = imagePath + image;
          var popupwidth   = curNode.getAttribute("popupwidth");
          popupwidth = popupwidth ? popupwidth : 100;
          var popupheight   = curNode.getAttribute("popupheight");
          popupheight = popupheight ? popupheight : 100;
          var url         = curNode.getAttribute("url");
          var tooltipid = curNode.getAttribute("tooltipid");
          var tooltip   = curNode.getAttribute("tooltip");
          var callback = curNode.getAttribute("callback");
          var tag    = curNode.getAttribute("tag");

          var objPopupButton = objToolbars.createPopupButton("",image,"__onPopupButtonClick",tooltip ? tooltip : getLanguageString(language,tooltipid),"",url);
          objPopupButton.popupwidth   = popupwidth;
          objPopupButton.popupheight  = popupheight;
          if(callback)
            objPopupButton.callback = callback;
	        objToolbar.add(objPopupButton);
        }
        // add colorbutton
        if(curNode.tagName == "colorbutton") {
          var image = curNode.getAttribute("image");
          var tooltipid = curNode.getAttribute("tooltipid");
          var tooltip   = curNode.getAttribute("tooltip");
          var tag    = curNode.getAttribute("tag");
          var callback = curNode.getAttribute("callback");
          var objColor = objToolbars.createColorButton(imagePath + image,imagePath + "colorselect.gif","__onColorButtonClick",tooltip ? tooltip : getLanguageString(language,tooltipid),tooltip ? tooltip : getLanguageString(language,tooltipid),"");
          if(tag == "COLOR")
            btnColor = objColor;
          if(tag == "BACKCOLOR")
            btnBackColor = objColor;
            
    		  if(callback)
            objColor.callback = callback;
	        objToolbar.add(objColor);
        }

        // add dropdown
        if(curNode.tagName == "dropdownlist") {
          //var image = curNode.getAttribute("image");
          var tooltipid = curNode.getAttribute("tooltipid");
          var tooltip   = curNode.getAttribute("tooltip");
          var action       = curNode.getAttribute("action");
          var width        = curNode.getAttribute("width") != "" ? curNode.getAttribute("width") : "";
          var displayValue = curNode.getAttribute("displayvalue");
          var selectedIndex = curNode.getAttribute("selectedindex");
          selectedIndex = selectedIndex ? selectedIndex : 0;
          var tag         = curNode.getAttribute("tag");
          tag = tag ? tag : "";
          var callback = curNode.getAttribute("callback");
          var popupwidth = curNode.getAttribute("popupwidth");
          if(!popupwidth)
            popupwidth = "";
          var comparemode = curNode.getAttribute("comparemode");
          if(!comparemode)
            comparemode = "";

		      var cmbDropDown = objToolbars.createStyleCombo("__onDropDownClick",tooltip ? tooltip : getLanguageString(language,tooltipid),tag);
		      if(tag == "STYLE")
		        cmbStyle = cmbDropDown;
		      if(tag == "FORMAT")
		        cmbFormat = cmbDropDown;
		      if(tag == "FONT")
		        cmbFont = cmbDropDown;
		      if(tag == "FONTSIZE")
		        cmbFontSize = cmbDropDown;
		      cmbDropDown.width = width;
		      cmbDropDown.popupwidth = popupwidth != "" ? popupwidth:"";
		      cmbDropDown.popupheight = "";
		      cmbDropDown.popupmaxheight = __editGetEditorHeight();
		      cmbDropDown.popupmaxwidth = __editGetEditorWidth();
    		  cmbDropDown.displayValue = displayValue.toLowerCase();
    		  if(selectedIndex > 0)
    		    cmbDropDown.selectedIndex = selectedIndex;
    		  if(callback)
    		    cmbDropDown.callback = callback;
    		  if(comparemode)
    		    cmbDropDown.compareMode = comparemode;

          var aItems = curNode.getElementsByTagName("listitem");
          for(var k=0;k<aItems.length;k++) {
  		      var curListItem = aItems[k];
            var text = curListItem.getAttribute("text");
            var textid = curListItem.getAttribute("textid");
            var value = curListItem.getAttribute("value");
            var tag = curListItem.getAttribute("tag");
            var tag2 = "";
            if(textid == "6000")
              tag2 = getLanguageString(language,textid)
            var objDropDownItem = objToolbars.createStyleComboItem(text ? text : getLanguageString(language,textid),"","",value,tag ? tag :"",tag2);
      		  cmbDropDown.add(objDropDownItem);
  		    }
  		    objToolbar.add(cmbDropDown);
        }

      }
     
      // add statusbar
      if(globalStatusBarVisible) {
	      if(id == "toolbar_bottom") {
  	      objToolbar.fullsize = true;
  		    objToolbar.add(toolbarsBottom.createDistance(3,true));
          if(browser.ie)
            editStatusBar = toolbarsBottom.createLabel("",true,"100%","border:1px inset;font-family:arial;font-size:11px;padding:2px;color: darkblue");
          else
            editStatusBar = toolbarsBottom.createLabel("",true,"100%","border-top:1px solid #808080;border-left:1px solid #808080;border-bottom:1px solid white;font-family:arial;font-size:11px;padding:2px;color:darkblue");
		      objToolbar.add(editStatusBar);
        }
      }

      objToolbars.add(objToolbar);
    }
  } catch(Error) {
  }

  objToolbars.create();

/*
if(id == "toolbar_bottom") {
  var status = editStatusBar.getObject();
  var pb = document.getElementById("toolbar_bottom").contentWindow.document.createElement("span");
  pb.style.height = "100%";
  status.appendChild(pb);
  pb.style.backgroundColor = "orange";
  pb.style.width = "50%";
}
*/

}

// called when button is clicked (independant of toolbar row)
function onToolbarButtonClick(id,objToolbars)
{
  var button = objToolbars.getElementById(id);
  eval(button.callback);
}

function __onMenuButtonClick(id)
{
  var menu = toolbarsTop.getElementById(id);
  eval(menu.selectedItem.tag2);
}

function __onPopupButtonClick(id)
{
  var popup = toolbarsTop.getElementById(id);
  eval(popup.callback);  
}

function __onDropDownClick(id)
{
  var dropdown = toolbarsTop.getElementById(id);
  eval(dropdown.callback);  
}

function __onColorButtonClick(id)
{
  var colorbutton = toolbarsTop.getElementById(id);
  eval(colorbutton.callback);  
}


function onAutoTextClicked(id)
{
  if(id == "") {
    // button pressed
    editOpen(7);    
  } else {
    // menu pressed
    var menu = toolbarsTop.getElementById(id);
    if(menu.selectedItem.value == "NEWAUTOTEXT") {
      // open editor in new window
      var left = screen.width/2 - 335;
      var top = screen.height/2 - 175;
      window.open(__editGetEditorUrl() + "server/" + globalTechnology + "/autotext." + globalTechnology + "?lg=" + language + "&st=" + design + "&iu=" + globalimageAbsolute + "&ip=" + globalImagePathAbsolute + "&au=" + globalAutoTextUrlAbsolute + "&ap=" + globalAutoTextPathAbsolute,"color","modal=1,left=" + left + ",top=" + top + ",height=350,width=670,resizable=1,status=0,scrollbars=0");
    }
  }
}
