<!-- start of components/stockdetaillinkedproducts.jsp -->
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

		  			final int qtyToShow = 20;
					final int numAcross = 2;

					java.util.ArrayList<String> headerText = new java.util.ArrayList<String>();
					Vector resultSet = userSession.getArticleDetail().getLinkedProducts(pageModel.getVendorArticleId(), qtyToShow, headerText);
		  			if (resultSet != null && resultSet.size() > 0) { 
            		%>
						<div id="linkedproductswrapper" class="stocklistingwrapper">
							<div class="stocklistingheader">
								
							</div>
							<div class="stocklistingbody">
								<h2><%=headerText.get(0)%></h2><%=pageView.getLinkedProductsArticleList(request, resultSet, qtyToShow, website.getLinkedProductsNumArticlesAcross(), true)%>
								<div class="clearfix"></div></div>
						
						</div>						
					<% }
				} catch (Exception ee23) {
					website.writeToLog(ee23);
				}
 %>
<!-- end of components/stockdetailalslinkedproducts.jsp -->
