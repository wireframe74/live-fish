<%@ page import = "com.pintexx.components.web.pinEdit.*" %>

<%

pinEdit pe = new pinEdit("pinEditID1","/editor");
pe.setPositionWidth("100%");
pe.setPositionHeight("90%");


//pe.setPageUrl("/test_tg.html");

pe.setPageUrl(request.getParameter("PageUrl"));

pe.setReadOnly(false);
pe.setDebugMode(true);

//pe.setEditorUrl("http://web1.ab8.irconnect.co.uk/editor/"); 


//  String docUrl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath()  + "/";
  String docUrl = request.getScheme() + "://" + request.getServerName() +  request.getContextPath()  + "/";

  String docPath = application.getRealPath("").replace('\\','/') + "/";


  pe.setAbsoluteDocumentUrl(docUrl);
  pe.setAbsoluteDocumentPath(docPath);

 pe.setAbsoluteTemplateUrl(docUrl);
  pe.setAbsoluteTemplatePath(docPath);
  // set url/path for autotext (normally use a different folder)
  pe.setAbsoluteAutoTextUrl(docUrl);
  pe.setAbsoluteAutoTextPath(docPath);



 pe.setAjaxSaveUrl("server/jsp/saveadapter.jsp");

//pe.setContextPath("/home/all/irtest/webapps/ROOT"); 
//pe.setContextUrl("http://web1.ab8.irconnect.co.uk/"); 

 pe.setAbsoluteImageUrl(docUrl);
  pe.setAbsoluteImagePath(docPath);

pe.setRelativeBaseImageUrl(docUrl);



%>
<%@ include file="setmode_tg.jsp" %>

<body style="margin:0;overflow:hidden">

<%= pe.create() %>

</body>