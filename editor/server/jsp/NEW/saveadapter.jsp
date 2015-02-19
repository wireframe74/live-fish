<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.text.*,org.w3c.dom.*,javax.xml.parsers.*" %>
<jsp:useBean id="website"  scope="application" class="co.simplypos.model.website.WebSite" />
<%!
  private Boolean check(String path, String filePath, co.simplypos.model.website.WebSite website)
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
			allPaths[i] = co.simplypos.model.utils.helpers.StringHelper.replace(allPaths[i], "[webpath]", filePath);
		       //if(curPath.startsWith(allPaths[i])) {
			if(curPath.equalsIgnoreCase(allPaths[i])) {
		        	isAllowed = true;
		      }
	      }
      } catch(Exception ex) {
		website.writeToLog(ex);
      }
      return isAllowed;
  }
  private String[] readLimitPath(String path)
  {
		String[] allPaths = new String[0];
		String message  = "";
		try {
			File file = new File(path);
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

  private String[] readLimitFilter(String path)
  {
		String[] allFilter = new String[0];
		
		try {
			File file = new File(path);
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

  if(!check(basePath,getServletContext().getRealPath(request.getServletPath()),website)) {
    message = "Sorry, access is currently restricted to the chosen folder."; //Access denied. Please configure seditor/config/security.xml.";
    out.print("<html><body onload=\"javascript: parent.__data = document.frmData.data.value;parent.__comm.receive('SAVE');\"><form id='frmData' name='frmData'><TEXTAREA id='data'>" + message + "</TEXTAREA></form></body></html>");
		return;
	}

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
			filePath = filePath.replace('\\','/'); 

			// backup
			try {
				File backupFolder = new File(website.getWebSitePath()+"template/_auto_backup_style_edits");
				File backupFile = new File(website.getWebSitePath()+"template/_auto_backup_style_edits/bak_"+System.currentTimeMillis()+"_"+relPath);
				if (!backupFolder.exists()) {
					backupFolder.mkdir();
				}
				co.simplypos.model.utils.helpers.FileHelper.fileCopy(new File(filePath),backupFile);
			} catch (Exception ee) {
				// no backup - ignore
			}			

			// write file
			FileOutputStream fos;
			// write file
			fos = new FileOutputStream(filePath);
			fos.write(html.getBytes());
			fos.close();

			// this message is displayed on the client
			message = "Successfully saved "+new File(filePath).getName(); // to: " + new File(filePath).getName();
		}
	} catch(Exception e) {
		message = "An error occured while saving to " + filePath + ": " + e.getMessage();
	}
  // don't change this code
  out.print("<html><body onload=\"javascript: parent.__data = document.frmData.data.value;parent.__comm.receive('SAVE');\"><form id='frmData' name='frmData'><TEXTAREA id='data'>" + message + "</TEXTAREA></form></body></html>");
%>
