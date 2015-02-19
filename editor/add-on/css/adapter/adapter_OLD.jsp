<%@ page import="java.io.*,java.util.*,java.text.*,org.w3c.dom.*,javax.xml.parsers.*" %>
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
        allPaths = readLimitPath(filePath + "\\editor\\config\\security.xml");
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
String key  = (String) request.getParameter("key");
String path = (String) request.getParameter("path");

//-----------------------------------------------------------------------------------
// Security Check
//-----------------------------------------------------------------------------------
if(!check(path,getServletContext().getRealPath(request.getServletPath()))) {
  return;
}
if(!path.toLowerCase().endsWith(".css")) {
  return;
}
//-----------------------------------------------------------------------------------
// Security Check
//-----------------------------------------------------------------------------------

try {
  if (key.equals("read")) {
    File file = new File(path);
    long len = file.length();
    byte[] data = new byte[(int)len];
    FileInputStream in = new FileInputStream(path);
    in.read(data);
    out.print(new String(data,0,(int) len));
  } else if(key.equals("write")) {
    String css = (String) request.getParameter("css");
	  FileOutputStream fos = new FileOutputStream(path);
	  fos.write(css.getBytes());
	  fos.close();
  }
} catch (Exception e) {
}
%>