<!-- start of components/pay.html -->
<jsp:useBean id="website"  scope="application" class="co.simplypos.model.website.WebSite" />
<jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession" />

<% 
    try {
	website.writeToLog("userSession.getCurrentPaymentProvider(): "+userSession.getCurrentPaymentProvider().getPaymentProviderKey()+"     not protx? "+(userSession.getCurrentPaymentProvider().isPayPal())+" || "+(userSession.getCurrentPaymentProvider().isWorldPay())+" || "+(userSession.getCurrentPaymentProvider().isHSBC())+" || "+(userSession.getCurrentPaymentProvider().isOrderOnlyMode())+"     paypal notifier: "+(request.getParameter("PayPal.x") != null));
	if (request.getParameter("PayPal.x") != null) { // || userSession.getCurrentPaymentProvider().isPayPal() || userSession.getCurrentPaymentProvider().isWorldPay() || userSession.getCurrentPaymentProvider().isHSBC() || userSession.getCurrentPaymentProvider().isOrderOnlyMode()) { // redirect back to confirm
		//if (request.getRequestURL().toString().startsWith("https")) 
		String nextURL = website.getWebSiteURL().substring(0,website.getWebSiteURL().lastIndexOf("/")+1)+"confirm.jsp";	
%>
		<form name="ppform" action="<%=nextURL%>" method="post">		
			<%=co.simplypos.model.utils.helpers.HTMLHelper.getRequestParamsAsFormFields(request)%>
			<input type="hidden" name="src" value="pay">
		
			<script type="text/javascript">
				<!--
				document.ppform.submit();
				//-->
			</script>
			<noscript><center><p>Please click button below to redirect to the payment gateway</p><input type="submit" value="Go"/></p></center></noscript>
		</form>
		<%
		return;
	}
	boolean testMode = website.getTestMode() != null && website.getTestMode().equals("100");

	int errorLevel = 0;    // 0 - no error, 1 = warning, 2 = fatal
	boolean showPayForm = true;	
	boolean paymentFailed = false;	
	boolean sendPayment = request.getParameter("action") != null && request.getParameter("action").equals("sendpayment");
	String returnString = "";
	String cardHolder = request.getParameter("CardHolder");
	String issueNumber = request.getParameter("IssueNumber");
	String cvv =request.getParameter("CV2");
	String expDate = request.getParameter("ExpiryDate");
	String startDate = request.getParameter("StartDate");
	String cardNumber = request.getParameter("CardNumber");
	String cardType = request.getParameter("CardType");
	if (cardHolder == null) {
		cardHolder = request.getParameter("name");
	}	 
	if (cardHolder == null) {
		cardHolder = (String) session.getAttribute("cardHolder");
	}
	if (cardHolder == null) {
		cardHolder = "";   
	}
	if (issueNumber == null) {
	    issueNumber = (String)session.getAttribute("issueNumber");
	}
	if (issueNumber == null) {
	    issueNumber = "";
	}
	if (cvv == null) {
	 	cvv = (String) session.getAttribute("CV2");   
	}
	if (testMode) {
	    cvv = "123";
	    expDate = "0209";
	    cardNumber = "4929000000006";
	}
	if (cvv == null) {
	    cvv = "";
	}
	if (expDate == null) {
	    expDate = (String) session.getAttribute("expiryDate");
	}
	if (expDate == null) {
	    expDate = "";
	}
	if (startDate == null) {
	 	startDate = (String) session.getAttribute("startDate");   
	}
	if (startDate == null) {
	 	startDate = "";   
	}
	if (cardNumber == null) {
	    cardNumber = (String) session.getAttribute("cardNumber");
	}
	if (cardNumber == null) {
		cardNumber = "";
	}
	if (cardType == null) {
	    cardType = (String) session.getAttribute("cardType");
	}
	if (cardType == null) {
	    cardType = "";
	}
	
//	String targetURL = "https://ukvpstest.protx.com/VSPSimulator/VSPDirectGateway.asp";  // simulator
//	String targetURL = "https://ukvpstest.protx.com/showpost/showpost.asp"; 	     // protx debug   
//	String targetURL = "https://ukvpstest.protx.com/vspgateway/service/vspdirect-register.vsp"; // test
	
	String targetURL = "https://test.sagepay.com/Simulator/VSPDirectGateway.asp"; // SagePay simulator
	//String targetURL = "https://test.sagepay.com/gateway/service/vspdirect-register.vsp"; // SagePay test
	
//	String callbackURL = "https://ukvpstest.protx.com/VSPSimulator/VSPDirectCallback.asp"; // simulator
//	String callbackURL = ""; //protx debug
//	String callbackURL = "https://ukvpstest.protx.com/vspgateway/service/direct3dcallback.vsp"; //test
	
	String callbackURL = "https://test.sagepay.com/Simulator/VSPDirectGateway.asp"; // SagePay simulator
	//String callbackURL = "https://test.sagepay.com/gateway/service/direct3dcallback.vsp"; //test
	
	if (!testMode) {
		//targetURL = "https://ukvps.protx.com/vspgateway/service/vspdirect-register.vsp";
		//callbackURL = "https://ukvps.protx.com/vspgateway/service/direct3dcallback.vsp";
		targetURL = "https://live.sagepay.com/gateway/service/vspdirect-register.vsp";
		callbackURL = "https://live.sagepay.com/gateway/service/direct3dcallback.vsp";
	}

	if (userSession.getShoppingBasket().getTotalQuantity() <= 0) {
		sendPayment = false;
		showPayForm = true;
		errorLevel = 2;
		returnString = "Your session is closed. If you did not complete your transaction then your session may have timed-out. If so, please re-add your items to your basket and try again.";
	}
 
	if (!sendPayment) {
		  int dbLines = 0;
		  int cartId = 0;
		  try {
			cartId = Integer.parseInt(request.getParameter("cartId"));
		  } catch (NumberFormatException nfe) {
			cartId = 0;
		  }

		 java.sql.Connection conn = null;
               try {
			conn = website.getConnection();
			userSession.getShoppingBasket().saveBasket(conn);
                     dbLines = userSession.getShoppingBasket().performPrePaymentProcessing(conn, cartId);
	              conn.commit();
		  } catch (co.simplypos.model.website.PaymentAlreadyAuthorisedException paae) {
                    userSession.clearShoppingBasket();
                    %>
                        <script language="javascript"><!--
                            alert("<%=paae.getMessage()%>");
                        //--></script>
                     <%
			try {
	                    response.sendRedirect("index.jsp");
			} catch (Exception e102) {
				%>
			       <script type='text/javascript'>
			           document.location.href="index.jsp";
			       </script>
				<%
			}
                    return;
                } finally {
		          website.releaseConnection(conn);
		  }
               
	} else {
	    java.util.Map results = null;
	    String authStr = request.getParameter("auth");
	    //website.writeToLog("in pay.jsp: getting authStr: " + authStr);
	    if ("true".equals(authStr)) {
	        //website.writeToLog("in pay.jsp: authStr == true, sending 3DAuthPaymentCall");
	        results = co.simplypos.model.website.ProtxHelper.send3DAuthPayment(callbackURL, userSession, request, new java.io.PrintWriter(out));
	    } else {
	        //website.writeToLog("in pay.jsp: authStr != true, sendingPayment first time through");
	        try {
//out.write("userSession.getCurrentPaymentProvider().getUserId(): "+userSession.getCurrentPaymentProvider().getUserId()+"    targetURL: "+targetURL);
	    		results = co.simplypos.model.website.ProtxHelper.sendPayment(userSession, request, response, new java.io.PrintWriter(out), targetURL, userSession.getCurrentPaymentProvider().getUserId());
//out.write("results: "+results);
	    	} catch (Exception e) {
	    		website.writeToLog(e);
	    	}
	    }
		returnString = (String) results.get("resultText");
		if ("3DAUTH".equals(returnString)) {
		    out.write(		  
					"<form name=\"form\" action=\"" + results.get( "ACSURL" ) + "\" method=\"post\">" +
					"<input type=\"hidden\" name=\"PaReq\" value=\"" + results.get( "PaReq" ) + "\"/>" +
					"<input type=\"hidden\" name=\"TermUrl\" value=\"" + results.get("termURL") + "\"/>" +
					"<input type=\"hidden\" name=\"MD\" value=\"" + results.get( "MD" ) + "\"/>" +
					"<script type=\"text/javascript\">document.form.submit();</script>" +
					"<noscript><center><p>Please click button below to Authenticate your card</p><input type=\"submit\" value=\"Go\"/></p></center></noscript>"+
					"</form>" );
		    
		}
		//
		if ("OK".equals(returnString)) {

			showPayForm   = false;
			paymentFailed = false;
			userSession.clearShoppingBasket(); 
			
			//String forwardPageEnd = "host.jsp?pg=thankyou.html"; 
			String orderTotal = request.getParameter("ot");
			if (orderTotal != null && orderTotal.length() > 0) orderTotal = orderTotal.substring(1);
			String pageName = "thankyou.html";
			if (new java.io.File(website.getWebSitePath(),"thankyou.jsp").exists()) pageName = "thankyou.jsp";

			String forwardPageEnd = website.getWebSiteURL().substring(0,website.getWebSiteURL().lastIndexOf("/")+1)+"host.jsp?pg="+pageName+"&ot="+orderTotal+"&ref=P"+request.getParameter("ref");
			if (forwardPageEnd != null) {
				out.write("<script type='text/javascript'>document.location.href='"+forwardPageEnd+"';</script>");
				try {					
      				// jsp:forward page="%=forwardPageEnd%"  
					response.sendRedirect(forwardPageEnd);

				} catch (Exception e102) {
					// nothing
				}	
				
       			return;
			}


		} else {
			paymentFailed = true;
		}

		if (paymentFailed) errorLevel = 1;
	}

	if (showPayForm ) {
	    float totalOrderAmount = 0;
	    String formatAmount = ""; 
	    try {
		totalOrderAmount = Float.parseFloat(request.getParameter("amount"));
		if (request.getParameter("formatAmount") != null) {
			formatAmount = request.getParameter("formatAmount");
		} else {
			formatAmount = userSession.formatPrice(totalOrderAmount);
		}
    	    } catch (NumberFormatException nfe) { 
		totalOrderAmount = 0;
		formatAmount = "0";
	    } catch (NullPointerException npe) {
		totalOrderAmount = 0;
		formatAmount = "0";
 	    }

		
%>
<form name="paymentdetails" action="paysecure.jsp" method="POST" style="margin:0 0 0 0;">

<table width="100%" align="center" cellspacing=0 cellpadding=0 border="0"><tr><td>

       <table border=0 width=100% align=center valign=top cellspacing=0 cellpadding=0>
        <tr>
		<td align=left valign=bottom class="trail">
	        	<a href="index.jsp" class="trail">Home</a> <img src="<%=website.getImagePath("tri.gif") %>" alt="" /> 
	        	<a href="basket.jsp" class="trail">Shopping Basket</a> <img src="<%=website.getImagePath("tri.gif") %>" alt="" />
	        	<a href="delivery.jsp" class="trail">Delivery</a> <img src="<%=website.getImagePath("tri.gif") %>" alt="" />
	        	<a href="confirm.jsp" class="trail">Confirmation</a><img src="<%=website.getImagePath("tri.gif") %>" alt="" />
	        	 <a href="paysecure.jsp" class="trail">Secure Payment</a>
        	</td>

 		<td align=right width=100>
        		<table width=100% border=0 cellspacing=0 cellpadding=0>
				<tr><td width=50%></td></tr>
			</table>
    		</td>
	</tr>
	</table>

</td></tr>
<tr>
        <td>
		<center><img src='<%=website.getImagePath("checkoutprocess5.gif")%>' style="margin-top:8px;margin-bottom:10px;"></center>         
        </td>
    </tr>

<tr>
<td>
<div id="paycontainer">
<%
	if (errorLevel > 0) {
%>
                <table width="100%" cellpadding=2 cellspacing=0>
		      <tr><td><img src="<%=website.getImagePath("spacer.gif") %>" width="1" height="10"></td></tr>

                    <tr>
                        <td valign=top>
                            <img src='<%=website.getImagePath("icon_error.gif")%>'>&nbsp;
                        </td>
                        <td color=red>
                            <font class="discount" style="font.size:12px"><b><%=returnString%></b></font>
                            <br><br>
                        </td>
                    </tr>
		      <tr><td><img src="<%=website.getImagePath("spacer.gif") %>" width="1" height="10"></td></tr>
                </table>
	<%		
 	} 

	if (errorLevel < 2) {
	%>


<BR>


<div class="checkoutcontainer">

<table cellspacing="0" cellpadding="0" border="0" width="99%"><tr><td>
	  
			<table width="100%" align="left" border="0" cellspacing="0" cellpadding="0">
	                    <tr>
				    <% 
					String pageTitle = "Enter Payment Details";
					String pageTitleText = "";
					String pageTitleImage = "";
				    %>
	                        <td width="100%">
					<%@include file="../drawcontainerheader.html"%>
	                        </td> 
				   <td><img src='<%=website.getImagePath("securetransaction.gif")%>' border="0"></td>
	                    </tr>
	                    <tr height=8><td> </td></tr>
			</table>
		  </td></tr>
<tr>
<td><BR>
<table width="95%" align="center" border="0" cellspacing="0" cellpadding="0">
<tr>

	<td valign="middle" width="140">Description:</td>
	<td width="6">
		<img alt="" border="0" height="1" src="<%=website.getImagePath("spacer.gif") %>" width="6">
	</td>
	<td align="left" class="stockthumbprice">
		<%=userSession.getShoppingBasket().getTotalQuantity()+" item"+(userSession.getShoppingBasket().getTotalQuantity()==1?"":"s")%> from <%=website.getWebsiteName()%>
	</td>
</tr>
<tr><td colspan="3"><img alt="" border="0" height="5" src="<%=website.getImagePath("spacer.gif")%>" width="6"></td></tr>
<tr>
	<td valign="middle" width="140">Amount:</td>
	<td width="6">
		<img alt="" border="0" height="1" src="<%=website.getImagePath("spacer.gif")%>" width="6">
	</td>
	<td align="left" class="stockthumbprice">
		<%=formatAmount%>
	</td>
</tr>

<% if (request.getParameter("exchangeRate") != null) {  %>
	<tr><td colspan="3"><img alt="" border="0" height="5" src="<%=website.getImagePath("spacer.gif")%>" width="6"></td></tr>
	<tr>
		<td valign="middle" width="140">Exchange Rate:</td>
		<td width="6">
			<img alt="" border="0" height="1" src="<%=website.getImagePath("spacer.gif")%>" width="6">
		</td>
		<td align="left" class="stockthumbprice">
			<%=request.getParameter("exchangeRate")%>
		</td>
	</tr>
<% } %>
<tr><td colspan="3"><img alt="" border="0" height="15" src="<%=website.getImagePath("spacer.gif")%>" width="6"></td></tr>
<tr>

	<td valign="middle" width="140">Card Type:</td>
	<td width="6">
		<img alt="" border="0" height="1" src="<%=website.getImagePath("spacer.gif")%>" width="6">
	</td>
	<td align="left">
		<select name="CardType">
		<option value="" <%=(!testMode && (cardType.equals(""))?"selected":"")%> >Select Card</option>
		<option value="VISA" <%=(testMode || cardType.equals("VISA")?"selected":"")%> >Visa</option>
		<option value="MC" <%=(cardType.equals("MC")?"selected":"")%> >MasterCard/Eurocard</option>
		<option value="MAESTRO" <%=(cardType.equals("MAESTRO")?"selected":"")%> >Switch and Maestro</option>
		<option value="SOLO" <%=(cardType.equals("SOLO")?"selected":"")%> >Solo</option>   
		<option value="DELTA" <%=(cardType.equals("DELTA")?"selected":"")%> >Delta</option>
		<option value="UKE" <%=(cardType.equals("UKE")?"selected":"")%> >Electron</option>
		<% if (website.getCardPaymentExcludeList().indexOf("AMEX") == -1) { %>
			<option value="AMEX" <%=(cardType.equals("AMEX")?"selected":"")%> >American Express</option>
		<% } %>
		</select>
	</td>
</tr>
<tr>
	<td valign="middle">Credit Card Number:</td>
	<td width="6"><img alt="" border="0" height="1" src="<%=website.getImagePath("spacer.gif")%>" width="6"></td>
	<td align="left">
		<input name="CardNumber" type="text" size="30" maxlength="19" value="<%=cardNumber%>"> 
	</td>
</tr>
<tr>
	<td class="label" valign="middle">Start Date:</td>
	<td width="6"><img alt="" border="0" height="1" src="<%=website.getImagePath("spacer.gif")%>" width="6"></td>
	<td align="left">
		<input name="StartDate" type="text" size="4" maxlength="4" value="<%=startDate%>">
		<img alt="" border="0" src="<%=website.getImagePath("spacer.gif")%>" width="5" height="1">(MMYY e.g. 1105)		
	</td>
</tr>
<tr>
	<td class="label" valign="middle">Expiration Date:</td>
	<td width="6"><img alt="" border="0" height="1" src="<%=website.getImagePath("spacer.gif")%>" width="6"></td>
	<td align="left">
		<input name="ExpiryDate" type="text" size="4" maxlength="4" value="<%=expDate%>">
		<img alt="" border="0" src="<%=website.getImagePath("spacer.gif")%>" width="5" height="1">(MMYY e.g. 1109)		
	</td>
</tr>
<tr>
	<td valign="middle">Issue Number:</td>
	<td width="6"><img alt="" border="0" height="1" src="<%=website.getImagePath("spacer.gif")%>" width="6"></td>
	<td align="left"><input name="IssueNumber" type="text" size="2" maxlength="2" value="<%=issueNumber%>"> (where applicable)
	</td>
</tr>
<tr>
	<td valign="middle">Card Verification Number:</td>
	<td width="6">
		<img alt="" border="0" height="1" src="<%=website.getImagePath("spacer.gif")%>" width="6">
	</td>
	<td align="left">
		<table align="center" border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td width="45"><input name="CV2" maxlength="4" size="4" type="text" value="<%=cvv%>"></td>
				<td align="center" width="51"><a href="#" onClick="javascript:"><img align="top" src="<%=website.getImagePath("mini_cvv2.gif")%>" border="0" alt="Card Verification Number"></a></td>
				<td width="4"></td>
				<td valign="top">
					<table align="center" border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td>(Usually found on the back of your card, locate the final 3 or 4 digit number)<br>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</td>
</tr>

<tr>
	<td valign="middle">Card Holders Name:</td>
	<td width="6"><img alt="" border="0" height="1" src="<%=website.getImagePath("spacer.gif")%>" width="6"></td>
	<td align="left">
		<input type="text" id="CardHolder" size="30" maxlength="64" name="CardHolder" value="<%=cardHolder%>">
		<img alt="" border="0" src="<%=website.getImagePath("spacer.gif")%>" width="5" height="1">(as it appears on card)
	</td>
</tr>
<tr><td colspan="3"><img alt="" border="0" height="15" src="<%=website.getImagePath("spacer.gif")%>" width="6"></td></tr>

</table>



</td></tr>
<tr><td><img src="<%=website.getImagePath("spacer.gif")%>" border="0" height="15"></td></tr>

<input type='hidden' name='action' value='sendpayment'>

<%
	 java.util.Enumeration en = request.getParameterNames();
        while (en.hasMoreElements()) {
        	String paramName = (String)en.nextElement();
        	String paramValue = request.getParameter(paramName);
		out.write("<input type='hidden' name='"+paramName+"' value='"+paramValue+"'>\n");        
	 }
%>


<tr valign="top">
<td>
<table cellspacing="0" cellpadding="0" width="100%">
<tr>
<td>
</td>
<td align="center"><div class="checkoutcontainer" style="border-width:0px;"><table cellpadding="3"><tr><td>
	<input type=submit name='submit' value='    Make Payment    '>    
	</td></tr></table></div>
</td></tr>
</table>



</td></tr>
</table>

</div>
</div>
<%		} %>

</td></tr>
<tr><td><img src="<%=website.getImagePath("spacer.gif")%>" border="0" height="25"></td></tr>

<tr><td align="center">


</td></tr>

</td></tr></table>

<input type='hidden' name='ot' value='<%=formatAmount%>'> 
<input type='hidden' name='ref' value='<%=userSession.getShoppingBasket().getTransactionId()%>'> 

</form>

<%
 	} 	
   } catch (Exception ee1) {
	website.writeToLog("ERROR: "+ee1.getMessage());
	website.writeToLog(ee1);
	out.write("ERROR: "+ee1.getMessage());
   }
%>
<!-- end of components/pay.html -->