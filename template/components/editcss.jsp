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
<jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession" />
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<title><%=website.getWebsiteName()%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<meta name="keywords" content="" />
<meta name="description" content="" />
<meta http-equiv="pragma" content="no-cache" />
<meta http-equiv="expires" content="-1" />
</head>
<body>
<% 
int version = 0;
try {
	File backupFolder = new File(website.getWebSitePath()+"_backup/editor");
	File backupFile = new File(website.getWebSitePath()+"_backup/editor/bak_"+System.currentTimeMillis()+"_style.css");
	File sourceFile = new File(website.getWebSitePath()+"template/style.css");
	if (request.getParameter("type") != null && request.getParameter("type").equals("ie")) {
		backupFile = new File(website.getWebSitePath()+"_backup/editor/bak_"+System.currentTimeMillis()+"_style_ie.css");
		sourceFile = new File(website.getWebSitePath()+"template/style_ie.css");
	}
	if (request.getParameter("type") != null && request.getParameter("type").equals("metahdr")) {
		backupFile = new File(website.getWebSitePath()+"_backup/editor/bak_"+System.currentTimeMillis()+"_-meta-metaheader.html");
		sourceFile = new File(website.getWebSitePath()+"meta/metaheader.html");
	}

	if (request.getParameter("version") != null) {
		try {
			version = Integer.parseInt(request.getParameter("version"));
		} catch (NumberFormatException nfe) { version = 0; }
	}
	if (request.getParameter("stylefilecontents2") != null) {
		String content = request.getParameter("stylefilecontents2");
		
		content = StringHelper.replace(content, "&#40;", "(");
		content = StringHelper.replace(content, "&#41;", ")");
		content = StringHelper.replace(content, "&#39;", "'");

		content = new String(content.getBytes(), "ASCII");

		FileWriter fw = null;
		try {	
			if (!backupFolder.exists()) {
				backupFolder.mkdir();
			}
			FileHelper.fileCopy(sourceFile,backupFile);
			fw = new FileWriter(sourceFile);
			fw.write(content);
			out.write("Save Successful");
			version++;

			String forwardPage = request.getRequestURL()+"?go=2ndphase&type="+request.getParameter("type")+"&version="+version;
			try {
				//Thread.sleep(2000);
	      			response.sendRedirect(forwardPage); 
			} catch (Exception e102) {
				out.write("<script type='text/javascript'>document.location.href='"+forwardPage+"';</script>"); 
			}		
		} finally {
			if (fw != null)
			try {
				fw.close();
			} catch (Exception e) {}
		}
	} else {
		if (!userSession.isLoggedIn() && (request.getParameter("go") == null || !(request.getParameter("go").equals("g1ftware") || request.getParameter("go").equals("2ndphase")))) {
			out.write("Access Denied");
		} else {
			
			String content = FileHelper.readFileToString(sourceFile); 
%>
			<form action="<%=request.getRequestURL()%>" method="post">
<%				out.write("<p>Editing: "+website.getWebsiteName()+": "+sourceFile.getName()+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type=\"submit\" value=\"SAVE\">"+(version>0?"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Successfully saved version "+version:"")+"</p>"); %>
				<textarea name="stylefilecontents2" rows="100" cols="200"><%=content%></textarea>
				<input type="hidden" name="version" value="<%=version%>" >
				<input type="hidden" name="type" value="<%=request.getParameter("type")%>" >
<%				out.write("<p>Editing: "+website.getWebsiteName()+": "+sourceFile.getName()+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type=\"submit\" value=\"SAVE\">"+(version>0?"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Successfully saved version "+version:"")+"</p>"); %>
			</form>
<%
		}
	}
} catch (Exception e) {
	out.write(e.getMessage());
}%>
</body>
</html>
