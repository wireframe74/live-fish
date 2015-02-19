<jsp:useBean id="website" scope="application" class="co.simplypos.model.website.WebSite"><%website.initialise(request.getRequestURL().toString(), application.getRealPath("/"), 170);%></jsp:useBean><jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession"><%userSession.initialise(website, request);%></jsp:useBean><%
try {
	userSession.setJavascriptEnabled(true);
} catch (Exception ee1) { 
	website.writeToLog("enablejavascript.jsp: "+ee1.getMessage()); 
}
%>