<!-- start of components/myaccount.html -->
<jsp:useBean id="website"  scope="application" class="co.simplypos.model.website.WebSite" />
<jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession" />
<%@page import="co.simplypos.persistence.Customer" %>
<%@page import="co.simplypos.model.website.HTMLComponents2" %>
<%
String alertMessage = null;
if (request.getAttribute("alertMessage") != null) {
	alertMessage = (String)request.getAttribute("alertMessage");
}

final String initialValidationString = "Please enter your ";
String validationString = initialValidationString ;
if (request.getAttribute("validationString") != null) validationString = (String)request.getAttribute("validationString");

String paramAction = "";
if (request.getAttribute("action") != null) paramAction = (String)request.getAttribute("action");

String paramSource = "";
if (request.getAttribute("src") != null) paramSource = (String)request.getAttribute("src");

String paramPage = "";
if (request.getAttribute("pg") != null) paramPage = (String)request.getAttribute("pg");
if (paramPage == null) paramPage = "1";

int pg = 1;
try {
	pg = Integer.parseInt(paramPage);
} catch (Exception e2) {
	pg = 1;
}

%>

		<!--<%=HTMLComponents2.getTrail(request, userSession, "My Account")%>-->

<div id="myaccount">
	<jsp:include page="accountButtons.jsp" />

	<%if (validationString != null && !validationString.equals(initialValidationString)) {%>
			<div id="pagevalidation_ajax">
				<ul class="validation labelpairleft" >
					<li class="validationicon"><img src="<%=website.getImagePath("icon_error.gif")%>" alt="" /></li>		 
					<li class="validationtext"><%=validationString%></li>
				</ul>
			</div>      
	<% } %>
<div id="myacccountcontent">

	<%if (pg == 1) { %>
	<form name="accountdetails" action="myaccount.jsp" method="POST" >
		<div class="pagetitle">
			<h1> <%=website.getText("myaccountaccountdetailsheader","My Account Details")%> </h1>
		</div>
		<div id="myaccountaddressdetails">
			<%=HTMLComponents2.getAddressDetails(request, userSession, true)%>
		</div>
		<div id="myaccountaccountdetails">
			<%=HTMLComponents2.getAccountDetails(request, userSession)%>
		</div>
		<div id="myaccountdetailsactions">
			<%=website.getText("myaccountaccountdetailnotes","<i>Note:</i> Fields marked with an * are required")%>
			<input type=hidden name="action" value="register" />
			<input type=hidden name="src" value="<%=paramSource%>" />
			<div id="myaccountupdate">
				<a class="actionbutton" href="javascript:document.accountdetails.submit();" >
					<%=website.getText("myaccountdetailsupdate","Update")%> 
				</a>
			</div>
			<div id="myaccountpasswordchange">
				<%=website.getText("myaccountaccountdetailprepasschange","If you would like to change your password then ")%>
					<a href='changepwd.jsp'>
						<%=website.getText("myaccountaccountdetailpostpasschange","<u>click here</u>")%>
					</a>
			</div>
		</div>
	</form>


<% } else if (pg == 2) { %>

	<div class="pagetitle">
		<h1> <%=website.getText("myaccountmypurchasesheader","My Delivery Addresses")%> </h1>
	</div>
	<div id="mydeliveryaddresses">
		<%=HTMLComponents2.getDeliveryAddressList(userSession, "My Delivery Addresses", "changeaddr.jsp", false, true).toString()%>
	</div>
     
<%} else if (pg == 3) {%>

	<div class="pagetitle">
		<h1> <%=website.getText("myaccountmypurchasesheader","My Purchases")%> </h1>
	</div>
	<div id="mypurchases" class="listtable">
		<ul class="listtableheader">
			<li class="mypurchaseordertype"> <%=website.getText("myaccountmypurchasestypeheader","Type")%> </li>
			<li class="orderlink"> <%=website.getText("myaccountmypurchasesdetailsheader","Details")%> </li>
			<li class="orderstaus"> <%=website.getText("myaccountmypurchasesorderstatusheader","Status")%> </li>
		</ul>	
		<%=HTMLComponents2.getPurchasesList(userSession, "My Purchases", "tracking.jsp", userSession.getLoggedInCustomerId(), true).toString()%>
	</div>

<% } %>
<% if (userSession.getWebsiteAccessDomainId() == Customer.WEB_ACCESS_TYPE_FULL_ADMIN || (userSession.getLoggedInCustomerEmailAddress() != null && userSession.getLoggedInCustomerEmailAddress().indexOf("intelligentretail.co.uk") > -1)) { %>	
	<div id="webmngmntarea">
		<div id="webmngmntareainner">
			<b><u>Administrator Options</u></b>     
			<a href="editor/editorAdmin.jsp">Website Management Area</a>   
		</div>
	</div>

<% }
	int orderId = userSession.hasNewPersonalShopperList();
	if (orderId > 0) { %>
		<div class="psMsg">
			<img alt="" src="<%=website.getImagePath("psshopper.png")%>" />
			You have a new Personal Shopping List which can be viewed <a href="viewList.jsp?id=<%=orderId%>">here</a>
		</div>
<% } %>
</div>

<% if (alertMessage != null && !alertMessage.trim().equals("")) { %>
	<script language="javascript">
		<!--
		alert("<%=alertMessage%>");
		//-->
	</script>
<% } %>
</div>
<!-- end of components/myaccount.html -->
