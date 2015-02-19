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
var toolbarPath = "";

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

  try {
    tbdesign = design;
    if(design == "1") {
      border = true;
    }
    if(design == "2") {
      border = true;
    }

    imagePath = globalEditorImagesFolder;
    toolbarPath = __editGetEditorUrl() + "toolbar/design/style" + design + "/";
    
    var hasTop    = false;
    var hasBottom = false;
    var hasLeft   = false;
    var hasTM     = false;
    var hasEdit   = false;
    var config    = "";

    objToolbars.backcolor = globalToolbarColor;

    // search for 'B'
    var bottomPos = __editToolbarString.indexOf("B");
    // search for 'L'
    var leftPos = __editToolbarString.indexOf("L");
    if(leftPos < 0)
      leftPos = __editToolbarString.length;

	  // which toolbar do we have
	  if(id == "toolbar_top") {
      toolbarsTop = objToolbars;
      if(__editToolbarString.indexOf("T") >= 0) {
        if(bottomPos > 0) {
          config = __editToolbarString.substring(0,bottomPos-1);
        } else {
          config = __editToolbarString;
        }
      } else {
        document.getElementById(id).style.height = 0;
        return;
      }
    }
	  // which toolbar do we have
	  if(id == "toolbar_bottom") {
      toolbarsBottom = objToolbars;
      if(bottomPos >= 0) {
        config = __editToolbarString.substring(bottomPos,leftPos);
      } else {
        document.getElementById(id).style.height = 0;
        return;
      }
    }
	  // which toolbar do we have
    if(globalSideBarVisible) {
	    if(id == "windowLeft") {
        toolbarsLeft = objToolbars;
        if(leftPos >= 0) {
          config = __editToolbarString.substring(leftPos);
        }
      }
    }

  //alert(id + ":" + config);

    if(config == "")
      return;

     
    // remove last ;
    if(config.substring(config.length-1,config.length) == ";")
      config = config.substring(0,config.length-1);
    
    // which toolbars do we have
    var aToolbars = config.split(";");

	  if(id != "windowLeft") {
	    var faktor = 1;
	    if(design == "5")
	      faktor = 30;
	    else
	      faktor = 29;
      // set height of toolbars  
      document.getElementById(id).style.height = aToolbars.length * faktor;
    }

    for(var i=0;i<aToolbars.length;i++) {
      var where = aToolbars[i].substring(0,1);
      if(where == "T") {
        hasTop = true;
      } else if( where == "B")  {
        hasBottom = true;
      } else if( where == "L")  {
        hasLeft = true;
      } else {
        alert("Unknown toolbar key: " + where);
        return;
      }
      var buttons = aToolbars[i].substring(1,aToolbars[i].length);
      var aItems = new Array(buttons.length/2);
      for(var k=0;k<aItems.length;k++) {
        aItems[k] = buttons.substring(k*2,(k*2) +2);
      }

      var objToolbar = objToolbars.createToolbar();
      objToolbar.design = tbdesign;
      objToolbar.border = border;
      //objToolbar.height = 40;
      
	    if(id == "toolbar_top")
		    objToolbar.action = "onToolbarbuttonClick";
	    if(id == "toolbar_bottom")
		    objToolbar.action = "onToolbarbuttonClickBottom";
	    if(id == "windowLeft") {
		    objToolbar.action = "onToolbarbuttonClickLeft";
        objToolbars.orientation = "V";
		  }

	    if(id != "windowLeft")
  		  objToolbar.add(objToolbars.createSeparator(toolbarPath + "tbbegin.gif"));
	    else
  		  objToolbar.add(objToolbars.createSeparator(toolbarPath + "tbbeginv.gif"));
      hasbutton = false;

      for(var j=0;j<aItems.length;j++) {
        if(aItems[j] == "53")
          hasEdit = true;
        if(__toolbar_addItem(objToolbars,objToolbar,aItems[j]))
          hasbutton = true;
      }

	    if(id != "windowLeft") {
        if(design == "3" || design == "4")
  		    objToolbar.add(objToolbars.createSeparator(toolbarPath + "tbend.gif"));
      }
      if(hasbutton)
        objToolbars.add(objToolbar);
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

    objToolbars.create();

  } catch(Error){
    if(globalDebug) {
      alert("config_toolbar_auto: " + Error);
    }
  }
}

function __toolbar_addItem(objToolbars,objToolbar, item)
{
  switch(item) {
    case "SE":  // separator
   		objToolbar.add(objToolbars.createSeparator(toolbarPath + "separator.gif",true));
      return false;

    case "TS":  // Toolbar start
   		objToolbar.add(objToolbars.createSeparator(toolbarPath + "tbbegin.gif"));
      return false;

    case "TE":  // Toolbar end
   		objToolbar.add(objToolbars.createSeparator(toolbarPath + "tbend.gif"));
      return false;

    case "DI":  // divider
			objToolbar.add(objToolbars.createDistance(3,true));
      return false;

    case "01":  // New
      if(globalTechnology != "desk") {
		    var objNew = objToolbars.createMenuButton("",imagePath + "new.gif",imagePath + "selector.gif","onNewClicked",getString(101),"New");
		    objNew.add(objToolbars.createMenuItem(getString(101),imagePath + "new.gif","","NEW"));
		    objNew.add(objToolbars.createMenuItem(getString(3313),imagePath + "template.gif","","TEMPLATE"));
		    // add to toolbar
		    objToolbar.add(objNew);
      }
      return true;

    case "97": // New single
   		objToolbar.add(objToolbars.createButton("",imagePath + "new.gif","",getString(101),"NEW"));
      return true;

    case "02": // Open
   		objToolbar.add(objToolbars.createButton("",imagePath + "open.gif","",getString(102),"OPEN"));
      return true;

    case "03":  // Save
		  objToolbar.add(objToolbars.createButton("",imagePath + "save.gif","",getString(118),"SAVE"));
      return true;

    case "65": // Save As
      objToolbar.add(objToolbars.createButton("",imagePath + "saveas.gif","",getString(119),"SAVEAS"));
      return true;

    case "73": // Save local
      if(globalTechnology != "desk")
	  	  objToolbar.add(objToolbars.createButton("",imagePath + "savelocal.gif","",getString(3300),"SAVELOCAL"));
      return true;

    case "04": // Search
      objToolbar.add(objToolbars.createButton("",imagePath + "search.gif","",getString(113),"SEARCH"));
      return true;

    case "05": // Print
		  objToolbar.add(objToolbars.createButton("",imagePath + "print.gif","",getString(103),"PRINT"));
      return true;

    case "76": // Preview
		  objToolbar.add(objToolbars.createButton("",imagePath + "preview.gif","",getString(3314),"PRINTPREVIEW"));
      return true;

    case "80": // PDF
		  var objPdf = objToolbars.createMenuButton("",imagePath + "pdf.gif",imagePath + "colorselect.gif","onMenuPDFClicked",getString(1077),getString(1077));
		  objPdf.add(objToolbars.createMenuItem("Create PDF",imagePath + "pdf.gif","","PDF"));
		  objPdf.add(objToolbars.createMenuItem("PDF Settings",imagePath + "pdf.gif","","PDFSET"));
		  // add to toolbar
		  objToolbar.add(objPdf);
      return true;

    case "64": // Spell
      if(globalTechnology != "desk")
		    objToolbar.add(objToolbars.createButton("",imagePath + "spell.gif","",getString(411),"SPELL"));
		  else
    		objToolbar.add(objToolbars.createCheckButton("",imagePath + "spell.gif","",getString(411),"SPELL",false,""));
		  
      return true;

    case "66": // Upload
      if(globalTechnology != "desk") {
		    var objUpload = objToolbars.createMenuButton("",imagePath + "upload.gif",imagePath + "colorselect.gif","onMenuUploadClicked",getString(3011),"Upload");
		    objUpload.add(objToolbars.createMenuItem(getString(704),imagePath + "upload_image.gif","","UPLOADIMG"));
		    objUpload.add(objToolbars.createMenuItem(getString(3010),imagePath + "upload_document.gif","","UPLOADDOC"));
		    objToolbar.add(objUpload);
      }
      return true;

    case "06":  // Cut
   		objToolbar.add(objToolbars.createButton("",imagePath + "cut.gif","",getString(104),"CUT"));
      return true;

    case "07":  // Copy
		  objToolbar.add(objToolbars.createButton("",imagePath + "copy.gif","",getString(105),"COPY"));
      return true;

    case "08":  // Paste
		  objToolbar.add(objToolbars.createButton("",imagePath + "paste.gif","",getString(106),"PASTE"));
      return true;

    case "61":  // Paste Word
		  objToolbar.add(objToolbars.createButton("",imagePath + "pasteword.gif","",getString(408),"PASTEWORD"));
      return true;

    case "77":  // Paste Text
		  objToolbar.add(objToolbars.createButton("",imagePath + "pastetext.gif","",getString(3340),"PASTETEXT"));
      return true;

    case "09":  // Undo
		  objToolbar.add(objToolbars.createButton("",imagePath + "undo.gif","",getString(107),"UNDO"));
      return true;

    case "10":  // Redo
		  objToolbar.add(objToolbars.createButton("",imagePath + "redo.gif","",getString(108),"REDO"));
      return true;

    case "11": // Link
   		objToolbar.add(objToolbars.createButton("",imagePath + "link.gif","",getString(109),"LINK"));
      return true;

    case "60": // anchor
  		objToolbar.add(objToolbars.createButton("",imagePath + "anchor.gif","",getString(407),"ANCHOR"));
      return true;

    case "12": // Image
		  var objImage = objToolbars.createMenuButton("",imagePath + "image.gif",imagePath + "colorselect.gif","onImageClicked",getString(110),"Image");
      if(globalTechnology != "desk") {
  		  objImage.add(objToolbars.createMenuItem(getString(703),imagePath + "image.gif","","INSERTSERVER"));
		    objImage.add(objToolbars.createMenuItem(getString(3005),imagePath + "image_upload.gif","","INSERTUP"));
		  }
		  objImage.add(objToolbars.createMenuItem(getString(702),imagePath + "image_world.gif","","INSERTWEB"));
		  if(browser.ie)
			  objImage.add(objToolbars.createMenuItem(getString(701),imagePath + "image_server.gif","","INSERTLOC"));
		  objToolbar.add(objImage);
      return true;

    case "13":  // Table
      var objpopupbutton = objToolbars.createPopupButton("",imagePath + "table.gif","onCreateTable",getString(111),"","popup/table2.html");
      objpopupbutton.popupwidth = "120px";
      objpopupbutton.popupheight  = "132px";
	    objToolbar.add(objpopupbutton);
      return true;

    case "14": // Rule
		  objToolbar.add(objToolbars.createButton("",imagePath + "rule.gif","",getString(112),"RULE"));
      return true;

    case "15": // Char
  		objToolbar.add(objToolbars.createButton("",imagePath + "char.gif","",getString(115),"CHAR"));
      return true;

    case "79": // Smileys
		  // smileys
      var objpopupbutton = objToolbars.createPopupButton("","design/image/smileys/smiley14.gif","onSmileyClicked","","","popup/smiley.html");
      objpopupbutton.popupheight  = "125px";
	    objToolbar.add(objpopupbutton);
      return true;

    case "16": // Date
		  objToolbar.add(objToolbars.createButton("",imagePath + "date.gif","",getString(116),"DATE"));
      return true;

    case "17": // Time
		  objToolbar.add(objToolbars.createButton("",imagePath + "time.gif","",getString(117),"TIME"));
      return true;

    case "62": // Marquee
  		objToolbar.add(objToolbars.createButton("",imagePath + "marquee.gif","",getString(409),"MARQUEE"));
      return true;

    case "57": // Page break
  		objToolbar.add(objToolbars.createButton("",imagePath + "pagebreak.gif","",getString(404),"PAGEBREAK"));
      return true;

    case "67": // Paragraph
  		objToolbar.add(objToolbars.createButton("",imagePath + "paragraph.gif","",getString(3002),"PARAGRAPH"));
      return true;

    case "70": // Flash
      if(globalTechnology != "desk")
    		objToolbar.add(objToolbars.createButton("",imagePath + "flash.gif","",getString(3303),"FLASH"));
      return true;

    case "71": // Media
      if(globalTechnology != "desk")
    		objToolbar.add(objToolbars.createButton("",imagePath + "media.gif","",getString(3304),"MEDIA"));
      return true;

    case "99": // Help
		  objToolbar.add(objToolbars.createButton("",imagePath + "help.gif","",getString(114),"HELP"));
      return true;

    case "19":  // Styles
		  // create a style combo
		  cmbStyle = objToolbars.createStyleCombo("onStyleComboChanged",getString(3014),"STYLE");
		  // set combo width
		  cmbStyle.width = "70";
		  // set popup window width
		  cmbStyle.popupwidth = "";
		  // set popup window height
		  cmbStyle.popupheight = "";
		  cmbStyle.popupmaxheight = __editGetEditorHeight();
		  cmbStyle.popupmaxwidth = __editGetEditorWidth();
		  // define which of the properties shall be used for display 
		  cmbStyle.displayValue = "tag2";
		  // add item
		  cmbStyle.add(objToolbars.createStyleComboItem(getString(6000),"","","Standard","",getString(6000)));
		  // add to toolbar
		  objToolbar.add(cmbStyle);
   		objToolbar.add(objToolbars.createDistance(3,false));
      return true;

    case "56": // Format
		  cmbFormat = objToolbars.createStyleCombo("onFormatComboChanged",getString(3015),"FORMAT");
		  // set combo width
		  cmbFormat.width = "80";
		  // set popup window width
		  cmbFormat.popupwidth = "";
		  // set popup window height
		  cmbFormat.popupheight = "";
		  cmbFormat.popupmaxheight = __editGetEditorHeight();
		  cmbFormat.popupmaxwidth = __editGetEditorWidth();
		  // define which of the properties shall be used for display 
		  cmbFormat.displayValue = "tag1";
		  // add item
		  cmbFormat.add(objToolbars.createStyleComboItem("Normal","","","NORMAL","Normal"));
		  cmbFormat.add(objToolbars.createStyleComboItem("<h1 unselectable='ON'>Heading 1</h1>","","","<h1>","Heading 1"));
		  cmbFormat.add(objToolbars.createStyleComboItem("<h2 unselectable='ON'>Heading 2</h2>","","","<h2>","Heading 2"));
		  cmbFormat.add(objToolbars.createStyleComboItem("<h3 unselectable='ON'>Heading 3</h3>","","","<h3>","Heading 3"));
		  cmbFormat.add(objToolbars.createStyleComboItem("<h4 unselectable='ON'>Heading 4</h4>","","","<h4>","Heading 4"));
		  cmbFormat.add(objToolbars.createStyleComboItem("<h5 unselectable='ON'>Heading 5</h5>","","","<h5>","Heading 5"));
		  cmbFormat.add(objToolbars.createStyleComboItem("<h6 unselectable='ON'>Heading 6</h6>","","","<h6>","Heading 6"));
		  cmbFormat.add(objToolbars.createStyleComboItem("<address unselectable='ON'>Address</address>","","","<address>","Address"));
		  cmbFormat.add(objToolbars.createStyleComboItem("<dir unselectable='ON'>Directory List</dir>","","","<dir>","Directory List"));
		  cmbFormat.add(objToolbars.createStyleComboItem("<pre unselectable='ON'>Formatted</pre>","","","<pre>","Formatted"));
		  cmbFormat.add(objToolbars.createStyleComboItem("<menu unselectable='ON'>Menu List</menu>","","","<menu>","Menu List"));
		  objToolbar.add(cmbFormat);
   		objToolbar.add(objToolbars.createDistance(3,false));
      return true;

    case "20":  // Font
		  // create a style combo
		  cmbFont = objToolbars.createStyleCombo("onFontComboChanged",getString(3016),"");
		  // set combo width
		  cmbFont.width = "114";
		  // set popup window width
		  cmbFont.popupwidth = "";
		  // set popup window height
		  cmbFont.popupheight = "";
		  cmbFont.popupmaxheight = __editGetEditorHeight();
		  cmbFont.popupmaxwidth = __editGetEditorWidth();
		  // define which of the properties shall be used for display 
		  cmbFont.displayValue = "value";
		  // add item
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

		  objToolbar.add(cmbFont);
		  objToolbar.add(objToolbars.createDistance(3,false));
      return true;

    case "21":  // Font size
		  // create a style combo
		  cmbFontSize = objToolbars.createStyleCombo("onFontSizeComboChanged",getString(3017),"");
		  // set combo width
		  cmbFontSize.width = "45";
		  // set popup window width
		  cmbFontSize.popupwidth = "";
		  // set popup window height
		  cmbFontSize.popupheight = "";
		  cmbFontSize.popupmaxheight = __editGetEditorHeight();
		  cmbFontSize.popupmaxwidth = __editGetEditorWidth();
		  // define which of the properties shall be used for display 
		  cmbFontSize.displayValue = "tag1";

		  // add item
      if(globalUseStyleFormatting) {
		    cmbFontSize.add(objToolbars.createStyleComboItem("<span unselectable='ON' style='font-family:Arial;font-size: 6" + globalFontSizeType + "'>6</span>","","","6","6"));
		    cmbFontSize.add(objToolbars.createStyleComboItem("<span unselectable='ON' style='font-family:Arial;font-size: 7" + globalFontSizeType + "'>7</span>","","","7","7"));
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
		    cmbFontSize.add(objToolbars.createStyleComboItem("<span unselectable='ON' style='font-family:Arial;font-size: 22" + globalFontSizeType + "'>22</span>","","","22","22"));
		    cmbFontSize.add(objToolbars.createStyleComboItem("<span unselectable='ON' style='font-family:Arial;font-size: 24" + globalFontSizeType + "'>24</span>","","","24","24"));
		    cmbFontSize.add(objToolbars.createStyleComboItem("<span unselectable='ON' style='font-family:Arial;font-size: 36" + globalFontSizeType + "'>36</span>","","","36","36"));
		    cmbFontSize.add(objToolbars.createStyleComboItem("<span unselectable='ON' style='font-family:Arial;font-size: 48" + globalFontSizeType + "'>48</span>","","","48","48"));
      } else {
        if(globalFontSizeType.toLowerCase() == "pt") {
  		    cmbFontSize.add(objToolbars.createStyleComboItem("<span unselectable='ON' style='font-family:Arial;font-size: 8" + globalFontSizeType + "'>8</span>","","","8","8"));
		      cmbFontSize.add(objToolbars.createStyleComboItem("<span unselectable='ON' style='font-family:Arial;font-size: 10" + globalFontSizeType + "'>10</span>","","","10","10"));
		      cmbFontSize.add(objToolbars.createStyleComboItem("<span unselectable='ON' style='font-family:Arial;font-size: 12" + globalFontSizeType + "'>12</span>","","","12","12"));
		      cmbFontSize.add(objToolbars.createStyleComboItem("<span unselectable='ON' style='font-family:Arial;font-size: 14" + globalFontSizeType + "'>14</span>","","","14","14"));
		      cmbFontSize.add(objToolbars.createStyleComboItem("<span unselectable='ON' style='font-family:Arial;font-size: 18" + globalFontSizeType + "'>18</span>","","","18","18"));
		      cmbFontSize.add(objToolbars.createStyleComboItem("<span unselectable='ON' style='font-family:Arial;font-size: 24" + globalFontSizeType + "'>24</span>","","","24","24"));
		      cmbFontSize.add(objToolbars.createStyleComboItem("<span unselectable='ON' style='font-family:Arial;font-size: 36" + globalFontSizeType + "'>36</span>","","","36","36"));
        } else {
		      cmbFontSize.add(objToolbars.createStyleComboItem("<span unselectable='ON' style='font-family:Arial;font-size: 10" + globalFontSizeType + "'>10</span>","","","10","10"));
		      cmbFontSize.add(objToolbars.createStyleComboItem("<span unselectable='ON' style='font-family:Arial;font-size: 12" + globalFontSizeType + "'>12</span>","","","12","12"));
		      cmbFontSize.add(objToolbars.createStyleComboItem("<span unselectable='ON' style='font-family:Arial;font-size: 16" + globalFontSizeType + "'>16</span>","","","16","16"));
		      cmbFontSize.add(objToolbars.createStyleComboItem("<span unselectable='ON' style='font-family:Arial;font-size: 18" + globalFontSizeType + "'>18</span>","","","18","18"));
		      cmbFontSize.add(objToolbars.createStyleComboItem("<span unselectable='ON' style='font-family:Arial;font-size: 24" + globalFontSizeType + "'>24</span>","","","24","24"));
		      cmbFontSize.add(objToolbars.createStyleComboItem("<span unselectable='ON' style='font-family:Arial;font-size: 32" + globalFontSizeType + "'>32</span>","","","32","32"));
		      cmbFontSize.add(objToolbars.createStyleComboItem("<span unselectable='ON' style='font-family:Arial;font-size: 48" + globalFontSizeType + "'>48</span>","","","48","48"));
        }
      }
		  objToolbar.add(cmbFontSize);
      return true;

    case "22":  // Bold
		  btnBold = objToolbars.createButton("",imagePath + "bold.gif","",getString(201),"BOLD");
		  objToolbar.add(btnBold);
      return true;

    case "23":  // Italic
		  btnItalic = objToolbars.createButton("",imagePath + "italic.gif","",getString(202),"ITALIC");
		  objToolbar.add(btnItalic);
      return true;

    case "24":  // Underline
		  btnUnderline = objToolbars.createButton("",imagePath + "underline.gif","",getString(203),"UNDERLINE")
		  objToolbar.add(btnUnderline);
      return true;

    case "51":  // Strike through
      btnStrike = objToolbars.createButton("",imagePath + "strikethrough.gif","",getString(1080),"STRIKE");
		  objToolbar.add(btnStrike);
      return true;

    case "25":  // Superscript
		  btnSuperscript = objToolbars.createButton("",imagePath + "superscript.gif","",getString(204),"SUPERSCRIPT")
		  objToolbar.add(btnSuperscript);
      return true;

    case "26":  // Subscript
		  btnSubscript = objToolbars.createButton("",imagePath + "subscript.gif","",getString(205),"SUBSCRIPT")
		  objToolbar.add(btnSubscript);
      return true;

    case "27":  // Justify left
		  btnJustifyLeft = objToolbars.createButton("",imagePath + "left.gif","",getString(206),"JUSTIFYLEFT")
		  objToolbar.add(btnJustifyLeft);
      return true;

    case "28":  // Justify center
		  btnJustifyCenter = objToolbars.createButton("",imagePath + "center.gif","",getString(207),"JUSTIFYCENTER")
		  objToolbar.add(btnJustifyCenter);
      return true;

    case "29":  // Justify right
		  btnJustifyRight = objToolbars.createButton("",imagePath + "right.gif","",getString(208),"JUSTIFYRIGHT")
		  objToolbar.add(btnJustifyRight);
      return true;

    case "30":  // Justify block
		  btnJustifyFull = objToolbars.createButton("",imagePath + "block.gif","",getString(209),"JUSTIFYFULL")
		  objToolbar.add(btnJustifyFull);
      return true;

    case "31":  // Ordered list
		  btnInsertOrderedList = objToolbars.createButton("",imagePath + "orderedlist.gif","",getString(210),"INSERTORDEREDLIST")
		  objToolbar.add(btnInsertOrderedList);
      return true;

    case "32":  // Unordered list
		  btnInsertUnorderedList = objToolbars.createButton("",imagePath + "unorderedlist.gif","",getString(211),"INSERTUNORDEREDLIST")
		  objToolbar.add(btnInsertUnorderedList);
      return true;

    case "33":  // Indent
		  objToolbar.add(objToolbars.createButton("",imagePath + "indent.gif","",getString(212),"INDENT"));
      return true;

    case "34":  // Outdent
		  objToolbar.add(objToolbars.createButton("",imagePath + "outdent.gif","",getString(213),"OUTDENT"));
      return true;

    case "35":  // Color
      btnColor = objToolbars.createColorButton(imagePath + "color.gif",imagePath + "colorselect.gif","onChangeTextColor",getString(215),getString(217),"");
		  objToolbar.add(btnColor);
      return true;

    case "36":  // Backcolor
		  btnBackColor = objToolbars.createColorButton(imagePath + "backcolor.gif",imagePath + "colorselect.gif","onChangeBackgroundColor",getString(216),getString(218),"");
		  objToolbar.add(btnBackColor);
      return true;

    case "75":  // Page
		  objToolbar.add(objToolbars.createButton("",imagePath + "page.gif","",getString(3398),"PAGE"));
      return true;

    case "59":  // Form
		  objToolbar.add(objToolbars.createButton("",imagePath + "form.gif","",getString(406),"FORM"));
      return true;

    case "38":  // Label
		  if(browser.ie)
			  objToolbar.add(objToolbars.createButton("",imagePath + "label.gif","",getString(301),"LABEL"));
      return true;

    case "39":  // button
		  objToolbar.add(objToolbars.createButton("",imagePath + "button.gif","",getString(302),"BUTTON"));
      return true;

    case "40":  // Input
		  objToolbar.add(objToolbars.createButton("",imagePath + "input.gif","",getString(303),"INPUT"));
      return true;

    case "41":  // Checkbox
  		objToolbar.add(objToolbars.createButton("",imagePath + "checkbox.gif","",getString(304),"CHECK"));
      return true;

    case "42":  // Radio
		  objToolbar.add(objToolbars.createButton("",imagePath + "radio.gif","",getString(305),"OPTION"));
      return true;

    case "43":  // Combo
  		objToolbar.add(objToolbars.createButton("",imagePath + "combobox.gif","",getString(306),"COMBO"));
      return true;

    case "44":  // Listbox
		  objToolbar.add(objToolbars.createButton("",imagePath + "listbox.gif","",getString(307),"LISTBOX"));
      return true;

    case "45":  // Textarea
		  objToolbar.add(objToolbars.createButton("",imagePath + "textarea.gif","",getString(308),"AREA"));
      return true;

    case "63":  // Hidden
		  objToolbar.add(objToolbars.createButton("",imagePath + "hidden.gif","",getString(410),"HIDDEN"));
      return true;

    case "46":  // Div
      if(globalUserMode == "0")
  		  objToolbar.add(objToolbars.createButton("",imagePath + "textbox.gif","",getString(310),"DIV"));
  		else
  		  objToolbar.add(objToolbars.createButton("",imagePath + "textbox.gif","",getString(1038),"DIV"));
      return true;

    case "47":  // IFrame
		  if(browser.ie)
  		  objToolbar.add(objToolbars.createButton("",imagePath + "iframe.gif","",getString(309),"IFRAME"));
      return true;

    case "48":  // Position
  		objToolbar.add(objToolbars.createButton("",imagePath + "position.gif","",getString(311),"POSITION"));
      return true;

    case "52":  // HTML Optimizer
  		objToolbar.add(objToolbars.createButton("",imagePath + "plus.gif","",getString(1083),"OPTIMIZER"));
      return true;

    case "49":  // Special character
      objToolbar.add(objToolbars.createCheckButton("",imagePath + "special.gif","",getString(1042),"SPECIAL",false,""));
      return true;

    case "78":  // Full size
      if(globalTechnology == "desk")
    		objToolbar.add(objToolbars.createButton("",imagePath + "fullsize.gif","",getString(3397),"FULLSIZE"));
      return true;

    case "37":  // Cleaner
		  // create cleaner menu button
		  var objCleaner = objToolbars.createMenuButton("",imagePath + "remove.gif",imagePath + "colorselect.gif","onCleanerClicked",getString(214),"CLEANER");
		  objCleaner.add(objToolbars.createMenuItem(getString(7014),imagePath + "remove.gif","","RMALL"));
		  objCleaner.add(objToolbars.createMenuSeparator());
		  objCleaner.add(objToolbars.createMenuItem(getString(7015),imagePath + "removestyle.gif","","RMSTYLE"));
		  objCleaner.add(objToolbars.createMenuItem(getString(7016),imagePath + "removetag.gif","","RMCLASS"));
		  objCleaner.add(objToolbars.createMenuItem(getString(7017),imagePath + "removeformat.gif","","RMFORMAT"));
		  // add to toolbar
		  objToolbar.add(objCleaner);
      return true;

    case "68":  // breakmode mode
		  // create breakmode button
		  var cmbBreakMode = objToolbars.createStyleCombo("onBreakClicked",getString(3013),"");
		  // set combo width
		  cmbBreakMode.width = "40";
		  cmbBreakMode.popupwidth = "";
		  // set popup window height
		  cmbBreakMode.popupheight = "";
		  cmbBreakMode.popupmaxheight = __editGetEditorHeight();
		  cmbBreakMode.popupmaxwidth = __editGetEditorWidth();
		  // define which of the properties shall be used for display 
		  cmbBreakMode.displayValue = "value";
		  cmbBreakMode.add(objToolbars.createStyleComboItem("P","","","P"));
		  cmbBreakMode.add(objToolbars.createStyleComboItem("BR","","","BR"));
		  cmbBreakMode.add(objToolbars.createStyleComboItem("WP","","","WP"));
		  if(globalBreakMode == "p")
   		  cmbBreakMode.selectedIndex  = 0;
		  if(globalBreakMode == "br")
   		  cmbBreakMode.selectedIndex  = 1;
		  if(globalBreakMode == "wp")
   		  cmbBreakMode.selectedIndex  = 2;

		  // add to toolbar
		  objToolbar.add(cmbBreakMode);
		  return true;

    case "81":  // Auto text
      if(globalTechnology != "desk") {
		    // auto text
		    var objAutoText = objToolbars.createMenuButton("",imagePath + "autotext.gif",imagePath + "colorselect.gif","onAutoTextClicked","Auto text","Auto text");
		    objAutoText.update = false;
		    objAutoText.add(objToolbars.createMenuItem("New...",imagePath + "new.gif","","NEWAUTOTEXT"));
		    // add to toolbar
		    objToolbar.add(objAutoText);
      }
		  return true;

    case "69":  // Table highlight
  		objToolbar.add(objToolbars.createButton("",imagePath + "tablehigh.gif","",getString(3003),"HIGHLIGHT"));
      return true;

    case "58":  // Select all
  		objToolbar.add(objToolbars.createButton("",imagePath + "selectall.gif","",getString(405),"SELECTALL"));
      return true;

    case "72":  // Editable
  		objToolbar.add(objToolbars.createButton("",imagePath + "edit.gif","",getString(3301),"EDITABLE"));
      return true;

    case "18":
      if(browser.ie) {
		    // create a style combo
		    cmbZoom = objToolbars.createStyleCombo("onZoomClicked",getString(3319),"");
		    // set combo width
		    cmbZoom.width = "50";
		    // set popup window width
		    cmbZoom.popupwidth = "50";
		    // set popup window height
		    cmbZoom.popupheight = "120";
		    // define which of the properties shall be used for display 
		    cmbZoom.displayValue = "value";
		    cmbZoom.add(objToolbars.createStyleComboItem("10%","","","10%"));
		    cmbZoom.add(objToolbars.createStyleComboItem("50%","","","50%"));
		    cmbZoom.add(objToolbars.createStyleComboItem("100%","","","100%"));
		    cmbZoom.add(objToolbars.createStyleComboItem("150%","","","150%"));
		    cmbZoom.add(objToolbars.createStyleComboItem("200%","","","200%"));
		    cmbZoom.selectedIndex  = 2;
		    // add to toolbar
		    objToolbar.add(cmbZoom);
      } 
      return true;

    case "82":  // ROWB
		  btnRowB = objToolbars.createButton("",imagePath + "insertrowbefore.gif","",getString(801),"INSERTROWB");
		  btnRowB.imageDisabled = imagePath + "insertrowbefore_d.gif";
		  btnRowB.enabled = false;
		  objToolbar.add(btnRowB);
      return true;

    case "83":  // ROWA
		  btnRowA = objToolbars.createButton("",imagePath + "insertrowafter.gif","",getString(802),"INSERTROWA");
		  btnRowA.imageDisabled = imagePath + "insertrowafter_d.gif";
		  btnRowA.enabled = false;
		  objToolbar.add(btnRowA);
      return true;

    case "84":  // ROWDEL
		  btnRowDelete = objToolbars.createButton("",imagePath + "deleterow.gif","",getString(803),"DELETEROW");
		  btnRowDelete.imageDisabled = imagePath + "deleterow_d.gif";
		  btnRowDelete.enabled = false;
		  objToolbar.add(btnRowDelete);
      return true;

    case "85":  // COLB
		  btnColB = objToolbars.createButton("",imagePath + "insertcolbefore.gif","",getString(804),"INSERTCOLB");
		  btnColB.imageDisabled = imagePath + "insertcolbefore_d.gif";
		  btnColB.enabled = false;
		  objToolbar.add(btnColB);
      return true;

    case "86":  // COLA
		  btnColA = objToolbars.createButton("",imagePath + "insertcolafter.gif","",getString(805),"INSERTCOLA");
		  btnColA.imageDisabled = imagePath + "insertcolafter_d.gif";
		  btnColA.enabled = false;
		  objToolbar.add(btnColA);
      return true;

    case "87":  // COLDEL
		  btnColDelete = objToolbars.createButton("",imagePath + "deletecolumn.gif","",getString(806),"DELETECOL");
		  btnColDelete.imageDisabled = imagePath + "deletecolumn_d.gif";
		  btnColDelete.enabled = false;
		  objToolbar.add(btnColDelete);
      return true;

    case "88":  // CELLDEL
		  btnCellDelete = objToolbars.createButton("",imagePath + "deletecell.gif","",getString(807),"DELETECELL");
		  btnCellDelete.imageDisabled = imagePath + "deletecell_d.gif";
		  btnCellDelete.enabled = false;
		  objToolbar.add(btnCellDelete);
      return true;

    case "89":  // CELLADD
		  btnCellAdd = objToolbars.createButton("",imagePath + "addcell.gif","",getString(3412),"ADDCELL");
		  btnCellAdd.imageDisabled = imagePath + "addcell_d.gif";
		  btnCellAdd.enabled = false;
		  objToolbar.add(btnCellAdd);
      return true;

    case "90":  // COLSPAN
		  btnColSpan = objToolbars.createButton("",imagePath + "colspan.gif","",getString(3410),"COLSPAN");
		  btnColSpan.imageDisabled = imagePath + "colspan_d.gif";
		  btnColSpan.enabled = false;
		  objToolbar.add(btnColSpan);
      return true;

    case "91":  // CELLDIV
		  btnCellDivide = objToolbars.createButton("",imagePath + "dividecell.gif","",getString(809),"DIVIDECELL");
		  btnCellDivide.imageDisabled = imagePath + "dividecell_d.gif";
		  btnCellDivide.enabled = false;
		  objToolbar.add(btnCellDivide);
      return true;

    case "92":  // ROWSPAN
		  btnRowSpan = objToolbars.createButton("",imagePath + "rowspan.gif","",getString(3411),"ROWSPAN");
		  btnRowSpan.imageDisabled = imagePath + "rowspan_d.gif";
		  btnRowSpan.enabled = false;
		  objToolbar.add(btnRowSpan);
      return true;

    case "93":  // CELLCONVERT
		  btnCellConvert = objToolbars.createButton("",imagePath + "converttdth.gif","",getString(3310),"CONVERTROW");
		  btnCellConvert.imageDisabled = imagePath + "converttdth_d.gif";
		  btnCellConvert.enabled = false;
		  objToolbar.add(btnCellConvert);
      return true;

    case "94":  // CELLPROP
		  btnCellProp = objToolbars.createButton("",imagePath + "cellproperties.gif","",getString(810),"TD");
		  btnCellProp.imageDisabled = imagePath + "cellproperties_d.gif";
		  btnCellProp.enabled = false;
		  objToolbar.add(btnCellProp);
      return true;

    case "95":  // TABLEPROP
		  btnTableProp = objToolbars.createButton("",imagePath + "tableproperties.gif","",getString(811),"TDTABLE");
		  btnTableProp.imageDisabled = imagePath + "tableproperties_d.gif";
		  btnTableProp.enabled = false;
		  objToolbar.add(btnTableProp);
      return true;

    case "96":  // Style editor
  		objToolbar.add(objToolbars.createButton("",imagePath + "ss_inline.gif","",getString(1015),"STYLESHEET"));
      return true;

    case "50":  // External styles
      if(globalTechnology != "desk") {
		    var objStyleSheetEx = objToolbars.createMenuButton("",imagePath + "ss_add.gif",imagePath + "colorselect.gif","onMenuStyleSheetEx",getString(1047),getString(1047));
		    objStyleSheetEx.add(objToolbars.createMenuItem(getString(1044),imagePath + "ss_add.gif","","ADDSTYLESHEET"));
		    objStyleSheetEx.add(objToolbars.createMenuItem(getString(1045),imagePath + "ss_edit.gif","","EDITSTYLESHEET"));
		    objStyleSheetEx.add(objToolbars.createMenuItem(getString(1046),imagePath + "ss_remove.gif","","REMOVESTYLESHEET"));
		    // add to toolbar
		    objToolbar.add(objStyleSheetEx);
      }
      return true;

    case "98":  // line spacing
		  var objLS = objToolbars.createMenuButton("",imagePath + "linespacing.gif",imagePath + "colorselect.gif","onLinespaceClicked",getString(7021),"CLEANER");
		  objLS.update = false;
		  objLS.add(objToolbars.createMenuItem("1",imagePath + "empty.gif","","LS1"));
		  objLS.add(objToolbars.createMenuItem("1.25",imagePath + "empty.gif","","LS2"));
		  objLS.add(objToolbars.createMenuItem("1.5",imagePath + "empty.gif","","LS3"));
		  objLS.add(objToolbars.createMenuItem("2",imagePath + "empty.gif","","LS4"));
		  objLS.add(objToolbars.createMenuSeparator());
		  objLS.add(objToolbars.createMenuItem(getString(7010),imagePath + "paragraph2.gif","","LS5"));
		  // add to toolbar
		  objToolbar.add(objLS);
      return true;


    case "53":  // Edit
  		objToolbar.add(objToolbars.createCheckButton(getString(401),imagePath + "edit.gif","",getString(401),"EDIT",true,"GROUP"));
      return true;

    case "54":  // HTML
  		objToolbar.add(objToolbars.createCheckButton(getString(402),imagePath + "html.gif","",getString(402),"HTML",false,"GROUP"));
      return true;

    case "55": // Preview
  		objToolbar.add(objToolbars.createCheckButton(getString(403),imagePath + "preview.gif","",getString(403),"PREVIEW",false,"GROUP"));
      return true;
  }
}

//-------------------------------------------------------------------------------------------
// User defined Toolbar events
//-------------------------------------------------------------------------------------------
// called when button is clicked (independant of toolbar row)
function onToolbarbuttonClick(id)
{
  // get object
  var button = toolbarsTop.getElementById(id);
  __onToolbarbuttonClick(button);
}

// for lower toolbar
function onToolbarbuttonClickBottom(id)
{
  // get object
  var button = toolbarsBottom.getElementById(id);
  __onToolbarbuttonClick(button);
}

function onToolbarbuttonClickLeft(id)
{
  // get object
  var button = toolbarsLeft.getElementById(id);
  __onToolbarbuttonClick(button);
}

function __onToolbarbuttonClick(button)
{
  if(button.tag == "NEW")	                 editNew(1);  
  if(button.tag == "OPEN") {
    if(globalTechnology != "desk") {
      editOpen(1);  
    } else {
      RaiseToolbarEvent('OPEN');
    }
  }
  if(button.tag == "SAVE") {
    if(globalTechnology != "desk") {
      onSaveFile();  
    } else {
      RaiseToolbarEvent('SAVE');
    }
  }
  if(button.tag == "SAVEAS") {	               
    if(globalTechnology != "desk") {
      editSaveDialog();  
    } else {
      RaiseToolbarEvent('SAVEAS')
    }
  }  
  if(button.tag == "SAVELOCAL")	           editSaveLocal();  
  if(button.tag == "SEARCH")	             editSearch();  
  if(button.tag == "PRINT")	               editPrint();  
  if(button.tag == "PRINTPREVIEW") {	         
    if(globalTechnology != "desk") {
      editPreview();  
    } else {
      RaiseInternalEvent('PREVIEW');
    }
  }  
  if(button.tag == "PRINTSETUP") {
    RaiseInternalEvent('PRINTSETUP');  
  }
  if(button.tag == "SPELL")	{
    if(globalTechnology != "desk")
      editSpell();  
    else
      editSpell(button.pressed);
  }
  if(button.tag == "CUT")	                 editCut();  
  if(button.tag == "COPY")	               editCopy();  
  if(button.tag == "PASTE")	               editPaste();  
  if(button.tag == "PASTEWORD")	           editPasteWord();  
  if(button.tag == "PASTETEXT")	           editPasteText();  
  if(button.tag == "UNDO")	               editUndo();  
  if(button.tag == "REDO")	               editRedo();  
  if(button.tag == "LINK")	               editLink();  
  if(button.tag == "ANCHOR")	             editInsertObject('ANCHOR');  
  if(button.tag == "RULE")	               editInsertObject('RULE');  
  if(button.tag == "DATE")	               editInsertDate();  
  if(button.tag == "TIME")	               editInsertTime();  
  if(button.tag == "MARQUEE")	             editInsertObject('MARQUEE');  
  if(button.tag == "PAGEBREAK")	           editInsertObject('PAGEBREAK');  
  if(button.tag == "PARAGRAPH")	           editParagraph();  
  if(button.tag == "EDITABLE")	           editSetEditable(false);  
  if(button.tag == "FLASH")	               editOpen(4);  
  if(button.tag == "MEDIA")	               editOpen(5);  
  if(button.tag == "HELP")	               editHelp();  
  if(button.tag == "BOLD")	               editBold(!button.pressed);  
  if(button.tag == "ITALIC")	             editItalic(!button.pressed);  
  if(button.tag == "UNDERLINE")	           editUnderline(!button.pressed);  
  if(button.tag == "STRIKE")	             editStrikeThrough(!button.pressed);  
  if(button.tag == "SUPERSCRIPT")	         editSuperscript();  
  if(button.tag == "SUBSCRIPT")	           editSubscript();  
  if(button.tag == "JUSTIFYLEFT")	         editJustifyLeft();  
  if(button.tag == "JUSTIFYCENTER")	       editJustifyCenter();  
  if(button.tag == "JUSTIFYRIGHT")	       editJustifyRight();  
  if(button.tag == "JUSTIFYFULL")	         editJustifyFull();  
  if(button.tag == "INSERTORDEREDLIST")	   editOrderedList();  
  if(button.tag == "INSERTUNORDEREDLIST")	 editUnorderedList();  
  if(button.tag == "INDENT")	             editIndent();  
  if(button.tag == "OUTDENT")	             editOutdent();  
  if(button.tag == "INSERTROWB")					__editInsertRow(0); 
  if(button.tag == "INSERTROWA")					__editInsertRow(1);
  if(button.tag == "DELETEROW")					  __editDeleteRow();
  if(button.tag == "INSERTCOLB")					__editInsertColumn(0);
  if(button.tag == "INSERTCOLA")					__editInsertColumn(1);
  if(button.tag == "DELETECOL")					  __editDeleteColumn();
  if(button.tag == "DELETECELL")					__editDeleteCell(); 
  if(button.tag == "ADDCELL")					    __editAddCell();
  if(button.tag == "COLSPAN")					    __editColSpan(); 
  if(button.tag == "DIVIDECELL")					__editDivideCell();
  if(button.tag == "ROWSPAN")					    __editRowSpan();
  if(button.tag == "CONVERTROW")					__editConvertRow(); 
  if(button.tag == "TD")					        editProperties(2);
  if(button.tag == "TDTABLE")             editProperties(0);
  if(button.tag == "TMADD")							   onInsertTextModule();  
  if(button.tag == "TMCREATE")						 editSetTextModule();  
  if(button.tag == "TMREMOVE")						 onDeleteTextModule();  
  if(button.tag == "POSITION")	           editAbsolute();  
  if(button.tag == "HIGHLIGHT")	           editTableHighlight(button.pressed);  
  if(button.tag == "RETURN")							 onReturnMode();  
  if(button.tag == "SELECTALL")	           editSelectAll();  
  if(button.tag == "FULLSIZE")	           editFullSize();  
  if(button.tag == "STYLESHEET")           editStyleSheet();  
  if(button.tag == "RMWP")                 editRemoveFormat();  

	// bottom. toolbar
  // hide top toolbar in HTML/PREVIEW
  if(button.tag == "EDIT" || button.tag == "HTML" || button.tag == "PREVIEW") {
    if(button.tag == "HTML" || button.tag == "PREVIEW") {
		  editSetToolbarVisible("TOP",false);  
    } else {
		  editSetToolbarVisible("TOP",true);  
    }

	  editSetMode(button.tag);
    editSetActiveMode(button.tag);
  }
  
  if(button.tag == "PAGE")	               editProperties(4);  
  if(button.tag == "FORM")	               editInsertObject('FORM');  
  if(button.tag == "LABEL")	               editInsertObject('LABEL');  
  if(button.tag == "BUTTON")	             editInsertObject('BUTTON');  
  if(button.tag == "INPUT")	               editInsertObject('INPUT');  
  if(button.tag == "CHECK")	               editInsertObject('CHECK');  
  if(button.tag == "OPTION")	             editInsertObject('OPTION');  
  if(button.tag == "COMBO")	               editInsertObject('COMBO');  
  if(button.tag == "LISTBOX")	             editInsertObject('LISTBOX');  
  if(button.tag == "AREA")	               editInsertObject('AREA');  
  if(button.tag == "HIDDEN")	             editInsertObject('HIDDEN');  
  if(button.tag == "DIV")	                 editInsertObject('DIV');  
  if(button.tag == "IFRAME")	             editInsertObject('IFRAME');  
  if(button.tag == "RMWP")                 editRemoveFormat();  
  if(button.tag == "SPECIAL")              editShowSpecialChar(button.pressed);

  if(button.tag == "OPTIMIZER")            editOptimize(2);
  if(button.tag == "CHAR")                 editChar();
  if(button.tag == "VALIDATOR")            editValidator();
}


// if NEW menu button item has been clicked
function onNewClicked(id)
{
  var menu = toolbarsTop.getElementById(id);
  if(menu.selectedItem.value == "NEW")      editNew();
  if(menu.selectedItem.value == "TEMPLATE") editOpen(6);
}

// if UPLOAD menu button item has been clicked
function onMenuUploadClicked(id)
{
  var menu = toolbarsTop.getElementById(id);
  if(menu.selectedItem.value == "UPLOADIMG") editUpload("","",0);
  if(menu.selectedItem.value == "UPLOADDOC") editUpload("","",1);
}

function onCreateTable(id)
{
  var popup = toolbarsTop.getElementById(id);
	// in value we have row:col (if cancel then value = "")
	if(popup.value != "") {
		var temp = popup.value.split(":");
		eventOnCreateTable(temp[0],temp[1]);
	}
}

function onCharClicked(id)
{
  var popup = toolbarsTop.getElementById(id);
	// in value we have character
	if(popup.value != "")
		editInsertHtml(popup.value);
}

// if IMAGE menu button item has been clicked
function onImageClicked(id)
{
  var menu = toolbarsTop.getElementById(id);
  if(menu.selectedItem.value == "INSERTLOC")    editInsertObject('IMAGE');
  if(menu.selectedItem.value == "INSERTWEB")    editInsertObject('IMAGEWEB');
  if(menu.selectedItem.value == "INSERTSERVER") editOpen(3);
  if(menu.selectedItem.value == "INSERTUP")     editUpload("","",0,true);
}

// if external Stylesheet
function onMenuStyleSheetEx(id)
{
  var menu = toolbarsTop.getElementById(id);
  if(menu.selectedItem.value == "ADDSTYLESHEET")    editOpen(8);
  if(menu.selectedItem.value == "EDITSTYLESHEET")   editEditExternalStyleSheet();
  if(menu.selectedItem.value == "REMOVESTYLESHEET") editRemoveExternalStyleSheets();
}

// called if style combo changed
function onStyleComboChanged(id)
{
  var combo = toolbarsTop.getElementById(id);
  editSetStyle(combo.selectedItem.value,combo.selectedItem.tag1);
}

// called if format combo changed
function onFormatComboChanged(id)
{
  var combo = toolbarsTop.getElementById(id);
	var value = combo.selectedItem.value;
  editFormat(value);
}

// called if font combo changed
function onFontComboChanged(id)
{
  var combo = toolbarsTop.getElementById(id);
	var value = combo.selectedItem.value;
	editFont(value);
}

// called if font size combo changed
function onFontSizeComboChanged(id)
{
  var combo = toolbarsTop.getElementById(id);
	var value = combo.selectedItem.value;
	editFontSize(value);
}

// called if CLEANER menu button item has been clicked
function onCleanerClicked(id)
{
  var menu = toolbarsTop.getElementById(id);
  if(menu.selectedItem.value == "RMALL")      editRemoveFormat();
  if(menu.selectedItem.value == "RMSTYLE")    editClean(0);
  if(menu.selectedItem.value == "RMCLASS")    editClean(1); 
  if(menu.selectedItem.value == "RMFORMAT")   editClean(2); 
}

// called if ZOOM menu button item has been clicked
function onZoomClicked(id)
{
  var menu = toolbarsTop.getElementById(id);
  editZoom(menu.selectedItem.value)
}

// called if break menu button item has been clicked
function onBreakClicked(id)
{
  var breakMode = toolbarsTop.getElementById(id);
  editSetBr(breakMode.selectedItem.value.toLowerCase());
}

function onAutoTextClicked(id)
{
  if(id == "") {
    // Button pressed
    editOpen(7);    
  } else {
    // menu pressed
    var menu = toolbarsTop.getElementById(id);
    if(menu.selectedItem.value == "NEWAUTOTEXT") {
      editOpen(9);
    }
  }
}

function onLinespaceClicked(id)
{
  var menu = toolbarsTop.getElementById(id);
  var value = menu.selectedItem.value;
  if(value == "LS1") editLineSpacing(14);
  if(value == "LS2") editLineSpacing(17.5);
  if(value == "LS3") editLineSpacing(21);
  if(value == "LS4") editLineSpacing(28);
  if(value == "LS5") editProperties(7);
}


// called if COLOR has been changed
function onChangeTextColor(id)
{
  var button = toolbarsTop.getElementById(id);
  editColor(button.color)
}

function onChangeBackgroundColor(id)
{
  var button = toolbarsTop.getElementById(id);
  editBackColor(button.color)
}

// called if RETURNMODE has been changed
function onReturnMode()
{
  var button = toolbarsTop.getElementByTag("RETURN");
  if(editGetBr()) {
    editSetBr(false);
    button.setImage(imagePath + "broff.gif");
  } else {
    editSetBr(true);
    button.setImage(imagePath + "bron.gif");
  }
}

// id save button is clicked
function onSaveFile()
{
	// if no file is loaded then open save dialog
	if(editGetFileUrl() == "")
		editSaveDialog();
	else
		editSave();
}

// if a text snippet has to be inserted
function onInsertTextModule()
{
	var combo = toolbarsTop.getElementByTag("TM");
	editInsertHtml(combo.getSelected().tag1);
}

// if a text snippet has to be deleted
function onDeleteTextModule()
{
	var combo = toolbarsTop.getElementByTag("TM");
	editDeleteTextModule(combo.getSelected().text);  
}

// when a smiley is clicked
function onSmileyClicked(id)
{
  var popup = toolbarsTop.getElementById(id);
	// in value we have character
  editInsertHtml("<img src='" + __editGetEditorUrl() + "design/image/smileys/smiley" + popup.value + ".gif' border=0>");
}

// if PDF menu button item has been clicked
function onMenuPDFClicked(id)
{
  var menu = toolbarsTop.getElementById(id);
  if(menu.selectedItem.value == "PDF") {    
    // set status
    editStatusBarSetText("Creating PDF...");
    if(globalTechnology != "desk")
      editPDFCreate();
    else
      RaiseInternalEvent('PDF');  
  }
  if(menu.selectedItem.value == "PDFSET")  editPDFSettings();
}

