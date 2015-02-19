<div id="freedelivery">
	<ul>
	<% float totalPriceMinusAdditionalDelivery = totPrice - userSession.getShoppingBasket().getAdditionalDeliveryOptionsTotal(); 
	if (totalPriceMinusAdditionalDelivery < website.getCarriagePaidOrderAmount()) { %>
       	<li class="freedeliverytogotext">
			<%=userSession.formatPrice(website.getCarriagePaidOrderAmount() - totalPriceMinusAdditionalDelivery )%> to go until Free Delivery
		</li>
	<% } else { %>
		<li class="freedeliveryfreetext">
		 Free delivery on this order! 
		</li>
	<% } %>
	<li class="freedeliveryprogressbar">
		<div id="basketprogressbar"></div>
	</li>
	<li class="freedeliveryprice">
		Australian delivery is <%=website.getCarriagePaidOrderAmount()<=0.01?"FREE!":"free on orders over "+userSession.formatPrice(website.getCarriagePaidOrderAmount())%>
	</li>
	<script> generateBasketProgressBar(<%=(totalPriceMinusAdditionalDelivery / website.getCarriagePaidOrderAmount()) * 100 %>)</script>
	</ul>
</div>
