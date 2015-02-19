<%@ page import = "com.pintexx.components.web.pinEdit.*" %>
<jsp:useBean id="website" scope="application" class="co.simplypos.model.website.WebSite"><%website.initialise(request.getRequestURL().toString(), application.getRealPath("/"), 170);%></jsp:useBean>
<jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession"><%userSession.initialise(website, request);%></jsp:useBean>
<%
if (!userSession.isLoggedIn()) { 
	out.write("You must be logged in to use this page!");
	return;
}
String docUrl = request.getScheme() + "://" + request.getServerName() +  request.getContextPath()  + "/";
String docPath = application.getRealPath("").replace('\\','/') + "/";
//out.write("docPath: "+docPath+"   docUrl: "+docUrl+"    "+request.getParameter("PageUrl")+"    "+docPath+co.simplypos.model.utils.helpers.StringHelper.replace(""+request.getParameter("PageUrl"),docUrl,""));
String str = new String(co.simplypos.model.utils.helpers.FileHelper.readSmallFile(new java.io.File(docPath+co.simplypos.model.utils.helpers.StringHelper.replace(""+request.getParameter("PageUrl"),docUrl,""))));
if (str.indexOf("<%") > -1) {
	out.write("Sorry, this file is not suitable for editing with a graphical editor as it contains embedded server-side code. You can however edit this page with the source code editor accessed from the previous index page. Please excercise caution when editing pages containing embedded code, if the server-side code content is not fully understood it may lead to unexpected results or may leave the website inaccessible.");
	return;
}
pinEdit pe = new pinEdit("pinEditID1",docUrl+"editor");
pe.setPositionWidth("100%");
pe.setPositionHeight("100%");
pe.setPageUrl(request.getParameter("PageUrl"));
pe.setReadOnly(false);
pe.setDebugMode(true);
pe.setAbsoluteDocumentUrl(docUrl);
pe.setAbsoluteDocumentPath(docPath);
pe.setAbsoluteTemplateUrl(docUrl);
pe.setAbsoluteTemplatePath(docPath);
// set url/path for autotext (normally use a different folder)
pe.setAbsoluteAutoTextUrl(docUrl);
pe.setAbsoluteAutoTextPath(docPath);
pe.setAjaxSaveUrl("server/jsp/saveadapter.jsp");
pe.setAbsoluteImageUrl(docUrl);
pe.setAbsoluteImagePath(docPath);
pe.setRelativeBaseImageUrl(docUrl);
pe.setRelativeBaseLinkUrl(docUrl);
pe.setHtmlMode(pinEdit.PE_HTMLMODE_BODY);
pe.setLicenseKey("140207143E07144807140201144804144762144801143401143E03");
pe.setToolbar("T01SE03SE65SE73SE04SE05SE76SE64SE66SE06SE07SE08SE61SE77SE09SE10TEDITS49SE11SE60SE12SE13SE14SE15SE16SE17SE62SE57SE67TE;T50SE96TEDI19562021DITS22SE23SE24SE51SE25SE26SE27SE28SE29SE30SE98SE31SE32SE33SE34SE3536TE;T82SE83SE84SE85SE86SE87SE90SE91SE92SE93SE94SE95TEDITS81TEDITS48SE78SE37SE526818SE58SE72TE;B53SE54SE55;L7559383940414243444563464748");
pe.setUserMode(pinEdit.PE_USERMODE_HTML);
%>
<body style="margin:0;overflow:hidden"><%=pe.create()%></body>