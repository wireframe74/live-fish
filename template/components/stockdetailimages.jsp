<%			
	if (userSession == null) {
		out.write("Session has expired, refresh the page.");
	} else {
		if (userSession.getArticleDetail().countImages() > 1 && website.getAdditionalImageSize() > 0) { %>

				<jsp:include page="template/components/stockdetailprimaryimage.jsp" />


			<% Iterator iter = userSession.getArticleDetail().getImages().iterator();
			   int imgCtr = 1;
			   while (iter.hasNext()) { 
				ArticleDetailImage articleDetailAdditionalImage = (ArticleDetailImage)iter.next(); 

				if (!userSession.getArticleDetail().getCurrentImage().isZoomable()) {
					//imgCtr++;
					
					String primaryImageName 	= website.getWebSiteURL().substring(0,website.getWebSiteURL().lastIndexOf("/")+1) + articleDetailAdditionalImage.getPrimaryImageName();
					String largeImagePath 	= website.getWebSitePath() + "images/_zoomconversionqueue/"+articleDetailAdditionalImage.getImageVendorArticleId()+".jpg";
					String largeImageName 	= website.getWebSiteURL().substring(0,website.getWebSiteURL().lastIndexOf("/")+1) + "images/_zoomconversionqueue/"+articleDetailAdditionalImage.getImageVendorArticleId()+".jpg";
					if(!new File(largeImagePath ).exists()) largeImageName = articleDetailAdditionalImage.getLargeImageName(); //primaryImageName;
	
					String thumbImageName 	= website.getWebSiteURL().substring(0,website.getWebSiteURL().lastIndexOf("/")+1) + articleDetailAdditionalImage.getAdditionalImageName();				

					int imageVaId = 0;
					imageVaId = articleDetailAdditionalImage.getImageVendorArticleId();
					int blobId = 0;
					blobId = articleDetailAdditionalImage.getBlobStorageId();
%>
				
					<a href="<%=largeImageName%>" rel="zoom-id: mainZoomer" rev="<%=primaryImageName%>" > <img src="<%=thumbImageName%>" /> </a>


<% 				} else { %>

					<script language="JavaScript"> <!-- if (document.images) { pic1= new Image(); pic1.src="<%=articleDetailAdditionalImage.getAdditionalImageName()%>"; } //--> </script> 

					<a href='template/components/stockdetailprimaryimage.jsp?imageName=<%=articleDetailAdditionalImage.getPrimaryImageName()%>&amp;imageId=<%=articleDetailAdditionalImage.getBlobStorageId()%>'>  <% //nm1 %>
						<img src='<%=articleDetailAdditionalImage.getAdditionalImageName()%>'
							alt='<%=articleDetailAdditionalImage.getImageShortDescription()%>'
							title='<%=articleDetailAdditionalImage.getImageShortDescription()%>'
							onmouseover="document.getElementsByClassName('primaryimage',$('imageandlinkinner')).title=document.getElementsByClassName('primaryimage',$('imageandlinkinner'))[0].src;document.getElementsByClassName('primaryimage',$('imageandlinkinner'))[0].src='<%=articleDetailAdditionalImage.getPrimaryImageName()%>;'" 
							onmouseout="document.getElementsByClassName('primaryimage',$('imageandlinkinner'))[0].src=document.getElementsByClassName('primaryimage',$('imageandlinkinner'))[0].title;" 
						/>
					</a>

<% 				} %>
			<% } %>

		<% } else { %>
 
			<jsp:include page="template/components/stockdetailprimaryimage.jsp" />

		<% }
	}
%>
