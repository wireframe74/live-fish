<%@page import="co.simplypos.model.website.ArticleDetail" %>
<%@page import="co.simplypos.model.website.ArticleDetailImage" %>
<%@page import="co.simplypos.model.website.page.model.StockDetailPageModel " %>
<%@page import="co.simplypos.model.website.page.view.StockDetailPageView" %>
<%@page import="co.simplypos.model.website.ArticleDetailImage" %>
<%@page import="co.simplypos.model.utils.helpers.HTMLHelper" %>
<%@page import="co.simplypos.model.utils.Pair" %>
<%@page import="co.simplypos.model.website.tracking.Feefo" %>
<%@page import="java.util.Iterator" %>
<%@page import="java.io.File" %>
<%@page import="java.util.ArrayList" %>
<jsp:useBean id="website" scope="application" class="co.simplypos.model.website.WebSite"><%website.initialise(request.getRequestURL().toString(), application.getRealPath("/"), 170);%></jsp:useBean><jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession"><%userSession.initialise(website, request);%></jsp:useBean><%
try {
	String fullText = "";

	StockDetailPageModel pageModel = null;
	StockDetailPageView pageView = null;
	try {
		pageModel = (StockDetailPageModel) userSession.getWebController().getCurrentPageController().getPageModel();
		pageView = (StockDetailPageView) userSession.getWebController().getCurrentPageController().getPageView();

		if (request.getParameter("imageVaId") == null) {
			fullText = HTMLHelper.applyHTML(pageModel.getFullDescription(),false,true);
		} else {
			try {
				int imageVaId = Integer.parseInt(request.getParameter("imageVaId"));
				if (imageVaId > 0) {
				
					String imageFullText = userSession.getArticleDetail().getFullText(imageVaId);
					if (imageFullText != null && !imageFullText.trim().equals("")) {
						fullText = HTMLHelper.applyHTML(imageFullText,false,true);
					} else {
						fullText = HTMLHelper.applyHTML(pageModel.getFullDescription(),false,true);
					}
				} else {
					fullText = HTMLHelper.applyHTML(pageModel.getFullDescription(),false,true);
				}
			} catch (Exception ees33) {
				ees33.printStackTrace();
				fullText = HTMLHelper.applyHTML(pageModel.getFullDescription(),false,true);
			}
		}




	} catch (Exception ee1) { 
		fullText = "<i>[Back button pressed or session has expired, please refresh or reload the current page (F5 key)]</i>";
	} 

	ArrayList<Pair> fullTextTabs = HTMLHelper.getTabsWithinFullText(website, fullText);
	int numExtraFullTextTabs = 0;
	if (fullTextTabs != null) numExtraFullTextTabs = fullTextTabs.size() - 1;

	int tab = 1;
	if (request.getParameter("tab") != null) {
		try {
			tab = Integer.parseInt(""+request.getParameter("tab"));
		} catch (NumberFormatException nfe) {
			tab = 1;
		}
	}
	if (tab==0) tab=1;
	if (userSession == null) {
		out.write("Session has expired, refresh the page.");
	} else {
 %>
			<div id="tabsholder">
				
				<ul class="tabs">
					<% for (int i=0;i<fullTextTabs.size();i++) { %>
						<li class="componentBorder"><div id="<%=(tab==(1+i)?"tabcurrent":"")%>" class="tab"><a href="javascript://nop/" onClick="<%=(tab!=(1+i)?"updateTabs("+(1+i)+"); return false;":"")%>"><span><%=(fullTextTabs!=null&&fullTextTabs.get(i)!=null?fullTextTabs.get(i).get(0):"[Unknown]")%></span></a></div></li>
					<% } %>
					<li class="componentBorder"><div id="<%=(tab==(2+numExtraFullTextTabs)?"tabcurrent":"")%>" class="tab"><a href="javascript://nop/" onClick="<%=(tab!=(2+numExtraFullTextTabs)?"updateTabs("+(2+numExtraFullTextTabs)+"); return false;":"")%>"> <span><%=(website.isUseShortNamesOnProductTabs()?"Delivery":"Delivery Details")%></span></a></div></li>
					<li class="componentBorder"><div id="<%=(tab==(3+numExtraFullTextTabs)?"tabcurrent":"")%>" class="tab"><a href="javascript://nop/" onClick="<%=(tab!=(3+numExtraFullTextTabs)?"updateTabs("+(3+numExtraFullTextTabs)+"); return false;":"")%>"> <span><%=(website.isUseShortNamesOnProductTabs()?"Returns":"Our Returns Policy")%></span></a></div></li>
					<% if (Feefo.isFeefoEnabled(userSession)) { %>
						<li class="componentBorder"><div id="<%=(tab==(5+numExtraFullTextTabs)?"tabcurrent":"")%>" class="tab"><a href="javascript://nop/" onClick="<%=(tab!=(5+numExtraFullTextTabs)?"updateTabs("+(5+numExtraFullTextTabs)+"); return false;":"")%>"><span>Reviews</span></a></div></li>
					<% } %>
				</ul>
				<div class="tab_container componentBorder">

						<% if (tab <= (1+numExtraFullTextTabs)) { %>
							<%=(fullTextTabs!=null&&fullTextTabs.get(tab-1)!=null?fullTextTabs.get(tab-1).get(1):"")%>
						<% } else if (tab == (2+numExtraFullTextTabs)) { %>
							<jsp:include page="../../productpagetab2.jsp" />
						<% } else if (tab == (3+numExtraFullTextTabs)) { %>
							<jsp:include page="../../productpagetab3.jsp" />
						<% } else if (tab == (4+numExtraFullTextTabs)) { %>
							<jsp:include page="../../productpagetab4.jsp" />
						<% } %> 

						<% if (Feefo.isFeefoEnabled(userSession)) { 
							   if (tab == (5+numExtraFullTextTabs)) { %>
								<div id="productpagetab5active">
							<% } else { %>
								<div id="productpagetab5inactive">
							<% } %>
								<jsp:include page="../../productpagetab5.jsp" />
								</div>				
						<% } %>
				</div>
			</div>
 <%
	}
} catch (Exception ee1) { 
	website.writeToLog("stockdetailtabarea.jsp failed: "+ee1.getMessage()); 
	website.writeToLog(ee1); 
} 	
%>
