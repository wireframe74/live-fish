<%@ page import="com.jspsmart.upload.SmartUpload,com.pintexx.components.flash.*,java.io.*,java.util.*,java.text.*,org.w3c.dom.*,javax.xml.parsers.*" %>
<%!
  private String[] readLimitPath(String path)
  {
		String[] allPaths = new String[0];
		
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
				allPaths[i] = allPaths[i].replaceAll("[/]", "\\\\");
			}
		} catch(Exception ex) {
		}
	
		return allPaths;
	}

  private Boolean check(String path, String filePath)
  {
      Boolean isAllowed = false;
      String[] allPaths = null;
      filePath = filePath.replaceAll("[/]", "\\\\");
      int pos = filePath.indexOf("\\editor\\");
      filePath = filePath.substring(0,pos);
      java.io.File file = new java.io.File(path);
      String curPath = file.getAbsolutePath();
      curPath = curPath.replaceAll("[/]", "\\\\");
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
%>
<% 
  pinUpload pu = new pinUpload();
  String action = request.getParameter("action");
  String xml = "<?xml version=\"1.0\"?>";
  if(action.equals("parsedir")) {
    response.setContentType("text/xml");
    String dir = request.getParameter("dir");
    if(check(dir,getServletContext().getRealPath(request.getServletPath()))) {
      String displayFiles = request.getParameter("displayfiles");
      xml = xml + pu.createFileList(dir, displayFiles.equals("1") ? true:false);    
    }
    out.print(xml);
  }
  if(action.equals("newfolder")) {
    String path = request.getParameter("path");
    if(check(path,getServletContext().getRealPath(request.getServletPath()))) {
      File file = new File(path);
      try {
        if(file.mkdir())
          out.print("&error=0");
        else
          out.print("&error=1");
      } catch(Exception e) {
        out.print("&error=1");
      }
    }
  }
  if(action.equals("rename")) {
    String oldPath = request.getParameter("oldpath");
    String newPath = request.getParameter("newpath");
    if(check(newPath,getServletContext().getRealPath(request.getServletPath()))) {
      try {
        File oldFile = new File(oldPath);
        File newFile = new File(newPath);
        if(oldFile.renameTo(newFile))
          out.print("&error=0");
        else
          out.print("&error=1");
      } catch(Exception e) {
        out.print("&error=1");
      }
    }
  }
  if(action.equals("remove")) {
    String path = request.getParameter("path");
    if(check(path,getServletContext().getRealPath(request.getServletPath()))) {
      File file = new File(path);
      try {
        if(file.delete())
          out.print("&error=0");
        else
          out.print("&error=1");
      } catch(Exception e) { 
        out.print("&error=1");
      }
    }
  }
  if(action.equals("upload")) {
    String path = request.getParameter("dir");
    if(check(path,getServletContext().getRealPath(request.getServletPath()))) {
      SmartUpload upload = new SmartUpload();
      try {
        upload.initialize(pageContext);
        upload.upload();
        upload.save(path);
      } catch(Exception e) { 
      }
    }
  }
%>
