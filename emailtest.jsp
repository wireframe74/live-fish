<jsp:useBean id="website"  scope="application" class="co.simplypos.model.website.WebSite" />
<%@page import="java.util.Properties" %>
<%@page import="co.simplypos.model.utils.helpers.MailHelper" %>
<%@page import="java.io.FileInputStream" %>
<%@page import="javax.mail.Message" %>
<%@page import="javax.mail.Authenticator" %>
<%@page import="javax.mail.PasswordAuthentication" %>
<%@page import="javax.mail.Session" %>
<%@page import="javax.mail.Transport" %>
<%@page import="javax.mail.internet.MimeMessage" %>
<%@page import="javax.mail.internet.InternetAddress, java.util.Enumeration" %>
<%   
if (request.getParameter("go") != null && request.getParameter("go").equals("1136")) {
	StringBuilder htmlMessage = new StringBuilder();
	htmlMessage.append("Test from the ").append(website.getWebsiteName()).append(" website");
	try {
	     
	    Properties mailProperties = new Properties();
	    
	   	String SMTP_HOST = MailHelper.FIXED_SMTP_HOST; 
   		String recepient = "neil.mackley@virgin.net";//MailHelper.FIXED_SMTP_TO1;
   		String from      = "support@intelligentretail.co.uk"; //"MailHelper.FIXED_SMTP_FROM;
   		//String webhost   = "ab8";


		if (request.getParameter("from") != null) from = ""+request.getParameter("from");
		if (request.getParameter("to") != null) recepient = ""+request.getParameter("to");

   		mailProperties.put("mail.smtp.host",SMTP_HOST);   		
		mailProperties.put("mail.smtp.auth", "true");

		Authenticator auth = new Authenticator() {
    			public PasswordAuthentication getPasswordAuthentication() {
    				return new PasswordAuthentication(MailHelper.FIXED_SMTP_USER, MailHelper.FIXED_SMTP_PASS); 
    			}
    		};

   		final Session mailSession = Session.getInstance(mailProperties, auth);
   		
   		MimeMessage message = new MimeMessage(mailSession);
		out.write("from: " + from);
		out.write("<br />");
		out.write("to: " + recepient);
		out.write("<br />");
		out.write("<br />");
		out.write("smtp host: " + SMTP_HOST); 

		//out.write("<br />");
		//out.write("<br />");
		//out.write("server: "+webhost);
   		out.write("<br />");
		out.write("<br />");
		out.write("Test Results:<BR>");

		message.addFrom(InternetAddress.parse(from));
		message.addRecipients(Message.RecipientType.TO, InternetAddress.parse(recepient));
		message.addRecipients(Message.RecipientType.CC, InternetAddress.parse("websupport@intelligentretail.co.uk"));
		message.setSubject("Test1: email direct from servlet from the " + website.getWebsiteName()+" website");
		message.setContent(htmlMessage.toString(), "text/html");
   		
		out.write("&nbsp;&nbsp;&nbsp;Test1: email direct from servlet...");
		Transport.send(message);
		out.write("Success<BR>");        

		out.write("&nbsp;&nbsp;&nbsp;Test2: email from IR model...");
	    	MailHelper.sendEmailFromWebsite(recepient, "Test2: email from IR model from the  "+website.getWebsiteName() +" website",htmlMessage.toString(), htmlMessage.toString(), from, "support@intelligentretail.co.uk", "");
	    	//website.sendEmailFromWebsite(recepient, "Test2: email from IR model from the  "+website.getWebsiteName() +" website",htmlMessage.toString(), htmlMessage.toString());
		out.write("Success<BR>");

	    	out.write("<BR>Completed.<BR>");

	} catch (Exception e) {
	    out.write(e.getMessage());

	}
}
%>