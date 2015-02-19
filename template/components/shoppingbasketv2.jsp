<jsp:useBean id="website"  scope="application" class="co.simplypos.model.website.WebSite" />
<jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession" />

<%@page import="co.simplypos.persistence.Customer" %>
<%@page import="co.simplypos.persistence.Domain" %>
<%@page import="co.simplypos.persistence.VendorArticle" %>
<%@page import="co.simplypos.persistence.TransactionLine" %>
<%@page import="co.simplypos.persistence.Transaction" %>
<%@page import="co.simplypos.model.website.ArticleDetail" %>
<%@page import="co.simplypos.model.website.ArticleMenu" %>
<%@page import="co.simplypos.model.website.RenderImageServlet" %>
<%@page import="co.simplypos.model.website.ShoppingBasket" %>
<%@page import="co.simplypos.model.website.UserSession" %>
<%@page import="co.simplypos.model.website.WebSite" %>
<%@page import="co.simplypos.model.utils.helpers.StringHelper" %>
<%@page import="javax.swing.table.DefaultTableModel" %>
<%@page import="co.simplypos.model.website.WebDiscountManager" %>
<%@page import="co.simplypos.model.TransactionManager" %>
<%@page import="java.math.BigDecimal" %>
<%@page import="java.util.Hashtable" %>
<%@page import="java.util.ArrayList" %>
<%@page import="java.sql.Connection" %>
<%@page import="java.io.File" %>
<%@page import="java.util.Vector" %>
<%@page import="co.simplypos.model.website.page.view.StockDetailPageView" %>


<%boolean debug = false;
int paramPid = userSession.getWebController().getPid();
int paramId = userSession.getWebController().getId();
String action = request.getParameter("action");
String psTransactionId = (String) session.getAttribute("psTransactionId");
if (action == null) {
	action = "";
}

String lastIndexPage = userSession.getWebSite().getArticleMenu().getPageForVendorArticle(userSession.getNavigationRefinementSettings().getLastCatVaId());
if (lastIndexPage == null) lastIndexPage = "index.jsp";

userSession.getShoppingBasket().recalcDiscountPercentage();

String shoppingBasketShortName = "Basket";
String shoppingBasketName = "Shopping Basket";
if (userSession.getShoppingBasket().getTransactionSubType() == Transaction.SUB_TYPE_TRANSACTION_PERSONAL_SHOPPING) {
	shoppingBasketName = "Personal Shopper List";
}
ArticleDetail articleDetail = userSession.getArticleDetail();%>

<script type='text/javascript'>
	function validateQtyV2(qty, sqty, formId){
		qty = parseInt(qty);
		sqty = parseInt(sqty);
		if( qty > sqty ){
			$("#qty"+formId).css({"backgroundColor":"#a00","color":"#fff"});
			qtyErr = true;
		}
		else{
			$("#qty"+formId).removeAttr("style");
			qtyErr = false;
		}
	}
	function shakeQty(formId){
		$("#qty"+formId).animate({"left":"5px"},40);
		$("#qty"+formId).animate({"left":"0px"},40);
		$("#qty"+formId).animate({"left":"5px"},40);
		$("#qty"+formId).animate({"left":"0px"},40);
		$("#qty"+formId).animate({"left":"5px"},40);
		$("#qty"+formId).animate({"left":"0px"},40);
	}
	var qtyErr = false;
	var doneErr = false;
</script>



<%boolean bContinue2 = true;
if (website.getDefaultWebsiteAccessDomainId() < Customer.WEB_ACCESS_TYPE_FULL) {
	if (!userSession.isLoggedIn() || userSession.getWebsiteAccessDomainId() < Customer.WEB_ACCESS_TYPE_FULL) {
		bContinue2 = false;	
		if (userSession.isLoggedIn()) {
			userSession.refreshCurrentLogin(); // try a refresh
			if (userSession.getWebsiteAccessDomainId() < Customer.WEB_ACCESS_TYPE_FULL) {%>
				Your registration is pending, please try again later

			<%} else {
				bContinue2 = true;
			}
		} else {%>
			<%=website.getBasketLoginMsg()%>
		<%}
	}
}

if (bContinue2) {
	String promoCode = "";
	String promoMsg = "";
	String voucherCode1 = "";
	String voucherCode2 = "";
	String voucherMsg = "";

	Connection conn = null;
	
	try {
		conn = website.getConnection();
		
		if (request.getParameter("promoCode") != null && !request.getParameter("promoCode").trim().equals("")) {
			promoCode = request.getParameter("promoCode").toUpperCase();
			promoMsg = userSession.getShoppingBasket().applyPromotionCode(conn, promoCode);
			if (promoMsg.indexOf("applied") > -1) promoCode = "";  
		}
		if (request.getParameter("voucherCode1") != null && !request.getParameter("voucherCode1").trim().equals("")) {
			voucherCode1 = request.getParameter("voucherCode1").toUpperCase();
			voucherCode2 = request.getParameter("voucherCode2").toUpperCase();
			voucherMsg = userSession.getShoppingBasket().applyVoucherCode(conn , voucherCode2, voucherCode1);
			if (voucherCode1.indexOf("applied") > -1) {
				voucherCode1 = "";
				voucherCode2 = "";
			}
		}
	} catch (Exception eee5) {
		conn.rollback();
	} finally {
		website.releaseConnection(conn);			
	}
	
	int paramParentVendorArticleId = paramPid;
	int paramVendorArticleId = paramId;
	int paramQuantity = 0;
	int additionalQty = 0;
	int paramTransLineId = 0;
	int paramBasketIndex = -1;
	String paramCarriageRegion = null;

	if (request.getParameter("tlid") != null) {
		paramTransLineId = Integer.parseInt(request.getParameter("tlid"));
	}
	if (request.getParameter("index") != null) {
		paramBasketIndex = Integer.parseInt(request.getParameter("index"));
	}
	if (request.getParameter("pid") != null) {
		paramParentVendorArticleId = Integer.parseInt(request.getParameter("pid"));
	}
	if (request.getParameter("id") != null) {
		paramVendorArticleId = Integer.parseInt(request.getParameter("id"));
	}
	if (request.getParameter("del") != null) {
		if (paramBasketIndex > -1) userSession.getShoppingBasket().removeItem(paramBasketIndex, paramVendorArticleId);
	}
	if (request.getParameter("carriageregion") != null) {
		int carriageRegionDomainId = Integer.parseInt(""+request.getParameter("carriageregion"));
		paramCarriageRegion = ""+carriageRegionDomainId;
		if (userSession.getShoppingBasket().getCarriageRegionId() != carriageRegionDomainId) {
			userSession.getShoppingBasket().setCarriageRegionId(carriageRegionDomainId);
			userSession.getShoppingBasket().saveBasket();		
		}
	}

	if (request.getParameter("qty") != null) {
		if (StringHelper.isNumber(request.getParameter("qty"))) {
			paramQuantity = Integer.parseInt(request.getParameter("qty"));

			int lineItemAibQty = userSession.getShoppingBasket().getQuantityInBasket(paramTransLineId);
			additionalQty = paramQuantity - lineItemAibQty;
		}
	}
		
	if (additionalQty != 0) {
		try {
			userSession.getShoppingBasket().incrementTransLineQty(paramTransLineId, additionalQty);
		} catch(ShoppingBasket.BasketItemSoldOutException bsoe){ %>
			<script type="text/javascript">
				doneErr = true;
				alert("<%=bsoe.getMessage()%>");
			</script>
		<%} catch (ShoppingBasket.BasketItemNotEnoughItemsInStockException bnee) {%>
			<script type="text/javascript">
				alert("<%=bnee.getMessage()%>");
			</script>
		
		<%}
	}
	try {
		userSession.getShoppingBasket().verifyBasket();
	} catch(ShoppingBasket.BasketItemSoldOutException bsoe){ %>
		<script language="Javascript">if(!doneErr){alert("<%=bsoe.getMessage()%>");}</script>
	<% } %>



	<div class="pagetitle">
		<h1><%=website.getText("basketheaderone","Your Shopping Basket")%></h1>
	</div>

	<div id="basketcontenttable" class="listtable basketV2">
	
		<ul id="basketheader" class="listtableheader">
			<li class="basketitem"><%=website.getText("basketheaditem","Item")%></li>
			<% if (userSession.getWebsiteAccessDomainId() > Customer.WEB_ACCESS_TYPE_NO_PRICES) { %><li class="basketprice"><%=website.getText("basketheadprice","Price")%></li><%}%>
			<li class="basketquantity"><%=website.getText("basketheadquantity","Quantity")%></li>
			<li class="basketremove"><%=website.getText("basketheadremove","Remove/Update")%></li>
			<%if (userSession.getWebsiteAccessDomainId() > Customer.WEB_ACCESS_TYPE_NO_PRICES) { %><li class="baskettotprice"><%=website.getText("basketheadtotalprice","Total Price")%></li><%}%>
		</ul>
	
	
		<% DefaultTableModel consoleTableModel = userSession.getShoppingBasket().getConsoleTableModel();
		WebDiscountManager discountManager = (WebDiscountManager)userSession.getShoppingBasket().getDiscountManager();

		ArrayList additionalDeliveryOptions = userSession.getShoppingBasket().getAdditionalDeliveryOptions();
		ArrayList<Integer> additionalDeliveryOptionsVaIds = new ArrayList<Integer>();
		for (int i=0;i<additionalDeliveryOptions.size();i++) {
			if (additionalDeliveryOptions.get(0) != null) additionalDeliveryOptionsVaIds.add((Integer)(((ArrayList)additionalDeliveryOptions.get(i)).get(0)));
 		}
		
		float additionalDeliveryOptionsTotal = 0;
		float totPrice = 0;
		boolean oddline = false;
		
		for (int i=0;i<consoleTableModel.getRowCount();i++) {
			try {
				if (!discountManager.isDiscountRow(i)) {
				
					int transLineId = userSession.getShoppingBasket().getIntValueAt(i, TransactionManager.COLUMN_TRANSACTION_LINE_ID);
					int vendorArticleId = userSession.getShoppingBasket().getIntValueAt(i, TransactionManager.COLUMN_VENDOR_ARTICLE_ID);
					int vendorArticleClsfnId = userSession.getShoppingBasket().getIntValueAt(i, TransactionManager.COLUMN_VENDOR_ARTICLE_CLSFN_ID);
					int quantity = userSession.getShoppingBasket().getIntValueAt(i, TransactionManager.COLUMN_ITEMS);
					float itemPrice = userSession.getShoppingBasket().getFloatValueAt(i, TransactionManager.COLUMN_UNIT_PRICE);
					float qtyPrice = userSession.getShoppingBasket().getFloatValueAt(i, TransactionManager.COLUMN_QTY_PRICE);
					float salePrice = discountManager.getQtyPriceIncludingDiscountsSoFar(i, userSession.getExchangeRate());
					String discountsApplied = ""+discountManager.getDiscountDesctiptions(i);
					if (discountsApplied.length() > 2) {
						discountsApplied = "Special Offer: "+discountsApplied.substring(1,discountsApplied.length()-1);
					} else {
						discountsApplied = "";
					}
					int wrappingTypeDomainId = userSession.getShoppingBasket().getIntValueAt(i, TransactionManager.COLUMN_WRAPPING_TYPE_DOMAIN_ID);
					float wrappingPrice = userSession.getShoppingBasket().getFloatValueAt(i, TransactionManager.COLUMN_WRAPPING_PRICE);
					int messageTypeDomainId = userSession.getShoppingBasket().getIntValueAt(i, TransactionManager.COLUMN_MESSAGE_TYPE_DOMAIN_ID);
					String message = userSession.getShoppingBasket().getStringValueAt(i, TransactionManager.COLUMN_MESSAGE_TEXT);
					float messagePrice = userSession.getShoppingBasket().getFloatValueAt(i, TransactionManager.COLUMN_MESSAGE_PRICE);
					wrappingPrice = new BigDecimal(wrappingPrice*userSession.getExchangeRate()).setScale(2, BigDecimal.ROUND_HALF_EVEN).floatValue();
					messagePrice = new BigDecimal(messagePrice*userSession.getExchangeRate()).setScale(2, BigDecimal.ROUND_HALF_EVEN).floatValue();
					float linePrice = salePrice + (quantity * wrappingPrice) + (quantity * messagePrice);
					totPrice += linePrice;
					String wrapTypeDesc = "";
					String messageTypeDesc = "";
					Hashtable domainRow = null;
					boolean isLineNote = false;

					if (wrappingTypeDomainId > 0) {
						domainRow = articleDetail.getDomainRow(wrappingTypeDomainId);
						String wrapPriceNarr = userSession.getDomainPriceNarrative(wrappingPrice);
						wrapTypeDesc = domainRow.get(Domain.DOMAIN_DESCRIPTION) + wrapPriceNarr;
					}
					if (messageTypeDomainId > 0) {
						domainRow = articleDetail.getDomainRow(messageTypeDomainId);
						String messagePriceNarr = userSession.getDomainPriceNarrative(messagePrice); 
						messageTypeDesc = domainRow.get(Domain.DOMAIN_DESCRIPTION) + messagePriceNarr +":\n"+StringHelper.replace(message, "\"", "`");
					}
					if (messageTypeDomainId > 0 && messageTypeDomainId == TransactionLine.MESSAGE_TYPE_LINE_NOTE) {
						messageTypeDesc = StringHelper.replace(StringHelper.replace(StringHelper.replace(co.simplypos.model.utils.helpers.HTMLHelper.applyHTML(StringHelper.replace(message, "\"", "`")),"<br />","\n"),"COUNT_",""),"_"," ");
						isLineNote = true;
					}

					Hashtable row = articleDetail.getRow(vendorArticleClsfnId);
					String shortDescription = (String)row.get(ArticleDetail.SHORT_DESCRIPTION);
					String fullDescription = (String)row.get(ArticleDetail.FULL_DESCRIPTION);
					int blobStorageId = 0;
					try {
						//blobStorageId = ((Integer)row.get(ArticleDetail.BLOB_STORAGE_ID)).intValue();
						blobStorageId = articleDetail.getPrimaryImage().getBlobStorageId();
					} catch (Exception ee) {}
					long blobStorageCreatedOn = 0;
					try {
						//blobStorageCreatedOn = ((Long)row.get(ArticleDetail.BLOB_STORAGE_CREATED_ON)).longValue();
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
					}

					if (additionalDeliveryOptionsVaIds.contains(vendorArticleId)) {
						additionalDeliveryOptionsTotal += salePrice;
					}
					
					int parentVendorArticleId = 0;
					
					try {
						parentVendorArticleId = Integer.parseInt(""+row.get(ArticleDetail.PARENT_VENDOR_ARTICLE_ID));
					} catch (NumberFormatException nfe) {
						// null entry - clean it up
						website.writeToLog("null entry couldn't find parentVendorArticleId: " + vendorArticleId);
						userSession.getShoppingBasket().removeItem(i, vendorArticleId);
						%>
						<script type="text/javascript">
							history.go(0);
						</script>
					<% } %>
					
						
					<ul class="basketline listtableline <%=oddline?"oddline":""%>">
					
						<form method="post" name="qtyform<%=i%>"  action='basket.jsp'>
					
							<li class="basketitemimg">
								<ul class="basketitemul">
								
									<% if (website.isShowBasketThumbnail()) { %>
										<li class="basketimage">
											<a class="smallertext"  href='<%=ArticleMenu.getPageName(website, shortDescription, true)%>?pid=<%=parentVendorArticleId%>&amp;id=<%=vendorArticleId%>&amp;tlid=<%=transLineId%>'>
												<img src="<%=imageName %>" alt="<%=shortDescription %>" title="<%=shortDescription %>" <%=imageWidth.equals(imageWidth) ? "" : "width=\"" + imageWidth + "\""%>/>
												
												<% if (wrappingTypeDomainId > 0 && wrappingTypeDomainId != TransactionLine.WRAPPING_TYPE_NO_WRAPPING) {%>
												
													<img src="<%=website.getImagePath("basket-gift.png")%>" alt="<%=wrapTypeDesc%>" class="giftwrapImg" />
													
												<% } else if(messageTypeDomainId > 0 && messageTypeDomainId != TransactionLine.MESSAGE_TYPE_NO_MESSAGE){ %>
													
													<img src="<%=website.getImagePath("basket-writing.png")%>" alt="<%=isLineNote?messageTypeDesc:messageTypeDesc%>" class="giftwrapImg" />
													
												<% } %>
												
											</a>
										</li>
									<% } %>
									
									
									<%if(false){%>
										<li class="basketExtras">
										
											<% if (wrappingTypeDomainId > 0 && wrappingTypeDomainId != TransactionLine.WRAPPING_TYPE_NO_WRAPPING) {%>
											
												<a href='<%=ArticleMenu.getPageName(website, shortDescription, true)%>?pid=<%=parentVendorArticleId%>&amp;id=<%=vendorArticleId%>&amp;tlid=<%=transLineId%>#giftwrapoptions' title='<%=wrapTypeDesc%>'>
													<img src="<%=website.getImagePath("basket-gift.png")%>" alt="<%=wrapTypeDesc%>" class="giftwrapImg" />
												</a>
												
											<% } else { %>
											
												<% if (messageTypeDomainId > 0 && messageTypeDomainId != TransactionLine.MESSAGE_TYPE_NO_MESSAGE) { %>
												
													<a href='<%=ArticleMenu.getPageName(website, shortDescription, true)%>?pid=<%=parentVendorArticleId%>&amp;id=<%=vendorArticleId%>&amp;tlid=<%=transLineId%><%=isLineNote?"#personalisationoptions":"#giftwrapoptions"%>' title='<%=messageTypeDesc%>'>
														<img src="<%=website.getImagePath("basket-writing.png")%>" alt="<%=isLineNote?messageTypeDesc:messageTypeDesc%>" class="giftwrapImg" />
													</a>
													
												<% } else if(website.isOfferGiftWrappingService() && (wrappingTypeDomainId == 0 || wrappingTypeDomainId == TransactionLine.WRAPPING_TYPE_NO_WRAPPING)) { %>
													
													<a href='<%=ArticleMenu.getPageName(website, shortDescription, true)%>?pid=<%=parentVendorArticleId%>&amp;id=<%=vendorArticleId%>&amp;tlid=<%=transLineId%>&amp;gwon=1#giftwrapoptions' title='<%=wrapTypeDesc%>'>
														<img src="<%=website.getImagePath("basket-giftadd.png")%>" alt="Add Giftwrap" class="giftwrapImg" />
													</a>
													
												<% } %>
												
											<% } %>
											
										</li>
									<%}%>
									
								</ul>
							</li>
							
							
							<li class="basketdescription">
								<a class="smallertext"  href='<%=ArticleMenu.getPageName(website, shortDescription, true)%>?pid=<%=parentVendorArticleId%>&amp;id=<%=vendorArticleId%>&amp;tlid=<%=transLineId%>'>
									<%=shortDescription%>
								</a>
								<% if (!discountsApplied.equals("")) {%>
									
									<a class="basketlinediscount" href='<%=ArticleMenu.getPageName(website, shortDescription, true)%>?pid=<%=parentVendorArticleId%>&amp;id=<%=vendorArticleId%>&amp;tlid=<%=transLineId%>'>
										<%=discountsApplied%>
									</a>
									
								<% } %>
							</li>
							
							
							<% if (debug) { %><%="vendorArticleClsfnId: "+vendorArticleClsfnId+",  parentVendorArticleId: "+parentVendorArticleId+", vendorArticleId: "+vendorArticleId%><% } %>
							
							
							<%if (userSession.getWebsiteAccessDomainId() > Customer.WEB_ACCESS_TYPE_NO_PRICES) { %>
							<li class="basketprice">
								<%=userSession.convertAndFormatPrice(itemPrice)%>
							</li>
							<% } %>

							
							<li class="basketquantity">
								
								<input type="text" class="inputitem" name="qty" id="qty<%=i%>" value='<%=ArticleDetail.formatQuantity(quantity,false)%>' size="1" onChange="validateQtyV2(this.value, <%=userSession.getArticleDetail().getQuantity(parentVendorArticleId, vendorArticleId)%>, <%=i%>)"/>
								
								<input type="hidden" name='pid' value='<%=parentVendorArticleId%>' />
								<input type="hidden" name='id' value='<%=vendorArticleId%>' />
								<input type="hidden" name='tlid' value='<%=transLineId%>' />
								<input type="hidden" name='origqty' value='<%=quantity%>' />
								<input type="hidden" name='sqty' id="sqty<%=i%>" value='<%=userSession.getArticleDetail().getQuantity(parentVendorArticleId, vendorArticleId)%>' />
								<input type="hidden" name='aibqty' value='<%=userSession.getShoppingBasket().getQuantityInBasket(parentVendorArticleId, vendorArticleId)%>' />
								<input type="hidden" name=<%="'"+UserSession.URL_PARAM_NO_TRAIL_PHRASE+"'"%> value='1' />
								
							</li>
						
						
							<li class="basketremove">
							
								<a href='basket.jsp?del=1&amp;index=<%=i%>&amp;id=<%=vendorArticleId%>&amp;<%=UserSession.URL_PARAM_NO_TRAIL_PHRASE%>=1'>
									<%=website.getText("basketremoveline","Remove")%> 
								</a>
								
								<input type="submit" class="smalltext" onClick="if(qtyErr){ shakeQty(<%=i%>); return false; }" value="<%=website.getText("basketupdateline","Update")%> "/>
								
							</li>
							
							
							<% if (userSession.getWebsiteAccessDomainId() > Customer.WEB_ACCESS_TYPE_NO_PRICES) {  %> 
								<li class="baskettotprice">
									<%=userSession.formatPrice(linePrice)%>									
								</li>
							<% } %>
				
						</form>
					</ul>
					
					<% oddline = !oddline;
					
				}
			} catch (Exception e) {website.writeToLog(e);}
		}
		
		userSession.getShoppingBasket().setAdditionalDeliveryOptionsTotal(additionalDeliveryOptionsTotal);

		float discountAmount = 0;
		int discountPercentage =  userSession.getShoppingBasket().getDiscountPercentage();
		if (discountPercentage > 0) {
			discountAmount = new BigDecimal(totPrice).setScale(2, BigDecimal.ROUND_HALF_EVEN).multiply(new BigDecimal(discountPercentage).setScale(2, BigDecimal.ROUND_HALF_EVEN).divide(new BigDecimal(100))).floatValue();
			totPrice = new BigDecimal(totPrice).setScale(2, BigDecimal.ROUND_HALF_EVEN).subtract(new BigDecimal(discountAmount).setScale(2, BigDecimal.ROUND_HALF_EVEN)).floatValue();
		}
		float voucherRedeemAmount =  userSession.getShoppingBasket().getVouchersRedeemedTotal();
		if (voucherRedeemAmount > 0) {
			voucherRedeemAmount = new BigDecimal(voucherRedeemAmount).setScale(2, BigDecimal.ROUND_HALF_EVEN).multiply(new BigDecimal(userSession.getExchangeRate()).setScale(2, BigDecimal.ROUND_HALF_EVEN)).floatValue();
			totPrice = new BigDecimal(totPrice).setScale(2, BigDecimal.ROUND_HALF_EVEN).subtract(new BigDecimal(voucherRedeemAmount).setScale(2, BigDecimal.ROUND_HALF_EVEN)).floatValue();
		}
		int carriageRegionDomainId = userSession.getShoppingBasket().getCarriageRegionId();
		try {
			carriageRegionDomainId = Integer.parseInt(""+paramCarriageRegion);
		} catch (NumberFormatException nfe) {}
		float deliveryCharge = userSession.getShoppingBasket().getDeliveryCharge(totPrice,carriageRegionDomainId);
		deliveryCharge = new BigDecimal(deliveryCharge*userSession.getExchangeRate()).setScale(2, BigDecimal.ROUND_HALF_EVEN).floatValue();
		userSession.getShoppingBasket().setTotalAmount(totPrice+deliveryCharge); %>
		
	</div>
	
	
	<div id="basketsubtotal">
		<ul id="subtotaloptions">
			<% if (userSession.getShoppingBasket().getDiscountAmount() > 0) { %>
				<li>
					<ul class="minorbasketsubtotal labelpairleft">
						<li class="subtotaltitle"> <%=userSession.getShoppingBasket().getDiscountPercentage()%>% Discount </li>					
						<li class="subtotalamount"> <%=userSession.formatPrice(discountAmount*-1)%> </li>
					</ul>
				</li>
			<% } if (voucherRedeemAmount > 0) { %>
				<li>
					<ul class="minorbasketsubtotal labelpairleft">				
						<li class="subtotaltitle">Voucher </li>
						<li class="subtotalamount"><%=userSession.formatPrice(voucherRedeemAmount * -1)%>
					</ul>
				</li>					
			<% } if (userSession.getWebsiteAccessDomainId() > Customer.WEB_ACCESS_TYPE_NO_PRICES) { %>
				<li>
					<ul class="majorbasketsubtotal labelpairleft">				
						<li class="subtotaltitle"> Shopping Basket Total </li>
						<li class="subtotalamount"> <%=userSession.formatPrice(totPrice)%> </li>
					</ul>
				</li>
			<% } %>
		</ul>
	</div>
	
	
	<% if (website.isShowDelivery()){%>
	
		<div id="basketdelivery">
			
			<h2><%=website.getText("basketheadertwo","Your Delivery Options")%></h2>
			
			
			<form name="RecalcDeliveryCharge" action="basket.jsp" method="post">
				<ul class="carriageregion labelpairtop">
					<li class="label"><%=website.getText("basketdeliveryto","Delivery To")%> </li>
					<li class="value">
						<select name="carriageregion" class="inputitem" onchange="RecalcDeliveryCharge.submit();">
							<%=userSession.getCarriageRegionsHTML(carriageRegionDomainId)%>
						</select>
					</li>
				</ul>
			</form>
			
			
			<% if (website.isShowDelivery() && website.getCarriagePaidOrderAmount() > 0 && website.getCarriagePaidOrderAmount() < 999 && carriageRegionDomainId == Domain.CARRIAGE_REGION_UK_MAINLAND) { %>			
				<div id="subtotalfreedelivery">
					<%@include file="deliverywidget.jsp"%>
				</div>
			<% }
			
			
			File basketExtrasFile = new File(website.getWebSitePath() + "basketextras.html");
			if (basketExtrasFile.exists()){%>
				<jsp:include page="../../basketextrasV2.html" />
			<% } 
			basketExtrasFile = new File(website.getWebSitePath() + "basketextras.jsp");
			if (basketExtrasFile.exists()){ %>
				<jsp:include page="../../basketextrasV2.jsp" />
			<% } 
			
			
			if (userSession.getWebsiteAccessDomainId() > Customer.WEB_ACCESS_TYPE_NO_PRICES) { %>
				<ul class="majorbasketdeliverytotal labelpairleft">
					<li class="subtotaltitle"> <%=website.getText("basketsubdelivery","Delivery Total")%> </li>
					<li class="subtotalamount"> <%=userSession.formatPrice(deliveryCharge)%> </li>
				</ul>
			<% } %>
		</div>
		
	<% } else { %>
		<input type="hidden" name="carriageregion" value="<%=carriageRegionDomainId %>" />
	<% } %>
		
		
	<% if (userSession.getWebsiteAccessDomainId() > Customer.WEB_ACCESS_TYPE_NO_PRICES) { %>
		<div id="ordertotal">
			<ul class="majorbaskettotal labelpairleft">
				<li class="totaltitle"> <%=website.getText("basketsubdelivery","Your Order Total")%> </li>
				<li class="totalamount"> <%=userSession.formatPrice(totPrice+deliveryCharge)%> </li>
			</ul>
		</div>

		<% if (website.getWebsiteMode() == WebSite.MODE_TRADE){%>
			<%=website.getText("basketallpricesincludevat","All prices are exclusive of VAT")%>
		<% } %>
		
	<% } %>
	

	<div id="voucherandpromo">
	
		<form name="discountform" action="basket.jsp" method="post">
		
			<h2><%=website.getText("basketheaderthree","Promotional Codes or Vouchers")%></h2>
			
			<ul class="vandp">
			
				<li class="promocodes">
					<ul class="componentBorder componentFill1">
						<li class="promocodetextone">
							<%=website.getText("basketpromocodetext","From time to time we run promotions and special offers identified by a promotional code.")%>
						</li>
						<li class="promocodelabel">
							<%=website.getText("basketpromocodelabel","Enter Promotional Code:")%>
						</li>
						<li class="promocodeinput">
							<input type="text" name="promoCode" class="inputitem" value="<%=promoCode%>" />
						</li><!--
						--><li class="promocodebutton">	
							<a href="javascript: document.discountform.submit();">
								<%=website.getText("basketpromocodebutton","Apply Code")%>
							</a>
						</li>
						<li class="promomodemessage">
							<%=promoMsg%>
						</li>
					</ul>
				</li>
				
				<li class="vouchercode">
					<ul class="componentBorder componentFill1">
					
						<li class="voucherocodetextone">
							<%=website.getText("basketvouchertext","If you have purchased or been given a voucher, enter the details below. ")%>
						</li>
						<li class="voucherocode1label">
							<%=website.getText("basketvouchercodeonelabel","Voucher Code 1: ")%>
						</li>
						<li class="voucherocode1input">														
							<input type="text" name="voucherCode1" class="inputitem"  value="<%=voucherCode1%>"/>
						</li>
						<li class="voucherocode2label">
							<%=website.getText("basketvouchercodetwolabel","Voucher Code 2: ")%>
						</li>
						<li class="voucherocode2input">
							<input type="text" name="voucherCode2" class="inputitem"  value="<%=voucherCode2%>"/>
						</li><!--
						--><li class="vouchercodebutton">
							<a href="javascript: document.discountform.submit();">
								<%=website.getText("basketvoucherbutton","Apply Voucher")%>
							</a>
						</li>
						<li class="vouchermessage">
							<%=voucherMsg%>
						</li>
						
					</ul>
				</li>
				
			</ul>
		</form>
	</div>
	
	
	<%Vector allAlsoBoughtList = userSession.getShoppingBasket().getAllAlsoBoughtList();
	if (allAlsoBoughtList.size() > 0) { 
		final int guessMarginWidth = 31;
		%>
		<div id="basketalsobought">
			<div id="custalsoboughtheader">
				<ul>
					<li>
						<%=website.getAlsoBoughtText()%>
					</li>
				</ul>
			</div>
			<div id="component_scrollbox">
				<div id="alsoboughtbody">							
					<%=StockDetailPageView.getAlsoBoughtArticleList(request, allAlsoBoughtList, website.getNumAlsoBoughtItems(), userSession, 0, null, true)%>
				</div>
			</div>		
		</div>				
	<% } %>

	<div class="pagebottomnav">
		
		<ul class="navPage blocklistright">
		
			<% if (userSession.hasActiveGiftList()) { %>
				<li class="buttonbacktogiftlist">
					<a href="viewList.jsp?listcode=<%=userSession.getGiftListCode()%>">
						<img src="<%=website.getImagePath("back-to-giftlist.gif")%>" alt="" class="noBorder" />
					</a>
				</li>
			<% } %>
			
			<% if (psTransactionId != null) { 
				String returnLink = "viewList.jsp?id=" + psTransactionId;
				if (userSession.getShoppingBasket().getTransactionSubType() == Transaction.SUB_TYPE_TRANSACTION_PERSONAL_SHOPPING) {
					returnLink = "basket.jsp";
				}%>
				<li class="buttonbacktoshoppinglist">
					<a href="<%=returnLink %>"><img src="<%=website.getImagePath("btnleft.gif")%>" alt="" class="noBorder" /></a>
				</li>
			<% } %>
			
			<li class="buttonbacktoshop">
				<a href="<%=lastIndexPage%>"><%=website.getText("basketbacktoshopbutton","Back to shop")%></a>
			</li>
			
			<% if (userSession.getShoppingBasket().getTotalQuantity() > 0) { %>
				<li class="buttoncheckout">
					<a href="quickpay.jsp">
						<%=website.getText("basketcheckoutbutton","Checkout")%>
					</a>
				</li>
			<% } %>
			
		</ul>
		
	</div>
	
	<% if (!userSession.isShoppingBasketEmpty()) {%>
		<script type="text/javascript">
			if (document.getElementById('div_proceed1') != null) document.getElementById('div_proceed1').style.display='';
			if (document.getElementById('div_proceed2') != null) document.getElementById('div_proceed2').style.display='';
		</script>
	<% } %> 
	
<% } %>

