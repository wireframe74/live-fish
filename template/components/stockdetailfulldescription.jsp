<%@page import="co.simplypos.model.website.ArticleDetail" %>
<%@page import="co.simplypos.model.website.ArticleDetailImage" %>
<%@page import="co.simplypos.model.website.page.model.StockDetailPageModel " %>
<%@page import="co.simplypos.model.website.page.view.StockDetailPageView" %>
<%@page import="co.simplypos.model.website.ArticleDetailImage" %>
<%@page import="java.util.Iterator" %>
<%@page import="java.io.File" %>
<jsp:useBean id="website"  scope="application" class="co.simplypos.model.website.WebSite" />
<jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession" />
<%

try {
	StockDetailPageModel pageModel = (StockDetailPageModel) userSession.getWebController().getCurrentPageController().getPageModel();
	//StockDetailPageView pageView = (StockDetailPageView) userSession.getWebController().getCurrentPageController().getPageView();
				

	if (userSession == null) {
		out.write("Session has expired, refresh the page.");
	} else {
%>

		<%=HTMLHelper.applyHTML(pageModel.getFullDescription())%>
		<%@include file="..\..\postFulltext.html"%>

 <%
	}
} catch (Exception ee1) { 
	website.writeToLog("stockdetailfulldescription files: "+ee1.getMessage()); 
} 	
%>
