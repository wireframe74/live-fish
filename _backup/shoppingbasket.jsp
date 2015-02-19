<!-- start of components/shoppingbasket.jsp -->
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
<%@page import="java.sql.Connection" %>
<%@page import="java.io.File" %>

<%
	int paramPid = userSession.getWebController().getPid();
	int paramId = userSession.getWebController().getId();
	String action = request.getParameter("action");
	String psTransactionId = (String) session.getAttribute("psTransactionId");
	if (action == null) {
	    action = "";
	}
	
	String shoppingBasketShortName = "Basket";
	String shoppingBasketName = "Shopping Basket";
	if (userSession.getShoppingBasket().getTransactionSubType() == Transaction.SUB_TYPE_TRANSACTION_PERSONAL_SHOPPING) {
	    shoppingBasketName = "Personal Shopper List";
	}
	ArticleDetail articleDetail = userSession.getArticleDetail();
%>
<script type='text/javascript'>
	<!--
	function ValidateQty(paramQty, paramSqty, paramAibqty, paramOrigQty) {
        if ( paramQty == "" || isNaN(paramQty)) {
            alert ( "Please enter a Quantity" );
            return false;
        } else {
            var qty = parseInt(paramQty, 10);
            var origQty = parseInt(paramOrigQty, 10);
            var stockQty = parseInt(paramSqty,10)
            var alreadyInBasketQty = parseInt(paramAibqty,10)

            if ((alreadyInBasketQty + (qty - origQty)) > stockQty) {
                alert("There is not enough quantity in stock to fulfil your request ("+stockQty+" item"+(stockQty==1?"":"s")+" in stock)." );
                return false;
            }
        }
        return true;
    }
    //-->
</script>
<%
	boolean bContinue2 = true;
	if (website.getDefaultWebsiteAccessDomainId() < Customer.WEB_ACCESS_TYPE_FULL) {
		if (!userSession.isLoggedIn() || userSession.getWebsiteAccessDomainId() < Customer.WEB_ACCESS_TYPE_FULL) {
			bContinue2 = false;	
			if (userSession.isLoggedIn()) {
				userSession.refreshCurrentLogin(); // try a refresh
				if (userSession.getWebsiteAccessDomainId() < Customer.WEB_ACCESS_TYPE_FULL) {
%>
<table width="100%" align="center" cellspacing="0" cellpadding="0">
	<tr height="100%">
		<td height="100%" class="pagetitle">
			<center>
				<br /><br /><br />Your registration is pending, please try again later.<br /><br /><br /><br /><br /><br /><br /><br />
			</center>
		</td>
	</tr>
</table>
<%
				} else {
					bContinue2 = true;
				}
			} else {
			    
%>
<table width="100%" align="center" cellspacing="0" cellpadding="0">
	<tr height="100%">
		<td height="100%" class="pagetitle">
			<center>
				<br /><br /><br /><%=website.getBasketLoginMsg()%>
				<br /><br /><br /><br /><br /><br /><br /><br />
			</center>
		</td>
	</tr>
</table>
<%
			}
		}
	} 
	if (bContinue2) {    
		String promoCode = "";
		String promoMsg = "<a href=\"javascript: document.discountform.submit();\">Click here to apply the promotion code</a>";
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
			userSession.getShoppingBasket().setCarriageRegionId(carriageRegionDomainId);
			paramCarriageRegion = ""+carriageRegionDomainId ;		
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
			} catch(ShoppingBasket.BasketItemSoldOutException bsoe) {
%>
<script type="text/javascript">
	alert ("<%=bsoe.getMessage()%>");
</script>
<%
			} catch (ShoppingBasket.BasketItemNotEnoughItemsInStockException bnee) {
%>
<script type="text/javascript">
	alert ("<%=bnee.getMessage()%>");
</script>
<%
			}
		}
		try {
			userSession.getShoppingBasket().verifyBasket();
		} catch(ShoppingBasket.BasketItemSoldOutException bsoe) {
%>
<script language="Javascript">
	alert ("<%=bsoe.getMessage()%>")
</script>
<%
		}
%>
<table width="97%" align="center" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<table border="0" width="100%" align="center" valign="top" cellspacing="0" cellpadding="0">
				<tr>
					<td align=left valign=bottom class="trail">
						<%=userSession.getTrailHTML("Shopping Basket", UserSession.getFullURL(request))%>
					</td>
					<td align="right" width="100">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td width="50%"></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	
	<tr>
		<td>
			<table class="smallertext" width="97%" align="center" valign="top" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>
						<div style="padding-top:25px;padding-bottom:30px;">
							<center><img src="<%=website.getImagePath("checkoutprocess1.gif")%>" alt="" /></center>          
						</div>
					</td>
				</tr>
				
				<tr>
					<td>
						<table align="left" cellspacing="0" cellpadding="0">  
							<tr>
								<td valign="middle">
									<a href=<%="'"+userSession.getLastIndexURL()+"'"%> class="button">
										&nbsp;&nbsp;<img src="<%=website.getImagePath("btnleft.gif")%>" alt="" class="noBorder" />&nbsp;Back to Shop&nbsp;&nbsp;
									</a>
									<br />
								</td>
<%
	if (userSession.hasActiveGiftList()) {
%>								
								<td>
									<a href="viewList.jsp?listcode=<%=userSession.getGiftListCode()%>"  class="buttonmed">
										&nbsp;&nbsp;&nbsp;<img src="<%=website.getImagePath("btnleft.gif")%>" alt="" class="noBorder" />&nbsp;Back to Gift List&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									</a>
								</td>
<%
	}
%>
<%
	if (psTransactionId != null) {
	    String returnLink = "viewList.jsp?id=" + psTransactionId;
	    if (userSession.getShoppingBasket().getTransactionSubType() == Transaction.SUB_TYPE_TRANSACTION_PERSONAL_SHOPPING) {
	        returnLink = "basket.jsp";
	    }
%>
								<td>
									&nbsp;<a href="<%=returnLink %>" class="buttonlong">
										&nbsp;<img src="<%=website.getImagePath("btnleft.gif")%>" alt="" class="noBorder" />&nbsp;&nbsp;Back to Shopping List&nbsp;&nbsp;&nbsp;
									</a>
								</td>

<%
	}
%>  					
							</tr>
     					</table>
						<div id="div_proceed1" style="display:none;">
							<table align="right" cellspacing="0" cellpadding="0">
								<tr>
									<td valign="middle">
										<a href="delivery.jsp" class="button">
											&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=website.getCheckoutButtonText()%>&nbsp;&nbsp;&nbsp;<img src="<%=website.getImagePath("btnright.gif")%>" alt="" class="noBorder" />&nbsp;&nbsp;
										</a>
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
<%
		
		String pageTitle = "Your "+shoppingBasketName+"&nbsp;";
		String pageTitleText = "";
		String pageTitleImage = "";
%>
								<table width="99%" cellspacing="2" cellpadding="0" border="0"> 
									<tr>
										<td width="100%" class="pagetitle" valign="center" colspan="99">				
											<%@include file="../drawcontainerheader.html"%>
										</td>
									</tr>
									<tr>
										<td>
											<img src="<%=website.getImagePath("spacer.gif")%>" alt="" class="width1 height15" />
										</td>
									</tr>
									<tr>
										<td align="center" class="formheader" style="text-align:center; vertical-align:center">
											Remove
										</td>
										<% if (website.isShowBasketThumbnail()) { %>
										<td>&nbsp;
											
										</td>
										<% } %>
										<td align="left" class="formheader" style="text-align:left; vertical-align:center"> 
											Description
										</td>
<% 
		if (userSession.getWebsiteAccessDomainId() > Customer.WEB_ACCESS_TYPE_NO_PRICES) { 
%>
										<td align="right" class="formheader" style="text-align:right; vertical-align:center">
											Price
										</td>
<%
		}
%>
										<td align="left" class="formheader"></td>
										<td class="formheader" align="center">
                        					Quantity
										</td>
<%
		if (userSession.getWebsiteAccessDomainId() > Customer.WEB_ACCESS_TYPE_NO_PRICES) { 
%>
										<td align="right" class="formheader" style="text-align:right; vertical-align:center">
											Total Price
										</td>
<%
		}
%>
									</tr>
<%
		DefaultTableModel consoleTableModel = userSession.getShoppingBasket().getConsoleTableModel();
		WebDiscountManager discountManager = (WebDiscountManager)userSession.getShoppingBasket().getDiscountManager();

        float totPrice = 0;

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
					messageTypeDesc = domainRow.get(Domain.DOMAIN_DESCRIPTION) + messagePriceNarr +":\n" +message;
                }

		  if (messageTypeDomainId > 0 && messageTypeDomainId == TransactionLine.MESSAGE_TYPE_LINE_NOTE) {
			messageTypeDesc = StringHelper.replace(StringHelper.replace(StringHelper.replace(co.simplypos.model.utils.helpers.HTMLHelper.applyHTML(message),"<br />","\n"),"COUNT_",""),"_"," ");
			isLineNote = true;
		  }

				Hashtable row = articleDetail.getRow(vendorArticleClsfnId);
				String shortDescription = (String)row.get(ArticleDetail.SHORT_DESCRIPTION);
				String fullDescription = (String)row.get(ArticleDetail.FULL_DESCRIPTION);
				int blobStorageId = 0;
				try {
					blobStorageId = ((Integer)row.get(ArticleDetail.BLOB_STORAGE_ID)).intValue();
				} catch (Exception ee) {}
				String imageName = website.getImagePath("ImageDefaultArticle.jpg");
				String imageWidth = String.valueOf(website.getBasketThumbSize()) + "px";
				if (blobStorageId > 0) {
					imageName = website.getArticleMenu().getCachedImageName(shortDescription, blobStorageId, website.getBasketThumbSize());
					File cachedImage = new File(website.getWebSitePath()+website.getArticleMenu().getCachedImageName(shortDescription,blobStorageId,website.getBasketThumbSize()));
					if (!cachedImage.exists()) {
					    try {
					    	RenderImageServlet.buildImage(userSession, vendorArticleId, shortDescription, blobStorageId, website.getBasketThumbSize(), true, request);
					    } catch (Exception e) {
					        imageName = website.getImagePath("ImageDefaultArticle.jpg");
					        imageWidth = String.valueOf(website.getBasketThumbSize()) + "px";
					    }
					}
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
<%
				}
%>
									<tr>
										<td align="left" style="text-align:left; vertical-align:center">
											<table align="center" cellspacing=0 cellpading=0>
												<tr>
													<td>
														<a href='basket.jsp?del=1&index=<%=i%>&id=<%=vendorArticleId%>&<%=UserSession.URL_PARAM_NO_TRAIL_PHRASE%>=1'>
															<img src="<%=website.getImagePath("delete.gif")%>" alt="Remove" class="noBorder" />
														</a>
													</td>
												</tr>
											</table>
										</td>
										<% if (website.isShowBasketThumbnail()) { %>
										<td>
											<a class="smallertext"  href='<%=ArticleMenu.getPageName(website, shortDescription, true)%>?pid=<%=parentVendorArticleId%>&id=<%=vendorArticleId%>&tlid=<%=transLineId%>'>
												<img src="<%=imageName %>" alt="<%=shortDescription %>" title="<%=shortDescription %>" <%=imageWidth.equals(imageWidth) ? "" : "width=\"" + imageWidth + "\""%>/>
											</a>
										</td>
										<% } %>
										
										<td align="left" style="text-align:left; vertical-align:center; horizontal-align:center;">
											<a class="smallertext"  href='<%=ArticleMenu.getPageName(website, shortDescription, true)%>?pid=<%=parentVendorArticleId%>&id=<%=vendorArticleId%>&tlid=<%=transLineId%>'>
												<%=shortDescription%>
											</a>
										</td>
										
<%
				if (userSession.getWebsiteAccessDomainId() > Customer.WEB_ACCESS_TYPE_NO_PRICES) { 
%>
										<td class="smallertext" align="right" style="text-align:right; vertical-align:center">
											<%=userSession.convertAndFormatPrice(itemPrice)%>
										</td> 
<%
				}
%>
										<td align="left" style="text-align:left; vertical-align:center"> 
											<table width="100%" cellspacing="0" cellpadding="0" border="0">
												<tr>
<%
				if (!discountsApplied.equals("")) {
%>
													<td align="left" style="text-align:left; vertical-align:center">
														<a href='<%=ArticleMenu.getPageName(website, shortDescription, true)%>?pid=<%=parentVendorArticleId%>&id=<%=vendorArticleId%>&tlid=<%=transLineId%>' title='<%=discountsApplied%>'><img src="<%=website.getImagePath("savesmall.gif")%>" alt="" class="noBorder" /></a>
													</td>
<%
				}
				if (wrappingTypeDomainId > 0 && wrappingTypeDomainId != TransactionLine.WRAPPING_TYPE_NO_WRAPPING) {
%>
													<td align="left" style="text-align:left; vertical-align:center">
														<a href='<%=ArticleMenu.getPageName(website, shortDescription, true)%>?pid=<%=parentVendorArticleId%>&id=<%=vendorArticleId%>&tlid=<%=transLineId%>#giftwrapoptions' title='<%=wrapTypeDesc%>'><img src="<%=website.getImagePath("gift_wrapped_small.gif")%>" alt="<%=wrapTypeDesc%>" class="height24 noBorder" /></a>
													</td>
<%
				}
				if (messageTypeDomainId > 0 && messageTypeDomainId != TransactionLine.MESSAGE_TYPE_NO_MESSAGE) {
%>
													<td align="left" style="text-align:left; vertical-align:center">
														<a href='<%=ArticleMenu.getPageName(website, shortDescription, true)%>?pid=<%=parentVendorArticleId%>&id=<%=vendorArticleId%>&tlid=<%=transLineId%><%=isLineNote?"#personalisationoptions":"#giftwrapoptions"%>' title='<%=messageTypeDesc%>'><img src="<%=website.getImagePath("hand_writing_small.gif")%>" alt="<%=isLineNote?messageTypeDesc:messageTypeDesc%>" class="height24 noBorder" /></a>
													</td>
<%
				}
%>

												</tr>
											</table>
										</td>
										<form method="post" name=<%="qtyform"+i%> style="margin-bottom:0;" action='basket.jsp' onsubmit=<%=!website.isAllwaysShowInStock()&&userSession.getArticleDetail().getOrderType(vendorArticleId)==VendorArticle.ORDER_TYPE_SELL_IN_STOCK_ONLY?"'return ValidateQty(document.qtyform"+i+".qty.value, document.qtyform"+i+".sqty.value, document.qtyform"+i+".aibqty.value, document.qtyform"+i+".origqty.value)'":"''"%>>
				                            <td align="right" style="text-align:right; vertical-align:center">
												<table align="right" cellpadding="1" cellspacing="0" border="0">
													<tr>
														<td>
															<table border="0" cellpadding="0" cellspacing="0" bottommargin="0">
																<tr>
																	<td>
																		<input type="text" class="inputitem" name="qty" value='<%=ArticleDetail.formatQuantity(quantity,false)%>' size="1" />
																	</td>
																</tr>
															</table>
														</td>
														<td> 
															<table cellspacing="0" cellpadding="0" border="0">
																<tr>
																	<td>
																		<table align="right" cellspacing="0" cellpadding="0" border="0">
																			<tr>
																				<td>
<%
				if (!website.isAllwaysShowInStock() && userSession.getArticleDetail().getOrderType(vendorArticleId)==VendorArticle.ORDER_TYPE_SELL_IN_STOCK_ONLY) {
%>
																					<a href=<%="'javascript: if (ValidateQty(document.qtyform"+i+".qty.value, document.qtyform"+i+".sqty.value, document.qtyform"+i+".aibqty.value, document.qtyform"+i+".origqty.value)) document.qtyform"+i+".submit();'"%> class="smalltext"><img src="<%=website.getImagePath("updatebasket.gif")%>" alt="Update quantity" class="noBorder" /></a>
<% 
				} else {
%>
																					<a href=<%="'javascript: document.qtyform"+i+".submit();'"%> class="smalltext"><img src="<%=website.getImagePath("updatebasket.gif")%>" alt="Update quantity" class="noBorder" /></a>
<%
				}
%>
																				</td>
																			</tr>
																		</table>
																		<input type=hidden name='pid' value='<%=parentVendorArticleId%>'>
																		<input type=hidden name='id' value='<%=vendorArticleId%>'>
																		<input type=hidden name='tlid' value='<%=transLineId%>'>
																		<input type=hidden name='origqty' value='<%=quantity%>'>
																		<input type=hidden name='sqty' value='<%=userSession.getArticleDetail().getQuantity(parentVendorArticleId, vendorArticleId)%>'>
																		<input type=hidden name='aibqty' value='<%=userSession.getShoppingBasket().getQuantityInBasket(parentVendorArticleId, vendorArticleId)%>'>
																		<input type=hidden name=<%="'"+UserSession.URL_PARAM_NO_TRAIL_PHRASE+"'"%> value='1'>
                                                					</td>
																</tr>
                                        					</table>
                                    					</td>
                                    				</tr>
                                				</table>
                            				</td>
                        				</form>
<%
				if (userSession.getWebsiteAccessDomainId() > Customer.WEB_ACCESS_TYPE_NO_PRICES) { 
%>
										<td class="smallertext" align="right" style="text-align:right; vertical-align:center">
                            				<%=userSession.formatPrice(linePrice)%>
										</td>
<% 
				} 
%>
									</tr>
<%
			}
            } catch (Exception e) {
                website.writeToLog(e);
            }
		}
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
		userSession.getShoppingBasket().setTotalAmount(totPrice+deliveryCharge);

%>
								</table>
							</div>
						</td>
					</tr>
					<tr>
						<td>
							<table class="smallertext" align="right" width="360" border="0" style="margin-right:2px;">  
<%
		if (userSession.getShoppingBasket().getDiscountAmount() > 0) { 
%>
								<tr>
									<td class="discount" align=left width=70%>
										<%=userSession.getShoppingBasket().getDiscountPercentage()%>% Discount
									</td>
									<td class="discount" align="right" style="text-align:right; vertical-align:center" width="25%">
										<%=userSession.formatPrice(discountAmount*-1)%>
									</td>
								</tr>
<% 
		}
		if (voucherRedeemAmount > 0) { 
%>
								<tr>
									<td class="discount" align="left" width="70%">
										Voucher
									</td>
									<td class="discount" align="right" style="text-align:right; vertical-align:center" width="25%">
										<%=userSession.formatPrice(voucherRedeemAmount * -1)%>
									</td>
								</tr>
<%
		} 
		if (userSession.getWebsiteAccessDomainId() > Customer.WEB_ACCESS_TYPE_NO_PRICES) { %>
								<tr>
									<td class="smallertext" align="left" width="70%">
										Shopping Basket Total
									</td>
									<td class="smallertext" align="right" style="text-align:right; vertical-align:center" width="25%">
										<%=userSession.formatPrice(totPrice)%>
									</td>
								</tr>
<%
		}
		
		if (website.isShowDelivery()) {
%>
								<tr>
									<td class="smallertext" align="left" style="text-align:left; vertical-align:center">
										<form name="RecalcDeliveryCharge" action="basket.jsp" method="post">
											Delivery to <select name="carriageregion" class="inputitem" value="<%=carriageRegionDomainId%>" onchange="RecalcDeliveryCharge.submit();"><%=userSession.getCarriageRegions(carriageRegionDomainId)%></select>
										</form>
	                  				</td>
<%
			if (userSession.getWebsiteAccessDomainId() > Customer.WEB_ACCESS_TYPE_NO_PRICES) { 
%>
									<td class="smallertext" height="100%" align="right" style="text-align:right; vertical-align:center;"> 
										<%=userSession.formatPrice(deliveryCharge)%>
									</td>
<% 
			} 
%>
								</tr>
<% 
		} else {
%>
			<input type="hidden" name="carriageregion" value="<%=carriageRegionDomainId %>" />
<%		    
		}
		if (userSession.getWebsiteAccessDomainId() > Customer.WEB_ACCESS_TYPE_NO_PRICES) { 
%>
								<tr class="checkoutcontainer">
									<td colspan="2">
										<div class="checkoutcontainer">
											<table cellpadding="0" cellspacing="0" border="0" width="100%">
												<tr>
													<td align="left" style="text-align:left; vertical-align:center"> 					
														<div class="pagetitle">
															<font style="font-size:14"><b>Order Total</b></font>
														</div>
													</td>
													<td align="right" style="text-align:right; vertical-align:middle">
														<div class="pagetitle">
															<font style="font-size:14"><b><%=userSession.formatPrice(totPrice+deliveryCharge)%></b></font>
														</div>
													</td>
												</tr>
											</table>
										</div>
									</td>
								</tr>
								<tr>                    
									<td colspan="2" align="right" style="text-align:right; vertical-align:center" class="smallertext">
<% 
		if (website.getWebsiteMode() == WebSite.MODE_TRADE) { 
%>
										All prices are exclusive of VAT
<% 
		} 
%>
									</td>
								</tr>
<% 
		if (website.isShowDelivery() && website.getCarriagePaidOrderAmount() > 0 && website.getCarriagePaidOrderAmount() < 999 && carriageRegionDomainId == Domain.CARRIAGE_REGION_UK_MAINLAND) { 
%>			<tr>
				<td>
               		 <%@include file="deliverywidget.jsp"%>
				</td>
<% 
		} 
%>		  
<% 
		} 
%>
							</table>	  
						</td>
					</tr>
				</table> 
			</td>
		</tr>
<% 
		File basketExtrasFile = new File(website.getWebSitePath() + "basketextras.html");
		if (basketExtrasFile.exists()) {
%>
			<tr>
				<td>
					<jsp:include page="../../basketextras.html" />
				</td>
			</tr>

<%
		} 
		basketExtrasFile = new File(website.getWebSitePath() + "basketextras.jsp");
		if (basketExtrasFile.exists()) {
%>
			<tr>
				<td>
					<jsp:include page="../../basketextras.jsp" />
				</td>
			</tr>

<%
		} 
%>
		<tr>
			<td>
				<img src="<%=website.getImagePath("spacer.gif")%>" alt="" class="width1 height15" />
			</td>
		</tr>
		<tr>
			<td>
				<form name="discountform" action="basket.jsp" method="post">
					<div class="checkoutcontainer">
						<table border="0" cellspacing="0" cellpadding="0" width="90%" align="left" >
							<tr valign="top">
								<td align="left">
									<table border="0" cellspacing="0" cellpadding="0" width="99%">
										<tr valign="top">
											<td align="left">
												<span class="pagesubtitle" align="left">
													<img src="<%=website.getImagePath("containerheader.gif")%>" alt="" class="containerHeader" />
													Promotional Codes or Vouchers
												</span>
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td>
									<table width="95%" align="left" border="0" style="margin:0 0 0 40px;">									
										<tr valign="top">
											<td>																						
												From time to time we run promotions and special offers identified by a promotional code. 
											</td>
										</tr>
										<tr valign="middle">
											<td colspan="1"><br />
												<center>
													<table cellspacing="0" cellpadding="0" border="0">
														<tr valign="middle">
															<td class="smallertext">	                                    
																Enter Promotional Code:&nbsp;
															</td>
															<td width="130">								
							       								<input type="text" name="promoCode" valign="center" class="inputitem" value="<%=promoCode%>" />
						       								</td>
															<td>
																<img src="<%=website.getImagePath("spacer.gif")%>" alt="" />
															</td>
															<td>
																<a href="javascript: document.discountform.submit();"><img src="<%= website.getImagePath("search.jpg") %>" alt="Lookup" class="noBorder width23 height18" /></a>
															</td>
															<td width="150" class="discount">
																<div style="margin-left:10px;"><%=promoMsg%></div>
															</td>
														</tr>
													</table>
												</center>
												<br />
											</td>
										</tr>
										<tr>
											<td>
												<img src="<%=website.getImagePath("spacer.gif")%>" alt="" class="width1 height10" />
											</td>
										</tr>
										<tr valign="bottom">
											<td>
												If you have purchased or been given a voucher, enter the details below. 
											</td>
										</tr>
										<tr>
											<td colspan="1">
												<br />
												<center>
													<table cellspacing="0" cellpadding="0" border="0">
														<tr>
															<td>
																<table cellspacing="0" cellpadding="0" border="0">
																	<tr valign="middle">
																		<td class="smallertext">	                                    
																			Voucher Code 1:&nbsp;
																		</td>
																		<td width="130">																
																			<input type="text" name="voucherCode1" valign="center" class="inputitem"  value="<%=voucherCode1%>"/>
																		</td>
																	</tr>
																	<tr valign="middle">
																		<td class="smallertext">	                                    
																			Voucher Code 2:&nbsp;
																		</td>
																		<td width="130">								
																			<input type="text" name="voucherCode2" valign="center" class="inputitem"  value="<%=voucherCode2%>"/>
																		</td>
																	</tr>
																</table>
															</td>
															<td>
																<a href="javascript: document.discountform.submit();"><img src="<%=website.getImagePath("search.jpg")%>" alt="Lookup" class="noBorder width23 height18 search" /></a>
															</td>
															<td width="150" class="discount">
																<div style="margin-left:10px;"><%=voucherMsg%></div>
															</td>
														</tr>						
													</table>
												</center>
												<br />
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</div>
				</form>
			</td>
		</tr>
		<tr>
			<td>
				<br />
        		<table align="left" cellspacing="0" cellpadding="0">  
					<tr>
						<td valign="middle">
							<a href=<%="'"+userSession.getLastIndexURL()+"'"%> class="button">&nbsp;&nbsp;<img src="<%=website.getImagePath("btnleft.gif")%>" alt="" class="noBorder" />&nbsp;Back to Shop&nbsp;&nbsp;</a>
							<br />
						</td>
					</tr>
     			</table>
         		<div id="div_proceed2" style="display:none;">
					<table align="right" cellspacing="0" cellpadding="0">
						<tr>
							<td valign="middle">
								<a href="delivery.jsp" class="button">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=website.getCheckoutButtonText()%>&nbsp;&nbsp;&nbsp;<img src="<%=website.getImagePath("btnright.gif")%>" alt="" class="noBorder" />&nbsp;&nbsp;</a>
							</td>
						</tr>
					</table>
         		</div>
    		</td>
	   </tr>
</table>
<br />

<% 
		if (!userSession.isShoppingBasketEmpty()) {
%>
<script type="text/javascript">
	<!--
	document.getElementById('div_proceed1').style.display='';
	document.getElementById('div_proceed2').style.display='';
    //-->
</script>
<%
		} 
} 
%>
<!-- end of components/shoppingbasket.jsp -->