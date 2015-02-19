<jsp:useBean id="website"  scope="application" class="co.simplypos.model.website.WebSite" />
<jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession" />
<%@page import="co.simplypos.model.website.HTMLComponents2"%>
<link rel="stylesheet" href="../style.css" type="text/css" />
<% final String initialValidationString = "Please enter the recipients ";
String validationString = initialValidationString ;
if (request.getAttribute("validationString") != null) validationString = (String)request.getAttribute("validationString");
	String paramAction = "";

if (request.getAttribute("action") != null) paramAction = (String)request.getAttribute("action");

int paramAddressId = 0;
if (request.getParameter("addressid") != null) {
	paramAddressId = Integer.parseInt(request.getParameter("addressid"));
}%>
<div class="pagetopnav">
	<ul class="crumb blocklist">
		<%=userSession.getTrailHTML("Shopping Basket", userSession.getFullURL(request), true)%>	
	</ul>
	<ul class="navPage blocklistright">
		<li class="buttonbacktoshop">
			<a href="<%=userSession.getLastURL()%>"> <%=website.getText("changeaddressbacktoshopbutton","Back to Shop")%> </a>
		</li>
	</ul>
</div>		

<%if (!validationString.equals(initialValidationString)) {%>
	<div id="pagevalidation_ajax">
		<ul class="validation labelpairleft" >
			<li class="validationicon"><img src="<%=website.getImagePath("icon_error.gif")%>" alt="" /></li>		 
			<li class="validationtext"><%=validationString%></li>
		</ul>
	</div>
	<script type='text/javascript'><!--
		location.replace('#addressdetail');
	//--></script>
<% } %>
	<div class="pagetitle"><h1><%=website.getText("changeaddressheaderone","Address Update")%></h1></div>
	<div id="addressupdatecontent">
		<%=HTMLComponents2.getAddressDetails(request, userSession, "Change Address Details", "changeaddr.jsp", false, null).toString()%>
	</div>

<div class="pagebottomnav">
	<ul class="crumb blocklist">
		<%=userSession.getTrailHTML("Shopping Basket", userSession.getFullURL(request), true)%>	
	</ul>
	<ul class="navPage blocklistright">
		<li class="buttonbacktoshop">
			<a href="<%=userSession.getLastURL()%>"> <%=website.getText("changeaddressbacktoshopbutton","Back to Shop")%> </a>
		</li>
	</ul>
</div>