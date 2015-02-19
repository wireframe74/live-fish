<!-- start of components/quickpayform.html -->
<jsp:useBean id="website"  scope="application" class="co.simplypos.model.website.WebSite" />
<jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession" />

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
<%		} %>

</td></tr>
<tr><td><img src="<%=website.getImagePath("spacer.gif")%>" border="0" height="25"></td></tr>

<tr><td align="center">


</td></tr>

</td></tr></table>

<input type='hidden' name='ot' value='<%=formatAmount%>'> 
<input type='hidden' name='ref' value='<%=userSession.getShoppingBasket().getTransactionId()%>'> 

</form>
<!-- end of components/quickpayform.html -->