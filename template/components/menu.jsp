<%@page import="co.simplypos.model.website.WebSite" %>
<jsp:useBean id="website" scope="application" class="co.simplypos.model.website.WebSite"><%website.initialise(request.getRequestURL().toString(), application.getRealPath("/"), 170);%></jsp:useBean><jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession"><%userSession.initialise(website, request);%></jsp:useBean><%
try {
	if (request.getParameter("id") != null) {
		try {
			website.getArticleMenu().setCurrentCategoryId(Integer.parseInt(request.getParameter("id")));
		} catch (Exception ee) {}
	}
} catch (Exception eee) {
	out.write("Session expired, refresh the page");
}

// 26/02/2009 NRM the following was to see if javascript was enabled to allow the pure ajax menu to operate on non-javascript enabled browsers.
// The pure ajax menu is not currently used as it does not refresh the category page, which affects SEO, therefore a hybrid ajax menu is implemented
// instead which is not reliant on javascript usage, it simply allows for a smaller menu footprint on the page.
if (false && !userSession.hasSetJavascriptEnabled()) { %>
	<noscript><%=website.getArticleMenu().getCSSMenuHTML(0,true,true,false,true)%></noscript>
	<div id="javascriptdiv" style="visible:none"><%=website.getArticleMenu().getCSSMenuHTMLAjax(0,true,true,false)%></div>
<% } else if (true || userSession.isJavascriptEnabled()) { %>
	<%=website.getArticleMenu().getCSSMenuHTMLAjax(0,true,true,false)%>
<% } else { %>
	<noscript><%=website.getArticleMenu().getCSSMenuHTML(0,true,true,false)%></noscript>
<% } %>