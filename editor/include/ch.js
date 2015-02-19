//-------------------------------------------------------
// CHECK
//-------------------------------------------------------
function checkSlash(param)
{
	 return param.indexOf("\\") >=0 ? true:false;
}

function checkRelPara(param)
{
	if(param.substring(0,1) == "/" || param.substring(param.length - 1,param.length) == "/")
		return true;
		
	return false;
}

// Parameter check
function checkSettings()
{
	var warning = "pinEdit Warning (Parameter Check):\n";
	
	if(globalImageUrlAbsolute != "" && globalImageUrlAbsolute.substring(globalImageUrlAbsolute.length-1,globalImageUrlAbsolute.length) != "/") {
		alert(warning + "Please add an / to globalImageUrlAbsolute !");
		return;
	}
	if(globalDocumentUrlAbsolute != "" && globalDocumentUrlAbsolute.substring(globalDocumentUrlAbsolute.length-1,globalDocumentUrlAbsolute.length) != "/") {
		alert(warning + "Please add an / to globalDocumentUrlAbsolute !");
		return;
	}
  if((globalImageUrlAbsolute == "" && globalImagePathAbsolute != "") || (globalImageUrlAbsolute != "" && globalImagePathAbsolute == "")) {
    alert(warning + "The Url/Path for Images is not properly set: globalImageUrlAbsolute and globalImagePathAbsolute are both needed !");
    return;
  }
  if((globalDocumentUrlAbsolute == "" && globalDocumentPathAbsolute != "") || (globalDocumentUrlAbsolute != "" && globalDocumentPathAbsolute == "")) {
    alert(warning + "The Url/Path for Documents is not properly set: globalDocumentUrlAbsolute and globalDocumentPathAbsolute are both needed !");
    return;
  }

  // check \
	if(checkSlash(globalImageUrlAbsolute)) alert(warning + "Please don't use \\ but / in globalImageUrlAbsolute !");	
	if(checkSlash(globalImagePathAbsolute)) alert(warning + "Please don't use \\ but / in globalImagePathAbsolute !");	
	if(checkSlash(globalDocumentUrlAbsolute)) alert(warning + "Please don't use \\ but / in globalDocumentUrlAbsolute !");	
	if(checkSlash(globalDocumentPathAbsolute)) alert(warning + "Please don't use \\ but / in globalDocumentPathAbsolute !");	
	if(checkSlash(globalTemplateUrlAbsolute)) alert(warning + "Please don't use \\ but / in globalTemplateUrlAbsolute !");	
	if(checkSlash(globalTemplatePathAbsolute)) alert(warning + "Please don't use \\ but / in globalTemplatePathAbsolute !");	
	if(checkSlash(globalRootUrl)) alert(warning + "Please don't use \\ but / in globalRootUrl !");	
	if(checkSlash(globalRootPath)) alert(warning + "Please don't use \\ but / in globalRootPath !");	
	if(checkSlash(globalEditorUrl)) alert(warning + "Please don't use \\ but / in globalEditorUrl !");	
	if(checkSlash(globalImagePathRelative)) alert(warning + "Please don't use \\ but / in globalImagePathRelative !");	
	if(checkSlash(globalLinkPathRelative)) alert(warning + "Please don't use \\ but / in globalLinkPathRelative !");	

	// check documentdir,imagedir
	if(checkRelPara(globalDocDir)) 	alert(warning + "Please don't use / at the beginning or end of globalDocDir !");	
	if(checkRelPara(globalImageDir)) 	alert(warning + "Please don't use / at the beginning or end of globalImageDir !");	

}


//-------------------------------------------------------
// CHECK Intern
//-------------------------------------------------------
function __editCheckRel(param)
{
	if(param == "")
		return "OK";

	// check /
	if(param.substring(0,1) == "/")
		return "Please don't use / at the beginning";

	// check /
	if(param.substring(param.length - 1,param.length) == "/")
		return "Please don't use / at the end";
	
	return "OK";
}

function __editCheckURL(param,rel)
{
	if(param == "")
		return "OK";

	// check http
	if(param.toUpperCase().indexOf("HTTP://") != 0 && param.toUpperCase().indexOf("HTTPS://") != 0 )
		return "Must start with http:// or https://";
	// check \\
	if(param.indexOf("\\") >=0)
		return "Don't use \\ but /";
		
	if(rel)
		return "OK";
			
	// check /
	if(param.substring(param.length - 1,param.length) != "/")
		return "Please use / at the end";
		
	return "OK";
}

function __editCheckPath(param)
{
	if(param == "")
		return "OK";
		
	if(param.substring(1,3) == ":/" || param.substring(0,1) == "/"){
		//void(0);
	} else {
		return "Please use x:/ or / at the beginning (x = drive name i.a.).";
  }
	// check \\
	if(param.indexOf("\\") >=0)
		return "Don't use \\ but / like c:/";
	// check /
	if(param.substring(param.length - 1,param.length) != "/")
		return "Please use / at the end";
		
	return "OK";
}

function __editShowParameters()
{
	var temp = "";
	var baseUrl  = "";
	var basePath = "";
	var color = "";
	
	temp += "<span style='font-family: arial;font-size: 14;font-weight:bold'>pinEdit parameter check</span><br>";
	temp += "<span style='font-family: arial;font-size: 11'>The red marked parameters are wrong.</span><br><br>";

	temp += "<table style='font-family: arial;font-size: 11' cellspacing=0 cellpadding=1 bordercolor='#c0c0c0' border=1 >";
	temp += "<tr><th>Parameter</th><th>Static(Config.js)</th><th>Dynamic(pinEdit.html)</th><th>Value</th><th>Status</th></tr>";
	var check = __editCheckURL(__editGetEditorWeb());
	color = (check != "OK" ? " style='color:red' ":"");
	temp += "<tr><td " + color + "nowrap>Context(application) URL</td><td>globalRootUrl</td><td>cu</td><td " + color + ">" + __editGetEditorWeb() + "</td><td>" + check + "</td></tr>";

	var check = __editCheckPath(globalRootPath);
	color = (check != "OK" ? " style='color:red' ":"");
	if(globalRootPath == "")
	  check = "Needed if open image/doc dialogs are used.";
	temp += "<tr><td nowrap " + color + ">Context(application) path</td><td>globalRootPath</td><td>cp</td><td" + color + ">" + globalRootPath + "</td><td>" + check + "</td></tr>";

	var check = __editCheckURL(__editGetEditorUrl());
	color = (check != "OK" ? " style='color:red' ":"");
	temp += "<tr><td nowrap" + color + ">Editor URL</td><td>globalEditorUrl</td><td>eu</td><td" + color + ">" + __editGetEditorUrl() + "</td><td>" + check + "</td></tr>";
// check domain ?

	var check = __editCheckRel(globalImageDir,true);
	color = (check != "OK" ? " style='color:red' ":"");
	if(globalImageDir=="")
	  check = "Not specified";
	temp += "<tr><td nowrap " + color + ">Relative image path</td><td>globalImageDir</td><td>id</td><td " + color + ">" + globalImageDir + "</td><td>" + check + "</td></tr>";
	var check = __editCheckRel(globalDocDir,true);
	color = (check != "OK" ? " style='color:red' ":"");
	if(globalDocDir=="")
	  check = "Not specified";
	temp += "<tr><td nowrap " + color + ">Relative document path</td><td>globalDocDir</td><td>dd</td><td " + color + ">" + globalDocDir + "</td><td>" + check + "</td></tr>";

  if(globalImageUrlAbsolute == "") {
		baseUrl  = __editGetEditorWeb() + globalImageDir + "/";
		basePath = globalRootPath != "" ?  (globalRootPath + globalImageDir + "/") : "";
  } else {
		baseUrl  = globalImageUrlAbsolute;
		basePath = globalImagePathAbsolute;
  }

	var check = __editCheckURL(baseUrl);
	color = (check != "OK" ? " style='color:red' ":"");
	if(baseUrl=="")
	  check = "Not specified";
	temp += "<tr><td nowrap " + color + ">Image URL(" + (globalImageUrlAbsolute!=""?"Absolute":"Relative") + ")</td><td>globalImageUrlAbsolute<br>or<br>globalRootUrl + globalImageDir</td><td>iua</td><td " + color + ">" + baseUrl + "</td><td>" + check + "</td></tr>";
	var check = __editCheckPath(basePath);
	color = (check != "OK" ? " style='color:red' ":"");
	if(basePath=="")
	  check = "Not specified";
	temp += "<tr><td nowrap " + color + ">Image path(" + (globalImagePathAbsolute!=""?"Absolute":"Relative") + ")</td><td>globalImagePathAbsolute</td><td>ipa</td><td " + color + ">" + basePath + "</td><td>" + check + "</td></tr>";

  if(globalDocumentUrlAbsolute == "") {
		baseUrl  = __editGetEditorWeb() + globalDocDir + "/";
		basePath = globalRootPath != "" ?  (globalRootPath + globalDocDir + "/") : "";
  } else {
		baseUrl  = globalDocumentUrlAbsolute;
		basePath = globalDocumentPathAbsolute;
  }
	var check = __editCheckURL(baseUrl);
	color = (check != "OK" ? " style='color:red' ":"");
	if(baseUrl=="")
	  check = "Not specified";
	temp += "<tr><td nowrap " + color + ">Document URL(" + (globalDocumentUrlAbsolute!=""?"Absolute":"Relative") + ")</td><td>globalDocumentUrlAbsolute<br>or<br>globalRootUrl + globalDocDir</td><td>dua</td><td " + color + ">" + baseUrl + "</td><td>" + check + "</td></tr>";
	var check = __editCheckPath(basePath);
	color = (check != "OK" ? " style='color:red' ":"");
	if(basePath=="")
	  check = "Not specified";
	temp += "<tr><td nowrap " + color + ">Document path(" + (globalDocumentPathAbsolute!=""?"Absolute":"Relative") + ")</td><td>globalDocumentPathAbsolute</td><td>dpa</td><td " + color + ">" + basePath + "</td><td>" + check + "</td></tr>";

	var check = __editCheckURL(globalTemplateUrlAbsolute);
	color = (check != "OK" ? " style='color:red' ":"");
	if(globalTemplateUrlAbsolute=="")
	  check = "Not specified";
	temp += "<tr><td nowrap " + color + ">Template URL(Absolute)</td><td>globalTemplateUrlAbsolute</td><td>tua</td><td " + color + ">" + globalTemplateUrlAbsolute + "</td><td>" + check + "</td></tr>";
	var check = __editCheckPath(globalTemplatePathAbsolute);
	color = (check != "OK" ? " style='color:red' ":"");
	if(globalTemplatePathAbsolute=="")
	  check = "Not specified";
	temp += "<tr><td nowrap " + color + ">Template path(Absolute)</td><td>globalTemplatePathAbsolute</td><td>tpa</td><td " + color + ">" + globalTemplatePathAbsolute + "</td><td>" + check + "</td></tr>";

	var check = __editCheckURL(globalImagePathRelative,true);
	color = (check != "OK" ? " style='color:red' ":"");
	if(globalImagePathRelative=="")
	  check = "Not specified";
	temp += "<tr><td nowrap " + color + ">Relative Image Base</td><td>globalImagePathRelative</td><td>rpi</td><td " + color + ">" + globalImagePathRelative + "</td><td>" + check + "</td></tr>";
	var check = __editCheckURL(globalLinkPathRelative,true);
	color = (check != "OK" ? " style='color:red' ":"");
	if(globalLinkPathRelative=="")
	  check = "Not specified";
	temp += "<tr><td nowrap " + color + ">Relative Link Base</td><td>globalLinkPathRelative</td><td>rpl</td><td " + color + ">" + globalLinkPathRelative + "</td><td>" + check + "</td></tr>";

  temp += "</table>";
	editSetBodyHtml(temp);
};

function __editCreateTBCacheFile()
{
  var width = 800;
  var height = 600;

  if(browser.ie) {
		window.showModalDialog(__editGetEditorUrl() + "config/toolbar_cache.html",window,"dialogHeight:" + height + "px;dialogWidth:" + width + "px;resizable:1;status:0;");
	} else {
    var left = screen.width/2 - width/2;
    var top = screen.height/2 - height/2;
    window.open(__editGetEditorUrl() + "config/toolbar_cache.html","color","modal=1,left=" + left + ",top=" + top + ",height=" + height + ",width=" + width + ",resizable=1,status=0");
	}
}

function __editCreateTBCacheFileData()
{
  var cache = "";
  var temp = "";
  

  cache += "var globalTBCache = new Array();\n\r";
  cache += "globalTBCache[0] = new Array();\n\r";

  // top
  if(toolbarsTop != null) {
    temp = toolbarsTop.getCacheData();
    temp = temp.replace(/\n/gi,"");
    temp = temp.replace(/\r/gi,"");
    temp = temp.replace(/"/gi,"\\\"");
    cache += "globalTBCache[0][0] = \"" + temp + "\";\n\r";
  } else {
    cache += "globalTBCache[0][0] = \"\";\n\r";
  }
  
  // bottom
  if(toolbarsBottom != null) {
    temp = toolbarsBottom.getCacheData();
    temp = temp.replace(/\n/gi,"");
    temp = temp.replace(/\r/gi,"");
    temp = temp.replace(/"/gi,"\\\"");
    cache += "globalTBCache[0][1] = \"" + temp + "\";\n\r";
  } else {
    cache += "globalTBCache[0][1] = \"\";\n\r";
  }

  // side
  if(toolbarsLeft != null) {
    temp = toolbarsLeft.getCacheData();
    temp = temp.replace(/\n/gi,"");
    temp = temp.replace(/\r/gi,"");
    temp = temp.replace(/"/gi,"\\\"");
    cache += "globalTBCache[0][2] = \"" + temp + "\";\n\r";
  } else {
    cache += "globalTBCache[0][2] = \"\";\n\r";
  }
  
  return cache; 
}
