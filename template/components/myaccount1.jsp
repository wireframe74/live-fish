<!-- start of components/myaccount.html -->
<jsp:useBean id="website"  scope="application" class="co.simplypos.model.website.WebSite" />
<jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession" />
<%@page import="co.simplypos.persistence.Customer" %>
<%@page import="co.simplypos.model.website.HTMLComponents" %>
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
<table width="100%" align="center" cellspacing=0 cellpadding=0 border="0">
<tr>
	<td>
		<%=HTMLComponents.getTrail(request, userSession, "My Account")%>
	</td>
</tr>
<tr>
	<td>
		<div id="myaccount">


		<table width="100%" align="center" valign=top border=0 cellspacing=0 cellpadding=0>
			<tr>
				<td>
					<jsp:include page="accountButtons.jsp" />
 				</td>
			</tr>

<%
if (pg == 1) { 
	if (validationString != null && !validationString.equals(initialValidationString)) {
%>
        	<tr>
            	<td>
			<div id="myaccountvalidation">
                	<table width="100%" cellpadding="2" cellspacing="0" border="0">
						<tr><td><img src="<%=website.getImagePath("spacer.gif")%>" alt="" class="height3 width1" /></td></tr>
                    	<tr>
	                        <td valign=top>
	                            <img src="<%=website.getImagePath("icon_error.gif")%>" alt="" />&nbsp;
	                        </td>
	                        <td>				 
	                            <font class="discount" style="font.size:12px"><b><%=validationString%></b></font>
	                        </td>
                    	</tr>
                	</table>
			</div>
            	</td>
        	</tr>
<%
	}
%>
   	
   			<form name="accountdetails" action="myaccount.jsp" method="POST" style="margin:0 0 0 0;">
    			<tr>
        			<td>		
        				<br />
<% 
	if (!paramAction.equals("getAddr")) out.write("<br />"); 
%>

						<div class="checkoutcontainer">
		  					<table cellspacing="0" cellpadding="0" border="0" width="99%">
		  						<tr>
		  							<td>
										<table width="100%" align="left" border="0" cellspacing="0" cellpadding="0">
	                    					<tr>
	                        					<td>
	                        <% 
								String pageTitle = "My Account Details";
								String pageTitleText = "";
								String pageTitleImage = website.getImagePath("myaccount.gif");
			
							%>
						<%@include file="../drawcontainerheader.html"%>
	                        					</td>
	                    					</tr>
	                    					<tr><td> </td></tr> 
										</table>
	  								</td>
	  							</tr>
	  							<tr>
	  								<td>
                						<table width="100%" class="form" cellspacing="0" cellpadding="4">
                							<tr>
                								<td>
                									<table width="100%" align="left" border="0" cellspacing=0 cellpadding=0>		 
                    									<tr>
                        									<td>
																<%=HTMLComponents.getAddressDetails(request, userSession, true)%>
                        									</td>
                     									</tr>
                									</table>
       	   										</td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
	  					</div>
	 				</td>
				</tr>
				<tr>
					<td>
						<br />
							<div class="checkoutcontainer">
								<table cellspacing="0" cellpadding="0" border="0" width="99%">
									<tr>
										<td>
											<table width="100%" align="left" border="0" cellspacing=0 cellpadding=0>
												<tr>
													<td>
														<br />
														<%=HTMLComponents.getAccountDetails(request, userSession)%>
													</td>
												</tr>
												<tr><td>&nbsp;</td></tr>
											</table>
										</td>
									</tr>
								</table>
							</div>
						</td>
					</tr>
					<tr>
						<td>
							<br />
							<div class="checkoutcontainer">
								<table cellspacing="0" cellpadding="0" border="0" width="99%">
									<tr>
										<td>
											<table width="100%" cellpadding="0" cellspacing="0" border="0">
												<tr valign=top>
													<td>
														<i>Note:</i><br />
													</td>
													<td>
														Fields marked with an * are required
													</td>
													<td width=20% align=right valign=bottom>				
									                                <input type=hidden name="action" value="register" />
									                                <input type=hidden name="src" value="<%=paramSource%>" />
														<div id="myaccountupdate">
									                                		<input type=submit name="submit" value="Update" /> 
														</div>
													</td>
												</tr>
											</table>
										</td>
									</tr>
								</table>
							</div>
						</td>
					</tr>
					<tr>
						<td>
							<img src="<%=website.getImagePath("spacer.gif")%>" alt="" class="width1 height35" />    
						</td>
					</tr>
					<tr>
						<td class="discount" align="center">
							If you would like to change your password then <a href='changepwd.jsp' class='discount'><u>click here</u></a>
						</td>
					</tr>
				</form>
<% 
} else if (pg == 2) { 
%>
				<tr>
					<td>
		&nbsp;
	  </td>
    </tr>	
    <tr>
	  <td>
		<%=HTMLComponents.getDeliveryAddressList(userSession, "My Delivery Addresses", "changeaddr.jsp", false, true).toString()%>
	  </td>
    </tr>
    
<%
} else if (pg == 3) { 
%>
    <tr>
	  <td>
		&nbsp;
	  </td>
    </tr>	
    <tr>
	  <td>
		<%=HTMLComponents.getPurchasesList(userSession, "My Purchases", "tracking.jsp", userSession.getLoggedInCustomerId(), true).toString()%>
	  </td>
    </tr>
<%
}
%>

<tr><td><center><br /><br /><br />
<%
			if (userSession.getWebsiteAccessDomainId() == Customer.WEB_ACCESS_TYPE_FULL_ADMIN || (userSession.getLoggedInCustomerEmailAddress() != null && userSession.getLoggedInCustomerEmailAddress().indexOf("intelligentretail.co.uk") > -1)) {
		%>	
				<b><u>Administrator Options</u></b>     
				<br /><br />
<!--				<a href="custauth.jsp">Authorise Customer Access</a> 
				<br /><br />
-->
				<a href="editor/editor3.jsp">Static Page and Style Sheet Editor</a>   
				<br />
				<a href="metakeyAdmin.jsp">Meta Policy Editor</a>   
				<br />
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
</center></td></tr>
		      
</table>

<%
if (alertMessage != null && !alertMessage.trim().equals("")) {
%>
<script language="javascript">
	<!--
	alert("<%=alertMessage%>");
	//-->
</script>
<%
}
%>

</td></tr><tr><td><br><br>
</div>

</td></tr></table>
<!-- end of components/myaccount.html -->