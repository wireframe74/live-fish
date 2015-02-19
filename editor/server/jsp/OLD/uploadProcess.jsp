<%@ page import="com.jspsmart.upload.*,java.io.*,java.util.*,java.text.*,org.w3c.dom.*,javax.xml.parsers.*" %>
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" />
<%!
  private Boolean check(String path, String filePath)
  {
      Boolean isAllowed = false;
      String[] allPaths = null;
  //    filePath = filePath.replaceAll("[/]", "\\\\");
      int pos = filePath.indexOf("/editor/");
      filePath = filePath.substring(0,pos);
      java.io.File file = new java.io.File(path);
      String curPath = file.getAbsolutePath();
   //   curPath = curPath.replaceAll("[/]", "\\\\");
      curPath = curPath.toLowerCase();

      try {  
        // check path
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
		//		allPaths[i] = allPaths[i].replaceAll("[/]", "\\\\");
			}
		} catch(Exception ex) {
		}
	
		return allPaths;
	}

  private String[] readLimitFilter(String path)
  {
		String[] allFilter = new String[0];
		
		try {
			java.io.File file = new java.io.File(path);
			DocumentBuilderFactory factory  = DocumentBuilderFactory.newInstance();
			DocumentBuilder        builder  = factory.newDocumentBuilder();
			Document               document = builder.parse(file);
			
			NodeList list = document.getElementsByTagName("limitextension");
			String filter = list.item(0).getAttributes().getNamedItem("value").getNodeValue().toLowerCase();
			allFilter = filter.split(";");
			
		} catch(Exception ex) {
		}
	
		return allFilter;
	}
%>
<%
  String path         = request.getParameter("path");
  String insert       = request.getParameter("insert");
  String sErrorDescription = "";
  boolean isError = false;

  //------------------------------------------------------------------------
  // Security check
  //------------------------------------------------------------------------
  Boolean isAllowed = false;
  String[] allPaths = null;
  String filePath = getServletContext().getRealPath(request.getServletPath());
  int pos = filePath.indexOf("/editor/");
  filePath = filePath.substring(0,pos);
  java.io.File file = new java.io.File(path);
  path = file.getAbsolutePath();

  if(!check(path,getServletContext().getRealPath(request.getServletPath()))) {
    isError = true;
    sErrorDescription = "Access denied ! <br><br>Please configure editor/config/security.xml.";
	}
  //------------------------------------------------------------------------
  // Security check
  //------------------------------------------------------------------------

  try {
    if(path != null && !isError) {
      // Initialization
      mySmartUpload.initialize(pageContext);
      // limit size
      mySmartUpload.setTotalMaxFileSize(500000);
      // Upload
      mySmartUpload.upload();
      if(mySmartUpload.getFiles().getCount() == 1) {
        if(mySmartUpload.getFiles().getFile(0).isMissing()) {
          isError = true;
          sErrorDescription = "Upload failed !";
        } else {
          String fileName = mySmartUpload.getFiles().getFile(0).getFileName();
          //------------------------------------------------------------------------
          // Security check
          //------------------------------------------------------------------------
	        // Filter
          String[] allFilters = readLimitFilter(filePath + "/editor/config/security.xml");
          isAllowed = false;
          for(int i=0;i<allFilters.length;i++) {
            if(fileName.toLowerCase().endsWith(allFilters[i])) {
              isAllowed = true;
            }
          }
          //------------------------------------------------------------------------
          // Security check
          //------------------------------------------------------------------------
	        if(isAllowed) {
            // save file
            mySmartUpload.save(path);
	        } else {
            isError = true;
            sErrorDescription = "<br><br>Filter error ! The uploaded extension is not allowed. <br><br>Please configure editor/config/security.xml.";
	        }
        }
      }      
    }
  } catch(Exception e) {
    isError = true;
    sErrorDescription = e.getMessage();
  }

%>
<html>
<head>
<script>
function closeWindow()
{
  window.close();  
}
</script>
</head>

<% if(!isError) { %>
<%   if(insert.equals("1")) { %>
       <body onload="window.opener.callback_editUpload('<%= mySmartUpload.getFiles().getFile(0).getFileName() %>','<%= (String) request.getParameter("url") %>');window.close()">
<%   } else { %>
       <body onload="window.close()">
<%   } %>
<% } else { %>
       <body>
       <%= "The following error occured while uploading to " + path + ": " + sErrorDescription %>
<% } %>

</body>
<html>