<!-- start of components/welcome.jsp -->
<jsp:useBean id="website"  scope="application" class="co.simplypos.model.website.WebSite" />
<jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession" />
<%@page import="co.simplypos.persistence.Customer" %>

<jsp:include page="accountButtons.jsp" />
 
<br />
<div class="checkoutcontainer">

							<div class="pagetitle" align="center">
								Welcome
							</div>
									<%@include file="../../welcome.html" %>
		</div>


<%if (userSession.getWebsiteAccessDomainId() == Customer.WEB_ACCESS_TYPE_FULL_ADMIN || (userSession.getLoggedInCustomerEmailAddress() != null && userSession.getLoggedInCustomerEmailAddress().indexOf("intelligentretail.co.uk") > -1)) {%>	
				<div id="webmngmntarea"><div id="webmngmntareainner">
				<b><u>Administrator Options</u></b>     
				<br /><br />
<!--  				<a href="custauth.jsp">Authorise Customer Access</a> 
				<br /><br />
-->
				<a href="editor/editorAdmin.jsp">Website Management Area</a>   
				<br />
<!-- 				<a href="metakeyAdmin.jsp">Meta Policy Editor</a>   
				<br />
-->
				</div></div>
		<%	
			}

			
				int orderId = userSession.hasNewPersonalShopperList();
				if (orderId > 0) {
		%>
				<br />
				<div class="psMsg">
					<img alt="" src="<%=website.getImagePath("psshopper.png")%>" />
					You have a new Personal Shopping List which can be viewed <a href="viewList.jsp?id=<%=orderId%>">here</a>
				</div>
		
		<%
				}
%>
<!-- end of components/welcome.jsp -->
