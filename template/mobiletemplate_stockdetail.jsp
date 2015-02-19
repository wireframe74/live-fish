<div id="mob_detail">
<% if (pageModel.getArticleType() == Article.ARTICLE_TYPE_STANDARD_ARTICLE || pageModel.getArticleType() == Article.ARTICLE_TYPE_CLASSIFICATION_ARTICLE_SET || pageModel.getArticleType() == Article.ARTICLE_TYPE_OPTIONS) { %>

	<h1> <%=pageModel.getShortDescription()%> </h1>
	<div id="productcode"><%=website.getText("detailproductcode","Code:")%> <%=pageModel.getVendorArticleCode()%></div>
		<div class="productimageholder" id="imagescontainer">
			<%@include file="/template/components/stockdetailimages_mobile.jsp"%>
		</div>

		<div class="detailInfo" >
			<div class="productdetailwrap">


			<%=pageView.getPriceHTML("","smalltext")%>


		<% if (!pageModel.isHasOptions() || pageModel.isOption()) { %>
			<div id="stockindicatorAjax" >
				<jsp:include page="/template/components/stockdetailstockindicator.jsp" /> 
			</div>
		<% } %>
		<% if (false && co.simplypos.model.website.tracking.Feefo.isFeefoEnabled(userSession)) { 
			String productCode = ((co.simplypos.model.website.tracking.Feefo)userSession.getTrackingController().feefo).getBestProductCode(pageModel.getVendorArticleId());
			ArticleDetail articleDetail = userSession.getArticleDetail();
			if (request.getParameter("imageId") != null) articleDetail.setCurrentImage(Integer.parseInt(request.getParameter("imageId")));
			ArticleDetailImage currentImage = articleDetail.getCurrentImage(); %>

				<a href="http://www.feefo.com/feefo/viewvendor.jsp?logon=<%=((co.simplypos.model.website.tracking.Feefo)userSession.getTrackingController().feefo).feefoLogin%>&vendorref=<%=productCode%>&mode=Product&name=<%=pageModel.getShortDescription()%>&description=<%=pageModel.getFullDescription()%>&imageurl=<%=website.getWebSiteURL().substring(0,website.getWebSiteURL().lastIndexOf('/')+1)+currentImage.getPrimaryImageName()%>" onclick="window.open(this.href,'Feefo','width=800,height=600,scrollbars,resizable');
					return false;"><img src="http://www.feefo.com/feefo/feefologo.jsp?logon=<%=((co.simplypos.model.website.tracking.Feefo)userSession.getTrackingController().feefo).feefoLogin%>&vendorref=<%=productCode%>&template=ms2.gif" tst="N166x56WP.jpg" border="0" alt="Independent Product Reviews"
					title="See independent reviews about this product">
				</a>


		<% } %>

			<jsp:include page="/template/components/stockdetailstockenquiryemail.jsp"> 
				<jsp:param name="stockEnquiryString" value="<%=stockEnquiryString%>" />
			</jsp:include>
		<div class="qtyaddtobasket">
			<jsp:include page="/template/components/stockdetailoptionsqtyaddtobasket_mobile.jsp" />
		</div>
		</div>


			<jsp:include page="/template/components/stockdetailtabarea.jsp" />

		</div>
		<div class="cleardiv"> </div>
			<jsp:include page="/template/components/stockdetaillinkedproducts.jsp" />
	<% } else { %>
		<%@include file="/template/components/stockdetailimages.jsp"%>
	<% } %>

		<%@include file="/template/components/stockdetailotherservices.jsp"%>
</div>