<%@page import="co.simplypos.model.website.ArticleDetail" %>
<%@page import="co.simplypos.model.website.ArticleDetailImage" %>
<%@page import="co.simplypos.model.website.page.model.StockDetailPageModel " %>
<%@page import="co.simplypos.model.website.page.view.StockDetailPageView" %>
<%@page import="co.simplypos.model.website.HTMLComponents" %>
<%@page import="java.util.Iterator" %>
<%@page import="java.io.File" %>
<jsp:useBean id="website" scope="application" class="co.simplypos.model.website.WebSite"><%website.initialise(request.getRequestURL().toString(), application.getRealPath("/"), 170);%></jsp:useBean><jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession"><%userSession.initialise(website, request);%></jsp:useBean><%
try {
	StockDetailPageModel pageModel = (StockDetailPageModel) userSession.getWebController().getCurrentPageController().getPageModel();
	StockDetailPageView pageView = (StockDetailPageView) userSession.getWebController().getCurrentPageController().getPageView();

	String stockEnquiryString = request.getParameter("stockEnquiryString");			
	if (userSession == null) {
		out.write("Session has expired, refresh the page.");
	} else {
		if (pageModel.isShowEnquiryEmail() && stockEnquiryString != null && !stockEnquiryString.equals("null")) { %>


				<form name="emailenq" method="post" action="#" >
					<%=stockEnquiryString%>
					<input type="text" name="enqstockemail" valign="center"  value="Email Address" onfocus="this.value='';" /><input type="submit" value="Enquire" /> 
					<input type="hidden" name="id" value='<%=pageModel.getVendorArticleId()%>' />
					<input type="hidden" name="pid" value='<%=pageModel.getParentVendorArticleId()%>' />
				</form>

		<% } else { %>
			<input type="hidden" name="enqstockemail" value="" />
		<% } %>
	  	<% if (pageModel.getMessageEmailSendResult() != null) { %>
			<%=pageModel.getMessageEmailSendResult()%>
		<% } 
	}
} catch (Exception ee1) { 
	website.writeToLog("Failed to render enquiry email fragment. Reason: "+ee1.getMessage()); 
} 	
%>
