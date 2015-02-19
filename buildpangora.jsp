<%@ page import="co.simplypos.model.website.ArticleDetail,
                 co.simplypos.persistence.Article,
		 co.simplypos.persistence.Domain,
		 co.simplypos.persistence.Currency,
                 java.math.BigDecimal,
  	         java.text.DecimalFormat, 
                 co.simplypos.model.utils.Triplet,
                 java.text.SimpleDateFormat,           
                 java.text.DateFormat,
                 co.simplypos.model.website.WebDiscountManager,
                 javax.imageio.ImageWriter,
		 javax.mail.MessagingException,
                 com.sun.imageio.plugins.jpeg.JPEGImageWriter,
                 java.io.*,
		 java.awt.*,
		 java.util.*,
                 java.sql.Connection,
                 java.net.URLEncoder,
                 java.net.URL,
                 java.net.URLConnection,
                 javax.net.ssl.HttpsURLConnection,
                 javax.swing.table.DefaultTableModel,
		 java.sql.SQLException,
		 java.sql.Connection,
                 java.sql.Statement,
                 java.sql.ResultSet,
                 co.simplypos.model.TransactionManager,
                 co.simplypos.model.DiscountManager,
                 co.simplypos.model.website.utils.Logger,
                 co.simplypos.model.website.ShoppingBasket,
                 co.simplypos.model.website.UserSession,
                 co.simplypos.model.website.*,
		 co.simplypos.model.utils.Pair,
                 co.simplypos.model.utils.helpers.HTMLHelper,
                 co.simplypos.model.utils.helpers.StringHelper,
		 co.simplypos.model.utils.helpers.FileHelper,
                 co.simplypos.model.utils.Security,
                 co.simplypos.persistence.*,
                 co.simplypos.persistence.utils.ComboListCache,
                 javax.swing.text.html.HTML,
                 javax.mail.Transport,
                 javax.mail.Message, 
                 javax.mail.internet.InternetAddress,
                 javax.mail.internet.MimeMessage,
	  	 com.clearcommerce.CpiTools.security.HashGenerator  
"%>
<jsp:useBean id="website"  scope="application" class="co.simplypos.model.website.WebSite"><%website.initialise(request.getRequestURL().toString(), application.getRealPath("/"), 186);%></jsp:useBean>
<jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession"><%userSession.initialise(website, request);%></jsp:useBean>

<% 
try {
	String feedFilename = "";	
	if ("".equals(feedFilename)) {
	    feedFilename = "pangorafile.txt";	 
	}

	final DecimalFormat df = new DecimalFormat("#0.00");
		final String delim = "\t";
		final String cr = "\n";
		
    	String sql = "SELECT vac.vendor_article_id1, va.vendor_article_id, va.short_description, bs.blob_item, va.price,  a.picture_blob_storage_id, va.description, va.quantity, va.vendor_article_code, vac.vendor_article_clsfn_id  "+ 
		 			 " FROM  vendor_article va, article a, vendor_article_clsfn vac, blob_storage bs, blob_storage bs1 "+  
					 " where va.article_id = a.article_id "+ 
					 " and vac.vendor_article_id2 = va.vendor_article_id "+ 
					 " and bs.blob_storage_id = a.full_text_blob_storage_id "+ 
					 " and bs1.blob_storage_id = a.picture_blob_storage_id "+
					 " and a.article_type_domain_id in ("+Article.ARTICLE_TYPE_STANDARD_ARTICLE+","+Article.ARTICLE_TYPE_OPTIONS+")"+
					 " and va.quantity > 0 "+
					 " and va.vendor_id = 1  and a.picture_blob_storage_id > 0";  
    	Statement stmt = null;
    	File feedFile = new File(website.getWebSitePath(),feedFilename);
	FileWriter fw = null;
	Connection conn = null;
    	try {
    		conn = website.getConnection();
    		
    		feedFile.createNewFile();
    		
    		fw = new FileWriter(feedFile);
    		fw.write("offer_url"+delim+"label"+delim+"description"+delim+"image_url"+delim+"merchant-category"+delim+"price"+delim+"offer_id"+delim+"instock"+cr);
    		
		String baseURL = website.getWebSiteURL();
		baseURL = baseURL.substring(0,baseURL.lastIndexOf("/")+1);
    		
    		stmt = conn.createStatement();
    		ResultSet rs = stmt.executeQuery(sql);
    		while (rs.next()) {
    			//String fullDesc = rs.getString(7);
			String fullDesc = website.getArticleMenu().getFullDescription(rs.getInt(2));
			if (fullDesc == null) fullDesc = "";

    			
    			String productURL = baseURL + ArticleMenu.getPageName(website, fullDesc, true) + "?pid="+rs.getInt(1)+"&id="+rs.getInt(2)+"&src=pangora";
    			String name = rs.getString(3);
			String desc =  "";
    			if (rs.getString(4) != null) desc = StringHelper.removeChar(StringHelper.removeChar(HTMLHelper.removeHTML(rs.getString(4)),'\n'),'\t');
    			String price = df.format(rs.getDouble(5));
    			String imageURL = baseURL + "remoteRenderer.jsp?id="+rs.getInt(6);
    			String category = fullDesc;
    			category = StringHelper.replace(category," , "," > ");
    			category = StringHelper.replace(category,", "," > ");
				category = StringHelper.replace(category," ,"," > ");
				category = StringHelper.replace(category,","," > ");
				String vaCode = ""+rs.getString(9);
				String inStock = (rs.getInt(8)>0?"Y":"N");
				String barcode = ""+rs.getInt(1);
				int quantity = rs.getInt(8);
				

				int vendorArticleId = rs.getInt(2);
				int vendorArticleClsfnId = rs.getInt(10);
				float unitPrice = (float)rs.getDouble(5);
				
				Triplet discounts = userSession.getShoppingBasket().getDiscountSchemesForVendorArticle(vendorArticleId, 1, unitPrice, unitPrice, vendorArticleClsfnId);
				if (((ArrayList)discounts.get(0)).size() > 0) {
					price = df.format(((BigDecimal)discounts.get(2)).floatValue());
				}

				fw.write(productURL+delim+name+delim+desc+delim+imageURL+delim+category+delim+"GBP"+price+delim+vaCode+delim+inStock+cr);
    		}    		
    	} catch (Exception e) {
    		out.write(""+e.getMessage());
    	} finally {
    		try {
				if (stmt != null) stmt.close();
			} catch (SQLException e1) {
			}
			if (fw != null)
				try {
					fw.close();
				} catch (IOException e2) {
				}
			if (conn != null) website.releaseConnection(conn);
    	}

	out.write("Pangora feed file built: <a href='"+feedFilename+"'>"+feedFilename+"</a>");

} catch (Exception e) {
	out.write(e.getMessage());
}%>
