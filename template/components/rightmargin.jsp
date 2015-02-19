<!-- start of components/rightmargin.jsp -->
<%@page import="co.simplypos.model.website.WebSite" %>

<jsp:useBean id="website"  scope="application" class="co.simplypos.model.website.WebSite" />
<jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession" />

<% if (!WebSite.isThisPageInList(request, "confirm,paysecure,register,delivery,changeaddr")) { %>
	<%@include file="/rightmargin010.html"%> 
	<%@include file="/rightmargin020.html"%> 
	<%@include file="/rightmargin030.html"%>
	<%@include file="/rightmargin040.html"%> 
	<%@include file="/rightmargin050.html"%> 
	<%@include file="/rightmargin060.html"%> 
	<%@include file="/rightmargin070.html"%> 
	<%@include file="/rightmargin080.html"%> 
	<%@include file="/rightmargin090.html"%> 
<% } %>
<!-- end of components/rightmargin.html -->