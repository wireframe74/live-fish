<!-- start of components/stockdetail.html -->
<%
	StockDetailPageModel pageModel = (StockDetailPageModel) userSession.getWebController().getCurrentPageController().getPageModel();
	StockDetailPageView pageView = (StockDetailPageView) userSession.getWebController().getCurrentPageController().getPageView();
	StockDetailPageController pageController = (StockDetailPageController) userSession.getWebController().getCurrentPageController();
	if (pageController.getUserMessage() != null) {
		%>
		<script type="text/javascript">
			<!--
			alert("<%=pageController.getUserMessage()%>");
			//-->
		</script>
<%
		return;
	}
%>
<div class="component_stockdetail">
	<div id="pagenavtop">
		<div id="stockdetailtrail" class="trail">
			<%=pageView.getTrailHTML(pageModel.getShortDescription(), request)%>
		</div>
		<div id="stockdetailpagenavtopbuttons">
			<span class="buttonbacktoshop">
				<a href="<%=userSession.getLastIndexURL()%>"><img src="<%=website.getImagePath("back-to-shop.gif")%>" alt="" class="noBorder" /></a>
			</span>
			<% if (userSession.hasActiveGiftList()) { %>
				<span class="buttonbacktogiftlist">
					<a href="viewList.jsp?listcode=<%=userSession.getGiftListCode()%>"><img	src="<%=website.getImagePath("back-to-giftlist.gif")%>" alt="" class="noBorder" /></a>
				</span>
			<% } %>
			<% if (pageModel.getPersonalShopperTransactionId() > 0) { %>
				<span class="buttonbacktoshoppinglist">
					<a href="viewList.jsp?id=<%=pageModel.getPersonalShopperTransactionId()%>"><img src="<%=website.getImagePath("btnleft.gif")%>" alt="" class="noBorder" /></a>
				</span>
			<% } %>
			<span class="buttonviewbasket">
				<a href="basket.jsp"><img src="<%=website.getImagePath("view-basket.gif")%>" alt="" class="noBorder" /></a>
			</span>
		</div>
	</div>
	<% if (pageController.getValidationMessage() != null) { %>
		<div id="pagevalidationmessage">
			<img src='<%=website.getImagePath("icon_error.gif")%>'>&nbsp;
			<div class="pagevalidationtext"><%=pageController.getValidationMessage()%></div>
		</div>
	<% } %>	
	<div id="component_stockdetail_image" style="width:<%=website.getProductPageImageSize()%>px;" >
		<% if (userSession.getArticleDetail().countImages() > 1 && website.getAdditionalImageSize() > 0) { %>
			<div id='stockdetailprimaryimage_ajax'>
				<jsp:include page="template/components/stockdetailprimaryimage.jsp" />
			</div>
			<% Iterator iter = userSession.getArticleDetail().getImages().iterator();
			   while (iter.hasNext()) { 
				ArticleDetailImage articleDetailAdditionalImage = (ArticleDetailImage)iter.next(); %>

				<SCRIPT language="JavaScript"> <!-- if (document.images) { pic1= new Image(); pic1.src="<%=articleDetailAdditionalImage.getAdditionalImageName()%>"; } //--> </SCRIPT> 
				<div class='img left' style='padding-top:2px;padding-bottom:2px;padding-right:4px;'>
					<ajax:anchors target='stockdetailprimaryimage_ajax' ajaxFlag='stockdetailprimaryimage_ajax'>
						<a href='template/components/stockdetailprimaryimage.jsp?imageName=<%=articleDetailAdditionalImage.getPrimaryImageName()%>&amp;imageId=<%=articleDetailAdditionalImage.getBlobStorageId()%>'>  <% //nm1 %>
							<img src='<%=articleDetailAdditionalImage.getAdditionalImageName()%>'
								alt='<%=articleDetailAdditionalImage.getImageShortDescription()%>'
								title='<%=articleDetailAdditionalImage.getImageShortDescription()%>'
								onmouseover="document.getElementById('primaryimage').title=document.getElementById('primaryimage').src;document.getElementById('primaryimage').src='<%=articleDetailAdditionalImage.getPrimaryImageName()%>;'" 
								onmouseout="document.getElementById('primaryimage').src=document.getElementById('primaryimage').title;" 
 							/>
						</a>
					</ajax:anchors>
				</div>
			<% } %>
		<% } else { %> 
			<jsp:include page="template/components/stockdetailprimaryimage.jsp" /> 
		<% } %>
	</div>
	<% if (pageModel.getArticleType() == Article.ARTICLE_TYPE_STANDARD_ARTICLE || pageModel.getArticleType() == Article.ARTICLE_TYPE_CLASSIFICATION_ARTICLE_SET || pageModel.getArticleType() == Article.ARTICLE_TYPE_OPTIONS) { %>
	   <div id="component_stockdetail_maindetail">
		<h1><%=pageModel.getShortDescription()%></h1>

		<div id="productcode" class="smalltext">
			Product code: <%=pageModel.getVendorArticleCode()%><br />
		</div>
		<div id="productprice">
			<%=pageView.getPriceHTML("","smalltext")%>
		</div>
		<% if (!pageModel.isHasOptions() || pageModel.isOption()) { %>
			<div class="smallgray">
				<%=HTMLComponents.getInStockIndicatorHTML(website, pageModel.getQuantity(), pageModel.getQtyInBasket(), pageModel.isAllowOutOfStockOrdering(), false)%>
				<% if (userSession.getGiftListArticles().contains(new Integer(pageModel.getVendorArticleId())) && userSession.getQuantityRemaining(pageModel.getVendorArticleId(), userSession.getListClassId()) > 0) { %>
					<div class="stockcontainer">
						<img align="left" src="<%=website.getImagePath("giftlist.png")%>" alt="Gift List Item" class="height25" /> 
						<br />
						<%=userSession.getQuantityRemaining(pageModel.getVendorArticleId(), userSession.getListClassId())%> Required for '<%=userSession.getGiftListName()%>'
					</div>
				<% } %> 
			
				<% if (pageModel.getQtyInBasket() > 0) { %> 
					<%=HTMLComponents.getQtyInYourBasketHTML(pageModel.getQtyInBasket())%>
				<% } %>
			</div>
		<% } %>
		<% if (pageModel.isShowEnquiryEmail() && stockEnquiryString != null) { %>
			<div id="productemailenquiry">
				<form name="emailenq" method="post" action="#" style="margin:0px;margin-top:5px;">
					<%=stockEnquiryString%>
					<input type="text" name="enqstockemail" valign="center" style="width:125px; background-color:#ffffff; border-width:2;" value="Email Address" onfocus="this.value='';" /> 
					<input type="submit" value="Enquire" /> 
					<input type="hidden" name="id" value='<%=pageModel.getVendorArticleId()%>' />
					<input type="hidden" name="pid" value='<%=pageModel.getParentVendorArticleId()%>' />
				</form>
			</div>
		<% } else { %>
			<input type="hidden" name="enqstockemail" value="" />
		<% } %>
	  	<% if (pageModel.getMessageEmailSendResult() != null) { %>
			<div class='pagevalidationtext'><%=pageModel.getMessageEmailSendResult()%></div>
		<% } %>	
		<div id="productsubdetail">
			<form name="qtyform" method="post" action="<%=request.getRequestURL().toString()%>?rpid=<%=pageModel.getRecParentVendorArticleId()%>&amp;rid=<%=pageModel.getRecVendorArticleId()%>" style="margin:0px;">   <% //nm1 %>
				<input type="hidden" name="action" value="" />			
				<div id="productoptionselection">
					<% if (!pageModel.isHasOptions() && pageModel.getOptionSetId() == 0) { %>
						<input type="hidden" name="id" value="<%=pageModel.getVendorArticleId()%>" /> 
						<input type="hidden" name="pid" value="<%=pageModel.getParentVendorArticleId()%>" /> 
					<% } else if (pageModel.isHasOptions()) { %> 
						<input type="hidden" name="pid" value="<%=pageModel.getParamPid()%>" /> 
						<%=pageModel.getOptionList()%>
						
					<% } %>
				</div>
				<% if (pageModel.isHasOptions() || pageModel.getOrderType() == VendorArticle.ORDER_TYPE_ENQUIRIES_ONLY) { %>
					<input type="hidden" name="updbasket" value="<%=website.getAddToBasketText()%>" class="button_basket button" /> 
				<% } %>
				<% if (!pageModel.isHasOptions() || pageModel.isOption()) { %> 
					<% if (pageModel.getOrderType() != VendorArticle.ORDER_TYPE_ENQUIRIES_ONLY && pageModel.getOrderType() != VendorArticle.ORDER_TYPE_ENQUIRIES_ONLY_HIDE_PRICE) { %>
						<% if (pageModel.getUnitPrice() > 0) { %>
							<div id="productqtyandaddtobasket">
								<span id="productquantity">
									<span class="productquantitytext">
										Quantity:
									</span>
									<span class="productqty productquantityinput">
										<img src="<%=website.getImagePath("icon_minus.gif")%>" alt="-" onclick="qty_minus('qty', 1)" />
										<input type="text" class="inputitem_productqty" id="qty" name="qty" value="1" size="1" />
										<img src="<%=website.getImagePath("icon_plus.gif")%>" alt="+" onclick="qty_plus('qty', 99)" />
									</span>
								</span>
								<input type="hidden" name="price" value="<%=pageModel.getUnitPrice()%>" />
	
								<div id="productadd">
									<input type="submit" name="updbasket" value="<%=website.getAddToBasketText()%>" class="buttonaddtobasket" />
								</div>
								<% if (userSession.hasActiveGiftList() && userSession.isGiftListOwner()) { %>
									<% if (userSession.getGiftListArticles() != null && userSession.getGiftListArticles().contains(new Integer(pageModel.getVendorArticleId()))) { %> 
										<span id="removefromgiftlist">
											<a href="javascript: document.qtyform.action.value='glRemove';document.qtyform.submit();"><img src="<%=website.getImagePath("remove-from-giftlist.gif")%>" alt="Remove from gift list" class="noBorder" /></a>
										</span>
									<% } else {	%> 
										<span id="addtogiftlist">
											<a href="javascript: document.qtyform.action.value='glAdd';document.qtyform.submit();"><img src="<%=website.getImagePath("add-to-giftlist.gif")%>" alt="Add to gift list" class="noBorder" /></a>
										</span>
									<% } %>
								<% } %>
								
							</div>
						<% } %>
					<% } %>
					<div id="productserviceslinks">
						
						<% if (pageModel.getArticleSubType() == Article.ARTICLE_SUB_TYPE_STANDARD_GIFT) { %>
							<% if (website.isOfferGiftWrappingService()) { %>
								<!--
								<a href="template/components/stockdetailgiftwrappopup.jsp?actionURL=<%=request.getRequestURL().toString()%>" onclick="return GB_showCenter('Giftwrapping',this.href, 380, 640, 0);">
									<span class="extras">
										<img src="<%=website.getImagePath("gift-wrapping.gif")%>" alt="" class="noBorder" />
										<%=website.getText("handwritecard","Giftwrapping")%>
									</span>
								</a>
								-->
								<div class="productservicelink">
								   <a href="#giftwrapoptions" onclick='javascript:document.getElementById("div_giftwrapoptions").style.display="";' >
									<img src="<%=website.getImagePath("gift-wrapping.gif")%>" alt="" class="noBorder" />
									<%=website.getText("handwritecard","Giftwrapping")%>
								   </a> 
								  </div>
							<% } %> 
							<% if (website.isShowPersonalisationForms() && pageModel.getPersonalisationFormName() != null) { %>
								<div class="productservicelink">
								   <a href="#personalisationoptions" class="extras">
									<img src="<%=website.getImagePath("hand-writing.gif")%>" alt="" class="noBorder" />
									<%=website.getText("personalisationOptions","Personalisation")%>
								   </a>
								</div>
							<% } %>	
						<% } else { %>
	   						<% if (website.isOfferWritingService()) { %>
								<div class="productservicelink">
								   <a href="#giftwrapoptions" onclick='javascript: document.getElementById("div_giftwrapoptions").style.display = "";'>
									<img src="<%=website.getImagePath("hand-writing.gif")%>" alt="" class="noBorder" />
									<%=website.getText("handwritecard","Handwrite Card")%>
								   </a>
								</div>
							<% } %>
						<% } %>
	
						<div class="productservicelink">
							<a href="#tellafriend" onclick='javascript: document.getElementById("div_tellafriend").style.display = "";document.tellafriendform.tellyourname.focus();'>
								<img src="<%=website.getImagePath("tell-a-friend.gif")%>" alt=""	class="noBorder" />
								<%=website.getText("tellafriend","Tell a friend")%>
							</a>
						</div>

						<div class="productservicelink">
							<script type="text/javascript">addthis_pub  = 'intellig';</script><a href="http://www.addthis.com/bookmark.php" onmouseover="return addthis_open(this, '', '[URL]', '[TITLE]')" onmouseout="addthis_close()" onclick="return addthis_sendto()"> <img src="http://s9.addthis.com/button0-share.gif" width="83" height="16" border="0" alt="" /></a><script type="text/javascript" src="http://s7.addthis.com/js/152/addthis_widget.js"></script>
						</div>
					</div>
				<% } else { %>	
					<div id="productserviceslinks">
						<div class="productservicelink">
							<a href="#tellafriend" onclick='javascript: document.getElementById("div_tellafriend").style.display = "";document.tellafriendform.tellyourname.focus();'>
								<img src="<%=website.getImagePath("tell-a-friend.gif")%>" alt="" class="noBorder" />
								<%=website.getText("tellafriend","Tell a friend")%>
							</a>
						</div>
					</div>
				<% } %>
				<% if (pageModel.getMessageTypeDomainId() == TransactionLine.MESSAGE_TYPE_LINE_NOTE) { 
					String personalShoppingMessage = pageModel.getGiftwrapOrCardWrittenMessage();
					if (!(""+personalShoppingMessage).startsWith("FORM PERSONALISATION:")) {
				%>
						<span id="personalshoppermessage">
							<img align="left" src="<%=website.getImagePath("psshopper.png")%>" alt="Personal Shopping Note" /> 
							<%=HTMLHelper.applyHTML(personalShoppingMessage)%>
						</span>
				<%  	}
				  } %>	
				<input type="hidden" name='vacid' value='<%=pageModel.getVendorArticleClsfnId()%>' /> 
				<input type="hidden" name='tlid' value='<%=pageModel.getParamTransLineId()%>' /> 
				<input type="hidden" name='sqty' value='<%=pageModel.isArticleSet()?pageModel.getQuantity():userSession.getArticleDetail().getQuantity(pageModel.getParentVendorArticleId(), pageModel.getVendorArticleId())%>' />
				<input type="hidden" name='aibqty' value='<%=userSession.getShoppingBasket().getQuantityInBasket(pageModel.getParentVendorArticleId(), pageModel.getVendorArticleId())%>' />
				<input type="hidden" name=<%="'"+UserSession.URL_PARAM_NO_TRAIL_PHRASE+"'"%> value='1' /> 
				<input type="hidden" name='set' value='<%=pageModel.isArticleSet()?1:0%>' /> 
				<input type="hidden" name='unlimstock' value='<%=pageModel.isAllowOutOfStockOrdering()?1:0%>' />
			</form>
		</div>
	   </div>
	   <div id='component_stockdetail_tabbedinfo_ajax'>
			<jsp:include page="template/components/stockdetailtabarea.jsp" />
	   </div>
	   <div id="component_stockdetail_linkedproducts">
			<jsp:include page="template/components/stockdetaillinkedproducts.jsp" />
	   </div>
	   <% if (website.isShowCustomersAlsoBoughtList()) { %>
		<div id="component_stockdetail_alsobought">
			<jsp:include page="template/components/stockdetailalsobought.jsp" />
		</div>
	   <% } %>

	<% } %>
	<div id="component_stockdetail_services">	
		<div id="servicetellafriend">
			<%@include file="stockdetailtellafriend.jsp"%>
		</div>
		<form name="extrasform" method="post" action="<%=request.getRequestURL().toString()%>?rpid=<%=pageModel.getRecParentVendorArticleId()%>&amp;rid=<%=pageModel.getRecVendorArticleId()%>" >   <% //nm1 %>
			<div id="servicegiftwrap">
				<%@include file="stockdetailgiftwrap.jsp"%>
			</div>
			<% if (website.isShowPersonalisationForms() && pageModel.getPersonalisationFormName() != null) { %>
				<div id="servicepersonalisation">
					<a name="personalisationoptions">
						<div id="personalisationheader">
							<%=website.getText("personalisationoptions","Personalisation Options")%>
						</div>
					</a>
					<span id="personalisationbody">
					<% 
						String personalisationPageName = "forms/"+pageModel.getPersonalisationFormName();
						if (new File(website.getWebSitePath(),personalisationPageName+".html").exists()) {
							try {
								out.write(pageView.readPersonalisationFormAndApplyDefaultValues(new File(website.getWebSitePath(),personalisationPageName+".html")).toString());
							} catch (Exception ee) {
								website.writeToLog(ee);
								out.write("There is a problem with personalisation form for this product called "+personalisationPageName+".html"+". Reason: "+ee.getMessage());
							}
						}  
					%>
					</span>
					   <div id="personalisationactions">
						<% if (pageModel.getParamTransLineId() > 0) { %>
							<input type="submit" name="updbasket" value="<%=website.getUpdateBasketText()+" with Personalisation"+(pageModel.getQtyInBasket()==1?"":(" ("+pageModel.getQtyInBasket()+" item"+(pageModel.getQtyInBasket()==1?"":"s")+")"))%>" class="buttonupdatebasketpersonalisation" />
						<% }

                         		if (pageModel.getParamTransLineId() == 0) {
						  	if (pageModel.getOrderType() != VendorArticle.ORDER_TYPE_ENQUIRIES_ONLY && pageModel.getOrderType() != VendorArticle.ORDER_TYPE_ENQUIRIES_ONLY_HIDE_PRICE && pageModel.getUnitPrice() > 0) { %>
								<input type="submit" name="updbasket" value="<%=website.getAddToBasketText()+" with Personalisation"%>" class="buttonaddtobasketpersonalisation" />
						  	<% } 
                         		}
                     			%>
					   </div>

				</div>
			<% } %>
			<input type="hidden" name="id" value="<%=pageModel.getVendorArticleId()%>" /> 
			<input type="hidden" name="pid" value="<%=pageModel.getParentVendorArticleId()%>" /> 
			<input type="hidden" name="vacid" value="<%=pageModel.getVendorArticleClsfnId()%>" /> 
			<input type="hidden" name="qty" value="1" /> 
			<input type="hidden" name="price" value="<%=pageModel.getUnitPrice()%>" />
			<input type="hidden" name="tlid" value="<%=pageModel.getParamTransLineId()%>" /> 
			<input type="hidden" name="sqty" value="<%=pageModel.isArticleSet()?pageModel.getQuantity():userSession.getArticleDetail().getQuantity(pageModel.getParentVendorArticleId(), pageModel.getVendorArticleId())%>" />
			<input type="hidden" name="aibqty" value="<%=userSession.getShoppingBasket().getQuantityInBasket(pageModel.getParentVendorArticleId(), pageModel.getVendorArticleId())%>" />
			<input type="hidden" name=<%="\""+UserSession.URL_PARAM_NO_TRAIL_PHRASE+"\""%> value="1" /> 
			<input type="hidden" name="set" value="<%=pageModel.isArticleSet()?1:0%>" /> 
			<input type="hidden" name="unlimstock" value="<%=pageModel.isAllowOutOfStockOrdering()?1:0%>" />
			<!-- /form close was here -->
		</form>
	</div>
	<div id="pagenavbottom">
		<div id="stockdetailpagenavbottombuttons">
			<span class="buttonbacktoshop">
				<a href="<%=userSession.getLastIndexURL()%>"><img src="<%=website.getImagePath("back-to-shop.gif")%>" alt="" class="noBorder" /></a>
			</span>
			<% if (userSession.hasActiveGiftList()) { %>
				<span class="buttonbacktogiftlist">
					<a href="viewList.jsp?listcode=<%=userSession.getGiftListCode()%>"><img	src="<%=website.getImagePath("back-to-giftlist.gif")%>" alt="" class="noBorder" /></a>
				</span>
			<% } %>
			<% if (pageModel.getPersonalShopperTransactionId() > 0) { %>
				<span class="buttonbacktoshoppinglist">
					<a href="viewList.jsp?id=<%=pageModel.getPersonalShopperTransactionId()%>"><img src="<%=website.getImagePath("btnleft.gif")%>" alt="" class="noBorder" /></a>
				</span>
			<% } %>
			<span class="buttonviewbasket">
				<a href="basket.jsp"><img src="<%=website.getImagePath("view-basket.gif")%>" alt="" class="noBorder" /></a>
			</span>
		</div>
	</div>
</div>
<script type='text/javascript'>
	var basketValue =<%=userSession.getShoppingBasket().getTotalAmount()%>;
	function ValidateQty() {

        if ( document.qtyform.qty.value == "" || isNaN(document.qtyform.qty.value)) {
            alert ( "Please enter a Quantity" );
            document.qtyform.qty.focus();
            return false;
        } else { 
            var qty = parseInt(document.qtyform.qty.value, 10);
            var stockQty = parseInt(document.qtyform.sqty.value,10)
            var alreadyInBasketQty = parseInt(document.qtyform.aibqty.value,10)
			var stockPrice = parseInt(document.qtyform.price.value, 10);
		if ((basketValue + (stockPrice * qty)) > 10000) {
			alert("Order value exceeds maximum order limit. Please contact us directly to place this order.");
			return false;
		}

            if (qty > stockQty) {
                alert("There is not enough quantity in stock to fulfil your request ("+stockQty+" in stock)");
                document.qtyform.qty.focus();
                return false;
            }

            if ((alreadyInBasketQty + qty) > stockQty) {
                alert("There is not enough quantity in stock to fulfil your request ("+stockQty+" in stock)");
                document.qtyform.qty.focus();
                return false;
            }
        }
        return true;
    }
</script>
<!-- end of components/stockdetail.html -->