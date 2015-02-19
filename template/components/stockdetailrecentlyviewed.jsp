<!-- start of components/stockdetailrecentlyviewed.jsp -->
<%@page import="co.simplypos.model.website.page.model.StockDetailPageModel" %>
<%@page import="co.simplypos.model.website.page.view.StockDetailPageView" %>
<%@page import="co.simplypos.model.website.page.controller.StockDetailPageController" %>
<%@page import="co.simplypos.model.website.HTMLComponents" %>
<%@page import="java.util.Vector" %>
<jsp:useBean id="website"  scope="application" class="co.simplypos.model.website.WebSite" />
<jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession" />
<%
				try {  
					StockDetailPageModel pageModel = (StockDetailPageModel) userSession.getWebController().getCurrentPageController().getPageModel();
					StockDetailPageView pageView = (StockDetailPageView) userSession.getWebController().getCurrentPageController().getPageView();

		  			final int qtyToShow = website.getNumRecentlyViewedItems();
              			final int guessMarginWidth = 32;

					Vector resultSet = userSession.getArticleDetail().getRecentlyViewed(pageModel.getMasterVendorArticleId(), qtyToShow);
					//out.write("resultSet.size(): "+resultSet.size());
		  			if (resultSet.size() > 0) { 
            			%>						
						<h2><%=website.getRecentlyViewedText()%></h2>
										
									
							
	
						<div id="component_scrollbox">
							<div id="recentlyviewedbody" >
								<%=pageView.getRecentlyViewedArticleList(request, resultSet, qtyToShow, true)%>
							</div>
							<div class="clearfix"></div>
						</div>						
					<% } 
				} catch (Exception ee23) {
					website.writeToLog(ee23);
				}

%>
<!-- end of components/stockdetailrecentlyviewed.jsp -->
