<!-- start of components/changepwd.html -->
<%@page import="java.sql.Connection" %>
<jsp:useBean id="website"  scope="application" class="co.simplypos.model.website.WebSite" />
<jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession" />



<%
boolean passwordChanged = false;
String validationString = "";
String existingPwd = "";
String newPwd1 = "";
String newPwd2 = "";

if (!userSession.isLoggedIn()) {
	validationString = "You must log-in or register before you can change your password";
}

if (request.getParameter("chngpwd") != null) {
if (request.getParameter("existingpwd") != null) {
	existingPwd = request.getParameter("existingpwd");
}
if (request.getParameter("newpwd1") != null) {
	newPwd1 = request.getParameter("newpwd1");
}
if (request.getParameter("newpwd2") != null) {
	newPwd2 = request.getParameter("newpwd2");
}

if (existingPwd != null && !existingPwd.trim().equals("")) {
	String password = ";;";

	Connection internetConn = null;	
       Statement stmt = null;
	java.sql.PreparedStatement pstmt = null;

	try {
	
		internetConn = website.getConnection();
       	stmt = internetConn.createStatement();
		pstmt = internetConn.prepareStatement("update customer set user_password = ? where email_address = '"+ userSession.getLoggedInCustomerEmailAddress()+"'");

		String sql = "select "+Customer.PASSWORD+" from "+Customer.TABLE_NAME+" where "+Customer.EMAIL_ADDRESS+" = '"+userSession.getLoggedInCustomerEmailAddress()+"'";
	 	ResultSet rs = stmt.executeQuery(sql);
	 	if (rs.next()) {
	 		byte[] encPassword = rs.getBytes(1);
	 		password = WebSite.decryptPassword(encPassword); 							

			if (existingPwd.equals(password)) {
				if (newPwd1 != null && newPwd2 != null) {
					if (newPwd1.equals(newPwd2)) {
						byte[] userPassEnc = WebSite.encryptPassword(newPwd1);
						pstmt.setBytes(1,userPassEnc);
			  			pstmt.executeUpdate();	
						internetConn.commit();
							
						passwordChanged = true;

						validationString = "";
						existingPwd = "";
						newPwd1 = "";
						newPwd2 = "";

					} else {
						validationString = "You have entered two different passwords, please try again.";
						newPwd1 = "";
						newPwd2 = "";
					}
				} else {
					validationString = "Please enter your new password and confirm your new password";
				}			
			} else {
				validationString = "Incorrect existing passord, please try again.";
			}
		} else {
			validationString = "Cannot find your details, please re-login.";
		}		
	} finally {
      		 if (stmt != null) stmt.close();
		 if (pstmt != null) pstmt.close();
		 if (internetConn != null) website.releaseConnection(internetConn);
       }


} else {
	validationString = "Please enter your existing password";
}
}

   if (validationString != null && !validationString.equals("")) {
    %>
        
                            <img src="<%=website.getImagePath("icon_error.gif")%>" alt="" />
                        			 
                            <b><%=validationString%></b>
                       
    <% } %>

	
<div class="stockcontainer">

				    <% 
					String pageTitle = "Change My Password";
					String pageTitleText = "To change your password enter your existing and new passwords below.";
					String pageTitleImage = "";

				    %>
	                       


					<%@include file="../drawcontainerheader.html"%>

		
	       <form name="changepassword" action="changepwd.jsp" method="POST" >
		<input type='hidden' name='chngpwd' value='1'> 

					
							Enter your existing password  
					
							<input class='inputitem' type='password' name='existingpwd' >
						
							Enter your new password 
						
							<input class='inputitem' type='password' name='newpwd1' autocomplete='off'>
						
							Confirm your new password 
						
							<input class='inputitem' type='password' name='newpwd2' autocomplete='off'>
						
							<% if (passwordChanged) { %>
								<b>Your password has been changed.</b>
							<% } %>
						
							<input type='submit' name='submit' value='Update'>
					
					
		</form>
	
</div>
		
<!-- end of components/changepwd.html -->