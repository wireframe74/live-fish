var tree;

function onNodeClick()
{
	var node = tree.getSelectedNode();
	alert(node.action);
}


function configTree()
{
var red = "rgb(176,8,95)";
var highlight = "black";
var web       = "/";

tree                 = new Tree();
tree.target          = "frMain";
tree.backcolor       = "#ECE9D8"
tree.selectfontcolor = red; //"rgb(176,8,95)";
tree.highlight       = true;
tree.font            = "Verdana, Arial, Helvetica, sans-serif"
tree.fontsize        = "11px";
tree.folderIcon      = "images/closed.gif";
tree.openFolderIcon  = "images/opened.gif";
tree.isFolderOpenedWhenTextClicked = true;
tree.setIconsBlank();
tree.onNodeClick         = "onNodeClick()";

var node0 = new Node("pinEdit");
node0.fontbold = true;
node0.fontcolor = highlight;
node0.expanded = true;
tree.add(node0);

var node100 = new Node("NEW - pinEdit 3.5","../../doc/features35.html")
node100.fontbold = true;
node100.fontcolor = "red";
node0.add(node100);

var node2 = new Node("New samples in 3.5");
node2.fontbold = true;
node2.fontcolor = highlight;
node2.expanded = true;
node0.add(node2);

var node102 = new Node("2 in one - pinToolbar integrated");
//node102.fontbold = true;
//node102.fontcolor = highlight;
node102.expanded = true;
node2.add(node102);

node102.add(new Node("pinToolbar integration","../../samples/3.5/pinToolbar.html"));
if(is.ie)
node102.add(new Node("1 toolbar with 2 editors","../../samples/3.5/editor2toolbar1.html"));
node2.add(new Node("Hierarchy bar","../../samples/3.5/hierarchybar.html"));
node2.add(new Node("Templates","../../samples/3.5/templates.html"));
if(is.ie)
node2.add(new Node("Flash/Media support","../../samples/3.5/media.html"));

var node100 = new Node("Changes in 3.5","../../doc/changes35.html")
//node100.fontbold = true;
node100.fontcolor = "red";
node0.add(node100);

var node1 = new Node("pinEdit Interfaces");
node1.fontbold = true;
node1.fontcolor = highlight;
//node1.expanded = true;
node0.add(node1);

node1.add(new Node("Technology","../../doc/standard.html"));
node1.add(new Node("ASP.Net","../../doc/aspnet.htm"));
node1.add(new Node(".Net WinForm/ActiveX","../../doc/winform.html"));
node1.add(new Node("ASP","../../doc/standard.html"));
node1.add(new Node("Java","../../doc/java.html"));
node1.add(new Node("JSP Tag Library","../../doc/taglib.html"));
node1.add(new Node("PHP","../../doc/standard.html"));
node1.add(new Node("Casabac GUI Server","../../doc/standard.html"));
node1.add(new Node("Others","../../doc/standard.html"));

var node2 = new Node("New - Tutorial for ASP,JSP,PHP");
node2.fontbold = true;
node2.fontcolor = highlight;
//node2.expanded = true;
node0.add(node2);

node2.add(new Node("Step 1 - Add editor/toolbar","../../tutorial/step1.html"));
node2.add(new Node("Step 2 - Add pinToolbarInterface.js","../../tutorial/step2.html"));
node2.add(new Node("Step 3 - Modify toolbar","../../tutorial/step3.html"));
node2.add(new Node("Step 4 - Call function after load","../../tutorial/step4.html"));
node2.add(new Node("Step 5 - Use entire page","../../tutorial/step5.html"));
node2.add(new Node("Step 6 - Read/Post data","../../tutorial/step6.jsp"));

var node2 = new Node("pinEdit Samples (build-in toolbar)");
node2.fontbold = true;
node2.fontcolor = highlight;
node2.expanded = true;
node0.add(node2);

var node3 = new Node("Common");
node3.fontbold = true;
node3.fontcolor = highlight;
node2.add(node3);

node3.add(new Node("pinSpell - Spell checker add-on","../../../editor/pinEdit.html?tb=T64&url=../evaluation/samples/common/spell.html&me=0"));
node3.add(new Node("Menu (only with built-in toolbar)","../../../editor/pinEdit.html?url=../evaluation/doc/menu.html"));
node3.add(new Node("Localization","../../samples/common/language.html"));
node3.add(new Node("Upload documents/images","../../../editor/pinEdit.html?me=0&tb=T026612&url=../evaluation/samples/common/image.html"));
if(!is.ns)
  node3.add(new Node("Editing with context menus","../../../editor/pinEdit.html?url=../evaluation/samples/common/context.html"));
if(!is.ns)
  node3.add(new Node("Table editing","../../../editor/pinEdit.html?url=../evaluation/samples/common/table.html"));
if(!is.ns)
  node3.add(new Node("Links,anchors,bookmarks","../../../editor/pinEdit.html?url=../evaluation/samples/common/anchor.html"));
if(!is.ns)
  node3.add(new Node("XHTML","../../samples/common/xhtml.html"));
if(!is.ns)
  node3.add(new Node("Non editing areas","../../../editor/pinEdit.html?url=../evaluation/samples/common/selection.html"));

if(!is.ns) {
  var node3 = new Node("Toolbar/Menu");
  node3.fontbold = true;
  node3.fontcolor = highlight;
  node2.add(node3);

  node3.add(new Node("Different Styles","../../samples/common/style.html"));
  node3.add(new Node("Toolbar design","../../samples/common/toolbar.html"));
  node3.add(new Node("User configuration","../../../editor/pinEdit.html?url=../evaluation/samples/common/usertoolbar.html&UC=USER"));
}

if(!is.ns6) {
  var node3 = new Node("File based");
  node3.fontbold = true;
  node3.fontcolor = highlight;
  node2.add(node3);

  node3.add(new Node("Integration in an existing page ","../../samples/common/integration.html"));
}

var node3 = new Node("Form based");
node3.fontbold = true;
node3.fontcolor = highlight;
node2.add(node3);

node3.add(new Node("Web form","../../samples/common/form.html"));
node3.add(new Node("Loading html content","../../samples/read_and_save/readandpostcontent.jsp"));
node3.add(new Node("2 editors","../../samples/read_and_save/readandpostcontent2editors.jsp"));
if(!is.ns6)
  node3.add(new Node("Form designer","../../../editor/pinEdit.html?url=../evaluation/samples/common/formdesigner.html"));

if(is.ie){
var node3 = new Node("Style Sheet Support");
node3.fontbold = true;
node3.fontcolor = highlight;
node2.add(node3);
node3.add(new Node("Auto detect","../../../editor/pinEdit.html?url=../evaluation/samples/common/stylesheet.html&tb=T1956;B535455&hm=2&me=0"));
node3.add(new Node("Assign to objects","../../../editor/pinEdit.html?url=../evaluation/samples/common/stylesheet2.html&tb=T19;B535455&hm=2&me=0"));
}
var node3 = new Node("Objects");
node3.fontbold = true;
node3.fontcolor = highlight;
node2.add(node3);

node3.add(new Node("Absolute positioning","../../../editor/pinEdit.html?tb=T3839404142434445464748&url=../evaluation/samples/common/absolute.html&me=0"));
if(!is.ns6)
  node3.add(new Node("Multiple select","../../../editor/pinEdit.html?tb=T48&url=../evaluation/samples/common/multiple.html&me=0"));
if(!is.ns6)
  node3.add(new Node("Objects","../../../editor/pinEdit.html?url=../evaluation/samples/common/objects.html&hm=2&me=0"));
node3.add(new Node("Javascript","../../../editor/pinEdit.html?url=../evaluation/samples/common/javascript.html&hm=2&me=0"));

if(!is.ns6) {
  var node4 = new Node("Extensions(Java,.Net,PHP)");
  node4.fontbold = true;
  node4.fontcolor = highlight;
  node2.add(node4);

  node4.add(new Node("Intellisense(Auto popup)","../../../editor/pinEdit.html?is=.&url=../evaluation/samples/common/intelli.html"));
  node4.add(new Node("Open/Save/Save As with dialog","../../../editor/pinEdit.html?tb=T020365&me=0"));
  node4.add(new Node("Text snippets","../../../editor/pinEdit.html?tb=T49505152&url=../evaluation/samples/common/textmodules.html&me=0"));
}

/*
if(!is.ns6) {
  var node60 = new Node("Cross Product Samples (pinWin)");
  node60.fontbold = true;
  node60.fontcolor = highlight;
  node0.add(node60);
  node60.add(new Node("Multi Document System","http://www.pintexx-demo.de/pinWin/client/pinWin.html?page=multiple.xml"));
}
*/

/*
var node63 = new Node("pinEdit Applications");
node63.fontbold = true;
node63.fontcolor = highlight;
node0.add(node63);
node63.add(new Node("Knowledgebase System","http://www.casabacdemo.com/release25/casabacforum"));
*/

/*
var node61 = new Node("Integration/Development");
node61.fontbold = true;
node61.fontcolor = highlight;
node0.add(node61);

var node62 = new Node("Integration","../doc/pinEditStartup.pdf");
node61.add(node62);

node61.add(new Node("Calling API functions","../doc/functions.html"));
node61.add(new Node("Client API (Javascript)","../doc/api.html"));
*/

var node8 = new Node("pinEdit Docs");
node8.fontbold = true;
node8.fontcolor = highlight;
//node8.expanded = true;
node0.add(node8);

node8.add(new Node("pinEdit Getting Started","../../doc/pinEditStartup.pdf"));
node8.add(new Node("pinEdit Data Sheet","../../doc/pinEditDataSheet.pdf"));
node8.add(new Node("pinEdit Manual","../../doc/pinEditManual.pdf"));

var node15 = new Node("Download pinEdit");
node15.fontbold = true;
node15.fontcolor = "blue";
node15.expanded = true;
tree.add(node15);

node15.add(new Node("pinEdit Evaluation","http://www.pintexx.com/application/products/development/pinEdit/download_files.html"));

var node16 = new Node("Purchase pinEdit");
node16.fontbold = true;
node16.fontcolor = "blue";
node16.expanded = true;
tree.add(node16);

node16.add(new Node("Licencing","http://www.pintexx.com/application/products/development/pinEdit/preise.html"));
node16.add(new Node("Purchase","http://www.pintexx.com/application/products/order.html"));

tree.draw();

}