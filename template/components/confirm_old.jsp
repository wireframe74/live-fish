<!-- start of components/confirm.jsp -->
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
	
	if (request.getParameter("cartId") != null) {
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
   <table width="97%" align="center" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<%=pageView.getTrailHTML("Confirmation", request)%>
		</td>
	</tr>
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>
						<div style="padding-top:25px;padding-bottom:25px;">
							<center><img src="<%=website.getImagePath("checkoutprocess4.gif")%>" alt="Confirm Order" /></center>         
						</div>
					</td>
				</tr>	

				<tr>
					<td>
						<br>
						<table align="left" border="0" cellspacing=0 cellpadding=0>
							<tr valign="middle">
								<td valign="middle">
									<a href=<%="'delivery.jsp'"%> >
										&nbsp;&nbsp;<img src="<%=website.getImagePath("back-to-shop.gif")%>" alt="Back" style="margin-top:16px;"  />
										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									</a>
									<br>
								</td>
							</tr>
						</table>
<% 
	if (userSession.getCurrentPaymentProvider() == null || (website.getPaymentProviders().size() > 0 && website.getPaymentProviders().get(0).getPaymentProviderKey().equalsIgnoreCase("order"))) {
%>
	       		
						<table align="right" cellspacing="0" cellpadding="0">
							<tr>
								<td valign="middle">
									<a href="javascript: document.payform.submit();">
										<img src="<%=website.getImagePath("place-order.gif")%>" alt="Place Order" class="placeorderbutton" />
									</a>
								</td>
							</tr>
						</table>
<%
	} else if (website.getPaymentProviders() != null && website.getPaymentProviders().size() == 1) { 
%>
						<table align="right" cellspacing="0" cellpadding="0">
							<tr>
<% 
		if (website.isAllowChequePayment()) {
%>
								<td valign="middle">
									<a href="host.jsp?pg=chequepayment.jsp" class="button">
										&nbsp;&nbsp;&nbsp;Pay by cheque&nbsp;&nbsp;&nbsp;&nbsp;
									</a>
								</td>
<%
		}
%>
								<td valign="middle">
									<a href="javascript: document.payform.submit();" >
										&nbsp;&nbsp;
										<img src="<%=website.getImagePath("go-checkout.gif")%>" alt="Next" />&nbsp;
									</a>
								</td>
							</tr>
						</table>


<% 
	} else {  // Multiple payment providers
%>
				<table align="center" cellspacing="0" cellpadding="0">
					<tr>
<% 
		if (website.isAllowChequePayment()) {
%>
						<td valign="middle">
							<a href="host.jsp?pg=chequepayment.jsp" class="button">&nbsp;&nbsp;&nbsp;Pay by cheque&nbsp;&nbsp;&nbsp;&nbsp;</a>
						</td>
<% 
		} 
%>
						
		<% if (website.getPaymentProviders() != null && website.getPaymentProviders().size() > 0) {  %>
						<td valign="middle">
							<table cellspacing="4" cellpadding="0" border="0">
								<tr>
									<%=pageView.getPaymentProviderImagesHTML()%>
								</tr>
							</table>
						</td>
		<% } %>
					</tr>
				</table>


<%
	} 
%>
					</td>
				</tr>
			
				<tr><td><br /></td></tr>    
				<tr>
					<td>
						<div id="checkoutconfirm" class="checkoutcontainer">
							<table cellspacing="0" cellpadding="0" border="0" width="99%">
								<tr>
									<td>
										<table class="form" width="100%" border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td>
													<table width="100%" cellspacing="0" cellpadding="0" border="0"> 
														<tr>
															<td>
																<div class="pagetitle">
																	<img src="<%=website.getImagePath("containerheader.gif")%>" alt="" class="containerHeader" />Confirm Order Details
																</div>
															</td>
														</tr>														
														<tr>
															<td>
																<table class="smallertext" width="100%" cellspacing="0" cellpadding="0" border="0">
																	<tr>
																		<td class="trail">
																			Purchase Summary
																		</td>
																	</tr>
																	<tr><td><img src="template/images/spacer.gif" height="2" width="1"></td></tr>
																	<tr>
																		<td>
																			<table width="100%" cellspacing="0" cellpadding="0" border="0">
																				<tr>
																					<td width="40" class="smallertext" align="center">
																						<img src="<%=website.getImagePath("purchase.gif")%>" alt="" />
																					</td>

																					<td align="left" class="smallertext" >
<% 	if (userSession.getWebsiteAccessDomainId() > Customer.WEB_ACCESS_TYPE_NO_PRICES) { %>
																						<a href="basket.jsp">
																							<%=userSession.getShoppingBasket().getTotalQuantityString()%>&nbsp;item<%=userSession.getShoppingBasket().getTotalQuantity()==1?"":"s"%> ordered at a total order price of <%=pageModel.getFinalTotalString()%> <%=(website.isShowDelivery() ? "including delivery " : "")%><%=(website.getWebsiteMode() == WebSite.MODE_TRADE?" and VAT":"")%>
																						</a>
<%	} else { %>
																						<a href="basket.jsp">
																							<%=userSession.getShoppingBasket().getTotalQuantityString()%>&nbsp;item<%=userSession.getShoppingBasket().getTotalQuantity()==1?"":"s"%> ordered
																						</a>
<% 	} %>
																					</td>
																				</tr>
																			</table>
																		</td>
																	</tr>
																	<tr>
																		<td class="trail">
																			<br />Invoice Address
																		</td>
																	</tr>
																	<tr><td><img src="template/images/spacer.gif" height="2" width="1"></td></tr>																	
																	<tr>
																		<td>
																			<table width="100%" cellspacing="0" cellpadding="0" border="0">
																				<tr>
																					<td width="40" class="smallertext" align="center">
																						<img src="<%=website.getImagePath("user.gif")%>" alt="" />
																					</td>
																					<td align="left" class="smallertext" >
																						<a href='changeaddr.jsp?addressid=<%=billingAddressRow.get(addressPrefix+Address.ADDRESS_ID)%>'>
																							<%=billingAddressRow.get(addressPrefix+Address.CONTACT)%>&nbsp;-&nbsp;<%=Address.combineAddressLines(""+billingAddressRow.get(addressPrefix+Address.ADDRESS_LINE1), ""+billingAddressRow.get(addressPrefix+Address.ADDRESS_LINE2), ""+billingAddressRow.get(addressPrefix+Address.ADDRESS_LINE3), ""+billingAddressRow.get(addressPrefix+Address.COUNTY), ""+billingAddressRow.get(addressPrefix+Address.COUNTRY), ""+billingAddressRow.get(addressPrefix+Address.POST_CODE))%>
																						</a>
																					</td>
																				</tr>
																			</table>
																		</td>
																	</tr>
																	<tr>
																		<td class="trail">
																			<br />Delivery Address
																		</td>
																	</tr>
																	<tr><td><img src="template/images/spacer.gif" height="2" width="1"></td></tr>
																	<tr>
																		<td>
																			<table width="100%" cellspacing="0" cellpadding="0" border="0">
																				<tr>
																					<td width=40 class="smallertext" align="center">
																						<img src="<%=website.getImagePath("user.gif")%>" alt="" />
																					</td>
																					<td align=left class="smallertext">
																						<a href='changeaddr.jsp?addressid=<%=deliveryAddressRow.get(addressPrefix+Address.ADDRESS_ID)%>'>
																							<%=deliveryAddressRow.get(addressPrefix+Address.CONTACT)%>&nbsp;-&nbsp;<%=Address.combineAddressLines(""+deliveryAddressRow.get(addressPrefix+Address.ADDRESS_LINE1), ""+deliveryAddressRow.get(addressPrefix+Address.ADDRESS_LINE2), ""+deliveryAddressRow.get(addressPrefix+Address.ADDRESS_LINE3), ""+deliveryAddressRow.get(addressPrefix+Address.COUNTY), ""+deliveryAddressRow.get(addressPrefix+Address.COUNTRY), ""+deliveryAddressRow.get(addressPrefix+Address.POST_CODE))%>
																						</a>
																					</td>
																				</tr>
																			</table>
																		</td>
																	</tr>
																	<tr><td><img src="template/images/spacer.gif" height="8" width="1"></td></tr>																	
																</table>
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
				<tr><td></td></tr>
				<tr>
					<td>
						<table align=left border=0 cellspacing=0 cellpadding=0>
							<tr>
								<td>
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
<% 
		if (!new BigDecimal(userSession.getExchangeRate()).setScale(2,BigDecimal.ROUND_HALF_EVEN).equals(new BigDecimal(1.00))) {  
%>
										<input type=hidden name="exchangeRate" value='<%=userSession.getExchangeRate()%>'>
<%
		} 
%>

								</td>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr><td><img src="<%=website.getImagePath("spacer.gif")%>" alt="" class="height15 width1" /></td></tr>
		<tr>
			<td>
					<div id="checkoutconfirmnotes" class="checkoutcontainer">
						<table border="0" cellspacing="0" cellpadding="0" width="100%">
							<tr>
								<td>
									<table width="100%" cellpadding="0" cellspacing="0" border="0">
<% 
	if (!pageModel.isNoteAdded()) { 
%>
										<tr valign="top">
											<td width="100%">
<%
		File preInstructions = new File(website.getWebSitePath()+"preInstructions.html");
		if (preInstructions != null && preInstructions.exists()) {
%>
			<jsp:include page="../../preInstructions.html"/>
<%
		} else {
%>
													If there is anything else you need to tell us, then simply type it into the box below: 
<% 	
		}
%>
											</td>
										</tr>
										<tr>
											<td colspan="2">
												<br />
												<center>
											  		<table cellspacing="0" cellpadding="0" border="0">
											  			<tr>
											  				<td>
																<textarea name="notes" rows="5" cols="61" class="textareaitem" ><%=pageModel.getNotes()%></textarea>
											  				</td>
											  			</tr>
											  			
											  			<tr>
											  				<td>
																<table align="right" border="0">
																	<tr>
																		<td valign="middle">
																			<input type="hidden" name="finalTotalString" value="<%=pageModel.getFinalTotalString()%>" />
																		</td>
																	</tr>
										     	     			</table>
											  				</td>
											  			</tr>
											  		</table>
												</center>
												<br />
											</td>
										</tr>
										<tr>
											<td>&nbsp;</td>
										</tr>
										<tr>
											<td width="100%">
<%
							
		File postInstructions = new File(website.getWebSitePath()+"postInstructions.html");
		if (postInstructions != null && postInstructions.exists()) {
%>
			<jsp:include page="../../postInstructions.html"/>
<%
		}
%>
											</td>
										</tr>
<% 
	} else {
%>
										<tr>
											<td colspan="2">
												<br />	
												<center>
													<table cellspacing="0" cellpadding="0" border="0">
														<tr>
															<td>
			     												<table width="400" height="50" align="center">
			     													<tr valign="top">
			     														<td class="smallertext">
																			<div class="checkoutcontainer">
																				<table bgcolor="white" width="99%" height="98%" align="center">
																					<tr valign="top">
																						<td class="smallertext">
																							<%=pageModel.getNotes()%>
																						</td>
																					</tr>
																				</table>
																			</div>
																		</td>
																	</tr>
																</table>	
															</td>
														</tr>
														<tr>
															<td>
																<table align="right" cellspacing="0" cellpadding="0" border="0">
																	<tr>
																		<td valign="middle" class="discount">Updated&nbsp;</td>
																	</tr>
																</table>
															</td>
														</tr>
													</table>
												</center>
												<br />
											</td>
										</tr>
<% 
	} 
%>
									</table>
								</td>
							</tr>
						</table>
					</div>
			</td>
		</tr>

		<tr>
		  <td>
		    <table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>
						<br>
						<table align="left" border="0" cellspacing=0 cellpadding=0>
							<tr valign="middle">
								<td valign="middle">
									<a href=<%="'delivery.jsp'"%> >
										&nbsp;&nbsp;<img src="<%=website.getImagePath("back-to-shop.gif")%>" alt="Back"  />
										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									</a>
									<br>
								</td>
							</tr>
						</table>
<% 
	if (userSession.getCurrentPaymentProvider() == null || (website.getPaymentProviders().size() > 0 && website.getPaymentProviders().get(0).getPaymentProviderKey().equalsIgnoreCase("order"))) {
%>
	       		
						<table align="right" cellspacing="0" cellpadding="0">
							<tr>
								<td valign="middle">
									<a href="javascript: document.payform.submit();">
										<img src="<%=website.getImagePath("place-order.gif")%>" alt="Place Order" class="placeorderbutton" />
									</a>
								</td>
							</tr>
						</table>
<%
	} else if (website.getPaymentProviders() != null && website.getPaymentProviders().size() == 1) { 
%>
						<table align="right" cellspacing="0" cellpadding="0">
							<tr>
<% 
		if (website.isAllowChequePayment()) {
%>
								<td valign="middle">
									<a href="host.jsp?pg=chequepayment.jsp" class="button">
										&nbsp;&nbsp;&nbsp;Pay by cheque&nbsp;&nbsp;&nbsp;&nbsp;
									</a>
								</td>
<%
		}
%>



								<td valign="middle">
									<a href="javascript: document.payform.submit();" >
										&nbsp;&nbsp;
										<img src="<%=website.getImagePath("go-checkout.gif")%>" alt="Next" />&nbsp;
									</a>
								</td>
							</tr>
						</table>


<% 
	} else {  // Multiple payment providers
%>
				<table align="center" cellspacing="0" cellpadding="0">
					<tr>
<% 
		if (website.isAllowChequePayment()) {
%>
						<td valign="middle">
							<a href="host.jsp?pg=chequepayment.jsp" class="button">&nbsp;&nbsp;&nbsp;Pay by cheque&nbsp;&nbsp;&nbsp;&nbsp;</a>
						</td>
<% 
		} 
%>
						
		<% if (website.getPaymentProviders() != null && website.getPaymentProviders().size() > 0) {  %>
						<td valign="middle">
							<table cellspacing="4" cellpadding="0" border="0">
								<tr>
									<%=pageView.getPaymentProviderImagesHTML()%>
								</tr>
							</table>
						</td>
		<% } %>
					</tr>
				</table>

			 
			 	

<%
	}
%>
					</td>
				</tr>




		    </table>
		  </td>
		</tr>
		<tr><td><br /><br /></td></tr>
	</table>
</form>
<!-- end of components/confirm.jsp -->