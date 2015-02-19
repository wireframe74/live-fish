<jsp:useBean id="website"  scope="application" class="co.simplypos.model.website.WebSite" />
<jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession" />
<%@page import="java.util.Vector"%>
<%@page import="java.util.Hashtable"%>
<%@page import="co.simplypos.model.website.WebSite"%>
<%@page import="co.simplypos.model.website.ArticleDetail"%>
<%@page import="java.io.File"%>
<%@page import="co.simplypos.model.website.RenderImageServlet"%>
<%
	//System.out.println("ViewList:10");
	String listcode = request.getParameter("listcode");
	String transactionId = request.getParameter("id");
	boolean isGiftListView = true;
	Vector listDetails =  null;
	
	if (transactionId != null) {	    
		session.setAttribute("psTransactionId", transactionId);
		isGiftListView = false;
//website.writeToLog("10: "+website.getPersonalShopperPageURL());

		if (!website.getPersonalShopperPageURL().equals("templateOrders.jsp")) {
			// personal shopping done elsewhere, show link
%>
			<jsp:forward page="<%=website.getPersonalShopperPageURL()%>"/>
<%
			/*try {
				website.writeToLog("20: /"+website.getPersonalShopperPageURL()+"    getBaseURL: "+WebSite.getBaseURL(request));
	      			response.sendRedirect(WebSite.getBaseURL(request)+"/"+website.getPersonalShopperPageURL()); 

				website.writeToLog("30: "+WebSite.getBaseURL(request)+"/"+website.getPersonalShopperPageURL());
			} catch (Exception e102) {
				website.writeToLog(e102);

				out.write("<script type='text/javascript'>document.location.href='http://www.babyconcierge.co.uk/boutique/"+website.getPersonalShopperPageURL()+"';</script>"); 
			}	
			return;*/
		}
	} else if (listcode == null) {	
	    listcode = userSession.getGiftListCode();
	}
	if (listcode == null) {
	    isGiftListView = false;
	}
	String pageName = "";
	String iconName = "";
	int listClassId = 0;
	if (listcode != null) {
		listClassId = userSession.getGiftListClassId(listcode);
		pageName = userSession.getGiftListName(listcode);
		iconName = "giftlist.png";
		isGiftListView = true;
	} else {
	 	pageName = "Personal Shopping List";
	 	iconName = "psshopper.png";
		isGiftListView = false;
	}
	
	if (isGiftListView) {
		listDetails = userSession.getArticleDetail().getGiftListArticles(listClassId);
	} else {
		listDetails = userSession.getArticleDetail().getPersonalShopperArticles(Integer.valueOf(transactionId).intValue());
	}
%>
<div id="viewlist">
<jsp:include page="accountButtons.jsp" />
<br />
<div class="checkoutcontainer">
	<h1 id="mainTitle" class="pagetitle left">&nbsp;<img src="<%=website.getImagePath("containerheader.gif") %>" alt="" class="containerHeader" /><%=pageName %><img src="<%=website.getImagePath(iconName) %>" alt="<%=pageName %>" align="right" id="mainImg" /></h1>
	<br />
<% if (!isGiftListView) { %>
	
	<div class="left">
		<a href="tracking.jsp?id=<%=transactionId %>&action=resume" class="button">&nbsp; &nbsp; &nbsp;Amend Order&nbsp; &nbsp; &nbsp;</a>
	</div>	
	<br />
<% } %>	

<% if (listDetails != null && listDetails.size() > 0) {
%>
	<table width="100%">
		<thead>
			<tr>
<%
	if (isGiftListView && userSession.isGiftListOwner(listcode)) {
%>			
				<td class="smallertext" align="center">Remove</td>
<%
	}
%>				
				<td></td>
				<td class="smallertext">Description</td>
<%
	if (!isGiftListView) {
%>
				<td class="smallertext">Message</td>
<%
	}
%>			
				
				<td class="smallertext" align="right">Quantity</td>
<%
	if (isGiftListView && userSession.isGiftListOwner(listcode)) {
%>				
				<td class="smallertext" align="right">Remaining</td>
<%
	}
%>				
				<td class="smallertext" align="right">Price</td>
			</tr>
		</thead>

		<tbody>
<%
			int vendorArticleId = 0;
			int blobStorageId = 0;
			String description = "";
			String message = "";
			float price = 0f;
			int quantity = 0;
			int remaining = 0;
			
			for (int i = 0; i < listDetails.size(); i++) {
	            Hashtable vendorArticleHashtable = (Hashtable) listDetails.get(i);
	            description = (String) vendorArticleHashtable.get(ArticleDetail.SHORT_DESCRIPTION);
	            price = ((Float) vendorArticleHashtable.get(ArticleDetail.PRICE)).floatValue();
	            vendorArticleId = ((Integer) vendorArticleHashtable.get(ArticleDetail.VENDOR_ARTICLE_ID)).intValue();
	            blobStorageId = ((Integer) vendorArticleHashtable.get(ArticleDetail.BLOB_STORAGE_ID)).intValue();
	            if (vendorArticleHashtable.get(ArticleDetail.QUANTITY) != null) {
	                quantity = ((Integer)vendorArticleHashtable.get(ArticleDetail.QUANTITY)).intValue();
	            }
	            if (vendorArticleHashtable.get(ArticleDetail.MESSAGE) != null) {
	                message = (String) vendorArticleHashtable.get(ArticleDetail.MESSAGE);
	            }
	            remaining = ((Integer) vendorArticleHashtable.get(ArticleDetail.REMAINING)).intValue();
	            String imageName = website.getArticleMenu().getCachedImageName(description, blobStorageId, website.getBasketThumbSize(), 0);
	            String link = "";
	            link = website.getArticleMenu().getPageForVendorArticle(vendorArticleId);
				int parentVendorArticleId = vendorArticleId;
			int maxLoopCount = 0;
	            while (link == null && parentVendorArticleId > 0 && parentVendorArticleId != website.getRootId()) {
				    parentVendorArticleId = website.getArticleMenu().findOptionSet(parentVendorArticleId);
				    link = website.getArticleMenu().getPageForVendorArticle(parentVendorArticleId);
					if (maxLoopCount++ > 20) break;
				}
	            if (link != null) link += "&id="+vendorArticleId;
				File cachedImage = new File(website.getWebSitePath()+imageName);
				if (!cachedImage.exists()) {
				    try {
				    RenderImageServlet.buildImage(userSession, vendorArticleId, description, blobStorageId, website.getBasketThumbSize(), true, request);
				    } catch (Exception e) {
				        website.writeToLog(e);
				        imageName = website.getImagePath("ImageDefaultArticleThumb.jpg");
				    }
				}

				if (remaining > 0 || userSession.isGiftListOwner(listcode)) {
%>
			<tr>
<%
					if (isGiftListView && userSession.isGiftListOwner(listcode)) {
%>			
				<td align="center">
					<form name="deleteForm" action="viewList.jsp" method="post">
						<input type="hidden" name="action" value="delete" />
						<input type="hidden" name="id" value="<%=vendorArticleId%>" />
						<input type="hidden" name="listClassId" value="<%=listClassId%>" />
						<input type="hidden" name="listcode" value="<%=listcode%>" />						
						<input type="image" src="<%=website.getImagePath("delete.gif")%>" alt="Delete" class="noBorder" />
					</form>
				</td>
<%
					}
%>				
				<td>
					<a href="<%=link %>">
						<img src="<%=imageName %>" alt="<%=description %>" title="<%=description %>" />
					</a>
				</td>
				<td>
					<a href="<%=link %>">
						<%=description %>
					</a>
				</td>
<%
	if (!isGiftListView) {
%>
				<td class="smallertext"><%=message %></td>
<%
	}
%>					
				
<%
					if (isGiftListView && userSession.isGiftListOwner(listcode)) {
%>
				<td align="right">
					<form name="updateQuantity" action="viewList.jsp" method="post">
						<input type="hidden" name="action" value="update" />
						<input type="hidden" name="id" value="<%=vendorArticleId%>" />
						<input type="hidden" name="listClassId" value="<%=listClassId%>" />
						<input type="hidden" name="listcode" value="<%=listcode%>" />
						<input type="text" size="1" name="quantity" value="<%=quantity %>" />
						<input type="image" src="<%=website.getImagePath("updatebasket.gif")%>" alt="Update Quantity" class="noBorder" />
					</form>
					
				</td>
<%
					} 
%>				
				<td align="right"><%=remaining %></td>
				<td align="right"><%=userSession.formatPrice(price) %></td>
			</tr>
<%
				}
			}
%>
			</tbody>
		</table>
<% 	        
		} 
%>

<% if (!isGiftListView) { %>
	<br />
	<div class="left">
		<a href="tracking.jsp?id=<%=transactionId %>&action=resume" class="button">&nbsp; &nbsp; &nbsp;Amend Order&nbsp; &nbsp; &nbsp;</a>
	</div>	
<% } %>		
<%
		if (listDetails != null && listDetails.size() <= 0) {
%>	        
			<br />
			<br />
			<% if (!isGiftListView) { %>
				<div class="discount left">
				<img src="<%=website.getImagePath("icon_error.gif") %>" alt="Warning" />
<% 			
				if (pageName.equals("")) { 
%>
					The list code you entered cannot be found. Please check the list code and re-enter:
<% 			
				} else {
%>	
					This list does not appear to have any items in it. Please check the list code or contact the list owner <br />
<%
				}
%>
				</div>
<%
			} else {
				if (userSession.isGiftListOwner(listcode)) {
%>
					<div class="emptygiftlist">
						<p><img src="<%=website.getImagePath("giftlist.png")%>" />You have successfully created your gift list.</p>
						</p>Your gift list is currently empty. You can now add products to your gift list by browsing the products on this website and selecting the "Add to Gift List" button on any main product page.</p>
					</div>
<%				} else { %>
					<div class="emptygiftlist">
						<p><img src="<%=website.getImagePath("giftlist.png")%>" />Sorry, this gift list is currently empty, please contact the list owner.</p>
					</div>
<%
				}
			}
		}
%>
</div>
</div>