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

<%DefaultTableModel consoleTableModel = userSession.getShoppingBasket().getConsoleTableModel();
WebDiscountManager discountManager = (WebDiscountManager)userSession.getShoppingBasket().getDiscountManager();
ArticleDetail articleDetail = userSession.getArticleDetail();%>


<div id="basketcontenttable" class="listtable">
	
	<%float totPrice = 0;
	for (int i=0;i<consoleTableModel.getRowCount();i++) {
		if (!discountManager.isDiscountRow(i)) {%>
		
			<ul class="basketline listtableline">
				
				<%int transLineId = userSession.getShoppingBasket().getIntValueAt(i, TransactionManager.COLUMN_TRANSACTION_LINE_ID);
				int vendorArticleId = userSession.getShoppingBasket().getIntValueAt(i, TransactionManager.COLUMN_VENDOR_ARTICLE_ID);
				int vendorArticleClsfnId = userSession.getShoppingBasket().getIntValueAt(i, TransactionManager.COLUMN_VENDOR_ARTICLE_CLSFN_ID);
				int quantity = userSession.getShoppingBasket().getIntValueAt(i, TransactionManager.COLUMN_ITEMS);
				float itemPrice = userSession.getShoppingBasket().getFloatValueAt(i, TransactionManager.COLUMN_UNIT_PRICE);
				float qtyPrice = userSession.getShoppingBasket().getFloatValueAt(i, TransactionManager.COLUMN_QTY_PRICE);
				float salePrice = discountManager.getQtyPriceIncludingDiscountsSoFar(i, userSession.getExchangeRate());
				int wrappingTypeDomainId = userSession.getShoppingBasket().getIntValueAt(i, TransactionManager.COLUMN_WRAPPING_TYPE_DOMAIN_ID);
				float wrappingPrice = userSession.getShoppingBasket().getFloatValueAt(i, TransactionManager.COLUMN_WRAPPING_PRICE);
				int messageTypeDomainId = userSession.getShoppingBasket().getIntValueAt(i, TransactionManager.COLUMN_MESSAGE_TYPE_DOMAIN_ID);
				String message = userSession.getShoppingBasket().getStringValueAt(i, TransactionManager.COLUMN_MESSAGE_TEXT);
				float messagePrice = userSession.getShoppingBasket().getFloatValueAt(i, TransactionManager.COLUMN_MESSAGE_PRICE);
				wrappingPrice = new BigDecimal(wrappingPrice*userSession.getExchangeRate()).setScale(2, BigDecimal.ROUND_HALF_EVEN).floatValue();
				messagePrice = new BigDecimal(messagePrice*userSession.getExchangeRate()).setScale(2, BigDecimal.ROUND_HALF_EVEN).floatValue();
				float linePrice = salePrice + (quantity * wrappingPrice) + (quantity * messagePrice);
				totPrice += linePrice;
				Hashtable row = articleDetail.getRow(vendorArticleClsfnId);
				String shortDescription = (String)row.get(ArticleDetail.SHORT_DESCRIPTION);
				String imageName = website.getImagePath("ImageBasketDefaultArticleThumb.jpg");
				String imageWidth = String.valueOf(website.getBasketThumbSize()) + "px";
				int blobStorageId = 0;
				
				try{
					blobStorageId = articleDetail.getPrimaryImage().getBlobStorageId();
				}catch(Exception e){}
				
				long blobStorageCreatedOn = 0;
				
				try{
					blobStorageCreatedOn = articleDetail.getPrimaryImage().getBlobStorageCreatedOn();
				}catch(Exception e){}
				
				if (blobStorageId > 0) {
					imageName = website.getArticleMenu().getCachedImageName(shortDescription, blobStorageId, website.getBasketThumbSize(), blobStorageCreatedOn);
					File cachedImage = new File(website.getWebSitePath()+website.getArticleMenu().getCachedImageName(shortDescription,blobStorageId,website.getBasketThumbSize(),blobStorageCreatedOn));
					if (!cachedImage.exists()) {
					
						try{
							RenderImageServlet.buildImage(userSession, vendorArticleId, shortDescription, blobStorageId, website.getBasketThumbSize(), true, request, false, false, blobStorageCreatedOn);
						}catch(Exception e){
							imageName = website.getImagePath("ImageBasketDefaultArticleThumb.jpg");
							imageWidth = String.valueOf(website.getBasketThumbSize()) + "px";
						}
						
					}
				}
				int parentVendorArticleId = 0;
				try {
					parentVendorArticleId = Integer.parseInt(""+row.get(ArticleDetail.PARENT_VENDOR_ARTICLE_ID));
				}catch(Exception a){}%>
				
				<li class="basketitem">
					<a class="smallertext"  href='<%=ArticleMenu.getPageName(website, shortDescription, true)%>?pid=<%=parentVendorArticleId%>&amp;id=<%=vendorArticleId%>&amp;tlid=<%=transLineId%>'>
						<img src="<%=imageName %>" alt="<%=shortDescription %>" title="<%=shortDescription %>" <%=imageWidth.equals(imageWidth) ? "" : "width=\"" + imageWidth + "\""%>/>
					</a>
				</li>
				
				<li class="basketdescription">
					<a class="smallertext"  href='<%=ArticleMenu.getPageName(website, shortDescription, true)%>?pid=<%=parentVendorArticleId%>&amp;id=<%=vendorArticleId%>&amp;tlid=<%=transLineId%>'>
						<%=shortDescription%>
					</a>
				</li>
				
				<%if (userSession.getWebsiteAccessDomainId() > Customer.WEB_ACCESS_TYPE_NO_PRICES) { %>
				<li class="basketprice">
					Price: <span class="mbAlign"><%=userSession.convertAndFormatPrice(itemPrice)%></span>
				</li>	
				<% } %>

				<li class="basketquantity">
					<div class="basketQty">Quantity: <span class="mbAlign"><%=ArticleDetail.formatQuantity(quantity,false)%></span></div>
				</li>

				<% if (userSession.getWebsiteAccessDomainId() > Customer.WEB_ACCESS_TYPE_NO_PRICES) {  %> 
					<li class="baskettotprice">
						Total: <span class="mbAlign"><%=userSession.formatPrice(linePrice)%></span>
					</li>
				<% } %>
			
			</ul>
			
		<% }
	} %>
	
	<%float discountAmount = 0;
	int discountPercentage =  userSession.getShoppingBasket().getDiscountPercentage();
	if (discountPercentage > 0) {
		discountAmount = new BigDecimal(totPrice).setScale(2, BigDecimal.ROUND_HALF_EVEN).multiply(new BigDecimal(discountPercentage).setScale(2, BigDecimal.ROUND_HALF_EVEN).divide(new BigDecimal(100))).floatValue();
		totPrice = new BigDecimal(totPrice).setScale(2, BigDecimal.ROUND_HALF_EVEN).subtract(new BigDecimal(discountAmount).setScale(2, BigDecimal.ROUND_HALF_EVEN)).floatValue();
	}
	float voucherRedeemAmount =  userSession.getShoppingBasket().getVouchersRedeemedTotal();
	if (voucherRedeemAmount > 0) {
		voucherRedeemAmount = new BigDecimal(voucherRedeemAmount).setScale(2, BigDecimal.ROUND_HALF_EVEN).multiply(new BigDecimal(userSession.getExchangeRate()).setScale(2, BigDecimal.ROUND_HALF_EVEN)).floatValue();
		totPrice = new BigDecimal(totPrice).setScale(2, BigDecimal.ROUND_HALF_EVEN).subtract(new BigDecimal(voucherRedeemAmount).setScale(2, BigDecimal.ROUND_HALF_EVEN)).floatValue();
	}%>
	
</div>

<div id="basketsubtotal">
	<ul id="subtotaloptions">
		<% if (userSession.getShoppingBasket().getDiscountAmount() > 0) { %>
			<li>
				<span class="subtotaltitle"><%=userSession.getShoppingBasket().getDiscountPercentage()%>% Discount:</span>
				<span class="subtotalamount mbAlign"><%=userSession.formatPrice(discountAmount*-1)%></span>
			</li>
		<% } if (voucherRedeemAmount > 0) { %>
			<li>
				<span class="subtotaltitle">Voucher:</span>
				<span class="subtotalamount mbAlign"><%=userSession.formatPrice(voucherRedeemAmount * -1)%></span>
			</li>
		<% } if (userSession.getWebsiteAccessDomainId() > Customer.WEB_ACCESS_TYPE_NO_PRICES) { %>
			<li>
				<span class="subtotaltitle">Shopping Basket Total:</span>
				<span class="subtotalamount mbAlign"><%=userSession.formatPrice(totPrice)%></span>
			</li>
		<% } %>
	</ul>
</div>

<div class="mbBottom">
	<a href="basket.jsp"><%=website.getText("basketbasketbutton","Full Basket and Checkout")%></a>
</div>