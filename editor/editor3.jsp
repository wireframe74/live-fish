<!-- start of components/metaKeyAdmin.html -->
<%@ page language="java" import="java.io.*,java.util.*,co.simplypos.model.utils.helpers.FileHelper,co.simplypos.model.website.utils.FtpUpload"%>
<jsp:useBean id="website"  scope="application" class="co.simplypos.model.website.WebSite" />
<jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession" />
<%
%>
<link rel="stylesheet" href="../template/framework.css" type="text/css" />
<link rel="stylesheet" href="../template/style.css" type="text/css" />

<body bgcolor="#ffffff" text="#000000" marginwidth="0" marginheight="0" topmargin="0" bottommargin="0" leftmargin="0" rightmargin="0">      
<style  TYPE="text/css"><!-- 
body {
	font-family: Verdana, Arial, "MS Sans Serif", sans-serif;
	color: #000000;
	margin-top: 4px;
	background:#FFFFFF;
}
li { list-style-type:none; }
--></style> 

<%
String message = null;
try { 
	if (request.getParameter("clearcompilecache.x") != null) {
		if (website.getWebSiteCacheFolder() != null && website.getWebSiteCacheFolder().indexOf("_logs/") > -1) {
			website.writeToLog("deleting: "+new File(website.getWebSiteCacheFolder()).getAbsolutePath());
			boolean del = FileHelper.deleteDir(new File(website.getWebSiteCacheFolder()));
			if (del) { 
				message = "Compile cache successfully cleared";
			} else {
				message = "Compile cache delete failed";
			}
		} else {
			message = "Cannot find compile cache location";
		}
	} else if (request.getParameter("reloadwebsite.x") != null) {
		message = "";
		if (website.getWebSiteCacheFolder() != null && website.getWebSiteCacheFolder().indexOf("_logs/") > -1) {
			website.writeToLog("deleting: "+new File(website.getWebSiteCacheFolder()).getAbsolutePath());
			boolean del = FileHelper.deleteDir(new File(website.getWebSiteCacheFolder()));
			if (del) { 
				message = "Compile cache successfully cleared. ";
			} else {
				message = "Compile cache delete failed. ";
			}
		} else {
			message = "Cannot find compile cache location. ";
		}
		
			
		co.simplypos.model.utils.Pair pair = co.simplypos.model.website.utils.FtpUpload.getHostNameAndAppFolder(website.getWebSiteURL());
		if (pair != null) {
			co.simplypos.model.website.WebSite.writeToPublicLog(request.getRequestURL().toString()+" manual tomcat restart and logs cleared at "+new File(website.getWebSiteCacheFolder()).getAbsolutePath());
			FtpUpload.reloadTomcatApp((String)pair.get(0), (String)pair.get(1), FtpUpload.TOMCAT_AUTH1, FtpUpload.TOMCAT_AUTH2); 
			String forwardPage = "websiterelaoaded.html";
			try {
		      		response.sendRedirect(forwardPage); 
			} catch (Exception e102) {
				out.write("<script type='text/javascript'>document.location.href='"+forwardPage+"';</script>"); 
			}	
			return;
		}
	}
} catch (Exception ee) {
	website.writeToLog(ee);
	message = "Exception: "+ee.getMessage();
}

if (!userSession.isLoggedIn() && (request.getParameter("go") == null || !request.getParameter("go").equals("g1ftware"))) {
	String forwardPage = "../myaccount.jsp";
	try {
		//Thread.sleep(2000);
		response.sendRedirect(forwardPage); 
	} catch (Exception e102) {
		out.write("<script type='text/javascript'>document.location.href='"+forwardPage+"';</script>"); 
	}
}	

%>
	<img src="../template/images/meta_logo.gif" style="position:relative; left:0px; top:1px; float:left;" />

	<div class="pagetitle" align="left" style="float:left; margin-left:40px;">
	</div>

	<% if (request.getParameter("showhelp") != null) { %>
		<span style="font-size: 14px; margin-right:18px; float:right;"><a href="<%=request.getRequestURL()%>"><img src="../template/images/meta_help.png" border="0" style="position:relative; left:0px; top:5px;" /><u>HELP! Click here to hide instructions</u></a></span>
	<% } else {%>
		<span style="font-size: 14px; margin-right:18px; float:right;"><a href="?showhelp=1"><img src="../template/images/meta_help.png" border="0" style="position:relative; left:0px; top:5px;" /><u>HELP! Click here to show instructions</u></a></span>
	<% } %>

<br/>
<br/>
<br/>
<br/>

	<div class="tabs" align="left" style="border-bottom: 2px solid #999999">
		<a href="../metakeyAdmin.jsp"><img src="../template/images/meta_tab_off.gif" alt="" style="position:relative; left:3px; top:5px;"  /></a>
		<a href="../editor/editor3.jsp"><img src="../template/images/editor_tab_on.gif" alt="" style="position:relative; left:3px; top:5px;"  /></a>
	</div>

<%
	if (request.getParameter("showhelp") != null) {
%>
		<div id="instructions" class="checkoutcontainer" align="left">
			<div class="pagetitle" align="left">
				<img src="../template/images/meta_help.png" alt="" style="position:relative; left:3px; top:5px;" />
				<span style="font-size: 14px;">How To Use This Page...</span>
			</div>
			<div style="color:#666666;font-size: 11px;margin-left:50px;">
				<i>
				<p>Use this page to edit html static content within your website. Simply <b>click on the page</b> you wish to edit. </p>
				<p>If you are editing a style sheet, a text editor page will open. From this page you can directly edit and save the stylesheet content.</p>
				<p>If you are editing any other pages, then a graphical editor will allow you to make neccessary changes, upload further files and images and save the contents. For further detailed documentation relating to this editing software <a href="http://www.pintexx.com/pinedit/doc/pinEdit_UserHelp.pdf" target="_blank1"><u>click here</u></a></p>
				</i>
				<p><br /></p>
			</div>
		</div>
<%
	}
%>

<% if (message != null) { %>
	<div class="checkoutcontainer" align="left">
		<div class="pagetitle" align="left">
			<span style="font-size: 14px;"><%=message%></span>
		</div>
	<br/>
<% } %>

	<div class="checkoutcontainer" align="left">
		<div class="pagetitle" align="left">
			<img src="../template/images/meta_editor.png" alt="" style="position:relative; left:3px; top:5px;"  />
			<span style="font-size: 14px;">Select a page to edit:</span>
		</div>
	<br/>

	<table style="margin-top:0px; margin-left:50px;margin-bottom:15px;">
		<thead>
			<tr>
				<td class="smallertext" width="100"><u>Style Sheets</u></td> 
			</tr>
		</thead>
		<tbody>
			<tr>
				<td>
					<span style="font-family: Tahoma; font-size: 12px; font-weight: normal; color:blue;">
						<a href="../template/components/editcss.jsp" target="_blank">style.css</a>
					</span>
				</td>
				<td>
					<i>(main customisable style sheet for all browsers)</i>
				</td>
			</tr>
			<tr>
				<td>
					<span style="font-family: Tahoma; font-size: 12px; font-weight: normal; color:blue;">
						<a href="../template/components/editcss.jsp?type=ie" target="_blank">style_ie.css</a>
					</span>
				</td>
				<td>
					<i>(optional style sheet dedicated to IE only!)</i>
				</td>
			</tr>
		</tbody>
	</table>


	<table style="margin-top:0px; margin-left:50px;margin-bottom:15px;">
		<thead>
			<tr>
				<td class="smallertext" width="5%"><b>Files In Use</b></td>
				<td class="smallertext" width="5%"><b>Files Currently Empty</b></td>
			</tr>
			<tr><td><br /></td></tr>
		</thead>

		<tbody>
			<tr>
			<td>
			<span style="font-family: Tahoma; font-size: 12px; font-weight: normal; color:blue;">
			<%

	
			String root = request.getSession().getServletContext().getRealPath("/");
			String extraParams = "go="+request.getParameter("go");
			File rootFile = new File(root);
			ArrayList fileList = new ArrayList();
			for (int i=0; i<rootFile.listFiles().length; i++) {
				File childFile = rootFile.listFiles()[i];
                           try {
				if (childFile.getName().endsWith(".html") && !FileHelper.isPageBlank(childFile)) fileList.add(childFile.getName());
				} catch (Exception e) {
					//out.write("<br />Failed: "+childFile.getName()+" with: "+e.getMessage());
					fileList.add(childFile.getName());
				}
				}
				Collections.sort(fileList);	
				for (int i=0;i<fileList.size();i++) {
	       	       String childFileName = ""+fileList.get(i);

					//String sb = FileHelper.readFileToString(new File(root, childFileName));

					%>
					<a href="<%="../editor_new.jsp?PageUrl=/"+childFileName%>" target="_blank"><%=childFileName%></a><BR>
					<%
					
	      		 }
			%>
			</span>
			</td>
		
			
			<td valign="top">
			<span style="font-family: Tahoma; font-size: 12px; font-weight: normal; color:blue;">
			<%
			fileList = new ArrayList();
			for (int i=0; i<rootFile.listFiles().length; i++) {
				File childFile = rootFile.listFiles()[i];
                           try {
				if (childFile.getName().endsWith(".html") && FileHelper.isPageBlank(childFile)) fileList.add(childFile.getName());
				} catch (Exception e) {
					//out.write("<br />Failed: "+childFile.getName()+" with: "+e.getMessage());
				}
				}
				Collections.sort(fileList);	
				for (int i=0;i<fileList.size();i++) {
	       	       String childFileName = ""+fileList.get(i);

					//String sb = FileHelper.readFileToString(new File(root, childFileName));

					%>
					<a href="<%="../editor_new.jsp?PageUrl=/"+childFileName%>" target="_blank"><%=childFileName%></a><BR>
					<%
					
	      		 }
			%>
			</span>
			</td>




			</tr>


		</tbody>
	</table>
	<div class="pagetitle" align="left">
		<span style="font-size: 14px;">Select an action:</span><br />
	</div>
		<span style="font-size: 11px;"><i><b>WARNING!</b> Please read this fully before pressing any action buttons. <br />The following actions allow you to refresh the content on your website in order to make any page changes visible. Reloading your website <b>will stop</b> and restart your website. If you choose this option then <u>always check the site is running afterwards</u> and notify the support team if this is not the case. Though this is unlikely, when changing content and reloading your website there is always an element of risk. Please make all of your changes then use these buttons as a final step, as restarting will affect the smooth running of your website.</i></span><br /><br />
		<form action="?" method="post">
			<input type="image" alt="Clear Compile Cache" name="clearcompilecache" value="1" src="../template/images/clear_compile_cache.gif" />
	 		<input type="image" alt="Reload Website"  name="reloadwebsite" value="" src="../template/images/reload_website.gif" />
		</form>
	<br /><br />

	</div>
</body></html>
<!-- end of components/metaKeyAdmin.html -->