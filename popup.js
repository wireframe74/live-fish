var popUpWin = false;
var browsertype=false;
if((navigator.appName=="Netscape")&&(parseInt(navigator.appVersion)>=3)) browsertype=true;
if((navigator.appName=="Microsoft Internet Explorer")&&(parseInt(navigator.appVersion)>=4)) browsertype=true;

function e (z, h, w, b, g) {
	document.write('<div style="width:'+w+';height:'+h+';background:white url(http://images.cafepress.com/image/'+z+'_400x400.jpg) no-repeat center center;"><img border="'+b+'" class="imageborder" src="/content/marketplace/img/'+(g?'zoom':'spacer')+'.gif" width="'+w+'" height="'+h+'"></div>')
}

function objectdata(hsize,vsize,hilite,original,messge)
{if(browsertype)
{		this.messge=messge;
		this.simg=new Image(hsize,vsize);
		this.simg.src=hilite;
		this.rimg=new Image(hsize,vsize);
		this.rimg.src=original;
}}



/**
** getURLParam -- get url parameter value
**/
function getURLParam(strParamName){
var strReturn = "";
var strHref = window.location.href;
if ( strHref.indexOf("?") > -1 ){
   var strQueryString = strHref.substr(strHref.indexOf("?")).toLowerCase();
   var aQueryString = strQueryString.split("&");
   for ( var iParam = 0; iParam < aQueryString.length; iParam++ ){
      if (aQueryString[iParam].indexOf(strParamName + "=") > -1 ){
        var aParam = aQueryString[iParam].split("=");
        strReturn = aParam[1];
        break;
      }
   }
}
return strReturn;
}

if (browsertype){
var object=new Array();
//object['home']= new objectdata(56,21,"/cp/info/img/btn_home_on.gif","/cp/info/img/btn_home_off.gif","Home");
//object['sell']= new objectdata(69,21,"/cp/info/img/btn_sell_on.gif","/cp/info/img/btn_sell_off.gif","Sell");
//object['help']= new objectdata(72,21,"/cp/info/img/btn_help_on.gif","/cp/info/img/btn_help_off.gif","Help");
//object['comm']= new objectdata(79,21,"/cp/info/img/btn_comm_on.gif","/cp/info/img/btn_comm_off.gif","Community");
}

function hilite(name)
{if(browsertype)
{//window.status=object[name].messge;
document[name].src=object[name].simg.src;}}

function original(name)
{if(browsertype)
{//window.status="";
document[name].src=object[name].rimg.src;}}

/**
 * launchHelp -> use to pop up all help windows
 **/
function launchHelp(newURL, newFeatures)
{
  if ((navigator.appName=='Microsoft Internet Explorer') && (window.HelpWindow)) HelpWindow.close();
  HelpWindow = open(newURL, "HelpWindow", newFeatures + ",screenX=0,left=0,screenY=0,top=0,channelmode=0,dependent=0,directories=0,fullscreen=0,location=0,menubar=0,resizable=0,status=0,toolbar=0,scroll=1");
  if (HelpWindow.opener == null) HelpWindow.opener = window;
  HelpWindow.focus();
}

function CheckPopup() {
	if (popUpWin) {
		popUpWin.close();
	};
};

/**
 ** launchWin()
 **     use to launch all popup windows besides help
 **/
function launchWin(href, target, params)
{
  var features = params + ',screenX=0,left=0,screenY=0,top=0,channelmode=0,dependent=0,directories=0,fullscreen=0,location=0,menubar=0,resizable=1,status=0,toolbar=0';
  popWin = window.open(href, target, features);
  if (popWin.focus) popWin.focus();
}

//survey code
function openExitSurvey(SurveyURL) {
	if (ShowSurvey) { document.cookie = "ExitSurvey=1;path=/"; ExitSurveyWin = window.open(SurveyURL,'ExitSurveyWin','height=450,width=400",screenX=0,left=0,screenY=0,top=0,channelmode=0,dependent=0,directories=0,fullscreen=0,location=0,menubar=0,resizable=0,status=0,toolbar=0,scroll=1,scrollbars=1'); }


}






//-- CSS Rounded Corners START

function RoundChecker(){
if(!document.getElementById || !document.createElement)
    return(false);
var b=navigator.userAgent.toLowerCase();
if(b.indexOf("msie 5")>0 && b.indexOf("opera")==-1)
    return(false);
return(true);
}

function Round(selector,bk,color,size){
var i;
var v=getElementsBySelector(selector);
var l=v.length;
for(i=0;i<l;i++){
    AddTop(v[i],bk,color,size);
    AddBottom(v[i],bk,color,size);
    }
}

function RoundedTop(selector,bk,color,size){
var i;
var v=getElementsBySelector(selector);
for(i=0;i<v.length;i++)
    AddTop(v[i],bk,color,size);
}

function RoundedBottom(selector,bk,color,size){
var i;
var v=getElementsBySelector(selector);
for(i=0;i<v.length;i++)
    AddBottom(v[i],bk,color,size);
}

function AddTop(el,bk,color,size){
var i;
var d=document.createElement("b");
var cn="r";
var lim=4;
if(size && size=="small"){ cn="rs"; lim=2}
d.className="rtop";
d.style.backgroundColor=bk;
for(i=1;i<=lim;i++){
    var x=document.createElement("b");
    x.className=cn + i;
    x.style.backgroundColor=color;
    d.appendChild(x);
    }
el.insertBefore(d,el.firstChild);
}

function AddBottom(el,bk,color,size){
var i;
var d=document.createElement("b");
var cn="r";
var lim=4;
if(size && size=="small"){ cn="rs"; lim=2}
d.className="rbottom";
d.style.backgroundColor=bk;
for(i=lim;i>0;i--){
    var x=document.createElement("b");
    x.className=cn + i;
    x.style.backgroundColor=color;
    d.appendChild(x);
    }
el.appendChild(d,el.firstChild);
}

function getElementsBySelector(selector){
var i;
var s=[];
var selid="";
var selclass="";
var tag=selector;
var objlist=[];
if(selector.indexOf(" ")>0){  //descendant selector like "tag#id tag"
    s=selector.split(" ");
    var fs=s[0].split("#");
    if(fs.length==1) return(objlist);
    return(document.getElementById(fs[1]).getElementsByTagName(s[1]));
    }
if(selector.indexOf("#")>0){ //id selector like "tag#id"
    s=selector.split("#");
    tag=s[0];
    selid=s[1];
    }
if(selid!=""){
    objlist.push(document.getElementById(selid));
    return(objlist);
    }
if(selector.indexOf(".")>0){  //class selector like "tag.class"
    s=selector.split(".");
    tag=s[0];
    selclass=s[1];
    }
var v=document.getElementsByTagName(tag);  // tag selector like "tag"
if(selclass=="")
    return(v);
for(i=0;i<v.length;i++){
    if(v[i].className==selclass){
        objlist.push(v[i]);
        }
    }
return(objlist);
}

//-- CSS Rounded Corners END





function getCPCookie(name) {
  var dc = document.cookie;
  var prefix = name + "=";
  var begin = dc.indexOf("; " + prefix);
  if (begin == -1) { begin = dc.indexOf(prefix); if (begin != 0) return null; }
  else { begin += 2; }
  var end = document.cookie.indexOf(";", begin);
  if (end == -1) { end = dc.length; }
  return unescape(dc.substring(begin + prefix.length, end));
}

//-- Function loadLongExampleWindow -- ajagtiani, 9/15/04
//-- loads the window for the long example popup in section_edit.aspx
function loadLongExampleWindow(url) {
	launchHelp(url,"height=380,width=550,scrollbars=1");
}

//-- Function loadShortExampleWindow - ajagtiani, 9/15/04
//--   Loads the short Example popup window in section_edit.aspx
function loadShortExampleWindow(url) {
	launchHelp(url,"height=480,width=430,scrollbars=1");
}

//--	Function loadHelpWindow - ajagtiani, 9/15/04
//--	loads help window for section_edit.aspx
function loadHelpWindow(url) {
	launchHelp(url,"height=300,width=400,scrollbars=1");
}

//returns the style of the DIV with the given divname
function getDivStyle(divname) {
 var style;
 if (isDOM) { style = document.getElementById(divname).style; }
 else { style = isIE ? document.all[divname].style
                     : document.layers[divname]; } // NS4
 return style;
}

// annoying detail: IE and NS6 store elt.top and elt.left as strings.
//Moves the given element by the given (X,Y) offset
function moveBy(elt,deltaX,deltaY) {
 elt.left = parseInt(elt.left) + deltaX;
 elt.top = parseInt(elt.top) + deltaY;
}

  //Toggles the visibility of the element with the given name
//If visible, make hidden. If hidden, make visible.
function toggleVisibility(divname,show) {
 var divstyle = document.getElementById(divname).style;
 if (show == 2) {
	divstyle.display='inline';
 } else if (show == 1) {
 	divstyle.display='block';
 } else if (show == 0) {
 	divstyle.display='none';
 }
}

//moveDiv() - moves a DIV to a specified location on an event
function moveDiv(e,divName) {
	var productListDiv = document.getElementById(divName);
	var x,y;

	//If IE, use e.client(x,y) + document.documentBody.scroll(Left/Top), else use e.pageX for Mozilla/Netscape where e is an Event object
	if(!document.all) {
		x = e.pageX;
		y = e.pageY;
	} else {
		x = e.clientX + document.documentElement.scrollLeft;
		y = e.clientY + document.documentElement.scrollTop;
	}

	//add spacing between mouse location and top of DIV location to prevent onmouseout from being executed
	x= x + 15;
	productListDiv.style.top = y + "px";
	productListDiv.style.left = x + "px";
}

//hideDiv() - hide all the products
function hideDiv(divName) {
	var div = document.getElementById(divName);
	div.style.display="none";
	div.innerHTML="";
}

//getType - used with product dropdown box
function getType(thisform) {
	if (thisform.type.options[thisform.type.selectedIndex].value != "") {
		thisform.action = "/"+thisform.s.value;
		thisform.submit();
	}
}

function showhideDiv(divname,disp) {
	document.getElementById(divname).style.display=disp;
}

// IE5 on Mac doesn't like Array.push and therefore
// also doesn't like string.split?
function splitStringToArray(stringToSplit,splitOnChar)
{
	var arr = new Array();
	var idx = 0;
	var start = -1;
	while(idx < stringToSplit.length && idx != -1)
	{
		start++;
		idx = stringToSplit.indexOf(splitOnChar,start);
		if(idx == -1)
		{
			idx = stringToSplit.length;
		}
		arr[arr.length] = stringToSplit.substring(start,idx);
		start = idx;
	}
	return arr;
}


