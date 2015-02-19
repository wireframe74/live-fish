<!-- start of components/quickpay.jsp -->
<%@page import="java.io.FileOutputStream"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.ArrayList" %>
<%@page import="co.simplypos.model.TransactionManager"%>
<%@page import="co.simplypos.model.website.utils.Logger"%>
<%@page import="co.simplypos.model.website.UserSession" %>
<%@page import="co.simplypos.model.utils.helpers.HTMLHelper"%>
<%@page import="co.simplypos.persistence.Address"%>
<%@page import="co.simplypos.model.website.WebSite" %>
<%@page import="co.simplypos.model.website.ShoppingBasket" %>
<%@page import="co.simplypos.model.website.PaymentAlreadyAuthorisedException" %>
<%@page import="co.simplypos.persistence.Customer" %>
<%@page import="co.simplypos.persistence.Currency" %>
<%@page import="co.simplypos.model.utils.helpers.StringHelper" %>
<%@page import="java.sql.Connection" %>
<%@page import="java.util.GregorianCalendar" %>
<%@page import="java.util.Calendar" %>
<%@page import="java.util.TimeZone" %>
<%@page import="java.math.BigDecimal" %>
<%@page import="java.text.DecimalFormat" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Vector" %>
<%@page import="java.util.Hashtable" %>
<%@page import="java.io.File" %>
<%@page import="co.simplypos.model.website.page.view.QuickPayPageView"%>
<%@page import="co.simplypos.model.website.page.model.QuickPayPageModel"%>
<jsp:useBean id="website"  scope="application" class="co.simplypos.model.website.WebSite" />
<jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession" />
<%
try {
	/*if (userSession.getShoppingBasket().getTotalAmount() <= 0) {
		// either nothing in basket or order is fully paid using a voucher or promotion
		String forwardPage = "delivery.jsp";
		if (userSession.isShoppingBasketEmpty()) forwardPage = "basket.jsp"; 
		try {
      			response.sendRedirect(forwardPage);
		} catch (Exception e102) {
			out.write("<script type='text/javascript'>document.location.href='"+forwardPage+"';</script>");
		}		
       	return;	
	}*/

	QuickPayPageModel pageModel = (QuickPayPageModel) userSession.getWebController().getCurrentPageController().getPageModel();
	QuickPayPageView pageView = (QuickPayPageView) userSession.getWebController().getCurrentPageController().getPageView();

	if (userSession.getWebController().getCurrentPageController().getUserMessage() != null) {
		%>
		<script type="text/javascript">
			<!--
			alert("<%=userSession.getWebController().getCurrentPageController().getUserMessage()%>");
			//-->
		</script>
		<noscript><center><p><%=userSession.getWebController().getCurrentPageController().getUserMessage()%></center></noscript>
		<%
		return;
	}

	//website.writeToLog("pageModel.getValidationString(): "+pageModel.getValidationString()+"    pageModel.getErrorLevel(): "+pageModel.getErrorLevel()+"  request.getParameter(\"qc-postcode\"): "+request.getParameter("qc-postcode")+"   pageAction: "+pageModel.getPageAction());

	if (request.getParameter("cartId") != null && !userSession.getCurrentPaymentProvider().isProtx() && (request.getParameter("qc-postcode") == null && request.getParameter("qc-house") == null && request.getParameter("qc-name") == null && !pageModel.getPageAction().equals("quickpaypcl"))) {
		%>
		<form name="ppform" action="<%=("100".equals(website.getTestMode()) ? userSession.getCurrentPaymentProvider().getURL() : userSession.getCurrentPaymentProvider().getURL())%>" method="post">		
			<%=pageView.getPaymentFormParamtersHTML()%>
			<script type="text/javascript">
				<!--
				document.ppform.submit();
				//-->
			</script>
			<noscript><center><p>Please click button below to redirect to the payment gateway</p><input type="submit" value="Go"/></p></center></noscript>
		</form>
		<%
	}

	if (pageModel.getAuth3dACSURL() != null) {
		 // redirect to the banks 3d auth page
		 out.write("<form name=\"form\" action=\"" + pageModel.getAuth3dACSURL() + "\" method=\"post\">" +
				"<input type=\"hidden\" name=\"PaReq\" value=\"" + pageModel.getAuth3dPaReq() + "\"/>" +
				"<input type=\"hidden\" name=\"TermUrl\" value=\"" + pageModel.getAuth3dTermURL() + "\"/>" +
				"<input type=\"hidden\" name=\"MD\" value=\"" + pageModel.getAuth3dMD() + "\"/>" +
				"<script type=\"text/javascript\">document.form.submit();</script>" +
				"<noscript><center><p>Please click button below to Authenticate your card</p><input type=\"submit\" value=\"Go\"/></p></center></noscript>"+
				"</form>" );
		return;
    	}

	
	String addressPrefix = pageModel.getAddressPrefix();
	Hashtable deliveryAddressRow = pageModel.getDeliveryAddressRow();
	Hashtable billingAddressRow = pageModel.getBillingAddressRow();

	boolean highlighterUsed = false;
	boolean isPrimaryPaymentProviderProtx = (website.getPaymentProviders() != null && website.getPaymentProviders().size() > 0 && website.getPaymentProviders().get(0).isProtx());

	String basketDescription = "";
	if (userSession.getWebsiteAccessDomainId() > Customer.WEB_ACCESS_TYPE_NO_PRICES) { 
		basketDescription = userSession.getShoppingBasket().getTotalQuantityString()+" item"+(userSession.getShoppingBasket().getTotalQuantity()==1?"":"s")+" ordered at a total order price of "+pageModel.getFinalTotalString()+" "+(website.isShowDelivery()?"including delivery":"")+(website.getWebsiteMode() == WebSite.MODE_TRADE?" and VAT":"");
	} else {
		basketDescription = userSession.getShoppingBasket().getTotalQuantityString()+" item"+(userSession.getShoppingBasket().getTotalQuantity()==1?"":"s")+" ordered";
	}


	String iframeSrc = null;
	//out.write("pageModel.getBillingAddressRow(): "+pageModel.getBillingAddressRow());
	if (pageModel.getBillingAddressRow() != null && pageModel.getBillingAddressRow().size() > 0 && (!website.isUseQuickPayCheckout() || request.getParameter("cartId") == null)) {
		iframeSrc = co.simplypos.model.website.ProtxHelper.registerServerTransaction(userSession, request); 
	}
	//out.write("iframeSrc: "+iframeSrc+"   pageModel.getPageAction(): "+pageModel.getPageAction()+"   request.getParameter(action): "+request.getParameter("action")+"   pageModel.getErrorLevel(): "+pageModel.getErrorLevel()+"  pageModel.getValidationString(): "+pageModel.getValidationString());

	if (!website.isUseQuickPayCheckout()) {
		out.write("<div id=\"checkoutsteps\"><img src='"+website.getImagePath("checkoutprocess5.gif")+"'></div>");
	}
%>
<form name="payform" action="<%=pageModel.getActionPage()%>" method="post">
   <div id="quickpay">
	<% if (website.isUseQuickPayCheckout()) { %>
		<h1>Quick Payment</h1>
	<% } %>
	<% if (pageModel.getErrorLevel() > 0) {%>
		<div id="pagevalidationmessage">
			<img src="<%=website.getImagePath("icon_error.gif")%>">
			<div class="pagevalidationtext"><%=pageModel.getValidationString()%></div>
               </div>
	<% } %>
                      


	<div id="basketDescription">
		<h2>Purchase Summary</h2>
		<a href="basket.jsp">
			<%=basketDescription%>
		</a>
	</div>	

	<div id="quickpaydeliverydetails">
		<% if (billingAddressRow != null && pageModel.isAreBillingAndDeliveryAddressesTheSame()) { %>
			<h2>Invoice		
			<% if (website.getPersistenceManager().getAddress().areMandatoryColumnsCompleted(billingAddressRow, website.isTelephoneOrEmailMandatoryWithinAddress())) { %>
				<%=pageModel.isAddSeperateDeliveryAddress()?"Address</h2>":" and Delivery Address</h2> <a class=\"newaddress\" href=\"quickpay.jsp?sepadd=1\">Click here to add a separate delivery address</a>"%>
			<% } else { %>
				<%=pageModel.isAddSeperateDeliveryAddress()?"Address</h2>":" and Delivery Address</h2>"%>
			<% } %>
		<% } else if (billingAddressRow != null) { %>
			<h2>Invoice Address</h2>
 		<% } else if (billingAddressRow == null || !website.getPersistenceManager().getAddress().areMandatoryColumnsCompleted(billingAddressRow, website.isTelephoneOrEmailMandatoryWithinAddress())) { %>
			<h2> Invoice and Delivery Address</h2>
			<% if (!userSession.isLoggedIn()) { %>
				<a href="template/components/loginpopup.jsp" onclick="return GB_showCenter('Existing Customer Login', this.href, 280, 460, 0);" class="quickcheckoutlogin">
					<%=website.getText("quickpayExistingCustomerLogin","Existing Customer Login")%>
				</a>
			<% } %>
			<p class="addressentytext">Enter your address details</p>
			<jsp:include page="quickpaypostcodelookup.jsp">
        			<jsp:param name="addresstype" value="1" />
        		</jsp:include>
		<% } %>

		<% if (billingAddressRow != null) { %>
			<% if (website.getPersistenceManager().getAddress().areMandatoryColumnsCompleted(billingAddressRow, website.isTelephoneOrEmailMandatoryWithinAddress())) { %>
	
			<% } else { %>
				<img src="<%=website.getImagePath("icon_error.gif")%>" />
			<% } %>
			<% if (billingAddressRow != null) { %>
				<a class="addressline" href="template/components/changeaddrpopup.jsp?addressid=<%=billingAddressRow.get(addressPrefix+Address.ADDRESS_ID)%>&amp;addresstype=1" onclick="return GB_showCenter('Change Address Details', this.href, 580, 660, 0);">																										
				<% if (website.getPersistenceManager().getAddress().areMandatoryColumnsCompleted(billingAddressRow, website.isTelephoneOrEmailMandatoryWithinAddress())) { %>
					<%=billingAddressRow.get(addressPrefix+Address.CONTACT)%>&nbsp;-&nbsp;<%=Address.combineAddressLines(""+billingAddressRow.get(addressPrefix+Address.ADDRESS_LINE1), ""+billingAddressRow.get(addressPrefix+Address.ADDRESS_LINE2), ""+billingAddressRow.get(addressPrefix+Address.ADDRESS_LINE3), ""+billingAddressRow.get(addressPrefix+Address.COUNTY), ""+billingAddressRow.get(addressPrefix+Address.COUNTRY), ""+billingAddressRow.get(addressPrefix+Address.POST_CODE))%>
				<% } else { 
					if (website.getPersistenceManager().getAddress().areMandatoryColumnsCompleted(billingAddressRow, false)) {%>
						<span class="quickpayhighlight" quickpayaddressincomplete">Please give a method of contact, click here to enter an email address or telephone number.</span>
					<% } else { %>
					<span class="quickpayhighlight quickpayaddressincomplete">Invoice address is incomplete, click here to finish filling-in your address details.</span>
					<% }
				} %>
				</a>
			<% } else { %>
				Add Billing Address Here!!!!
			<% } %>
		<% } %>

		<% if (website.getPersistenceManager().getAddress().areMandatoryColumnsCompleted(billingAddressRow, website.isTelephoneOrEmailMandatoryWithinAddress())) {
			if (deliveryAddressRow != null && ((pageModel.isAreBillingAndDeliveryAddressesTheSame() && pageModel.isAddSeperateDeliveryAddress()))) { %>
				<% highlighterUsed = true; %> 
				<h2>Delivery Address</h2>
				Enter your address details. Alternatively, to use a previously entered address leave blank and click the 'Get Address' button.
				<jsp:include page="quickpaypostcodelookup.jsp">
					<jsp:param name="addresstype" value="2" />
				</jsp:include>
			<% } else if (deliveryAddressRow != null && !pageModel.isAreBillingAndDeliveryAddressesTheSame()) { %>	
				<h2>Delivery Address</h2>
				<% if (website.getPersistenceManager().getAddress().areMandatoryColumnsCompleted(deliveryAddressRow)) { %>
			
				<% } else { %>
					<img src="<%=website.getImagePath("icon_error.gif")%>" />
				<% } %>
				<% if (deliveryAddressRow != null) { %>
					<a class="addressline" href="template/components/changeaddrpopup.jsp?addressid=<%=deliveryAddressRow.get(addressPrefix+Address.ADDRESS_ID)%>&amp;addresstype=2" onclick="return GB_showCenter('Change Address Details',this.href, 580, 660, 0);">																																<% if (website.getPersistenceManager().getAddress().areMandatoryColumnsCompleted(deliveryAddressRow)) { %>
						<%=deliveryAddressRow.get(addressPrefix+Address.CONTACT)%>&nbsp;-&nbsp;<%=Address.combineAddressLines(""+deliveryAddressRow.get(addressPrefix+Address.ADDRESS_LINE1), ""+deliveryAddressRow.get(addressPrefix+Address.ADDRESS_LINE2), ""+deliveryAddressRow.get(addressPrefix+Address.ADDRESS_LINE3), ""+deliveryAddressRow.get(addressPrefix+Address.COUNTY), ""+deliveryAddressRow.get(addressPrefix+Address.COUNTRY), ""+deliveryAddressRow.get(addressPrefix+Address.POST_CODE))%>
				      <% } else { %>
					<span class="quickpayhighlight quickpayaddressincomplete">Delivery address is incomplete, click here to finish filling-in your address details.</span>
				      <% } %>
					</a>
				<% } else { %>
					Add Delivery Address Here!!!!
				<% } %>
			<% } 
 		}  %>
</div>

<% if (deliveryAddressRow != null && billingAddressRow != null) { %>
	<input type=hidden name="cartId" value='<%=userSession.getShoppingBasket().getTransactionId()%>'>
	<input type=hidden name="amount" value='<%=pageModel.getTotalOrderAmount()%>'>
	<input type=hidden name="currency" value='<%=userSession.getCurrencyAbbrev()%>'>
	<input type=hidden name="desc" value='<%=userSession.getShoppingBasket().getTotalQuantity()+" item"+(userSession.getShoppingBasket().getTotalQuantity()==1?"":"s")%> from <%=website.getWebsiteName()%>'>
	<input type=hidden name="testMode" value='<%=website.getTestMode()%>'>
	<input type=hidden name="name" value="<%=billingAddressRow.get(addressPrefix+Address.CONTACT)%>">
	<input type=hidden name="address" value='<%=Address.combineAddressLines(""+billingAddressRow.get(addressPrefix+Address.ADDRESS_LINE1),""+billingAddressRow.get(addressPrefix+Address.ADDRESS_LINE2),""+billingAddressRow.get(addressPrefix+Address.ADDRESS_LINE3))%>'>
	<input type=hidden name="address1" value='<%=""+billingAddressRow.get(addressPrefix+Address.ADDRESS_LINE1)%>'>
	<input type=hidden name="address2" value='<%=""+billingAddressRow.get(addressPrefix+Address.ADDRESS_LINE2)%>'>
	<input type=hidden name="address3" value='<%=""+billingAddressRow.get(addressPrefix+Address.ADDRESS_LINE3)%>'>
	<input type=hidden name="postcode" value='<%=""+billingAddressRow.get(addressPrefix+Address.POST_CODE)%>'>
	<input type=hidden name="county" value='<%=billingAddressRow.get(addressPrefix+Address.COUNTY)%>'>
	<input type=hidden name="country" value='<%=billingAddressRow.get(addressPrefix+Address.COUNTRY)%>'>
	<input type=hidden name="tel" value='<%=billingAddressRow.get(addressPrefix+Address.TELEPHONE)%>'>
	<input type=hidden name="email" value='<%=billingAddressRow.get(addressPrefix+Address.EMAIL_ADDRESS)%>'>
	<input type=hidden name="delvName" value='<%=deliveryAddressRow.get(addressPrefix+Address.CONTACT)%>'>
	<input type=hidden name="delvAddress" value='<%=Address.combineAddressLines(""+deliveryAddressRow.get(addressPrefix+Address.ADDRESS_LINE1),""+deliveryAddressRow.get(addressPrefix+Address.ADDRESS_LINE2),""+deliveryAddressRow.get(addressPrefix+Address.ADDRESS_LINE3))%>'>
	<input type=hidden name="delvAddress1" value='<%=""+deliveryAddressRow.get(addressPrefix+Address.ADDRESS_LINE1)%>'>
	<input type=hidden name="delvAddress2" value='<%=""+deliveryAddressRow.get(addressPrefix+Address.ADDRESS_LINE2)%>'>
	<input type=hidden name="delvAddress3" value='<%=""+deliveryAddressRow.get(addressPrefix+Address.ADDRESS_LINE3)%>'>
	<input type=hidden name="delvPostcode" value='<%=deliveryAddressRow.get(addressPrefix+Address.POST_CODE)%>'>
	<input type=hidden name="delvCounty" value='<%=deliveryAddressRow.get(addressPrefix+Address.COUNTY)%>'">
	<input type=hidden name="delvCountry" value='<%=deliveryAddressRow.get(addressPrefix+Address.COUNTRY)%>'>
	<input type=hidden name="fixContact">
	<input type=hidden name="formatAmount" value='<%=pageModel.getFinalTotalString()%>'>
	<% if (!new BigDecimal(userSession.getExchangeRate()).setScale(2,BigDecimal.ROUND_HALF_EVEN).equals(new BigDecimal(1.00))) {  %>
		<input type=hidden name="exchangeRate" value='<%=userSession.getExchangeRate()%>'>
	<% } %>
<% } %>
				<% 
	   if (billingAddressRow != null && website.getPersistenceManager().getAddress().areMandatoryColumnsCompleted(billingAddressRow, website.isTelephoneOrEmailMandatoryWithinAddress()) && (deliveryAddressRow == null || website.getPersistenceManager().getAddress().areMandatoryColumnsCompleted(deliveryAddressRow))) {
		// do nothing
	   } else {
		highlighterUsed = true;
	   }
	   if (pageModel.getErrorLevel() < 2) {
		if (pageModel.isShowPayForm() && ShoppingBasket.isFullyPaidByVoucher(userSession, request)) {

			String disabledText = "disabled";
			if (pageModel.isShowPayForm()) { 
				if (!highlighterUsed) { 
					disabledText = ""; 
				%>
					
						
							<table id="paybycardtable" class="quickpayhighlight">
				<% } %>
			<% } %>
			
			<% if (highlighterUsed) { %>
				<td class="quickpayheader">
					<div id="paybycardheader">Fully Paid By Voucher</div>
				
			<% } else { %>
				
					<div id="paybycardheader" class="quickpayheader">
						<span class="pagetitle quickpayheader quickpayheadertext">Fully Paid By Voucher</span>
					</div>
				
			<% } %>
			
			
					


			<input type='hidden' name='action' value='sendpayment'>
			<%
			 java.util.Enumeration en = request.getParameterNames();
		        while (en.hasMoreElements()) {
		        	String paramName = (String)en.nextElement();
		        	String paramValue = request.getParameter(paramName);
				out.write("<input type='hidden' name='"+paramName+"' value='"+paramValue+"'>\n");        
			 }
			

		} else {
		  if (isPrimaryPaymentProviderProtx) {
			String disabledText = "disabled";
			if (pageModel.isShowPayForm()) {
				if (!highlighterUsed) { 
					disabledText = ""; 
					String preIframeFile = "preIframeInstructions.jsp";
					File preIframe = new File(website.getWebSitePath()+preIframeFile);
					if (preIframe.exists()) { %>
						<jsp:include page="../../preIframeInstructions.jsp"/>
					<% } %>

				<% } %>
			<% } %>
			
			<% if (highlighterUsed) { 
				if (1==0) { %>

						<div id="paybycardheader">Card Details</div>
					
				<% } %>
			<% } else { %>
				
					<div id="paybycardheader" class="quickpayheader">
						<h2>Pay by card</h2>
					</div>
				
			<% } %>
			
<% if (iframeSrc != null) {%>
<div id="sagepayformouterdiv">
	<div id="sagepayformdiv">
		<iframe  name="sagepayform" id="sagepayform" src="<%=iframeSrc%>" scrolling="auto" width="580" height="655" frameborder="0" marginheight="0" marginwidth="0"></iframe>
	</div>
</div>
<% } %>
			<!--// end pay by card //-->
		  <% } %>

		  <!--// Alternative Payment //--->
		  <% if (!highlighterUsed) { %>
			<% if (website.getPaymentProviders() != null && (!isPrimaryPaymentProviderProtx || website.getPaymentProviders().size() > 1)) {  %>							
									<div id="paymentoptionsheader" class="quickpayheader">
										<h2><%=isPrimaryPaymentProviderProtx?"Alternative Payment Options":"Payment Options"%></h2>
									</div>
									<div id="additionalpaymentimages">	
										<% if (isPrimaryPaymentProviderProtx) { %>
											<%=pageView.getAdditionalPaymentProviderImagesHTML()%>
										<% } else { %>
											<%=pageView.getPaymentProviderImagesHTML()%>
										<% } %>
									</div>	
			<% } %>
		  <% } %>
		<% } %>
		<input type='hidden' name='ot' value='<%=pageModel.getFormatAmount()%>'> 
		<input type='hidden' name='ref' value='<%=userSession.getShoppingBasket().getTransactionId()%>'> 
		<% if (userSession.getCurrentPaymentProvider() == null) { %>
<a href=<%="'"+userSession.getLastURL()+"'"%> class="button">
<img src="<%=website.getImagePath("btnleft.gif")%>" alt="" class="btnLeft"/>
Back
</a>
<a href="javascript: document.payform.submit();" class="button">Place Order
<img src="<%=website.getImagePath("btnright.gif")%>" alt="" class="btnRight" />
</a>
		<% } %>
	 <% } %>
   </div>
</form>
<%

} catch (Exception eeeee) {
	website.writeToLog(eeeee);
	out.write("Error: "+eeeee.getMessage());
}
%>
