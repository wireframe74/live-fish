//----------------------------------------------------------------------------------------
// pinEdit global settings
//----------------------------------------------------------------------------------------

// defines the save mode
// 0 = Absolute All HTML
// 1 = Absolute Body HTML
// 2 = Relative All HTML
// 3 = Relative Body HTML
// 4 = XHTML
// 5 = XHtml Body
var globalSaveMode = 5;

// this content is passed in variable "custom" to the save adapter
var globalSaveValue = "";

//--------------------------------------------------------------------------------------------------------
// MISC
//--------------------------------------------------------------------------------------------------------
// if set to true, Control-V is disabled and the event editOnControlV is raised
var globalControlVDisabled = false;

// the active doc type for XHTML (transitional)
//var globalXHtmlDocType = "<?xml version=\"1.0\"?><!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">";
var globalXHtmlDocType = "";
// the official w3c doc type declarations
//var globalXHtml10Transitionl = "<?xml version=\"1.0\"?><!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">";
//var globalXHtml10Strict = "<?xml version=\"1.0\"?><!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">";
//var globalXHtml11 = "<?xml version=\"1.0\"?><!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.1//EN\" \"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd\">";
var globalXHtml10Transitionl = "";
var globalXHtml10Strict = "";
var globalXHtml11 = "";




//------------------------------------------------------------------------------------------------------
// configuration file for pinEdit menu creation
//------------------------------------------------------------------------------------------------------

var objMenuBar = null;

function CreateMenu(userCode)
{
  var imageUrl = globalEditorImagesFolder; 
  
  objMenuBar = new MenuBar();

  // Execute custom menu code if applicable
  if(eventOnBeforeCreateMenu(objMenuBar)) {
  	customMenu = true;
	  objMenuBar.show(0,0,500,22);
  	return;
  }

  // we have to close open toolbar popups
  objMenuBar.eventOnPopup = "onMenuPopup";

  objMenuBar.design = design;
  objMenuBar.backcolor = globalToolbarColor;

  //-----------------------------------------------------------------------------------------------------------
  // create file menu
  //-----------------------------------------------------------------------------------------------------------
  objMenuBarItem = new MenuBarItem(getString(3018));

  objMenu = new Menu("onMenuItemClick");
  objMenu.add(new MenuItem(getString(101) ,imageUrl + "new.gif","","NEW"));
  objMenu.add(new MenuItem(getString(102) + "...",imageUrl + "open.gif","","OPEN"));
  objMenu.add(new MenuItem(getString(118) ,imageUrl + "save.gif","","SAVE"));
  objMenu.add(new MenuItem(getString(119) + "...",imageUrl + "saveas.gif","","SAVEAS"));
  objMenu.add(new MenuSeparator());
  objMenu.add(new MenuItem(getString(403) + "...",imageUrl + "preview.gif","","PREVIEW"));
  if(browser.ie)
    objMenu.add(new MenuItem(getString(103) + "...",imageUrl + "print.gif","","PRINT"));
  objMenu.add(new MenuSeparator());
  objMenu.add(new MenuItem(getString(1016) + "...","","","PAGE"));

  objMenuBarItem.setMenu(objMenu);
  objMenuBar.add(objMenuBarItem);

  //-----------------------------------------------------------------------------------------------------------
  // create edit menu
  //-----------------------------------------------------------------------------------------------------------
  objMenuBarItem = new MenuBarItem(getString(3019));

  objMenu = new Menu("onMenuItemClick");
  objMenu.add(new MenuItem(getString(107) ,imageUrl + "undo.gif","","UNDO"));
  objMenu.add(new MenuItem(getString(108),imageUrl + "redo.gif","","REDO"));
  objMenu.add(new MenuSeparator());
  objMenu.add(new MenuItem(getString(104) ,imageUrl + "cut.gif","","CUT"));
  objMenu.add(new MenuItem(getString(105) ,imageUrl + "copy.gif","","COPY"));
  objMenu.add(new MenuItem(getString(106) ,imageUrl + "paste.gif","","PASTE"));
  objMenu.add(new MenuItem(getString(408) ,imageUrl + "pasteword.gif","","PASTEWORD"));
  objMenu.add(new MenuSeparator());
  objMenu.add(new MenuItem(getString(1017) ,imageUrl + "delete.gif","","REMOVE"));
  objMenu.add(new MenuItem(getString(405) ,imageUrl + "selectall.gif","","SELECTALL"));
  objMenu.add(new MenuSeparator());
  objMenu.add(new MenuItem(getString(113) ,imageUrl + "search.gif","","SEARCH"));
  
  objMenuBarItem.setMenu(objMenu);
  objMenuBar.add(objMenuBarItem);

  //-----------------------------------------------------------------------------------------------------------
  // create view menu
  //-----------------------------------------------------------------------------------------------------------
  objMenuBarItem = new MenuBarItem(getString(1034));

  objMenu = new Menu("onMenuItemClick");
  objMenu.add(new MenuItem(getString(1031) ,imageUrl + "page.gif","","VIEWNORMAL"));
  objMenu.add(new MenuItem(getString(1032) ,imageUrl + "page.gif","","VIEWDOC"));
  objMenu.add(new MenuSeparator());
  objMenu.add(new MenuItem(getString(1033) ,imageUrl + "rule.gif","","RULER"));
  if(globalTechnology != "desk") {
    objMenu.add(new MenuSeparator());
    objMenu.add(new MenuItem(getString(3397) ,imageUrl + "fullsize.gif","","FULLSIZE"));
  }
    
  objMenuBarItem.setMenu(objMenu);
  objMenuBar.add(objMenuBarItem);

  //-----------------------------------------------------------------------------------------------------------
  // create insert menu
  //-----------------------------------------------------------------------------------------------------------
  objMenuBarItem = new MenuBarItem(getString(3020));

  objMenu = new Menu("onMenuItemClick");

  if(globalTechnology != "desk") {
    objMenu.add(new MenuItem(getString(1022),imageUrl + "autotext.gif","","AUTOTEXT"));
    objMenu.add(new MenuSeparator());
  }
  if(globalUserMode == "0") {
    objMenu.add(new MenuItem(getString(1020),imageUrl + "anchor.gif","","ANCHOR"));
  } else {
    objMenu.add(new MenuItem(getString(1037),imageUrl + "anchor.gif","","ANCHOR"));
  }
  if(globalTechnology != "desk") {
    objMenu.add(new MenuItem(getString(1018),imageUrl + "image.gif","","IMAGE"));
  }
  objMenu.add(new MenuItem(getString(1019),imageUrl + "textbox.gif","","TEXTBOX"));
  objMenu.add(new MenuItem(getString(1021),imageUrl + "link.gif","","LINK"));
  objMenu.add(new MenuSeparator());

  objMenu.add(new MenuItem(getString(116) ,imageUrl + "date.gif","","DATE"));
  objMenu.add(new MenuItem(getString(117),imageUrl + "time.gif","","TIME"));
  if(browser.ie) {
    objMenu.add(new MenuItem(getString(404),imageUrl + "pagebreak.gif","","PAGEBREAK"));
  }
  objMenu.add(new MenuSeparator());
  objMenu.add(new MenuItem(getString(3000),imageUrl + "ltr.gif","","LTR"));
  objMenu.add(new MenuItem(getString(3001),imageUrl + "rtl.gif","","RTL"));

  objMenuBarItem.setMenu(objMenu);
  objMenuBar.add(objMenuBarItem);

  //-----------------------------------------------------------------------------------------------------------
  // create forms menu
  //-----------------------------------------------------------------------------------------------------------
  if(globalUserMode == "0") {
    objMenuBarItem = new MenuBarItem(getString(3022));

    objMenu = new Menu("onMenuItemClick");
    objMenu.width = 200;
    objMenu.add(new MenuItem(getString(406),imageUrl + "form.gif","","FORM"));
    if(browser.ie) {
      objMenu.add(new MenuItem(getString(301),imageUrl + "label.gif","","LABEL"));
    }
    objMenu.add(new MenuItem(getString(302),imageUrl + "button.gif","","BUTTON"));
    objMenu.add(new MenuItem(getString(303),imageUrl + "input.gif","","INPUT"));
    objMenu.add(new MenuItem(getString(304),imageUrl + "checkbox.gif","","CHECK"));
    objMenu.add(new MenuItem(getString(305),imageUrl + "radio.gif","","OPTION"));
    objMenu.add(new MenuItem(getString(306),imageUrl + "combobox.gif","","COMBO"));
    objMenu.add(new MenuItem(getString(307),imageUrl + "listbox.gif","","LISTBOX"));
    objMenu.add(new MenuItem(getString(308),imageUrl + "textarea.gif","","AREA"));
    objMenu.add(new MenuItem(getString(410),imageUrl + "hidden.gif","","HIDDEN"));
    objMenu.add(new MenuSeparator());
    objMenu.add(new MenuItem(getString(310),imageUrl + "div.gif","","DIV"));
    if(browser.ie) {
      objMenu.add(new MenuItem(getString(309),imageUrl + "iframe.gif","","IFRAME"));
    }
    objMenu.add(new MenuSeparator());
    objMenu.add(new MenuItem(getString(311),imageUrl + "position.gif","","POSITION"));

    objMenuBarItem.setMenu(objMenu);
    objMenuBar.add(objMenuBarItem);
  }

  //-----------------------------------------------------------------------------------------------------------
  // create format menu
  //-----------------------------------------------------------------------------------------------------------
  if(globalUserMode == "1") {
    objMenuBarItem = new MenuBarItem(getString(3021));

    objMenu = new Menu("onMenuItemClick");
    objMenu.add(new MenuItem(getString(1023),imageUrl + "character.gif","","CHARACTER"));
    objMenu.add(new MenuItem(getString(1024),imageUrl + "border.gif","","BORDER"));
    objMenu.add(new MenuSeparator());
    objMenu.add(new MenuItem(getString(210),imageUrl + "orderedlist.gif","","ORDEREDLIST"));
    objMenu.add(new MenuItem(getString(211),imageUrl + "unorderedlist.gif","","UNORDEREDLIST"));

    objMenuBarItem.setMenu(objMenu);
    objMenuBar.add(objMenuBarItem);
  }
  
  //-----------------------------------------------------------------------------------------------------------
  // create xtras menu
  //-----------------------------------------------------------------------------------------------------------
  objMenuBarItem = new MenuBarItem(getString(1030));

  objMenu = new Menu("onMenuItemClick");
  objMenu.width = 200;
  if(globalTechnology != "desk") {
    objMenu.add(new MenuItem(getString(411),imageUrl + "spell.gif","","SPELL"));
    objMenu.add(new MenuSeparator());
  }
  objMenu.add(new MenuItem(getString(1025),"","","COUNTWORD"));
  objMenu.add(new MenuItem(getString(1026),"","","COUNTCHAR"));

  objMenuBarItem.setMenu(objMenu);
  objMenuBar.add(objMenuBarItem);

  //-----------------------------------------------------------------------------------------------------------
  // create help menu
  //-----------------------------------------------------------------------------------------------------------
  if(globalTechnology != "desk") {
    objMenuBarItem = new MenuBarItem("&?");

    objMenu = new Menu("onMenuItemClick");
    objMenu.add(new MenuItem(getString(114),imageUrl + "help.gif","","HELP"));

    objMenuBarItem.setMenu(objMenu);
    objMenuBar.add(objMenuBarItem);
  }

  // Execute custom menu code if applicable
  eventOnAfterCreateMenu(objMenuBar);
    
  // show menu
  objMenuBar.show(0,0,500,22);

}

function onMenuItemClick(key)
{
  if(key == "NEW")
    editNew();
  if(key == "OPEN") {
    if(globalTechnology != "desk") {
      editOpen(1);  
    } else {
      RaiseToolbarEvent('OPEN');
    }
  }
  if(key == "SAVE") {
    if(globalTechnology != "desk") {
      editSaveFile();
    } else {
      RaiseToolbarEvent('SAVE');
    }
  }
  if(key == "SAVEAS") {
    if(globalTechnology != "desk") {
      editSaveDialog();  
    } else {
      RaiseToolbarEvent('SAVEAS')
    }
  }
  if(key == "PREVIEW") {
    if(globalTechnology != "desk") {
      editPreview();  
    } else {
      RaiseInternalEvent('PREVIEW');
    }
  }
  if(key == "PRINT")
    editPrint();
  if(key == "PAGE")
    editProperties(4);

  if(key == "UNDO")
    editUndo();
  if(key == "REDO")
    editRedo();
  if(key == "CUT")
    editCut();
  if(key == "COPY")
    editCopy();
  if(key == "PASTE")
    editPaste();
  if(key == "PASTEWORD")
    editPasteWord();
  if(key == "REMOVE")
    editRemoveFormat();
  if(key == "SELECTALL")
    editSelectAll();
  if(key == "SEARCH")
    editSearch();


  if(key == "VIEWNORMAL") {
    editSetDocumentView(false);
  }  
  if(key == "VIEWDOC") {
    editSetDocumentView(true);
  }  
  if(key == "RULER") {
    globalRulerVisible = ! globalRulerVisible;
    editSetRulerVisible(globalRulerVisible);
  }  
  if(key == "FULLSIZE")
    editFullSize();


  if(key == "PAGEBREAK")
    editInsertObject('PAGEBREAK');
  if(key == "DATE")
    editInsertDate();
  if(key == "TIME")
    editInsertTime();
  if(key == "AUTOTEXT")
    editOpen(7);    
  if(key == "MARQUEE")
    editInsertObject('MARQUEE');
  if(key == "IMAGE")
    editOpen(3);
  if(key == "TEXTBOX")
    editInsertObject('DIV')
  if(key == "ANCHOR")
    editInsertObject('ANCHOR');
  if(key == "LINK")
    editLink();
  if(key == "LTR")
    editSetDirection('ltr');
  if(key == "RTL")
    editSetDirection('rtl');

  if(key == "CHARACTER")
    editProperties(16,"","", 400, 510);
  if(key == "BORDER")
    editProperties(17,"","", 430, 410);
  if(key == "ORDEREDLIST")
    editOrderedList();  
  if(key == "UNORDEREDLIST")
    editUnorderedList();  

  if(key == "SPELL") {
    if(globalTechnology != "desk")
      editSpell();  
    else
      editSpell(button.pressed);
  }
  if(key == "COUNTWORD")
    alert(getString(1027) + editGetWordCount());
  if(key == "COUNTCHAR")
    alert(getString(1028) + editGetCharCount());


  if(key == "FORM")
    editInsertObject('FORM');
  if(key == "LABEL")
    editInsertObject('LABEL');
  if(key == "BUTTON")
    editInsertObject('BUTTON');
  if(key == "INPUT")
    editInsertObject('INPUT');
  if(key == "CHECK")
    editInsertObject('CHECK');
  if(key == "OPTION")
    editInsertObject('OPTION');
  if(key == "COMBO")
    editInsertObject('COMBO');
  if(key == "LISTBOX")
    editInsertObject('LISTBOX');
  if(key == "AREA")
    editInsertObject('AREA');
  if(key == "HIDDEN")
    editInsertObject('HIDDEN');
  if(key == "DIV")
    editInsertObject('DIV');
  if(key == "IFRAME")
    editInsertObject('IFRAME');
  if(key == "POSITION")
    editAbsolute();
  if(key == "HELP") {
    editHelp();
  }
}

function onMenuPopup()
{
	// if there are open popups they will be closed
	toolbarsTop.reset();
}





//------------------------------------------------------------------------------------------------------
// pinEdit CONTEXT MENU creation
//------------------------------------------------------------------------------------------------------
// creates the context menu
function CreateContextMenu(objMenu,source,aHierarchy,selection,x,y)
{
  // to disable all context menus add uncomment "return"
  // return

  // allow modifying context menus from outside
  if(eventOnCreateContextMenu(objMenu,source,aHierarchy,selection,x,y))
    return;

  // Folder for images
  var url = globalEditorImagesFolder;
  var tag = "";
  
  if(selection.type != "TEXT")
    tag = source.tagName.toUpperCase();

  // is there a class ?
  var removeClass = source.className != "" ? true:false;

  // check out cut, copy, paste
  if(browser.ie) {
    // add cut,copy,paste and detect if something is selected
    if(selection.type != "NONE") {
      objMenu.add(new MenuItem(getString(104),url + "cut.gif","","CUT"));
    } else {
      var item = new MenuItem(getString(104),url + "cut.gif","","CUT");
      item.enabled = false;
      objMenu.add(item);
    }
    if(selection.type != "NONE") {
      objMenu.add(new MenuItem(getString(105),url + "copy.gif","","COPY"));
    } else {
      var item = new MenuItem(getString(105),url + "copy.gif","","COPY");
      item.enabled = false;
      objMenu.add(item);
    }
    objMenu.add(new MenuItem(getString(106),url + "paste.gif","","PASTE"));
    
    // foreground
    if(source.style.position == "absolute") {
      objMenu.add(new MenuSeparator());
      objMenu.add(new MenuItem(getString(814) ,url + "foreground.gif","","FOREGROUND"));
      objMenu.add(new MenuItem(getString(2000) ,url + "background.gif","","BACKGROUND"));
    }
  }

  // if we have a selection then add CHARACTER
  if(selection.type == "TEXT") {
    if(objMenu.count() > 0)
      objMenu.add(new MenuSeparator());
    objMenu.add(new MenuItem(getString(4300) ,url + "character.gif","","CHAR"));
    objMenu.add(new MenuItem(getString(4301) ,url + "border.gif","","BORDER"));
  }

  
  // 
  if(tag == "BODY") {
    if(objMenu.count() > 0)
      objMenu.add(new MenuSeparator());
    objMenu.add(new MenuItem(getString(812),url + "properties.gif","","BODY"));
    return;
  }

  if(tag == "DIV") {
    if(objMenu.count() > 0)
      objMenu.add(new MenuSeparator());
    objMenu.add(new MenuItem(getString(815),url + "properties.gif","","DIV"));
  }
  if(tag == "IFRAME") {
    if(objMenu.count() > 0)
      objMenu.add(new MenuSeparator());
    objMenu.add(new MenuItem(getString(816),url + "properties.gif","","IFRAME"));
    return;
  }
  if(tag == "INPUT") {
    if(objMenu.count() > 0)
      objMenu.add(new MenuSeparator());
    objMenu.add(new MenuItem(getString(3031),url + "properties.gif","","INPUT"));
    return;
  }
  if(tag == "SELECT") {
    if(objMenu.count() > 0)
      objMenu.add(new MenuSeparator());
    objMenu.add(new MenuItem(getString(3032),url + "properties.gif","","SELECT"));
    return;
  }
  if(tag == "TEXTAREA") {
    if(objMenu.count() > 0)
      objMenu.add(new MenuSeparator());
    objMenu.add(new MenuItem(getString(3033),url + "properties.gif","","TEXTAREA"));
    return;
  }

  if(tag == "A" && source.name != "") {
    if(objMenu.count() > 0)
      objMenu.add(new MenuSeparator());
    objMenu.add(new MenuItem(getString(1104) ,url + "remove.gif","","REMOVEANCHOR"));
    objMenu.add(new MenuSeparator());
    objMenu.add(new MenuItem(getString(1103),url + "properties.gif","","ANCHOR"));
    return;
  }
  if(tag == "FLASH") {
    if(objMenu.count() > 0)
      objMenu.add(new MenuSeparator());
    objMenu.add(new MenuItem(getString(3302),url + "properties.gif","","FLASH"));
    return;
  }
  if(tag == "HR") {
    if(objMenu.count() > 0)
      objMenu.add(new MenuSeparator());
    objMenu.add(new MenuItem(getString(1055),url + "properties.gif","","HR"));
    return;
  }
  
  // here we do NOT return
  if(tag == "IMG") {
    if(objMenu.count() > 0)
      objMenu.add(new MenuSeparator());
    objMenu.add(new MenuItem("Original Size" ,url + "position.gif","","ORIGINALSIZE"));
    objMenu.add(new MenuSeparator());
    objMenu.add(new MenuItem(getString(813),url + "properties.gif","","IMAGE"));
    if(globalUsePinImage) {
      objMenu.add(new MenuSeparator());
      objMenu.add(new MenuItem(getString(1096),url + "image.gif","","IMAGEEDITOR"));
    }
  }
  

  //-----------------------------------------------------------------------------------------------
  // Loop 
  //-----------------------------------------------------------------------------------------------
  var hasTable = false;
  var hasP = false;
  var hasA = false;
  var hasCell = false;
  var hasOL = false;
  var hasUL = false;
  for(var i=0; i< aHierarchy.length;i++) {
    var curObject = aHierarchy[i];
    tag = curObject.tagName;
    
    if(tag == "OL" && !hasOL) {
      hasOL = true;
      if(objMenu.count() > 0)
        objMenu.add(new MenuSeparator());
      objMenu.add(new MenuItem(getString(1061),url + "properties.gif","","OL"));
    }
    if(tag == "UL" && !hasUL) {
      hasUL = true;
      if(objMenu.count() > 0)
        objMenu.add(new MenuSeparator());
      objMenu.add(new MenuItem(getString(1062),url + "properties.gif","","UL"));
    }

	  if(globalUserMode == "0") {
      if(tag == "FORM") {
        if(objMenu.count() > 0)
          objMenu.add(new MenuSeparator());
        objMenu.add(new MenuItem(getString(1204) ,url + "remove.gif","","REMOVEFORM"));
        objMenu.add(new MenuItem(getString(1203),url + "properties.gif","","FORM"));
        return;
      }
    }
        
    if((tag == "TD" || tag == "TH") && !hasCell) {
      hasCell = true;
      if(objMenu.count() > 0)
        objMenu.add(new MenuSeparator());
      objMenu.add(new MenuItem(getString(801),url + "insertrowbefore.gif","","INSERTROWB"));
      objMenu.add(new MenuItem(getString(802),url + "insertrowafter.gif","","INSERTROWA"));
      objMenu.add(new MenuItem(getString(803),url + "deleterow.gif","","DELETEROW"));
      objMenu.add(new MenuSeparator());
      objMenu.add(new MenuItem(getString(804),url + "insertcolbefore.gif","","INSERTCOLB"));
      objMenu.add(new MenuItem(getString(805),url + "insertcolafter.gif","","INSERTCOLA"));
      objMenu.add(new MenuItem(getString(806),url + "deletecolumn.gif","","DELETECOL"));
      objMenu.add(new MenuSeparator());
      objMenu.add(new MenuItem(getString(807),url + "deletecell.gif","","DELETECELL"));
      objMenu.add(new MenuItem(getString(3412),url + "addcell.gif","","ADDCELL"));
      objMenu.add(new MenuSeparator());
      objMenu.add(new MenuItem(getString(3410),url + "colspan.gif","","COLSPAN"));
      objMenu.add(new MenuItem(getString(809),url + "dividecell.gif","","DIVIDECELL"));
      objMenu.add(new MenuSeparator());
      objMenu.add(new MenuItem(getString(3411),url + "rowspan.gif","","ROWSPAN"));
      objMenu.add(new MenuSeparator());
      objMenu.add(new MenuItem(getString(3310),url + "converttdth.gif","","CONVERTROW"));
      objMenu.add(new MenuSeparator());
      objMenu.add(new MenuItem(getString(810),url + "cellproperties.gif","","TD"));
      if(browser.ie) {
        objMenu.add(new MenuSeparator());
        objMenu.add(new MenuItem(getString(1036),"","","TDTABLESELECT"));
      }
    }
    if(tag == "TABLE" && !hasTable) {
      hasTable = true;
      if(objMenu.count() > 0)
        objMenu.add(new MenuSeparator());
		  if(!browser.ie) {
			  objMenu.add(new MenuItem(getString(3312) ,url + "remove.gif","","REMOVETABLE"));
			  objMenu.add(new MenuSeparator());
		  }
      if(source.style.tableLayout == "")  
        objMenu.add(new MenuItem(getString(1040),"","","SETSTATIC"));
      if(source.style.tableLayout == "fixed")  
        objMenu.add(new MenuItem(getString(1041),"","","SETNOTSTATIC"));

      objMenu.add(new MenuSeparator());
      var hasBorderWidth = (parseInt(curObject.style.borderWidth) == 0 || curObject.style.borderWidth == "") ? false:true;
      if(!hasBorderWidth && curObject.border == 0)
        objMenu.add(new MenuItem(getString(1070),"","","BORDERON"));
      else 
        objMenu.add(new MenuItem(getString(1071),"","","BORDEROFF"));
      objMenu.add(new MenuSeparator());
        
		  objMenu.add(new MenuItem(getString(811),url + "properties.gif","","TABLE"));
    }
    if(tag == "P" && !hasP) {
      hasP = true;
      if(objMenu.count() > 0)
        objMenu.add(new MenuSeparator());
      objMenu.add(new MenuItem(getString(7010),url + "paragraph2.gif","","P"));
    }
    if(tag == "A" && !hasA) {
      hasA = true;
      if(objMenu.count() > 0)
        objMenu.add(new MenuSeparator());
      objMenu.add(new MenuItem(getString(3024),url + "link.gif","","REMOVELINK"));
      objMenu.add(new MenuItem(getString(3023),url + "properties.gif","","LINK"));
    }
  }

  if(removeClass) {
    if(objMenu.count() > 0)
      objMenu.add(new MenuSeparator());
    objMenu.add(new MenuItem(getString(7013) ,"","","REMOVECLASS"));
  }
  
}

// after item click
function onContextMenuItemClick(key,value)
{
  if(eventOnContextMenuItemClick(key,value))
    return;

  try {
    var sel = new Selection(getDoc());

  if(key == "FOREGROUND")
    editSetForeground();
  if(key == "BACKGROUND")
    editSetBackground();
  if(key == "CUT")
    editCut();
  if(key == "COPY")
    editCopy();
  if(key == "PASTE")
    editPaste();
    
    if(key == "BODY")
      editProperties(4);
    if(key == "IMAGE")
      editProperties(3);
    if(key == "DIV")
      editProperties(5);
    if(key == "IFRAME")
      editProperties(6);
    if(key == "P")
      editProperties(7);
    if(key == "REMOVEANCHOR")
      __editRemoveAnchor();
    if(key == "ANCHOR")
      editProperties(8);
    if(key == "REMOVEFORM")
      __editRemoveForm();
    if(key == "FORM")
      editProperties(9);
    if(key == "INPUT")
      editProperties(10);
    if(key == "SELECT")
      editProperties(11);
    if(key == "TEXTAREA")
      editProperties(13);
    if(key == "TABLE")
      editProperties(0);
    if(key == "HR")
      editProperties(18);
    if(key == "CHAR")
      editProperties(14,"","", 400, 540);
    if(key == "BORDER")
      editProperties(15,"","", 430, 410);

    if(key == "TDTABLE") {
      editSetActiveObject(sel.getActiveObject("table"));
      editProperties(0);
    }
    if(key == "TDTABLESELECT") {
      var table = sel.getActiveObject("table");
      editSetActiveObject(table);
      editSelectObject(table);
    }
    if(key == "REMOVETABLE")
      __editRemoveTable();

    if(key == "INSERTROWB")
      __editInsertRow(0);
    if(key == "INSERTROWA")
      __editInsertRow(1);
    if(key == "DELETEROW")
      __editDeleteRow();
    if(key == "INSERTCOLB")
      __editInsertColumn(0);
    if(key == "INSERTCOLA")
      __editInsertColumn(1);
    if(key == "DELETECOL")
      __editDeleteColumn();
    if(key == "DELETECELL")
      __editDeleteCell();
    if(key == "ADDCELL")
      __editAddCell();
    if(key == "COLSPAN")
      __editColSpan();
    if(key == "DIVIDECELL")
      __editDivideCell();
    if(key == "ROWSPAN")
      __editRowSpan();
    if(key == "CONVERTROW")
		  __editConvertRow();
    if(key == "TD")
      editProperties(2);

    if(key == "EDITABLE")
      editSetEditable(true);
    if(key == "FLASH")
      editProperties(12);
    if(key == "LINK")
      editLink();
    if(key == "REMOVELINK")
      editRemoveLink();

    if(key == "REMOVECLASS") {
      if(sel.type == "NONE") {
        var object = sel.getActiveObject();
        object.removeAttribute("class");
        object.removeAttribute("className");
      } else {
        var objects = sel.getSelectedObjects(true);
        for(var i=0;i<objects.length;i++) {
          objects[i].removeAttribute("class");
          objects[i].removeAttribute("className");
        }
      }
      __editOnChanged(true);
    }

    if(key == "ORIGINALSIZE") {
      var curObject = sel.getActiveObject();
      curObject.removeAttribute("width");
      curObject.removeAttribute("height");
      curObject.style.width = "";
      curObject.style.height = "";
      __editOnChanged(true);
    }

    if(key == "SETSTATIC") {
      var table = sel.getActiveObject("table");
      if(table)
        table.style.tableLayout = "fixed";
      __editOnChanged(true);
    }
    if(key == "SETNOTSTATIC") {
      var table = sel.getActiveObject("table");
      if(table)
        table.style.tableLayout = "";
      __editOnChanged(true);
    }

    if(key == "BORDEROFF") {
      var table = sel.getActiveObject("table");
      if(table) {
        editSetActiveObject(table);
        __editSetTableBorder(false);
      }
    }
    if(key == "BORDERON") {
      var table = sel.getActiveObject("table");
      if(table) {
        editSetActiveObject(table);
        __editSetTableBorder(true);
      }
    }

    if(key == "OL") {
      editSetActiveObject(sel.getActiveObject("ol"));
      editProperties(19);
    }
    if(key == "UL") {
      editSetActiveObject(sel.getActiveObject("ul"));
      editProperties(20);
    }
    
    if(key == "IMAGEEDITOR") {
      editImage();
    }
  } catch(Error) {}
  
	__editHidePopup();
}




