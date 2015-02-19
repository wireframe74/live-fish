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
		   co.simplypos.model.utils.helpers.HTML2Text,
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

	File sourceFile = null;
	File backupFile = null;
	File backupFolder = null;
	if (request.getParameter("fulledit") != null && request.getParameter("go") != null && (request.getParameter("go").equals("g1ftware") || request.getParameter("go").equals("2ndphase"))) {
		String fileName = request.getParameter("fulledit");
		fileName = StringHelper.replace(fileName,"/","-");
		fileName = StringHelper.replace(fileName,"\\","-");
		fileName = StringHelper.replace(fileName,"^","-");
		backupFolder = new File(website.getWebSitePath()+"_backup/editor");
		backupFile = new File(website.getWebSitePath()+"_backup/editor/bak_"+System.currentTimeMillis()+"_"+fileName);

		String fullEditName = StringHelper.replace(request.getParameter("fulledit"),"^","/");
		sourceFile = new File(website.getWebSitePath()+fullEditName);
//out.write("1. sourceFile: "+sourceFile.getAbsolutePath());
       } else if (request.getParameter("file").equals("template")) {
		backupFolder = new File(website.getWebSitePath()+"_backup/editor");
		backupFile = new File(website.getWebSitePath()+"_backup/editor/bak_"+System.currentTimeMillis()+"_"+request.getParameter("file")+".jsp");
		sourceFile = new File(website.getWebSitePath()+"template/"+request.getParameter("file")+".jsp");
//out.write("2. sourceFile: "+sourceFile.getAbsolutePath());
	} else {
		backupFolder = new File(website.getWebSitePath()+"_backup/editor");
		backupFile = new File(website.getWebSitePath()+"_backup/editor/bak_"+System.currentTimeMillis()+"_"+request.getParameter("file")+".html");
		sourceFile = new File(website.getWebSitePath()+request.getParameter("file")+".html");
//out.write("3. sourceFile: "+sourceFile.getAbsolutePath());
	}

//	website.writeToLog("backupFolder: "+backupFolder.getAbsolutePath());
//	website.writeToLog("backupFile : "+backupFile.getAbsolutePath());
//	website.writeToLog("sourceFile : "+sourceFile.getAbsolutePath());

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

		//content = new String(content.getBytes(), "ASCII");

		content = new HTML2Text().turnToHtml(content, false);
		
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

			String forwardPage = request.getRequestURL()+"?go=2ndphase&file="+request.getParameter("file")+"&version="+version;
			if (request.getParameter("fulledit") != null) {
				String fullEditName = StringHelper.replace(request.getParameter("fulledit"),"/","^");
				forwardPage += "&fulledit="+fullEditName;	
			}
//website.writeToLog("forwardPage: "+forwardPage ); 
//out.write("<p>forwardPage: "+forwardPage);

			try {
				//Thread.sleep(2000);
	      			response.sendRedirect(forwardPage); 
			} catch (Exception e102) {
				out.write("<script type='text/javascript'>document.location.href='"+forwardPage+"';</script>"); 
			}	
		} catch (Exception e11) {
			website.writeToLog(e11);
			out.write(e11.getMessage());
	
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
				<input type="hidden" name="file" value="<%=request.getParameter("file")%>" >
				<% if (request.getParameter("fulledit") != null) { 
					String fullEditName = StringHelper.replace(request.getParameter("fulledit"),"/","^");
				%>	
					<input type="hidden" name="fulledit" value="<%=fullEditName%>" >
					<input type="hidden" name="go" value="g1ftware" >
				<% } %>
<%				out.write("<p>Editing: "+website.getWebsiteName()+": "+sourceFile.getName()+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type=\"submit\" value=\"SAVE\">"+(version>0?"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Successfully saved version "+version:"")+"</p>"); %>
			</form>
<%
		}
	}
} catch (Exception e) {
	website.writeToLog(e);
	out.write(e.getMessage());
}%>
</body>
</html>
