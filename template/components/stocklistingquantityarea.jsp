<%@page import="java.util.ArrayList" %>
<%@page import="co.simplypos.model.website.page.model.StockListingPageModel" %>
<%@page import="co.simplypos.model.website.HTMLComponents2" %>
<%@page import="co.simplypos.model.website.page.controller.StockDetailPageController" %>
<jsp:useBean id="website" scope="application" class="co.simplypos.model.website.WebSite">
	<%website.initialise(request.getRequestURL().toString(), application.getRealPath("/"), 170);%>
</jsp:useBean>
<jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession">
	<%userSession.initialise(website, request);%>
</jsp:useBean><%
ArrayList<Object> params = null;
try {
	String html = "";
	if (userSession == null) {
		html = "Session has expired, refresh the page.";
	} else {
		String type = "";
		int seq = 0;
		if (request.getParameter("type") != null) type = ""+request.getParameter("type");
		if (request.getParameter("seq") != null) seq = Integer.parseInt(""+request.getParameter("seq"));

		params = userSession.getIndexSeqParams(type, seq);

		if (params == null) {
			html = "Session has expired, refresh the page.";
		} else {
			html = HTMLComponents2.getInStockIndicatorAndQtyInBasketHTML(userSession, type, seq, ((Integer)params.get(0)).intValue(), ((Integer)params.get(1)).intValue());
		}
	}
	out.write(html);

} catch (Exception ee1) { 
	out.write("Failed!   Reason: "+ee1.getMessage());
	website.writeToLog("Failed to add to basket for seq: "+(request==null?"null":request.getParameter("productId"))+"  values: "+params +".  Reason: "+ee1.getMessage()); 
} 
%>
