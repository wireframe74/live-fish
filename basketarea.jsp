<!-- start of shoppingbasket.jsp -->
<jsp:useBean id="website"  scope="application" class="co.simplypos.model.website.WebSite" />
<jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession" />

<%if (userSession == null) { %>

	<em>Session has expired, refresh the page.</em>
	
<% } else {

	if (userSession.getShoppingBasket().getTotalQuantity() == 0) { %>
		<%@include file="basketareaempty.html"%>
	<% } else { %>
		<%@include file="basketareanotempty.html"%>
	<% }
	
} %>
<!-- end of shoppingbasket.jsp -->