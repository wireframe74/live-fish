<%@page import="co.simplypos.model.website.ArticleDetail" %>
<%@page import="co.simplypos.model.website.ArticleDetailImage" %>
<%@page import="co.simplypos.model.website.page.model.StockDetailPageModel " %>
<%@page import="co.simplypos.model.website.page.view.StockDetailPageView" %>
<%@page import="co.simplypos.model.website.ArticleDetailImage" %>
<%@page import="java.util.Iterator" %>
<%@page import="java.io.File" %>
<jsp:useBean id="website" scope="application" class="co.simplypos.model.website.WebSite"><%website.initialise(request.getRequestURL().toString(), application.getRealPath("/"), 170);%></jsp:useBean><jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession"><%userSession.initialise(website, request);%></jsp:useBean><%
try {
	StockDetailPageModel pageModel = (StockDetailPageModel) userSession.getWebController().getCurrentPageController().getPageModel();
	StockDetailPageView pageView = (StockDetailPageView) userSession.getWebController().getCurrentPageController().getPageView();
				
	if (userSession == null) {
		out.write("Session has expired, refresh the page.");
	} else {
		int type = StockDetailPageView.ARTICLE_LIST_TYPE_MAIN_PRODUCT_PAGE;
		int seq = (type*10000); 

		ArticleDetail articleDetail = userSession.getArticleDetail();
		if (request.getParameter("imageId") != null) articleDetail.setCurrentImage(Integer.parseInt(request.getParameter("imageId")));
		ArticleDetailImage currentImage = articleDetail.getCurrentImage(); 
		
		int maxImageHeight = 0;
		try {
			maxImageHeight = articleDetail.getMaxImageHeightRequiredForDiv();

		} catch (Exception eegh3) {
			eegh3.printStackTrace();
		}
		int currentImageHeight = 0;
		try {
			currentImageHeight = currentImage.getMaxDivHeightRequired();
		} catch (Exception eegh3) {}
	
		int padding = maxImageHeight - currentImageHeight;

		if (padding < 0) padding = 0;
	
		String dimenionStyleHTML = website.isProductPageFixedWidthInCSS()?"style=\"overflow:hidden;display:block;"+(maxImageHeight>0?"height:"+maxImageHeight+"px;min-height:"+maxImageHeight+"px;":"")+"\"":"style=\"height:"+website.getProductPageImageSize()+"px;width:"+website.getProductPageImageSize()+"px;\"";

		%>

			<%=pageView.getIndicatorImageHTML(pageModel)%>
			<div id="ajax_image_wrap">
				<div class="productimageholder" id="mainimagecontainer">
				<% if (currentImage != null) { %>
					<% if (currentImage.isZoomable()) { %>							
	
						<a href="<%=website.getWebSiteURL().substring(0,website.getWebSiteURL().lastIndexOf("/")+1)%>zoomifyURLDrivenWebPage.jsp?zoomifyImagePath=<%=website.getWebSiteURL().substring(0,website.getWebSiteURL().lastIndexOf("/")+1)%>images/_zoomconversioncomplete/<%=currentImage.getImageVendorArticleId()%>/&zoomifyX=500&zoomifyY=500&zoomifyZoom=50&zoomifyToolbar=1&zoomifyNavWin=1&zoomifyNavWidth=150&zoomifyNavHeight=150&zoomifyFadeInSpeed=1000"  onclick="return GB_showCenter('<%=currentImage.getImageShortDescription()%>', this.href, 500, 700)" class="smalltext">							
	
					<% } else if (articleDetail.getPrimaryImage().isZoomable()) {   // backward compatability for zoomable primary image with additional images (magic zoom not work)
						if (currentImage.getBlobStorageId() != 0) {   
			 		%>		
							<a href="<%=currentImage.getLargeImageName()%>" onclick="return GB_showImage('<%=currentImage.getImageShortDescription()%>', this.href)">				
			
					<% 	}
					   } else { 
						if (currentImage.getBlobStorageId() != 0) {
							boolean biggerImageAvailable = currentImage.isBiggerImageAvailable();

							String primaryImageNamePrimary 	= website.getWebSiteURL().substring(0,website.getWebSiteURL().lastIndexOf("/")+1) + currentImage.getPrimaryImageName();
							String largeImagePathPrimary 	= website.getWebSitePath() + "images/_zoomconversionqueue/"+currentImage.getImageVendorArticleId()+".jpg";
							String largeImageNamePrimary 	= website.getWebSiteURL().substring(0,website.getWebSiteURL().lastIndexOf("/")+1) + "images/_zoomconversionqueue/"+currentImage.getImageVendorArticleId()+".jpg";
							if (!new File(largeImagePathPrimary).exists()) {
								largeImagePathPrimary 	= website.getWebSitePath() + "images/_zoomMagnify/"+currentImage.getImageVendorArticleId()+".jpg";
								largeImageNamePrimary 	= website.getWebSiteURL().substring(0,website.getWebSiteURL().lastIndexOf("/")+1) + "images/_zoomMagnify/"+currentImage.getImageVendorArticleId()+".jpg";
								if (!new File(largeImagePathPrimary).exists()) {
									largeImageNamePrimary = currentImage.getLargeImageName(); //primaryImageNamePrimary;
								} else {
									biggerImageAvailable = true;
								}
							} else {
								biggerImageAvailable = true;
							}
			
							currentImage.setBiggerImageAvailable(biggerImageAvailable);

							if (website.isInPageZoom() && currentImage.isBiggerImageAvailable()) {
				 	%>		
							      <a href="javascript:imageZoom('<%=largeImageNamePrimary%>')" class="productMainLink"  title="<%=currentImage.getImageShortDescription()%>" >
								
					<%		} else { %>
							      <a href="javascript:imageZoom('<%=largeImageNamePrimary%>')" class="productMainLink"  title="<%=currentImage.getImageShortDescription()%>" alt="<%=currentImage.getImageShortDescription()%>" > 
								
					<%		} %>

					<%
						}
		 			  } 
					%>
					
						<img class="productMain" src="<%=website.getWebSiteURL().substring(0,website.getWebSiteURL().lastIndexOf("/")+1)%><%=currentImage.getPrimaryImageName()%>" alt="<%=currentImage.getImageShortDescription()%>" title="<%=currentImage.getImageShortDescription()%>" /> 
					
					<% if (currentImage.getBlobStorageId() != 0) { %> 
						</a>
					<% } %>
				<% } else { %>
					
					<img class="productMain" src="<%=website.getImagePath("ImageDefaultArticle.jpg")%>"  /> 
					
				<% } %>
				</div>

				

</div>
<%	}
} catch (Exception ee1) { 
	website.writeToLog(ee1);
//	website.writeToLog("Failed to get image for blobStorageId: "+( userSession !=null && userSession.getArticleDetail() != null && userSession.getArticleDetail().getCurrentImage() != null?""+userSession.getArticleDetail().getCurrentImage().getBlobStorageId():"unkown")+". Reason: "+ee1.getMessage()); 
} 	
%>
