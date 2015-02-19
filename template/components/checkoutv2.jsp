<!-- start of components/quickpay.jsp -->
<%@page import="java.io.FileOutputStream"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileReader"%>
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
<%@page import="co.simplypos.model.website.payment.PaymentProvider" %>
<%@page import="javax.swing.table.DefaultTableModel" %>
<%@page import="co.simplypos.model.website.WebDiscountManager" %>
<%@page import="co.simplypos.model.TransactionManager" %>
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
<%@page import="co.simplypos.model.website.RenderImageServlet" %>
<%@page import="co.simplypos.model.website.ArticleDetail" %>
<jsp:useBean id="website"  scope="application" class="co.simplypos.model.website.WebSite" />
<jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession" />
<% userSession.getWebController().processRegisterPage(request);
QuickPayPageModel pageModel = (QuickPayPageModel) userSession.getWebController().getCurrentPageController().getPageModel();
QuickPayPageView pageView = (QuickPayPageView) userSession.getWebController().getCurrentPageController().getPageView();

String addressPrefix = pageModel.getAddressPrefix();
Hashtable deliveryAddressRow = pageModel.getDeliveryAddressRow();
Hashtable billingAddressRow = pageModel.getBillingAddressRow();

String actionPay = ""+request.getParameter("actionPay");

String iframeSrc = null;

if( actionPay != null && !actionPay.trim().equals("") && !actionPay.trim().equals("null") ){

	Connection conn = null;
	int custId  = userSession.getLoggedInCustomerId();
	int addressId = 0;
	if (request.getAttribute("addressid") != null) {
		try {
			addressId = Integer.parseInt(""+request.getAttribute("addressid"));
		} catch (NumberFormatException nfe23) {
			addressId = 0;
		}
	}
	int transId = userSession.getShoppingBasket().getTransactionId();
	
	try {
		conn = website.getConnection();
		userSession.getWebController().addTransactionAddress(conn, custId, addressId, transId, 1);
		conn.commit();
	} finally {
		website.releaseConnection(conn);
	}
	
	
	if( actionPay.equals("iframe") ){
		
		iframeSrc = "";
		iframeSrc = co.simplypos.model.website.ProtxHelper.registerServerTransaction(userSession, request);
		
	} else {
		
		out.write(actionPay+"!<br/>");
		//String actionPayUrl = ""+request.getParameter("actionPayUrl");
		//response.sendRedirect(actionPayUrl);
		
	}
	
}%>


<div class="checkoutv2Left">

	<%if (pageModel.getAuth3dACSURL() != null) {
	
		%><div class="checkoutv2IframeHold">
			<form name="form" action="<%=pageModel.getAuth3dACSURL()%>" method="post">
				<input type="hidden" name="PaReq" value="<%=pageModel.getAuth3dPaReq()%>" />
				<input type="hidden" name="TermUrl" value="<%=pageModel.getAuth3dTermURL()%>" />
				<input type="hidden" name="MD" value="<%=pageModel.getAuth3dMD()%>" />
				<script type="text/javascript">document.form.submit();</script>
				<noscript><h2>Please click button below to authenticate your card:</h2><input type="submit" value="Go" class="button" /></noscript>
			</form>
		</div><%
		
    } else if( iframeSrc != null ){ %>
		
		<div class="checkoutv2IframeHold">
			<iframe class="sagepayform" src="<%=iframeSrc%>" width="100%" height="655px"></iframe>
		</div>
		
	<% } else { %>

		<% if (!userSession.isLoggedIn()) { %>
			
			<div class="checkoutv2Login">
				
				<h2 class="checkoutv2LoginTitle">Existing Customer Login</h2>
				
				<% final String initialValidationString = "Please enter your ";
				String validationString = initialValidationString ;
				
				if (request.getAttribute("validationString") != null){
					validationString = (String)request.getAttribute("validationString");
				}

				String paramAction = ""+request.getParameter("action");
				
				if (request.getAttribute("action") != null){
					paramAction = (String)request.getAttribute("action");
				}

				if (paramAction.equals("forgot") && validationString.equals(initialValidationString)) {
					validationString = "An email has been sent containing your password.";
				}
				
				if (paramAction.equals("login") && validationString.equals(initialValidationString)) { %>
				
					<p>Login Successful</p>
					
					<% response.sendRedirect("checkoutv2.jsp"); %>
				
				<%} else { %>
				
					<form name="logindetails" method="post">
						
						<input type="hidden" name="action" value="login">
						<input type="hidden" name="src" value="">
						
						<label for="emailaddress">Email Address</label>
						<input class="inputitem loginpopupemail" type="text" name="emailaddress" id="emailaddress" placeholder="Email Address">
						
						<label for="password">Password</label>
						<input class="inputitem loginpopuppassword" type="password" name="password" id="password" placeholder="Password">
					
					
						<% if (!validationString.equals(initialValidationString)) { %>
							<div id="pagevalidationmessage">
								<%=validationString%>
							</div>
						<% } %>
						
						<div class="checkoutLoginButtons">
							<a class="button" href="javascript:document.logindetails.action.value='forgot';document.logindetails.submit();">
								Forgotten your password?
							</a>
							
							<button type="submit" class="button">Login</button>
						</div>
						
					</form>
				
				<%}%>
				
			</div>
			
		<% } %>
		
		
		<form method="post" onSubmit="return checkoutFormValidate();">
		
			<div class="checkoutv2Address">
			
				<h2 class="checkoutv2AddressTitle">Invoice Address</h2>
				
				<% if( !userSession.isLoggedIn() || (deliveryAddressRow == null || billingAddressRow == null) ){ %>
				
					<div class="pclForm">
					
						<input type="hidden" name="src" value="" />
						<input type="hidden" name="addresstype" value="1" />
					
						<label for="qc-house">House Number/Street</label>
						<input class="inputitem" type="text" name="qc-house" id="qc-house" placeholder="House Number/Street">
						
						<label for="qc-postcode">Postcode</label>
						<input class="inputitem" type="text" name="qc-postcode" id="qc-postcode" placeholder="Postcode">
						
						<div class="buttonHold">
							<button type="submit" class="button" name="action" value="quickpaypcl">Find Address</button>
						</div>
						
					</div>
				
				<% } %>
				
				<input type="hidden" name="action" value="update"/>
				<input type="hidden" name="cartId" value='<%=userSession.getShoppingBasket().getTransactionId()%>'>
				<input type="hidden" name="amount" value='<%=pageModel.getTotalOrderAmount()%>'>
				<input type="hidden" name="currency" value='<%=userSession.getCurrencyAbbrev()%>'>
				<input type="hidden" name="desc" value='<%=userSession.getShoppingBasket().getTotalQuantity()+" item"+(userSession.getShoppingBasket().getTotalQuantity()==1?"":"s")%> from <%=website.getWebsiteName()%>'>
				<input type="hidden" name="testMode" value='<%=website.getTestMode()%>'>
				<% if (!new BigDecimal(userSession.getExchangeRate()).setScale(2,BigDecimal.ROUND_HALF_EVEN).equals(new BigDecimal(1.00))) {  %>
					<input type="hidden" name="exchangeRate" value='<%=userSession.getExchangeRate()%>'>
				<% } %>
				<input type="hidden" name="fixContact">
				<input type="hidden" name="formatAmount" value='<%=pageModel.getFinalTotalString()%>'>
				<input type="hidden" name="ot" value='<%=pageModel.getFormatAmount()%>'> 
				<input type="hidden" name="ref" value='<%=userSession.getShoppingBasket().getTransactionId()%>'> 
				
				
				<input type="hidden" name="address" id="address" value='<%=billingAddressRow != null?Address.combineAddressLines(""+billingAddressRow.get(addressPrefix+Address.ADDRESS_LINE1),""+billingAddressRow.get(addressPrefix+Address.ADDRESS_LINE2),""+billingAddressRow.get(addressPrefix+Address.ADDRESS_LINE3)):""%>'>
				<input type="hidden" name="delvAddress" id="delvAddress" value='<%=deliveryAddressRow != null?Address.combineAddressLines(""+deliveryAddressRow.get(addressPrefix+Address.ADDRESS_LINE1),""+deliveryAddressRow.get(addressPrefix+Address.ADDRESS_LINE2),""+deliveryAddressRow.get(addressPrefix+Address.ADDRESS_LINE3)):""%>'>
				
				
				<label for="name">Full Name*</label>
				<input type="text" name="name" id="name" value="<%=billingAddressRow != null?billingAddressRow.get(addressPrefix+Address.CONTACT):""%>" placeholder="John Smith">
				
				<label for="address1">Address*</label>
				<input type="text" name="address1" id="address1" value='<%=billingAddressRow != null?""+billingAddressRow.get(addressPrefix+Address.ADDRESS_LINE1):""%>' placeholder="123 Road Name">
				<input type="text" name="address2" id="address2" value='<%=billingAddressRow != null?""+billingAddressRow.get(addressPrefix+Address.ADDRESS_LINE2):""%>' placeholder="Town Name">
				<input type="text" name="address3" id="address3" value='<%=billingAddressRow != null?""+billingAddressRow.get(addressPrefix+Address.ADDRESS_LINE3):""%>' placeholder="City Name">
				
				<label for="postcode">Postcode*</label>
				<input type="text" name="postcode" id="postcode" value='<%=billingAddressRow != null?""+billingAddressRow.get(addressPrefix+Address.POST_CODE):""%>' placeholder="Postcode" pattern="^[0-9a-zA-Z ]{7,}$">
				
				<label for="county">State</label>
				<input type="text" name="county" id="county" value='<%=billingAddressRow != null?billingAddressRow.get(addressPrefix+Address.COUNTY):""%>' placeholder="County/Region">
				
				<label for="country">Country</label>
				<%File codes = new File(website.getWebSitePath()+"CountryCodes.txt");
				if (codes.exists()) {
					BufferedReader reader = new BufferedReader(new FileReader( website.getWebSitePath()+"CountryCodes.txt" ));
					String line = null;
					%><select name="country" id="country"><%
					while ((line = reader.readLine()) != null) {
						String[] fields = line.split(",");
						String curAdd = "a";
						String thisAdd = "b";
						thisAdd = fields[1].toString();
						String add = null;
						try{
							add = billingAddressRow.get(addressPrefix+Address.COUNTRY).toString();
						}catch(Exception x){}
						if( add != null && !add.equals("") ){
							curAdd = add;
						}else{
							curAdd = "GB";
						}
						%><option value="<%=fields[1].toString()%>" <%=curAdd.equals(thisAdd)?"selected='selected'":""%> ><%=fields[0].toString()%></option><%
					}
					%></select><%
				} else {%>
					<input type="text" name="country" id="country" value='<%=billingAddressRow != null?billingAddressRow.get(addressPrefix+Address.COUNTRY):""%>' placeholder="Country">
				<% } %>
				
				<label for="tel">Telephone<%=website.isTelephoneMandatoryWithinAddress()?"*":""%></label>
				<input type="text" name="tel" id="tel" value='<%=billingAddressRow != null?billingAddressRow.get(addressPrefix+Address.TELEPHONE):""%>' placeholder="01234 567 890" pattern="^[0-9]*[0-9]$">
				
				<label for="email">Email Address<%=website.isEmailMandatoryWithinAddress()?"*":""%></label>
				<input type="email" name="email" id="email" value='<%=billingAddressRow != null?billingAddressRow.get(addressPrefix+Address.EMAIL_ADDRESS):""%>' placeholder="john@internet.com">
				
				<label>* Please complete all fields marked by an asterisk</label>
				
			</div>
			
			<div class="checkoutv2Address">
				
				<h2 class="checkoutv2Address2Title">Delivery Address</h2>
				
				<div class="checkboxHold">
					<input class="inputCheck" type="checkbox" checked="checked" onClick="$('.checkoutv2DeliveryAdd').toggle();" /><label>Delivery address is the same as invoice address</label>
				</div>
				
				<div class="checkoutv2DeliveryAdd" style="display:none;">
					
					<label for="delvName">Full Name*</label>
					<input type="text" name="delvName" id="delvName" value='<%=deliveryAddressRow != null?deliveryAddressRow.get(addressPrefix+Address.CONTACT):""%>' placeholder="John Smith">
					
					<label for="delvAddress1">Address*</label>
					<input type="text" name="delvAddress1" id="delvAddress1" value='<%=deliveryAddressRow != null?""+deliveryAddressRow.get(addressPrefix+Address.ADDRESS_LINE1):""%>' placeholder="123 Road Name">
					<input type="text" name="delvAddress2" id="delvAddress2" value='<%=deliveryAddressRow != null?""+deliveryAddressRow.get(addressPrefix+Address.ADDRESS_LINE2):""%>' placeholder="Town Name">
					<input type="text" name="delvAddress3" id="delvAddress3" value='<%=deliveryAddressRow != null?""+deliveryAddressRow.get(addressPrefix+Address.ADDRESS_LINE3):""%>' placeholder="City Name">
					
					<label for="delvPostcode">Postcode*</label>
					<input type="text" name="delvPostcode" id="delvPostcode" value='<%=deliveryAddressRow != null?deliveryAddressRow.get(addressPrefix+Address.POST_CODE):""%>' placeholder="Postcode">
					
					<label for="delvCounty">County</label>
					<input type="text" name="delvCounty" id="delvCounty" value='<%=deliveryAddressRow != null?deliveryAddressRow.get(addressPrefix+Address.COUNTY):""%>' placeholder="County/Region">
					
					<label for="delvCountry">Country</label>
					<%if (codes.exists()) {
						BufferedReader reader = new BufferedReader(new FileReader( website.getWebSitePath()+"CountryCodes.txt" ));
						String line = null;
						%><select name="delvCountry" id="delvCountry"><%
						while ((line = reader.readLine()) != null) {
							String[] fields = line.split(",");
							String curAdd = "a";
							String thisAdd = "b";
							thisAdd = fields[1].toString();
							String delvAdd = null;
							try{
								delvAdd = deliveryAddressRow.get(addressPrefix+Address.COUNTRY).toString();
							}catch(Exception x){}
							if( delvAdd != null && !delvAdd.equals("")){
								curAdd = delvAdd;
							}else{
								curAdd = "GB";
							}
							%><option value="<%=fields[1].toString()%>" <%=curAdd.equals(thisAdd)?"selected='selected'":""%> ><%=fields[0].toString()%></option><%
						}
						%></select><%
					} else {%>
						<input type="text" name="delvCountry" id="delvCountry" value='<%=deliveryAddressRow != null?deliveryAddressRow.get(addressPrefix+Address.COUNTRY):""%>' placeholder="Country">
					<% } %>
				
					<label>* Please complete all fields marked by an asterisk</label>
				
				</div>
				
				<label for="carriageregion">Delivery Area</label>
				<select name="carriageregion" id="carriageregion">
					<%int carriageRegionDomainId = Integer.parseInt(""+userSession.getShoppingBasket().getCarriageRegionId());%>
					<%=userSession.getCarriageRegionsHTML(carriageRegionDomainId)%>
				</select>
				
			</div>
			
			
			<div class="checkoutv2DeliveryIn">
				
				<h2>Delivery Instructions</h2>
				
				<label for="specialinstructions">Notes for your delivery driver</label>
				<textarea name="specialinstructions" id="specialinstructions"></textarea>
				
			</div>
			
			
			<div class="checkoutv2Checkout">
				
				<h2>Checkout</h2>
				
				<%File preIframe = new File(website.getWebSitePath()+"preIframeInstructions.jsp");
				if (preIframe.exists()) { %>
					<jsp:include page="../../preIframeInstructions.jsp"/>
				<% } %>
				
				<div class="checkoutv2ValidationMsg"></div>
				
				<div class="checkoutv2Btns">
					
					<%if( website.getPaymentProviders() != null && website.getPaymentProviders().size() >= 1 ){
						
						ArrayList<PaymentProvider> paymentProviders = website.getPaymentProviders();
						boolean isProtx = false;
						for (PaymentProvider provider : paymentProviders) {
							
							if( provider.isProtx() ){
								isProtx = true;
							} else {
								%><button type="submit" class="button checkoutBtn checkoutBtn-<%=provider.getPaymentProviderKey()%>" name="actionPay" value="<%=provider.getPaymentProviderKey()%>">Checkout with <%=provider.getPaymentProviderKey()%></button><%
							}
							
						}
						
						if( isProtx ){
							%><button type="submit" class="button checkoutBtn checkoutBtn-iframe" name="actionPay" value="iframe">Checkout</button><%
						}
						
					}%>
				
				</div>
				
			</div>
			
		</form>
	
	<% } %>
	
</div><!--

--><div class="checkoutv2Right">
	
	<div class="checkoutv2Basket">
	
		<h2>Basket</h2>
		
		<div>
			
			<% float totPrice = 0;
			DefaultTableModel consoleTableModel = userSession.getShoppingBasket().getConsoleTableModel();
			WebDiscountManager discountManager = (WebDiscountManager)userSession.getShoppingBasket().getDiscountManager();
			for (int i=0;i<consoleTableModel.getRowCount();i++) {
				if (!discountManager.isDiscountRow(i)) {
					int quantity = userSession.getShoppingBasket().getIntValueAt(i, TransactionManager.COLUMN_ITEMS);
					float salePrice = discountManager.getQtyPriceIncludingDiscountsSoFar(i, userSession.getExchangeRate());
					float wrappingPrice = userSession.getShoppingBasket().getFloatValueAt(i, TransactionManager.COLUMN_WRAPPING_PRICE);
					float messagePrice = userSession.getShoppingBasket().getFloatValueAt(i, TransactionManager.COLUMN_MESSAGE_PRICE);
					wrappingPrice = new BigDecimal(wrappingPrice*userSession.getExchangeRate()).setScale(2, BigDecimal.ROUND_HALF_EVEN).floatValue();
					messagePrice = new BigDecimal(messagePrice*userSession.getExchangeRate()).setScale(2, BigDecimal.ROUND_HALF_EVEN).floatValue();
					
					float linePrice = salePrice + (quantity * wrappingPrice) + (quantity * messagePrice);
					totPrice += linePrice;
					
					int vendorArticleId = userSession.getShoppingBasket().getIntValueAt(i, TransactionManager.COLUMN_VENDOR_ARTICLE_ID);
					int vendorArticleClsfnId = userSession.getShoppingBasket().getIntValueAt(i, TransactionManager.COLUMN_VENDOR_ARTICLE_CLSFN_ID);
					float itemPrice = userSession.getShoppingBasket().getFloatValueAt(i, TransactionManager.COLUMN_UNIT_PRICE);
					
					ArticleDetail articleDetail = userSession.getArticleDetail();
					Hashtable row = articleDetail.getRow(vendorArticleClsfnId);
					String shortDescription = (String)row.get(ArticleDetail.SHORT_DESCRIPTION);
					int blobStorageId = 0;
					try {
						blobStorageId = articleDetail.getPrimaryImage().getBlobStorageId();
					} catch (Exception ee) {}
					long blobStorageCreatedOn = 0;
					try {
						blobStorageCreatedOn = articleDetail.getPrimaryImage().getBlobStorageCreatedOn();
					} catch (Exception ee) {}
					String imageName = website.getImagePath("ImageBasketDefaultArticleThumb.jpg");
					String imageWidth = String.valueOf(website.getBasketThumbSize()) + "px";
					
					if (blobStorageId > 0) {
						imageName = website.getArticleMenu().getCachedImageName(shortDescription, blobStorageId, website.getBasketThumbSize(), blobStorageCreatedOn);
						File cachedImage = new File(website.getWebSitePath()+website.getArticleMenu().getCachedImageName(shortDescription,blobStorageId,website.getBasketThumbSize(),blobStorageCreatedOn));
						if (!cachedImage.exists()) {
							try {
								RenderImageServlet.buildImage(userSession, vendorArticleId, shortDescription, blobStorageId, website.getBasketThumbSize(), true, request, false, false, blobStorageCreatedOn);
							} catch (Exception e) {
								imageName = website.getImagePath("ImageBasketDefaultArticleThumb.jpg");
								imageWidth = String.valueOf(website.getBasketThumbSize()) + "px";
							}
						}
					}%>
					
					<div class="checkoutv2BasketLine">
						<div class="checkoutv2BasketLineTitle">
							<div class="checkoutv2BasketImg"><span><img src="<%=imageName %>" alt="<%=shortDescription %>" title="<%=shortDescription %>" <%=imageWidth.equals(imageWidth) ? "" : "width=\"" + imageWidth + "\""%>/></span></div>
							<div class="checkoutv2BasketTitle"><%=shortDescription %></div>
						</div>
						<%if( quantity == 1 ){%>
							<div class="checkoutv2BasketPrice"><span><%=userSession.formatPrice(itemPrice)%></span></div>
						<%}else{%>
							<div class="checkoutv2BasketPrice"><%=userSession.formatPrice(itemPrice)%> x <%=quantity%> = <span><%=userSession.formatPrice(itemPrice*quantity)%></span></div>
						<%}%>
					</div>
				
				<%}
			}%>
			
		</div>
		
		<div class="checkoutv2BasketDetails">
		
			<div class="checkoutv2BasketDiv">
			
				<% float discountAmount = 0;
				int discountPercentage =  userSession.getShoppingBasket().getDiscountPercentage();
				float voucherRedeemAmount =  userSession.getShoppingBasket().getVouchersRedeemedTotal();
				
				if( voucherRedeemAmount > 0 ){
					voucherRedeemAmount = new BigDecimal(voucherRedeemAmount).setScale(2, BigDecimal.ROUND_HALF_EVEN).multiply(new BigDecimal(userSession.getExchangeRate()).setScale(2, BigDecimal.ROUND_HALF_EVEN)).floatValue(); %>
					Voucher: -<span><%=userSession.formatPrice(voucherRedeemAmount * -1)%></span><br/>
				<%}
				if(discountPercentage > 0){ 
					discountAmount = new BigDecimal(totPrice).setScale(2, BigDecimal.ROUND_HALF_EVEN).multiply(new BigDecimal(discountPercentage).setScale(2, BigDecimal.ROUND_HALF_EVEN).divide(new BigDecimal(100))).floatValue();%>
					Discount: -<span><%=userSession.formatPrice(discountAmount*-1)%></span><br/>
				<%}%>
				
				Sub Total: <span><%=userSession.formatPrice(totPrice)%></span><br/>
				
				<%
				int carriageRegionDomainId2 = userSession.getShoppingBasket().getCarriageRegionId();
				float deliveryCharge = userSession.getShoppingBasket().getDeliveryCharge(totPrice,carriageRegionDomainId2);
				deliveryCharge = new BigDecimal(deliveryCharge*userSession.getExchangeRate()).setScale(2, BigDecimal.ROUND_HALF_EVEN).floatValue();%>
				
				Delivery: <span><%=userSession.formatPrice(deliveryCharge)%></span>
			
			</div>
			
			Basket Total: <span><%=pageModel.getFinalTotalString()%></span>
			
		</div>
		
	</div>
	
</div>

<script type="text/javascript">
	$(document).ready(function(){
		var pageTop = $(".checkoutv2Basket").offset().top - 10;
		var basketWidth = $(".checkoutv2Right").width();
		$(window).scroll(function(){
			var y = $(this).scrollTop();
			var pageHeight = $(window).height();
			var basketHeight = $(".checkoutv2Basket").height();
			if( y >= pageTop && pageHeight > basketHeight ){
				$(".checkoutv2Basket").css({"position":"fixed","marginTop":"-"+pageTop+"px","width":basketWidth+"px"});
			} else {
				$(".checkoutv2Basket").css({"position":"relative","marginTop":"0px"});
			}
		});
	});
	
	function checkoutFormValidate(){
		
		var name = $("#name").val();
		var address1 = $("#address1").val();
		var address2 = $("#address2").val();
		var address3 = $("#address3").val();
		var postcode = $("#postcode").val();
		var county = $("#county").val();
		var country = $("#country").val();
		
		var tel = $("#tel").val();
		var email = $("#email").val();
		
		if( $(".checkboxHold .inputCheck").is(":checked") ){
			$("#delvName").val( name );
			$("#delvAddress1").val( address1 );
			$("#delvAddress2").val( address2 );
			$("#delvAddress3").val( address3 );
			$("#delvPostcode").val( postcode );
			$("#delvCounty").val( county );
			$("#delvCountry").val( country );
		}
		
		var delvName = $("#delvName").val();
		var delvAddress1 = $("#delvAddress1").val();
		var delvAddress2 = $("#delvAddress2").val();
		var delvAddress3 = $("#delvAddress3").val();
		var delvPostcode = $("#delvPostcode").val();
		var delvCounty = $("#delvCounty").val();
		var delvCountry = $("#delvCountry").val();
		
		$("#address").val( address1+", "+address2+", "+address3 );
		$("#delvAddress").val( delvAddress1+", "+delvAddress2+", "+delvAddress3 );
		
		var valid = "";
		
		var nameRegex = new RegExp(/\w+ \w+/);
		var addressRegex = new RegExp(/\w+/);
		var postcodeRegex = new RegExp(/^[0-9a-zA-Z ]{7,}$/);
		var telRegex = new RegExp(/^[0-9]*[0-9]$/);
		var emailRegex = new RegExp(/^[^@]+@[^@\.]+\.{1}[^@]+$/);
		
		
		if( name == null || name == "" || !nameRegex.test(name) ){
			valid += "full name,";
			$("#name").addClass("error");
		} else {
			$("#name").removeClass("error");
		}
		if( address1 == null || address1 == "" || !addressRegex.test(address1) ){
			valid += "address,";
			$("#address1").addClass("error");
		} else {
			$("#address1").removeClass("error");
		}
		if( postcode == null || postcode == "" || !postcodeRegex.test(postcode) ){
			valid += "postcode,";
			$("#postcode").addClass("error");
		} else {
			$("#postcode").removeClass("error");
		}
		
		<%if( website.isTelephoneMandatoryWithinAddress() ){%>
			if( tel == null || tel == "" || !telRegex.test(tel) ){
				valid += "telephone number,";
				$("#tel").addClass("error");
			} else {
				$("#tel").removeClass("error");
			}
		<%}%>
		<%if( website.isEmailMandatoryWithinAddress() ){%>
			if( email == null || email == "" || !emailRegex.test(email) ){
				valid += "email address,";
				$("#email").addClass("error");
			} else {
				$("#email").removeClass("error");
			}
		<%}%>
		
		if( ( delvName == null || delvName == "" || !nameRegex.test(delvName) ) && !$(".checkboxHold .inputCheck").is(":checked") ){
			valid += "full name for delivery,<br/>";
			$("#delvName").addClass("error");
		} else {
			$("#delvName").removeClass("error");
		}
		if( ( delvAddress1 == null || delvAddress1 == "" || !addressRegex.test(delvAddress1) ) && !$(".checkboxHold .inputCheck").is(":checked") ){
			valid += "address for delivery,";
			$("#delvAddress1").addClass("error");
		} else {
			$("#delvAddress1").removeClass("error");
		}
		if( ( delvPostcode == null || delvPostcode == "" || !postcodeRegex.test(delvPostcode) ) && !$(".checkboxHold .inputCheck").is(":checked") ){
			valid += "postcode for delivery,";
			$("#delvPostcode").addClass("error");
		} else {
			$("#delvPostcode").removeClass("error");
		}
		
		if( valid == "" ){
			return true;
		} else {
			valid = valid.split(",");
			validStr = "";
			for( i=0 ; valid.length > i ; i++ ){
				if( validStr != "" ){
					validStr += ", " + valid[i];
				} else {
					validStr += valid[i];
				}
			}
			validStr = "Please enter your " + validStr.substring( 0, validStr.lastIndexOf(",") ) + ".";
			$(".checkoutv2ValidationMsg").html(validStr);
			return false;
		}
		
	}
</script>