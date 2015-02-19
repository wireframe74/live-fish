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
	<div class="pagetopnav">
		<ul class="crumb blocklist">
			<%=pageView.getTrailHTML(pageModel.getShortDescription(), request, true)%>
		</ul>
		<ul class="navPage blocklistright">
			<li class="firstbutton">
				<a href="basket.jsp"> <%=website.getText("detailbasketbutton","View Basket")%> </a>
			</li>
			<% if (userSession.hasActiveGiftList()) { %>
				<li>
					<a href="viewList.jsp?listcode=<%=userSession.getGiftListCode()%>"> <%=website.getText("detailbacktogiftlistbutton","Back to Giftlist")%> </a>
				</li>
			<% } %>
			<% if (pageModel.getPersonalShopperTransactionId() > 0) { %>
				<li>
					<a href="viewList.jsp?id=<%=pageModel.getPersonalShopperTransactionId()%>"> <%=website.getText("detailbacktoshoppinglistbutton","Back to Shopping List")%> </a>
				</li>
			<% } %>

			<li>
					<a href="<%=userSession.getBackToShopURL()%>"> <%=website.getText("detailbacktoshopbutton","Back to Shop")%> </a>
			</li>
		</ul>
	</div>

	<div id="pagevalidation_ajax">
		<jsp:include page="/template/components/stockdetailvalidation.jsp" /> 		
	</div>	

	<%@include file="/template/mobiletemplate_stockdetail.jsp"%>

	<div class="pagebottomnav">
		<ul class="crumb blocklist">
			<%=pageView.getTrailHTML(pageModel.getShortDescription(), request, true)%>
		</ul>
		<ul class="navPage blocklistright">
			<li class="firstbutton">
				<a href="basket.jsp"> <%=website.getText("detailbasketbutton","View Basket")%> </a>
			</li>
			<% if (userSession.hasActiveGiftList()) { %>
				<li>
					<a href="viewList.jsp?listcode=<%=userSession.getGiftListCode()%>"> <%=website.getText("detailbacktogiftlistbutton","Back to Giftlist")%> </a>
				</li>
			<% } %>
			<% if (pageModel.getPersonalShopperTransactionId() > 0) { %>
				<li>
					<a href="viewList.jsp?id=<%=pageModel.getPersonalShopperTransactionId()%>"> <%=website.getText("detailbacktoshoppinglistbutton","Back to Shopping List")%> </a>
				</li>
			<% } %>

			<li>
					<a href="<%=userSession.getBackToShopURL()%>"> <%=website.getText("detailbacktoshopbutton","Back to Shop")%> </a>
			</li>
		</ul>
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