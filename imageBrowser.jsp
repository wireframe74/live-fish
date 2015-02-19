<!-- start of imageBrowser.jsp -->
<%@page import="co.simplypos.model.utils.helpers.HTMLHelper" %>
<%@page import="co.simplypos.model.website.RenderImageServlet" %>
<%@page import="co.simplypos.persistence.VendorArticle" %>
<%@page import="co.simplypos.persistence.BlobStorage" %>
<%@page import="java.io.File" %>
<%@page import="java.sql.Connection" %>
<%@page import="java.util.Hashtable" %>
<%@page import="java.util.Vector" %>

<jsp:useBean id="website"  scope="application" class="co.simplypos.model.website.WebSite" />
<jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession" />

<%
	Connection connection = null;
	String vaIdStr = null;
	String idStr = null;
	String masterId = null;
	String imageName;
	String mainImageName;
	String description = "";
	String fullDesc = "";
	Integer vaId = new Integer(0);
	int vaid = 0;
	Integer id = new Integer(0);
	int blobStorageId = 0;
	Hashtable primaryImage = null;
	Vector additionalImages = null;
	File cachedImage;
	int masterVaId = 0;
	
	vaIdStr = request.getParameter("vaid");
	idStr = request.getParameter("id");
	description = request.getParameter("description");
	masterId = request.getParameter("masterid");
	
	if (vaIdStr != null) {
		vaId = new Integer(vaIdStr);
	}
	
	if (idStr != null) {
	    
	    id = new Integer(idStr);
	}
	
	if (masterId == null) {
	    
	    masterVaId = vaId.intValue();
	} else {
	    
	    masterVaId = new Integer(masterId).intValue();
	}
	
	vaid = vaId.intValue();
	blobStorageId = id.intValue();
	
	try {
	    
	    connection = website.getConnection();
	    primaryImage = VendorArticle.getPrimaryImage(masterVaId, connection);
		additionalImages = VendorArticle.getAdditionalImages(masterVaId, connection);
		fullDesc = HTMLHelper.applyHTML(BlobStorage.getImageDescription(vaid, connection), false);
	
	} finally {
	    
	    if (connection != null) {
	        website.releaseConnection(connection);
	        
	    }
	}
	if (blobStorageId == 0)  {
	    
	    mainImageName = website.getImagePath("ImageDefaultArticle.jpg");
	    
	} else {
		mainImageName = website.getArticleMenu().getCachedImageName(description,blobStorageId,0);
	}
	cachedImage = new File(website.getWebSitePath()+mainImageName); 
	if (!cachedImage.exists()) {
	
		RenderImageServlet.buildImage(userSession, vaid, description, blobStorageId, 0, false, request);
	}
	
	
%>

<html>
	<head>
		<meta http-equiv="content-type" content="text/html; charset=iso-8859-1" />
		<title><%=description %></title>
		<link rel="stylesheet" type="text/css" href="template/style.css" />
		<link rel="stylesheet" type="text/css" href="template/imageBrowser.css" />
	</head>
	<body>
		
		<div class="container">
		
			<%
				if (additionalImages != null && additionalImages.size() >0) {	
			
					if (primaryImage != null) {
						vaId = (Integer) primaryImage.get(VendorArticle.VENDOR_ARTICLE_ID);
						description = (String) primaryImage.get(VendorArticle.SHORT_DESCRIPTION);
						id = (Integer) primaryImage.get(BlobStorage.BLOB_STORAGE_ID);
					}
					imageName = website.getArticleMenu().getCachedImageName(description,id.intValue(),80);
					cachedImage = new File(website.getWebSitePath()+imageName); 
					if (!cachedImage.exists()) {
					
						RenderImageServlet.buildImage(userSession, vaId.intValue(), description, id.intValue(), 80, false, request);
					}
			%>
			<div class="img left">
				<a href="imageBrowser.jsp?id=<%=id.intValue() %>&vaid=<%=vaId.intValue() %>&description=<%=description %>&masterid=<%=masterVaId %>">
					<img src="<%=imageName %>" />
				</a>
			</div>
			<%
			if (additionalImages != null) {
				for (int i = 0; i < additionalImages.size(); i++) {
				    Hashtable detail = (Hashtable) additionalImages.get(i);
				    
				    vaId = (Integer) detail.get(VendorArticle.VENDOR_ARTICLE_ID);
					description = (String) detail.get(VendorArticle.SHORT_DESCRIPTION);
					id = (Integer) detail.get(BlobStorage.BLOB_STORAGE_ID);
					if (id.intValue() == 0) {
					    imageName = website.getImagePath("ImageDefaultArticleThumb.jpg");
					} else {
						imageName = website.getArticleMenu().getCachedImageName(description,id.intValue(),80);
					}
					
					
					cachedImage = new File(website.getWebSitePath()+imageName); 
					if (!cachedImage.exists()) {
					
						RenderImageServlet.buildImage(userSession, vaId.intValue(), description, id.intValue(), 80, false, request);
					}
					
					String className = "img";
					
					if (i % 2 != 0) {
					    
					    className += " left";
					}
			%>
			<div class="<%=className%>">
				<a href="imageBrowser.jsp?id=<%=id.intValue() %>&vaid=<%=vaId.intValue() %>&description=<%=description %>&masterid=<%=masterVaId %>">
					<img src="<%=imageName %>" />
				</a>
			</div>
			<%	
				}
			} 
		}%>
		</div>
		
		<div class="fullDesc">
			<img src="<%=mainImageName %>" />
			<% if (blobStorageId != 0) { %>
				<p><%=fullDesc %></p>
			<% } %>
		</div>
		
	</body>
</html>
<!-- end of imageBrowser.jsp -->