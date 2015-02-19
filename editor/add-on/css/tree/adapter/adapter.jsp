<%@ page import="java.io.*" %><% 
  String key       = "";
  String data      = "";
  String sepObject = "&&:";
  String sepLine   = "&&;";
  String root      = this.getServletContext().getRealPath("");
  boolean isError = false;
  String errorMessage = "";
  String xml = "<?xml version=\"1.0\"?><ajax><key>";
  response.setContentType("text/xml");
  //try {
    // get the editor content
    key = request.getParameter("key");
    // add key
    xml = xml + key + "</key>";
    // show the content on console
System.out.println("Key:" + key);
    //---------------------------------------------------------------------------------
    // LIST
    //---------------------------------------------------------------------------------
    if(key.equals("LIST")) {
      xml = xml + "<list>";
      // read path
      String path = request.getParameter("para2");
//System.out.println("Path: " + path);
      // read mode
      String folderOnly = request.getParameter("para3") == null ? "1":"0";
      if(path.equals("ROOT"))
        path = request.getParameter("para1") == null ? "":request.getParameter("para1");
//System.out.println("Path: " + path);
      // read folder
      File file = new File(path);
      File[] list = file.listFiles();
      for(int i=0;i<list.length ; i++) {
        if(list[i].isDirectory()) {
          xml = xml + "<node name=\"" +  list[i].getName() + "\" path=\"" + list[i].getAbsolutePath() + "\" type=\"0\" />";
        }
      }
      if(folderOnly.equals("1")) {
        // read files
        for(int i=0;i<list.length ; i++) {
          if(list[i].isFile()) {
            //String curpath = list[i].getAbsolutePath();
            //String relPath = curpath.substring(root.length() + 1,curpath.length());
            xml = xml + "<node name=\"" +  list[i].getName() + "\" path=\"" + list[i].getAbsolutePath() + "\" type=\"1\" />";
          }
        }
      }
      xml = xml + "</list>";
    }
    //---------------------------------------------------------------------------------
    // RENAME
    //---------------------------------------------------------------------------------
    if(key.equals("RENAME")) {
      String oldName = request.getParameter("para1"); 
      String oldPath = request.getParameter("para2"); 
      String newName = request.getParameter("para3"); 
      //boolean isFolder = request.getParameter("para4").equals("0"); 
      String newPath = oldPath.substring(0, oldPath.length() - oldName.length()) + newName;
System.out.println(oldPath);
System.out.println(newPath);
      // replace file name
      try {
        File oldFile = new File(oldPath);
        File newFile = new File(newPath);
        oldFile.renameTo(newFile);
      } catch(Exception ex) { 
        errorMessage = ex.getMessage();
      }
      xml = xml + "<name>" + newName + "</name>";
      xml = xml + "<path>" + newPath + "</path>";
      xml = xml + "<errormessage>" + errorMessage + "</errormessage>";
    }
    //---------------------------------------------------------------------------------
    // REMOVE
    //---------------------------------------------------------------------------------
    if(key.equals("REMOVE")) {
      String path = request.getParameter("para1"); 
      File file = new File(path);
      try {
        file.delete(); 
      } catch(Exception ex) { 
        errorMessage = ex.getMessage();
      }
      xml = xml + "<errormessage>" + errorMessage + "</errormessage>";
    }
    //---------------------------------------------------------------------------------
    // CREATE
    //---------------------------------------------------------------------------------
    if(key.equals("CREATE")) {
      String path = request.getParameter("para1"); 
      String name = request.getParameter("para2"); 
      boolean isFolder = request.getParameter("para3").equals("0"); 
      File file = new File(path + "\\" + name);
      try {
        file.mkdir();
      } catch(Exception ex) { 
        errorMessage = ex.getMessage();
      }
      xml = xml + "<name>" + name + "</name>";
      xml = xml + "<path>" + path + "\\" + name + "</path>";
      xml = xml + "<errormessage>" + errorMessage + "</errormessage>";
    }
    if(key.equals("COPY")) {
    }
    if(key.equals("MOVE")) {
    }
 // } catch(Exception e) {
 //   isError = true;
 // }
  xml = xml + "</ajax>";
System.out.println(xml);
  out.print(xml);
%>
