<%@page import="co.simplypos.model.utils.helpers.HTMLHelper" %>
<%@page import="co.simplypos.model.website.UserSession" %>
<%@page import="co.simplypos.model.website.WebSite" %>
<%@page import="java.io.File" %>
<jsp:useBean id="website"  scope="application" class="co.simplypos.model.website.WebSite" />
<jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession" />
<% try { %>
<% 
	String cacheFileName = HTMLHelper.getCachedPageName(request);
	File cachedFile = new File(website.getWebSitePath()+"cache/page/"+cacheFileName);
out.write("request.getRequestURI(): "+request.getRequestURI());
	if (cachedFile != null && cachedFile.exists()) {
%>
		<jsp:include page="../../cache/page/<%=cacheFileName%>"/>
<%
	} else {
%>
		<jsp:include page="/template/components/sitenavigationgen.jsp" />
<%
		HTMLHelper.writePageToCache(request, website, "/template/components/sitenavigationgen.jsp");
	}
 } catch (Exception ee) { 
	website.writeToLog(ee);
} 
%>