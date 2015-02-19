<!-- start of thankyou.jsp --> 
<%@page import="java.io.*"%>
<jsp:useBean id="website"  scope="application" class="co.simplypos.model.website.WebSite" />
<jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession" />
<div class="thankyou">
<%
String validationString = "";
String action = request.getParameter("action");
String src = request.getParameter("src");

String emailAddress = request.getParameter("email");
String confEmailAddress = request.getParameter("confemail");
String name = request.getParameter("name");

if (emailAddress == null) emailAddress = "";
if (confEmailAddress == null) confEmailAddress = "";
if (name == null) name = request.getParameter("ch");
if (name == null) name = "";

if (action == null) action = "";
if (src == null) src = "";

//out.write("<br />amount: "+userSession.getThankYouPageAttribs().getAuthorisedAmount());
//out.write("<br />pPtrans: "+userSession.getThankYouPageAttribs().getPpTransId());
//out.write("<br />getQuickpayEmailAddress: "+userSession.getThankYouPageAttribs().getQuickpayEmailAddress());

if (action.equals("reg")) {
	if (emailAddress.indexOf('@') < 1) validationString = "Please enter a valid email address"; 
	if (!confEmailAddress.equals(emailAddress)) validationString = "You have entered two different email addressed. Please re-enter a valid email address and confirm it by retyping it into the Confirm Email Address box.";
	if (!validationString.equals("")) {
		action = "";
		src= "qp";
	}
}
if (!validationString.equals("")) { 
%>
	<table cellspacing="0" cellpadding="10" width="100%"><tr><td>
	   <table cellpadding="2" cellspacing="0" border="0" align="left" style="margin:50px;" class="errorpanel">
	     <tr>
			<td valign="top">
				<img src="<%=website.getImagePath("icon_error.gif")%>">&nbsp;
			</td>
			<td valign="top" align="left" class="error">
				<%=validationString%>
			</td>
		</tr>
	   </table>
	</td></tr></table>
<%
}

if (action.equals("info")) {
	//out.write("ms:"+""+request.getParameter("marketingsource")+"      optin:"+request.getParameter("optin"));
	userSession.updateRegistrationInfo(request, userSession.getLoggedInCustomerId(), ""+request.getParameter("telephone"),""+request.getParameter("gender"),""+request.getParameter("dob1"),""+request.getParameter("dob2"),""+request.getParameter("dob3"),""+request.getParameter("marketingsource"),""+request.getParameter("optin"));
%>
	<jsp:include page="quickregistrationsuccess.html" />	
<%
} else if (action.equals("reg")) {
	userSession.updateRegistrationDetails(request, userSession.getLoggedInCustomerId(),""+request.getParameter("name"),""+request.getParameter("email"), true);
%>
	<jsp:include page="quickregistration.html" />

<table cellspacing="0" cellpadding="10" width="550" align="center">
  <tr>
    <td>
     <table id="quickpayform" cellspacing="8" cellpadding="0" align="center" class="quickpayhighlight" width="90%">
	<tr valign="top">
		<td colspan="2">
			<div id="quickpayheader">
				<div id="bestserviceheader" class="quickpayheader">
					<img  class="noBorder quickpayheaderImg" src="<%=website.getImagePath("star.png")%>" alt="" />
					<span class="quickpayheader quickpayheadertext">Help us to give you the very best service</span>
				</div>
				<div id="quickpayheadersubtext">
					<div style="margin-left:10px;">Giving this brief information will help us to offer a more personalised service to suit you.</div>
				</div>
			</div>
		</td>
	</tr>	
	<tr>
		<td colspan="2">
			<form name="infoform" action="host.jsp?pg=thankyou.jsp&action=info" method="get">
				<input class='inputitem' type='hidden' name='pg' value='thankyou.jsp' />

				<input class='inputitem' type='hidden' name='action' value='info' />

				<div class="quickcheckout">				
			 	   <table cellpadding="2" cellspacing="0" border="0" >
					<tr>
						<td >
							Contact Telephone:&nbsp;
						</td><td>
							<input id="infotelephone" class="inputitem" type="text" name="telephone" value="" />
						</td>
					</tr>
					<tr>
						<td>
							Gender
						</td><td>
							<div id="gender">
								&nbsp;&nbsp;<input type='radio' checked name='gender' value='m' />Male&nbsp;&nbsp;
								<input type='radio' name='gender' value='f' />Female
							</div>
						</td>
					</tr>
				<% 	if (website.isShowDOB()) { %>
						<tr>
							<td>
				        			<div id="dobTitle">
									Date of Birth:&nbsp;
								</div>
							</td><td>
								<div id="dob">
									<input class='inputitem' type='text' name='dob1' maxlength='2' size='2' style='width:20;' value='' />
									<input class='inputitem' type='text' name='dob2' maxlength='2' size='2' style='width:20;' value='' />
									<input class='inputitem' type='text' name='dob3' maxlength='4' size='4' style='width:40;' value='' /> (dd/mm/yyyy)
								</div>
							</td>
						</tr>
				<%    } %>
					<tr>
						<td>
							Where did you hear about us:
						</td><td>
							<select class='inputitem' name='marketingsource' value=''><option value=''>[please choose]<%=userSession.getWebSite().getMarketingSourceList(25, "")%>
						</td>
					</tr>
					<tr>
						<td>
							<img src="<%=website.getImagePath("spacer.gif")%>" width="100" height="1">
						</td><td width="100%">
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<input type='checkbox' checked name='optin' value='1' />&nbsp;&nbsp;We send out occasional information about our products and services. Tick the box if you wish to receive this information.
						</td>
					</tr>						
					<tr>
						<td colspan="2">
							<div class="quickcheckoutactionbutton"><input type="image" src="<%=website.getImagePath("update-large.gif")%>" alt="Register" /></div>
						</td>
					</tr>
				   </table>				
				</div>
			</form>
		</td>
	  </tr>
	</table>
    </td>
  </tr>
</table>

<script type='text/javascript'><!--
	document.getElementById("infotelephone").focus();
//--></script>


<%
} else {
	
	if (validationString.equals("")) {
%>

<jsp:include page="thankyou.html" />
<% File linksFile = new File(website.getWebSitePath(),"socialLinks.html");
if( linksFile.exists() ){ %>
	<div class="tyPgLinks">
		<jsp:include page="socialLinks.html" />
	</div>
<% } %>


<%
	}
String orderTotal = request.getParameter("ot");
String orderRef = request.getParameter("ref");

if (src.equals("qp") && !userSession.hasCustomerRegistered()) { //(userSession.getLoggedInCustomerEmailAddress() == null || userSession.getLoggedInCustomerEmailAddress().equals("null") || userSession.getLoggedInCustomerEmailAddress().equals(""))) {
%>
<table cellspacing="0" cellpadding="10" width="550" align="center">
  <tr>
    <td align="center">
       <table id="quickpayform" cellspacing="8" cellpadding="0" width="90%">
	<tr valign="top">
		<td>
			<div class="quickpayhighlight"> 
				<div id="quickpayheader">
					<div id="registrationbenefitsheader" class="quickpayheader">
						<img  class="noBorder quickpayheaderImg" src="<%=website.getImagePath("star.png")%>" alt="" />
						<span class="quickpayheader quickpayheadertext">Now you can enjoy the benefits of registration</span>
					</div>
					<div id="quickpayheadersubtext">
						<div style="margin-left:10px;">By simply giving your email address below, you can now register with us</div>
						<div style="margin-left:10px;">and enjoy these benefits: </div>
					</div>
				</div>
	
				<ul>
					<li>Receive email order confirmation</li>
					<li>Track your order online</li>
					<li>Easier ordering next time</li>
					<li>Review your order history</li>
					<li>Repeat previous orders</li>
					<li>Continuation of incomplete orders</li>
					<br /><br /><div id="quickpayheadersubtext"><i>...and we can contact you regarding this order if needed!</i></div>
				</ul>
				<br />
				</p>
				<form name="emailform" action="host.jsp?pg=thankyou.jsp&action=reg" method="post">
					<div class="quickcheckout">
						<table align="center" cellpadding="0" cellspacing="0" border="0" width="80%">
							<tr><td align="right">Name:</td><td><input type="text" name="name" size="30" value="<%=name%>" /></td></tr>
							<tr><td align="right">Email Address:</td><td><input type="text" name="email" size="30" value="<%=emailAddress%>" /></td></tr>
							<tr><td align="right">Confirm Email Address:</td><td><input  type="text" name="confemail" size="30" value="<%=confEmailAddress%>" /></td></tr>
							<tr><td colspan="2"></td></tr>
						</table>
						<div class="quickcheckoutactionbutton"><input type="image" src="<%=website.getImagePath("register-large.gif")%>" border="0" alt="Register" /></div>
					</div>
					
				</form>
			</div>
		</td>
	 </tr>

	</table>
    </td>
  </tr>
</table>

<script type='text/javascript'><!--
	document.emailform.email.focus();
//--></script>

<% } %>
<%@include file="analyticsconversion.html"%>
<% } %>
</div>


<!-- end of thankyou.jsp -->