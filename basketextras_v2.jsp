<jsp:useBean id="website"  scope="application" class="co.simplypos.model.website.WebSite" />
<jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession" />
<%@page import="java.math.BigDecimal" %>
<%@page import="java.util.ArrayList" %>

<%
ArrayList<ArrayList> deliveryOptions = userSession.getShoppingBasket().getAdditionalDeliveryOptions();
if (deliveryOptions != null && deliveryOptions.size() > 0) {
	java.text.DecimalFormat df = new java.text.DecimalFormat("#0.00");
   %><div class="basketExtrasHold"><%
	for (int i=0;i<deliveryOptions.size();i++) {
		ArrayList<Object> row = deliveryOptions.get(i);
		int vendorArticleId = ((Integer)row.get(0)).intValue();
		int parentVendorArticleId = ((Integer)row.get(4)).intValue();
		int vacId = ((Integer)row.get(5)).intValue();
		String price = "0.00";
		String priceNonFormatted = "0.00";
		String productName = ""+row.get(1);
		String productFullText = ""+(row.get(3)!=null?row.get(3):"");
		try {
			double price1 = ((Number)row.get(2)).doubleValue();
			priceNonFormatted = df.format(price1);
			if (price1 >= 0) price = "+£"+priceNonFormatted; else price = "- £"+priceNonFormatted;
		} catch (Exception nfe) { price = "0.00"; }
		%>
		
		<form name="qtyformdelopt<%=i%>" method="post" action='detail.jsp?rpid=0&amp;rid=0'>
			<input type="hidden" name="action" value="1" />
			<input type="hidden" name="id" value="<%=vendorArticleId%>" />
			<input type="hidden" name="pid" value="<%=parentVendorArticleId%>" />
			<input type="hidden" name="qty" value="1" />
			<input type="hidden" name="price" value="<%=priceNonFormatted%>" /> 
			<input type="hidden" name='vacid' value='<%=vacId%>' /> 
			<input type="hidden" name='tlid' value='0' /> 
			<input type="hidden" name='sqty' value='0.0' />
			<input type="hidden" name='aibqty' value='0' />
			<input type="hidden" name='xtrail' value='1' /> 
			<input type="hidden" name='set' value='0' /> 
			<input type="hidden" name='unlimstock' value='1' />
			<input type="hidden" name="updbasket" value='1'/>
			<div class="basketExtrasHolder">
				<div class="basketExtrasName"><%=productName%></div>
				<div class="basketExtrasPrice"><%=price%></div>
				<div class="basketExtrasText"><%=productFullText!=null?productFullText:""%></div>
				<div class="basketExtrasBtn"><input type="submit" value="<%=website.getText("basketextrasbutton","Add to basket")%>" class="deliveryAddToBasket" /></div>
			</div>
		</form>
	<%}%>
	</div>
<%}%>
