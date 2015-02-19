<%@page import="java.util.ArrayList" %>
<%@page import="co.simplypos.model.website.page.model.StockListingPageModel" %>
<%@page import="co.simplypos.model.website.page.controller.StockDetailPageController" %>
<jsp:useBean id="website" scope="application" class="co.simplypos.model.website.WebSite"><%website.initialise(request.getRequestURL().toString(), application.getRealPath("/"), 170);%></jsp:useBean><jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession"><%userSession.initialise(website, request);%></jsp:useBean><%
ArrayList<Object> params = null;
try {
	//StockListingPageModel pageModel = (StockListingPageModel) userSession.getWebController().getCurrentPageController().getPageModel();


	userSession.getWebController().getCurrentPageController().getPageModel().setValidationMessage(null);


	//website.writeToLog("stocklistingaddtobasket: top");

	String type = "";
	int seq = 0;
	if (request.getParameter("type") != null) type = ""+request.getParameter("type");

	try {
		if (request.getParameter("seq") != null) seq = Integer.parseInt(""+request.getParameter("seq"));
	} catch (Exception ee34) { seq = 0; }

	int qty = 1;
	if (request.getParameter("qty") != null) {
		try {
			qty = Integer.parseInt(""+request.getParameter("qty"));
		} catch (Exception ee34) { qty = 1; }
	}

	int vaId = 0;
	try {
		if (request.getParameter("vaId") != null) vaId = Integer.parseInt(""+request.getParameter("vaId"));
	} catch (Exception ee34) { vaId = 0; }

	//website.writeToLog("stocklistingaddtobasket: vaId: "+vaId);


	if (userSession != null) params = userSession.getIndexSeqParams(type, seq);


	if (params == null) {
		out.write("Session has expired, refresh the page.");
	} else {
		int parentVendorArticleId = ((Integer)params.get(0)).intValue();
		int vendorArticleId = ((Integer)params.get(1)).intValue();
		int vendorArticleClsfnId = ((Integer)params.get(2)).intValue();

		//website.writeToLog("stocklistingaddtobasket: vaId: "+vendorArticleId+"    parentVendorArticleId: "+parentVendorArticleId+"    vendorArticleClsfnId: "+vendorArticleClsfnId+"      ((Integer)params.get(0)).intValue(): "+((Integer)params.get(0)).intValue());


		if (vendorArticleId != vaId) {
			throw new Exception("The session data has changed, possibly caused by access from another browser tab. Please refresh the page.");
		}


		int outOfStockOrdering = website.isAllwaysAllowSalesOfOutOfStockItems()?1:0;
		//System.out.println("---------------------------");
		//System.out.println("---- outOfStockOrdering: "+outOfStockOrdering);
		//System.out.println("---------------------------");

		//StockDetailPageController.addToShoppingBasket(userSession, ((Integer)params.get(0)).intValue(), vendorArticleId, ((Integer)params.get(2)).intValue(), qty, 0, 0, "", ((Integer)params.get(2)).intValue());
		StockDetailPageController.addToShoppingBasket(userSession, parentVendorArticleId, vendorArticleId, vendorArticleClsfnId , qty, 0, 0, "", outOfStockOrdering);

		//out.write(HTMLComponents.getInStockIndicatorAndQtyInBasketHTML(userSession, type, seq, ((Integer)params.get(0)).intValue(), ((Integer)params.get(1)).intValue()));
		userSession.getShoppingBasket().recalcTotalAmount(userSession.getExchangeRate());

		userSession.getShoppingBasket().setAlsoBoughtInvalidated(true);

		//website.writeToLog("stocklistingaddtobasket: end");

	}
} catch (Exception ee1) { 
	website.writeToLog(ee1);
	try {
		userSession.getWebController().getCurrentPageController().getPageModel().setValidationMessage(ee1.getMessage()); 
	} catch (Exception ee1a) {
		out.write("Failed!   Reason: "+ee1a.getMessage());
		website.writeToLog("Failed to add to basket for seq: "+(request==null?"null":request.getParameter("productId"))+"  values: "+params+".  Reason: "+ee1a.getMessage());
	}
%>
	<script type="text/javascript">window.location.hash = "#pagevalidationmessageajax";</script>
<%
} 
%>
