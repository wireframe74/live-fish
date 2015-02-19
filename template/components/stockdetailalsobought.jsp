<!-- start of components/stockdetailalsobought.jsp -->
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

		  			final int qtyToShow = website.getNumAlsoBoughtItems();
              			final int guessMarginWidth = 32;

					Vector resultSet = userSession.getArticleDetail().getAlsoBought(pageModel.getVendorArticleId(), userSession.getShoppingBasket().getTransactionId(), qtyToShow);
		  			if (resultSet.size() > 0) { 
            			%>
						<div id="alsobroughtwrapper" class="stocklistingwrapper">
							<div class="stocklistingheader">		
								
							</div>
							<div class="stocklistingbody"><h2><%=website.getAlsoBoughtText()%></h2>
								<%=pageView.getAlsoBoughtArticleList(request, resultSet, qtyToShow, true)%>
							</div>
						</div>
					<% } 
				} catch (Exception ee23) {
					website.writeToLog(ee23);
				}

%>
<!-- end of components/stockdetailalsobought.jsp -->
