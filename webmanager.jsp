<jsp:useBean id="website" scope="application" class="co.simplypos.model.website.WebSite"><%website.initialise(request.getRequestURL().toString(), application.getRealPath("/"), 170);%></jsp:useBean>
<jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession"><%userSession.initialise(website, request);%></jsp:useBean><%
try {
	long statusCode = Long.parseLong(""+request.getParameter("status"));
	website.setUploadStatus(statusCode);
	out.write("status code set to "+statusCode);
} catch (Exception ee) {
	out.write("Exception: "+ee.getMessage());
}
%>