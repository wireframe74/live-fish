<% if (pageModel.getArticleType() == Article.ARTICLE_TYPE_STANDARD_ARTICLE || pageModel.getArticleType() == Article.ARTICLE_TYPE_CLASSIFICATION_ARTICLE_SET || pageModel.getArticleType() == Article.ARTICLE_TYPE_OPTIONS) { %>
	
	<div class="productimageholder" id="imagescontainer">
		<%@include file="/template/components/stockdetailimages.jsp"%>
	</div>
	
	
	<div class="prodPgRight" >
		<div id="magicZoomPos"></div>
	
		<div class="detailInfo" itemscope itemtype="http://schema.org/Product">
		
			<div class="addthisHold">
				<!-- AddThis Button BEGIN -->
				<div class="addthis_toolbox addthis_default_style addthis_16x16_style">
					<a class="addthis_button_facebook"></a><!-- 
					 --><a class="addthis_button_twitter"></a><!-- 
					 --><a class="addthis_button_google_plusone_share"></a><!-- 
					 --><a class="addthis_button_email"></a>
				</div>
				<script type="text/javascript" src="//s7.addthis.com/js/300/addthis_widget.js#pubid=xa-51ee758001990002"></script>
				<!-- AddThis Button END -->
				
				<div id="productcode" itemprop="productID"><%=website.getText("detailproductcode","Code:")%> <%=pageModel.getVendorArticleCode()%></div>
				
			</div>
			
			<h1 itemprop="name"><%=pageModel.getShortDescription()%></h1>
			
			<div class="productdetailwrap">

				<%=pageView.getBrandLogoHtml()%>

				<%=pageView.getPriceHTML("","smalltext")%>

				<% if (co.simplypos.model.website.tracking.Feefo.isFeefoEnabled(userSession)) {
				
					ArticleDetail articleDetail = userSession.getArticleDetail();
					
					if (request.getParameter("imageId") != null) articleDetail.setCurrentImage(Integer.parseInt(request.getParameter("imageId")));
					
					ArticleDetailImage currentImage = articleDetail.getCurrentImage(); %>

						<% 
						String feefoOut = "";
						try {
							feefoOut = ((co.simplypos.model.website.tracking.Feefo)userSession.getTrackingController().feefo).getFeefoRatingHTML(pageModel.getVendorArticleId(), website.getWebSiteURL().substring(0,website.getWebSiteURL().lastIndexOf('/')+1)+currentImage.getPrimaryImageName(), pageModel.getShortDescription(), pageModel.getShortDescription());
						} catch (Exception ee223) {
							feefoOut = "";  // won't work with bundles
						}
						out.write(feefoOut);
						%>

				<% } %>
				
				<% if (false && co.simplypos.model.website.tracking.Feefo.isFeefoEnabled(userSession)) {
					String productCode = ((co.simplypos.model.website.tracking.Feefo)userSession.getTrackingController().feefo).getBestProductCode(pageModel.getVendorArticleId());
					ArticleDetail articleDetail = userSession.getArticleDetail();
					if (request.getParameter("imageId") != null) articleDetail.setCurrentImage(Integer.parseInt(request.getParameter("imageId")));
					ArticleDetailImage currentImage = articleDetail.getCurrentImage(); %>

						<a href="http://www.feefo.com/feefo/viewvendor.jsp?logon=<%=((co.simplypos.model.website.tracking.Feefo)userSession.getTrackingController().feefo).feefoLogin%>&vendorref=<%=productCode%>&mode=Product&name=<%=pageModel.getShortDescription()%>&description=<%=pageModel.getFullDescription()%>&imageurl=<%=website.getWebSiteURL().substring(0,website.getWebSiteURL().lastIndexOf("/")+1)+currentImage.getPrimaryImageName()%>" onclick="window.open(this.href,'Feefo','width=800,height=600,scrollbars,resizable');return false;"><img src="http://www.feefo.com/feefo/feefologo.jsp?logon=<%=((co.simplypos.model.website.tracking.Feefo)userSession.getTrackingController().feefo).feefoLogin%>&vendorref=<%=productCode%>&template=ms2.gif" tst="N166x56WP.jpg" border="0" alt="Independent Product Reviews" title="See independent reviews about this product">
						</a>

				<% } %>

				
				<% if (!pageModel.isHasOptions() || pageModel.isOption()) { %>
					<div id="stockindicatorAjax" >
						<ul>
							<jsp:include page="/template/components/stockdetailstockindicator.jsp" /> 
						</ul>
					</div>
				<% } %>
				
				<div class="basketSpacer"></div>
				
				<jsp:include page="/template/components/stockdetailstockenquiryemail.jsp"> 
					<jsp:param name="stockEnquiryString" value="<%=stockEnquiryString%>" />
				</jsp:include>
				
				<div class="qtyaddtobasket">
					<jsp:include page="/template/components/stockdetailoptionsqtyaddtobasket.jsp" />
				</div>
				
				<%@include file="/template/components/stockdetailotherservices.jsp"%>
				
			</div>

		</div>
		

		<jsp:include page="/template/components/stockdetailtabarea.jsp" />
	
	</div>
	
	<jsp:include page="/template/components/stockdetaillinkedproducts.jsp" />

	<% if (website.isShowCustomersRecentlyViewedList()) { %>
		<div id="component_stockdetail_recentlyviewed">
			<jsp:include page="/template/components/stockdetailrecentlyviewed.jsp" />
		</div>
	<% } %>
	
	<script type="text/javascript">$(document).ready(function(){
		var e=$(".productprice").html().replace(/&nbsp;&nbsp;/g,"");
		$(".productprice").html(e);
		$("#mainZoomer").removeAttr("title");
		$(".productMain").removeAttr("title");
		if( $("#imagescontainer>a").length == 0 ){ $("#ajax_image_wrap").css({"borderBottom":"0","marginBottom":"0"}); }
		$(".tab_container").wrap("<div class='tabBorder'></div>");
		if($(".detailRRP").length>0){
			e=$(".detailRRP").html().replace("RRP:&nbsp;","");
			$(".detailRRP").html(e);
		}
	});</script>
	
<% } else { %>
	<%@include file="/template/components/stockdetailimages.jsp"%>
<% } %>

