// TODO
// - Wenn Maus rechts oben dann style falsch und popup geht nicht weg

// toolbars
var __menu_count = 1;
var __menu_aAllComponents = new Array();
var __aAllMenu = new Array();
var __delay_html = "";
var __delay_iframe;
var __curMenuBarItem = null;
var __curMenu = null;
var __curHeight = 0;

//---------------------------------------------------------------------------------------------
// MENU BAR
//---------------------------------------------------------------------------------------------
function MenuBar(containerid)
{
  this.id     = "";
  this.container  = document;
  if(containerid)
    this.containerid = containerid;
  else
    this.containerid = "";

  this.border       = true;
  this.action       = "";
  this.design       = "Office2003";
  this.fullsize     = false;
  this.backcolor    = "";
  this.active       = false;
  this.eventOnPopup = "";

  this.aComponents = new Array();
  this.add       = __menubar_add;
  this.show      = __menubar_show;
  this.getActiveBarItem = __menubar_getActiveBarItem;
  this.setVisible = __menubar_setvisible;
}

function __menubar_getActiveBarItem()
{
  return __curMenuBarItem;
}

function __menubar_setvisible(value)
{
  if(value)
    this.container.getElementById("__menu_bar").style.visibility = "visible";
  else
    this.container.getElementById("__menu_bar").style.visibility = "hidden";
}

function __menubar_show(x,y,width,height)
{
  var html = "";
  var temp = "";
  var div  = null;

  // if menu is recreated
  __curMenuBarItem = null;
  __curMenu = null;

  temp+= "<table height='100%' width='100%' cellspacing=1 cellpadding=1 border=0><tr>";

  for (var j=0;j<this.aComponents.length;j++) {
    var component = this.aComponents[j];
    var html = component.create();
    temp+=html;
  }

  temp+= "<td width='100%'></td></tr>";
  temp+= "</table>";

  html = temp;
  // create dynamic div
  if(!this.container.getElementById("__menu_bar")) {
    div = this.container.createElement("DIV");
    this.container.body.appendChild(div);
    div.id = "__menu_bar";
    if(this.containerid == "") {
      div.style.position = "absolute";
      div.style.left  = x;
      div.style.top   = y;
    }
    div.style.width = "100%";
    div.style.height= height;
    //div.style.backgroundColor = this.backcolor;
  } else {
    div = this.container.getElementById("__menu_bar");
  }
  div.className = "MenuBar" + this.design;
  div.innerHTML = html;
  div.style.visibility = "visible";
}

function __menubar_add(component)
{
  var id = this.aComponents.length;
  this.aComponents[id] = component;
  //component.id = __menu_count;
  component.bar = this;
  component.design = this.design;
  if(component.menu) {
    component.menu.design = this.design;
    component.menu.bar = this;
  }

  //__menu_count++;

  // we need this for access within events
  var id = __menu_aAllComponents.length;
  __menu_aAllComponents[id] = component;
}

function MenuBarItem(text)
{
  this.id      = __menu_count;
  __menu_count++;
  this.bar     = null;
  this.menu    = null;
  //this.tag     = tag;
  this.text    = text;
  //this.action  = action;
  //this.image   = image;
  this.pressed = false;
  this.enabled = true;
  this.visible = true;
  this.design  = "";

  this.setVisible   = __menubaritem_visible;
  this.setEnabled   = __menubaritem_enable;
  this.setStatus    = __menubaritem_status;

  this.onmouseup    = __menubaritem_mouseup;
  this.onmousedown  = __menubaritem_mousedown;
  this.onmouseover  = __menubaritem_mouseover;
  this.onmouseout   = __menubaritem_mouseout;

  this.create       = __menubaritem_create;
  this.setMenu      = __menubaritem_menu;
  this.reset        = __menubaritem_reset;

  // Added for keyboard accessibility
  this.getNextSibling   = __menubaritem_nextSibling;
  this.getPrevSibling   = __menubaritem_prevSibling;
  this.showMenu = __menubaritem_showMenu;
  this.hideMenu = __menubaritem_hideMenu;
  // used for Alt key shortcuts
  this.accessKey = null;
}

function __menubaritem_menu(menu)
{
  this.menu = menu;
  this.menu.id = "__menu" + this.id;
  this.menu.parent = this;
}

function __menubaritem_direct(id,action)
{
  for (var j=0;j<__menu_aAllComponents.length;j++) {
    if(__menu_aAllComponents[j].id == id){
      var component = __menu_aAllComponents[j];
      if(action == "OVER") {
        if(__curMenuBarItem) {
          document.getElementById(__curMenuBarItem.id).className='MenuBarItemStandard' + __curMenuBarItem.design;
        }
        __curMenuBarItem = component;
        component.onmouseover();
        if(component.bar.active) {
          if(component.menu) {
            var x = globalGetPositonX(document.getElementById(id));
            var y = globalGetPositonY(document.getElementById(id)) + document.getElementById(id).offsetHeight - 1;
            component.menu.show(x,y,component.menu.width,null,document.getElementById(id).offsetWidth-2);
          } else {
            __onMenuHide(component.menu.id);
          }
        }
      } else if(action == "OUT") {
        component.onmouseout();
      } else if(action == "DOWN") {
        component.onmousedown();
        component.bar.active = !component.bar.active;
        if(!component.bar.active) {
          __onMenuHide(component.menu.id);
        } else {
          if(component.menu && component.menu.visible == false) {
            var x = globalGetPositonX(document.getElementById(id));
            var y = globalGetPositonY(document.getElementById(id)) + document.getElementById(id).offsetHeight - 1;
            component.menu.show(x,y,component.menu.width,null,document.getElementById(id).offsetWidth-2);
          } else {
            __onMenuHide(component.menu.id);
          }
        }
      } else if(action == "UP") {
        component.onmouseup();
        if(component.bar.action != "") {
          if(component.tag != "" && component.tag != null)
            eval( component.bar.action + "('" + component.tag + "')");
        }
      }  else if(action == "FOCUS") {
		    if (!__curMenuBarItem || __curMenuBarItem != this) {		
			    if(__curMenuBarItem) {
				    // remove style from previous item
				    document.getElementById(__curMenuBarItem.id).className='MenuBarItemStandard' + __curMenuBarItem.design;
			    }
			    __curMenuBarItem = component;

       		    component.bar.active = true;
			    component.onmousedown();
    			
			    if(component.menu) {
				    // Show & give focus to the menu
				    component.showMenu();
			    } else {
				    __onMenuHide(component.menu.id);
			    }
		    }
	    }
      return;
    }
  }
}

// Added for keyboard accessibility
// shows & sets focus to the menu
function __menubaritem_showMenu() 
{
  var x = globalGetPositonX(document.getElementById(this.id));
  var y = globalGetPositonY(document.getElementById(this.id)) + document.getElementById(this.id).offsetHeight - 1;

  __curMenuBarItem = this;
  this.bar.active = true;
	this.onmousedown();
	
	if (this.menu) {
	  this.menu.show(x,y,this.menu.width,null,document.getElementById(this.id).offsetWidth-2);
    this.menu.focus()
	}
}

// Added for keyboard accessibility
function __menubaritem_hideMenu() 
{
	// hides & blurs the menu
	this.menu.hide();
	this.onmouseout();
}


function __menubaritem_create()
{
  var temp = "";

  var UIShortcut = getUIShortcut(this.text);

  temp+= "<td";
  temp+= " nowrap id='" + this.id + "' ";
  temp+= "class='MenuBarItemStandard" + this.design + "' ";
  temp+= "onmouseover='__menubaritem_direct(" + this.id + ",\"OVER\")'";
  temp+= "onmouseout='__menubaritem_direct(" + this.id + ",\"OUT\")'";
  temp+= "onmousedown='__menubaritem_direct(" + this.id + ",\"DOWN\")'";
  temp+= "onmouseup='__menubaritem_direct(" + this.id + ",\"UP\")'";
  temp+= "onfocus='__menubaritem_direct(" + this.id + ",\"FOCUS\")' ";
  temp+= "tabindex='1' ";
  if(UIShortcut.accessKey != null) {
		temp+= "accesskey='" + UIShortcut.accessKey + "' ";
  }
  temp+= ">";
  if(this.text)
    temp+= "<p unselectable='ON' class='MenuBarItemText" + this.design + "'>" + UIShortcut.html + "</p>";
  temp+= "</td>";
  temp+= "<iframe id='__menu" + this.id + "' unselectable='on' style='visibility: hidden;position:absolute;top:0px;left:0px;height:2px;width:2px;' class='MenuFrame" + this.design + "' src='" + this.menu.path + "pinMenu.html' frameborder='0' ></iframe>";
  return temp;
}

function __menubaritem_visible(value)
{
  this.visible = value;
}

function __menubaritem_enable(value)
{
  this.enabled = value;
  var button = document.getElementById(this.id);
  if(value) {
    button.className = 'MenuBarItemDisabled';
    button.innerHTML = "<span class='MenuBarItemDisabledContainer'><span class='MenuBarItemDisabledContainer'>" + button.innerHTML + "</span></span>";
  } else {
    button.className = 'MenuBarItemStandard';
    button.innerHTML = button.firstChild.firstChild.innerHTML;
  }
}

function __menubaritem_status(value)
{
  this.pressed = value;
  if(value) {
    document.getElementById(this.id).className='MenuBarItemActive' + this.design;
  } else {
    document.getElementById(this.id).className='MenuBarItemStandard' + this.design;
  }
}

function __menubaritem_mouseup()
{
  if(!this.enabled)
    return;

  if(this.bar.active)
    document.getElementById(this.id).className='MenuBarItemActive' + this.design;
  else
    document.getElementById(this.id).className='MenuBarItemStandard' + this.design;

  if(this.action != "") {
    eval(this.action);
  }
}

function __menubaritem_mousedown()
{
  if(!this.enabled)
    return;

  if(this.bar.active)
    document.getElementById(this.id).className='MenuBarItemActive' + this.design;
  else
    document.getElementById(this.id).className='MenuBarItemHover' + this.design;
}

function __menubaritem_mouseover()
{
  if(!this.enabled)
    return;

  if(this.bar.active)
    document.getElementById(this.id).className='MenuBarItemActive' + this.design;
  else
    document.getElementById(this.id).className='MenuBarItemHover' + this.design;
}

function __menubaritem_mouseout()
{
  if(!this.enabled)
    return;

  // Added visibility check to prevent improper styling bug when mousing away
  // from the menubaritem but not onto the menu.
  if(!this.menu.visible) {
  	document.getElementById(this.id).className='MenuBarItemStandard' + this.design;
  }
}

function __menubaritem_reset()
{
  this.bar.active = false;
  document.getElementById(this.id).className='MenuBarItemStandard' + this.design;
  if(this.menu)
    this.menu.hide();
}

// Added for keyboard accessibility
function __menubaritem_nextSibling()
{
	var siblingIndex = 0;
	for(i=0; i < this.bar.aComponents.length; i++) {
		if(this.bar.aComponents[i].id == this.id) {
			siblingIndex = i + 1;
			break;
		}
	}
	
	if(siblingIndex < this.bar.aComponents.length) {
		return this.bar.aComponents[siblingIndex];
	}
	else {
		// no next sibling, go to first menubaritem
		return this.bar.aComponents[0];
	}
}

// Added for keyboard accessibility
function __menubaritem_prevSibling()
{
	var siblingIndex = 0;
	for(i=0; i < this.bar.aComponents.length; i++) {
		if(this.bar.aComponents[i].id == this.id) {
			siblingIndex = i - 1;
			break;
		}
	}
	
	if(siblingIndex >= 0) {
		return this.bar.aComponents[siblingIndex];
	}
	else {
		// no previous sibling, go to last menubaritem
		return this.bar.aComponents[this.bar.aComponents.length - 1];
	}
}

//---------------------------------------------------------------------------------------------
// MENU
//---------------------------------------------------------------------------------------------
function Menu(callBack, containerid)
{
  this.id         = "__menu" + __menu_count;
  __menu_count++;
  this.aMenuItems = new Array();
  this.container  = document;
  this.bar     = null;
  // use an existing container
  if(containerid)
    this.id = containerid;
  this.callBack   = callBack;
  // the callback from pinMenu.html
  this.callbackInternal = "__onItemClick";
  this.isPopupMode = false;
  this.design     = "";
  this.width      = 150;
  this.height     = 0;
  this.path       = "menu/";
  this.imageColumn = true;
  this.isCreated  = false;

  this.clear  = __menu_clear;
  this.count  = __menu_itemcount;
  this.add    = __menu_add;
  this.create = __menu_create;
  this.show   = __menu_show;
  this.hide   = __menu_hide;
  this.getItemById = __menu_getitem;
  this.getDocument = __menu_getdoc;
  
  // Added for keyboard accessibility
  this.focus		= __menu_focus;
  this.blur			= __menu_blur;
  this.parent		= null;
  this.visible		= false;
   // Item in menu currently selected
  this.__curMenuItem = null;

//  document.onmouseup = __onMenuHidePopup;

  this.createItem		   = __menu_createitem;
  this.createSeparator = __menu_createseparator;
}

function __menu_itemcount()
{
  return this.aMenuItems.length;
}

function __menu_getitem(id)
{
  for(var i=0;i<this.aMenuItems.length;i++) {
    var item = this.aMenuItems[i];
    if(item.id == id)
      return item;
  }
}

function __onMenuHidePopup(evt)
{

  if(!browser.ns) {
    var x = parseInt(event.clientX);
    var y = parseInt(event.clientY);
  } else {
    var x = parseInt(evt.clientX);
    var y = parseInt(evt.clientY);
  }

  if(!__curMenu)
    return;

  var id = __curMenu.id;

  if(!document.getElementById(id))
    return;

  var menuX = parseInt(document.getElementById(id).style.left);
  var menuY = parseInt(document.getElementById(id).style.top);
  var menuWidth  = parseInt(document.getElementById(id).style.width);
  var menuHeight = parseInt(document.getElementById(id).style.height);

  if(x < menuX || x > (menuX + menuWidth)) {
    __onMenuHide(id);
    return;
  }


  if(y > (menuY + menuHeight))
    __onMenuHide(id);

}

function __onMenuHide(id)
{
alert("Hide");

  if(document.getElementById(id))
    document.getElementById(id).style.visibility = "hidden";

  if(__curMenuBarItem)
    __curMenuBarItem.reset();
}

function __menu_clear()
{
  this.aMenuItems = new Array();
}

function __menu_add(menuitem)
{
  var id = this.aMenuItems.length;
  this.aMenuItems[id] = menuitem;
  menuitem.id = __menu_count;
  menuitem.menu = this;
  menuitem.callback = this.callbackInternal;
  __menu_count++;

  // we ned this for access within events
  var id = __aAllMenu.length;
  __aAllMenu[id] = menuitem;
}

function __menu_create(barwidth)
{
  var lineWidth = "0";

  if(barwidth)
    lineWidth = barwidth;

  __curHeight = 0;
  var temp = "";

  if(this.isPopupMode) {
    temp+= "<TABLE  unselectable='ON' style='border:0' class='MenuBorder" + this.design + "' width='100%' height='100%' cellSpacing=0 cellPadding=0 border=0><TR><TD>";
  } else {
    if(!browser.ns)
      temp+= "<HR class='MenuLine" + this.design + "' style='width:" + lineWidth + " px;LEFT: 1px; POSITION: absolute; TOP: 0px' SIZE=1>";
    temp+= "<TABLE  unselectable='ON' style='TABLE-LAYOUT: fixed;' class='MenuBorder" + this.design + "' width='100%' height='100%' cellSpacing=0 cellPadding=0 border=0><TR><TD>";
  }

  // when we have no images the background image must disappear
  if(this.imageColumn)
    temp+= "<TABLE unselectable='ON'  style='TABLE-LAYOUT: fixed;' class='Menu" + this.design + "' cellSpacing=0 cellPadding=0 border=0><TR unselectable='ON'><TD unselectable='ON'>";
  else
    temp+= "<TABLE unselectable='ON' style='TABLE-LAYOUT: fixed;background-image: url();' class='Menu" + this.design + "' cellSpacing=0 cellPadding=0 border=0><TR unselectable='ON'><TD unselectable='ON'>";

  // get code for all toolbars
  for (var i=0;i<this.aMenuItems.length;i++) {
    var menuitem = this.aMenuItems[i];
    temp+= menuitem.create();
  }

  temp+="</TD></TR></table></TD></TR></table>";

  // difference to 4.0 ? Not clear why . ->Images

  //if(this.isPopupMode && browser.ns)
  //  this.height = __curHeight - 6;
  //else
    this.height = __curHeight + 4;

  return temp;
}

function __menu_show(x,y,width,height,barwidth)
{

  var iframe;
  var html = "";

  if(__curMenu)
    __curMenu.hide();

  __curMenu = this;

  // if we have a container
  if(this.id != "") {
    iframe = this.container.getElementById(this.id);
    if(!this.isCreated){
      html = this.create(barwidth);
      //this.htmlCreated = html;
      iframe.style.position = "absolute";
      var doc = iframe.contentWindow.document;
      doc.body.innerHTML = html;
      doc.onmousemove = __menu_move;
      // Added menu reference for keyboard accessibility (right/left arrows)
      iframe.contentWindow.__curMenu = this;
      this.isCreated = true;
    }
    // Added menu reference in else clause for keyboard 
    // accessibility (right/left arrows)
    else {
	  // update current menu
	   iframe.contentWindow.__curMenu = this;
    }

    iframe.style.left = x;
    iframe.style.top = y;

    if(height == null)
      iframe.style.height = this.height;
    else
      iframe.style.height = height;

    if(width == null)
      iframe.style.width = this.width;
    else
      iframe.style.width = width;

    iframe.style.visibility = "visible";
    //iframe.contentWindow.document.focus();

	  if(this.bar.eventOnPopup != "")
	    eval(this.bar.eventOnPopup + "()");
  } else {
    // no id --> use popup
    //<iframe id='__menu" + this.id + "' unselectable='on' style='visibility: hidden;position:absolute;top:0px;left:0px;height:2px;width:2px;' class='MenuFrame" + this.design + "' src='" + this.menu.path + "pinMenu.html' frameborder='0' ></iframe>";

  }
  this.visible = true;
}

function __menu_getdoc()
{
  // if we have a container
  if(this.id != "") {
    var iframe = this.container.getElementById(this.id);
    if (this.isCreated) {
		  // found document
      return iframe.contentWindow.document;
    }
  }
  
  return null;
}

function __menu_move()
{
  if(__curMenuBarItem && document.getElementById(__curMenuBarItem.id).className != "MenuBarItemActive" + __curMenuBarItem.design)
    document.getElementById(__curMenuBarItem.id).className = "MenuBarItemActive" + __curMenuBarItem.design;
  return false;
}


// we have to wait, until pinEdit is loaded
function __menu_delay_load()
{
  var doc;
  try {
    doc = __delay_iframe.contentWindow.document;
  } catch(Error) {
    window.setTimeout('__menu_delay_load()',10);
    return;
  }
  doc.body.innerHTML = __delay_html;
  doc.onmousemove = __menu_move;
}


function __menu_hide()
{
  this.container.getElementById(this.id).style.visibility = "hidden";
  this.blur();
  this.visible = false;
}

// Give focus to the first menu item
function __menu_focus()
{
	this.aMenuItems[0].focus();
}

// Blur all menu items (needed to allow for simultaneous access from the
// keyboard and mouse)
function __menu_blur()
{
	for(i=0; i<this.aMenuItems.length; i++) {
		if( this.aMenuItems[i] instanceof MenuItem) {
			this.aMenuItems[i].blur();
		}
	}
}

function __menu_createitem(text,image,title,value,tag1,tag2)
{
  return new MenuItem(text,image,title,value,tag1,tag2);
}

function __menu_createseparator()
{
  return new MenuSeparator();
}



//---------------------------------------------------------------------------------------------
// MENUITEM
//---------------------------------------------------------------------------------------------
function MenuItem(text,image,title,value,tag1,tag2)
{
  this.id      = "";
  this.callback = "";
  this.text    = text;
  this.title   = title;
  this.image   = image;
  this.enabled = true;
  this.value   = value;
  this.menu    = null;
  this.height  = 22;
  this.tag1    = tag1;
  this.tag2    = tag2;

  // Added focus and blur for keyboard Accessibility
  this.focus		= __menuitem_focus;
  this.blur			= __menuitem_blur;
  
  this.setEnabled   = __menuitem_enable;
  this.create       = __menuitem_create;
  
  // Added for keyboard shortcut functionality
  // Get the next and previous menu items (next = below, previous = above)
  this.getNextSibling   = __menuitem_nextSibling;
  this.getPrevSibling   = __menuitem_prevSibling;
}

// Return the next menuitem in the table, or the first if at the bottom
function __menuitem_nextSibling()
{
	var siblingIndex = 0;
	for(i=0; i < this.menu.aMenuItems.length; i++) {
		if(this.menu.aMenuItems[i].id == this.id) {
			siblingIndex = i + 1;
			break;
		}
	}

	// go to next non-separator
	if (this.menu.aMenuItems[siblingIndex] instanceof MenuSeparator) {
		// skip over separators

		for (i=siblingIndex + 1; i < this.menu.aMenuItems.length; i++) {
			if (!(this.menu.aMenuItems[i] instanceof MenuSeparator)) {
				// found non-separator
				siblingIndex = i;
				break;
			}
		}
	}

	
	// get actual sibling, or first item
	if(siblingIndex < this.menu.aMenuItems.length) {
		return this.menu.aMenuItems[siblingIndex];
	}
	else {
		// no next sibling, go to first menuitem
		return this.menu.aMenuItems[0];
	}
	
}

// Return the previous menuitem in the table, or the last if at the top
function __menuitem_prevSibling()
{
	var siblingIndex = 0;
	for(i=0; i < this.menu.aMenuItems.length; i++) {
		if(this.menu.aMenuItems[i].id == this.id) {
			siblingIndex = i - 1;
			break;
		}
	}
	
	// go to prev non-separator
	if (this.menu.aMenuItems[siblingIndex] instanceof MenuSeparator) {
		// skip over separators

		for (i=siblingIndex - 1; i >= 0; i--) {
			if (!(this.menu.aMenuItems[i] instanceof MenuSeparator)) {
				// found non-separator
				siblingIndex = i;
				break;
			}
		}
	}
	// get actual prev sibling, or last item
	if(siblingIndex >= 0) {
		return this.menu.aMenuItems[siblingIndex];
	}
	else {
		// no previous sibling, go to last menubaritem
		return this.menu.aMenuItems[this.menu.aMenuItems.length - 1];
	}
}

function __menuitem_create()
{
  __curHeight =  __curHeight + this.height;

  var temp = "<table id='" + this.id + "' unselectable='ON' class='MenuItem" + this.menu.design + "' title='" + this.title + "' width='100%' cellSpacing=0 cellPadding=2 border=0";

  if(this.enabled) {
	  // Use onFocus for menubar, use onOver for popup mode
	  if(!this.menu.isPopupMode) {
		  //temp+= " onmouseover='onFocus(this," + this.id + ",\"" + this.menu.design + "\")'";
	  } else {
		  temp+= " onmouseover=onOver(this," + this.id + ",\"" + this.menu.design + "\") ";
	  }
    temp+= " onmouseout='onOut(this," + this.id + ",\"" + this.menu.design + "\")'";
    temp+= " onmouseup=onClick(this," + this.id + ",\"" + this.menu.design + "\",\"" + this.callback + "\")";
	  // Attached onKeyDown event for keyboard accessibility
	  //temp+= " onkeydown='onKeyDown(this," + this.id + ",\"" + this.menu.design + "\",\"" + this.callback + "\")'";
  }
  temp+= ">";
  temp+= "<tr  unselectable='ON'>";
  temp+= "<TD name='test' unselectable='ON' id='" + this.id + ".1'>";
  if(this.image) {
    if(this.image.substring(0,1) == "/" || this.image.toLowerCase().substring(0,4) == "http" || this.image.toLowerCase().substring(0,4) == "file")
      temp+= "<div style='width:25px'><IMG unselectable='ON' src='" + this.image + "'></div>";
    else
      temp+= "<div style='width:25px'><IMG unselectable='ON' src='" + this.image + "'></div>";
  } else {
    // when no text then height is 23 ? Not clear why
    if(browser.ie)
      __curHeight++;
    if(this.menu.imageColumn)
      temp+= "<div style='width:25px'></div>";
  }
  temp+= "</TD>";
  //temp+= "</TR>";

  if(this.enabled)
    temp+= "<TD unselectable='ON' width='100%' id='" + this.id + ".2' class='MenuItemFont" + this.menu.design + "'>" + this.text + "</TD>";
  else
    temp+= "<TD unselectable='ON' width='100%' id='" + this.id + ".2' style='color: #8D8D8D;' class='MenuItemFont" + this.menu.design + "'>" + this.text + "</TD>";

  temp+= "<TD id='" + this.id + ".3'></TD>";

  temp+= "</tr></table>";
  return temp;
}

function __menuitem_enable(value)
{
	this.enabled = value;
}

function __onItemClick(row)
{
  for(var i=0;i<__aAllMenu.length;i++) {
    if(__aAllMenu[i].id == row) {
      if(__aAllMenu[i].menu.callBack != null)
        __curMenuBarItem.reset();
        __aAllMenu[i].menu.hide();
        eval(__aAllMenu[i].menu.callBack + "('" + __aAllMenu[i].value + "')");
        // Added break after calling function to improve performance
        break;
    }
  }
}

// Fire the focus event on this menuitem and set the menu's current
// menu item to this
function __menuitem_focus() 
{
return;

	var doc = this.menu.getDocument();
	var table = doc.getElementById(this.id);
	doc.parentWindow.onFocus(table,this.id,this.menu.design);
	this.menu.__curMenuItem = this;
}

// Fire the blur event on this menuitem and set the menu's current
// menu item to null
function __menuitem_blur() 
{
return;

  try {
    if(browser.ie) {
	    var doc = this.menu.getDocument();
	    var table = doc.getElementById(this.id);
	    doc.parentWindow.onOut(table,this.id,this.menu.design);
	    this.menu.__curMenuItem = null;
    }
  } catch(Error) {}
}

//---------------------------------------------------------------------------------------------
// MENU SEPARATOR
//---------------------------------------------------------------------------------------------
function MenuSeparator()
{
  this.create = __menusep_create;
}

function __menusep_create()
{
  if(browser.ie)
    __curHeight =  __curHeight + 3;
  else
    __curHeight =  __curHeight + 4;

  var temp = "<TABLE style='WIDTH: 100%;height: 1px;' cellSpacing=0 cellPadding=0 border=0>";
      temp+= "<TR>";
      temp+= "<TD style='width:28px'></TD>";
      temp+= "<TD class='MenuSeparator" + this.menu.design + "'>&nbsp;</TD>";
      temp+= "<TD class='MenuSeparator" + this.menu.design + "'>&nbsp;</TD>";
      temp+= "</TR>";
      temp+= "</TABLE>";

  return temp;
}

//---------------------------------------------------------------------------------------------
// KEYBOARD SHORTUCT FUNCTIONS
//---------------------------------------------------------------------------------------------

// Create a new UIShortcut object
function UIShortcut(sText, sAccessKey, sHtml)
{
		
	this.text = sText;
	this.accessKey = sAccessKey;
	this.html = sHtml;
	
	return this;
	
}

// Return a UIShortcut specific to text parameter (value in en.js)
function getUIShortcut(sText)
{
	// init
	var text = sText;
	var accessKey = null;
	var html = sText;
	
	// set attributes for UI Shortcut object & return
	if(sText.match("&") != null) {
		text = text.replace("&", "");
		accessKey = sText.charAt(sText.indexOf("&") + 1);
		html = html.substring(0, html.indexOf("&")) + "<u>" + accessKey + "</u>" + html.substring(html.indexOf("&") + 2);
	}

	return UIShortcut(text, accessKey, html);
}


