<%@ page import="java.io.*,java.util.*,java.text.*,org.w3c.dom.*,javax.xml.parsers.*" %>

<%!
  private Boolean check(String path, String filePath)
  {
      Boolean isAllowed = false;
      String[] allPaths = null;
      //filePath = filePath.replaceAll("[/]", "\\\\");
      filePath = filePath.replace('\\','/'); 
      //int pos = filePath.indexOf("\\editor\\");
      int pos = filePath.indexOf("/editor/");
      filePath = filePath.substring(0,pos);
      java.io.File file = new java.io.File(path);
      String curPath = file.getAbsolutePath();
      //curPath = curPath.replaceAll("[/]", "\\\\");
      curPath = curPath.replace('\\','/'); 
      curPath = curPath.toLowerCase();

      try {  
        // check path
        //allPaths = readLimitPath(filePath + "\\editor\\config\\security.xml");
        allPaths = readLimitPath(filePath + "/editor/config/security.xml");
	      for(int i=0;i<allPaths.length;i++) {
		      if(curPath.startsWith(allPaths[i])) {
		        isAllowed = true;
		      }
	      }
      } catch(Exception ex) {
      }
      return isAllowed;
  }
  private String[] readLimitPath(String path)
  {
		String[] allPaths = new String[0];
		
		try {
			java.io.File file = new java.io.File(path);
			DocumentBuilderFactory factory  = DocumentBuilderFactory.newInstance();
			DocumentBuilder        builder  = factory.newDocumentBuilder();
			Document               document = builder.parse(file);
			
			NodeList list = document.getElementsByTagName("limitpath");
			allPaths = new String[list.getLength()];
			for(int i=0;i<list.getLength();i++) {
				Node node = list.item(i);
				allPaths[i] = node.getAttributes().getNamedItem("value").getNodeValue().toLowerCase();
				//allPaths[i] = allPaths[i].replaceAll("[/]", "\\\\");
        allPaths[i] = allPaths[i].replace('\\','/'); 
			}
		} catch(Exception ex) {
		}
	
		return allPaths;
	}

  boolean isValidParam(HttpServletRequest request,String paramname) {
    try {
            if( request.getParameter(paramname).equals(null) ){
                    return false;
            } else if(request.getParameter(paramname).equals("")){
                    return false;
            }
    } catch(Exception e){
            return false;
    }
    return true;
  }

  private String getSize(long size)
  {
    // display short and long filesize
    long fileSize =  size;
    long sizeSmall = fileSize / 1024;

    if ( sizeSmall == 0)
      sizeSmall = 1;
    String len = sizeSmall + " KB&nbsp;";
    return len;
  }

  class ExtensionFilter implements FileFilter
  {
    private String[] filters = new String[0];

    public ExtensionFilter(String filter)
    {
      StringTokenizer stFilter = new StringTokenizer(filter,";");
      filters = new String[stFilter.countTokens()];
      int i=0;
      while(stFilter.hasMoreElements()) {
        String temp = (String) stFilter.nextElement();
        filters[i] = temp;
        i++;
      }
    }
    public boolean accept(File dir)
    {
      if(filters.length == 0) {
        return true;
      } else {
        if(dir.isDirectory()) {
          return true;
        } else {
          for(int i=0;i<filters.length;i++) {
            if(dir.getName().toUpperCase().endsWith(filters[i].toUpperCase()) ) {
              return true;
            }
          }
          return false;
        }
      }
    }
  }
%>
<%
  String language = request.getParameter("language");
  String mode     = "";
  String path     = "";
  String rootPath = "";
  String rootUrl  = "";
  String temp     = "";
  String filter   = request.getParameter("filter"); 

  if(isValidParam(request,"pathabs")) {
    mode = request.getParameter("mode");
  }
  
  
  rootUrl  = request.getParameter("urlabs");

  if(isValidParam(request,"pathabs")) {
		rootPath = request.getParameter("pathabs");
	} else {
		// if not specified 
		out.print("Please specify url/path !");
		return;
	}
	  
  path = rootPath;

	// if reloaded  
  if(isValidParam(request,"path")) {
    path = request.getParameter("path");
  }

  //------------------------------------------------------------------------
  // Security check
  //------------------------------------------------------------------------
  if(!check(path,getServletContext().getRealPath(request.getServletPath()))) {
		out.print("Access denied !<br><br>Please configure editor/config/security.xml.");
		return;
	}
  //------------------------------------------------------------------------
  // Security check
  //------------------------------------------------------------------------

  if(mode.equals("REMOVE")) {
    String fileName = request.getParameter("file");
    path = path.replace('\\','/'); 
    if(!path.endsWith("/"))
      path = path + "/";
    File file = new File(path + fileName);
    try {
      if(check(file.getAbsolutePath(),getServletContext().getRealPath(request.getServletPath()))) {
        file.delete(); 
      }
    } catch(Exception e) { }
  }

  if(mode.equals("RENAME")) {
    path = path.replace('\\','/'); 
    if(!path.endsWith("/"))
      path = path + "/";
    String oldFileName = request.getParameter("file"); 
    String newFileName = request.getParameter("file2"); 
    try {
      File oldFile = new File(path + oldFileName);
      File newFile = new File(path + newFileName);
      if(check(newFile.getAbsolutePath(),getServletContext().getRealPath(request.getServletPath()))) {
        oldFile.renameTo(newFile);
      }
    } catch(Exception e) { }
  }

  if(mode.equals("CREATEFOLDER")) {
    String fileName = request.getParameter("file");
    path = path.replace('\\','/'); 
    if(!path.endsWith("/"))
      path = path + "/";
    File file = new File(path + fileName);
    try {
      if(check(file.getAbsolutePath(),getServletContext().getRealPath(request.getServletPath()))) {
        file.mkdir();
      }
    } catch(Exception e) { }
  }

  File[] list = new File[0];
  try {
    list = new File(path).listFiles(new ExtensionFilter(filter));
  } catch(Exception e) {
		out.print("Path does not exists: " + path);
		return;
  }

%>

<html>
<head>
<script language="javascript" src="../../config/international.js"></script>
<script>
var selectedRow = -1;
var selectedType = "";
var mode = "<%=mode %>";
var language = "<%=language %>";
var abspath = "<%=rootPath %>";
var absurl  = "<%=rootUrl %>";

function load()
{
  document.getElementById("lblName").innerHTML = parent.getLanguageString(language,11016);
  document.getElementById("lblSize").innerHTML = parent.getLanguageString(language,11017);
  document.getElementById("lblType").innerHTML = parent.getLanguageString(language,11018);
  document.getElementById("lblChanged").innerHTML = parent.getLanguageString(language,11019);
  parent.onRefreshFileList(getCurrentPath());
}

function clickRow(row,i,type)
{
  selectedRow = i;
  selectedType = type;

  if(type == 'FILE') {
    parent.selectPath(getSelectedPath());
	  parent.setFileName(getFileName());
  } else {
    //parent.selectPath(getSelectedUrl());
	  parent.setFolderName(getFileName());
  }

  var curtable = row.parentNode;
  try {
    for(var i=1;i<curtable.rows.length;i++) {
      curtable.rows[i].cells(1).style.background = "";
      curtable.rows[i].cells(1).style.color = "black";
    }
    row.cells(1).style.background = "Highlight";
    row.cells(1).style.color = "HighlightText";
  } catch(Error) {}

}

// Actions
function onDelete(fileName)
{
  document.getElementById("file").value = fileName;
  document.getElementById("mode").value = "REMOVE";
  document.frmSelect.submit();
}
function onRename(newName,oldName)
{
  document.getElementById("file").value = oldName;
  document.getElementById("file2").value = newName;
  document.getElementById("mode").value = "RENAME";
  document.frmSelect.submit();
}
function onCreateFolder(fileName)
{
  document.getElementById("file").value = fileName;
  document.getElementById("mode").value = "CREATEFOLDER";
  document.frmSelect.submit();
}


function dblClick(row,type)
{
  if(type == 'FOLDER') {
    setCurrentPath(row);
    document.frmSelect.submit();
  }
  if(type == 'FILE') {
    parent.RowDblClick()
  }

}

// if go back button is pressed
function goBack()
{
  var curPath = getCurrentPath();
  curPath = curPath.replace(/\\/gi, "/");

  if(curPath.substring(curPath.length-1,curPath.length) == "/")
    curPath = curPath.substring(0,curPath.length-1);

  var i = curPath.length - 1;
	// remove last folder
  while(curPath.substring(i,i+1) != "/") {
    i=i-1;
  }
  var newPath = curPath.substring(0,i);

  // check if we are on the "root"
  if(newPath.length >= (abspath.length - 1) ) {
    document.getElementById("path").value = curPath.substring(0,i) + "/";
    document.frmSelect.submit();
  }
}

// 
function getSelectedPath()
{
  if(selectedRow >=0) {
    // this is the path
    return document.getElementById("hidRow" + selectedRow).value;
  }
}

// returns the URL of the current selected file/image
function getSelectedUrl()
{
  if(selectedRow >=0) {
    // this is the path
    var path = document.getElementById("hidRow" + selectedRow).value;
		// now build the URL
		var temp = path.substring(abspath.length,path.length);
    temp = temp.replace(/\\/gi, "/");
		path = absurl + temp;
    return path;
  } else {
    return "";
	}
}

// returns current folder URL (without file name)
function getCurrentUrl()
{
	var path = getCurrentPath();
	// now build the URL
	var temp = path.substring(abspath.length,path.length);
  temp = temp.replace(/\\/gi, "/");
	path = absurl + temp;
  return path;
}

// sets the current absolute folder path
function setCurrentPath(row)
{
  document.getElementById("path").value = document.getElementById("hidRow" + row).value;
}

// gets the current absolute folder path
function getCurrentPath()
{
  return document.getElementById("path").value;
}

function getSelectedType()
{
  return selectedType;
}

function getSelectedRow()
{
  return selectedRow;
}

function getFileName()
{
  var curPath = document.getElementById("hidRow" + selectedRow).value;
  curPath = curPath.replace(/\\/gi, "/");
  
  var i=curPath.length -1 ;

  while(curPath.substring(i,i+1) != "/") {
    i=i-1;
  }
  if(curPath.substring(i,i+1) == "/") {
    var ret = curPath.substring(i+1,curPath.length);
    return ret;
  }
}

</script>
</head>

<body style="margin: 2px" onload="load()">

<table style="cursor: Hand;padding-left: 2px; padding-right: 2px;font-family: arial; font-size:11px; font-weight:normal" border="0" cellspacing="0" cellpadding="1" width="100%">
<form name="frmSelect" id="frmSelect" method="POST" action="filelist.jsp?pathabs=<%=rootPath %>&urlabs=<%=rootUrl %>&language=<%=language %>&filter=<%=filter %>">
<input type="hidden" id="path" name="path" value="<%=path %>">
<input type="hidden" id="file" name="file" value="">
<input type="hidden" id="file2" name="file2" value="">
<input type="hidden" id="mode" name="mode" value="">
</form>
    <td colspan="2" align="left" bgcolor="#ECE9D8"><p id="lblName">Name</p></td>
    <td align="right" bgcolor="#ECE9D8"><p id="lblSize">Size</p></td>
    <td align="left" bgcolor="#ECE9D8"><p id="lblType">Type</p></td>
    <td align="left" bgcolor="#ECE9D8"><p id="lblChanged">Changed</p></td>
  <%
    int j=0;
    for(int i=0;i<list.length;i++) {
      if(list[i].isDirectory() && !list[i].isHidden() ) {
        Date d = new Date(list[i].lastModified());
        DateFormat fmt = DateFormat.getDateTimeInstance(DateFormat.SHORT,DateFormat.SHORT );
        String dt = fmt.format(d);
%>
        <tr style="background-color: white" onclick="clickRow(this,<%=j%>,'FOLDER');" ondblclick="dblClick(<%=j%>,'FOLDER')" onmouseover="this.style.background='#ECE9D8';" onmouseout="this.style.background='white';">
          <input type="hidden" id="hidRow<%=j%>" value="<%=list[i].getAbsolutePath() %>">
          <td width="1px"><img src="folder_close.gif" border=0></td>
          <td align="left"><%= list[i].getName() %></td>
          <td align="left"></td>
          <td align="left">Folder</td>
          <td nowrap width="1%" align="left"><%= dt %></td>
        </tr>
<%      j++; %>
<%    } %>
<%  } %>

<%
    for(int i=0;i<list.length;i++) {
      if(!list[i].isDirectory() && !list[i].isHidden() ) {
        Date d = new Date(list[i].lastModified());
        DateFormat fmt = DateFormat.getDateTimeInstance(DateFormat.SHORT,DateFormat.SHORT );
        String dt = fmt.format(d);
%>
        <tr  style="background-color: white" onclick="clickRow(this,<%=j%>,'FILE');" ondblclick="dblClick(<%=j%>,'FILE')" onmouseover="this.style.background='#ECE9D8'" onmouseout="this.style.background='white'">
          <input type="hidden" id="hidRow<%=j%>" value="<%=list[i].getAbsolutePath()  %>">
<% 
	String image = "";
	String ext = list[i].getName().toUpperCase();

	if(ext.endsWith("DOC") ) {
		image = "word.gif";
	} else if(list[i].getName().toUpperCase().endsWith("PDF")) {
		image = "pdf.gif";
	} else if(ext.endsWith("GIF") || ext.endsWith("PNG") || ext.endsWith("JPG")) {
		image = "image.gif";
  } else {
		image = "html.gif";
	}
%>
          <td width="1px"><img src="<%=image %>" border=0></td>
          <td align="left"><%= list[i].getName() %></td>
          <td nowrap align="right"><%= getSize(list[i].length()) %></td>
          <td align="left">File</td>
          <td nowrap width="1%" align="left"><%= dt %></td>
        </tr>
<%      j++; %>
<%    } %>
<%  } %>
</td></tr>
</table>

</body>
</html>
