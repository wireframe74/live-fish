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
<%@page import="co.simplypos.model.website.page.view.ConfirmPageView"%>
<%@page import="co.simplypos.model.website.page.model.ConfirmPageModel"%>
<jsp:useBean id="website"  scope="application" class="co.simplypos.model.website.WebSite" />
<jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession" />
<%
	ConfirmPageModel pageModel = (ConfirmPageModel) userSession.getWebController().getCurrentPageController().getPageModel();
	ConfirmPageView pageView = (ConfirmPageView) userSession.getWebController().getCurrentPageController().getPageView();

	String addressPrefix = pageModel.getAddressPrefix();
	Hashtable deliveryAddressRow = pageModel.getDeliveryAddressRow();
	Hashtable billingAddressRow = pageModel.getBillingAddressRow();
	
	if (userSession.getWebController().getCurrentPageController().getUserMessage() != null) {
		%>
		<script type="text/javascript">
			<!--
			alert("<%=userSession.getWebController().getCurrentPageController().getUserMessage()%>");
			//-->
		</script>
		<%
		return;
	}
	
	if (request.getParameter("step") != null) {
	} else if (request.getParameter("cartId") != null) {
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

if (request.getParameter("src") != null && request.getParameter("src").equals("pay")) {
	out.write("from pay so stop");
	return;
}
%>
<form name="payform" action="<%=pageModel.getActionPage()%>" method="post">

			


<div class="pagetopnav">
	<ul class="crumb blocklist">
		<%=userSession.getTrailHTML("Confirm Order Details", userSession.getFullURL(request), true)%>
	</ul>
	<ul class="navPage blocklistright">

		<% if (website.isAllowChequePayment()) { %>
			<li class="buttonchequepayment">
				<a href="host.jsp?pg=chequepayment.jsp">
			</li>
		<% } %>
		<% if (userSession.getCurrentPaymentProvider() == null || (website.getPaymentProviders().size() > 0 && website.getPaymentProviders().get(0).getPaymentProviderKey().equalsIgnoreCase("order"))) {%>
			<li class="buttonplaceorder">
				<a href="javascript: document.payform.submit();"> <%=website.getText("confirmplaceorderbutton","Place Order")%> </a>
			</li>
		<% } else if (website.getPaymentProviders() != null && website.getPaymentProviders().size() == 1) {  %>

		<li class="buttongotocheckout">
			<a href="javascript: document.payform.submit();" > <%=website.getText("confirmcheckoutbutton","Checkout")%> </a>
		</li>
		<% } else { //more than 1 payment provider%>
			<% if (website.getPaymentProviders() != null && website.getPaymentProviders().size() > 0) {  %>
				<%=pageView.getPaymentProviderImagesHTML()%>
			<%}%>
		<%}%>
		<li class="buttonbacktoshop">
			<a href="delivery.jsp"> <%=website.getText("confirmbacktoshopbutton","Back to Shop")%> </a>
		</li>
	</ul>
</div>


<div class="pagetitle"><h1><%=website.getText("confirmheaderone","Confirm Order Details")%></h1></div>

<div>
	<img src="<%=website.getImagePath("checkoutprocess4.gif")%>" alt="Confirm Order" />         
</div>
<div id="confirmordersummary">
	<div class="pagesubtitle"><h2><%=website.getText("confirmheadertwo","Purchase Summary")%></h2></div>
	<ul id="confirmordersummarylist" class="contentform">
		<li id="confirmpurcahselinepurhcases">
			<% if (userSession.getWebsiteAccessDomainId() > Customer.WEB_ACCESS_TYPE_NO_PRICES) { %>
				<a href="basket.jsp"> 
					<%=userSession.getShoppingBasket().getTotalQuantityString()%> <%=website.getText("confirmitem"," item")%><%=userSession.getShoppingBasket().getTotalQuantity()==1?"":website.getText("confirmitems","s")%> <%=website.getText("confirmtotalpricetext"," ordered at a total order price of ")%>  <%=pageModel.getFinalTotalString()%> <%=(website.isShowDelivery() ? "including delivery " : "")%><%=(website.getWebsiteMode() == WebSite.MODE_TRADE?website.getText("confirmandvattext","and VAT"):"")%>
				</a>
			<% } else { %>
				<a href="basket.jsp">
					<%=userSession.getShoppingBasket().getTotalQuantityString()%> <%=website.getText("confirmitem"," item")%><%=userSession.getShoppingBasket().getTotalQuantity()==1?"": website.getText("confirmitems","s")%> <%=website.getText("confirmorderedtext"," ordered ")%>
				</a>
			<% } %>
		</li>
		<li id="confirminvoicelineinvoice">
			<ul class="labelpairtop">
				<li class="label"> <%=website.getText("confirminvoicelinelabel","Invoice Address")%> </li>
				<li class="textvalue"> 
					<a href='changeaddr.jsp?addressid=<%=billingAddressRow.get(addressPrefix+Address.ADDRESS_ID)%>'>
						<%=billingAddressRow.get(addressPrefix+Address.CONTACT)%> - <%=Address.combineAddressLines(""+billingAddressRow.get(addressPrefix+Address.ADDRESS_LINE1), ""+billingAddressRow.get(addressPrefix+Address.ADDRESS_LINE2), ""+billingAddressRow.get(addressPrefix+Address.ADDRESS_LINE3), ""+billingAddressRow.get(addressPrefix+Address.COUNTY), ""+billingAddressRow.get(addressPrefix+Address.COUNTRY), ""+billingAddressRow.get(addressPrefix+Address.POST_CODE))%>
					</a>
				</li>
			</ul>
		</li>
		<li id="confirmdeliverylinedelivery">
			<ul class="labelpairtop">
				<li class="label"> <%=website.getText("confirmdeliverylinelabel","Delivery Address")%> </li>
				<li class="textvalue">	
					<a href='changeaddr.jsp?addressid=<%=deliveryAddressRow.get(addressPrefix+Address.ADDRESS_ID)%>'>
							<%=deliveryAddressRow.get(addressPrefix+Address.CONTACT)%> - <%=Address.combineAddressLines(""+deliveryAddressRow.get(addressPrefix+Address.ADDRESS_LINE1), ""+deliveryAddressRow.get(addressPrefix+Address.ADDRESS_LINE2), ""+deliveryAddressRow.get(addressPrefix+Address.ADDRESS_LINE3), ""+deliveryAddressRow.get(addressPrefix+Address.COUNTY), ""+deliveryAddressRow.get(addressPrefix+Address.COUNTRY), ""+deliveryAddressRow.get(addressPrefix+Address.POST_CODE))%>
					</a>
				</li>
			</ul>
		</li>
	</ul>
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
	<% if (!new BigDecimal(userSession.getExchangeRate()).setScale(2,BigDecimal.ROUND_HALF_EVEN).equals(new BigDecimal(1.00))) { %>
	<input type=hidden name="exchangeRate" value='<%=userSession.getExchangeRate()%>'>
	<% } %>
</div>

<div id="checkoutconfirmnotes">
	<ul class="contentform">
	<% if (!pageModel.isNoteAdded()) { 
		File preInstructions = new File(website.getWebSitePath()+"preInstructions.html");
		if (preInstructions != null && preInstructions.exists()) {
		%>
			<jsp:include page="../../preInstructions.html"/>
		<%} else { %>
			<%=website.getText("confirmdeliverynotes","If there is anything else you need to tell us, then simply type it into the box below:")%>		
		<% } %>
	
		<li class="textbox"><textarea name="notes" rows="5" cols="61" class="textareaitem" ><%=pageModel.getNotes()%></textarea></li>
		<input type="hidden" name="finalTotalString" value="<%=pageModel.getFinalTotalString()%>" />
																												
		<% File postInstructions = new File(website.getWebSitePath()+"postInstructions.html");
	   	if (postInstructions != null && postInstructions.exists()) {
			%>
				<jsp:include page="../../postInstructions.html"/>
		<% } %>
	<% } else { %>
		<%=pageModel.getNotes()%>
		<%=website.getText("confirmdeliverynoteupdated","Updated")%>														
	<% } %>
</div>
<div class="pagebottomnav">
	<ul class="crumb blocklist">
		<li><%=pageView.getTrailHTML("Confirmation", request)%></li>
	</ul>
	<ul class="navPage blocklistright">
		<% if (website.isAllowChequePayment()) { %>
			<li class="buttonchequepayment">
				<a href="host.jsp?pg=chequepayment.jsp">
			</li>
		<% } %>
		<% if (userSession.getCurrentPaymentProvider() == null || (website.getPaymentProviders().size() > 0 && website.getPaymentProviders().get(0).getPaymentProviderKey().equalsIgnoreCase("order"))) {%>
			<li class="buttonplaceorder">
				<a href="javascript: document.payform.submit();"> <%=website.getText("confirmplaceorderbutton","Place Order")%> </a>
			</li>
		<% } else if (website.getPaymentProviders() != null && website.getPaymentProviders().size() == 1) {  %>

		<li class="buttongotocheckout">
			<a href="javascript: document.payform.submit();" > <%=website.getText("confirmcheckoutbutton","Checkout")%> </a>
		</li>
		<% } else { //more than 1 payment provider%>
			<% if (website.getPaymentProviders() != null && website.getPaymentProviders().size() > 0) {  %>
				<%=pageView.getPaymentProviderImagesHTML()%>
			<%}%>
		<%}%>
		<li class="buttonbacktoshop">
			<a href="delivery.jsp"> <%=website.getText("confirmbacktoshopbutton","Back to Shop")%> </a>
		</li>
	</ul>
</div>

</form>
<% if (request.getParameter("step") != null && (""+request.getParameter("step")).equals("2")) { %>
	<script type="text/javascript">
		if (confirm('Confirm final order submission?\n\nClick OK to confirm your are submitting your final order for delivery.\n\nClick Cancel to submit an update request only.\n\n')) {
			document.location.href='confirm.jsp?cartId=<%=request.getParameter("cartId")%>&finalorder=1&email=<%=request.getParameter("email")%>&step=3';
		} else {
			document.location.href='confirm.jsp?cartId=<%=request.getParameter("cartId")%>&finalorder=0&email=<%=request.getParameter("email")%>&step=3';
		};
	</script>
	<noscript><div id="orderstep3nos"><center><p>Please confirm wether you are submitting an update request to your order or your final order for delivery.</p><a href="confirm.jsp?cartId=<%=request.getParameter("cartId")%>&finalorder=0&email=<%=request.getParameter("email")%>&step=3">Send Order Update Request</a><a href="confirm.jsp?cartId=<%=request.getParameter("cartId")%>&finalorder=1&email=<%=request.getParameter("email")%>&step=3">Send Final Order</a></p></center></div></noscript>
<% } %>