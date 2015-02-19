<%@ page import = "com.pintexx.components.web.pinStyle.*" %>

<%
  pinStyle ps = new pinStyle();
  ps.setLanguage(request.getParameter("language"));
  ps.setDesign(request.getParameter("design"));
  ps.setTechnology(request.getParameter("tech"));
  if(request.getParameter("url") != null)
    ps.setUrl(request.getParameter("url"));
  if(request.getParameter("path") != null)
    ps.setPath(request.getParameter("path"));
  if(request.getParameter("file") != null)
    ps.setFileName(request.getParameter("file"));
  
  //-----------------------------------------------
  // LICENSEKEY
  //-----------------------------------------------
  ps.setLicenseKey("");

  ps.create(response); 
%>


