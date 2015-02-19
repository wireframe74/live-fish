<%@ page import="java.io.*" %>
<% 
  //String html = "<span><p>hallo</p></span>";
  //String optimizerPath  = "D:/projects/intern/pinEdit/tidy/tidy-060405-exe/";
  //String tempDir  = (String) request.getParameter("tempdir");

  String html  = (String) request.getParameter("html");
  String optimizerPath  = (String) request.getParameter("path");
  String optimizerParameters = (String) request.getParameter("params");
  String tempDir  = optimizerPath;
  String path = "";
  boolean isError = false;
  int optimizeStatus = 1000;
  long z1 = (long)(Math.random() * 100000000);
  String rndName = Long.toString(z1);

  try {
    path = tempDir + rndName + ".html";
	  FileOutputStream fos = new FileOutputStream(path);
	  fos.write(html.getBytes());
	  fos.close();
  } catch(Exception e) {
    isError = true;
  }

  if(!isError) {
    try {
		  Process p = Runtime.getRuntime().exec(optimizerPath + optimizerParameters + tempDir + rndName + ".html");
  	  p.waitFor();
  	  optimizeStatus = p.exitValue(); 
    } catch(Exception e) {
      optimizeStatus = 0;
    }
  }

  // if optimizer worked
  if(optimizeStatus == 1) {
    try {
      File file = new File(path);
      long len = file.length();
      byte[] data = new byte[(int)len];
      FileInputStream in = new FileInputStream(path);
      in.read(data);
      html = new String(data,0,(int) len);
      in.close();
    } catch(Exception e) {
    }
  }

  // now remove temp file
  try {
    File file = new File(path);
    file.delete(); 
  } catch(Exception e) { 
  }
  
  //<textarea style="height:300px;width:500px"></textarea>
  //out.print(html);
  // don't change this code
  out.print("<html><body onload=\"javascript:parent.__callback_optimizer(document.getElementById('data').value);\"><textarea id='data'>" + html + "</textarea></body></html>");
%>
