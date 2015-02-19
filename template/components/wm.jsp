<jsp:useBean id="website" scope="application" class="co.simplypos.model.website.WebSite"><%website.initialise(request.getRequestURL().toString(), application.getRealPath("/"), 170);%></jsp:useBean>
<jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession"><%userSession.initialise(website, request);%></jsp:useBean><%
try {
	String agent = request.getHeader("USER-AGENT");
	//out.write("(["+agent+"])");
	if (agent.toLowerCase().indexOf("java") == -1) {
		out.write("not supported!");
	} else {
		if (request.getParameter("requeststatus") != null && request.getParameter("requeststatus").equals("1")) {
			out.write("{["+website.getUploadStatus()+"]}");
		} else {
			long statusCode = Long.parseLong(""+request.getParameter("status"));
			website.setUploadStatus(statusCode);
			out.write("status code set to "+statusCode);
		}
	}
} catch (Exception ee) {
	out.write("Exception: "+ee.getMessage());
}
%>