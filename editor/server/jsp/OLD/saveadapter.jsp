<%@ page import="java.io.*" %>


<%
	//---------------------------------------------------------------------------------
	// Sample implementation for saving files to file system 
	//---------------------------------------------------------------------------------
  String html = "";
  String url  = "";
  String baseUrl  = "";
  String basePath  = "";
  String message = "";
  String filePath = "";

  // we need utf8 encoding
	//request.setCharacterEncoding("UTF-8");

  // get the editor content 
  html = request.getParameter("html");
  // get the editor content 
  url  = request.getParameter("url");
  // get base url
  baseUrl  = request.getParameter("baseurl");
  // get base path
  basePath  = request.getParameter("basepath");

	try {
		// if a new document is created in editor we don't have a url
		// therefore send message to use Save As
		if(url.equals("")) {
			message = "Please use Save As !";
		} else {
			String relPath = url.substring(baseUrl.length());
      // build path
			filePath = basePath + relPath;
			// make it perfect  
			filePath = filePath.replace('\\','/');         //changed tg  swap brack around
 


			// write file
			FileOutputStream fos;
			// write file
			fos = new FileOutputStream(filePath);
			fos.write(html.getBytes());
			fos.close();

			// this message is displayed on the client
			message = "File saved to: " + filePath;
		}
	} catch(Exception e) {
		message = "An error occured while saving to " + filePath + ": " + e.getMessage();
	}
  // don't change this code
  out.print("<html><body onload=\"javascript: parent.__data = document.frmData.data.value;parent.__comm.receive('SAVE');\"><form id='frmData' name='frmData'><TEXTAREA id='data'>" + message + "</TEXTAREA></form></body></html>");
%>
