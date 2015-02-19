<%@ page import="java.io.*,java.util.*,java.text.*,org.w3c.dom.*,javax.xml.parsers.*" %><%!
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
				//allPaths[i] = allPaths[i].replaceAll("[/]", "\\\\");
				allPaths[i] = allPaths[i].replace('\\','/');
			}
		} catch(Exception ex) {
		}
	
		return allPaths;
	}

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
			allPaths[i] = co.simplypos.model.utils.helpers.StringHelper.replace(allPaths[i], "[webpath]", filePath);

		      //if(curPath.startsWith(allPaths[i])) {
			if(curPath.equalsIgnoreCase(allPaths[i])) {

		        isAllowed = true;
		      }
	      }
      } catch(Exception ex) {
      }
      return isAllowed;
  }
%><% 
  String key       = "";
  String data      = "";
  String sepObject = "&&:";
  String sepLine   = "&&;";
  String root      = this.getServletContext().getRealPath("");
  boolean isError = false;
  String errorMessage = "";
  String xml = "<?xml version=\"1.0\"?><ajax><key>";
  response.setContentType("text/xml");
  try {
    // get the editor content
    key = request.getParameter("key");
    // add key
    xml = xml + key + "</key>";
    //---------------------------------------------------------------------------------
    // LIST
    //---------------------------------------------------------------------------------
    if(key.equals("LIST")) {
      String path = request.getParameter("para2");

      xml = xml + "<list>";
	    if(check(path,getServletContext().getRealPath(request.getServletPath()))) {
        // read path
        File file = new File(path);
        File[] list = file.listFiles();
        for(int i=0;i<list.length ; i++) {
          if(list[i].isDirectory()) {
            xml = xml + "<node name=\"" +  list[i].getName() + "\" path=\"" + list[i].getAbsolutePath() + "\" type=\"0\" />";
          }
        }
      }
      xml = xml + "</list>";
    }
    //---------------------------------------------------------------------------------
    // CREATE
    //---------------------------------------------------------------------------------
    if(key.equals("CREATE")) {
      String path = request.getParameter("para1");
      String name = request.getParameter("para2");
      // read path
      try {
        File file = new File(path + "/" + name);
    	  if(check(file.getAbsolutePath(),getServletContext().getRealPath(request.getServletPath()))) {
          file.mkdir();
        }
      } catch(Exception ei) {
        errorMessage = ei.getMessage();
      }
      xml = xml + "<name>" + name + "</name>";
      xml = xml + "<path>" + path + "/" + name + "</path>";
      xml = xml + "<errormessage>" + errorMessage + "</errormessage>";
    }
    //---------------------------------------------------------------------------------
    // RENAME
    //---------------------------------------------------------------------------------
    if(key.equals("RENAME")) {
      String path = request.getParameter("para2");
      String name = request.getParameter("para1");
      String newName = request.getParameter("para3");
      String oldFileName = path + "/" + name; 
      String newFileName = path + "/" + newName;;
      try {
        File oldFile = new File(oldFileName);
        File newFile = new File(newFileName);
    	  if(check(newFile.getAbsolutePath(),getServletContext().getRealPath(request.getServletPath()))) {
          oldFile.renameTo(newFile);
        }
      } catch(Exception ei) {
        errorMessage = ei.getMessage();
      }
      xml = xml + "<name>" + newName + "</name>";
      xml = xml + "<path>" + newFileName + "</path>";
      xml = xml + "<errormessage>" + errorMessage + "</errormessage>";
    }
  } catch(Exception e) {
    //xml = xml + "<error>" + e.getMessage() + "</error>";
  }
  xml = xml + "</ajax>";
  out.print(xml);
%>
