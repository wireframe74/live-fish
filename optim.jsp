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
<jsp:useBean id="website1"  scope="session" class="co.simplypos.model.website.WebSite"><%website1.initialise(request.getRequestURL().toString(), application.getRealPath("/"), 186);%></jsp:useBean>
<jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession"><%userSession.initialise(website1, request);%></jsp:useBean>
<jsp:useBean id="websiteOptim"  scope="session" class="co.simplypos.model.website.WebSite"><%websiteOptim.initialise(request.getRequestURL().toString(), application.getRealPath("/"), 186);%></jsp:useBean>
<html>
<head>
</head>
<body>
Optimisation launched.
</body>
</html>