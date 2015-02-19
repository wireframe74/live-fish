<!-- start of components/loginpopup.jsp -->
<jsp:useBean id="website" scope="application" class="co.simplypos.model.website.WebSite"><%website.initialise(request.getRequestURL().toString(), application.getRealPath("/"), 170);%></jsp:useBean><jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession"><%userSession.initialise(website, request);%></jsp:useBean>
<%@page import="co.simplypos.model.website.HTMLComponents"%>
<html>
<head>
<link rel="stylesheet" href="../framework.css" type="text/css" />
<link rel="stylesheet" href="../style.css" type="text/css" />
<style TYPE="text/css"> 
<!-- 
body {font-family: Arial, Verdana, "MS Sans Serif", sans-serif; color: #000000; margin-top: 0px; background: #ffffff;}
--> 
</style>
</head>
<body>
<% 
	userSession.getWebController().processRegisterPage(request);

	final String initialValidationString = "Please enter your ";
	String validationString = initialValidationString ;
	if (request.getAttribute("validationString") != null) validationString = (String)request.getAttribute("validationString");

	String paramAction = ""+request.getParameter("action");
	if (request.getAttribute("action") != null) paramAction = (String)request.getAttribute("action");

	boolean showValidationIcon = true;
	//out.write("paramAction: "+paramAction+"     validationString: "+validationString+"    valid: "+validationString.equals(initialValidationString));
	if (paramAction.equals("forgot") && validationString.equals(initialValidationString)) {
		//showValidationIcon = false;
		validationString = "An email has been sent containing your password.";
	}
	if (paramAction.equals("login") && validationString.equals(initialValidationString)) {
		String nextURL = website.getWebSiteURL().substring(0,website.getWebSiteURL().lastIndexOf("/")+1)+"quickpay.jsp";	
		if ((""+request.getRequestURL()).startsWith("https:")) nextURL = co.simplypos.model.utils.helpers.StringHelper.replace(nextURL, "http:", "https:");
		%>
			<br /><br /><br /><br /><br /><br />
			<center>Login Successful<center>

		      <script type='text/javascript'>
		          parent.parent.location.href="<%=nextURL%>";
		      </script>		
			<noscript>
				<br /><br /><a href="<%=nextURL%>">Click here to continue</a>
		  	</noscript>			
		<%
		return;
	} 
%>
<span id="loginpopupbackground">
<table width="350" align="center" cellspacing="0" cellpadding="0">
<tr>
<td>
<table align="center" width="100%" valign="top" border="0" cellspacing="0" cellpadding="0">
    <tr>
    <td>
           <br>
    <td>
    </tr>
    <% if (!validationString.equals(initialValidationString)) { %>
        <tr>
            <td>
		<div id="pagevalidationmessage">
			<% if (showValidationIcon) { %> 
				<img src="<%=website.getImagePath("icon_error.gif")%>">&nbsp;
			<% } %>
			<div class="pagevalidationtext"><%=validationString%></div>
		</div>
            </td>
        </tr>
    <% } else { %>
        <tr>
            <td>
		<img src="<%=website.getImagePath("spacer.gif")%>" width="1" height="30" />
            </td>
        </tr>
    <% } %>
	<tr>
	   <td>	
		<div id="loginpopupform">	
		<form name="logindetails" action='loginpopup.jsp' method="post">  
                 <input type=hidden name="action" value="login">
                 <input type=hidden name="src" value="">
                 <input type="hidden" name="cName" value="<%=(request.getParameter("cName") != null ? request.getParameter("cName"): "")%>" />
                 <input type="hidden" name="pName" value="<%=(request.getParameter("pName") != null ? request.getParameter("pName"): "")%>" />

                            <table id="loginpopupformtable" width="100%" border="0" cellspacing="0" cellpadding="0">
                               <tr>
                                  <td> 
                                        Email Address*&nbsp;&nbsp; 
					</td>
					<td width="70%">
						<input class="inputitem loginpopupemail" type="text" name="emailaddress" value="<%=request.getAttribute("emailaddress")!=null?request.getAttribute("emailaddress"):""%>">
                                  </td>
				   </tr>
				   <tr>
                                  <td>
                                        Password*
                                  </td> 
					<td>
						<input class="inputitem loginpopuppassword" type="password" name="password" value=''>
                                  </td> 
                               </tr> 
                            </table> 
			<div class="loginpopupfooter">
				<div class="loginpopupforgot">    
					<a href="javascript: document.logindetails.action.value='forgot'; document.logindetails.submit();" class="trail">Forgotten your password?</a> 
				</div>
				<div class="loginpopupsubmit"> 
					<input type="image" src="<%=website.getImagePath("login-large.gif")%>" name="submit1" alt="Login" title="Login" class="btnloginpopup" />
				</div> 	 
			</div> 	 
              </form>
		</div>
              <script language="javascript"><!--
                  document.logindetails.emailaddress.focus();
              //--></script>
	   </td>
	</tr>
</table>
</td></tr>
</table>
</span>
</body>
</html>
<!-- end of components/loginpopup.jsp -->