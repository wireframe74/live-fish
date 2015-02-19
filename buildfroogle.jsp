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
<jsp:useBean id="website"  scope="application" class="co.simplypos.model.website.WebSite" />
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<title><%=website.getWebsiteName()%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<meta name="keywords" content="" />
<meta name="description" content="" />
<meta name="ROBOTS" content="NONE">
</head>
<body>
<% 
if (website == null) {
%>
	<p><br />Website not initialised yet, awaiting first visitor to visit the website.
<%
} else {
	if (request.getParameter("launch") == null) {
%>
		<p><br />Please note that visiting this page is no longer required as feed files are now automatically generated nightly for convenience.
		<!--  <p><br />To start building your feed file <a href="?launch=1">click here</a>   -->
<%
	} else {
		try {
			website.getFeedBuilder().launch(false);
		} catch (Exception e) {
			out.write(e.getMessage());
		}
%>
		<p><br />Feed submission complete, please wait for status update or <a href="<%=website.getWebSiteBaseURL()%>/feedstatus.html">click here</a>

<% 	} 
} %>
</body>
</html>
