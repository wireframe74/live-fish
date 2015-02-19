<%@page import="co.simplypos.model.website.ArticleDetail" %>
<%@page import="co.simplypos.model.website.ArticleDetailImage" %>
<%@page import="co.simplypos.model.website.page.model.StockDetailPageModel " %>
<%@page import="co.simplypos.model.website.page.view.StockDetailPageView" %>
<%@page import="co.simplypos.model.website.HTMLComponents" %>
<%@page import="co.simplypos.model.website.HTMLComponents2" %>
<%@page import="java.util.Iterator" %>
<%@page import="java.io.File" %>
<jsp:useBean id="website" scope="application" class="co.simplypos.model.website.WebSite"><%website.initialise(request.getRequestURL().toString(), application.getRealPath("/"), 170);%></jsp:useBean>
<jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession"><%userSession.initialise(website, request);%></jsp:useBean>

<%StockDetailPageModel pageModel = null;

try {

	pageModel = (StockDetailPageModel) userSession.getWebController().getCurrentPageController().getPageModel();
	StockDetailPageView pageView = (StockDetailPageView) userSession.getWebController().getCurrentPageController().getPageView();
	
	if (userSession == null) {
		out.write("Session has expired, refresh the page.");
	} else {
	
		int qtyInBasket = userSession.getShoppingBasket().getQuantityInBasket(pageModel.getParentVendorArticleId(), pageModel.getVendorArticleId(), pageModel.getVendorArticleClsfnId());%>
		
		<%=HTMLComponents2.getInStockIndicatorHTML(website, pageModel.getQuantity(), qtyInBasket , pageModel.isAllowOutOfStockOrdering(), false)%>
	

		<% if (userSession.hasActiveGiftList() && userSession.getGiftListArticles().contains(new Integer(pageModel.getVendorArticleId())) && userSession.getQuantityRemaining(pageModel.getVendorArticleId(), userSession.getListClassId()) > 0) { %>

				<a href="viewList.jsp?listcode=<%=userSession.getGiftListCode()%>">
					<img align="left" src="<%=website.getImagePath("giftlist.png")%>" alt="Gift List Item" class="height25" /> 

					<%=userSession.getQuantityRemaining(pageModel.getVendorArticleId(), userSession.getListClassId())%> Required for '<%=userSession.getGiftListName()%>'
				</a>

		<% } %> 
	
		<% if (qtyInBasket > 0) { %>
			<%=HTMLComponents2.getQtyInYourBasketHTML(qtyInBasket)%>
		<% }

	}
	
} catch (Exception ee1) { 
	website.writeToLog("Failed to get stock indicator information for: "+(pageModel!=null?pageModel.getVendorArticleId():"[unknown]")+". Reason: "+ee1.getMessage()); 
} 	
%>
