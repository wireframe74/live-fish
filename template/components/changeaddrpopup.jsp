<!-- start of components/changedeliveryaddr.html -->
<jsp:useBean id="website" scope="application" class="co.simplypos.model.website.WebSite"><%website.initialise(request.getRequestURL().toString(), application.getRealPath("/"), 170);%></jsp:useBean><jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession"><%userSession.initialise(website, request);%></jsp:useBean>
<%@page import="co.simplypos.model.website.HTMLComponents"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.util.Vector"%>
<html>
<head>
<link rel="stylesheet" href="../framework.css" type="text/css" />
<link rel="stylesheet" href="../style.css" type="text/css" />
<style TYPE="text/css"> 
<!-- 
body {font-family: Arial, Verdana, "MS Sans Serif", sans-serif; color: #000000; margin-top: 0px; background: #ffffff;}
--> 
</style>
</head>
<body>
<% 
	String forwardPage = userSession.getWebController().processRequestParameters(request); 	
	/*if (forwardPage != null) {
		try {
      			response.sendRedirect(forwardPage);
		} catch (Exception e102) {
			out.write("<script type='text/javascript'>document.location.href='"+forwardPage+"';</script>");
		}		
       	return;
	}*/

	final String initialValidationString = "Please enter the recipients ";
	String validationString = initialValidationString ;
	if (request.getAttribute("validationString") != null) validationString = (String)request.getAttribute("validationString");

	String paramAction = ""; //"quickpay.jsp";
	if (request.getAttribute("action") != null) paramAction = (String)request.getAttribute("action");

	int addressId = 0;
	if (request.getAttribute("addressid") != null) {
		try {
			addressId = Integer.parseInt(""+request.getAttribute("addressid"));
		} catch (NumberFormatException nfe23) {
			addressId = 0;
			website.writeToLog("changeaddrpopup addressId exception: "+nfe23);
		} 
	}

	int addressType = 0;
	if (request.getAttribute("addresstype") != null) {
		try {
			addressType = Integer.parseInt(""+request.getAttribute("addresstype")); 
		} catch (NumberFormatException nfe23) {
			addressType = 0;
			website.writeToLog("changeaddrpopup addressType  exception: "+nfe23);
		} 
	} else {
		if (request.getParameter("addresstype") != null) {
			try {
				addressType = Integer.parseInt(""+request.getParameter("addresstype")); 
			} catch (NumberFormatException nfe23) {
				addressType = 0;
				website.writeToLog("changeaddrpopup addressType  exception: "+nfe23);
			} 
		}
	}

	if (paramAction.equals("selectaddress")) {
		int custId  = userSession.getLoggedInCustomerId();
        	int transId = userSession.getShoppingBasket().getTransactionId();
//out.write("quickpaycontroller - adding transaction address: cust_id: "+custId+"   transId: "+transId+"   address_id: "+addressId+"   addressType: "+addressType);
        	        	
        	if (custId > 0 && transId > 0 && addressId > 0 && addressType > 0) {
			Connection conn = null;
			try {
				conn = website.getConnection();
	        		userSession.getWebController().addTransactionAddress(conn, custId, addressId, transId, addressType);
				conn.commit();
			} finally {
				website.releaseConnection(conn);
			}
        	}

	} 
	if ((paramAction.equals("update") || paramAction.equals("selectaddress")) && validationString.equals(initialValidationString)) {
		//String nextURL = website.getWebSiteURL().substring(0,website.getWebSiteURL().lastIndexOf("/")+1)+"quickpay.jsp"+(paramAction.equals("selectaddress")?"?selectedaddressid="+addressId:"");	
		String nextURL = website.getBaseURL(request)+"/quickpay.jsp";	    
		%>
			<br /><br /><br /><br /><br /><br />
			<center>Address details saved<center>

		      <script type='text/javascript'>
		          parent.parent.location.href="<%=nextURL%>";
		      </script>		
			<noscript>
				<br /><br /><a href="<%=nextURL%>">Click here to continue</a>
		  	</noscript>			
		<%
		return;
	} 


%>
<span id="addresspopupbackground">
<table width="500" align="center" cellspacing="0" cellpadding="0">
<tr>
<td>
<table align="center" width="100%" valign="top" border="0" cellspacing="0" cellpadding="0">
    <tr>
    <td>
           <br />
    <td>
    </tr>
    <%
        if (!validationString.equals(initialValidationString)) {
    %>
        <tr>
            <td>
		<div id="pagevalidationmessage">
			<img src='<%=website.getImagePath("icon_error.gif")%>'>&nbsp;
			<div class="pagevalidationtext"><%=validationString%></div>
		</div>
            </td>
        </tr>
    <% } %>
    <% if (request.getParameter("failedlookup") != null) { %>
        <tr>
            <td>
		<div id="pagevalidationmessage">
			<img src='<%=website.getImagePath("icon_error.gif")%>'>&nbsp;
			<div class="pagevalidationtext"><%=request.getParameter("failedreason")%></div>
		</div>
            </td>
        </tr>
    <% } %>
    <tr>
        <td>
		<%=HTMLComponents.getAddressDetails(request, userSession, null, "changeaddrpopup.jsp?addresstype="+addressType, (addressType == 1), null, null, website.isAskForTelephoneAndEmailWithAddress()).toString()%> 
        </td>
    </tr>
    <tr>
        <td>
<%
try {
	Vector addressList = HTMLComponents.getAddressList(userSession);
	if (addressList != null && addressList.size() > 1) {
%>
		<div id="addresslist">
			<div id="addresslisttitle" class="pagetitle">
				My Previous Addresses
			</div>
			<div id="addresslistsubtitle">
				You can alternatively choose a previously entered address by clicking on the address below:
			</div>	
			<div id="addresslistbody">
				<%=HTMLComponents.getAddressList(addressList, userSession, "", "changeaddrpopup.jsp", addressId, addressId, false, true, addressType).toString()%>
			</div>
		</div>
<%
	}
} catch (Exception ee2) {
	out.write("Error: "+ee2.getMessage());
	website.writeToLog(ee2);
}
%>
        </td>
    </tr>

</table>
</td></tr>
</table>
</span>
</body>
</html>
<!-- end of components/changedeliveryaddr.html -->