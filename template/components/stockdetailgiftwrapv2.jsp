<!-- start of components/stockdetailgiftwrap.jsp -->
<div id='div_giftwrapoptions' style='display:none;' class="stockcontainer componentBorder">

	<%String pageTitleGiftwrap = "";
	
	if (pageModel.getArticleSubType() == Article.ARTICLE_SUB_TYPE_STANDARD_GIFT) {
		pageTitleGiftwrap = website.getText("giftwrapping",website.getGiftwrapText());
	} else {
		pageTitleGiftwrap = website.getText("handwritecard",website.getHandwriteText());
	}%>
	
	<% if (pageModel.getArticleSubType() == Article.ARTICLE_SUB_TYPE_STANDARD_GIFT) { %>
		
		<div class="giftwrapHold extraHold" style="display: none;">
		
			<h3><%=pageTitleGiftwrap%></h3>
		
			<p>	
				Would you like us to wrap this gift?<br/>
				<select name="wrapgift">
					<%=pageModel.getWrappingOptionsList()%>
				</select>
			</p>
			
		</div>
	
	<%}
	
	if (!website.isShowPersonalisationForms() && pageModel.getPersonalisationFormName() == null && (pageModel.getArticleSubType() == Article.ARTICLE_SUB_TYPE_STANDARD_CARD || pageModel.getArticleSubType() == Article.ARTICLE_SUB_TYPE_STANDARD_GIFT)) { %>
	
		<div class="handwritingHold extraHold" style="display: none;">
		
			<h3>Handwritten card</h3>
			
			<p>
			
				Would you like a gift tag on this gift?<br/>

				<input type="radio" name="gifttag" value="<%=TransactionLine.MESSAGE_TYPE_NO_MESSAGE%>" onclick="$('#div_message').css({'display':'none'});" <%=pageModel.getMessageTypeDomainId()==TransactionLine.MESSAGE_TYPE_NO_MESSAGE||pageModel.getMessageTypeDomainId()==0?"checked=\"checked\"":""%> />
				No
				
				<input type="radio" name="gifttag" value="<%=TransactionLine.MESSAGE_TYPE_GIFT_TAG%>" onclick="$('#div_message').css({'display':'block'});" <%=pageModel.getMessageTypeDomainId()==TransactionLine.MESSAGE_TYPE_NO_MESSAGE||pageModel.getMessageTypeDomainId()==0?"":"checked=\"checked\""%> /> 
				<%=pageModel.getGiftwrapOrCardYesTagText()%>
				
			</p>
			
			<div id="div_message" style="display:none;">
			
				Gift tag message:
				
				<textarea name="gifttagmessage" rows="5" cols="10"><%=pageModel.getGiftwrapOrCardWrittenMessage()%></textarea>

				<p><small>* We reserve the right to exclude any part of the message that is deemed to be offensive</small></p>
			
			</div>
		</div>
		
	<% } %>
	
	
	<% if (pageModel.getParamTransLineId() > 0) { %>
		
		<a name="<%=website.getAddToBasketText()%>" class="buttonaddtobasket" href="javascript: document.extrasform.submit()" >
			<input type="hidden"  name="<%=website.getUpdateBasketText()+(pageModel.getQtyInBasket()==1?"":(" ("+pageModel.getQtyInBasket()+" item"+(pageModel.getQtyInBasket()==1?"":"s")+")"))%>" />
			<%=website.getText("detailUpdatebasket","<span>Update basket</span>")%>
		</a>

	<% } else if (pageModel.getParamTransLineId() == 0 && pageModel.getOrderType() != VendorArticle.ORDER_TYPE_ENQUIRIES_ONLY && pageModel.getOrderType() != VendorArticle.ORDER_TYPE_ENQUIRIES_ONLY_HIDE_PRICE) { %>									
		
		<a name="<%=website.getAddToBasketText()%>" class="buttonaddtobasket" href="javascript: document.extrasform.submit()" >
			<input type="hidden" name="<%=website.getAddToBasketText()%>"  />
			<%=website.getText("detailAddtobasket","<span>Add to basket</span>")%>
		</a>
		
	<% } %>
	<input type="hidden" name="tempfield" id="tempfield"/>
	
</div>

<script type="text/javascript">
	function toggleGiftwrap(){
		$(".giftwrapHold").toggle();
		toggleExtras();
	}
	function toggleHandwrite(){
		$(".handwritingHold").toggle();
		toggleExtras();
	}
	function toggleExtras(){
		if( $(".handwritingHold").css("display") == "none" && $(".giftwrapHold").css("display") == "none" ){
			$("#div_giftwrapoptions").hide();
		}else{
			$("#div_giftwrapoptions").show();
		}
	}
</script>

<!-- end of components/stockdetailgiftwrap.jsp -->
